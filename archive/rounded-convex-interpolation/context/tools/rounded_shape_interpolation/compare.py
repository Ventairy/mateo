"""Capture the unchanged current engine for the rounded-shape comparison.

All preparation in this file belongs to the OLD comparison lane. The rounded-shape
lane evaluates reference.py or interpolation.js directly from its parameters.
"""
from array import array
from bisect import bisect_right
import gzip
import hashlib
import importlib.util
import json
import math
from pathlib import Path
import sys
import time

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
from tools.rounded_shape_interpolation import reference as new
from tools.rounded_shape import reference as shape

# The incumbent reference uses sibling imports; isolate its public name.
sys.path.insert(0, str(ROOT / 'tools/rounded_convex_interpolation'))
spec = importlib.util.spec_from_file_location('current_convex_reference', ROOT / 'tools/rounded_convex_interpolation/reference.py')
old = importlib.util.module_from_spec(spec)
sys.modules[spec.name] = old
spec.loader.exec_module(old)

CASES = [
    dict(id='pill-panel', label='Pill → panel', a=[144, 48, 24], b=[240, 280, 32], kinds=['new', 'new']),
    dict(id='compact-square', label='Compact → square', a=[96, 96, 48], b=[112, 112, 0], kinds=['new', 'new']),
    dict(id='pill-upright', label='Horizontal → vertical', a=[200, 56, 28], b=[56, 200, 28], kinds=['new', 'new']),
    dict(id='less-rounding', label='Rounded → sharp', a=[144, 96, 16], b=[144, 96, 0], kinds=['new', 'new']),
    dict(id='same-endpoints', label='Surface resize · same inputs', a=[144, 96, 16], b=[240, 280, 32], kinds=['new', 'new']),
    dict(id='same-bounds', label='Corner morph · same inputs', a=[220, 220, 16], b=[220, 220, 60], kinds=['new', 'new']),
]
PROGRESS = [i / 100 for i in range(-20, 121)]
RAYS = 512
QUANTIZATION = 32760
SOURCE_FILES = [
    'tools/rounded_shape/reference.py',
    'tools/rounded_shape_interpolation/reference.py',
    'tools/rounded_shape_interpolation/compare.py',
    'tools/rounded_convex_interpolation/reference.py',
    'tools/rounded_convex_interpolation/geometry.py',
    'tools/rounded_convex_interpolation/motion.py',
]


def source_hashes():
    return {name: hashlib.sha256((ROOT / name).read_bytes()).hexdigest() for name in SOURCE_FILES}


def curves(elements):
    result = []
    for e in elements:
        pts = [complex(x, y) for x, y in e['points']]
        if e['kind'] == 'M':
            p = first = pts[0]
        elif e['kind'] == 'C':
            result.append((p, *pts))
            p = pts[-1]
        elif e['kind'] == 'A':
            center = complex(*e['center'])
            r, start, end = e['radius'], e['startAngle'], e['endAngle']
            for step in range(2):
                lo = start + (end - start) * step / 2
                hi = start + (end - start) * (step + 1) / 2
                q = pts[0] if step == 1 else center + r * complex(math.cos(hi), math.sin(hi))
                handle = 4 / 3 * math.tan((hi - lo) / 4) * r
                result.append((p, p + handle * complex(-math.sin(lo), math.cos(lo)),
                               q - handle * complex(-math.sin(hi), math.cos(hi)), q))
                p = q
        elif e['kind'] == 'L':
            q = pts[0]
            if abs(q - p) > 1e-12:
                result.append((p, p + (q - p) / 3, p + 2 * (q - p) / 3, q))
            p = q
        elif e['kind'] == 'Z' and abs(first - p) > 1e-12:
            result.append((p, p + (first - p) / 3, p + 2 * (first - p) / 3, first))
    return result


def supplied_curves(parameters, kind):
    w, h, r = parameters
    result = curves(shape.outline(w, h, r))
    return [[(p.real / w - .5, p.imag / h - .5) for p in c] for c in result]


def sample_new(frame, steps=64):
    center = complex(frame.width / 2, frame.height / 2)
    return [old.bezier(c, i / steps) - center for c in curves(new.outline(frame)) for i in range(steps)]


def support_values(points, count=128):
    # Brute force deliberately handles duplicate and zero-length edges in old
    # exact-endpoint frames; a rotating-vertex shortcut can stop on a plateau.
    return [max((p.conjugate() * complex(math.cos(2 * math.pi * i / count), math.sin(2 * math.pi * i / count))).real for p in points) for i in range(count)]


