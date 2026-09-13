"""Independent, standard-library renderer for the Mateo capsule specification.

This is a reference implementation, not a runtime dependency of any package.
The equations are specified in design-system/foundation/capsule.md.
"""

from __future__ import annotations

import math

Point = tuple[float, float]

# Polynomial coefficients, in ascending power order. These are not size samples.
SHOULDER_EXPONENT = (
    3.871257456340878,
    -12.88611924670383,
    52.98714338673223,
    -93.58531994541094,
    76.23481388943857,
    -23.504691269150406,
)
SHOULDER_JOIN = (
    1.2859740959239152,
    6.803433630915522,
    -39.513958239342216,
    81.06757004843966,
    -72.45787701452092,
    23.86446258146726,
)
ROOT_HALF = math.sqrt(0.5)
SHOULDER_INTERVALS = 6
QUINTIC_INTERVALS = 2


def add(a: Point, b: Point) -> Point:
    return a[0] + b[0], a[1] + b[1]


def subtract(a: Point, b: Point) -> Point:
    return a[0] - b[0], a[1] - b[1]


def multiply(p: Point, value: float) -> Point:
    return p[0] * value, p[1] * value


def length(p: Point) -> float:
    return math.hypot(*p)


def polynomial(coefficients: tuple[float, ...], value: float) -> float:
    result = 0.0
    for coefficient in reversed(coefficients):
        result = result * value + coefficient
    return result


def adaptation(aspect_ratio: float) -> float:
    t = min(1.0, max(0.0, aspect_ratio - 1.0))
    weight = t * t * t * (t * (6.0 * t - 15.0) + 10.0)
    remaining = 1.0 - t
    weight += 0.12 * remaining * remaining * remaining * (1.0 - weight)
    return 1.0 + (aspect_ratio - 1.0) * weight


def bezier(points: list[Point], t: float) -> Point:
    """Evaluate through de Casteljau, independently of the Flutter evaluator."""
    work = list(points)
    while len(work) > 1:
        work = [add(multiply(a, 1.0 - t), multiply(b, t)) for a, b in zip(work, work[1:])]
    return work[0]


def derivative(points: list[Point]) -> list[Point]:
    degree = len(points) - 1
    return [multiply(subtract(b, a), degree) for a, b in zip(points, points[1:])]


def join(p0: Point, tangent0: Point, curvature0: float,
         p1: Point, tangent1: Point, curvature1: float) -> list[Point]:
    span = length(subtract(p1, p0))
    normal0 = (tangent0[1], -tangent0[0])
    normal1 = (tangent1[1], -tangent1[0])
    return [
        p0,
        add(p0, multiply(tangent0, span / 5.0)),
        add(add(p0, multiply(tangent0, 2.0 * span / 5.0)),
            multiply(normal0, span * span * curvature0 / 20.0)),
        add(subtract(p1, multiply(tangent1, 2.0 * span / 5.0)),
            multiply(normal1, span * span * curvature1 / 20.0)),
        subtract(p1, multiply(tangent1, span / 5.0)),
        p1,
    ]


def quarter(reference_ratio: float) -> list[dict]:
    """Upper-right quadrant, centered at the origin, with short radius one."""
    q = reference_ratio
    if q == 1.0:
        return [dict(kind="arc", center=(0.0, 0.0), radius=1.0,
                     start=math.pi / 2.0, end=0.0)]
    z = (q - 1.0) / (q + 1.0)
    exponent = 2.0 + (q - 1.0) * polynomial(SHOULDER_EXPONENT, z)
    wide = max(0.0, (q - 2.0) / (q + 4.0))
    shoulder_ease = 4.0 * wide * (1.0 - wide)
    exponent *= 1.0 - 0.01 * shoulder_ease ** 3
    join_factor = 1.13276676 + (q - 1.0) * polynomial(SHOULDER_JOIN, z)
    join_x = q * (1.0 - 1.0 / join_factor)

    def profile(x: float) -> tuple[Point, Point, float, float, float]:
        power = (x / q) ** exponent
        drop = -q * math.expm1(math.log1p(-power) / exponent)
        ordinate = q - drop
        slope = -power * ordinate / (x * (1.0 - power))
        second = (exponent - 1.0) * slope / (x * (1.0 - power))
        magnitude = math.hypot(1.0, slope)
        return (x, 1.0 - drop), (1.0 / magnitude, slope / magnitude), \
            -second / magnitude ** 3, slope, second

    junction, tangent, _, _, _ = profile(join_x)
    diagonal = (q - 1.0 + ROOT_HALF, ROOT_HALF)
    tangent_ratio = -tangent[1] / tangent[0]
    d = (join_x - tangent_ratio * (junction[1] + q - 1.0)) / (1.0 - tangent_ratio)
    radius = (q - d - 1.0 + ROOT_HALF) * math.sqrt(2.0)
    chord = subtract(diagonal, junction)
    chord_length = length(chord)
    middle = multiply(add(junction, diagonal), 0.5)
    perpendicular = (-chord[1] / chord_length, chord[0] / chord_length)
    center = subtract(middle, multiply(perpendicular,
                                      math.sqrt(radius * radius - chord_length * chord_length / 4.0)))
    arc_start = math.atan2(junction[1] - center[1], junction[0] - center[0])
    arc_end = math.atan2(diagonal[1] - center[1], diagonal[0] - center[0])
    blend = 0.12 * (1.0 - 1.0 / q)

    def circle(angle: float) -> tuple[Point, Point, float]:
        return add(center, (radius * math.cos(angle), radius * math.sin(angle))), \
            (math.sin(angle), -math.cos(angle)), 1.0 / radius

    before = profile(join_x - blend)
    after = circle(arc_start - blend)
    v_end = -exponent * math.log(before[0][0] / q)
    v_start = 16.0 - math.log1p(-1.0 / q)
    states = [profile(q * math.exp(-(v_start + (v_end - v_start) * i / SHOULDER_INTERVALS) / exponent))
              for i in range(SHOULDER_INTERVALS + 1)]

    point, _, curvature, slope, _ = states[0]
    power = (point[0] / q) ** exponent
    drop = -q * math.expm1(math.log1p(-power) / exponent)
    tangent_x = -drop / slope
    control2_x = point[0] - tangent_x
    control1_x = control2_x - 1.5 * curvature * math.hypot(tangent_x, drop) ** 3 / drop
    start = (control1_x * control1_x / control2_x, 1.0)
    segments = [dict(kind="line", points=[(0.0, 1.0), start]),
                dict(kind="bezier", points=[start, (control1_x, 1.0), (control2_x, 1.0), point])]

    for left, right in zip(states, states[1:]):
        p0, _, _, slope0, second0 = left
        p1, _, _, slope1, second1 = right
        dx = p1[0] - p0[0]
        velocity0 = (dx, dx * slope0)
        velocity1 = (dx, dx * slope1)
        segments.append(dict(kind="bezier", points=[
            p0,
            add(p0, multiply(velocity0, 0.2)),
            add(add(p0, multiply(velocity0, 0.4)), (0.0, dx * dx * second0 / 20.0)),
            add(subtract(p1, multiply(velocity1, 0.4)), (0.0, dx * dx * second1 / 20.0)),
            subtract(p1, multiply(velocity1, 0.2)),
            p1,
        ]))
    segments.extend([
        dict(kind="bezier", points=join(*before[:3], *after)),
        dict(kind="arc", center=center, radius=radius, start=arc_start - blend, end=arc_end + blend),
        dict(kind="bezier", points=join(*circle(arc_end + blend), diagonal, (ROOT_HALF, -ROOT_HALF), 1.0)),
        dict(kind="arc", center=(q - 1.0, 0.0), radius=1.0, start=math.pi / 4.0, end=0.0),
    ])
    return segments


