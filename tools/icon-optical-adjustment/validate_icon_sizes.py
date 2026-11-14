#!/usr/bin/env python3
"""Audit optically sized SVG preservation, bounds, determinism and display sampling.

This checks numerical and rendering behavior. It does not certify equal human
perception or recognition. Use render_icon_sizes.py for actual-size comparisons.
"""

from __future__ import annotations

import argparse
import hashlib
import io
import json
import math
import xml.etree.ElementTree as ET
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

import numpy as np
import resvg_py
from adjust_icon_sizes import (
    DISPLAY_SIZES,
    MAX_EXTENT,
    TRANSFORM_TOLERANCE,
    adjust_icon_size,
    measure,
    placement,
    reference_target,
)
from PIL import Image
from svg_measurement import FRAME, render_alpha, split_optical_adjustment, unwrap


def display_samples(source):
    # Serialization is analysis-only. The actual source is never rewritten.
    root = ET.fromstring(source)
    # Standalone SVG roots ignore x/y; nesting must preserve that behavior.
    root.attrib.pop("x", None)
    root.attrib.pop("y", None)
    nested = ET.tostring(root, encoding="unicode")
    results = {}
    for display_size in DISPLAY_SIZES:
        size = int(display_size)
        for dpr in (1, 2, 3):
            areas, peaks = [], []
            for x, y in ((0, 0), (0.5, 0), (0, 0.5), (0.5, 0.5)):
                side = size + 8
                document = (
                    f'<svg xmlns="http://www.w3.org/2000/svg" width="{side * dpr}" '
                    f'height="{side * dpr}" viewBox="-4 -4 {side} {side}">'
                    f'<g transform="translate({x / dpr} {y / dpr}) scale({size / 20})">{nested}</g></svg>'
                )
                image = Image.open(
                    io.BytesIO(resvg_py.svg_to_bytes(svg_string=document, skip_system_fonts=True))
                ).convert("RGBA")
                alpha = np.asarray(image)[..., 3].astype(float) / 255
                areas.append(float(alpha.sum() / dpr**2))
                peaks.append(float(alpha.max()))
            results[f"{size}px@{dpr}x"] = dict(
                ink_areas=areas,
                peak_alpha=peaks,
                visible=all(area > 0 for area in areas),
                relative_area_range=float((max(areas) - min(areas)) / np.mean(areas))
                if np.mean(areas) > 0
                else None,
            )
    return results


def audit(original_path, adjusted_path, target, pixels_per_unit=32):
    original = original_path.read_bytes().decode("utf-8")
    output = adjusted_path.read_bytes().decode("utf-8")
    source_preserved = unwrap(original) == unwrap(output)
    repeated, metrics = adjust_icon_size(output, target, pixels_per_unit=pixels_per_unit)
    raster = render_alpha(output, pixels_per_unit=64)
    bounds = raster.bounds
    # Check the serialized placement against freshly measured authored geometry.
    # This verifies the model's export contract, not human perceptual agreement.
    authored, transform = split_optical_adjustment(output)
    scale, tx, ty = transform or (1.0, 0.0, 0.0)
    measured = measure(authored, pixels_per_unit=pixels_per_unit)
    expected = placement(measured, scale)
    placement_residual = [tx - expected["tx"], ty - expected["ty"]]
    placement_error = math.hypot(*placement_residual)
    x0, y0, x1, y1 = measured.source_bounds
    geometric_midpoint = [scale * (x0 + x1) / 2 + tx, scale * (y0 + y1) / 2 + ty]
    margin = (FRAME - MAX_EXTENT) / 2
    contained = min(bounds[:2]) >= margin - 1 / 64 and max(bounds[2:]) <= FRAME - margin + 1 / 64
    contexts = display_samples(output)
    return dict(
        source_preserved=source_preserved,
        idempotent=repeated == output,
        optically_placed=placement_error <= TRANSFORM_TOLERANCE,
        geometric_midpoint=geometric_midpoint,
        placement_offset=[coordinate - FRAME / 2 for coordinate in geometric_midpoint],
        desired_placement_offset=expected["desired_placement_offset"],
        placement_limited=expected["placement_limited"],
        placement_residual=placement_residual,
        placement_error=placement_error,
        contained=contained,
        visible_bounds=list(bounds),
        extent=metrics["extent"],
        limited=metrics["limited"],
        relative_presence_residual=metrics["relative_presence_residual"],
        source_sha256=hashlib.sha256(unwrap(original).encode()).hexdigest(),
        adjusted_sha256=hashlib.sha256(output.encode()).hexdigest(),
        display_samples=contexts,
        all_contexts_visible=all(c["visible"] for c in contexts.values()),
        maximum_phase_area_range=max((c["relative_area_range"] or 0) for c in contexts.values()),
    )


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", type=Path, required=True)
    parser.add_argument("--adjusted", type=Path, required=True)
    parser.add_argument("--report", type=Path, required=True)
    parser.add_argument("--jobs", type=int, default=4)
    parser.add_argument(
        "--pixels-per-unit",
        type=int,
        choices=(32,),
        default=32,
        help="Match the geometry density used to generate the candidate",
    )
    args = parser.parse_args(argv)
    if not 1 <= args.jobs <= 8:
        parser.error("--jobs must be between 1 and 8")
    paths = sorted(args.input.glob("*.svg"))
    if not paths:
        parser.error("No input SVGs found")
    if {p.name for p in paths} != {p.name for p in args.adjusted.glob("*.svg")}:
        parser.error("Input and adjusted directories must contain exactly the same SVG filenames")
    target = reference_target(pixels_per_unit=args.pixels_per_unit)

    def process(path):
        return path.name, audit(path, args.adjusted / path.name, target, args.pixels_per_unit)

    with ThreadPoolExecutor(max_workers=args.jobs) as pool:
        results = dict(pool.map(process, paths))
    failures = [
        name
        for name, row in results.items()
        if not all(
            row[key]
            for key in (
                "source_preserved",
                "idempotent",
                "optically_placed",
                "contained",
                "all_contexts_visible",
            )
        )
    ]
    report = dict(
        scope=f"Source preservation, deterministic generation, model optical placement and contained {MAX_EXTENT:g}px bounds; {len(DISPLAY_SIZES) * 12} raster contexts per icon. Not a human perceptual test.",
        count=len(results),
        pixels_per_unit=args.pixels_per_unit,
        failed=failures,
        extent_limited=sum(row["limited"] for row in results.values()),
        placement_limited=sum(row["placement_limited"] for row in results.values()),
        maximum_placement_error=max(row["placement_error"] for row in results.values()),
        maximum_phase_area_range=max(row["maximum_phase_area_range"] for row in results.values()),
        icons=results,
    )
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2, allow_nan=False) + "\n", encoding="utf-8")
    print(
        f"{len(results)} icons, {len(results) * len(DISPLAY_SIZES) * 12} display samples; {len(failures)} contract failures; "
        f"{report['extent_limited']} extent-limited; {report['placement_limited']} placement-limited."
    )
    return int(bool(failures))


if __name__ == "__main__":
    raise SystemExit(main())
