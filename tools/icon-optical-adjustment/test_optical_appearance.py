"""Rendered-appearance contracts, independent of catalog-specific size ranges."""

import math
import unittest
from dataclasses import replace
from functools import lru_cache

import numpy as np
from PIL import Image

import adjust_icon_sizes as tool
from optical_appearance import appearance
from svg_measurement import Raster, render_alpha, unwrap
from test_svg_measurement import png_reference, svg


def field(rgb, alpha=None):
    pixels = np.asarray(rgb, dtype=np.uint8)
    coverage = np.ones(pixels.shape[:2]) if alpha is None else np.asarray(alpha, dtype=float)
    height, width = coverage.shape
    return Raster(coverage, (0, 0), 1, (0, 0, width, height), pixels)


def solid_field(color, alpha=None):
    return field(np.full((8, 8, 3), color, dtype=np.uint8), alpha)


def sampled(source):
    return appearance(render_alpha(source, pixels_per_unit=16), tool.MODEL_DATA)


@lru_cache(maxsize=24)
def measured(source):
    return tool.measure(source)


class OpticalAppearanceTests(unittest.TestCase):
    def test_sparse_fractional_black_coverage_stays_ordered_and_bounded(self):
        alpha = np.array([[0, 64, 128, 255], [255, 128, 64, 0]], dtype=float) / 255
        raster = field(np.zeros((*alpha.shape, 3), dtype=np.uint8), alpha)
        coverage, metrics = appearance(raster, tool.MODEL_DATA)
        # This deliberately edge-heavy field is not an opaque reference glyph.
        # Its relative alpha distribution may supply weaker amplitude evidence
        # and a different normalized sizing field, while raw alpha stays intact.
        np.testing.assert_array_equal(raster.alpha, alpha)
        self.assertTrue(np.isfinite(coverage).all())
        self.assertGreaterEqual(float(coverage.min()), 0)
        self.assertLessEqual(float(coverage.max()), 1)
        order = np.argsort(alpha.ravel())
        self.assertTrue((np.diff(coverage.ravel()[order]) >= 0).all())
        self.assertTrue((coverage[alpha == 0] == 0).all())
        self.assertTrue((coverage[alpha == 1] == 1).all())
        self.assertGreaterEqual(metrics["color_presence_factor"], 1 / tool.MODEL_DATA["appearance_max_enlargement"])
        self.assertLessEqual(metrics["color_presence_factor"], 1)
        self.assertEqual(metrics["contrast_peak"], 1)

    def test_saturated_black_body_keeps_alpha_geometry_and_full_reference_strength(self):
        alpha = np.ones((64, 64))
        alpha[[0, -1], :] = 128 / 255
        alpha[:, [0, -1]] = 64 / 255
        raster = field(np.zeros((*alpha.shape, 3), dtype=np.uint8), alpha)
        coverage, metrics = appearance(raster, tool.MODEL_DATA)
        self.assertGreaterEqual(metrics["contrast_amplitude"], tool.MODEL_DATA["appearance_saturation_range"][1])
        np.testing.assert_array_equal(coverage, alpha)
        self.assertEqual(metrics["color_presence_factor"], 1)

    def test_transparent_pixels_do_not_contribute_their_hidden_rgb(self):
        alpha = np.ones((8, 8))
        alpha[:, :3] = 0
        first = solid_field((34, 158, 217), alpha)
        hidden = first.rgb.copy()
        hidden[:, :3] = [255, 0, 0]
        a, metrics_a = appearance(first, tool.MODEL_DATA)
        b, metrics_b = appearance(replace(first, rgb=hidden), tool.MODEL_DATA)
        np.testing.assert_array_equal(a, b)
        self.assertEqual(metrics_a, metrics_b)

    def test_global_opacity_does_not_change_size_evidence(self):
        raster = solid_field((34, 158, 217))
        a, metrics_a = appearance(raster, tool.MODEL_DATA)
        b, metrics_b = appearance(replace(raster, alpha=raster.alpha * .2), tool.MODEL_DATA)
        np.testing.assert_array_equal(a, b)
        self.assertEqual(metrics_a, metrics_b)

    def test_opaque_white_motifs_and_transparent_holes_match_on_white(self):
        pixels = np.full((8, 8, 3), (34, 158, 217), dtype=np.uint8)
        pixels[2:6, 2:6] = 255
        opaque = field(pixels)
        hole_alpha = np.ones((8, 8))
        hole_alpha[2:6, 2:6] = 0
        transparent = solid_field((34, 158, 217), hole_alpha)
        a, metrics_a = appearance(opaque, tool.MODEL_DATA)
        b, metrics_b = appearance(transparent, tool.MODEL_DATA)
        np.testing.assert_array_equal(a, b)
        self.assertEqual(metrics_a, metrics_b)

    def test_internal_white_paint_changes_appearance_without_changing_alpha(self):
        plain = solid_field((34, 158, 217))
        pixels = plain.rgb.copy()
        pixels[2:6, 2:6] = 255
        motif = replace(plain, rgb=pixels)
        a, _ = appearance(plain, tool.MODEL_DATA)
        b, _ = appearance(motif, tool.MODEL_DATA)
        np.testing.assert_array_equal(plain.alpha, motif.alpha)
        self.assertEqual(a[3, 3], 1)
        self.assertEqual(b[3, 3], 0)
        self.assertEqual(b[0, 0], 1)

    def test_white_and_nearwhite_paint_keep_finite_bounded_alpha_fallback(self):
        alpha = np.ones((8, 8))
        alpha[2:6, 2:6] = 0
        factors = []
        for channel in range(256):
            raster = solid_field((channel, channel, channel), alpha)
            coverage, metrics = appearance(raster, tool.MODEL_DATA)
            self.assertTrue(np.isfinite(coverage).all())
            self.assertGreaterEqual(float(coverage.min()), 0)
            self.assertLessEqual(float(coverage.max()), 1)
            factor = metrics["color_presence_factor"]
            self.assertTrue(math.isfinite(factor))
            self.assertGreaterEqual(factor, 1 / tool.MODEL_DATA["appearance_max_enlargement"] - 1e-12)
            self.assertLessEqual(factor, 1)
            factors.append(factor)
        self.assertLess(float(np.abs(np.diff(factors)).max()), .02)
        white, metrics = appearance(solid_field((255, 255, 255), alpha), tool.MODEL_DATA)
        np.testing.assert_array_equal(white, alpha)
        self.assertEqual(metrics["contrast_confidence"], 0)
        self.assertEqual(metrics["color_presence_factor"], 1)

    def test_a_tiny_dark_detail_cannot_switch_nearwhite_artwork_to_full_contrast_confidence(self):
        for channel in (240, 250):
            with self.subTest(channel=channel):
                raster = field(np.full((64, 64, 3), channel, dtype=np.uint8))
                decorated = raster.rgb.copy()
                decorated[32, 32] = 0
                a, before = appearance(raster, tool.MODEL_DATA)
                b, after = appearance(replace(raster, rgb=decorated), tool.MODEL_DATA)
                self.assertLess(abs(after["contrast_confidence"] - before["contrast_confidence"]), .1)
                self.assertLess(abs(after["color_presence_factor"] - before["color_presence_factor"]), .02)
                self.assertLess(float(np.abs(a - b).mean()), .03)

    def test_equivalent_svg_color_encodings_and_constant_gradients_match(self):
        sources = [
            svg(f'<rect x="4" y="4" width="12" height="12" fill="{color}"/>')
            for color in ("#36c", "#3366CC", "rgb(51,102,204)", "rgba(51,102,204,1)")
        ]
        sources.append(svg(
            '<defs><linearGradient id="paint"><stop stop-color="#3366cc"/>'
            '<stop offset="1" stop-color="rgb(51,102,204)"/></linearGradient></defs>'
            '<rect x="4" y="4" width="12" height="12" fill="url(#paint)"/>'
        ))
        baseline, metrics = sampled(sources[0])
        for source in sources[1:]:
            with self.subTest(source=source):
                coverage, current = sampled(source)
                np.testing.assert_array_equal(coverage, baseline)
                self.assertEqual(current, metrics)

    def test_occluded_transparent_and_unused_paint_cannot_change_appearance(self):
        paint = '<rect x="4" y="4" width="12" height="12" fill="#229ed9"/>'
        ordinary = svg(paint)
        decorated = svg(
            '<defs><rect id="unused" width="20" height="20" fill="yellow"/></defs>'
            '<rect x="4" y="4" width="12" height="12" fill="red"/>' + paint +
            '<circle cx="10" cy="10" r="9" fill="lime" opacity="0"/>'
        )
        a, metrics_a = sampled(ordinary)
        b, metrics_b = sampled(decorated)
        np.testing.assert_array_equal(a, b)
        self.assertEqual(metrics_a, metrics_b)

    def test_equivalent_vector_and_embedded_png_paint_match(self):
        vector = svg('<rect x="4" y="4" width="8" height="8" fill="#229ed9"/>')
        png = png_reference(Image.new("RGBA", (8, 8), "#229ed9"))
        raster = svg(f'<image x="4" y="4" width="8" height="8" href="{png}"/>')
        a, metrics_a = sampled(vector)
        b, metrics_b = sampled(raster)
        np.testing.assert_array_equal(a, b)
        self.assertEqual(metrics_a, metrics_b)

    def test_white_motif_and_alpha_hole_also_receive_the_same_solved_size(self):
        opaque = svg(
            '<rect x="3" y="3" width="14" height="14" fill="#229ed9"/>'
            '<rect x="7" y="7" width="6" height="6" fill="white"/>'
        )
        hole = svg('<path fill="#229ed9" fill-rule="evenodd" d="M3 3H17V17H3Z M7 7H13V13H7Z"/>')
        a = tool.sizing(measured(opaque), tool.reference_target())
        b = tool.sizing(measured(hole), tool.reference_target())
        self.assertAlmostEqual(a["scale"], b["scale"], delta=.001)
        self.assertAlmostEqual(a["extent"], b["extent"], delta=.02)

    def test_a_tiny_dark_accent_cannot_renormalize_the_entire_colored_body(self):
        body = '<circle cx="10" cy="10" r="8" fill="#229ed9"/>'
        plain = measured(svg(body))
        accented = measured(svg(body + '<circle cx="10" cy="10" r=".1" fill="black"/>'))
        # The accent occupies 0.016% of the disk, below one tenth of one percent.
        self.assertEqual(plain.source_bounds, accented.source_bounds)
        a = tool.sizing(plain, tool.reference_target())
        b = tool.sizing(accented, tool.reference_target())
        self.assertLess(abs(a["extent"] - b["extent"]), .05)

    def test_colored_sources_retain_strictly_increasing_finite_presence(self):
        sources = [
            svg('<circle cx="10" cy="10" r="8" fill="#229ed9"/>'),
            svg('<rect x="3" y="3" width="14" height="14" fill="#eeeeee"/>'),
            svg('<rect x="3" y="3" width="14" height="14" fill="#229ed9"/>'
                '<circle cx="10" cy="10" r="4" fill="white"/>'),
        ]
        for source in sources:
            with self.subTest(source=source):
                icon = measured(source)
                values = [tool.presence(icon, scale) for scale in np.geomspace(.0001, 8, 80)]
                self.assertTrue(np.isfinite(values).all())
                self.assertTrue((np.diff(values) > 0).all())
                solved = tool.sizing(icon, tool.reference_target())
                if not solved["limited"]:
                    self.assertLess(abs(solved["relative_presence_residual"]), 1e-9)

    def test_appearance_changes_do_not_move_the_alpha_based_optical_center(self):
        body = '<path d="M3 3L17 3L17 17Z" fill="{}"/>'
        monochrome = svg(body.format("black"))
        decorated = svg(body.format("#229ed9") + '<circle cx="14" cy="7" r="1" fill="white"/>')
        a, b = measured(monochrome), measured(decorated)
        self.assertEqual(a.source_bounds, b.source_bounds)
        np.testing.assert_allclose(a.features["optical_center"], b.features["optical_center"], atol=1e-12)
        self.assertEqual(tool.placement(a, .6), tool.placement(b, .6))

    def test_global_opacity_also_keeps_colored_solved_sizes_stable(self):
        paint = '<rect x="3" y="3" width="14" height="14" fill="#229ed9"/>'
        opaque = measured(svg(paint))
        translucent = measured(svg('<g opacity=".2">' + paint + '</g>'))
        a = tool.sizing(opaque, tool.reference_target())
        b = tool.sizing(translucent, tool.reference_target())
        # resvg's 8-bit premultiply/unpremultiply changes the recovered straight
        # RGB by a few channel levels at low opacity. Direct-field invariance
        # above remains exact; this source-render test allows that sampling loss.
        self.assertAlmostEqual(a["extent"], b["extent"], delta=.05)

    def test_black_reference_disk_stays_exactly_on_the_existing_reference_size(self):
        disk = measured(tool.optical_model.REFERENCE_SOURCE)
        result = tool.sizing(disk, tool.reference_target())
        self.assertEqual(disk.features["color_presence_factor"], 1)
        self.assertAlmostEqual(result["extent"], 15.5, delta=1e-7)

    def test_a_colored_disk_gets_bounded_size_support_against_the_black_reference(self):
        black = measured(svg('<circle cx="10" cy="10" r="8" fill="black"/>'))
        blue = measured(svg('<circle cx="10" cy="10" r="8" fill="#229ed9"/>'))
        self.assertEqual(black.source_bounds, blue.source_bounds)
        a = tool.sizing(black, tool.reference_target())
        b = tool.sizing(blue, tool.reference_target())
        self.assertGreater(b["extent"], a["extent"])
        self.assertLessEqual(b["extent"] / a["extent"], tool.MODEL_DATA["appearance_max_enlargement"])
        self.assertLessEqual(b["extent"], tool.MAX_EXTENT)

    def test_appearance_adjustment_preserves_authored_color_bytes_and_is_idempotent(self):
        png = png_reference(Image.new("RGBA", (8, 8), "#229ed9"))
        source = svg(f'<image x="4" y="4" width="8" height="8" href="{png}"/>')
        adjusted, _ = tool.adjust_icon_size(source)
        self.assertEqual(unwrap(adjusted), source)
        self.assertEqual(tool.adjust_icon_size(adjusted)[0], adjusted)


if __name__ == "__main__":
    unittest.main()
