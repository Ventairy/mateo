"""Readable binary64 reference for the rounded-convex-interpolation foundation.

No framework dependencies or special shape families.
Python's ordinary sine/cosine implement the equations directly.
"""
from bisect import bisect_right
from dataclasses import dataclass, replace
from functools import cached_property, lru_cache
from geometry import Endpoint, Pair, line_cubics, outline_progress, continued as positive
from motion import Movement, curve_progress, opening, mix, fit
from typing import Optional
from math import atan2, cos, floor, hypot, isfinite, pi, sin, sqrt, tanh

TAU = 2 * pi
INPUT_COUNT = 512
CUBIC_COUNT = 256
ARC_WEIGHT = 4
TURN_BLEND = .0001
PREPARED_MINIMUM = 1e-12
OUTLINE_LIMIT = .08
RELATIVE_DISPLACEMENT_LIMIT = .2


@dataclass(frozen=True)
class Shape:
    width: float
    height: float
    angle: float
    turns: tuple[float, ...]
    speeds: tuple[float, ...]
    spacings: tuple[float, ...]
    outline: Optional[Endpoint] = None

    @cached_property
    def endpoint(self):
        if self.outline is not None: return self.outline
        outline = reconstruct(self)
        return Endpoint.create(tuple(tuple(complex(p.real*self.width,p.imag*self.height) for p in c) for c in outline.cubics),self.width,self.height)


@dataclass(frozen=True)
class Outline:
    width: float
    height: float
    cubics: tuple[tuple[complex, ...], ...]


def cross(a, b):
    return a.real * b.imag - a.imag * b.real


def bezier(c, t):
    u = 1 - t
    return u**3 * c[0] + 3 * u*u*t * c[1] + 3 * u*t*t * c[2] + t**3 * c[3]


def _segments(points):
    """Start at the top support midpoint; unwrap clockwise screen tangents."""
    top = min(p.imag for p in points)
    ids = [i for i, p in enumerate(points) if abs(p.imag - top) < 1e-10]
    first = min(ids, key=lambda i: points[i].real)
    last = max(ids, key=lambda i: points[i].real)
    start = complex((points[first].real + points[last].real) / 2, top)
    ring = [start]
    if abs(points[last] - start) > 1e-12:
        ring.append(points[last])
    j = (last + 1) % len(points)
    while j != first:
        ring.append(points[j])
        j = (j + 1) % len(points)
    if abs(points[first] - start) > 1e-12:
        ring.append(points[first])
    if abs(ring[-1] - start) < 1e-12:
        ring.pop()
    edges, length, previous = [], 0., float('-inf')
    for i, a in enumerate(ring):
        delta = ring[(i + 1) % len(ring)] - a
        size = abs(delta)
        if size < 1e-12:
            continue
        angle = atan2(delta.imag, delta.real)
        while angle < previous - 1e-8:
            angle += TAU
        edges.append((length, length + size, angle, a, delta))
        length += size
        previous = angle
    return [(lo/length, hi/length, angle, a, d) for lo, hi, angle, a, d in edges]


