"""Check reference artifacts and geometric properties independently of emission."""
import json
from dataclasses import replace
from math import atan2, isfinite, pi, cos, sin, tanh, sqrt
from xml.etree import ElementTree
from artifacts import OUTPUT, build, inputs, prepared
from geometry import Endpoint, Pair, continued, line_cubics
from motion import supports
from reference import (PREPARED_MINIMUM, Outline, _flatten_outline,
                       bezier, cross, dimension, evaluate, outline_progress, positive, prepare,
                       capture, prepared_pair)


def straight_outline(points):
    """Finished straight segments for structural and sharp-input checks."""
    return [[a, [(2*a[0]+b[0])/3,(2*a[1]+b[1])/3],
             [(a[0]+2*b[0])/3,(a[1]+2*b[1])/3], b]
            for a,b in zip(points,points[1:]+points[:1])]


class ContourIndex:
    def __init__(self, points, start, end):
        self.points, self.start, self.end = points,start,end
        vertices = [points[i % len(points)] for i in range(start,end+1)]
        self.bounds = (min(p.real for p in vertices),min(p.imag for p in vertices),
                       max(p.real for p in vertices),max(p.imag for p in vertices))
        self.children = None
        if end-start > 8:
            middle = (start+end)//2
            self.children = (ContourIndex(points,start,middle),ContourIndex(points,middle,end))

    def is_near(self, point, squared_tolerance):
        left,top,right,bottom = self.bounds
        dx,dy = max(0,left-point.real,point.real-right),max(0,top-point.imag,point.imag-bottom)
        if dx*dx+dy*dy > squared_tolerance:
            return False
        if self.children:
            return any(child.is_near(point,squared_tolerance) for child in self.children)
        for i in range(self.start,self.end):
            start = self.points[i]
            delta = self.points[(i+1) % len(self.points)]-start
            offset = point-start
            fraction = max(0.,min(1.,(offset.conjugate()*delta).real/abs(delta)**2)) if delta else 0.
            if abs(offset-fraction*delta)**2 <= squared_tolerance:
                return True
        return False


def contour_agreement(a,b,tolerance):
    contours = [[complex(p.real*o.width,p.imag*o.height)
                 for p in _flatten_outline(o.cubics,o.width,o.height)] for o in (a,b)]
    indexes = [ContourIndex(p,0,len(p)) for p in contours]
    return all(indexes[1-i].is_near(p,tolerance*tolerance) for i,c in enumerate(contours) for p in c)


def polynomial(c, u):
    value = 0.
    for a in reversed(c):
        value = value*u+a
    return value


def roots(c):
    """Real roots in [0,1], isolated by derivative roots and bisection."""
    c = list(c)
    while len(c) > 1 and c[-1] == 0:
        c.pop()
    if len(c) == 1:
        return []
    if len(c) == 2:
        u = -c[0]/c[1]
        return [u] if 0 <= u <= 1 else []
    cuts = [0., *roots([i*c[i] for i in range(1, len(c))]), 1.]
    out = []
    for u in cuts:
        if abs(polynomial(c,u)) <= 1e-14*sum(abs(v) for v in c):
            out.append(u)
    for lo, hi in zip(cuts,cuts[1:]):
        a, b = polynomial(c,lo), polynomial(c,hi)
        if a*b >= 0:
            continue
        for _ in range(55):
            mid = (lo+hi)/2
            v = polynomial(c,mid)
            if (a < 0) == (v < 0):
                lo, a = mid, v
            else:
                hi = mid
        out.append((lo+hi)/2)
    return sorted(set(out))


def vertices(o):
    points = []
    for c in o.cubics:
        if not points or abs(c[0]-points[-1])>1e-12:
            points.append(c[0])
    if len(points)>1 and abs(points[-1]-points[0])<1e-12: points.pop()
    return points


def agrees(a,b,tolerance=1e-9):
    pa,pb = vertices(a),vertices(b)
    if len(pa)==len(pb) and all(abs(x-y)<=tolerance for x,y in zip(pa,pb)):
        return True
    ia,ib = ContourIndex(pa,0,len(pa)),ContourIndex(pb,0,len(pb))
    return all(ib.is_near(p,tolerance*tolerance) for p in pa) and all(ia.is_near(p,tolerance*tolerance) for p in pb)


