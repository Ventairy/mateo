"""Regression checks for validation context fidelity, independent of model tuning."""

import tempfile
import subprocess
import sys
import unittest
from pathlib import Path

from adjust_icon_sizes import adjust_icon_size, reference_target
from validate_icon_sizes import audit, display_samples

SOURCE = '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 20 20"><circle cx="10" cy="10" r="7"/></svg>'


class ValidationTests(unittest.TestCase):
    def test_actual_28px_product_size_is_included_at_every_density(self):
        contexts = display_samples(SOURCE)
        for density in (1, 2, 3):
            self.assertIn(f"28px@{density}x", contexts)

    def test_catalog_renderer_accepts_the_28px_product_size(self):
        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary)
            inputs, output = directory / "input", directory / "preview"
            inputs.mkdir()
            (inputs / "circle.svg").write_text(SOURCE)
            result = subprocess.run(
                [sys.executable, str(Path(__file__).with_name("render_icon_sizes.py")),
                 "--input", str(inputs), "--output-dir", str(output), "--size", "28"],
                capture_output=True, text=True,
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertTrue(list(output.glob("*.png")))

    def test_standalone_root_offsets_stay_inactive_when_rendering_contexts(self):
        offset = SOURCE.replace("<svg ", '<svg x="100" y="100" ')
        self.assertEqual(display_samples(offset), display_samples(SOURCE))
        self.assertTrue(all(row["visible"] for row in display_samples(offset).values()))

    def test_empty_native_context_is_reported_without_nan(self):
        empty = SOURCE.replace('<circle cx="10" cy="10" r="7"/>', "")
        contexts = display_samples(empty)
        self.assertTrue(all(not row["visible"] for row in contexts.values()))
        self.assertTrue(all(row["relative_area_range"] is None for row in contexts.values()))

    def test_fixed_model_density_has_matching_idempotence_check(self):
        with tempfile.TemporaryDirectory() as temporary:
            before, after = Path(temporary) / "before.svg", Path(temporary) / "after.svg"
            before.write_text(SOURCE)
            target = reference_target(pixels_per_unit=32)
            output, _ = adjust_icon_size(SOURCE, target, pixels_per_unit=32)
            after.write_bytes(output.encode("utf-8"))
            result = audit(before, after, target, pixels_per_unit=32)
            self.assertTrue(result["idempotent"])
            self.assertTrue(result["all_contexts_visible"])
            self.assertTrue(result["source_preserved"])

    def test_validation_cannot_change_the_model_geometry_density(self):
        with tempfile.TemporaryDirectory() as temporary:
            path = Path(temporary) / "icon.svg"
            path.write_text(SOURCE)
            for density in (16, 64):
                with self.assertRaisesRegex(ValueError, "32 geometry samples"):
                    audit(path, path, 16, pixels_per_unit=density)


if __name__ == "__main__":
    unittest.main()
