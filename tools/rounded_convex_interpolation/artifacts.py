"""Generate portable examples and SVG drawings from the mathematical reference."""
import json
from html import escape
from pathlib import Path
from reference import (INPUT_COUNT, CUBIC_COUNT, RELATIVE_DISPLACEMENT_LIMIT, TURN_BLEND, PREPARED_MINIMUM,
                       evaluate, prepare, reconstruct, prepared_pair)
from geometry import FLATNESS


ROOT = Path(__file__).resolve().parents[2]
OUTPUT = ROOT / 'design-system/foundation/assets/rounded-convex-interpolation'
PROGRESS = [0., .15, .3, .5, .7, .85, 1.]
OVERSHOOT_PROGRESS = [-.1, 0., .25, .5, .75, 1., 1.05, 1.1]
FIXTURE_PROGRESS = sorted(set(PROGRESS+[-.5,-.25,-.1,.25,.75,1.1,1.25,1.5]))
PAIRS = [('triangle', 'hexagon'), ('vertical', 'triangle'),
         ('capsule', 'rounded'), ('rounded', 'circle'),
         ('pentagon', 'capsule'), ('pentagon', 'kite'),
         ('capsule', 'vertical'), ('triangle', 'rectangle')]
ILLUSTRATED_PAIRS = [('triangle', 'hexagon'), ('vertical', 'soft-triangle'),
                    ('capsule', 'rounded'), ('rounded', 'circle'),
                    ('soft-pentagon', 'capsule'), ('soft-pentagon', 'soft-triangle'),
                    ('capsule', 'vertical'), ('soft-triangle', 'rounded')]
ACCENT = '#4A5CFF'


def inputs():
    return json.loads((OUTPUT / 'source-outlines.json').read_text())['shapes']


def prepared(rows):
    return {s['id']: prepare(s['cubics'], s['width'], s['height']) for s in rows}


def pair(p):
    return [p.real, p.imag]


def packed(outline):
    return [[pair(p) for p in c] for c in outline.cubics]


def fixtures(rows, shapes):
    endpoints = []
    for s in rows:
        shape = shapes[s['id']]
        endpoints.append(dict(id=s['id'], label=s['label'], width=shape.width, height=shape.height,
                              anchorAngle=shape.angle, turningGaps=shape.turns, speeds=shape.speeds,
                              arcGaps=shape.spacings, cubics=packed(reconstruct(shape))))
    transitions = []
    for a, b in PAIRS:
        frames = []
        for t in FIXTURE_PROGRESS:
            o = evaluate(shapes[a], shapes[b], t)
            frames.append(dict(progress=t, width=o.width, height=o.height, points=[pair(c[0]) for c in o.cubics]))
        transitions.append(dict(source=a, destination=b, frames=frames))
    return dict(specification='Mateo rounded convex interpolation 6',
                coordinates='Clockwise screen polygon points in centered unit bounds. Endpoint fits retain cubic controls. Multiply x by width and y by height.',
                interpretation='Numerical examples for the documented construction; equivalent native approximations may use different controls.',
                inputIntervals=INPUT_COUNT, endpointFitCubics=CUBIC_COUNT, arcTurnWeight=1,
                outputBendWeight=4, uniformTurningBlend=TURN_BLEND, preparedPositiveMinimum=PREPARED_MINIMUM,
                endpointFlatness=FLATNESS, physicalOutlineLimit=.08, curveOutlineLimit=.02,
                cornerAmount=.36, roundedContribution=.3, movementSamples=257, supportDirections=64,
                relativeDisplacementLimit=RELATIVE_DISPLACEMENT_LIMIT, verifiedProgressRange=[-.5,1.5], endpoints=endpoints, transitions=transitions)


def number(x):
    return f'{x:.9f}'.rstrip('0').rstrip('.') or '0'


def svg_path(outline, cx, cy, scale):
    def point(p):
        return f'{number(cx+p.real*outline.width*scale)},{number(cy+p.imag*outline.height*scale)}'
    return 'M '+' L '.join(point(c[0]) for c in outline.cubics)+' Z'


def document(width, height, title, description, body):
    return ('<svg xmlns="http://www.w3.org/2000/svg" '
            f'viewBox="0 0 {width} {height}" role="img" aria-labelledby="title description">\n'
            f'<title id="title">{escape(title)}</title>\n<desc id="description">{escape(description)}</desc>\n'
            '<rect width="100%" height="100%" fill="white"/>\n'
            '<style>text{font-family:system-ui,sans-serif;fill:#303030;font-size:14px}'
            '.heading{font-size:24px;font-weight:600}.note{font-size:12px;fill:#666}'
            '.label{font-size:16px;font-weight:500}</style>\n'+ '\n'.join(body)+'\n</svg>\n')