def _describe(points, width, height):
    edges = _segments(points)
    g, z = 1 / TAU, 2
    # Each piece: route interval, tangent interval, arc interval.
    pieces = []
    first = edges[0][2]
    if first > 1e-12:
        pieces.append((0., g*first/z, 0., first, 0., 0.))
    for i, (lo, hi, angle, _, _) in enumerate(edges):
        begin, end = (lo + g*angle)/z, (hi + g*angle)/z
        pieces.append((begin, end, angle, angle, lo, hi))
        after = edges[i+1][2] if i+1 < len(edges) else TAU
        if after - angle > 1e-12:
            pieces.append((end, (hi + g*after)/z, angle, after, hi, hi))
    ends = [p[1] for p in pieces]
    arc_ends = [e[1] for e in edges]
    mean = sum((hi-lo)*angle for lo, hi, angle, _, _ in edges)
    phase = (mean / TAU - .5) / z

    def read(u):
        lap = floor(u)
        v = u - lap
        p = pieces[min(bisect_right(ends, v), len(pieces)-1)]
        f = (v-p[0]) / (p[1]-p[0])
        return p[2]+f*(p[3]-p[2])+lap*TAU, p[4]+f*(p[5]-p[4])+lap

    def point_at(arc):
        u = arc - floor(arc)
        e = edges[min(bisect_right(arc_ends, u), len(edges)-1)]
        return e[3] + (u-e[0])/(e[1]-e[0])*e[4]

    positions = [point_at(read(i/INPUT_COUNT-phase)[1]) for i in range(INPUT_COUNT+1)]
    angles, speeds = [], []
    for i in range(INPUT_COUNT):
        delta = positions[i+1] - positions[i]
        speed = abs(delta) * INPUT_COUNT
        tangent, _ = read((i+.5)/INPUT_COUNT-phase)
        if abs(delta) > 1e-12:
            angle = atan2(delta.imag, delta.real)
            while angle < tangent-pi:
                angle += TAU
            while angle > tangent+pi:
                angle -= TAU
        else:
            angle = tangent
        angles.append(angle)
        speeds.append(max(speed, PREPARED_MINIMUM))
    polygon = _fit_points(positions[:-1], width/max(width,height), height/max(width,height))
    sites = _arc_sites(polygon)
    turns = [max(0., angles[(i+1) % INPUT_COUNT]+(TAU if i == INPUT_COUNT-1 else 0)-angle)
             for i,angle in enumerate(angles)]
    total = sum(turns)
    turns = tuple((1-TURN_BLEND)*v*TAU/total+TURN_BLEND*TAU/INPUT_COUNT for v in turns)
    spacings = tuple(max(PREPARED_MINIMUM, sites[(i+1) % CUBIC_COUNT]+(1 if i == CUBIC_COUNT-1 else 0)-v)
                     for i,v in enumerate(sites))
    if not isfinite(angles[0]) or any(not isfinite(v) or v <= 0 for v in (*turns,*speeds,*spacings)):
        raise ValueError('The outline cannot produce a finite, positive prepared description.')
    return Shape(width,height,angles[0],turns,tuple(speeds),spacings)


def _polygon(shape):
    angle,total = shape.angle,sum(shape.turns)
    directions=[]
    for turn in shape.turns:
        directions.append(complex(cos(angle),sin(angle)))
        angle += TAU*turn/total
    mean=sum(w*d for w,d in zip(shape.speeds,directions))/sum(shape.speeds)
    polygon,p=[],0j
    for w,d in zip(shape.speeds,directions):
        polygon.append(p);p+=w*(d-mean)
    longest=max(shape.width,shape.height)
    return _fit_points(polygon,shape.width/longest,shape.height/longest)


def _sites(shape):
    total,arc,sites=sum(shape.spacings),0.,[]
    for gap in shape.spacings:
        sites.append(arc);arc+=gap/total
    return sites


def _fit_points(points, width, height):
    x0, x1 = min(p.real for p in points), max(p.real for p in points)
    y0, y1 = min(p.imag for p in points), max(p.imag for p in points)
    return [complex((p.real-(x0+x1)/2)*width/(x1-x0),
                    (p.imag-(y0+y1)/2)*height/(y1-y0)) for p in points]


def _lengths(polygon):
    lengths = [0.]
    for i, p in enumerate(polygon):
        lengths.append(lengths[-1] + abs(polygon[(i+1) % len(polygon)] - p))
    return lengths


def _arc_sites(polygon):
    lengths = _lengths(polygon)
    perimeter = lengths[-1]
    edges = [polygon[(i+1) % INPUT_COUNT]-p for i, p in enumerate(polygon)]
    bends = [max(0., cross(edges[i-1], e)) for i, e in enumerate(edges)]
    factor = ARC_WEIGHT*INPUT_COUNT**2 / (TAU*perimeter)
    weights = [abs(e)+factor*(bends[i]+bends[(i+1) % INPUT_COUNT])/2
               for i, e in enumerate(edges)]
    total, prefix, j, sites = sum(weights), 0., 0, []
    for i in range(CUBIC_COUNT):
        target = total*i/CUBIC_COUNT
        while j < INPUT_COUNT-1 and prefix+weights[j] <= target:
            prefix += weights[j]
            j += 1
        f = (target-prefix)/weights[j]
        sites.append((lengths[j]+f*(lengths[j+1]-lengths[j]))/perimeter)
    return tuple(sites)


