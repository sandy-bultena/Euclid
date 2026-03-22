from __future__ import annotations
import numpy as np

from euclidlib.Objects.em_object_decorators import *
import euclidlib.Scenes.PropScene as ps

from . import Polygon
from . import Triangle
from . import Point
from . import Line
from . import Circle
from . import Angle

@anim_speed
def pentagon(center: Point.EPoint | mn.Vect3, radius: float):
    scene: ps.PropScene = find_scene()

    # make circle where we will draw the pentagon
    c = Circle.ECircle(center, center + mn.RIGHT * radius).e_fade()

    # make an arbitrary straight line so that we can create a
    # "golden" rectangle
    cl = center + np.array([1.2 * radius, radius, 0])
    l = Line.ELine(cl, cl + mn.DOWN * radius)
    gold = Triangle.ETriangle.golden(l, speed=0)

    g2 = gold.copy_as_chord(c)

    with scene.simultaneous():
        l.e_remove()
        gold.e_remove()

    # bisect the angles at the base
    with scene.simultaneous():
        ac = Angle.EAngle(g2.l1, g2.l0)
        ad = Angle.EAngle(g2.l2, g2.l1)
    with scene.simultaneous():
        lx = ac.clean_bisect()
        ly = ad.clean_bisect()
    with scene.simultaneous():
        lx.extend_and_prepend(2.3 * radius)
        ly.extend_and_prepend(2.3 * radius)

    # find intersection points
    px = c.intersect(lx)
    py = c.intersect(ly)

    # with scene.run_animations_for():
    #     c.e_draw()
    #     g2.e_draw()
    #     lx.e_draw()
    #     ly.e_draw()

    # define the points of the pentagon
    points = [
        g2.p0,
        py[1],
        g2.p1,
        g2.p2,
        px[0]
    ]

    # make pentagon
    pent = Polygon.EPolygon(*points)

    with scene.simultaneous():
        lx.e_remove()
        ly.e_remove()
        ac.e_remove()
        ad.e_remove()
        g2.e_remove()
        c.e_remove()

    return pent