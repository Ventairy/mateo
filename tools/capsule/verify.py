"""Protect the approved Mateo capsule geometry against regressions.

Run this check after refactoring the reference renderer or changing its equations
or generated fixtures. It checks geometric invariants, curve joins, approximation
error, and agreement with the committed fixtures. It does not tune the design,
generate assets, or run inside an application; visual review remains separate.

From the repository root: python3 tools/capsule/verify.py
Requires only Python's standard library.
"""

import json
import math
from pathlib import Path

from reference import adaptation, bezier, cubic_segments, derivative, length, outline, quarter


def state(segment, t):
    if segment['kind'] == 'arc':
        c, r, a, b = (segment[k] for k in ('center', 'radius', 'start', 'end'))
        angle = a + (b - a) * t
        return ((c[0] + r * math.cos(angle), c[1] + r * math.sin(angle)),
                (math.sin(angle), -math.cos(angle)), 1 / r)
    points = segment['points']
    velocity = bezier(derivative(points), t)
    speed = length(velocity)
    if speed < 1e-14:
        # Derivatives of vanishing segments are below binary64 resolution.
        return bezier(points, t), (1.0, 0.0), 0.0
    if len(points) == 2:
        curvature = 0.0
    else:
        acc = bezier(derivative(derivative(points)), t)
        curvature = (velocity[1] * acc[0] - velocity[0] * acc[1]) / speed ** 3
    return bezier(points, t), (velocity[0] / speed, velocity[1] / speed), curvature


def main():
    ratios = sorted(set([1.0] + [1 + i / 1000 for i in range(1, 1001)] +
                        [2 + i / 100 for i in range(801)] +
                        [1 + 10 ** -i for i in range(2, 13)] +
                        [16, 32, 64, 128, 1000, 10000, 100000, 1000000]))
    max_error = 0.0
    min_curvature = 0.0
    for aspect in ratios:
        q = adaptation(aspect)
        segments = quarter(q)
        previous = None
        for segment in segments:
            start, end = state(segment, 0), state(segment, 1)
            span = math.dist(start[0], end[0])
            if previous:
                assert math.dist(previous[0], start[0]) < 1e-8 * q, (aspect, 'position')
                # Vanishing segments lose second-derivative precision in binary64.
                if span > 1e-5 and previous_span > 1e-5:
                    assert math.dist(previous[1], start[1]) < 1e-6, (aspect, 'tangent')
                    assert abs(previous[2] - start[2]) < 0.002, (aspect, 'curvature', previous[2], start[2])
            previous, previous_span = end, span
            for i in range(17):
                p, v, curvature = state(segment, i / 16)
                assert all(math.isfinite(value) for value in (*p, *v, curvature))
                assert -1e-8 <= p[0] <= q + 1e-8 * q and -1e-8 <= p[1] <= 1 + 1e-8
                # Monotonic quadrants and reflection guarantee a simple outline.
                assert v[0] >= -1e-7 and v[1] <= 1e-7, (aspect, 'monotonic')
                if span > 1e-5:
                    min_curvature = min(min_curvature, curvature)
                    assert curvature >= -0.002, (aspect, 'convexity', curvature)
            if segment['kind'] == 'bezier' and len(segment['points']) == 6:
                fourth = segment['points']
                for _ in range(4):
                    fourth = derivative(fourth)
                bound = max(map(length, fourth)) / (384 * 16) * 24
                max_error = max(max_error, bound)
                assert bound < 0.01, (aspect, 'conversion', bound)
            elif segment['kind'] == 'arc':
                # Radial contour error, independent of arc parameterization.
                for curve in cubic_segments([segment]):
                    for i in range(33):
                        radial_error = abs(math.dist(bezier(curve, i / 32), segment['center']) - segment['radius'])
                        bound = radial_error * 24
                        max_error = max(max_error, bound)
                        assert bound < 0.01, (aspect, 'arc conversion', bound)
    fixture = json.loads((Path(__file__).parents[2] / 'design-system/foundation/assets/capsule/reference.json').read_text())
    for case in fixture['cases']:
        segments, curves = outline(case['width'], case['height'])
        assert json.loads(json.dumps(segments)) == case['quarter']
        assert json.loads(json.dumps(curves)) == case['cubics']
        assert math.dist(curves[-1][-1], curves[0][0]) < 1e-9
    print(json.dumps(dict(proportions=len(ratios), fixtures=len(fixture['cases']),
                         maximumConversionBoundAtHeight48=max_error,
                         minimumSampledCurvature=min_curvature,
                         checks='finite bounds, monotonic quadrants, sampled convexity, G2 joins, closure, fixtures'), indent=2))


if __name__ == '__main__':
    main()
