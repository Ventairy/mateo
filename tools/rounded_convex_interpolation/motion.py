"""Convex disk opening and a monotone inverse of outline movement."""
from bisect import bisect_right
from math import atan2, ceil, cos, pi, sin, sqrt, tanh
from geometry import compact

TAU = 2*pi


def curve_progress(t):
    def f(u): return u+.9*u**3*(4-7*u+3*u*u)
    if t < 0: return .02*tanh(5*t)
    if t < .25: return .25*(1-f(1-4*t))
    if t <= .75: return t
    if t <= 1: return .75+.25*f(4*t-3)
    return 1+.02*tanh(5*(t-1))


def fit(points, width=1., height=1.):
    x0,x1=min(p.real for p in points),max(p.real for p in points)
    y0,y1=min(p.imag for p in points),max(p.imag for p in points)
    return tuple(complex((p.real-(x0+x1)/2)*width/(x1-x0),
                         (p.imag-(y0+y1)/2)*height/(y1-y0)) for p in points)


def opening(points, requested_radius):
    if requested_radius < 1e-6: return points
    points=compact(points,min(.003,requested_radius*.003))
    lines=[]; area=0.; centroid=0j
    for i,p in enumerate(points):
        q=points[(i+1)%len(points)]; d=q-p; length=abs(d)
        cross=(p.conjugate()*q).imag
        area+=cross; centroid+=(p+q)*cross
        if length < 1e-9: continue
        n=d*1j/length
        lines.append((atan2(n.imag,n.real)%TAU,n,(n.conjugate()*p).real))
    if area <= 0 or len(lines)<3: raise ValueError('Expected a convex outline.')
    centroid/=3*area
    available=min((n.conjugate()*centroid).real-h for _,n,h in lines)
    radius=min(requested_radius,.9*available)
    if radius < 1e-6: return points
    unique=[]
    for angle,n,h in sorted(lines,key=lambda l:l[0]):
        h+=radius
        if unique and angle-unique[-1][0]<1e-9:
            a,v,k=unique[-1]; unique[-1]=(a,v,max(k,h))
        else: unique.append((angle,n,h))
    if len(unique)>1 and unique[0][0]+TAU-unique[-1][0]<1e-9:
        a,n,h=unique[0]; unique[0]=(a,n,max(h,unique.pop()[2]))
    def intersection(a,b):
        _,u,h=a; _,v,k=b; det=(u.conjugate()*v).imag
        if abs(det)<1e-12: return None
        return complex((h*v.imag-u.imag*k)/det,(u.real*k-h*v.real)/det)
    def outside(line,p): return p is None or (line[1].conjugate()*p).real<line[2]-1e-11
    queue=[]; first=0
    for line in unique:
        while len(queue)-first>1 and outside(line,intersection(queue[-2],queue[-1])): queue.pop()
        while len(queue)-first>1 and outside(line,intersection(queue[first],queue[first+1])): first+=1
        queue.append(line)
    while len(queue)-first>2 and outside(queue[first],intersection(queue[-2],queue[-1])): queue.pop()
    while len(queue)-first>2 and outside(queue[-1],intersection(queue[first],queue[first+1])): first+=1
    active=queue[first:]; rounded=[]
    if len(active)<3: raise ValueError('The rounding inset collapsed.')
    for i,a in enumerate(active):
        b=active[(i+1)%len(active)]; center=intersection(a,b)
        if center is None: raise ValueError('Parallel rounding supports.')
        angle=(a[0]+pi)%TAU; turn=(b[0]-a[0])%TAU; steps=max(1,ceil(turn/.04))
        for j in range(steps+1):
            if j==0: rounded.append(center-radius*a[1])
            elif j==steps: rounded.append(center-radius*b[1])
            else:
                theta=angle+turn*j/steps
                rounded.append(center+radius*complex(cos(theta),sin(theta)))
    return rounded


def mix(a,b,weight=.3,minimum=1e-12):
    edges=[]
    for points,w in ((a,1-weight),(b,weight)):
        for i,p in enumerate(points):
            d=(points[(i+1)%len(points)]-p)*w
            if abs(d)>minimum: edges.append((atan2(d.imag,d.real)%TAU,d))
    points=[]; p=0j
    for _,d in sorted(edges,key=lambda e:e[0]): points.append(p); p+=d
    return fit(points)


def supports(points, count=64):
    """Convex rotating support vertex; linear in vertices plus directions."""
    n=len(points); vertex=max(range(n),key=lambda i:points[i].real); values=[]
    for k in range(count):
        direction=complex(cos(TAU*k/count),sin(TAU*k/count))
        def dot(i): return (points[i%n].conjugate()*direction).real
        value=dot(vertex)
        for _ in range(n):
            following=dot(vertex+1)
            if following<value-1e-13: break
            vertex=(vertex+1)%n; value=following
        values.append(value)
    return values


class Movement:
    def __init__(self, frame):
        count=257; previous=None; cumulative=[0.]; total=0.
        for i in range(count):
            values=supports(frame(i/(count-1)))
            if previous is not None:
                total+=sqrt(sum((a-b)**2 for a,b in zip(values,previous))/64)
                cumulative.append(total)
            previous=values
        if total<1e-9:
            self.x,self.y,self.slopes=[0.,1.],[0.,1.],[1.,1.]; return
        rows=[]
        for i,value in enumerate(cumulative):
            x=value/total; y=i/(count-1)
            if rows and x-rows[-1][0]<1e-12: rows[-1]=(rows[-1][0],y)
            else: rows.append((x,y))
        rows[0]=(0.,0.); rows[-1]=(1.,1.)
        self.x=[r[0] for r in rows]; self.y=[r[1] for r in rows]
        h=[b-a for a,b in zip(self.x,self.x[1:])]
        d=[(b-a)/v for a,b,v in zip(self.y,self.y[1:],h)]
        def end(h0,h1,d0,d1): return max(0.,min(3*d0,((2*h0+h1)*d0-h0*d1)/(h0+h1)))
        m=[end(h[0],h[1],d[0],d[1]) if len(d)>1 else d[0]]
        for i in range(1,len(rows)-1):
            w1,w2=2*h[i]+h[i-1],h[i]+2*h[i-1]
            m.append(0. if d[i-1]*d[i]<=0 else (w1+w2)/(w1/d[i-1]+w2/d[i]))
        m.append(end(h[-1],h[-2],d[-1],d[-2]) if len(d)>1 else d[0])
        self.slopes=m

    def progress(self,t):
        x,y,m=self.x,self.y,self.slopes
        if t<=0: return m[0]*t
        if t>=1: return 1+m[-1]*(t-1)
        b=bisect_right(x,t); a=b-1; h=x[b]-x[a]; u=(t-x[a])/h
        return (2*u**3-3*u*u+1)*y[a]+(u**3-2*u*u+u)*h*m[a]+(-2*u**3+3*u*u)*y[b]+(u**3-u*u)*h*m[b]
