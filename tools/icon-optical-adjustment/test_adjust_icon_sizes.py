"""Behavioral contracts for shared icon sizing; no snapshots of calibrated glyphs."""

import io
import json
import math
import subprocess
import sys
import tempfile
import unittest
from contextlib import redirect_stderr
from functools import lru_cache
from pathlib import Path
from unittest.mock import patch

import adjust_icon_sizes as sizing_tool
import numpy as np
from scipy.ndimage import gaussian_filter
from svg_measurement import render_alpha, split_optical_adjustment, unwrap, wrap


def svg(body):
    return (
        '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 20 20">'
        + body
        + "</svg>"
    )


@lru_cache(maxsize=48)
def measure(source, density=32):
    return sizing_tool.measure(source, pixels_per_unit=density)


@lru_cache(maxsize=3)
def target(density=32):
    return sizing_tool.reference_target(pixels_per_unit=density)


RECT = svg('<rect x="3" y="5" width="14" height="10" fill="black"/>')
DISK = svg('<circle cx="10" cy="10" r="8" fill="black"/>')
REFERENCE_DISK = svg('<circle cx="10" cy="10" r="10" fill="black"/>')
ASYMMETRIC = '<path d="M2 4 L16 6 L12 17 L9 10 L3 12Z" fill="black"/>'