def cubic_segments(segments: list[dict]) -> list[list[Point]]:
    """Convert the canonical segments to the shared cubic-only representation."""
    result = []
    for segment in segments:
        if segment["kind"] == "line":
            p0, p1 = segment["points"]
            result.append([p0, add(p0, multiply(subtract(p1, p0), 1 / 3)),
                           add(p0, multiply(subtract(p1, p0), 2 / 3)), p1])
        elif segment["kind"] == "bezier":
            points = segment["points"]
            if len(points) == 4:
                result.append(points)
                continue
            velocities = derivative(points)
            for i in range(QUINTIC_INTERVALS):
                t0, t1 = i / QUINTIC_INTERVALS, (i + 1) / QUINTIC_INTERVALS
                p0, p1 = bezier(points, t0), bezier(points, t1)
                result.append([p0, add(p0, multiply(bezier(velocities, t0), 1 / (3 * QUINTIC_INTERVALS))),
                               subtract(p1, multiply(bezier(velocities, t1), 1 / (3 * QUINTIC_INTERVALS))), p1])
        else:
            center, radius, start, end = (segment[name] for name in ("center", "radius", "start", "end"))
            count = max(1, math.ceil(abs(end - start) / (math.pi / 4.0)))
            for i in range(count):
                a, b = start + (end - start) * i / count, start + (end - start) * (i + 1) / count
                handle = 4.0 / 3.0 * math.tan((b - a) / 4.0) * radius
                p0 = add(center, (radius * math.cos(a), radius * math.sin(a)))
                p1 = add(center, (radius * math.cos(b), radius * math.sin(b)))
                result.append([p0, add(p0, (-handle * math.sin(a), handle * math.cos(a))),
                               subtract(p1, (-handle * math.sin(b), handle * math.cos(b))), p1])
    return result


def outline(width: float, height: float) -> tuple[list[dict], list[list[Point]]]:
    if not math.isfinite(width) or not math.isfinite(height) or min(width, height) <= 0.0:
        return [], []
    short, long = min(width, height), max(width, height)
    aspect = long / short
    if not math.isfinite(aspect):
        return [], []
    reference = adaptation(aspect)
    segments = quarter(reference)
    curves = cubic_segments(segments)
    extension = aspect - reference
    if extension:
        curves = [[[p[0] + extension, p[1]] for p in curve] for curve in curves]
        curves.insert(0, [(0.0, 1.0), (extension / 3, 1.0), (2 * extension / 3, 1.0), (extension, 1.0)])

    def transform(p: Point, sx: float, sy: float) -> Point:
        x, y = p[0] * sx * short / 2.0, p[1] * sy * short / 2.0
        if width >= height:
            return width / 2.0 + x, height / 2.0 - y
        return width / 2.0 + y, height / 2.0 + x

    full = []
    for sx, sy, reverse in ((1, 1, False), (1, -1, True), (-1, -1, False), (-1, 1, True)):
        for curve in reversed(curves) if reverse else curves:
            full.append([transform(p, sx, sy) for p in (reversed(curve) if reverse else curve)])
    return segments, full


def svg_path(curves: list[list[Point]]) -> str:
    if not curves:
        return ""
    def pair(p: Point) -> str:
        return f"{p[0]:.12g},{p[1]:.12g}"
    return "M " + pair(curves[0][0]) + " " + " ".join(
        "C " + " ".join(pair(p) for p in curve[1:]) for curve in curves) + " Z"


if __name__ == "__main__":
    # Artifact authoring is kept outside the reference geometry.
    from artifacts import main
    main()
    from pathlib import Path
    from runpy import run_path
    run_path(str(Path(__file__).with_name('verify.py')), run_name='__main__')