def _spline(points):
    m = len(points)
    return tuple(((points[i-1]+4*points[i]+points[(i+1) % m])/6,
                  (2*points[i]+points[(i+1) % m])/3,
                  (points[i]+2*points[(i+1) % m])/3,
                  (points[i]+4*points[(i+1) % m]+points[(i+2) % m])/6)
                 for i in range(m))


def _stationary(p):
    # Roots of the coordinate derivative / 3; stable quadratic evaluation.
    a, b, c = -p[0]+3*p[1]-3*p[2]+p[3], 2*(p[0]-2*p[1]+p[2]), p[1]-p[0]
    if a == 0:
        return [-c/b] if b != 0 else []
    discriminant = b*b-4*a*c
    if discriminant < 0:
        return []
    q = -.5*(b+(-1 if b < 0 else 1)*sqrt(discriminant))
    return [q/a, c/q] if q != 0 else [0.]


def _fit_cubics(cubics):
    bounds = []
    for coordinate in (lambda p: p.real, lambda p: p.imag):
        values = []
        for c in cubics:
            p = [coordinate(v) for v in c]
            values.extend([p[0], p[3]])
            for t in _stationary(p):
                if 0 < t < 1:
                    values.append(coordinate(bezier(c, t)))
        bounds.append((min(values), max(values)))
    (x0, x1), (y0, y1) = bounds
    return tuple(tuple(complex((p.real-(x0+x1)/2)/(x1-x0),
                               (p.imag-(y0+y1)/2)/(y1-y0)) for p in c) for c in cubics)


def _controls(polygon, sites):
    lengths = _lengths(polygon)
    perimeter = lengths[-1]
    points = []
    for site in sites:
        target = perimeter*site
        j = min(bisect_right(lengths, target)-1, len(polygon)-1)
        f = (target-lengths[j])/(lengths[j+1]-lengths[j])
        points.append((1-f)*polygon[j]+f*polygon[(j+1) % len(polygon)])
    return points


def dimension(a, b, progress):
    """Linear dimensions with gentle relative resistance outside the endpoints."""
    if 0 <= progress <= 1:
        return (1-progress)*a+progress*b
    endpoint = a if progress < 0 else b
    relative = (b-a)*(progress if progress < 0 else progress-1)/endpoint
    softened = relative/hypot(1,relative/RELATIVE_DISPLACEMENT_LIMIT)
    return endpoint*(1+softened) if softened >= 0 else endpoint/(1-softened+softened*softened)


def reconstruct(shape):
    """Reconstruct a positive turning, speed, and arc-spacing description."""
    controls=_controls(_polygon(shape),_sites(shape))
    return Outline(shape.width,shape.height,_fit_cubics(_spline(controls)))


def _flatten_outline(cubics, width, height):
    """Adaptively approximate a finished cubic boundary, without rounding it."""
    points = []
    tolerance = max(width,height)*1e-6

    def flatten(c, depth):
        chord = c[3]-c[0]
        def distance(p):
            if abs(chord) == 0:
                return abs(p-c[0])
            fraction = max(0.,min(1.,((p-c[0]).conjugate()*chord).real/abs(chord)**2))
            return abs(p-c[0]-fraction*chord)
        if max(distance(c[1]),distance(c[2])) <= tolerance:
            points.append(complex(c[0].real/width,c[0].imag/height))
            return
        if depth == 24:
            raise ValueError('The outline cannot be represented at the requested size.')
        a,b,d = (c[0]+c[1])/2,(c[1]+c[2])/2,(c[2]+c[3])/2
        e,f = (a+b)/2,(b+d)/2
        middle = (e+f)/2
        flatten((c[0],a,e,middle),depth+1)
        flatten((middle,f,d,c[3]),depth+1)

    for c in cubics:
        flatten(tuple(complex(p.real*width,p.imag*height) for p in c),0)
    return points