class GeometricContractTests(unittest.TestCase):
    def test_reference_is_synthetic_and_has_the_requested_diameter(self):
        self.assertEqual(REFERENCE_DISK, sizing_tool.learned_presence.REFERENCE_SOURCE)
        reference = measure(REFERENCE_DISK)
        geometry = sizing_tool._measure_geometry(REFERENCE_DISK)
        self.assertAlmostEqual(reference.features["learned_log_correction"], 0, delta=1e-10)
        self.assertEqual(
            target(), sizing_tool.presence(geometry, sizing_tool.REFERENCE_DIAMETER / 20)
        )
        result = sizing_tool.sizing(reference, target())
        self.assertAlmostEqual(result["extent"], sizing_tool.REFERENCE_DIAMETER, places=7)
        self.assertFalse(result["limited"])

    def test_generated_wrapper_is_idempotent_and_preserves_authored_bytes(self):
        source = '<?xml version="1.0"?>\r\n' + svg(
            '<!-- π > -->\r\n<rect x="3" y="5" width="14" height="10"/>\r\n'
        )
        output, _ = sizing_tool.adjust_icon_size(source, target())
        self.assertEqual(unwrap(output), source)
        repeated, _ = sizing_tool.adjust_icon_size(output, target())
        self.assertEqual(repeated, output)

    def test_equivalent_path_decomposition_does_not_change_size(self):
        divided = svg(
            '<rect x="3" y="5" width="7" height="10"/><rect x="10" y="5" width="7" height="10"/>'
        )
        duplicate = svg(
            '<rect x="3" y="5" width="14" height="10"/><rect x="3" y="5" width="14" height="10"/>'
        )
        sizes = [
            sizing_tool.sizing(measure(s), target())["extent"] for s in (RECT, divided, duplicate)
        ]
        # Compositing an antialiased edge twice can change fractional coverage;
        # tolerate less than one high-resolution analysis pixel.
        self.assertLess(max(sizes) - min(sizes), 1 / sizing_tool.PIXELS_PER_UNIT)

    def test_titles_and_identifiers_never_select_adjustments(self):
        a = svg('<title>chevron-left</title><rect id="pencil" x="3" y="5" width="14" height="10"/>')
        b = svg(
            '<title>unknown future icon</title><rect id="unrelated" x="3" y="5" width="14" height="10"/>'
        )
        self.assertEqual(
            sizing_tool.sizing(measure(a), target()), sizing_tool.sizing(measure(b), target())
        )

    def test_translated_and_uniformly_scaled_sources_adjust_to_same_geometry(self):
        sources = [
            svg(ASYMMETRIC),
            svg('<g transform="translate(2 -1)">' + ASYMMETRIC + "</g>"),
            svg('<g transform="translate(3 2) scale(.7)">' + ASYMMETRIC + "</g>"),
        ]
        outputs = [sizing_tool.adjust_icon_size(source, target())[0] for source in sources]
        rasters = [render_alpha(output, pixels_per_unit=32) for output in outputs]
        areas = [r.ink_area for r in rasters]
        self.assertLess((max(areas) - min(areas)) / np.mean(areas), 0.005)
        bounds = np.array([r.bounds for r in rasters])
        self.assertLess(float(np.ptp(bounds, axis=0).max()), 0.07)
        for raster in rasters[1:]:
            self.assertLess(
                float(np.abs(raster.alpha - rasters[0].alpha).sum() / rasters[0].alpha.sum()), 0.02
            )

    def test_reflection_and_half_turn_preserve_size(self):
        sources = [
            svg(ASYMMETRIC),
            svg('<g transform="translate(20 0) scale(-1 1)">' + ASYMMETRIC + "</g>"),
            svg('<g transform="rotate(180 10 10)">' + ASYMMETRIC + "</g>"),
        ]
        sizes = [sizing_tool.sizing(measure(source), target())["extent"] for source in sources]
        self.assertLess(max(sizes) - min(sizes), 0.012)

    def test_axis_prior_has_a_bounded_effect_and_is_stable_near_isotropy(self):
        horizontal = measure(svg('<rect x="2" y="9" width="16" height="2"/>'))
        vertical = measure(svg('<rect x="9" y="2" width="2" height="16"/>'))
        ratio = sizing_tool.presence(vertical, 0.7) / sizing_tool.presence(horizontal, 0.7)
        self.assertGreater(ratio, 1.065)
        self.assertLess(ratio, math.exp(2 * sizing_tool.ORIENTATION_COEFFICIENT) + 0.001)
        for epsilon in (0.001, 0.01):
            almost_square = measure(svg(f'<rect x="3" y="3" width="14" height="{14 - epsilon}"/>'))
            self.assertLess(abs(almost_square.features["orientation_log_bias"]), 0.0001)

    def test_global_opacity_does_not_change_geometric_size(self):
        opaque = measure(DISK)
        translucent = measure(svg('<circle cx="10" cy="10" r="8" fill="black" opacity=".2"/>'))
        a = sizing_tool.sizing(opaque, target())["extent"]
        b = sizing_tool.sizing(translucent, target())["extent"]
        self.assertLess(abs(a - b), 0.02)

    def test_duotone_opacity_changes_do_not_trigger_a_size_jump(self):
        sources = [
            svg(
                f'<rect x="7" y="3" width="10" height="14"/>'
                f'<rect x="1" y="8" width="2" height="4" opacity="{opacity}"/>'
            )
            for opacity in (0.499, 0.501)
        ]
        measurements = [measure(source) for source in sources]
        presence = [item.features["geometry_presence"] for item in measurements]
        self.assertLess(abs(math.log(presence[1] / presence[0])), 0.005)
        sizes = [sizing_tool.sizing(item, target())["extent"] for item in measurements]
        self.assertLess(abs(sizes[1] - sizes[0]), 0.06)

    def test_private_geometry_sampling_densities_converge(self):
        source = svg(ASYMMETRIC)
        extents = []
        for density in (16, 32, 64):
            geometry = sizing_tool._measure_geometry(source, pixels_per_unit=density)
            reference = sizing_tool._measure_geometry(REFERENCE_DISK, pixels_per_unit=density)
            base_target = sizing_tool.presence(reference, sizing_tool.REFERENCE_DIAMETER / 20)
            extents.append(sizing_tool.sizing(geometry, base_target)["extent"])
        self.assertLess(max(extents) - min(extents), 0.04)

    def test_fixed_model_rejects_other_densities_before_loading_weights(self):
        with patch.object(sizing_tool.learned_presence, "get_model") as load_model:
            for density in (16, 64):
                with self.subTest(density=density):
                    with self.assertRaisesRegex(ValueError, "requires 32"):
                        sizing_tool.measure(RECT, pixels_per_unit=density)
                    with self.assertRaisesRegex(ValueError, "requires 32"):
                        sizing_tool.reference_target(pixels_per_unit=density)
            load_model.assert_not_called()

    def test_safety_bound_contains_all_visible_geometry(self):
        source = svg(
            '<path d="M-3 3L23 17" stroke="black" stroke-width=".7" stroke-linecap="round"/>'
        )
        output, metrics = sizing_tool.adjust_icon_size(source, target() * 2)
        raster = render_alpha(output, pixels_per_unit=64)
        self.assertTrue(metrics["limited"])
        self.assertLessEqual(metrics["extent"], 18)
        self.assertGreaterEqual(min(raster.bounds[:2]), 0.99)
        self.assertLessEqual(max(raster.bounds[2:]), 19.01)
        self.assertLess(metrics["relative_presence_residual"], 0)


