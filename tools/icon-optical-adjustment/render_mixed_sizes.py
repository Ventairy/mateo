#!/usr/bin/env python3
"""Review icons and authored-color logos together at their display sizes.

Each sheet repeats the complete logo catalog beside a group of representative
icons at 16, 20, 24, and 28px. Light and inverse surfaces each receive bare,
circular, and rounded-square contexts. Optional before catalogs add focused
envelope/Telegram comparisons. The renderer never changes its input files.
"""

import argparse
import io
import math
import xml.etree.ElementTree as ET
from dataclasses import dataclass
from functools import lru_cache
from pathlib import Path

import resvg_py
from PIL import Image, ImageDraw

from render_icon_sizes import DISPLAY_SIZES, font


REPRESENTATIVE_ICONS = (
    "envelope", "circle", "heart", "phone", "gear",
    "three-horizontal-lines", "magnifying-glass", "calendar", "clock", "chevron-left",
    "chevron-down", "running-figure", "praying-figure", "disco-ball", "popcorn",
    "ev-plug", "eraser", "medical-cross", "logout", "numbers",
    "monkey-head", "smartphone", "telegram", "whatsapp", "instagram-logo",
)
CONTEXTS = (("bare", "Bare"), ("circle", "Circle"), ("rounded-square", "Rounded square"))
SURFACES = (
    ("light", "Light", "#FFFFFF", "#F5F5F5", "#181818", "#636363", "#000000"),
    ("inverse", "Inverse", "#202020", "#383838", "#FFFFFF", "#BBBBBB", "#FFFFFF"),
)
ICONS_PER_PAGE = 5


@dataclass(frozen=True)
class Artwork:
    kind: str
    name: str
    source: str
    before: str | None


@lru_cache(maxsize=128)
def _icon_foreground(source, color):
    """Apply a component foreground in memory, leaving masks and clips intact."""
    root = ET.fromstring(source)

    def tint(element):
        tag = element.tag.rsplit("}", 1)[-1]
        if tag in ("mask", "clipPath"):
            return
        for attribute in ("fill", "stroke", "stop-color"):
            value = element.attrib.get(attribute)
            if value is not None and value.strip() != "none" and not value.strip().startswith("url("):
                element.set(attribute, color)
        for child in element:
            tint(child)

    tint(root)
    root.set("color", color)
    if "fill" not in root.attrib:
        root.set("fill", color)
    return ET.tostring(root, encoding="unicode")


@lru_cache(maxsize=512)
def _tile(source, size, density, foreground):
    if foreground is not None:
        source = _icon_foreground(source, foreground)
    png = resvg_py.svg_to_bytes(
        svg_string=source,
        width=size * density,
        height=size * density,
        skip_system_fonts=True,
        shape_rendering="geometric_precision",
    )
    with Image.open(io.BytesIO(png)) as image:
        return image.convert("RGBA")


def _draw_artwork(canvas, artwork, x, y, size, density, context, container_color, foreground, *, before=False):
    frame = size * 2 + 8
    drawing = ImageDraw.Draw(canvas)
    bounds = (round(x * density), round(y * density), round((x + frame) * density) - 1, round((y + frame) * density) - 1)
    if context == "circle":
        drawing.ellipse(bounds, fill=container_color)
    elif context == "rounded-square":
        drawing.rounded_rectangle(bounds, radius=frame * density / 4, fill=container_color)
    source = artwork.before if before else artwork.source
    tile = _tile(source, size, density, foreground if artwork.kind == "Icon" else None)
    offset = (frame - size) * density / 2
    canvas.paste(tile, (round(x * density + offset), round(y * density + offset)), tile)


def _label_lines(drawing, text, width, text_font):
    lines = [""]
    for word in text.replace("-", " ").replace("_", " ").split():
        trial = (lines[-1] + " " + word).strip()
        if lines[-1] and drawing.textlength(trial, font=text_font) > width:
            lines.append(word)
        else:
            lines[-1] = trial
    return lines


def _mixed_sheet(artworks, logo_count, output, density, surface, context, page, pages):
    surface_name, surface_title, background, container, foreground, muted, icon_color = surface
    context_name, context_title = context
    column_width, left, row_height, top = 82, 64, 88, 152
    width = left + column_width * len(artworks) + 16
    height = top + len(DISPLAY_SIZES) * row_height + 28
    canvas = Image.new("RGB", (width * density, height * density), background)
    drawing = ImageDraw.Draw(canvas)
    drawing.text((20 * density, 14 * density), f"Mixed optical sizing · {surface_title} / {context_title}", fill=foreground, font=font(20 * density))
    drawing.text(
        (20 * density, 43 * density),
        f"16, 20, 24, 28px artwork · {density}x image density · group {page}/{pages}",
        fill=muted, font=font(12 * density),
    )
    label_font = font(11 * density)
    for column, artwork in enumerate(artworks):
        x = left + column * column_width
        drawing.text((x * density, 76 * density), artwork.kind, fill=muted, font=label_font)
        for line, text in enumerate(_label_lines(drawing, artwork.name, (column_width - 6) * density, label_font)):
            drawing.text((x * density, (94 + line * 13) * density), text, fill=foreground, font=label_font)
    divider = (left + logo_count * column_width - 9) * density
    drawing.line((divider, 72 * density, divider, (height - 28) * density), fill=container, width=density)
    for row, size in enumerate(DISPLAY_SIZES):
        size = int(size)
        frame = size * 2 + 8
        y = top + row * row_height
        drawing.text((12 * density, (y + 27) * density), f"{size}px", fill=muted, font=font(12 * density))
        for column, artwork in enumerate(artworks):
            x = left + column * column_width + (column_width - frame) / 2
            _draw_artwork(canvas, artwork, x, y + (64 - frame) / 2, size, density, context_name, container, icon_color)
    drawing.text(
        (20 * density, (height - 20) * density),
        "Authored logo colors · component foreground for icons · matching square asset frames",
        fill=muted, font=font(10 * density),
    )
    canvas.save(output / f"mixed-{surface_name}-{context_name}-{page:02d}.png")


