"""Preserve authored SVG bytes and sample uncropped artwork with resvg.

The supported input is static SVG geometry and embedded PNGs in a fixed 20px
frame, including exported mask-type declarations. Text, external resources,
other CSS, filters, vector effects, and root transforms,
clipping, or masking are excluded; every supported stroke scales with geometry.
Only the temporary analysis document exposes paint outside the root viewport;
authored clip paths and nested viewport clipping remain in effect.
"""

import base64
import binascii
import io
import math
import re
from dataclasses import dataclass, field
from xml.parsers import expat

import numpy as np
import resvg_py
from PIL import Image

FRAME = 20.0
MARKER_ID = "mateo-optical-size"
RENDERER_VERSION = f"resvg_py {resvg_py.__version__} / resvg {resvg_py.__resvg_version__}"
SVG_NAMESPACE = "http://www.w3.org/2000/svg"
MAX_SOURCE_BYTES = 16_000_000
MAX_GEOMETRY_BYTES = 2_000_000
MAX_IMAGE_PIXELS = 16_000_000
MAX_IMAGE_SIDE = 4096
_TAGS = set(
    "svg g defs path rect circle ellipse line polyline polygon clipPath "
    "mask use linearGradient radialGradient stop pattern title desc image".split()
)
_NUMERIC = set(
    "viewBox x y x1 y1 x2 y2 width height cx cy r rx ry d points "
    "transform gradientTransform patternTransform opacity fill-opacity "
    "stroke-opacity stroke-width stroke-miterlimit stroke-dasharray "
    "stroke-dashoffset offset pathLength".split()
)
_NUMBER = re.compile(r"[+-]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?")
_NONFINITE = re.compile(r"(?<![a-z])(?:nan|[+-]?inf(?:inity)?)(?![a-z])", re.I)
_ATTRIBUTE = re.compile(r"""\s+([^\s=]+)\s*=\s*(["'])(.*?)\2""", re.S)
_TAG_END = re.compile(rb"""[^>"']*(?:(?:"[^"]*"|'[^']*')[^>"']*)*>""")


@dataclass
class _Element:
    tag: str
    attributes: dict
    start: int
    opening_end: int
    closing_start: int = 0
    end: int = 0
    children: list = field(default_factory=list)


@dataclass(frozen=True)
class Raster:
    """Rendered coverage and straight sRGB, with bounds in SVG user coordinates."""

    alpha: np.ndarray
    origin: tuple[float, float]
    pixels_per_unit: float
    bounds: tuple[float, float, float, float]
    rgb: np.ndarray

    @property
    def ink_area(self):
        return float(self.alpha.sum() / self.pixels_per_unit**2)


def _tag_end(data, start):
    # Skip quoted payloads in one scan, including multi-megabyte logo images.
    match = _TAG_END.match(data, start)
    if not match:
        raise ValueError("Unterminated SVG tag")
    return match.end()


def _embedded_png_pixels(reference):
    """Validate a self-contained static image before resvg can silently omit it."""
    prefix = "data:image/png;base64,"
    if not reference.startswith(prefix):
        raise ValueError("SVG images require an embedded base64 PNG")
    try:
        payload = base64.b64decode(reference[len(prefix):], validate=True)
        with Image.open(io.BytesIO(payload)) as image:
            if image.format != "PNG" or getattr(image, "n_frames", 1) != 1:
                raise ValueError("SVG images require a static PNG")
            width, height = image.size
            if max(width, height) > MAX_IMAGE_SIDE or width * height > MAX_IMAGE_PIXELS:
                raise ValueError("Embedded PNG exceeds the image pixel limit")
            image.verify()
        with Image.open(io.BytesIO(payload)) as image:
            image.load()
            return width * height
    except (binascii.Error, OSError, SyntaxError, Image.DecompressionBombError) as error:
        raise ValueError(f"Invalid embedded PNG: {error}") from error


