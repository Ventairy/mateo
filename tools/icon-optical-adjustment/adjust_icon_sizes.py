#!/usr/bin/env python3
"""Adjust icon sizes optically using geometry and a learned visual descriptor.

Only one uniform transform is generated inside each existing 20px SVG frame.
No filename, family, catalog statistic, or per-icon adjustment enters the model.
See README.md for the model, commands, and validation boundaries.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.metadata
import json
import math
import os
import tempfile
from concurrent.futures import ThreadPoolExecutor
from dataclasses import dataclass, replace
from pathlib import Path

import learned_presence
import numpy as np
from optical_geometry import closure_measure, layer_span
from scipy import fft
from svg_measurement import (
    FRAME,
    RENDERER_VERSION,
    render_alpha,
    split_optical_adjustment,
    unwrap,
    wrap,
)

ICONS = Path(__file__).resolve().parents[2] / "design-system/foundation/assets/icons/svg"
MODEL_DATA = learned_presence.read_model()
MODEL_VERSION = MODEL_DATA["model"]
MAX_EXTENT = MODEL_DATA["max_extent"]
REFERENCE_DIAMETER = MODEL_DATA["reference_diameter"]
PIXELS_PER_UNIT = learned_presence.PIXELS_PER_UNIT
ANALYSIS_PIXELS_PER_UNIT = 8
# Fixed shared calibration; none of these values depends on the input catalog.
ORIENTATION_COEFFICIENT = 0.03577135033431072
EMPTY_SPACE_WEIGHT = 0.20
CONTRAST_CUE_WEIGHT = 0.03
DIAGONAL_CUE_WEIGHT = 0.25
CLOSURE_SIGMAS = (0.35, 0.70, 1.40)
# Fixed model sampling contexts, independent of current component size tokens.
DISPLAY_SIZES = (16.0, 20.0, 24.0)
BLUR_SCALES = ((0.45, 0.50), (0.90, 0.35), (1.80, 0.15))
SOLVER_STEPS = 36
TRANSFORM_TOLERANCE = 1e-4
BOUNDS_EPSILON = 1e-8


@dataclass(frozen=True)
class Measurement:
    """Features in a canonical 20-unit occupied span, independent of source size."""

    source_bounds: tuple[float, float, float, float]
    source_to_canonical: float
    features: dict
    frequency_squared: np.ndarray
    spectral_energy: np.ndarray


def _spectral_measurement(alpha, pixels_per_unit):
    """Radially pool a zero-padded Fourier power spectrum.

    Parseval normalization gives E_sigma(s)/(s² A). Every bin is nonnegative,
    so that ratio increases monotonically with scale. A 128-unit field keeps
    periodic copies remote from the useful scale range. Pooling into 2048
    radial bins avoids retaining a full spectrum for every icon.
    """
    n = round(128 * pixels_per_unit)
    rows, cols = alpha.shape
    if max(rows, cols) > n:
        raise ValueError("Analysis coverage exceeds the spectral field")
    field = np.zeros((n, n), dtype=float)
    y, x = (n - rows) // 2, (n - cols) // 2
    field[y : y + rows, x : x + cols] = alpha
    spectrum = np.abs(fft.rfft2(field, workers=1)) ** 2
    # The real FFT stores only half of the horizontal frequencies.
    spectrum[:, 1:-1] *= 2
    fy = fft.fftfreq(n, d=1 / pixels_per_unit)
    fx = fft.rfftfreq(n, d=1 / pixels_per_unit)
    frequency2 = fy[:, None] ** 2 + fx[None, :] ** 2
    radius = np.sqrt(frequency2)
    indices = np.minimum((radius / radius.max() * 2047).astype(int), 2047)
    power = np.bincount(indices.ravel(), weights=spectrum.ravel(), minlength=2048)
    moment = np.bincount(indices.ravel(), weights=(spectrum * frequency2).ravel(), minlength=2048)
    active = power > 0
    mean_frequency2 = moment[active] / power[active]
    ink = alpha.sum() / pixels_per_unit**2
    energy = power[active] / (n * n * pixels_per_unit**2 * ink)
    return mean_frequency2, energy


def _measure_geometry(source, *, pixels_per_unit=PIXELS_PER_UNIT):
    """Measure authored geometry; generated transforms do not become new inputs."""
    original = unwrap(source)
    raw = render_alpha(original, pixels_per_unit=pixels_per_unit)
    x0, y0, x1, y1 = raw.bounds
    extent = max(x1 - x0, y1 - y0)
    canonical_scale = FRAME / extent
    canonical = wrap(
        original,
        canonical_scale,
        FRAME / 2 - canonical_scale * (x0 + x1) / 2,
        FRAME / 2 - canonical_scale * (y0 + y1) / 2,
    )
    raster = render_alpha(canonical, pixels_per_unit=pixels_per_unit)
    peak = float(raster.alpha.max())
    alpha = raster.alpha / peak
    support = layer_span(alpha, pixels_per_unit)
    width, height = support["width"], support["height"]
    diameter, axis_extent = support["diameter"], support["axis_extent"]
    area = float(alpha.sum() / pixels_per_unit**2)
    yy, xx = np.indices(alpha.shape, dtype=float)
    mass = alpha.sum()
    cx, cy = float((xx * alpha).sum() / mass), float((yy * alpha).sum() / mass)
    vx = float(((xx - cx) ** 2 * alpha).sum() / mass)
    vy = float(((yy - cy) ** 2 * alpha).sum() / mass)
    orientation = (vy - vx) / (vy + vx)
    # Re-render vectors at the analysis density, avoiding phase-dependent image
    # enlargement and retaining native strokes and clipping behavior.
    analysis = render_alpha(canonical, pixels_per_unit=ANALYSIS_PIXELS_PER_UNIT)
    coverage = analysis.alpha / float(analysis.alpha.max())
    closure = closure_measure(coverage, ANALYSIS_PIXELS_PER_UNIT, sigmas=CLOSURE_SIGMAS)
    # Express the softly filled support as a ratio so high-resolution ink area
    # remains authoritative. No blurred field is peak-normalized.
    filled_area = area * closure["filled_area"] / closure["ink_area"]
    unoccupied_fraction = 1 - min(max(filled_area / axis_extent**2, 0.0), 1.0)
    # The bounded empty-space term treats a sparse span as perceptually extended.
    # Its weight and synthetic reference are shared design calibration, not
    # coefficients fitted to the large-shape area-judgment study.
    geometry_presence = axis_extent * math.exp(
        EMPTY_SPACE_WEIGHT * unoccupied_fraction + ORIENTATION_COEFFICIENT * orientation
    )
    # Preserve the operation order of the candidate used in the local review.
    # Occupancy still uses the axis span; diagonal reach modifies extent only.
    diagonal_factor = (diameter / axis_extent) ** DIAGONAL_CUE_WEIGHT
    geometry_presence *= diagonal_factor
    frequencies, energy = _spectral_measurement(coverage, ANALYSIS_PIXELS_PER_UNIT)
    features = dict(
        width=width,
        height=height,
        axis_extent=axis_extent,
        diameter=diameter,
        ink_area=area,
        filled_area=filled_area,
        unoccupied_fraction=unoccupied_fraction,
        closure=closure["closure"],
        closure_filled_areas=closure["filled_areas"],
        orientation=orientation,
        orientation_log_bias=ORIENTATION_COEFFICIENT * orientation,
        diagonal_factor=diagonal_factor,
        geometry_presence=geometry_presence,
        peak_alpha=peak,
    )
    if not all(
        math.isfinite(value) for value in features.values() if isinstance(value, (int, float))
    ):
        raise ValueError("Nonfinite icon measurement")
    return Measurement(raw.bounds, canonical_scale, features, frequencies, energy)


def measure(source, *, pixels_per_unit=PIXELS_PER_UNIT):
    """Apply one fixed visual correction to the authored geometry measurement."""
    if pixels_per_unit != PIXELS_PER_UNIT:
        raise ValueError("The fixed icon model requires 32 geometry samples per unit")
    original = unwrap(source)
    measured = _measure_geometry(original, pixels_per_unit=pixels_per_unit)
    model = learned_presence.get_model()
    raw = model.raw_features(original, measured, pixels_per_unit=pixels_per_unit)
    correction = learned_presence.readout(raw, model.data)
    features = dict(measured.features)
    features.update(
        learned_raw_cues=raw.tolist(),
        learned_log_correction=correction,
        learned_gate=math.exp(-max(float(raw[2]), 0)),
        base_geometry_presence=features["geometry_presence"],
    )
    features["geometry_presence"] *= math.exp(correction)
    return replace(measured, features=features)


def visibility(icon, scale, display_size=20.0):
    """Bounded blurred-contrast retention in one final rendering context."""
    if (
        not math.isfinite(scale)
        or scale <= 0
        or not math.isfinite(display_size)
        or display_size <= 0
    ):
        raise ValueError("Scale and display size must be finite and positive")
    display_scale = scale * display_size / FRAME
    terms = []
    for sigma, weight in BLUR_SCALES:
        exponent = -4 * math.pi**2 * (sigma / display_scale) ** 2 * icon.frequency_squared
        retained = float(np.dot(icon.spectral_energy, np.exp(exponent)))
        terms.append(weight * max(min(retained, 1.0), 1e-15))
    return sum(terms)


def presence(icon, scale):
    """Strictly increasing length score with a bounded, shared contrast cue."""
    log_visibility = sum(math.log(visibility(icon, scale, size)) for size in DISPLAY_SIZES) / len(
        DISPLAY_SIZES
    )
    return (
        scale * icon.features["geometry_presence"] * math.exp(CONTRAST_CUE_WEIGHT * log_visibility)
    )


def reference_target(*, pixels_per_unit=PIXELS_PER_UNIT):
    """A synthetic disk fixes overall size without depending on a catalog member."""
    if pixels_per_unit != PIXELS_PER_UNIT:
        raise ValueError("The fixed icon model requires 32 geometry samples per unit")
    disk = _measure_geometry(learned_presence.REFERENCE_SOURCE, pixels_per_unit=pixels_per_unit)
    learned_presence.get_model().verify_reference_geometry(disk)
    return presence(disk, REFERENCE_DIAMETER / FRAME)


def sizing(icon, target):
    if not math.isfinite(target) or target <= 0:
        raise ValueError("Presence target must be finite and positive")
    safe_scale = MAX_EXTENT / FRAME
    limited = presence(icon, safe_scale) < target
    if limited:
        canonical_scale = safe_scale
    else:
        low, high = 0.0, safe_scale
        for _ in range(SOLVER_STEPS):
            mid = (low + high) / 2
            if presence(icon, mid) < target:
                low = mid
            else:
                high = mid
        canonical_scale = (low + high) / 2
    scale = canonical_scale * icon.source_to_canonical
    x0, y0, x1, y1 = icon.source_bounds
    achieved = presence(icon, canonical_scale)
    return dict(
        scale=scale,
        tx=FRAME / 2 - scale * (x0 + x1) / 2,
        ty=FRAME / 2 - scale * (y0 + y1) / 2,
        extent=canonical_scale * FRAME,
        target_presence=target,
        presence=achieved,
        relative_presence_residual=achieved / target - 1,
        limited=limited,
        canonical_scale=canonical_scale,
        ink_area=icon.features["ink_area"] * canonical_scale**2,
        visibility={
            str(int(size)): visibility(icon, canonical_scale, size) for size in DISPLAY_SIZES
        },
        source_bounds=list(icon.source_bounds),
        features=icon.features,
    )


def _retained_metrics(icon, metrics, transform):
    """Keep subprecision changes only when the saved drawing remains contained."""
    scale, tx, ty = transform
    x0, y0, x1, y1 = icon.source_bounds
    displacement = max(
        math.hypot(
            (scale - metrics["scale"]) * x + tx - metrics["tx"],
            (scale - metrics["scale"]) * y + ty - metrics["ty"],
        )
        for x in (x0, x1)
        for y in (y0, y1)
    )
    margin = (FRAME - MAX_EXTENT) / 2
    bounds = (scale * x0 + tx, scale * y0 + ty, scale * x1 + tx, scale * y1 + ty)
    if (
        displacement > TRANSFORM_TOLERANCE
        or min(bounds[:2]) < margin - BOUNDS_EPSILON
        or max(bounds[2:]) > FRAME - margin + BOUNDS_EPSILON
    ):
        return None
    canonical_scale = scale / icon.source_to_canonical
    achieved = presence(icon, canonical_scale)
    return dict(
        metrics,
        scale=scale,
        tx=tx,
        ty=ty,
        extent=canonical_scale * FRAME,
        presence=achieved,
        relative_presence_residual=achieved / metrics["target_presence"] - 1,
        canonical_scale=canonical_scale,
        ink_area=icon.features["ink_area"] * canonical_scale**2,
        visibility={
            str(int(size)): visibility(icon, canonical_scale, size) for size in DISPLAY_SIZES
        },
    )


def adjust_icon_size(source, target=None, *, pixels_per_unit=PIXELS_PER_UNIT):
    original, previous = split_optical_adjustment(source)
    if target is None:
        target = reference_target(pixels_per_unit=pixels_per_unit)
    icon = measure(original, pixels_per_unit=pixels_per_unit)
    metrics = sizing(icon, target)
    if previous is not None:
        retained = _retained_metrics(icon, metrics, previous)
        if retained is not None:
            return source, retained
    return wrap(original, metrics["scale"], metrics["tx"], metrics["ty"]), metrics


def _write_batch(changes):
    """Stage every file, detect concurrent edits, then replace with rollback."""
    staged, written = [], []
    try:
        for path, expected, output in changes:
            path.parent.mkdir(parents=True, exist_ok=True)
            descriptor, temporary = tempfile.mkstemp(
                prefix=f".{path.name}.", suffix=".tmp", dir=path.parent
            )
            with os.fdopen(descriptor, "wb") as stream:
                stream.write(output)
            if path.exists():
                os.chmod(temporary, path.stat().st_mode & 0o777)
            staged.append((path, expected, output, Path(temporary)))
        for path, expected, _, _ in staged:
            actual = path.read_bytes() if path.exists() else None
            if actual != expected:
                raise RuntimeError(f"File changed during optical size adjustment: {path}")
        for path, expected, output, temporary in staged:
            os.replace(temporary, path)
            written.append((path, expected, output))
    except BaseException:
        for path, previous, output in reversed(written):
            if path.exists() and path.read_bytes() == output:
                if previous is None:
                    path.unlink()
                else:
                    path.write_bytes(previous)
        raise
    finally:
        for _, _, _, temporary in staged:
            temporary.unlink(missing_ok=True)


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", type=Path, default=ICONS, help="Directory of 20px SVG frames")
    parser.add_argument("--output-dir", type=Path, help="Write a separate candidate directory")
    parser.add_argument(
        "--check", action="store_true", help="Check exact output without writing SVGs"
    )
    parser.add_argument(
        "--report", type=Path, help="Write measurements and model provenance as JSON"
    )
    parser.add_argument(
        "--pixels-per-unit",
        type=int,
        default=PIXELS_PER_UNIT,
        choices=(32,),
        help="Fixed model geometry sampling density",
    )
    parser.add_argument("--jobs", type=int, default=4, help="Parallel icon measurements (1–8)")
    args = parser.parse_args(argv)
    if not 1 <= args.jobs <= 8:
        parser.error("--jobs must be between 1 and 8")
    if args.check and args.output_dir:
        parser.error("--check and --output-dir are mutually exclusive")
    source_dir = args.input.expanduser().resolve()
    paths = sorted(source_dir.glob("*.svg"))
    if not paths:
        parser.error(f"No SVGs in {source_dir}")
    destination = args.output_dir.expanduser().resolve() if args.output_dir else source_dir
    if args.report and args.report.expanduser().resolve().suffix.lower() != ".json":
        parser.error("--report must be a JSON file")

    def process(path):
        original_bytes = input_bytes[path.name]
        source = original_bytes.decode("utf-8")
        output, metrics = adjust_icon_size(source, target, pixels_per_unit=args.pixels_per_unit)
        metrics["source_sha256"] = hashlib.sha256(unwrap(source).encode()).hexdigest()
        metrics["output_sha256"] = hashlib.sha256(output.encode()).hexdigest()
        return path.name, original_bytes, output.encode(), metrics

    try:
        input_bytes = {path.name: path.read_bytes() for path in paths}
        expected_outputs = {
            path.name: input_bytes[path.name]
            if destination == source_dir
            else (
                (destination / path.name).read_bytes()
                if (destination / path.name).exists()
                else None
            )
            for path in paths
        }
        report_path = args.report.expanduser().resolve() if args.report else None
        expected_report = report_path.read_bytes() if report_path and report_path.exists() else None
        target = reference_target(pixels_per_unit=args.pixels_per_unit)
        with ThreadPoolExecutor(max_workers=args.jobs) as pool:
            results = list(pool.map(process, paths))
        changes = []
        for name, _, output, _ in results:
            path = destination / name
            expected = expected_outputs[name]
            if expected != output:
                changes.append((path, expected, output))
        writes = [] if args.check else list(changes)
        if report_path:
            report = dict(
                model=MODEL_VERSION,
                renderer=RENDERER_VERSION,
                packages={
                    name: importlib.metadata.version(name) for name in MODEL_DATA["packages"]
                },
                learned_model=dict(
                    parameters=MODEL_DATA,
                    parameters_sha256=learned_presence.digest_file(learned_presence.MODEL_PATH),
                    formula="P(s) = P_base(s) * exp(bound * gate * tanh(standardized_polynomial_cues dot coefficients))",
                    inference="Verified local weights; no downloads or fitting during optical size adjustment.",
                ),
                input_directory=str(source_dir),
                output_directory=str(destination),
                pixels_per_unit=args.pixels_per_unit,
                target_presence=target,
                reference=dict(kind="synthetic disk", diameter=REFERENCE_DIAMETER),
                coefficients=dict(
                    orientation=ORIENTATION_COEFFICIENT,
                    empty_space=EMPTY_SPACE_WEIGHT,
                    contrast_cue=CONTRAST_CUE_WEIGHT,
                    diagonal_extent=DIAGONAL_CUE_WEIGHT,
                ),
                icons={name: metrics for name, _, _, metrics in results},
            )
            report_bytes = (json.dumps(report, indent=2, allow_nan=False) + "\n").encode("utf-8")
            writes.append((report_path, expected_report, report_bytes))
        _write_batch(writes)
    except (ValueError, OSError, RuntimeError) as error:
        parser.exit(2, f"Optical size adjustment failed: {error}\n")
    limited = sum(metrics["limited"] for _, _, _, metrics in results)
    print(
        f"{len(results)} icons; {len(changes)} {'out of date' if args.check else 'updated'}; "
        f"{limited} extent-limited; shared geometry and learned visual model."
    )
    return int(args.check and bool(changes))


if __name__ == "__main__":
    raise SystemExit(main())