def _pair_sheet(envelope, telegram, output, density, surface):
    surface_name, surface_title, background, container, foreground, muted, icon_color = surface
    column_width, left, top, row_height = 288, 64, 152, 96
    width, height = left + len(CONTEXTS) * column_width + 16, top + len(DISPLAY_SIZES) * row_height + 24
    canvas = Image.new("RGB", (width * density, height * density), background)
    drawing = ImageDraw.Draw(canvas)
    drawing.text((20 * density, 14 * density), f"Envelope icon / Telegram logo · {surface_title}", fill=foreground, font=font(20 * density))
    drawing.text((20 * density, 43 * density), f"Before and after in identical frames · {density}x image density", fill=muted, font=font(12 * density))
    for column, (_, title) in enumerate(CONTEXTS):
        x = left + column * column_width
        drawing.text((x * density, 76 * density), title, fill=foreground, font=font(13 * density))
        for stage, caption in enumerate(("Before", "After")):
            stage_x = x + stage * 140
            drawing.text((stage_x * density, 99 * density), caption, fill=muted, font=font(12 * density))
            drawing.text((stage_x * density, 122 * density), "Icon       Logo", fill=muted, font=font(10 * density))
    for row, size in enumerate(DISPLAY_SIZES):
        size = int(size)
        frame = size * 2 + 8
        y = top + row * row_height
        drawing.text((12 * density, (y + 27) * density), f"{size}px", fill=muted, font=font(12 * density))
        for column, (context_name, _) in enumerate(CONTEXTS):
            for stage in range(2):
                for index, artwork in enumerate((envelope, telegram)):
                    x = left + column * column_width + stage * 140 + index * 68 + (64 - frame) / 2
                    _draw_artwork(canvas, artwork, x, y + (64 - frame) / 2, size, density, context_name, container, icon_color, before=stage == 0)
    canvas.save(output / f"envelope-telegram-{surface_name}.png")


def _read_artwork(kind, path, before_directory):
    previous = None
    if before_directory is not None:
        before = before_directory / path.name
        if not before.is_file():
            raise ValueError(f"Before {kind.lower()} catalog is missing {path.name}")
        previous = before.read_text(encoding="utf-8")
    return Artwork(kind, path.stem, path.read_text(encoding="utf-8"), previous)


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--icons", type=Path, required=True, help="Adjusted SVG icon catalog")
    parser.add_argument("--logos", type=Path, required=True, help="Adjusted authored-color SVG logo catalog")
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--before-icons", type=Path)
    parser.add_argument("--before-logos", type=Path)
    parser.add_argument("--density", type=int, choices=(1, 2, 3), default=2)
    args = parser.parse_args(argv)
    if (args.before_icons is None) != (args.before_logos is None):
        parser.error("--before-icons and --before-logos must be supplied together")
    try:
        for directory in (args.icons, args.logos, args.before_icons, args.before_logos):
            if directory is not None and not directory.is_dir():
                raise ValueError(f"Catalog directory does not exist: {directory}")
        # Keep the two catalogs separate even when their SVG filenames match.
        icons = [
            _read_artwork("Icon", args.icons / f"{name}.svg", args.before_icons)
            for name in REPRESENTATIVE_ICONS
            if (args.icons / f"{name}.svg").is_file()
        ]
        logos = [_read_artwork("Logo", path, args.before_logos) for path in sorted(args.logos.glob("*.svg"))]
        if not icons or not logos:
            raise ValueError("Supply at least one representative icon and one SVG logo")
        pair = None
        if args.before_icons is not None:
            envelope = next((artwork for artwork in icons if artwork.name == "envelope"), None)
            telegram = next((artwork for artwork in logos if artwork.name == "telegram"), None)
            if envelope is None or telegram is None:
                raise ValueError("Before/after comparison requires the envelope icon and Telegram logo")
            pair = envelope, telegram
        args.output_dir.mkdir(parents=True, exist_ok=True)
        pages = math.ceil(len(icons) / ICONS_PER_PAGE)
        for surface in SURFACES:
            for context in CONTEXTS:
                for page, start in enumerate(range(0, len(icons), ICONS_PER_PAGE), 1):
                    _mixed_sheet(logos + icons[start:start + ICONS_PER_PAGE], len(logos), args.output_dir, args.density, surface, context, page, pages)
        if pair is not None:
            for surface in SURFACES:
                _pair_sheet(*pair, args.output_dir, args.density, surface)
    except (OSError, ValueError, ET.ParseError) as error:
        parser.exit(2, f"Mixed optical review failed: {error}\n")
    count = pages * len(SURFACES) * len(CONTEXTS) + (2 if args.before_icons else 0)
    print(f"{len(logos)} logos and {len(icons)} representative icons; {count} review sheets at 16, 20, 24, and 28px.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
