from manimlib import *

from euclidlib.Objects import *

def build(scene: PropScene, p1, p2, speed = 1.0):
    with scene.animation_speed(speed):
        c1 = EuclidCircle(p1, p2, scene=scene).e_fade()
        c2 = EuclidCircle(p2, p1, scene=scene).e_fade()

        pts = c1.intersect(c2)

        l1 = VirtualLine(p1, p2, scene=scene)
        l2 = VirtualLine(p2, pts[0], scene=scene)

        th = calculateAngle(l1, l2)
        if th < TAU:
            C = pts[0]
        else:
            C = pts[1]

        p = EuclidPoint(C, scene=scene)
        t = EuclidTriangle(p1, p2, (*C, 0), scene=scene)
        with scene.simultaneous():
            c1.e_remove()
            c2.e_remove()
        return t, p