"""Offline calibration validation and reproducible runtime requirements."""

import importlib.metadata
import json
import math
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

import optical_model as model


class ModelTests(unittest.TestCase):
    def test_model_contains_only_the_geometry_runtime(self):
        data = model.read_model()
        self.assertEqual(set(data["packages"]), {"numpy", "scipy", "Pillow", "resvg-py", "scikit-image"})
        model.require_packages(data)

    def test_missing_or_different_runtime_is_explicit(self):
        for value in ("0.0.0", importlib.metadata.PackageNotFoundError("missing")):
            with self.subTest(value=value):
                kwargs = {"side_effect": value} if isinstance(value, Exception) else {"return_value": value}
                with patch.object(model.importlib.metadata, "version", **kwargs):
                    with self.assertRaisesRegex(model.ModelSetupError, "requires"):
                        model.require_packages(model.read_model())

    def test_nonfinite_and_invalid_calibration_fails_before_generation(self):
        for name, values in {
            "reference_diameter": (0, 21, True, math.inf),
            "max_extent": (0, 14, 21, math.nan),
            "body_area_weight": (-1, 2, True, math.nan),
            "body_evidence_gain": (0, -1, True, math.inf),
            "placement_weight": (-1, 2, True, math.nan),
            "placement_max_offset": (0, 3, True, math.inf),
            "pixels_per_unit": (16, 64),
            "analysis_pixels_per_unit": (0, 16),
            "closure_sigmas": ([], [1, 1], [math.nan], [True]),
            "display_sizes": ([], [24, 16], [0], ["20"]),
            "compact_body_concentration_range": ([], [0.5], [0.8, 0.5], [0, 2], [True, 1]),
            "compact_body_aspect_range": ([0.5, 0.5], [math.nan, 1]),
            "broad_body_concentration_rise": ([], [0.7, 0.5], [0.5, 0.8]),
            "broad_body_concentration_fall": ([0.6, 0.9], [True, 1], [0.8, math.inf]),
            "detached_ink_range": ([-1, 0.1], [0.2, 0.1], [0, math.nan]),
            "broad_body_max_enlargement": (0.9, 2.1, True, math.inf),
            "appearance_weight": (-.1, 1.1, True, math.nan),
            "appearance_max_enlargement": (.9, 2.1, True, math.inf),
            "appearance_channel_weights": (
                [], [.5, .5], [1, 0, 0], [-.1, .6, .5], [.2, .7, .2],
                [True, .5, .5], [math.nan, .5, .5], [math.inf, .5, .5],
            ),
            "appearance_levels": (0, 32, 256, True, math.nan),
            "appearance_contrast_range": ([], [.1], [.1, .1], [-.1, .2], [0, 1.1], [math.nan, 1]),
            "appearance_saturation_range": ([], [.95, .75], [True, 1], [0, math.inf]),
        }.items():
            for value in values:
                with self.subTest(name=name, value=value), tempfile.TemporaryDirectory() as temporary:
                    data = model.read_model()
                    data[name] = value
                    path = Path(temporary) / "model.json"
                    path.write_text(json.dumps(data))
                    with self.assertRaises(ValueError):
                        model.read_model(path)

    def test_missing_calibration_is_rejected(self):
        for name in (
            "body_area_weight", "reference_diameter", "packages", "appearance_weight",
            "appearance_max_enlargement", "appearance_channel_weights", "appearance_levels",
            "appearance_contrast_range", "appearance_saturation_range",
        ):
            with self.subTest(missing=name), tempfile.TemporaryDirectory() as temporary:
                data = model.read_model()
                del data[name]
                path = Path(temporary) / "model.json"
                path.write_text(json.dumps(data))
                with self.assertRaisesRegex(ValueError, "Missing or invalid"):
                    model.read_model(path)

    def test_unsupported_model_schema_is_rejected(self):
        with tempfile.TemporaryDirectory() as temporary:
            data = model.read_model()
            data["schema"] = "mateo.icon-presence-model.v1"
            path = Path(temporary) / "model.json"
            path.write_text(json.dumps(data))
            with self.assertRaisesRegex(ValueError, "Unsupported"):
                model.read_model(path)


if __name__ == "__main__":
    unittest.main()
