from __future__ import annotations
import manimlib as mn
from euclidlib.Objects.Circle import ECircle
from euclidlib.Utilities.find_scene import find_scene
import  euclidlib.Scenes.PropScene as ps

from euclidlib.Objects import Line
from euclidlib.Objects import Angle
from euclidlib.Objects import Point
from euclidlib.Objects import Triangle

# =====================================================================================================================
# build an equilateral triangle given two points
# =====================================================================================================================
def build(p1, p2, scene: ps.PropScene = None, speed = 1.0):
    scene = scene or find_scene()

    # have everything drawn at the same speed
    with scene.animation_speed(speed):
        c1 = ECircle(p1, p2, scene=scene).e_fade()
        c2 = ECircle(p2, p1, scene=scene).e_fade()

        pts = c1.intersect(c2)
        l1 = Line.VirtualLine(p1, p2)
        l2 = Line.VirtualLine(p2, pts[0])

        th = Angle.calculateAngle(l2, l1)
        if th < mn.PI:
            C = pts[0]
        else:
            C = pts[1]

        p = Point.EPoint(C, scene=scene)
        t = Triangle.ETriangle(p1, p2, C, scene=scene)
        with scene.simultaneous():
            c1.e_remove()
            c2.e_remove()
            l1.e_remove()
            l2.e_remove()
        t.replace_point(-1, p)
    return t