def geometry(o):
    assert all(isfinite(v) and v>0 for v in (o.width,o.height)), 'Invalid dimensions'
    for i,c in enumerate(o.cubics):
        assert all(isfinite(p.real) and isfinite(p.imag) for p in c), 'Nonfinite polygon'
        assert abs(c[3]-o.cubics[(i+1)%len(o.cubics)][0])<1e-11, 'Open join'
    points=vertices(o)
    edges=[points[(i+1)%len(points)]-p for i,p in enumerate(points)]
    assert all(cross(a,b)>=-1e-11 for a,b in zip(edges,edges[1:]+edges[:1])), 'Inward turn'
    assert sum(cross(p,points[(i+1)%len(points)]) for i,p in enumerate(points))>0, 'Nonpositive area'
    for coordinate in (lambda p:p.real,lambda p:p.imag):
        assert abs(min(map(coordinate,points))+.5)<1e-10 and abs(max(map(coordinate,points))-.5)<1e-10, 'Incorrect bounds'
    turn=sum(atan2(cross(a,b),(a.conjugate()*b).real) for a,b in zip(edges,edges[1:]+edges[:1]))
    assert abs(turn-2*pi)<1e-8, 'Incorrect winding'


def measured(points,count=128,rotation=0.):
    return [max(p.real*cos((i+rotation)*2*pi/count)+p.imag*sin((i+rotation)*2*pi/count) for p in points)
            for i in range(count)]


def motion_checks(shapes):
    fixture=json.loads((OUTPUT/'reference.json').read_text())
    for transition in fixture['transitions']:
        pair=prepared_pair(shapes[transition['source']],shapes[transition['destination']])
        for frame in transition['frames']:
            points=pair.frame(frame['progress'])
            assert max(abs(a-b) for a,b in zip(supports(points),measured(points,64)))<1e-11, 'Rotating support mismatch'
    for begin,end in [('triangle','hexagon'),('soft-triangle','soft-hexagon'),('pentagon','triangle')]:
        pair=prepared_pair(shapes[begin],shapes[end]); previous=measured(pair.frame(0),96,.5); distances=[]
        for i in range(1,501):
            current=measured(pair.frame(i/500),96,.5)
            distance=sqrt(sum((a-b)**2 for a,b in zip(current,previous))/96)
            if 25<i<=475: distances.append(distance)
            previous=current
        mean=sum(distances)/len(distances); low,high=min(distances)/mean,max(distances)/mean
        assert low>.85 and high<1.2, f'Uneven motion: {begin} to {end}: {low}, {high}'
        print(f'Even motion {begin} to {end}: {low:.4f}–{high:.4f} of mean',flush=True)


def rounded_retarget_checks(shapes):
    a,b=shapes['soft-triangle'],shapes['soft-hexagon']; source=a; worst_exact=0.; worst_near=0.; maximum_vertices=0
    for i in range(12):
        target=b if i%2==0 else a
        pair=prepared_pair(source,target)
        if source.outline:
            expected=measured(source.outline.points)
            for t in (0.,1e-7):
                actual=measured(tuple(complex(p.real*source.width,p.imag*source.height) for p in pair.frame(t)))
                error=max(abs(x-y) for x,y in zip(expected,actual))
                if t==0:
                    worst_exact=max(worst_exact,error); assert error<1e-8
                else:
                    worst_near=max(worst_near,error); assert error<max(.05,.002*max(source.width,source.height))
        width=dimension(source.width,target.width,.37);height=dimension(source.height,target.height,.37)
        source=capture(pair.frame(.37),width,height)
        maximum_vertices=max(maximum_vertices,len(source.outline.points))
    assert maximum_vertices<1600
    print(f'Passed 12 rounded retargets; exact endpoint error {worst_exact:.3g} px; near-endpoint refit {worst_near:.3g} px; maximum {maximum_vertices} vertices.',flush=True)


