"""Observable placement contracts for the shared SVG artwork."""

import math
import unittest
from unittest.mock import patch

import numpy as np
import adjust_icon_sizes as tool
from svg_measurement import render_alpha, unwrap
from test_adjust_icon_sizes import svg, measure, target, DISK, RECT


TRIANGLE = '<path d="M3 3L17 3L17 17Z"/>'


class OpticalPlacementTests(unittest.TestCase):
    def test_asymmetric_mass_moves_toward_center_without_resizing_or_redrawing(self):
        source = svg(TRIANGLE)
        output, adjusted = tool.adjust_icon_size(source)
        with patch.dict(tool.MODEL_DATA, placement_weight=0):
            _, geometric = tool.adjust_icon_size(source)
        self.assertEqual(unwrap(output), source)
        self.assertAlmostEqual(adjusted["scale"], geometric["scale"], places=9)
        self.assertLess(adjusted["tx"] - geometric["tx"], -0.4)
        self.assertGreater(adjusted["ty"] - geometric["ty"], 0.4)
        self.assertLessEqual(math.hypot(*adjusted["placement_offset"]), 1.00000001)

    def test_symmetric_shapes_keep_their_geometric_center(self):
        for source in (DISK, RECT):
            with self.subTest(source=source):
                _, adjusted = tool.adjust_icon_size(source)
                raster = render_alpha(source)
                x0, y0, x1, y1 = raster.bounds
                self.assertAlmostEqual(adjusted["tx"] + adjusted["scale"] * (x0 + x1) / 2, 10, delta=.01)
                self.assertAlmostEqual(adjusted["ty"] + adjusted["scale"] * (y0 + y1) / 2, 10, delta=.01)

    def test_mirrored_and_turned_drawings_receive_matching_placement(self):
        sources = [svg(TRIANGLE), svg('<g transform="translate(20 0) scale(-1 1)">' + TRIANGLE + '</g>'),
                   svg('<g transform="rotate(180 10 10)">' + TRIANGLE + '</g>')]
        offsets = [np.array(tool.adjust_icon_size(source)[1]["placement_offset"]) for source in sources]
        np.testing.assert_allclose(offsets[1], offsets[0] * [-1, 1], atol=.015)
        np.testing.assert_allclose(offsets[2], -offsets[0], atol=.015)

    def test_source_translation_scale_and_opacity_do_not_select_placement(self):
        sources = [svg(TRIANGLE), svg('<g transform="translate(1 -1) scale(.8)">' + TRIANGLE + '</g>'),
                   svg('<g opacity=".2">' + TRIANGLE + '</g>')]
        offsets = [tool.adjust_icon_size(source)[1]["placement_offset"] for source in sources]
        for offset in offsets[1:]:
            np.testing.assert_allclose(offset, offsets[0], atol=.025)

    def test_faint_detached_marks_contribute_gradually(self):
        offsets = []
        for opacity in (.49, .50, .51):
            source = svg('<circle cx="11" cy="10" r="5"/>'
                         f'<circle cx="2" cy="5" r="1" opacity="{opacity}"/>')
            offsets.append(np.array(tool.adjust_icon_size(source)[1]["placement_offset"]))
        self.assertLess(max(np.linalg.norm(a-b) for a,b in zip(offsets, offsets[1:])), .03)

    def test_safe_frame_limits_translation_without_shrinking_the_icon(self):
        icon = measure(svg(TRIANGLE))
        adjusted = tool.sizing(icon, target() * 3)
        with patch.dict(tool.MODEL_DATA, placement_weight=0):
            geometric = tool.sizing(icon, target() * 3)
        self.assertEqual(adjusted["scale"], geometric["scale"])
        self.assertTrue(adjusted["placement_limited"])
        self.assertAlmostEqual(adjusted["placement_offset"][0], 0, delta=1e-8)
        self.assertAlmostEqual(adjusted["placement_offset"][1], 0, delta=1e-8)

    def test_telegram_is_balanced_in_the_asset_and_stays_idempotent(self):
        source = (tool.ICONS / 'telegram.svg').read_text()
        output, adjusted = tool.adjust_icon_size(source)
        with patch.dict(tool.MODEL_DATA, placement_weight=0):
            _, geometric = tool.adjust_icon_size(unwrap(source))
        self.assertGreater(adjusted["scale"] * 20, 14)
        self.assertAlmostEqual(adjusted["scale"], geometric["scale"], places=9)
        self.assertLess(adjusted["placement_offset"][0], -.8)
        self.assertGreater(adjusted["placement_offset"][0], -1.01)
        self.assertEqual(tool.adjust_icon_size(output)[0], output)


if __name__ == '__main__':
    unittest.main()
