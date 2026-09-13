"""Generate portable fixtures and usage-facing reference drawings."""
import json
from pathlib import Path
from reference import canonical, curvature_centers, effective_radius, outline, sample, svg_path

OUTPUT = Path(__file__).resolve().parents[2] / 'design-system/foundation/assets/rounded-rectangle'
# Example-specific placement from the rounded-rectangle foundation.
SHEET_BUTTON_CENTER_INSET = 47.42643532355292

COLOR = '#4A5CFF'  # Default accent anchor in the color foundation.
CASES = [(96, 96, 24, 0), (96, 96, 32, 0), (360, 180, 32, 8),
         (360, 420, 42, 0), (96, 96, 999, 0), (96, 96, 0, 0),
         (180, 360, 32, 8), (500, 500, 72, 0)]


def pair(p):
    return [p.real, p.imag]


def fixtures():
    w, cp, c = canonical()
    cases = []
    for width, height, radius, inset in CASES:
        rr = effective_radius(width, height, radius)
        cases.append(dict(width=width, height=height, requestedRadius=radius,
                          effectiveRadius=rr, inset=inset, cornerExtent=c * rr,
                          curvatureCenters=[pair(p) for p in curvature_centers(width, height, radius)]))
    cases[3]['circularButton'] = dict(
        radius=24, center=[360-SHEET_BUTTON_CENTER_INSET, SHEET_BUTTON_CENTER_INSET])
    samples = []
    for i in range(33):
        t = i / 32
        p, tangent, k = sample(t)
        samples.append(dict(t=t, point=pair(p), tangent=pair(tangent), curvature=k))
    return dict(specification='Mateo rounded rectangle 1', coordinates='screen, clockwise',
                svgErrorPerEffectiveRadius=1e-6, cornerExtentPerRadius=c,
                hodograph=[pair(p) for p in w], cornerControls=[pair(p) for p in cp],
                canonicalSamples=samples, cases=cases)


def document(width, height, title, body):
    return (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {width} {height}" '
            f'role="img" aria-label="{title}"><title>{title}</title>'
            '<rect width="100%" height="100%" fill="white"/>'
            '<style>text{font-family:system-ui,sans-serif;fill:#303030;font-size:14px}'
            '.heading{font-size:24px;font-weight:600}.note{font-size:12px;fill:#666}</style>'
            + ''.join(body) + '</svg>\n')


def drawings():
    body = ['<text x="28" y="40" class="heading">Mateo rounded rectangle</text>',
            '<text x="28" y="65" class="note">One flowing corner. The examples below are drawn at their stated dimensions.</text>']
    placements = [(28, 120, 0), (180, 120, 1), (28, 300, 2), (444, 120, 3),
                  (28, 580, 4), (180, 580, 5)]
    for x, y, index in placements:
        w, h, r, d = CASES[index]
        rr = effective_radius(w, h, r)
        label = f'{w} × {h} · radius {r}' + (f' · inset {d}' if d else '')
        body.append(f'<text x="{x}" y="{y-17}">{label}</text>')
        body.append(f'<path d="{svg_path(outline(w,h,r))}" transform="translate({x},{y})" fill="{COLOR}"/>')
        if d:
            body.append(f'<path d="{svg_path(outline(w,h,r,d))}" transform="translate({x},{y})" fill="white"/>')
        if index == 3:
            p = complex(w-SHEET_BUTTON_CENTER_INSET, SHEET_BUTTON_CENTER_INSET)
            body.append(f'<circle cx="{x+p.real}" cy="{y+p.imag}" r="24" fill="white"/>')
            body.append(f'<text x="{x}" y="{y+h+24}" class="note">Circular button: radius 24. Positioned for an even gap.</text>')
        if r != rr:
            body.append(f'<text x="{x}" y="{y+h+24}" class="note">Effective radius {rr:.6f}</text>')
    reference = document(840, 735, 'Mateo rounded rectangles, inset card, and sheet', body)

    c = canonical()[2]
    points = [sample(i / 512) for i in range(513)]
    arc = [0.0]
    for a, b in zip(points, points[1:]):
        arc.append(arc[-1] + abs(b[0] - a[0]))
    body = ['<text x="28" y="40" class="heading">A single curvature peak</text>',
            '<text x="28" y="65" class="note">The corner joins straight sides with zero curvature, without a circular middle.</text>']
    path = 'M' + ' L'.join(f'{50+240*p.real},{110+240*p.imag}' for p, _, _ in points)
    body.append(f'<path d="M28 110H50 L{path[1:]} V375" fill="none" stroke="{COLOR}" stroke-width="2"/>')
    for p, tangent, k in points[::16]:
        a = complex(50, 110) + 240 * p
        b = a - 1j * tangent * k / c * 45
        body.append(f'<path d="M{a.real},{a.imag}L{b.real},{b.imag}" stroke="{COLOR}" stroke-width="1"/>')
    body.append('<path d="M390 105V350H805" fill="none" stroke="#888"/>')
    plot = 'M' + ' L'.join(f'{390+400*s/arc[-1]},{350-210*k/c}' for s, (_, _, k) in zip(arc, points))
    body.append(f'<path d="{plot}" fill="none" stroke="{COLOR}" stroke-width="2"/>')
    body.extend(['<text x="365" y="145" class="note">1/r</text>',
                 '<text x="375" y="355" class="note">0</text>',
                 '<text x="420" y="385" class="note">Distance along the corner, normalized from 0 to 1</text>'])
    return {'reference.svg': reference,
            'curvature.svg': document(840, 420, 'Rounded-rectangle corner and its curvature distribution', body)}


def main():
    OUTPUT.mkdir(parents=True, exist_ok=True)
    (OUTPUT / 'reference.json').write_text(json.dumps(fixtures(), indent=2, allow_nan=False) + '\n')
    for name, text in drawings().items():
        (OUTPUT / name).write_text(text)
    print(f'Wrote rounded-rectangle references to {OUTPUT}')


if __name__ == '__main__':
    main()
