"""Independent grayscale reconstruction and enclosure regression properties."""

import math
import unittest

import numpy as np
from optical_geometry import closure_measure, layer_span, soft_fill
from scipy import ndimage
from svg_measurement import render_alpha


def _ring(gap):
    if gap == 0:
        body = (
            '<path fill-rule="evenodd" d="M2 10 a8 8 0 1 0 16 0 a8 8 0 1 0 -16 0 '
            'M4 10 a6 6 0 1 0 12 0 a6 6 0 1 0 -12 0"/>'
        )
    else:
        angle = math.radians(gap / 2)

        def point(radius, theta):
            return f"{10 + radius * math.cos(theta)},{10 + radius * math.sin(theta)}"

        body = (
            f'<path d="M{point(8, angle)} A8,8 0 1 1 {point(8, -angle)} '
            f'L{point(6, -angle)} A6,6 0 1 0 {point(6, angle)} Z"/>'
        )
    return (
        '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" '
        f'viewBox="0 0 20 20">{body}</svg>'
    )


def _iterated_reference(image):
    result = np.full_like(image, image.max())
    result[0], result[-1] = image[0], image[-1]
    result[:, 0], result[:, -1] = image[:, 0], image[:, -1]
    for _ in range(image.size + 1):
        updated = np.maximum(
            image,
            ndimage.minimum_filter(
                result, footprint=ndimage.generate_binary_structure(2, 1), mode="nearest"
            ),
        )
        if np.array_equal(updated, result):
            return result
        result = updated
    raise AssertionError("Independent reconstruction failed to converge")