def retarget_checks():
    shapes=prepared(inputs())
    a,b=shapes['capsule'].endpoint,shapes['rounded'].endpoint
    source=a
    maximum=0
    for i in range(120):
        target=b if i%2==0 else a
        width=dimension(source.width,target.width,.37)
        height=dimension(source.height,target.height,.37)
        points=Pair(source,target).frame(.37)
        endpoint=Endpoint.from_frame(points,width,height)
        maximum=max(maximum,len(endpoint.points))
        before=Outline(width,height,line_cubics(points))
        after=Outline(width,height,line_cubics(tuple(complex(p.real/width,p.imag/height) for p in endpoint.points)))
        geometry(after)
        assert contour_agreement(before,after,.0030001), 'Retarget compaction drift'
        source=endpoint
    assert maximum<1600, 'Redundant edges accumulate across retargets'
    print(f'Passed 120 consecutive retargets; maximum prepared vertices {maximum}.',flush=True)


def verify():
    rows = inputs()
    shapes = prepared(rows)
    for row in rows:
        shape = shapes[row['id']]
        source = Outline(row['width'],row['height'],tuple(tuple(complex(*p) for p in c) for c in row['cubics']))
        assert contour_agreement(source,evaluate(shape,shape,0.),max(.5,.002*max(shape.width,shape.height))), row['id']
        assert all(v >= PREPARED_MINIMUM for v in (*shape.speeds,*shape.spacings))
    print('Passed finished-outline endpoint agreement and prepared positivity.',flush=True)
    values = list(shapes.values())
    times = sorted(set([-.5+i*.02 for i in range(101)]+[
        join+offset for join in [0.,.25,.75,1.]
        for offset in [-1e-4,-1e-6,0.,1e-6,1e-4]]))
    states = 0
    for i,a in enumerate(values):
        still = evaluate(a,a,0.)
        for t in times:
            assert agrees(still,evaluate(a,a,t)), 'Identity drift'
            identity = evaluate(a,a,t)
            assert abs(identity.width-a.width) < 1e-10 and abs(identity.height-a.height) < 1e-10, 'Identity bounds drift'
        for b in values[i+1:]:
            for t in times:
                o = evaluate(a,b,t)
                geometry(o)
                assert agrees(o,evaluate(b,a,1-t)), 'Reversal mismatch'
                if t in (0.,1.):
                    endpoint = a if t == 0 else b
                    assert agrees(o,evaluate(endpoint,endpoint,0.)), 'Partner-dependent endpoint'
                reverse = evaluate(b,a,1-t)
                assert abs(o.width-reverse.width) < 1e-10 and abs(o.height-reverse.height) < 1e-10
                assert abs(o.width-dimension(a.width,b.width,t)) < 1e-10
                assert abs(o.height-dimension(a.height,b.height,t)) < 1e-10
                if 0 <= t <= 1:
                    assert abs(o.width-((1-t)*a.width+t*b.width)) < 1e-10
                    assert abs(o.height-((1-t)*a.height+t*b.height)) < 1e-10
                states += 1
    stress = 0
    targets = {'vertical','triangle','pentagon','kite','rounded','rectangle'}
    for aspect in [.01,.1,10.,100.]:
        a_shapes = {s['id']:prepare(s['cubics'],s['width']*aspect,s['height']) for s in rows}
        b_shapes = {s['id']:prepare(s['cubics'],s['width'],s['height']/aspect) for s in rows if s['id'] in targets}
        for a in a_shapes.values():
            for b in b_shapes.values():
                for t in [-.5,-.25,-1e-6,.01,.2,.4,.6,.8,.99,1+1e-6,1.25,1.5]:
                    geometry(evaluate(a,b,t))
                    stress += 1
    for a in values:
        for factor in [1e-4,1e4]:
            scaled = replace(a,width=a.width*factor,height=a.height*factor)
            for t in [-.5,.1,.5,.9,1.5]:
                base = evaluate(a,values[0],t)
                large = evaluate(scaled,replace(values[0],width=values[0].width*factor,height=values[0].height*factor),t)
                # Pixel-based subdivision can change feature classification at
                # a threshold; this contract does not assert scale invariance.
                geometry(large)
                assert abs(large.width/factor-base.width) < 1e-10
                assert abs(large.height/factor-base.height) < 1e-10
    sharp = straight_outline([[-.5,-.5],[.5,-.5],[.5,.5],[-.5,.5]])
    shape = prepare(sharp,240,160)
    assert PREPARED_MINIMUM in shape.speeds, 'Zero speeds must receive the positive minimum'
    for t in times:
        geometry(evaluate(shape,values[0],t))
    invalid = [([],1,1),(sharp,0,1),(sharp[:-1],1,1),
               (straight_outline([[-.5,-.5],[0,.5],[.5,-.5]]),1,1),
               (straight_outline([[-.5,-.5],[.5,-.5],[0,0],[.5,.5],[-.5,.5]]),1,1)]
    for cubics,w,h in invalid:
        try:
            prepare(cubics,w,h)
        except ValueError:
            pass
        else:
            raise AssertionError('Invalid source accepted')
    for t in [float('-inf'),float('inf'),float('nan')]:
        try:
            evaluate(values[0],values[1],t)
        except ValueError:
            pass
        else:
            raise AssertionError('Invalid progress accepted')
    for name,text in build().items():
        assert (OUTPUT/name).read_text() == text, f'Stale artifact: {name}'
        if name.endswith('.svg'):
            root = ElementTree.fromstring(text)
            assert root.find('{http://www.w3.org/2000/svg}title') is not None
            assert root.find('{http://www.w3.org/2000/svg}desc') is not None
    fixture = json.loads((OUTPUT/'reference.json').read_text())
    assert len(fixture['endpoints']) == 16 and len(fixture['transitions']) == 8
    motion_checks(shapes)
    rounded_retarget_checks(shapes)
    retarget_checks()
    scalar_checks()
    print(f'Passed: 120 pairs, {states} geometry states, {stress} aspect cases, identity, reversal, endpoint independence, scaling, invalid inputs, and reproducible JSON/SVG artifacts.')


