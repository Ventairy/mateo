"""Generate the rounded-shape fixtures and usage-facing reference drawings."""

import json
from pathlib import Path

from reference import COEFFICIENTS, axis_parameters, effective_radius, outline, segment_point, svg_path, top_right_segments


ROOT = Path(__file__).resolve().parents[2]
OUTPUT = ROOT / "design-system/foundation/assets/rounded-shape"
# Foundation colors from design-system/foundation/color-palette.md.
ACCENT = "#4A5CFF"
BLACK = "#000000"
WHITE = "#FFFFFF"
CASES = [
    (500, 500, 72), (500, 500, 160), (500, 500, 180), (500, 500, 200),
    (220, 220, 46), (220, 220, 80), (220, 220, 110), (96, 96, 24),
    (96, 96, 48), (96, 96, 999), (360, 180, 32), (360, 420, 42),
    (300, 50, 25), (65, 50, 25), (50, 65, 25), (50, 50, 25),
    (50, 50, 0), (400, 232, 153), (0.001, 0.002, 0.0001),
]


def fixture(width, height, radius, origin=(0, 0)):
    r = effective_radius(width, height, radius)
    item = dict(width=width, height=height, requestedRadius=radius,
                effectiveRadius=r, origin=list(origin),
                elements=outline(width, height, radius, origin))
    if r:
        item["axes"] = {name: axis_parameters(d, r) for name, d in (("x", width), ("y", height))}
        segments = top_right_segments(width, height, r)
        for segment in segments:
            segment["points"] = [[x + origin[0], y + origin[1]] for x, y in segment["points"]]
            if segment["kind"] == "A":
                x, y = segment["center"]
                segment["center"] = [x + origin[0], y + origin[1]]
        item["topRightSegments"] = segments
        item["topRightSamples"] = [
            dict(segment=index, t=t, point=list(segment_point(segment, t)))
            for index, segment in enumerate(segments)
            for t in (0.0, 0.125, 0.5, 0.875, 1.0)
        ]
    return item


def fixtures():
    return dict(
        specification="Mateo rounded shape 2",
        coordinates="positive x right, positive y down; clockwise",
        precision="binary64 or higher",
        coefficients=COEFFICIENTS,
        cases=[fixture(*case) for case in CASES] + [fixture(360, 180, 32, (17, -25))],
    )


def document(width, height, title, body):
    return (
        f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {width} {height}" '
        f'role="img" aria-label="{title}"><title>{title}</title>'
        f'<rect width="100%" height="100%" fill="{WHITE}"/>'
        '<style>text{font-family:Inter,system-ui,sans-serif;font-size:14px;'
        f'fill:{BLACK}'
        '}.heading{font-size:24px;font-weight:500}.note{font-size:13px}</style>'
        + "".join(body) + '</svg>\n'
    )


def drawings():
    body = [
        '<text x="32" y="40" class="heading">Mateo rounded shape</text>',
        '<text x="32" y="68" class="note">One construction for rounded rectangles, pills, and circles. Shapes are drawn at their stated dimensions.</text>',
    ]
    placements = [
        (32, 122, 220, 220, 46), (340, 122, 220, 220, 80), (648, 122, 220, 220, 110),
        (32, 440, 360, 180, 32), (520, 440, 300, 50, 25),
        (520, 574, 65, 50, 25), (706, 574, 50, 50, 25),
    ]
    for x, y, width, height, radius in placements:
        body.append(f'<text x="{x}" y="{y - 22}">{width} × {height} · radius {radius}</text>')
        body.append(f'<path d="{svg_path(outline(width, height, radius))}" '
                    f'transform="translate({x} {y})" fill="{ACCENT}"/>')
    reference = document(900, 682, "Mateo rounded rectangles, pills, and exact circles", body)

    body = [
        '<text x="32" y="40" class="heading">Soft shoulders meet a circular arc</text>',
        '<text x="32" y="68" class="note">Dashed lines connect cubic controls. Filled dots mark the endpoints of each piece.</text>',
    ]
    for x, width, height, radius, label in [
        (64, 500, 500, 100, "Unfitted corner"),
        (520, 200, 360, 100, "Horizontal shoulder collapsed"),
    ]:
        segments = top_right_segments(width, height, radius)
        scale, y = 1.4, 154
        first_x = segments[0]["points"][0][0]
        transform = lambda p: (x + (p[0] - first_x) * scale, y + p[1] * scale)
        body.append(f'<text x="{x - 32}" y="112">{label}</text>')
        body.append(f'<text x="{x - 32}" y="134" class="note">{width} × {height} · radius {radius}</text>')
        for segment in segments:
            points = [transform(p) for p in segment["points"]]
            if segment["kind"] == "C":
                polygon = "M" + " L".join(f"{px},{py}" for px, py in points)
                command = dict(kind="C", points=points[1:])
            else:
                command = dict(kind="A", radius=radius * scale, points=[points[-1]])
            path = [dict(kind="M", points=[points[0]]), command]
            body.append(f'<path d="{svg_path(path)}" fill="none" stroke="{ACCENT}" stroke-width="3"/>')
            if segment["kind"] == "C":
                body.append(f'<path d="{polygon}" fill="none" stroke="{BLACK}" stroke-opacity=".7" '
                            'stroke-width="1.5" stroke-dasharray="4 4"/>')
            for i, (px, py) in enumerate(points):
                endpoint = i == 0 or i == len(points) - 1
                body.append(f'<circle cx="{px}" cy="{py}" r="3.5" '
                            f'fill="{ACCENT if endpoint else WHITE}" stroke="{ACCENT}"/>')
        arc = next(s for s in segments if s["kind"] == "A")
        for point, label in [(arc["points"][0], "T₃"), (arc["points"][-1], "R₀")]:
            px, py = transform(point)
            dx, dy = (-26, 18) if label == "T₃" and segments[0]["kind"] == "A" else (12, -10)
            body.append(f'<text x="{px + dx}" y="{py + dy}">{label}</text>')
        ex, ey = (radius * axis_parameters(d, radius)["extent"] for d in (width, height))
        body.append(f'<text x="{x - 32}" y="448" class="note">Horizontal extent {ex:.3f} · vertical extent {ey:.3f}</text>')
    construction = document(900, 480, "Cubic shoulders joined to an exact circular arc", body)
    return {"reference.svg": reference, "construction.svg": construction}


def write():
    OUTPUT.mkdir(parents=True, exist_ok=True)
    (OUTPUT / "reference.json").write_text(json.dumps(fixtures(), indent=2, allow_nan=False) + "\n")
    for name, content in drawings().items():
        (OUTPUT / name).write_text(content)
    print("Wrote rounded-shape reference fixtures and drawings")
