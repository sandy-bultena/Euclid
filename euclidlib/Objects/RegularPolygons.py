from __future__ import annotations

from euclidlib.Objects import Polygon, ETriangle, EPolygon
from euclidlib.Objects import CalculatePoints
from euclidlib.Objects import Point
from euclidlib.Objects import Line
from euclidlib.Objects import Circle as Cir
from euclidlib.Objects import EucidGroupMObject as Gr
from euclidlib.Objects import Angel as An
from euclidlib.Objects.EucidMObject import *

@anim_speed
def pentagon(center: Point.EPoint | Vect3, radius: float):
    scene: ps.PropScene = find_scene()

    # make circle where we will draw the pentagon
    c = Cir.ECircle(center, center + RIGHT * radius).e_fade()

    # make an arbitrary straight line so that we can create a
    # "golden" rectangle
    cl = center + np.array([1.2 * radius, radius, 0])
    l = Line.ELine(cl, cl + DOWN * radius)
    gold = ETriangle.golden(l, speed=0)

    g2 = gold.copy_to_circle(c)

    with scene.simultaneous():
        l.e_remove()
        gold.e_remove()

    # bisect the angles at the base
    with scene.simultaneous():
        ac = An.EAngle(g2.l1, g2.l0)
        ad = An.EAngle(g2.l2, g2.l1)
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
    pent = EPolygon(*points)

    with scene.simultaneous():
        lx.e_remove()
        ly.e_remove()
        ac.e_remove()
        ad.e_remove()
        g2.e_remove()
        c.e_remove()

    return pent