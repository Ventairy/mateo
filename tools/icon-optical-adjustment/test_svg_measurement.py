"""Analytic geometry and preservation checks independent of the size model."""

import math
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import numpy as np
from svg_measurement import render_alpha, split_optical_adjustment, unwrap, wrap


def svg(body, root=""):
    return (
        f'<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" '
        f'viewBox="0 0 20 20"{root}>\n{body}\n</svg>\n'
    )


class SvgMeasurementTests(unittest.TestCase):
    def test_circle_area_matches_analytic_geometry(self):
        raster = render_alpha(svg('<circle cx="10" cy="10" r="7"/>'))
        self.assertAlmostEqual(raster.ink_area, 49 * math.pi, delta=0.06)
        self.assertEqual(raster.bounds, (3, 3, 17, 17))

    def test_live_stroke_and_evenodd_hole_preserve_empty_center(self):
        stroke = '<circle cx="10" cy="10" r="7" fill="none" stroke="black" stroke-width="2"/>'
        ring = (
            '<path fill-rule="evenodd" d="M2 10 a8 8 0 1 0 16 0 a8 8 0 1 0 -16 0 '
            'M4 10 a6 6 0 1 0 12 0 a6 6 0 1 0 -12 0"/>'
        )
        for body in (stroke, ring):
            with self.subTest(body=body):
                raster = render_alpha(svg(body))
                self.assertAlmostEqual(raster.ink_area, 28 * math.pi, delta=0.2)
                self.assertEqual(raster.alpha[640, 640], 0)

    def test_clip_path_limits_the_rendered_geometry(self):
        source = svg(
            '<defs><clipPath id="cut"><rect x="1" y="1" width="10" height="18"/></clipPath></defs>'
            '<rect width="20" height="20" clip-path="url(#cut)"/>'
        )
        raster = render_alpha(source)
        self.assertEqual(raster.bounds, (1, 1, 11, 19))
        self.assertEqual(raster.ink_area, 180)

    def test_root_clipping_and_masking_fail_before_a_transform_is_generated(self):
        for effect in ("clip-path", "mask"):
            source = svg('<circle cx="10" cy="10" r="8"/>', root=f' {effect}="url(#cut)"')
            for operation in (unwrap, render_alpha, lambda s: wrap(s, 0.5, 5, 5)):
                with (
                    self.subTest(effect=effect, operation=operation),
                    self.assertRaisesRegex(ValueError, "Root clipping and masking are unsupported"),
                ):
                    operation(source)
        source = svg(
            '<rect x="4" y="4" width="8" height="12"/>', root=' clip-path="none" mask="none"'
        )
        self.assertEqual(render_alpha(wrap(source, 0.5, 5, 5)).ink_area, 24)

    def test_child_clipping_and_masking_scale_with_the_authored_geometry(self):
        effects = {
            "clip-path": '<clipPath id="cut"><rect x="4" y="4" width="4" height="12"/></clipPath>',
            "mask": '<mask id="cut" maskUnits="userSpaceOnUse" x="0" y="0" width="20" height="20">'
            '<rect x="4" y="4" width="4" height="12" fill="white"/></mask>',
        }
        for effect, definition in effects.items():
            source = svg(
                f'<defs>{definition}</defs><g {effect}="url(#cut)">'
                '<rect x="4" y="4" width="8" height="12"/></g>'
            )
            with self.subTest(effect=effect):
                self.assertEqual(render_alpha(source).ink_area, 48)
                output = wrap(source, 0.5, 5, 5)
                self.assertEqual(unwrap(output), source)
                raster = render_alpha(output)
                self.assertEqual(raster.bounds, (7, 7, 9, 13))
                self.assertEqual(raster.ink_area, 12)

    def test_root_effect_rejection_prevents_every_batch_write(self):
        import adjust_icon_sizes

        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary)
            for effect in ("clip-path", "mask"):
                (directory / "a.svg").write_bytes(
                    svg('<rect x="4" y="4" width="8" height="12"/>').encode()
                )
                (directory / "b.svg").write_bytes(
                    svg('<circle cx="10" cy="10" r="8"/>', root=f' {effect}="url(#cut)"').encode()
                )
                before = {p.name: p.read_bytes() for p in directory.iterdir()}
                with (
                    self.subTest(effect=effect),
                    patch.object(adjust_icon_sizes, "_write_batch") as write,
                ):
                    with self.assertRaises(SystemExit) as error:
                        adjust_icon_sizes.main(["--input", str(directory), "--jobs", "1"])
                    self.assertEqual(error.exception.code, 2)
                    write.assert_not_called()
                    self.assertEqual(before, {p.name: p.read_bytes() for p in directory.iterdir()})

    def test_rotated_rect_is_visible(self):
        raster = render_alpha(
            svg('<rect x="2" y="4" width="10" height="4" transform="rotate(90 10 10)"/>')
        )
        self.assertEqual(raster.ink_area, 40)
        self.assertEqual(raster.bounds, (12, 2, 16, 12))

    def test_source_geometry_outside_root_viewport_is_measured(self):
        raster = render_alpha(svg('<rect x="-5" y="2" width="20" height="16"/>'))
        self.assertEqual(raster.ink_area, 320)
        self.assertEqual(raster.bounds, (-5, 2, 15, 18))
        self.assertEqual(raster.origin, (-10, -10))
        self.assertEqual(raster.pixels_per_unit, 32)

    def test_percentage_geometry_keeps_original_viewport(self):
        raster = render_alpha(svg('<rect x="25%" y="25%" width="50%" height="50%"/>'))
        self.assertEqual(raster.ink_area, 100)
        self.assertEqual(raster.bounds, (5, 5, 15, 15))
        circle = render_alpha(svg('<circle cx="50%" cy="50%" r="25%"/>'))
        self.assertAlmostEqual(circle.ink_area, 25 * math.pi, delta=0.05)

    def test_authored_nested_viewport_clipping_is_retained(self):
        source = svg(
            '<svg width="10" height="10" viewBox="0 0 10 10" overflow="hidden">'
            '<rect x="-5" y="2" width="20" height="6"/></svg>'
        )
        raster = render_alpha(source)
        self.assertEqual(raster.ink_area, 60)
        self.assertEqual(raster.bounds, (0, 2, 10, 8))

    def test_equivalent_numeric_frame_formatting_is_accepted(self):
        source = (
            svg('<rect x="2" y="2" width="5" height="8"/>')
            .replace('width="20" height="20"', 'height="2e1px" width="+20.000"')
            .replace('viewBox="0 0 20 20"', 'viewBox="0, 0, 20.0, 20"')
        )
        self.assertEqual(render_alpha(source).ink_area, 40)

    def test_translation_changes_only_the_bounds(self):
        a = render_alpha(svg('<rect x="-5" y="2" width="8" height="10"/>'))
        b = render_alpha(svg('<rect x="6" y="5" width="8" height="10"/>'))
        self.assertEqual(a.ink_area, b.ink_area)
        self.assertEqual(tuple(x + delta for x, delta in zip(a.bounds, (11, 3, 11, 3))), b.bounds)

    def test_authored_coordinate_scale_does_not_change_rendered_geometry(self):
        a = render_alpha(svg('<rect x="2" y="3" width="6" height="8"/>'))
        b = render_alpha(
            svg('<g transform="scale(.5)"><rect x="4" y="6" width="12" height="16"/></g>')
        )
        np.testing.assert_array_equal(a.alpha, b.alpha)

    def test_resolution_changes_coverage_without_changing_svg_units(self):
        source = svg('<circle cx="10" cy="10" r="7"/>')
        a = render_alpha(source, pixels_per_unit=16)
        b = render_alpha(source, pixels_per_unit=64)
        self.assertEqual(a.bounds, b.bounds)
        self.assertAlmostEqual(a.ink_area, b.ink_area, delta=0.08)

    def test_round_trip_preserves_preamble_comments_unicode_and_quoted_greater_than(self):
        source = '<?xml version="1.0" encoding="UTF-8"?>\n<!-- outside <svg> -->\n' + svg(
            "<!-- unchanged café -->\n<title>Luís &amp; Ana</title>\n"
            '<path data-label="a > b" d="M1 2H12V14H1Z"/>',
            root=" data-label='a > b x=\"5\"'",
        )
        source = source.replace("\n", "\r\n")
        result = wrap(source, 0.75, 1.25, -2)
        self.assertEqual(unwrap(result), source)
        self.assertEqual(wrap(result, 0.75, 1.25, -2), result)
        self.assertGreater(render_alpha(result).ink_area, 0)

    def test_prefixed_svg_namespace_stays_valid_through_wrap_and_render(self):
        source = (
            '<s:svg xmlns:s="http://www.w3.org/2000/svg" width="20" height="20" '
            'viewBox="0 0 20 20"><s:rect x="2" y="2" width="8" height="8"/></s:svg>'
        )
        result = wrap(source, 0.5, 5, 5)
        self.assertEqual(unwrap(result), source)
        self.assertEqual(render_alpha(result).ink_area, 16)

    def test_split_optical_adjustment_preserves_authored_bytes_and_extracts_serialized_transform(
        self,
    ):
        source = svg(
            '<!-- café -->\n<g transform="translate(1 2)"><rect width="8" height="6"/></g>'
        ).replace("\n", "\r\n")
        output = wrap(source, 0.1234567894, 1.9876543216, -2.5)
        authored, transform = split_optical_adjustment(output)
        self.assertEqual(authored, source)
        self.assertEqual(transform, (0.123456789, 1.987654322, -2.5))
        alternate = output.replace(
            "matrix(0.123456789 0 0 0.123456789 1.987654322 -2.500000000)",
            "matrix(1e-1,0,0,1e-1,-2.5,+3)",
        )
        self.assertEqual(split_optical_adjustment(alternate), (source, (0.1, -2.5, 3.0)))

    def test_split_optical_adjustment_keeps_authored_groups_without_inventing_a_transform(self):
        source = svg('<g transform="scale(.5)"><rect width="8" height="6"/></g>')
        self.assertEqual(split_optical_adjustment(source), (source, None))

    def test_render_samples_the_supplied_transform_without_implicitly_unwrapping(self):
        source = svg('<rect width="20" height="20"/>')
        output = wrap(source, 0.5, 5, 5)
        self.assertEqual(render_alpha(output).bounds, (5, 5, 15, 15))
        self.assertEqual(render_alpha(output).ink_area, 100)

    def test_duplicate_misplaced_or_modified_optical_size_marker_fails(self):
        bodies = [
            '<g id="mateo-optical-size"/><g id="mateo-optical-size"/>',
            '<g><g id="mateo-optical-size"/></g>',
            '<g id="mateo-optical-size" transform="matrix(1 0 0 1 0 0)" opacity=".5"/>',
            '<g id="mateo-optical-size" transform="matrix(1 0 0 2 0 0)"/>',
        ]
        for body in bodies:
            with self.subTest(body=body), self.assertRaises(ValueError):
                unwrap(svg(body))

    def test_existing_catalog_wrappers_preserve_sources_byte_for_byte(self):
        paths = sorted(
            (
                Path(__file__).resolve().parents[2] / "design-system/foundation/assets/icons/svg"
            ).glob("*.svg")
        )
        self.assertGreater(len(paths), 0)
        for path in paths:
            with self.subTest(icon=path.name):
                original = unwrap(path.read_text())
                self.assertEqual(unwrap(wrap(original, 0.8, 2, 2)), original)

    def test_empty_or_transparent_source_fails(self):
        for body in ("", '<rect width="20" height="20" opacity="0"/>'):
            with self.subTest(body=body), self.assertRaisesRegex(ValueError, "no visible area"):
                render_alpha(svg(body))

    def test_analysis_boundary_contact_fails_instead_of_silently_clipping(self):
        source = svg('<rect x="-11" y="2" width="10" height="10"/>')
        with self.assertRaisesRegex(ValueError, "analysis boundary"):
            render_alpha(source)
        self.assertEqual(render_alpha(source, padding=20).ink_area, 100)

    def test_malformed_nonfinite_and_non_square_sources_fail(self):
        sources = [
            svg('<path d="M0 0 L1e999 2"/>'),
            svg('<rect width="NaN" height="5"/>'),
            svg('<rect width="Infinity" height="5"/>'),
            "<svg>",
            svg('<rect width="2" height="2"/>').replace('width="20"', 'width="24"', 1),
        ]
        for source in sources:
            with self.subTest(source=source), self.assertRaises(ValueError):
                render_alpha(source)

    def test_non_geometry_or_external_inputs_fail_explicitly(self):
        sources = [
            svg("<text>words</text>"),
            svg('<image href="local.png"/>'),
            svg('<use href="other.svg#shape"/>'),
            svg('<rect fill="url(https://example.com/x)"/>'),
            svg("<style>path { fill: red }</style>"),
            svg('<rect style="fill: red"/>'),
            svg('<circle r="5" vector-effect="non-scaling-stroke"/>'),
            svg("<script/>"),
            svg("<filter/>"),
            '<!DOCTYPE svg [<!ENTITY x "value">]>' + svg("<title>&x;</title>"),
        ]
        for source in sources:
            with self.subTest(source=source), self.assertRaises(ValueError):
                render_alpha(source)

    def test_filter_attributes_fail_before_geometry_is_rendered_or_wrapped(self):
        for effect in ("blur(1px)", "drop-shadow(1px 1px 1px)", "url(#effect)"):
            for source in (
                svg(f'<rect width="10" height="10" filter="{effect}"/>'),
                svg('<rect width="10" height="10"/>', root=f' filter="{effect}"'),
            ):
                with (
                    self.subTest(effect=effect, source=source),
                    patch("svg_measurement.resvg_py.svg_to_bytes") as render,
                ):
                    for operation in (unwrap, render_alpha, lambda s: wrap(s, 0.5, 5, 5)):
                        with self.assertRaisesRegex(ValueError, "Filters are unsupported"):
                            operation(source)
                    render.assert_not_called()

    def test_explicit_none_filter_preserves_static_geometry_and_authored_bytes(self):
        source = svg(
            '<rect x="5" y="5" width="10" height="10" filter=" none "/>', root=' filter="none"'
        )
        self.assertEqual(render_alpha(source).bounds, (5, 5, 15, 15))
        self.assertEqual(render_alpha(source).ink_area, 100)
        self.assertEqual(unwrap(wrap(source, 0.5, 5, 5)), source)

    def test_invalid_transform_or_sampling_parameters_fail(self):
        source = svg('<rect width="10" height="10"/>')
        for scale, tx, ty in (
            (0, 0, 0),
            (-1, 0, 0),
            (1e-15, 0, 0),
            (math.inf, 0, 0),
            (1, math.nan, 0),
        ):
            with self.subTest(scale=scale, tx=tx), self.assertRaises(ValueError):
                wrap(source, scale, tx, ty)
        for settings in (
            {"pixels_per_unit": 0},
            {"pixels_per_unit": 1.5},
            {"padding": math.inf},
            {"padding": 0},
            {"pixels_per_unit": 128, "padding": 100},
        ):
            with self.subTest(settings=settings), self.assertRaises(ValueError):
                render_alpha(source, **settings)


if __name__ == "__main__":
    unittest.main()