def prepare(cubics, width, height):
    """Prepare one finished, closed convex cubic outline in centered unit bounds.

    Straight segments use collinear cubic controls. There is no initial
    rounding pass, radius requirement, or shape-family dispatch.
    """
    if not all(isfinite(v) and v > 0 for v in (width, height)):
        raise ValueError('Both dimensions must be positive and finite.')
    if not cubics or any(len(c) != 4 or any(len(p) != 2 for p in c) for c in cubics):
        raise ValueError('Provide closed cubic segments, each with four coordinate pairs.')
    curves = tuple(tuple(complex(x,y) for x,y in c) for c in cubics)
    if any(not isfinite(v.real) or not isfinite(v.imag) for c in curves for v in c):
        raise ValueError('Provide a finite convex outline.')
    if any(abs(c[3]-curves[(i+1) % len(curves)][0]) > 1e-10 for i,c in enumerate(curves)):
        raise ValueError('The supplied segments must form one closed boundary.')
    for coordinate in (lambda p:p.real,lambda p:p.imag):
        values = [coordinate(bezier(c,t)) for c in curves
                  for t in [0.,1.,*(v for v in _stationary([coordinate(p) for p in c]) if 0 < v < 1)]]
        if abs(min(values)+.5) > 1e-8 or abs(max(values)-.5) > 1e-8:
            raise ValueError('Normalize each coordinate to centered unit bounds first.')
    p = []
    for point in _flatten_outline(curves,width,height):
        if not p or abs(point-p[-1]) > 1e-12:
            p.append(point)
    if len(p) > 1 and abs(p[-1]-p[0]) < 1e-12:
        p.pop()
    if len(p) < 3:
        raise ValueError('The outline must have positive area.')
    if any(cross(p[(i+1) % len(p)]-v, p[(i+2) % len(p)]-p[(i+1) % len(p)]) < -1e-10
           for i, v in enumerate(p)) or sum(cross(v, p[(i+1) % len(p)]) for i, v in enumerate(p)) <= 0:
        raise ValueError('Use a clockwise, positive-area convex screen outline.')
    edges = [p[(i+1) % len(p)]-v for i, v in enumerate(p)]
    turn = sum(atan2(cross(edges[i-1], e), (edges[i-1].conjugate()*e).real)
               for i, e in enumerate(edges))
    if abs(turn-TAU) > 1e-7:
        raise ValueError('The outline must make exactly one convex turn.')
    return _describe(p,width,height)


def capture(points,width,height):
    """Describe a visible normalized frame while retaining its endpoint polygon."""
    endpoint=Endpoint.from_frame(points,width,height)
    normalized=tuple(complex(p.real/width,p.imag/height) for p in endpoint.points)
    return replace(_describe(normalized,width,height),outline=endpoint)


class Interpolation:
    def __init__(self,a,b):
        self.a,self.b=a,b
        self.physical=Pair(a.endpoint,b.endpoint)
        fa,fb=a.endpoint.features,b.endpoint.features
        self.rounds_corners=self.physical.refines or (not fa and len(fb)>=3) or (not fb and len(fa)>=3)
        self.movement=Movement(self.raw) if self.rounds_corners else None

    def raw(self,t):
        if not self.rounds_corners or t==0 or t==1: return self.physical.frame(t)
        a,b=self.a,self.b; g=curve_progress(t)
        width,height=dimension(a.width,b.width,t),dimension(a.height,b.height,t)
        blend=lambda x,y:tuple(positive(v,w,g) for v,w in zip(x,y))
        shape=Shape(width,height,(1-g)*a.angle+g*b.angle,blend(a.turns,b.turns),blend(a.speeds,b.speeds),blend(a.spacings,b.spacings))
        cubics=reconstruct(shape).cubics
        points=tuple(complex(p.real*width,p.imag*height) for c in cubics for p in (bezier(c,j/4) for j in range(4)))
        rounded=opening(points,.36*min(width,height)*abs(4*g*(1-g)))
        return mix(fit(points,width,height),fit(rounded,width,height),minimum=min(1e-12,max(width,height)*1e-12))

    def frame(self,t):
        return self.raw(self.movement.progress(t)) if self.movement and t!=0 and t!=1 else self.physical.frame(t)


@lru_cache(maxsize=128)
def prepared_pair(a,b):
    return Interpolation(a,b)


def evaluate(a,b,progress):
    if not isfinite(progress):
        raise ValueError("Progress must be finite.")
    width,height = dimension(a.width,b.width,progress),dimension(a.height,b.height,progress)
    if not all(isfinite(v) and v>0 for v in (width,height)):
        raise ValueError("Progress produces unrepresentable dimensions.")
    points = prepared_pair(a,b).frame(progress)
    return Outline(width,height,line_cubics(points))
