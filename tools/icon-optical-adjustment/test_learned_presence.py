"""Focused contracts for the self-contained visual presence leaf and setup."""

import hashlib
import io
import json
import math
import tempfile
import unittest
from pathlib import Path
from unittest import mock

import learned_presence as presence
import numpy as np
import prepare_optical_model as preparation


def readout_data():
    return dict(
        input_reference_features=np.zeros(8),
        input_feature_standard_deviations=np.ones(8),
        reference_features=np.zeros(164),
        feature_standard_deviations=np.ones(164),
        coefficients=np.r_[np.zeros(3), 100.0, np.zeros(160)],
        bound=math.log(1.2),
        dense_ink_start=0.6,
    )


class LearnedPresenceTests(unittest.TestCase):
    def test_package_versions_accept_exact_pins_and_official_torch_cpu_builds(self):
        for package, expected in presence.read_model()["packages"].items():
            versions = (
                (expected, f"{expected}+cpu")
                if package in ("torch", "torchvision")
                else (expected,)
            )
            for actual in versions:
                with self.subTest(package=package, actual=actual):
                    with mock.patch.object(
                        presence.importlib.metadata, "version", return_value=actual
                    ):
                        presence.require_packages(dict(packages={package: expected}))

    def test_package_versions_reject_other_releases_and_local_builds(self):
        for package, expected in presence.read_model()["packages"].items():
            versions = ("0.0.0", f"{expected}+cu130", f"{expected}+custom", f"{expected}+cpu.extra")
            if package not in ("torch", "torchvision"):
                versions += (f"{expected}+cpu",)
            for actual in versions:
                with self.subTest(package=package, actual=actual):
                    with mock.patch.object(
                        presence.importlib.metadata, "version", return_value=actual
                    ):
                        with self.assertRaisesRegex(presence.ModelSetupError, "requires"):
                            presence.require_packages(dict(packages={package: expected}))

    def test_model_cannot_move_its_fixed_disk_reference(self):
        data = presence.read_model()
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "model.json"
            data["input_reference_features"][3] = 0.001
            path.write_text(json.dumps(data))
            with self.assertRaisesRegex(ValueError, "disk-reference log ratios"):
                presence.read_model(path)

    def test_validated_runtime_disk_defines_the_learned_ratios(self):
        stored = np.asarray(presence.read_model()["reference_layer_means"])
        observed = stored * (1 + 5e-7)
        with mock.patch.object(presence.LearnedPresence, "layer_means", return_value=observed):
            model = presence.LearnedPresence()
            np.testing.assert_array_equal(model._reference, observed)
            measurement = mock.Mock(
                features=dict(
                    unoccupied_fraction=0,
                    diameter=1,
                    axis_extent=1,
                    filled_area=1,
                    ink_area=1,
                    peak_alpha=1,
                )
            )
            raw = model.raw_features(presence.REFERENCE_SOURCE, measurement)
            np.testing.assert_array_equal(raw[3:], np.zeros(5))
        with mock.patch.object(presence.LearnedPresence, "layer_means", return_value=stored * 1.01):
            with self.assertRaisesRegex(presence.ModelSetupError, "Fresh disk inference differs"):
                presence.LearnedPresence()

    def test_complete_square_symmetry_orbit_is_closed_under_every_member(self):
        class ArrayOperations:
            @staticmethod
            def rot90(value, turns, dims):
                return np.rot90(value, turns, axes=dims)

            @staticmethod
            def flip(value, dims):
                return np.flip(value, axis=dims)

        original = np.arange(25).reshape(1, 1, 5, 5)
        orbit = {
            presence._orient(original, turns, reflected, ArrayOperations).tobytes()
            for turns, reflected in presence.SYMMETRIES
        }
        self.assertEqual(len(orbit), 8)
        for turns, reflected in presence.SYMMETRIES:
            transformed = presence._orient(original, turns, reflected, ArrayOperations)
            actual = {
                presence._orient(transformed, k, flip, ArrayOperations).tobytes()
                for k, flip in presence.SYMMETRIES
            }
            self.assertEqual(actual, orbit)

    def test_integrated_bounds_are_continuous_and_peak_relative(self):
        for faintness in (0.001, 0.01, 0.2):
            alpha = np.zeros((5, 10))
            alpha[1:4, 4:8], alpha[2, 0] = 1.0, faintness
            expected = [4 - 4 * faintness, 1.0, 8.0, 4.0]
            np.testing.assert_allclose(presence.integrated_bounds(alpha, 1), expected, atol=1e-14)
            np.testing.assert_allclose(
                presence.integrated_bounds(alpha * 0.3, 1), expected, atol=1e-14
            )

    def test_enclosure_gate_bounds_both_correction_directions(self):
        data = readout_data()
        for direction in (-1.0, 1.0):
            raw = np.zeros(8)
            raw[0], raw[2], raw[3] = 0.5, math.log(4), direction
            self.assertAlmostEqual(presence.readout(raw, data), direction * math.log(1.2) / 4)
            raw[2] = -0.1
            self.assertAlmostEqual(presence.readout(raw, data), direction * math.log(1.2))
        self.assertEqual(presence.readout(np.zeros(8), data), 0.0)

    def test_dense_silhouettes_lose_enlargement_without_losing_size_reduction(self):
        data = readout_data()
        data["input_reference_features"][0] = 0.21444619332107762
        reference_ink = 1 - data["input_reference_features"][0]
        start = data["dense_ink_start"]
        fractions = (0.2, start, (start + reference_ink) / 2, reference_ink, 1.0)
        for fraction, remaining in zip(fractions, (1, 1, 0.5, 0, 0), strict=True):
            raw = np.zeros(8)
            raw[0], raw[3] = 1 - fraction, -1
            with self.subTest(ink_fraction=fraction):
                self.assertAlmostEqual(presence.readout(raw, data), -data["bound"] * remaining)
                raw[3] = 1
                self.assertAlmostEqual(presence.readout(raw, data), data["bound"])

    def test_dense_ink_transition_has_no_jump_at_either_boundary(self):
        data = readout_data()
        for boundary in (data["dense_ink_start"], 1.0):
            corrections = []
            for fraction in (boundary - 1e-6, boundary, boundary + 1e-6):
                raw = np.zeros(8)
                raw[0], raw[3] = 1 - fraction, -1
                corrections.append(presence.readout(raw, data))
            self.assertLess(max(corrections) - min(corrections), 1e-10)

    def test_hollow_shapes_use_actual_ink_instead_of_filled_enclosure(self):
        data = readout_data()
        raw = np.zeros(8)
        raw[0], raw[2], raw[3] = 0.05, math.log(5), -1
        self.assertAlmostEqual(presence.readout(raw, data), -data["bound"] / 5)

    def test_model_rejects_invalid_dense_ink_transition(self):
        data = presence.read_model()
        reference_ink = 1 - data["input_reference_features"][0]
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "model.json"
            for start in (-1, reference_ink, 1, math.inf, math.nan, True):
                with self.subTest(start=start):
                    data["dense_ink_start"] = start
                    path.write_text(json.dumps(data))
                    with self.assertRaisesRegex(ValueError, "Dense ink transition"):
                        presence.read_model(path)

    def test_complete_cubic_expansion_preserves_the_polynomial_kernel(self):
        random = np.random.default_rng(164)
        reference, units = random.normal(size=8), np.arange(1, 9) / 4
        for _ in range(12):
            x, y = random.normal(size=(2, 8))
            a = presence.expand(reference + units * x, reference, units)
            b = presence.expand(reference + units * y, reference, units)
            dot = float(x @ y)
            self.assertAlmostEqual(float(a @ b), dot + dot**2 + dot**3, places=10)
            self.assertAlmostEqual(float(a[:44] @ b[:44]), dot + dot**2, places=11)
        self.assertEqual(len(presence.FEATURE_NAMES), 164)
        np.testing.assert_array_equal(presence.expand(reference, reference, units), np.zeros(164))

    def test_model_rejects_obsolete_mappings_and_gates(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "model.json"
            for changes in (
                dict(polynomial_degree=2, feature_mapping="complete-quadratic"),
                dict(correction_gate="none"),
            ):
                with self.subTest(changes=changes):
                    data = presence.read_model()
                    data.update(changes)
                    path.write_text(json.dumps(data))
                    with self.assertRaises(ValueError):
                        presence.read_model(path)

    def test_model_rejects_invalid_output_dimensions(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "model.json"
            for label in ("reference_diameter", "max_extent"):
                for value in (0, -1, math.nan, math.inf, True, "18"):
                    with self.subTest(label=label, value=value):
                        data = presence.read_model()
                        data[label] = value
                        path.write_text(json.dumps(data))
                        with self.assertRaisesRegex(ValueError, "positive and finite"):
                            presence.read_model(path)
            for dimensions in ((19, 18), (15.5, 21)):
                data = presence.read_model()
                data["reference_diameter"], data["max_extent"] = dimensions
                path.write_text(json.dumps(data))
                with self.assertRaisesRegex(ValueError, "must fit"):
                    presence.read_model(path)

    def test_model_rejects_missing_fields_and_invalid_weight_sizes(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "model.json"
            for field in (
                "canonical_context",
                "coefficients",
                "reference_diameter",
                "polynomial_degree",
            ):
                with self.subTest(field=field):
                    data = presence.read_model()
                    del data[field]
                    path.write_text(json.dumps(data))
                    with self.assertRaisesRegex(ValueError, "Missing or invalid icon model field"):
                        presence.read_model(path)
            for value in (0, -1, 6.5, True):
                with self.subTest(byte_count=value):
                    data = presence.read_model()
                    data["weights"]["backbone"]["bytes"] = value
                    path.write_text(json.dumps(data))
                    with self.assertRaisesRegex(ValueError, "positive integers"):
                        presence.read_model(path)

    def test_model_rejects_omitted_or_reordered_polynomial_terms(self):
        data = presence.read_model()
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "model.json"
            data["feature_names"][0], data["feature_names"][1] = (
                data["feature_names"][1],
                data["feature_names"][0],
            )
            path.write_text(json.dumps(data))
            with self.assertRaisesRegex(ValueError, "fixed order"):
                presence.read_model(path)
            data["feature_names"].pop()
            path.write_text(json.dumps(data))
            with self.assertRaisesRegex(ValueError, "fixed order"):
                presence.read_model(path)

    def test_fixed_render_window_clips_distant_faint_detail_without_failure(self):
        source = (
            '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 20 20">'
            '<rect x="4" y="8" width="2" height="4"/>'
            '<rect x="18" y="9" width="1" height="1" opacity="0.01"/></svg>'
        )
        button, blank = presence.rendered_button(source, 1.0)
        self.assertEqual(button.shape, (96, 96))
        self.assertTrue(np.isfinite(button).all())
        self.assertGreater(np.count_nonzero(button < blank), 0)
        self.assertTrue(np.all(button <= blank))
        self.assertTrue(np.all(blank[:1, :1] == 1))

    def test_fixed_sampling_context_and_invalid_features_fail_explicitly(self):
        with self.assertRaisesRegex(ValueError, "32"):
            presence.rendered_button(presence.REFERENCE_SOURCE, 1.0, pixels_per_unit=16)
        with self.assertRaises(ValueError):
            presence.expand(np.zeros(8), np.zeros(8), np.zeros(8))
        with self.assertRaises(ValueError):
            presence.integrated_bounds(np.zeros((3, 3)), 1)
        with self.assertRaises(ValueError):
            presence.readout(np.full(8, math.nan), readout_data())

    def test_atomic_setup_rejects_bad_bytes_without_replacing_existing_file(self):
        with tempfile.TemporaryDirectory() as directory:
            target = Path(directory) / "model.pth"
            target.write_bytes(b"previous")
            expected = dict(bytes=4, sha256=hashlib.sha256(b"good").hexdigest())
            with self.assertRaises(presence.ModelSetupError):
                preparation._install_stream(io.BytesIO(b"nope"), target, expected)
            self.assertEqual(target.read_bytes(), b"previous")
            self.assertEqual(list(Path(directory).iterdir()), [target])
            preparation._install_stream(io.BytesIO(b"good"), target, expected)
            self.assertEqual(target.read_bytes(), b"good")

    def test_verified_cache_setup_does_not_use_network(self):
        with tempfile.TemporaryDirectory() as directory:
            weights = {}
            for label in ("backbone", "calibration"):
                raw = label.encode()
                filename = label + ".pth"
                (Path(directory) / filename).write_bytes(raw)
                weights[label] = dict(
                    filename=filename, bytes=len(raw), sha256=hashlib.sha256(raw).hexdigest()
                )
            with (
                mock.patch.object(presence, "read_model", return_value=dict(weights=weights)),
                mock.patch.object(presence, "require_packages"),
                mock.patch.object(
                    preparation.urllib.request,
                    "urlopen",
                    side_effect=AssertionError("Unexpected download"),
                ),
            ):
                paths = preparation.prepare(cache_dir=directory)
            self.assertEqual(set(paths), {"backbone", "calibration"})

    def test_missing_or_modified_weights_fail_before_network_construction(self):
        data = dict(weights={"backbone": dict(filename="backbone.pth", sha256="0" * 64)})
        with tempfile.TemporaryDirectory() as directory:
            with (
                mock.patch.object(presence, "read_model", return_value=data),
                mock.patch.object(presence, "require_packages"),
            ):
                with self.assertRaisesRegex(presence.ModelSetupError, "prepare_optical_model"):
                    presence.LearnedPresence(cache_dir=directory)
                (Path(directory) / "backbone.pth").write_bytes(b"changed")
                with self.assertRaisesRegex(presence.ModelSetupError, "prepare_optical_model"):
                    presence.LearnedPresence(cache_dir=directory)


if __name__ == "__main__":
    unittest.main()