def _parse(source):
    if not isinstance(source, str):
        raise ValueError("SVG source must be text")
    data = source.encode("utf-8")
    if len(data) > MAX_SOURCE_BYTES:
        raise ValueError("SVG source exceeds the 16MB source limit")
    parser = expat.ParserCreate(namespace_separator="}")
    stack, elements = [], []
    image_bytes, image_pixels = 0, 0

    def start(name, attributes):
        nonlocal image_bytes, image_pixels
        namespace, _, tag = name.rpartition("}")
        if namespace not in ("", SVG_NAMESPACE) or tag not in _TAGS:
            raise ValueError(f"Unsupported SVG geometry element: {name}")
        if len(stack) >= 64 or len(elements) >= 4096:
            raise ValueError("SVG geometry exceeds nesting or element limits")
        if tag == "image":
            references = [v for k, v in attributes.items() if k.rsplit("}", 1)[-1] == "href"]
            if len(references) != 1:
                raise ValueError("SVG images require exactly one embedded PNG reference")
            image_pixels += _embedded_png_pixels(references[0])
            image_bytes += len(references[0])
            if image_pixels > MAX_IMAGE_PIXELS:
                raise ValueError("SVG images exceed the combined image pixel limit")
        for key, value in attributes.items():
            local = key.rsplit("}", 1)[-1]
            if local == "style" and not (
                tag == "mask"
                and re.fullmatch(r"\s*mask-type\s*:\s*(?:alpha|luminance)\s*;?\s*", value)
            ):
                raise ValueError("CSS is unsupported except an inline mask-type on mask elements")
            if local.lower().startswith("on") or local == "base":
                raise ValueError("CSS, event handlers, and external bases are unsupported")
            if local == "vector-effect" and value != "none":
                raise ValueError("Vector effects are unsupported; strokes must scale with geometry")
            if local == "filter" and value.strip() != "none":
                raise ValueError(
                    "Filters are unsupported; use static geometry without filter effects"
                )
            if local == "href" and tag != "image" and not re.fullmatch(r"#[\w.:-]+", value):
                raise ValueError("Only local SVG fragment references are supported")
            for target in re.findall(r"url\(\s*([^)]+)\)", value, re.I):
                if not re.fullmatch(r"#[\w.:-]+", target.strip(" \t\r\n\"'")):
                    raise ValueError("External SVG resources are unsupported")
            if local in _NUMERIC:
                if _NONFINITE.search(value) or any(
                    not math.isfinite(float(n)) for n in _NUMBER.findall(value)
                ):
                    raise ValueError(f"Nonfinite SVG geometry: {local}")
        node = _Element(
            tag, attributes, parser.CurrentByteIndex, _tag_end(data, parser.CurrentByteIndex)
        )
        if stack:
            stack[-1].children.append(node)
        stack.append(node)
        elements.append(node)

    def end(_name):
        node = stack.pop()
        if data[node.start : node.opening_end].rstrip().endswith(b"/>"):
            node.closing_start, node.end = node.opening_end - 2, node.opening_end
        else:
            node.closing_start = parser.CurrentByteIndex
            node.end = _tag_end(data, node.closing_start)

    def reject(*_args):
        raise ValueError("SVG declarations, entities, and processing instructions are unsupported")

    parser.StartElementHandler, parser.EndElementHandler = start, end
    parser.StartDoctypeDeclHandler = reject
    parser.EntityDeclHandler = reject
    parser.ProcessingInstructionHandler = reject
    try:
        parser.Parse(data, True)
    except expat.ExpatError as error:
        raise ValueError(f"Malformed SVG: {error}") from error
    if len(data) - image_bytes > MAX_GEOMETRY_BYTES:
        raise ValueError("SVG source exceeds the 2MB geometry limit excluding embedded PNGs")
    if not elements or elements[0].tag != "svg":
        raise ValueError("Expected an SVG root")
    root = elements[0]
    for attr in ("width", "height"):
        length = root.attributes.get(attr, "").strip()
        number = length.removesuffix("px")
        if not _NUMBER.fullmatch(number) or float(number) != FRAME:
            raise ValueError("Expected a fixed 20px SVG frame")
    view_box = re.split(r"[\s,]+", root.attributes.get("viewBox", "").strip())
    try:
        valid = tuple(map(float, view_box)) == (0.0, 0.0, FRAME, FRAME)
    except ValueError:
        valid = False
    if not valid or "transform" in root.attributes:
        raise ValueError('Expected viewBox="0 0 20 20" with no root transform')
    if any(root.attributes.get(name, "none").strip() != "none" for name in ("clip-path", "mask")):
        raise ValueError(
            "Root clipping and masking are unsupported; place effects on a child group"
        )
    return data, root, elements


def split_optical_adjustment(source):
    """Return authored SVG and its optional generated (scale, tx, ty) transform."""
    data, root, elements = _parse(source)
    markers = [n for n in elements if n.attributes.get("id") == MARKER_ID]
    if not markers:
        return source, None
    if len(markers) != 1 or root.children != markers or markers[0].tag != "g":
        raise ValueError("Optical size marker must identify the sole root group")
    group = markers[0]
    if set(group.attributes) != {"id", "transform"}:
        raise ValueError("Generated optical size group has unexpected attributes")
    matrix = re.fullmatch(r"matrix\(([^)]+)\)", group.attributes["transform"])
    try:
        values = tuple(map(float, re.split(r"[\s,]+", matrix[1].strip()))) if matrix else ()
    except ValueError:
        values = ()
    if (
        len(values) != 6
        or not all(map(math.isfinite, values))
        or values[0] <= 0
        or values[0] != values[3]
        or values[1:3] != (0, 0)
    ):
        raise ValueError("Generated optical size transform must be a uniform scale and translation")
    if (
        data[root.opening_end : group.start] != b"\n"
        or data[group.end : root.closing_start] != b"\n"
    ):
        raise ValueError("Unexpected generated optical size group placement")
    authored = (
        data[: root.opening_end]
        + data[group.opening_end : group.closing_start]
        + data[root.closing_start :]
    ).decode("utf-8")
    return authored, (values[0], values[4], values[5])


