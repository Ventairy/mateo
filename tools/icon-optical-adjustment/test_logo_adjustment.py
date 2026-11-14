"""Logo raster artwork follows the same optical and preservation contracts."""

import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import adjust_icon_sizes as tool
import numpy as np
from PIL import Image, ImageDraw
from svg_measurement import render_alpha, unwrap
from test_svg_measurement import png_reference, svg
from validate_icon_sizes import audit


def raster_logo(color):
    image = Image.new("RGBA", (32, 32))
    ImageDraw.Draw(image).polygon(((0, 0), (31, 0), (31, 31)), fill=color)
    return svg(f'<image x="2" y="2" width="16" height="16" href="{png_reference(image)}"/>')


class LogoAdjustmentTests(unittest.TestCase):
    def test_raster_logo_gets_optical_placement_without_changing_solved_size(self):
        source = raster_logo("#229ED9")
        adjusted, metrics = tool.adjust_icon_size(source)
        with patch.dict(tool.MODEL_DATA, placement_weight=0):
            _, geometric = tool.adjust_icon_size(source)
        self.assertEqual(unwrap(adjusted), source)
        self.assertEqual(metrics["scale"], geometric["scale"])
        self.assertLess(metrics["placement_offset"][0], -.4)
        self.assertGreater(metrics["placement_offset"][1], .4)
        bounds = render_alpha(adjusted).bounds
        self.assertGreaterEqual(min(bounds[:2]), .25 - 1 / 32)
        self.assertLessEqual(max(bounds[2:]), 19.75 + 1 / 32)
        self.assertEqual(tool.adjust_icon_size(adjusted)[0], adjusted)

    def test_authored_colors_receive_contrast_sizing_without_recoloring_or_selecting_placement(self):
        blue = raster_logo("#229ED9")
        red = raster_logo("#FF4A4B")
        results = [tool.adjust_icon_size(source) for source in (blue, red)]
        self.assertGreater(results[0][1]["extent"], results[1][1]["extent"])
        measurements = [tool.measure(source) for source in (blue, red)]
        self.assertEqual(tool.placement(measurements[0], .5), tool.placement(measurements[1], .5))
        for source, (output, _) in zip((blue, red), results):
            self.assertEqual(unwrap(output), source)
        np.testing.assert_array_equal(render_alpha(blue).alpha, render_alpha(red).alpha)

    def test_raster_logo_passes_validation_at_every_display_size_density_and_phase(self):
        source = raster_logo("#25D366")
        adjusted, _ = tool.adjust_icon_size(source)
        with tempfile.TemporaryDirectory() as temporary:
            before, after = Path(temporary) / "before.svg", Path(temporary) / "after.svg"
            before.write_text(source)
            after.write_text(adjusted)
            result = audit(before, after, tool.reference_target())
        for key in ("source_preserved", "idempotent", "optically_placed", "contained", "all_contexts_visible"):
            self.assertTrue(result[key], key)
        self.assertEqual(len(result["display_samples"]), 12)
        self.assertEqual(sum(len(context["ink_areas"]) for context in result["display_samples"].values()), 48)


if __name__ == "__main__":
    unittest.main()
