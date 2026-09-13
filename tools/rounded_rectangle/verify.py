"""Independent numerical checks of the fixed rounded-rectangle construction."""
import json
import math
from reference import (bezier, canonical, corner_controls, curvature_centers,
                       effective_radius, flatten, outline, sample, svg_path)
from artifacts import OUTPUT, drawings, fixtures


def close(a, b, tolerance=2e-11):
    assert abs(a - b) <= tolerance * max(1, abs(a), abs(b)), (a, b)


def power(controls):
    n = len(controls) - 1
    return [sum(controls[j] * math.comb(n, j) * math.comb(n-j, k-j)
                * (-1)**(k-j) for j in range(k+1)) for k in range(n+1)]


def evaluate(coefficients, t, order=0):
    for _ in range(order):
        coefficients = [j * coefficients[j] for j in range(1, len(coefficients))]
    value = 0j
    for coefficient in reversed(coefficients):
        value = value * t + coefficient
    return value


def independent(t):
    p = evaluate(POWER, t)
    v, a = evaluate(POWER, t, 1), evaluate(POWER, t, 2)
    return p, v / abs(v), (v.conjugate() * a).imag / abs(v)**3


def raises(fn):
    try:
        fn()
    except ValueError:
        return
    raise AssertionError('expected invalid-input rejection')


_, controls, c = canonical()
POWER = power(controls)
close(c, 1.497374792625798)
close(controls[-1], 1+1j)
previous = -1
for i in range(4001):
    t = i / 4000
    p, tangent, k = independent(t)
    for a, b in zip((p, tangent, k), sample(t)):
        close(a, b)
    close(p, (1+1j) - 1j * independent(1-t)[0].conjugate())
    assert tangent.real >= -1e-12 and tangent.imag >= -1e-12
    assert k >= -1e-12 and k <= c + 1e-11
    if i <= 2000:
        assert k > previous
        previous = k
close(independent(0)[1], 1)
close(independent(1)[1], 1j)
close(independent(0)[2], 0)
close(independent(1)[2], 0)
close(independent(.5)[2], c)

cases = 0
for size in (1e-6, .01, 1, 96, 500, 1e6):
    for aspect in (1, 2, 100, 1e6):
        for w, h in ((size, size*aspect), (size*aspect, size)):
            limit = min(w, h)/(2*c)
            for r in (0, limit/2, math.nextafter(limit, 0), limit,
                      math.nextafter(limit, math.inf), limit*100):
                rr = effective_radius(w, h, r)
                close(rr, min(r, limit))
                points = outline(w, h, r)
                assert points[0] == points[-1]
                epsilon = max(w, h)*1e-12
                assert all(-epsilon <= p.real <= w+epsilon and
                           -epsilon <= p.imag <= h+epsilon for p in points)
                # Four identical rotated corners enforce reflection and convexity.
                if rr:
                    n = (len(points)-1)//4
                    for j in range(n):
                        close(points[j] + points[2*n+j], complex(w, h))
                    for a, b, d in zip(points, points[1:], points[2:]):
                        cross = ((b-a).conjugate()*(d-b)).imag
                        assert cross >= -epsilon*(abs(b-a)+abs(d-b))
                cases += 1

base = outline(360, 180, 32, 8)
for transformed, expected in (
    (outline(360, 180, 32, 8, 31-17j), [p+31-17j for p in base]),
    (outline(1080, 540, 96, 24), [3*p for p in base])):
    assert len(transformed) == len(expected)
    for a, b in zip(transformed, expected):
        close(a, b)
# Transposition reverses winding; compare coordinate sets after rounding.
transposed = outline(180, 360, 32, 8)
assert {(round(p.imag, 8), round(p.real, 8)) for p in base} == {
    (round(p.real, 8), round(p.imag, 8)) for p in transposed}

