"""Write the capsule's portable fixtures and SVG reference drawings."""

import json
import math
from pathlib import Path

from reference import adaptation, bezier, derivative, outline, quarter, svg_path

ROOT = Path(__file__).resolve().parents[2]
OUTPUT = ROOT / "design-system/foundation/assets/capsule"
# Mateo's default accent anchor in design-system/foundation/color-palette.md.
CAPSULE_COLOR = "#4A5CFF"


def document(width, height, body, title):
    return (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {width} {height}" '
            f'role="img" aria-label="{title}"><title>{title}</title>'
            f'<rect width="{width}" height="{height}" fill="white"/>'
            '<style>text{font-family:system-ui,sans-serif;fill:#303030;font-size:14px}'
            '.heading{font-size:24px;font-weight:600}.note{fill:#666;font-size:12px}</style>'
            + "".join(body) + '</svg>\n')


def main():
    OUTPUT.mkdir(parents=True, exist_ok=True)
    ratios = (1.0, 1.15, 1.35, 1.6, 2.0, 3.5, 8.0)
    cases = []
    for height in (40.0, 48.0, 56.0):
        for ratio in ratios:
            width = ratio * height
            segments, curves = outline(width, height)
            cases.append(dict(width=width, height=height, aspectRatio=ratio,
                              referenceRatio=adaptation(ratio), quarter=segments, cubics=curves))
    segments, curves = outline(48.0, 120.0)
    cases.append(dict(width=48.0, height=120.0, aspectRatio=2.5,
                      referenceRatio=2.5, quarter=segments, cubics=curves))
    (OUTPUT / "reference.json").write_text(json.dumps(dict(
        specification="Mateo capsule 1", coordinates="screen, origin at top left",
        conversionErrorPerShortSide=1.0 / 4800.0, cases=cases), indent=2, allow_nan=False) + "\n")

    width = round(144 + sum(ratio * 56 + 24 for ratio in ratios))
    body = ['<text x="28" y="40" class="heading">Mateo capsule</text>',
            '<text x="28" y="65" class="note">One continuous outline, shown at actual control heights.</text>']
    x = 140.0
    for ratio in ratios:
        cell_width = ratio * 56
        body.append(f'<text x="{x + cell_width / 2}" y="106" text-anchor="middle">{ratio:g}:1</text>')
        for row, height in enumerate((40.0, 48.0, 56.0)):
            _, curves = outline(ratio * height, height)
            px = x + (cell_width - ratio * height) / 2
            py = 126 + row * 92 + (56 - height) / 2
            body.append(f'<path d="{svg_path(curves)}" transform="translate({px},{py})" fill="{CAPSULE_COLOR}"/>')
        x += cell_width + 24
    for row, height in enumerate((40, 48, 56)):
        body.append(f'<text x="28" y="{160 + row * 92}">Height {height}</text>')
    (OUTPUT / "reference.svg").write_text(document(width, 380, body, "Mateo capsules across proportions and control heights"))

    body = ['<text x="28" y="38" class="heading">Curvature and joins</text>',
            '<text x="28" y="63" class="note">Ticks follow outward normals. Their lengths show curvature; dots mark segment joins.</text>']
    for index, ratio in enumerate((1.0, 1.35, 2.0, 3.5, 8.0)):
        segments = quarter(adaptation(ratio))
        extension = ratio - adaptation(ratio)
        stretch = 1.0
        scale, ox, oy = 63.0, 55.0 + (index % 4) * 285 + extension * 63.0, 245.0 + (index // 4) * 200
        if extension:
            body.append(f'<path d="M {ox-extension*scale},{oy-scale} H {ox}" '
                        f'fill="none" stroke="{CAPSULE_COLOR}" stroke-width="2"/>')
        body.append(f'<text x="{ox}" y="{100 + (index // 4) * 200}">{ratio:g}:1</text>')
        positions = []
        for segment in segments:
            if segment["kind"] == "bezier":
                points = segment["points"]
                velocities = derivative(points)
                accelerations = derivative(velocities)
                for i in range(51):
                    t = i / 50
                    p, v, acc = bezier(points, t), bezier(velocities, t), bezier(accelerations, t)
                    positions.append((p, v, acc))
            elif segment["kind"] == "arc":
                c, r, start, end = (segment[key] for key in ("center", "radius", "start", "end"))
                for i in range(51):
                    angle = start + (end - start) * i / 50
                    positions.append(((c[0] + r * math.cos(angle), c[1] + r * math.sin(angle)),
                                      (math.sin(angle), -math.cos(angle)),
                                      (-math.cos(angle) / r, -math.sin(angle) / r)))
            else:
                positions.extend((p, (1.0, 0.0), (0.0, 0.0)) for p in segment["points"])
            p = positions[-1][0]
            body.append(f'<circle cx="{ox + p[0] * stretch * scale}" cy="{oy - p[1] * scale}" r="2" fill="#303030"/>')
        path = "M " + " L ".join(f"{ox + p[0] * stretch * scale},{oy - p[1] * scale}" for p, _, _ in positions)
        body.append(f'<path d="{path}" fill="none" stroke="{CAPSULE_COLOR}" stroke-width="2"/>')
        previous = None
        for p, v, acc in positions:
            p = (p[0] * stretch, p[1])
            if previous and math.dist(previous, p) < 0.075:
                continue
            previous = p
            vx, vy = v[0] * stretch, v[1]
            ax, ay = acc[0] * stretch, acc[1]
            speed = math.hypot(vx, vy)
            if speed < 1e-7:
                continue
            curvature = (vy * ax - vx * ay) / speed ** 3
            end = (p[0] - vy / speed * curvature * 0.3, p[1] + vx / speed * curvature * 0.3)
            body.append(f'<path d="M {ox+p[0]*scale},{oy-p[1]*scale} L {ox+end[0]*scale},{oy-end[1]*scale}" '
                        'stroke="#999" stroke-width="1"/>')
    (OUTPUT / "curvature.svg").write_text(document(1170, 492, body, "Mateo capsule curvature and segment joins"))

    print(f"Wrote {len(cases)} reference cases and two SVG drawings to {OUTPUT}")


if __name__ == "__main__":
    main()
