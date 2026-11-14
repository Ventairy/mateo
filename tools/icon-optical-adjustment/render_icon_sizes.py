#!/usr/bin/env python3
"""Render static icon and logo comparisons and contact sheets with resvg.

These are review artifacts, not automatic judgments of optical equivalence.
PNG density is explicit: a 20px icon at density2 occupies40 image pixels.
"""

import argparse
import io
import math
from pathlib import Path

import resvg_py
from PIL import Image, ImageDraw, ImageFont
from adjust_icon_sizes import DISPLAY_SIZES


def font(size):
    return ImageFont.load_default(size=size)


def draw_icon(canvas, source, x, y, size, circle, density, context="circle"):
    drawing = ImageDraw.Draw(canvas)
    bounds = (x, y, x + circle * density - 1, y + circle * density - 1)
    if context == "circle":
        drawing.ellipse(bounds, fill="#F5F5F5")
    elif context == "rounded-square":
        drawing.rounded_rectangle(bounds, radius=circle * density / 4, fill="#F5F5F5")
    png = resvg_py.svg_to_bytes(
        svg_string=source,
        width=size * density,
        height=size * density,
        skip_system_fonts=True,
        shape_rendering="geometric_precision",
    )
    tile = Image.open(io.BytesIO(png)).convert("RGBA")
    offset = (circle - size) * density // 2
    canvas.paste(tile, (x + offset, y + offset), tile)