# Check shortest geometric distance independently of paired normal parameters.
outer = outline(360, 180, 32)
inner = outline(360, 180, 32, 8)
for point in inner[::max(1, len(inner)//128)]:
    distances = []
    for a, b in zip(outer, outer[1:]):
        chord = b-a
        if chord == 0:
            distances.append(abs(point-a))
            continue
        projection = ((point-a).real*chord.real + (point-a).imag*chord.imag)/abs(chord)**2
        distances.append(abs(point-(a+max(0, min(1, projection))*chord)))
    assert abs(min(distances)-8) < 32e-6

leaf_count = 0
for r in (.001, 24, 1e5):
    for fraction in (0, 1/3, .9, .999):
        d = r*fraction
        cp = corner_controls(r, d)
        leaves = flatten(cp, 5e-7*r)
        leaf_count += len(leaves)
        assert leaves[0][0] == 0 and leaves[-1][1] == 1
        for a, b in zip(leaves, leaves[1:]):
            assert a[1] == b[0] and a[3] == b[2]
        for lo, hi, a, b, bound in leaves:
            assert bound <= 5e-7*r
            for fraction in (.125, .5, .875):
                t = lo + (hi-lo)*fraction
                p, tangent, k = independent(t)
                exact = c*r*p + 1j*d*tangent
                rational = bezier([p for p, _ in cp], t)/bezier([v for _, v in cp], t)
                close(rational, exact)
                close(abs(exact-c*r*p), d)
                chord = b-a
                u = max(0, min(1, ((exact-a)/chord).real))
                assert abs(exact-(a+u*chord)) <= bound + 2e-11*r
                assert 1-d*k/(c*r) > 0
        # Differencing independently evaluated offset positions checks its curvature.
        dt = 1e-4
        def offset(t):
            p, tangent, _ = independent(t)
            return c*r*p + 1j*d*tangent
        a, b, e = offset(.5-dt), offset(.5), offset(.5+dt)
        velocity = (e-a)/(2*dt)
        acceleration = (e-2*b+a)/(dt*dt)
        curvature = (velocity.conjugate()*acceleration).imag/abs(velocity)**3
        assert abs(curvature*(r-d)-1) < 2e-3

for bad in (-1, math.inf, -math.inf, math.nan):
    raises(lambda: outline(96, 96, bad))
    raises(lambda: outline(0, 0, bad))
    raises(lambda: outline(96, 96, 24, bad))
for w, h in ((0, 1), (-1, 1), (1, 0), (math.inf, 1), (1, math.nan)):
    assert outline(w, h, 24) == []
assert outline(96, 96, 24, origin=complex(math.inf, 0)) == []
for d in (24, 25):
    raises(lambda: outline(96, 96, 24, d))
raises(lambda: outline(96, 96, 0, 1))
raises(lambda: outline(1, 1, .1, origin=1e20+0j))
close(curvature_centers(360, 420, 42)[0], complex(315.979067, 44.020933), 1e-8)
button = fixtures()['cases'][3]['circularButton']
center = complex(*button['center'])
sheet = outline(360, 420, 42)
from reference import distance_to_segment
button_gaps = []
for i in range(129):
    angle = math.pi/2*i/128
    point = center + button['radius']*complex(math.cos(angle), -math.sin(angle))
    button_gaps.append(min(distance_to_segment(point, a, b) for a, b in zip(sheet, sheet[1:])))
assert abs(min(button_gaps)-22.46554) < .001
assert abs(max(button_gaps)-22.81611) < .001
assert len(outline(96, 96, 0)) == 5
assert svg_path([]) == ''
assert json.loads((OUTPUT/'reference.json').read_text()) == fixtures()
for name, content in drawings().items():
    assert (OUTPUT/name).read_text() == content, f'stale artifact: {name}'
print(f'PASS: 4001 independent curve samples; {cases} bounds/radius cases; '
      f'{leaf_count} bounded approximation leaves; transforms, offsets, invalid inputs, and artifacts.')
