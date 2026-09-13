"""Standard-library reference for the Mateo rounded-rectangle foundation."""
from __future__ import annotations

import math
from functools import lru_cache


def bezier(points, t):
    work = list(points)
    while len(work) > 1:
        work = [(1 - t) * a + t * b for a, b in zip(work, work[1:])]
    return work[0]


def derivative(points):
    n = len(points) - 1
    return [n * (b - a) for a, b in zip(points, points[1:])]


def product(a, b):
    """Product of two polynomials in the Bernstein basis."""
    m, n = len(a) - 1, len(b) - 1
    return [sum(math.comb(m, i) * math.comb(n, k - i) * a[i] * b[k - i]
                for i in range(max(0, k - n), min(m, k) + 1))
            / math.comb(m + n, k) for k in range(m + n + 1)]


def elevate(points, degree):
    work = list(points)
    while len(work) <= degree:
        n = len(work)
        work = [work[0]] + [i / n * work[i - 1] + (1 - i / n) * work[i]
                           for i in range(1, n)] + [work[-1]]
    return work


@lru_cache(maxsize=1)
def canonical():
    a = (20 + math.sqrt(2)) / 140
    b = (10 + 4 * math.sqrt(2)) / 140
    c = (12 + 9 * math.sqrt(2)) / 140
    eigenvalue = (a + c + math.hypot(a - c, 2 * b)) / 2
    divisor = math.hypot(b, eigenvalue - a) * math.sqrt(eigenvalue)
    lam, mu = b / divisor, (eigenvalue - a) / divisor
    z = complex(1, 1) / math.sqrt(2)
    w = (complex(lam), complex(mu), z * mu, z * lam)
    velocity = product(w, w)
    p = [0j]
    for value in velocity:
        p.append(p[-1] + value / 7)
    # Canonical symmetry makes the peak occur exactly at t = 1/2.
    v, dv = bezier(w, .5), bezier(derivative(w), .5)
    peak = 2 * (v.conjugate() * dv).imag / abs(v) ** 4
    return w, tuple(p), peak


def sample(t):
    """Position, unit tangent, and curvature of the unscaled canonical corner."""
    w, p, _ = canonical()
    v, dv = bezier(w, t), bezier(derivative(w), t)
    return (bezier(p, t), v * v / abs(v) ** 2,
            2 * (v.conjugate() * dv).imag / abs(v) ** 4)


def effective_radius(width, height, radius, origin=0j):
    if not math.isfinite(radius) or radius < 0:
        raise ValueError('radius must be finite and nonnegative')
    values = (width, height, origin.real, origin.imag,
              origin.real + width, origin.imag + height)
    if width <= 0 or height <= 0 or not all(map(math.isfinite, values)):
        return None
    return min(radius, min(width, height) / (2 * canonical()[2]))


def corner_controls(radius, inset=0):
    """Homogeneous (weighted point, weight) controls; exact rational PH offset."""
    if not math.isfinite(inset) or inset < 0 or (inset and inset >= radius):
        raise ValueError('inset must be zero or smaller than the effective radius')
    w, p, peak = canonical()
    scale = peak * radius
    if inset == 0:
        return [(scale * point, 1.0) for point in p]
    speed = [v.real for v in product(w, [v.conjugate() for v in w])]
    numerator = product([scale * point for point in p], speed)
    normal = elevate([1j * inset * v for v in product(w, w)], 13)
    weights = elevate(speed, 13)
    return [(p + n, weight) for p, n, weight in zip(numerator, normal, weights)]


def split(controls):
    work = list(controls)
    left, right = [work[0]], [work[-1]]
    while len(work) > 1:
        work = [((a[0] + b[0]) / 2, (a[1] + b[1]) / 2)
                for a, b in zip(work, work[1:])]
        left.append(work[0])
        right.append(work[-1])
    return left, right[::-1]


def distance_to_segment(point, a, b):
    chord = b - a
    if chord == 0:
        return abs(point - a)
    t = max(0.0, min(1.0, ((point - a) / chord).real))
    return abs(point - (a + t * chord))


def flatten(controls, tolerance):
    """Return leaf intervals, chords, and conservative convex-hull error bounds."""
    if tolerance <= 0 or not math.isfinite(tolerance):
        raise ValueError('tolerance must be finite and positive')
    leaves = []
    stack = [(list(controls), 0.0, 1.0, 0)]
    while stack:
        cp, lo, hi, depth = stack.pop()
        if any(weight <= 0 for _, weight in cp):
            raise ValueError('positive rational weights required')
        points = [p / weight for p, weight in cp]
        bound = max(distance_to_segment(p, points[0], points[-1]) for p in points)
        if bound <= tolerance:
            leaves.append((lo, hi, points[0], points[-1], bound))
        else:
            if depth == 40:
                raise ValueError('reference subdivision cannot resolve tolerance')
            left, right = split(cp)
            mid = (lo + hi) / 2
            stack.extend([(right, mid, hi, depth + 1), (left, lo, mid, depth + 1)])
    return leaves


def outline(width, height, radius, inset=0, origin=0j):
    rr = effective_radius(width, height, radius, origin)
    if not math.isfinite(inset) or inset < 0:
        raise ValueError('inset must be finite and nonnegative')
    if rr is None:
        return []
    if inset and inset >= rr:
        raise ValueError('inset must be smaller than the effective radius')
    if rr == 0:
        return [origin, origin + width, origin + complex(width, height), origin + 1j * height, origin]
    tolerance = 1e-6 * rr
    coords = (width, height, origin.real, origin.imag, origin.real + width, origin.imag + height)
    if tolerance == 0 or any(math.ulp(v) > tolerance / 16 for v in coords):
        raise ValueError('bounds cannot represent the SVG error tolerance in binary64')
    # Leave a margin for arithmetic and serialized-coordinate rounding.
    leaves = flatten(corner_controls(rr, inset), tolerance / 2)
    q = [leaves[0][2]] + [leaf[3] for leaf in leaves]
    e = canonical()[2] * rr
    starts = [complex(width - e, 0), complex(width, height - e), complex(e, height), complex(0, e)]
    points = [origin + starts[j] + (1j ** j) * p for j in range(4) for p in q]
    return points + [points[0]]


def curvature_centers(width, height, radius, origin=0j):
    rr = effective_radius(width, height, radius, origin)
    if not rr:
        return []
    p, tangent, _ = sample(.5)
    e = canonical()[2] * rr
    local = e * p + 1j * rr * tangent
    starts = [complex(width - e, 0), complex(width, height - e), complex(e, height), complex(0, e)]
    return [origin + starts[j] + 1j ** j * local for j in range(4)]


def svg_path(points):
    if not points:
        return ''
    return 'M' + ' L'.join(f'{p.real:.17g},{p.imag:.17g}' for p in points[:-1]) + ' Z'


if __name__ == '__main__':
    from artifacts import main
    main()
    from pathlib import Path
    from runpy import run_path
    run_path(str(Path(__file__).with_name('verify.py')), run_name='__main__')
