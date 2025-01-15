from euclidlib.Objects import Circle
from euclidlib.Objects import ps, mn
from euclidlib.Objects import Line as L
from euclidlib.Objects import Angel
from euclidlib.Objects import Point as P
from euclidlib.Objects import Triangle as T

def build(scene: ps.PropScene, p1, p2, speed = 1.0):
    with scene.animation_speed(speed):
        c1 = Circle.EuclidCircle(p1, p2, scene=scene).e_fade()
        c2 = Circle.EuclidCircle(p2, p1, scene=scene).e_fade()

        pts = c1.intersect(c2)

        l2 = L.VirtualLine(p2, p1, scene=scene)
        l1 = L.VirtualLine(p2, pts[0], scene=scene)

        th = Angel.calculateAngle(l1, l2)
        if th < mn.PI:
            C = pts[0]
        else:
            C = pts[1]

        p = P.EuclidPoint(C, scene=scene)
        t = T.EuclidTriangle(p1, p2, (*C, 0), scene=scene)
        with scene.simultaneous():
            c1.e_remove()
            c2.e_remove()
        return t, p