class ContrastAndSolverTests(unittest.TestCase):
    def test_correction_multiplies_presence_without_changing_geometry_or_spectrum(self):
        geometry = sizing_tool._measure_geometry(RECT)
        corrected = measure(RECT)
        self.assertEqual(corrected.source_bounds, geometry.source_bounds)
        self.assertEqual(corrected.source_to_canonical, geometry.source_to_canonical)
        np.testing.assert_array_equal(corrected.frequency_squared, geometry.frequency_squared)
        np.testing.assert_array_equal(corrected.spectral_energy, geometry.spectral_energy)
        self.assertEqual(
            corrected.features["base_geometry_presence"], geometry.features["geometry_presence"]
        )
        factor = math.exp(corrected.features["learned_log_correction"])
        for scale in (0.001, 0.4, 0.9, 4):
            with self.subTest(scale=scale):
                actual = sizing_tool.presence(corrected, scale) / sizing_tool.presence(
                    geometry, scale
                )
                self.assertAlmostEqual(actual, factor, places=12)

    def test_score_is_strictly_increasing_over_several_orders_of_magnitude(self):
        for source in (
            DISK,
            RECT,
            svg('<path d="M3 16L10 4L17 16" fill="none" stroke="black" stroke-width=".5"/>'),
        ):
            icon = measure(source)
            scores = [sizing_tool.presence(icon, s) for s in np.geomspace(0.001, 4, 80)]
            self.assertTrue(np.all(np.diff(scores) > 0))
            self.assertTrue(np.isfinite(scores).all())

    def test_visibility_agrees_with_independent_spatial_convolution(self):
        ppu = 8
        alpha = np.zeros((320, 320))
        alpha[120:200, 104:216] = 1
        frequency, energy = sizing_tool._spectral_measurement(alpha, ppu)
        fake = sizing_tool.Measurement((0, 0, 20, 20), 1, {}, frequency, energy)
        area = alpha.sum() / ppu**2
        for scale in (0.4, 0.7, 1):
            direct = sum(
                weight
                * np.square(
                    gaussian_filter(alpha, sigma / scale * ppu, mode="constant", truncate=6)
                ).sum()
                / ppu**2
                / area
                for sigma, weight in sizing_tool.BLUR_SCALES
            )
            self.assertAlmostEqual(sizing_tool.visibility(fake, scale), direct, delta=0.0005)

    def test_solver_equalizes_score_when_not_limited(self):
        icon = measure(RECT)
        result = sizing_tool.sizing(icon, target())
        self.assertFalse(result["limited"])
        self.assertLess(abs(result["relative_presence_residual"]), 1e-9)
        # A matched proxy is only a numerical solver assertion, not proof of
        # equal human perception; icon-level review is a separate workflow.

    def test_invalid_targets_and_scales_are_rejected(self):
        icon = measure(DISK)
        for value in (0, -1, float("nan"), float("inf")):
            with self.assertRaises(ValueError):
                sizing_tool.sizing(icon, value)
            with self.assertRaises(ValueError):
                sizing_tool.visibility(icon, value)


class TransformStabilityTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.icon = sizing_tool._measure_geometry(RECT)
        cls.target = sizing_tool.presence(cls.icon, 0.7)
        cls.solved = sizing_tool.sizing(cls.icon, cls.target)

    def test_small_transform_noise_preserves_bytes_after_fresh_measurement(self):
        saved = wrap(
            RECT,
            self.solved["scale"] + 2e-6,
            self.solved["tx"] - 1e-5,
            self.solved["ty"] - 1e-5,
        )
        with patch.object(sizing_tool, "measure", return_value=self.icon) as measured:
            output, _ = sizing_tool.adjust_icon_size(saved, self.target)
        measured.assert_called_once_with(RECT, pixels_per_unit=32)
        self.assertEqual(output, saved)

    def test_changed_target_replaces_a_genuinely_different_transform(self):
        saved = wrap(RECT, self.solved["scale"], self.solved["tx"], self.solved["ty"])
        changed_target = self.target * 1.01
        solved = sizing_tool.sizing(self.icon, changed_target)
        expected = wrap(RECT, solved["scale"], solved["tx"], solved["ty"])
        with patch.object(sizing_tool, "measure", return_value=self.icon):
            output, metrics = sizing_tool.adjust_icon_size(saved, changed_target)
        self.assertNotEqual(output, saved)
        self.assertEqual(output, expected)
        self.assertEqual(metrics, solved)

    def test_nearby_transform_cannot_preserve_paint_outside_the_safe_frame(self):
        target = self.target * 10
        solved = sizing_tool.sizing(self.icon, target)
        saved = wrap(RECT, solved["scale"], solved["tx"] + 3e-5, solved["ty"])
        with patch.object(sizing_tool, "measure", return_value=self.icon):
            output, _ = sizing_tool.adjust_icon_size(saved, target)
        self.assertNotEqual(output, saved)
        self.assertEqual(output, wrap(RECT, solved["scale"], solved["tx"], solved["ty"]))

    def test_unwrapped_input_always_uses_the_independent_solution(self):
        expected = wrap(RECT, self.solved["scale"], self.solved["tx"], self.solved["ty"])
        with (
            patch.object(sizing_tool, "measure", return_value=self.icon),
            patch.object(sizing_tool, "_retained_metrics") as retain,
        ):
            output, metrics = sizing_tool.adjust_icon_size(RECT, self.target)
        retain.assert_not_called()
        self.assertEqual(output, expected)
        self.assertEqual(metrics, self.solved)

    def test_report_describes_the_retained_serialized_transform(self):
        saved = wrap(
            RECT,
            self.solved["scale"] + 2e-6,
            self.solved["tx"] - 1e-5,
            self.solved["ty"] - 1e-5,
        )
        _, (scale, tx, ty) = split_optical_adjustment(saved)
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "future-icon.svg"
            report = Path(directory) / "report.json"
            path.write_bytes(saved.encode("utf-8"))
            with (
                patch.object(sizing_tool, "reference_target", return_value=self.target),
                patch.object(sizing_tool, "measure", return_value=self.icon),
            ):
                sizing_tool.main(["--input", directory, "--report", str(report), "--jobs", "1"])
            self.assertEqual(path.read_bytes(), saved.encode("utf-8"))
            metrics = json.loads(report.read_text())["icons"][path.name]
        canonical_scale = scale / self.icon.source_to_canonical
        achieved = sizing_tool.presence(self.icon, canonical_scale)
        self.assertEqual((metrics["scale"], metrics["tx"], metrics["ty"]), (scale, tx, ty))
        self.assertEqual(metrics["extent"], canonical_scale * 20)
        self.assertEqual(metrics["presence"], achieved)
        self.assertEqual(metrics["relative_presence_residual"], achieved / self.target - 1)
        self.assertEqual(metrics["ink_area"], self.icon.features["ink_area"] * canonical_scale**2)
        self.assertEqual(
            metrics["visibility"]["20"], sizing_tool.visibility(self.icon, canonical_scale, 20)
        )