def sequence(rows, shapes, pairs, title, progress=PROGRESS):
    labels = {s['id']: s['label'] for s in rows}
    body = [f'<text x="28" y="40" class="heading">{title}</text>',
            '<text x="28" y="65" class="note">One continuous change. Each row keeps a shared scale; progress has no easing.</text>']
    for j, t in enumerate(progress):
        body.append(f'<text x="{100+142*j}" y="101" text-anchor="middle">{round(t*100)}%</text>')
    for i, (a, b) in enumerate(pairs):
        y = 137+180*i
        body.append(f'<text x="28" y="{y}" class="label">{escape(labels[a])} → {escape(labels[b])}</text>')
        frames = [evaluate(shapes[a],shapes[b],t) for t in progress]
        scale = 122/max(max(o.width,o.height) for o in frames)
        for j, o in enumerate(frames):
            body.append(f'<path d="{svg_path(o, 100+142*j, y+80, scale)}" fill="{ACCENT}"/>')
    return document(62+142*len(progress), 144+180*len(pairs), title,
                    'Each row keeps a shared scale at progress '+', '.join(str(round(t*100)) for t in progress)+' percent.', body)


def construction(shapes):
    a, b, t = shapes['soft-triangle'], shapes['soft-hexagon'], .5
    polygon = [complex(p.real/a.width,p.imag/a.height) for p in a.endpoint.compact]
    q = prepared_pair(a,b).frame(t)
    body = ['<text x="28" y="40" class="heading">One outline, with an even pace</text>',
            '<text x="28" y="65" class="note">Rounded triangle → rounded hexagon at 50%. These are calculation steps, not animation phases.</text>']
    centers = [145, 400, 655, 910]
    titles = ['Endpoint outlines', 'Endpoint boundary', 'Rounded transition', 'Fitted outline']
    notes = ['Prepare each shape once', 'Keep the resting shape', 'Corners and sides move together', 'Size follows the supplied progress']
    for cx, title, note in zip(centers, titles, notes):
        body.append(f'<text x="{cx}" y="108" text-anchor="middle" class="label">{title}</text>')
        body.append(f'<text x="{cx}" y="320" text-anchor="middle" class="note">{note}</text>')
    for s, stroke in [(a, '#888'), (b, ACCENT)]:
        body.append(f'<path d="{svg_path(evaluate(s,s,0), centers[0], 213, 160/140)}" fill="none" stroke="{stroke}" stroke-width="2"/>')
    for cx, points in [(centers[1], polygon), (centers[2], q)]:
        coords=' '.join(f'{number(cx+p.real*160)},{number(213+p.imag*160)}' for p in points)
        body.append(f'<polygon points="{coords}" fill="none" stroke="#888" stroke-width="1"/>')

    out = evaluate(a,b,t)
    body.append(f'<path d="{svg_path(out, centers[3], 213, 160/max(out.width,out.height))}" fill="{ACCENT}"/>')
    for x in [267, 522, 777]:
        body.append(f'<text x="{x}" y="218" text-anchor="middle">→</text>')
    return document(1056, 350, 'Construction of a convex interpolation outline',
                    'Prepared endpoint boundaries form one rounded transition, fitted to the current dimensions.', body)


def build():
    rows = inputs()
    shapes = prepared(rows)
    return {'reference.json': json.dumps(fixtures(rows, shapes), separators=(',', ':'), allow_nan=False)+'\n',
            'reference.svg': sequence(rows, shapes, ILLUSTRATED_PAIRS[:4], 'Rounded convex interpolation'),
            'asymmetric.svg': sequence(rows, shapes, ILLUSTRATED_PAIRS[4:6], 'Asymmetric rounded convex interpolation'),
            'overshoot.svg': sequence(rows, shapes, [*ILLUSTRATED_PAIRS[6:],ILLUSTRATED_PAIRS[4]], 'Continuing beyond the endpoints', OVERSHOOT_PROGRESS),
            'construction.svg': construction(shapes)}


def main():
    for name, text in build().items():
        (OUTPUT / name).write_text(text)
    from verify import verify
    verify()


if __name__ == '__main__':
    main()