def draw_pairs(directory, pairs, output, label, density):
    column_width, row_height = 184, 118
    canvas = Image.new("RGB", ((56 + len(pairs) * column_width) * density, (100 + len(DISPLAY_SIZES) * row_height) * density), "white")
    drawing = ImageDraw.Draw(canvas)
    drawing.text((20 * density, 14 * density), label, fill="#181818", font=font(20 * density))
    drawing.text(
        (20 * density, 43 * density),
        "Identical button frames / image density " + str(density) + "x",
        fill="#636363",
        font=font(12 * density),
    )
    for row, size in enumerate(DISPLAY_SIZES):
        size = int(size)
        circle = size * 2 + 8
        y = 98 + row * row_height
        drawing.text(
            (10 * density, (y + circle // 2 - 6) * density),
            str(size) + "px",
            fill="#636363",
            font=font(11 * density),
        )
        for column, pair in enumerate(pairs):
            x = 56 + column * column_width
            for index, name in enumerate(pair):
                source = (directory / (name + ".svg")).read_bytes().decode("utf-8")
                draw_icon(
                    canvas, source, (x + index * 80) * density, y * density, size, circle, density
                )
            drawing.text(
                (x * density, (y + circle + 8) * density),
                " / ".join(pair),
                fill="#636363",
                font=font(10 * density),
            )
    canvas.save(output / "key-pairs.png")


def draw_comparisons(paths, before, output, label, density):
    """Review one icon in fixed, matching frames without enlarged artwork."""
    contexts = (("bare", "Bare"), ("circle", "Circle"), ("rounded-square", "Rounded square"))
    column_width, row_height = 88, 108
    for path in paths:
        sources = ((before / path.name).read_text(encoding="utf-8"), path.read_text(encoding="utf-8"))
        canvas = Image.new(
            "RGB", (600 * density, (112 + len(DISPLAY_SIZES) * row_height) * density), "white"
        )
        drawing = ImageDraw.Draw(canvas)
        drawing.text((20 * density, 14 * density), f"{label}: {path.stem}", fill="#181818", font=font(18 * density))
        drawing.text(
            (20 * density, 42 * density),
            f"Before / after in identical frames · image density {density}x",
            fill="#636363", font=font(12 * density),
        )
        for column, (_, title) in enumerate(contexts):
            x = 64 + column * column_width * 2
            drawing.text((x * density, 68 * density), title, fill="#181818", font=font(12 * density))
            for index, caption in enumerate(("Before", "After")):
                drawing.text(
                    ((x + index * column_width) * density, 88 * density),
                    caption, fill="#636363", font=font(11 * density),
                )
        for row, size in enumerate(DISPLAY_SIZES):
            size = int(size)
            frame = size * 2 + 8
            y = 114 + row * row_height
            drawing.text(
                (12 * density, (y + frame / 2 - 6) * density),
                f"{size}px", fill="#636363", font=font(11 * density),
            )
            for column, (context, _) in enumerate(contexts):
                for index, source in enumerate(sources):
                    x = 64 + (column * 2 + index) * column_width
                    draw_icon(canvas, source, x * density, y * density, size, frame, density, context)
        canvas.save(output / f"placement-{path.stem}.png")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--label", default="Optically sized icons")
    parser.add_argument("--size", type=int, choices=tuple(map(int, DISPLAY_SIZES)), default=20)
    parser.add_argument("--density", type=int, choices=(1, 2, 3), default=2)
    parser.add_argument("--columns", type=int, default=6)
    parser.add_argument("--per-page", type=int, default=36)
    parser.add_argument("--before", type=Path, help="Compare original SVGs with --input in bare, circular and rounded-square frames")
    parser.add_argument("--icon", action="append", help="Limit --before comparisons to this icon name; repeat for more icons")
    parser.add_argument(
        "--pair",
        action="append",
        metavar="FIRST,SECOND",
        help="Render named review pairs at the model's display sizes instead of a catalog",
    )
    args = parser.parse_args()
    if not 1 <= args.columns <= 12 or not 1 <= args.per_page <= 120:
        parser.error("Use 1–12 columns and 1–120 icons per page")
    paths = sorted(args.input.glob("*.svg"))
    if not paths:
        parser.error("No SVGs found")
    if args.icon and not args.before:
        parser.error("--icon requires --before")
    if args.before:
        if args.pair:
            parser.error("--before and --pair are separate review modes")
        if args.icon:
            names = {path.stem for path in paths}
            if any(name not in names for name in args.icon):
                parser.error("--icon must name an existing input icon without .svg")
            paths = [path for path in paths if path.stem in args.icon]
        if any(not (args.before / path.name).is_file() for path in paths):
            parser.error("--before must contain a matching SVG for every selected input icon")
        args.output_dir.mkdir(parents=True, exist_ok=True)
        draw_comparisons(paths, args.before, args.output_dir, args.label, args.density)
        print(f"{len(paths)} SVGs compared across {len(DISPLAY_SIZES)} sizes and 3 contexts")
        return
    args.output_dir.mkdir(parents=True, exist_ok=True)
    if args.pair:
        pairs = [value.split(",") for value in args.pair]
        names = {path.stem for path in paths}
        if any(len(pair) != 2 or any(name not in names for name in pair) for pair in pairs):
            parser.error("--pair must name two existing icons separated by one comma")
        draw_pairs(args.input, pairs, args.output_dir, args.label, args.density)
        sizes = ", ".join(str(int(size)) for size in DISPLAY_SIZES)
        print(f"{len(pairs)} pairs rendered at {sizes}px")
        return

    density = args.density
    column_width, row_height = 156, 104
    circle = args.size * 2 + 8
    for page, start in enumerate(range(0, len(paths), args.per_page), 1):
        subset = paths[start : start + args.per_page]
        rows = math.ceil(len(subset) / args.columns)
        canvas = Image.new(
            "RGB",
            (args.columns * column_width * density, (72 + rows * row_height) * density),
            "white",
        )
        drawing = ImageDraw.Draw(canvas)
        drawing.text(
            (20 * density, 14 * density), args.label, fill="#181818", font=font(20 * density)
        )
        drawing.text(
            (20 * density, 43 * density),
            f"{args.size}px artwork / {circle}px circles / image density {density}x / page {page}",
            fill="#636363",
            font=font(12 * density),
        )
        for index, path in enumerate(subset):
            x = (index % args.columns) * column_width
            y = 72 + (index // args.columns) * row_height
            draw_icon(
                canvas,
                path.read_bytes().decode("utf-8"),
                (x + (column_width - circle) // 2) * density,
                y * density,
                args.size,
                circle,
                density,
            )
            # Labels never enter any optical size decision.
            words = path.stem.replace("__", " / ").replace("--", " / ").replace("-", " ").split()
            lines = [""]
            for word in words:
                trial = (lines[-1] + " " + word).strip()
                if len(trial) > 23 and lines[-1]:
                    lines.append(word)
                else:
                    lines[-1] = trial
            for line_index, line in enumerate(lines[:3]):
                drawing.text(
                    ((x + 8) * density, (y + circle + 6 + line_index * 13) * density),
                    line,
                    fill="#636363",
                    font=font(11 * density),
                )
        canvas.save(args.output_dir / f"catalog-{page:02d}.png")
    print(f"{len(paths)} SVGs rendered across {math.ceil(len(paths) / args.per_page)} pages")


if __name__ == "__main__":
    main()