def unwrap(source):
    """Remove only a generated wrapper; retain every authored byte verbatim."""
    return split_optical_adjustment(source)[0]


def wrap(source, scale, tx, ty):
    """Replace the generated transform without altering the authored geometry."""
    if (
        not all(
            isinstance(v, (int, float)) and not isinstance(v, bool) and math.isfinite(v)
            for v in (scale, tx, ty)
        )
        or scale <= 0
        or round(scale, 9) == 0
    ):
        raise ValueError("Transform needs a positive finite scale and finite translation")
    source = unwrap(source)
    data, root, _ = _parse(source)
    if data[root.start : root.opening_end].rstrip().endswith(b"/>"):
        raise ValueError("Cannot optically size an empty SVG root")
    qname = re.match(rb"<([^\s/>]+)", data[root.start :])[1]
    group_name = qname.rsplit(b":", 1)[0] + b":g" if b":" in qname else b"g"
    matrix = f"matrix({scale:.9f} 0 0 {scale:.9f} {tx:.9f} {ty:.9f})"
    opening = b"\n<" + group_name + f' id="{MARKER_ID}" transform="{matrix}">'.encode()
    return (
        data[: root.opening_end]
        + opening
        + data[root.opening_end : root.closing_start]
        + b"</"
        + group_name
        + b">\n"
        + data[root.closing_start :]
    ).decode("utf-8")


def render_alpha(source, *, pixels_per_unit=32, padding=10.0):
    """Sample the source as supplied, preserving percentage geometry's viewport.

    An expanded outer SVG contains the original 20px viewport with visible
    overflow. Unlike enlarging its viewBox, this leaves percentage lengths at
    their original values. Raises if ink reaches the analysis canvas boundary.
    """
    if (
        not isinstance(pixels_per_unit, int)
        or isinstance(pixels_per_unit, bool)
        or not 1 <= pixels_per_unit <= 128
    ):
        raise ValueError("pixels_per_unit must be an integer between 1 and 128")
    if not isinstance(padding, (int, float)) or not math.isfinite(padding) or padding <= 0:
        raise ValueError("Analysis padding must be finite and positive")
    span = FRAME + 2 * padding
    size = round(span * pixels_per_unit)
    if size > 4096:
        raise ValueError("Analysis raster exceeds the 4096px side limit")
    data, root, _ = _parse(source)
    opening = data[root.start : root.opening_end].decode("utf-8")
    # Root x/y have no effect in a standalone source, but would affect nesting.
    opening = _ATTRIBUTE.sub(lambda m: "" if m[1] in ("overflow", "x", "y") else m[0], opening)
    close = "/>" if opening.rstrip().endswith("/>") else ">"
    opening = opening.rstrip()[: -len(close)] + ' x="0" y="0" overflow="visible"' + close
    nested = opening + data[root.opening_end : root.end].decode("utf-8")
    document = (
        f'<svg xmlns="{SVG_NAMESPACE}" width="{size}" height="{size}" '
        f'viewBox="{-padding} {-padding} {span} {span}">{nested}</svg>'
    )
    try:
        png = resvg_py.svg_to_bytes(
            svg_string=document, skip_system_fonts=True, shape_rendering="geometric_precision"
        )
        rgba = np.asarray(Image.open(io.BytesIO(png)).convert("RGBA"))
        alpha = rgba[..., 3].astype(np.float64) / 255
    except (ValueError, OSError) as error:
        raise ValueError(f"SVG rendering failed: {error}") from error
    if alpha.shape != (size, size):
        raise ValueError("Renderer returned unexpected raster dimensions")
    occupied = alpha > 0
    if not occupied.any():
        raise ValueError("Icon has no visible area")
    if occupied[0].any() or occupied[-1].any() or occupied[:, 0].any() or occupied[:, -1].any():
        raise ValueError("Visible geometry reaches the analysis boundary; increase padding")
    xs, ys = np.flatnonzero(occupied.any(axis=0)), np.flatnonzero(occupied.any(axis=1))
    ppu = size / span
    bounds = (
        xs[0] / ppu - padding,
        ys[0] / ppu - padding,
        (xs[-1] + 1) / ppu - padding,
        (ys[-1] + 1) / ppu - padding,
    )
    return Raster(alpha, (-padding, -padding), ppu, tuple(map(float, bounds)), rgba[..., :3])
