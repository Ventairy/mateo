"""Physical edge interpolation and straight-feature classification."""
from dataclasses import dataclass
from math import atan2, cos, sin, pi, tanh, isfinite

TAU = 2*pi
DEG = pi/180
FLATNESS = .003
COMPACTION = .02


def distance(p, a, b):
    d = b-a
    f = max(0., min(1., ((p-a).conjugate()*d).real/abs(d)**2)) if d else 0.
    return abs(p-a-f*d)


def tolerance(ordinary,longest):
    return max(longest*1e-8,min(ordinary,longest*1e-3))


def flatten(cubics,flatness=FLATNESS):
    points = []
    def split(c, depth=0):
        if max(distance(c[1],c[0],c[3]), distance(c[2],c[0],c[3])) <= flatness:
            points.append(c[0]); return
        if depth >= 24:
            raise ValueError('The endpoint cannot be represented at the requested size.')
        a,b,d = (c[0]+c[1])/2,(c[1]+c[2])/2,(c[2]+c[3])/2
        e,f = (a+b)/2,(b+d)/2
        m = (e+f)/2
        split((c[0],a,e,m),depth+1); split((m,f,d,c[3]),depth+1)
    for c in cubics:
        split(c)
    return tuple(points)


def compact(points,error=COMPACTION):
    n = len(points)
    anchors = sorted({max(range(n),key=lambda i: sign*coordinate(points[i]))
                      for coordinate in (lambda p:p.real,lambda p:p.imag) for sign in (-1,1)})
    keep = set(anchors)
    def split(a,b):
        maximum,index = error,-1
        for j in range(a+1,b):
            d = distance(points[j%n],points[a%n],points[b%n])
            if d > maximum:
                maximum,index = d,j
        if index >= 0:
            keep.add(index%n); split(a,index); split(index,b)
    for i,a in enumerate(anchors):
        split(a,anchors[(i+1)%len(anchors)]+(n if i==len(anchors)-1 else 0))
    return tuple(points[i] for i in sorted(keep))


def edges(points,minimum=1e-10):
    result = []
    for i,p in enumerate(points):
        d = points[(i+1)%len(points)]-p
        if abs(d) >= minimum:
            result.append((atan2(d.imag,d.real)%TAU,abs(d)))
    return sorted(result,key=lambda e:e[0])


def features(outline, width, height):
    # Sliding angular windows anchor grouping to geometry, not an arbitrary
    # seam chosen among almost equal gaps in a symmetric outline.
    extended=[(a-TAU,l) for a,l in outline]+list(outline)+[(a+TAU,l) for a,l in outline]
    candidates=[]
    low=high=0
    total=0.
    for angle,_ in outline:
        while high<len(extended) and extended[high][0]<=angle+DEG/2:
            total+=extended[high][1]; high+=1
        while low<high and extended[low][0]<angle-DEG/2:
            total-=extended[low][1]; low+=1
        if total>=.18*min(width,height):
            start,end=extended[low][0],extended[high-1][0]
            candidates.append((total,(start+end)/2%TAU,end-start))
    result=[]
    for length,angle,span in sorted(candidates,key=lambda c:(-c[0],c[1])):
        if not any(abs(atan2(sin(angle-a),cos(angle-a)))<3*DEG for a,_ in result):
            result.append((angle,span))
    return sorted(result)


def spread(angle, own, other):
    if len(other)<2:
        return 0.
    feature = next((f for f in own if abs(atan2(sin(angle-f[0]),cos(angle-f[0])))<=f[1]/2+1e-8),None)
    if feature is None or any(abs(atan2(sin(feature[0]-f[0]),cos(feature[0]-f[0])))<3*DEG for f in other):
        return 0.
    left = min((feature[0]-f[0])%TAU for f in other)
    right = min((f[0]-feature[0])%TAU for f in other)
    u = max(0.,min(1.,(pi-left-right-6*DEG)/(pi/3-6*DEG)))
    return min(left,right)*.9*u*u*(3-2*u)


@dataclass(frozen=True)
class Endpoint:
    width: float
    height: float
    points: tuple
    edges: tuple
    features: tuple
    compact: tuple

    @classmethod
    def from_frame(cls,points,width,height):
        longest=max(width,height)
        physical=tuple(complex(p.real*width,p.imag*height) for p in points)
        ring=compact(physical,tolerance(FLATNESS,longest))
        e=edges(ring,min(1e-10,longest*1e-12))
        return cls(width,height,ring,tuple(e),tuple(features(e,width,height)),compact(ring,tolerance(COMPACTION,longest)))

    @classmethod
    def create(cls,cubics,width,height):
        longest=max(width,height)
        points = flatten(cubics,tolerance(FLATNESS,longest))
        e = edges(points,min(1e-10,longest*1e-12))
        return cls(width,height,points,tuple(e),tuple(features(e,width,height)),compact(points,tolerance(COMPACTION,longest)))


class Pair:
    def __init__(self,a,b):
        self.a,self.b = a,b
        self.minimum=min(1e-12,max(a.width,a.height,b.width,b.height)*1e-12)
        merged = []
        i=j=0
        while i<len(a.edges) or j<len(b.edges):
            aa = a.edges[i][0] if i<len(a.edges) else float('inf')
            ab = b.edges[j][0] if j<len(b.edges) else float('inf')
            if abs(aa-ab)<1e-10:
                merged.append((aa,a.edges[i][1],b.edges[j][1])); i+=1; j+=1
            elif aa<ab:
                merged.append((aa,a.edges[i][1],0.)); i+=1
            else:
                merged.append((ab,0.,b.edges[j][1])); j+=1
        self.refines = any(spread(angle,own,other)>1e-7 for angle,_,_ in merged
                           for own,other in ((a.features,b.features),(b.features,a.features)))
        self.base = tuple((complex(cos(angle),sin(angle)),x,y,0.) for angle,x,y in merged)

    def frame(self,t):
        if not isfinite(t): raise ValueError('Progress must be finite.')
        q = outline_progress(t)
        source = self.base
        weights = [continued(a,b,q,self.minimum) for _,a,b,_ in source]
        mean = sum(w*e[0] for w,e in zip(weights,source))/sum(weights)
        p,points = 0j,[]
        for w,(direction,_,_,_) in zip(weights,source):
            points.append(p); p+=w*(direction-mean)
        x0,x1=min(p.real for p in points),max(p.real for p in points)
        y0,y1=min(p.imag for p in points),max(p.imag for p in points)
        if not x1>x0 or not y1>y0: raise ValueError('The contour must have positive area.')
        return tuple(complex((p.real-(x0+x1)/2)/(x1-x0),(p.imag-(y0+y1)/2)/(y1-y0)) for p in points)


def continued(a,b,t,minimum=1e-12):
    if 0<=t<=1: return (1-t)*a+t*b
    a,b=max(minimum,a),max(minimum,b)
    x,z=(a,(b-a)*t) if t<0 else (b,(b-a)*(t-1))
    if z>=0: return x+z
    q=-z/x
    return x/(1+q+q*q)


def line_cubics(points):
    return tuple((p,(2*p+points[(i+1)%len(points)])/3,(p+2*points[(i+1)%len(points)])/3,points[(i+1)%len(points)]) for i,p in enumerate(points))


def outline_progress(t):
    return .08*tanh(t/.08) if t<0 else 1+.08*tanh((t-1)/.08) if t>1 else t
