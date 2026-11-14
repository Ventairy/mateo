"""Regression checks for validation context fidelity, independent of model tuning."""

import tempfile
import subprocess
import sys
import unittest
from pathlib import Path

from adjust_icon_sizes import adjust_icon_size, reference_target
from svg_measurement import split_optical_adjustment, unwrap, wrap
from validate_icon_sizes import audit, display_samples

SOURCE = '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 20 20"><circle cx="10" cy="10" r="7"/></svg>'
TRIANGLE = SOURCE.replace('<circle cx="10" cy="10" r="7"/>', '<path d="M2 2L18 10L2 18Z"/>')


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

    def test_optically_placed_triangle_does_not_need_centered_painted_bounds(self):
        with tempfile.TemporaryDirectory() as temporary:
            before, after = Path(temporary) / "before.svg", Path(temporary) / "after.svg"
            target = reference_target()
            before.write_text(TRIANGLE)
            output, _ = adjust_icon_size(TRIANGLE, target)
            after.write_text(output)
            result = audit(before, after, target)
            self.assertTrue(result["optically_placed"])
            self.assertGreater(result["geometric_midpoint"][0], 10.5)
            self.assertLess(result["placement_error"], 0.0001)
            self.assertTrue(result["contained"])
            self.assertTrue(result["idempotent"])

    def test_validation_rejects_a_manually_displaced_generated_transform(self):
        with tempfile.TemporaryDirectory() as temporary:
            before, after = Path(temporary) / "before.svg", Path(temporary) / "after.svg"
            target = reference_target()
            before.write_text(TRIANGLE)
            output, _ = adjust_icon_size(TRIANGLE, target)
            _, (scale, tx, ty) = split_optical_adjustment(output)
            after.write_text(wrap(unwrap(output), scale, tx + 0.125, ty))
            result = audit(before, after, target)
            self.assertFalse(result["optically_placed"])
            self.assertAlmostEqual(result["placement_residual"][0], 0.125, places=8)
            self.assertTrue(result["source_preserved"])

    def test_placement_limited_triangle_is_accepted_without_clipping(self):
        with tempfile.TemporaryDirectory() as temporary:
            before, after = Path(temporary) / "before.svg", Path(temporary) / "after.svg"
            target = reference_target() * 100
            before.write_text(TRIANGLE)
            output, _ = adjust_icon_size(TRIANGLE, target)
            after.write_text(output)
            result = audit(before, after, target)
            self.assertTrue(result["optically_placed"])
            self.assertTrue(result["placement_limited"])
            self.assertTrue(result["limited"])
            self.assertTrue(result["contained"])
            self.assertTrue(result["idempotent"])


if __name__ == "__main__":
    unittest.main()
