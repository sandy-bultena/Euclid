from euclidlib.Objects import Circle, find_scene
from euclidlib.Objects import ps, mn
from euclidlib.Objects import Line as L
from euclidlib.Objects import Angel
from euclidlib.Objects import Point as P
from euclidlib.Objects import Triangle as T

def build(p1, p2, scene: ps.PropScene = None, speed = 1.0):
    scene = scene or find_scene()
    with scene.animation_speed(speed):
        c1 = Circle.EuclidCircle(p1, p2, scene=scene).e_fade()
        c2 = Circle.EuclidCircle(p2, p1, scene=scene).e_fade()

        pts = c1.intersect(c2)
        l1 = L.VirtualLine(p1, p2)
        l2 = L.VirtualLine(p2, pts[0])

        th = Angel.calculateAngle(l2, l1)
        if th < mn.PI:
            C = pts[0]
        else:
            C = pts[1]

        p = P.EuclidPoint(C, scene=scene)
        t = T.EuclidTriangle(p1, p2, C, scene=scene)
        with scene.simultaneous():
            c1.e_remove()
            c2.e_remove()
            l1.e_remove()
            l2.e_remove()
        t.replace_point(-1, p)
    return t, p