class OpticalGeometryTests(unittest.TestCase):
    def test_layer_span_matches_analytic_rectangle_and_cell_corner_diameter(self):
        alpha = np.zeros((20, 20))
        alpha[7:13, 8:14] = 1
        result = layer_span(alpha, 1)
        self.assertEqual(result["width"], 6)
        self.assertEqual(result["height"], 6)
        self.assertEqual(result["diameter"], math.sqrt(72))

    def test_partially_opaque_appendage_contributes_linearly_through_half_alpha(self):
        previous = None
        for opacity in (0, 1e-12, 0.1, 0.499, 0.5, 0.501, 0.9, 1):
            alpha = np.zeros((20, 20))
            alpha[7:13, 8:14] = 1
            alpha[8:12, 1:3] = opacity
            result = layer_span(alpha, 1)
            self.assertAlmostEqual(result["width"], 6 + 7 * opacity, places=12)
            self.assertEqual(result["height"], 6)
            expected = math.sqrt(72) + opacity * (math.sqrt(194) - math.sqrt(72))
            self.assertAlmostEqual(result["diameter"], expected, places=12)
            if opacity == 0.501:
                self.assertLess(result["width"] - previous["width"], 0.01)
            previous = result

    def test_layer_span_is_translation_rotation_reflection_and_opacity_invariant(self):
        alpha = np.random.default_rng(22).choice([0, 0.1, 0.499, 0.9, 1], size=(17, 21))
        original = layer_span(alpha, 4)
        self.assertEqual(layer_span(np.pad(alpha, ((3, 0), (0, 7))), 4), original)
        self.assertEqual(layer_span(alpha[:, ::-1], 4), original)
        rotated = layer_span(np.rot90(alpha), 4)
        self.assertEqual(rotated["width"], original["height"])
        self.assertEqual(rotated["height"], original["width"])
        self.assertEqual(rotated["diameter"], original["diameter"])
        faint = layer_span(alpha * 1e-10, 4)
        for name in original:
            self.assertAlmostEqual(faint[name], original[name], places=12)

    def test_collinear_or_single_pixel_centers_have_finite_cell_extents(self):
        diagonal = layer_span(np.eye(3), 1)
        self.assertAlmostEqual(diagonal["diameter"], 3 * math.sqrt(2), places=14)
        single = layer_span(np.array([[1, 0], [0, 0]]), 1)
        self.assertEqual(single["diameter"], math.sqrt(2))
        self.assertEqual(single["width"], 1)

    def test_round_vector_span_converges_with_pixel_cell_sampling(self):
        source = (
            '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" '
            'viewBox="0 0 20 20"><circle cx="10" cy="10" r="8"/></svg>'
        )
        errors = []
        for ppu in (16, 32, 64):
            raster = render_alpha(source, pixels_per_unit=ppu)
            result = layer_span(raster.alpha, ppu)
            self.assertAlmostEqual(result["width"], 16, places=10)
            self.assertAlmostEqual(result["height"], 16, places=10)
            error = abs(result["diameter"] - 16)
            self.assertLess(error, 2 * math.sqrt(2) / ppu)
            errors.append(error)
        self.assertGreater(errors[0], errors[1])
        self.assertGreater(errors[1], errors[2])

    def test_layer_span_invalid_or_empty_input_fails(self):
        with self.assertRaisesRegex(ValueError, "no visible area"):
            layer_span(np.zeros((3, 3)), 4)
        with self.assertRaises(ValueError):
            layer_span(np.ones((3, 3)), 0)

    def test_soft_fill_matches_independent_iterated_reconstruction(self):
        for seed in range(6):
            image = np.random.default_rng(seed).uniform(size=(17, 19))
            np.testing.assert_array_equal(soft_fill(image), _iterated_reference(image))

    def test_tiny_escape_barriers_remain_fractional_without_topological_jump(self):
        image = np.zeros((5, 5))
        image[1:4, 1:4] = 1
        image[2, 2] = 0
        for barrier in (0, 1e-12, 1e-9, 0.001, 0.1, 0.5, 1):
            image[1, 2] = barrier
            self.assertEqual(soft_fill(image)[2, 2], barrier)

    def test_reconstruction_is_extensive_idempotent_and_nonexpansive(self):
        rng = np.random.default_rng(17)
        image = rng.uniform(size=(20, 20))
        result = soft_fill(image)
        self.assertTrue(np.all(result >= image))
        np.testing.assert_array_equal(soft_fill(result), result)
        perturbed = np.clip(image + rng.uniform(-0.005, 0.005, image.shape), 0, 1)
        self.assertLessEqual(
            np.abs(soft_fill(perturbed) - result).max(), np.abs(perturbed - image).max() + 1e-15
        )

    def test_rotation_reflection_and_opacity_preserve_reconstruction(self):
        image = np.random.default_rng(13).uniform(size=(17, 19))
        result = soft_fill(image)
        np.testing.assert_array_equal(soft_fill(np.rot90(image)), np.rot90(result))
        np.testing.assert_array_equal(soft_fill(image[:, ::-1]), result[:, ::-1])
        np.testing.assert_allclose(soft_fill(image * 0.3), result * 0.3, atol=1e-15)

    def test_widening_ring_opening_gradually_reduces_enclosed_area(self):
        areas = []
        for gap in (0, 0.25, 0.5, 1, 2, 4, 8, 16, 30, 60):
            raster = render_alpha(_ring(gap), pixels_per_unit=8)
            areas.append(closure_measure(raster.alpha, 8)["filled_area"])
        self.assertEqual(areas, sorted(areas, reverse=True))
        self.assertLess(abs(areas[1] / areas[0] - 1), 0.02)
        self.assertLess(areas[-1], areas[0] * 0.6)

    def test_separated_dots_do_not_fill_the_gap_between_them(self):
        alpha = np.zeros((100, 140))
        alpha[46:54, 20:28] = 1
        alpha[46:54, 112:120] = 1
        result = closure_measure(alpha, 8)
        self.assertAlmostEqual(result["filled_area"], result["ink_area"], places=12)
        self.assertLess(result["closure"], 1e-12)

    def test_solid_box_and_disk_tolerate_gaussian_roundoff_without_added_enclosure(self):
        box = np.ones((160, 160))
        yy, xx = np.mgrid[:200, :200]
        disk = ((xx - 99.5) ** 2 + (yy - 99.5) ** 2 < 80**2).astype(float)
        for alpha in (box, disk):
            result = closure_measure(alpha, 16)
            self.assertAlmostEqual(result["filled_area"], result["ink_area"], places=10)

    def test_enclosure_is_translation_invariant_and_alpha_homogeneous(self):
        raster = render_alpha(_ring(2), pixels_per_unit=8)
        result = closure_measure(raster.alpha, 8)
        shifted = closure_measure(np.pad(raster.alpha, ((5, 0), (3, 19))), 8)
        self.assertEqual(result, shifted)
        faint = closure_measure(raster.alpha * 1e-10, 8)
        self.assertAlmostEqual(faint["closure"], result["closure"], places=12)
        self.assertAlmostEqual(faint["filled_area"] / result["filled_area"], 1e-10, places=20)

    def test_enclosure_is_bounded_and_never_removes_ink(self):
        for gap in (0, 2, 60):
            raster = render_alpha(_ring(gap), pixels_per_unit=8)
            result = closure_measure(raster.alpha, 8)
            self.assertLessEqual(result["ink_area"], result["filled_area"])
            self.assertGreaterEqual(result["closure"], 0)
            self.assertLess(result["closure"], 1)

    def test_subpixel_opening_converges_with_sampling_resolution(self):
        measures = []
        for ppu in (8, 16, 32):
            raster = render_alpha(_ring(0.5), pixels_per_unit=ppu)
            measures.append(closure_measure(raster.alpha, ppu)["filled_area"])
        self.assertLess(abs(measures[1] / measures[2] - 1), 0.005)
        self.assertLess(abs(measures[0] / measures[2] - 1), 0.015)

    def test_empty_nonfinite_out_of_range_or_invalid_settings_fail(self):
        for image in (np.array([]), np.full((3, 3), math.nan), np.full((3, 3), 1.1)):
            with self.subTest(image=image), self.assertRaises(ValueError):
                soft_fill(image)
        for kwargs in (
            {"pixels_per_unit": 0},
            {"pixels_per_unit": math.inf},
            {"pixels_per_unit": 8, "sigmas": ()},
            {"pixels_per_unit": 8, "sigmas": (math.nan,)},
            {"pixels_per_unit": 1000, "sigmas": (100,)},
        ):
            with self.subTest(kwargs=kwargs), self.assertRaises(ValueError):
                closure_measure(np.ones((3, 3)), **kwargs)
        with self.assertRaisesRegex(ValueError, "no visible area"):
            closure_measure(np.zeros((3, 3)), 8)


if __name__ == "__main__":
    unittest.main()