def radial(points):
    """Only resample the OLD preview lane; never used by the new evaluator."""
    # The current contour is convex about its center. Sorted vertex angles
    # identify the one boundary edge crossed by a ray without scanning every
    # edge for every preview point. This is offline comparison work only.
    vertices = sorted((math.atan2(p.imag, p.real) % (2 * math.pi), p.real, p.imag) for p in points)
    unique = []
    for angle, x, y in vertices:
        if not unique or angle - unique[-1][0] > 1e-12:
            unique.append((angle, complex(x, y)))
        elif abs(complex(x, y)) > abs(unique[-1][1]):
            unique[-1] = (angle, complex(x, y))
    angles = [row[0] for row in unique]
    result = []
    for i in range(RAYS):
        angle = 2 * math.pi * i / RAYS
        direction = complex(math.cos(angle), math.sin(angle))
        j = bisect_right(angles, angle)
        a, b = unique[j - 1][1], unique[j % len(unique)][1]
        delta = b - a
        denominator = (direction.conjugate() * delta).imag
        if abs(denominator) < 1e-15:
            raise ValueError('Current outline has a degenerate radial edge.')
        distance = (a.conjugate() * delta).imag / denominator
        if not math.isfinite(distance) or distance < 0:
            raise ValueError('Current outline has no radial intersection.')
        result.append(direction * distance)
    return result


def current_points(a, b, t):
    o = old.evaluate(a, b, t)
    return [c[0] for c in o.cubics], o.width, o.height


def build(destination):
    destination.mkdir(parents=True, exist_ok=True)
    all_values = array('h')
    report = []
    for case in CASES:
        start = time.perf_counter()
        a, b = [old.prepare(supplied_curves(parameters, kind), *parameters[:2])
                for parameters, kind in zip((case['a'], case['b']), case['kinds'])]
        pair = old.prepared_pair(a, b)
        prep = time.perf_counter() - start
        maximum, endpoint_error, baseline_error, midpoint_error, interior_error = 0., 0., 0., 0., 0.
        endpoint_deltas = []
        for t in (0., 1.):
            p, w, h = current_points(a, b, t)
            old_s = support_values([complex(v.real * w, v.imag * h) for v in p])
            new_s = support_values(sample_new(new.interpolate(case['a'], case['b'], t)))
            endpoint_deltas.append([y - x for x, y in zip(old_s, new_s)])
        for i, t in enumerate(PROGRESS):
            p, w, h = current_points(a, b, t)
            sampled = radial(p)
            for v in sampled:
                all_values.extend((round(v.real * QUANTIZATION), round(v.imag * QUANTIZATION)))
            if i % 5 == 0:
                old_s = support_values([complex(v.real * w, v.imag * h) for v in p])
                sampled_s = support_values([complex(round(v.real * QUANTIZATION) / QUANTIZATION * w,
                                                            round(v.imag * QUANTIZATION) / QUANTIZATION * h) for v in sampled])
                baseline_error = max(baseline_error, max(abs(x - y) for x, y in zip(old_s, sampled_s)))
                new_s = support_values(sample_new(new.interpolate(case['a'], case['b'], t)))
                gap = max(abs(x - y) for x, y in zip(old_s, new_s))
                maximum = max(maximum, gap)
                if t in (0, 1):
                    endpoint_error = max(endpoint_error, gap)
                if 0 <= t <= 1:
                    interior_error = max(interior_error, gap)
                    residual = max(abs(y - x - ((1 - t) * da + t * db)) for x, y, da, db in zip(old_s, new_s, *endpoint_deltas))
                    midpoint_error = max(midpoint_error, residual)
            # Verify the in-between preview frames against the actual engine.
            if i < len(PROGRESS) - 1 and i % 10 == 0:
                next_p, _, _ = current_points(a, b, PROGRESS[i + 1])
                next_samples = radial(next_p)
                exact, mw, mh = current_points(a, b, t + .005)
                blended = [(x + y) / 2 for x, y in zip(sampled, next_samples)]
                exact_s = support_values([complex(v.real * mw, v.imag * mh) for v in exact])
                blend_s = support_values([complex(v.real * mw, v.imag * mh) for v in blended])
                baseline_error = max(baseline_error, max(abs(x - y) for x, y in zip(exact_s, blend_s)))
        item = dict(case=case['id'], currentPreparationSeconds=prep, currentRoundsCorners=pair.rounds_corners,
                    maximumSupportDifference=maximum, maximumInteriorSupportDifference=interior_error, maximumEndpointDifference=endpoint_error,
                    maximumDifferenceAfterEndpointAdjustment=midpoint_error,
                    maximumPreviewSupportError=baseline_error)
        if baseline_error > .1 or maximum > 4 or interior_error > 3 or midpoint_error > 2:
            raise AssertionError(f'Comparison exceeded its sampled tolerance: {item}')
        report.append(item)
        print(json.dumps(item), flush=True)
    if sys.byteorder != 'little':
        all_values.byteswap()
    (destination / 'current-frames.bin.gz').write_bytes(gzip.compress(all_values.tobytes(), mtime=0))
    (destination / 'comparison.json').write_text(json.dumps(dict(cases=CASES, progress=PROGRESS, rays=RAYS,
             quantization=QUANTIZATION, checks=report, sourceHashes=source_hashes(), note='Both engines receive the same current rounded-shape endpoints. Arcs are converted to two cubics only for the current engine and numerical measurements; the simple rounded-shape preview renders exact arcs. Support checks use 128 directions, 0.05 progress increments, and selected preview midpoints; these are sampled measurements, not a proof of perceptual equivalence.'), indent=2) + '\n')


if __name__ == '__main__':
    build(Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'design-system/foundation/assets/rounded-shape-interpolation')