class BatchContractTests(unittest.TestCase):
    def test_missing_weights_and_setup_failure_leave_the_batch_untouched(self):
        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary) / "input"
            directory.mkdir()
            empty_cache = Path(temporary) / "unprepared-weights"
            empty_cache.mkdir()
            (directory / "a.svg").write_text(RECT)
            (directory / "b.svg").write_text(svg(ASYMMETRIC))
            report = Path(temporary) / "report.json"
            before = {path.name: path.read_bytes() for path in directory.iterdir()}
            failures = (
                (
                    "missing weights",
                    lambda: sizing_tool.learned_presence.LearnedPresence(cache_dir=empty_cache),
                    "weights are missing or invalid",
                ),
                (
                    "runtime setup",
                    sizing_tool.learned_presence.ModelSetupError(
                        "simulated incompatible model runtime"
                    ),
                    "simulated incompatible model runtime",
                ),
            )
            for label, failure, message in failures:
                with self.subTest(failure=label):
                    stderr = io.StringIO()
                    with (
                        patch.object(
                            sizing_tool.learned_presence, "get_model", side_effect=failure
                        ),
                        redirect_stderr(stderr),
                        self.assertRaises(SystemExit) as error,
                    ):
                        sizing_tool.main(
                            ["--input", str(directory), "--report", str(report), "--jobs", "4"]
                        )
                    self.assertEqual(error.exception.code, 2)
                    self.assertIn(message, stderr.getvalue())
                    self.assertEqual(
                        before, {path.name: path.read_bytes() for path in directory.iterdir()}
                    )
                    self.assertFalse(report.exists())

    def test_worker_counts_produce_identical_bytes_from_fresh_processes(self):
        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary) / "input"
            directory.mkdir()
            (directory / "a.svg").write_text(RECT)
            (directory / "b.svg").write_text(svg(ASYMMETRIC))
            before = {path.name: path.read_bytes() for path in directory.iterdir()}
            outputs = []
            # Each process starts with a fresh network and empty inference
            # cache, so the parallel run cannot reuse serial measurements.
            for jobs in (1, 4):
                output = Path(temporary) / f"output-{jobs}"
                process = subprocess.run(
                    [
                        sys.executable,
                        str(Path(sizing_tool.__file__).resolve()),
                        "--input",
                        str(directory),
                        "--output-dir",
                        str(output),
                        "--jobs",
                        str(jobs),
                    ],
                    capture_output=True,
                    text=True,
                )
                self.assertEqual(process.returncode, 0, process.stderr + process.stdout)
                outputs.append({path.name: path.read_bytes() for path in output.glob("*.svg")})
            self.assertEqual(set(outputs[0]), set(before))
            self.assertEqual(outputs[0], outputs[1])
            self.assertEqual(before, {path.name: path.read_bytes() for path in directory.iterdir()})

    def test_invalid_batch_leaves_every_input_byte_untouched(self):
        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary)
            (directory / "a.svg").write_text(RECT)
            (directory / "b.svg").write_text(svg(""))
            before = {p.name: p.read_bytes() for p in directory.iterdir()}
            with self.assertRaises(SystemExit) as error:
                sizing_tool.main(["--input", str(directory), "--jobs", "1"])
            self.assertEqual(error.exception.code, 2)
            self.assertEqual(before, {p.name: p.read_bytes() for p in directory.iterdir()})

    def test_check_is_read_only_and_separate_output_is_repeatable(self):
        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary) / "input"
            directory.mkdir()
            output = Path(temporary) / "output"
            report = Path(temporary) / "report.json"
            path = directory / "arbitrary.svg"
            original = RECT.encode()
            path.write_bytes(original)
            self.assertEqual(
                sizing_tool.main(["--input", str(directory), "--check", "--jobs", "1"]), 1
            )
            self.assertEqual(path.read_bytes(), original)
            arguments = [
                "--input",
                str(directory),
                "--output-dir",
                str(output),
                "--report",
                str(report),
                "--jobs",
                "1",
            ]
            self.assertEqual(sizing_tool.main(arguments), 0)
            first = (output / path.name).read_bytes()
            self.assertEqual(sizing_tool.main(arguments), 0)
            self.assertEqual((output / path.name).read_bytes(), first)
            self.assertEqual(path.read_bytes(), original)
            data = json.loads(report.read_text())
            self.assertEqual(data["reference"]["kind"], "synthetic disk")
            self.assertEqual(set(data["icons"]), {"arbitrary.svg"})

    def test_concurrent_edit_is_detected_before_replacing_any_file(self):
        with tempfile.TemporaryDirectory() as temporary:
            a, b = Path(temporary) / "a.svg", Path(temporary) / "b.svg"
            a.write_bytes(b"original-a")
            b.write_bytes(b"changed-by-user")
            with self.assertRaises(RuntimeError):
                sizing_tool._write_batch(
                    [(a, b"original-a", b"generated-a"), (b, b"original-b", b"generated-b")]
                )
            self.assertEqual(a.read_bytes(), b"original-a")
            self.assertEqual(b.read_bytes(), b"changed-by-user")
            self.assertEqual(sorted(p.name for p in Path(temporary).iterdir()), ["a.svg", "b.svg"])

    def test_output_edited_during_measurement_is_not_overwritten(self):
        with tempfile.TemporaryDirectory() as temporary:
            source = Path(temporary) / "input"
            output = Path(temporary) / "output"
            source.mkdir()
            output.mkdir()
            (source / "icon.svg").write_text(RECT)
            destination = output / "icon.svg"
            destination.write_bytes(b"previous output")

            def measure_while_user_edits(*_args, **_kwargs):
                destination.write_bytes(b"user edit")
                return DISK, {}

            with (
                patch.object(sizing_tool, "reference_target", return_value=16),
                patch.object(sizing_tool, "adjust_icon_size", side_effect=measure_while_user_edits),
                redirect_stderr(io.StringIO()),
                self.assertRaises(SystemExit) as error,
            ):
                sizing_tool.main(["--input", str(source), "--output-dir", str(output)])
            self.assertEqual(error.exception.code, 2)
            self.assertEqual(destination.read_bytes(), b"user edit")
            self.assertEqual((source / "icon.svg").read_text(), RECT)

    def test_report_write_failure_rolls_back_svg_changes(self):
        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary)
            source = directory / "icon.svg"
            report = directory / "report.json"
            source.write_text(RECT)
            report.write_bytes(b"previous report")
            real_replace = sizing_tool.os.replace

            def fail_report(source_path, destination):
                if destination.resolve() == report.resolve():
                    raise OSError("simulated report write failure")
                real_replace(source_path, destination)

            with (
                patch.object(sizing_tool, "reference_target", return_value=16),
                patch.object(sizing_tool, "adjust_icon_size", return_value=(DISK, {})),
                patch.object(sizing_tool.os, "replace", side_effect=fail_report),
                redirect_stderr(io.StringIO()),
                self.assertRaises(SystemExit) as error,
            ):
                sizing_tool.main(["--input", str(directory), "--report", str(report)])
            self.assertEqual(error.exception.code, 2)
            self.assertEqual(source.read_text(), RECT)
            self.assertEqual(report.read_bytes(), b"previous report")
            self.assertEqual(
                sorted(path.name for path in directory.iterdir()), ["icon.svg", "report.json"]
            )

    def test_failed_replace_rolls_back_completed_writes(self):
        with tempfile.TemporaryDirectory() as temporary:
            a, b = Path(temporary) / "a.svg", Path(temporary) / "b.svg"
            a.write_bytes(b"original-a")
            b.write_bytes(b"original-b")
            real_replace = sizing_tool.os.replace

            def replace(source, destination):
                if destination == b:
                    raise OSError("simulated write failure")
                real_replace(source, destination)

            with (
                patch.object(sizing_tool.os, "replace", side_effect=replace),
                self.assertRaises(OSError),
            ):
                sizing_tool._write_batch(
                    [(a, b"original-a", b"generated-a"), (b, b"original-b", b"generated-b")]
                )
            self.assertEqual(a.read_bytes(), b"original-a")
            self.assertEqual(b.read_bytes(), b"original-b")


if __name__ == "__main__":
    unittest.main()