def scalar_checks():
    for a,b in [(48.,280.),(280.,48.),(72.,144.),(72.,72.)]:
        for i in range(2001):
            t = -.5+i*.001
            value = dimension(a,b,t)
            assert abs(value-dimension(b,a,1-t)) < 1e-10
            if 0 <= t <= 1:
                assert value == positive(a,b,t)
            else:
                endpoint = a if t < 0 else b
                assert endpoint/1.24 <= value <= endpoint*1.2
        for join in [0.,1.]:
            h = -1e-4 if join == 0 else 1e-4
            def correction(h):
                return abs(dimension(a,b,join+h)-((1-join-h)*a+(join+h)*b))
            assert correction(h/2) <= correction(h)*.14+1e-12
    assert abs(dimension(240.,144.,1.1)-134.926774) < 1e-6
    assert abs(dimension(280.,48.,1.1)-39.377971) < 1e-6
    # Check the mapping separately from rendered curves, including join slopes.
    previous = float('-inf')
    for i in range(2001):
        t = -.5+i*.001
        g = outline_progress(t)
        assert g >= previous and -.08 < g < 1.08
        assert abs(g+outline_progress(1-t)-1) < 1e-14
        if 0 <= t <= 1:
            assert g == t
        previous = g
        for a,b in [(1.,3.),(3.,1.),(2.,2.)]:
            value = positive(a,b,t)
            assert value > 0 and abs(value-positive(b,a,1-t)) < 1e-14
            if 0 <= t <= 1:
                assert value == (1-t)*a+t*b
    mapped=outline_progress
    for join in [0.,1.]:
        h=1e-6
        for sign in [-1,1]:
            assert abs((mapped(join+sign*h)-mapped(join))/(sign*h)-1)<1e-7
    for t in [-.08,-.01,0.,.5,1.,1.01,1.08]:
        assert continued(0.,100.,t)>=0 and continued(100.,0.,t)>=0
    assert abs(positive(144.,48.,1.2)-48/1.56) < 1e-12
    for a,b in [(1.,3.),(3.,1.)]:
        for join in [0.,1.]:
            h = 1e-5
            v = positive(a,b,join)
            for sign in [-1,1]:
                first = (positive(a,b,join+sign*h)-v)/(sign*h)
                second = (positive(a,b,join+sign*2*h)-2*positive(a,b,join+sign*h)+v)/(h*h)
                assert abs(first-(b-a)) < 1e-7 and abs(second) < .005


if __name__ == '__main__':
    verify()
