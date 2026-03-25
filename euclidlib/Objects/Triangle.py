from __future__ import annotations

import math
from itertools import pairwise
from math import  cos, sin, atan
from typing import Self, Optional

import numpy as np
import manimlib as mn
from euclidlib.Objects.em_object_base import EMObject
from euclidlib.Objects.em_object_decorators import *
from euclidlib.Utilities.coordinate_utilities import convert_to_coord, mn_scale, get_dist

from . import Polygon, Parallelogram
from . import em_group_object as GroupObject
from . import Parallelogram as Para
from . import Line
from . import Point
from . import Angle
from . import Circle

# ====================================================================================================================
# ETriangle
# ====================================================================================================================

class ETriangle(Polygon.EPolygonBase):

    # ---------------------------------------------------------------------------------------------------------------
    # length of / angle of --- helper functions
    # ---------------------------------------------------------------------------------------------------------------
    @staticmethod
    def length_of(val: float | Line.ELine)->float:
        if isinstance(val, mn.TipableVMobject):
            return val.get_length()
        return val

    @staticmethod
    def angle_of(val: float | Angle.EAngleBase) ->float:
        if isinstance(val, Angle.EAngleBase):
            return val.e_angle
        return val

    # ---------------------------------------------------------------------------------------------------------------
    # Create a Triangle Side-Angle-Side
    # ---------------------------------------------------------------------------------------------------------------
    @classmethod
    def SAS(cls,
            point: Point.EPoint | mn.Vect3,
            side1: float | Line.ELine,
            angle: float | Angle.EAngleBase,
            side3: float | Line.ELine,
            labels: Polygon.LABEL_ARGS = None,
            point_labels: Polygon.LABEL_ARGS = None,
            **kwargs) -> Self:
        '''
        create a Triangle with 1st and 3rd side defined, with the angle defined

        the triangle will always be drawn such that the calculated line will be horizontal
        :param point: coordinate of one vertex of the triangle
        :param side1: length of one side
        :param angle: angle
        :param side3: length of other side
        :param labels: iterable defining label arguments
        :param point_labels: iterable defining point label arguments
        :param kwargs: animation arguments
        :return:
        '''

        p2, p3, _ = cls._calculate_SAS(convert_to_coord(point),
                                      cls.length_of(side1),
                                      cls.angle_of(angle),
                                      cls.length_of(side3))
        return cls(point, p2, p3, labels=labels, point_labels=point_labels, **kwargs)

    @classmethod
    def _calculate_SAS(cls, point: mn.Vect3, r1: float, angle: float, r2: float)->tuple[np.array, np.array, float]:
        x1, y1, _ = point
        theta = atan((r1 - r2 * cos(angle)) /
                     (r2 * sin(angle)))
        h1 = r1 * cos(theta)
        d1 = r1 * sin(theta)
        d2 = r2 * sin(angle - theta)

        x2 = x1 - d1
        x3 = x1 + d2
        y3 = y2 = y1 - h1
        return np.array([x2, y2, 0]), np.array([x3, y3, 0]), d1 + d2

    # ---------------------------------------------------------------------------------------------------------------
    # Create a Triangle Side-Side-Side
    # ---------------------------------------------------------------------------------------------------------------
    @classmethod
    def SSS(cls,
            base: EMObject | mn.Vect3,
            *sides: float | Line.ELine,
            labels: Polygon.LABEL_ARGS = None,
            point_labels: Polygon.LABEL_ARGS = None,
            **kwargs):
        assert (len(sides) == 3)

        speed = kwargs.pop('speed',-1)

        # find the vertices
        coord = convert_to_coord(base)
        r = [cls.length_of(s) for s in sides]

        p1, p2, p3 = cls._calculate_SSS(coord, *r)
        if p2 is None:
            return p1

        # animate the construction
        if speed > 0:
            c1 = Circle.ECircle(p2, p2 + mn.RIGHT * r[0])
            c1.e_fade()
            l2 = Line.ELine(p2, p3)

            c2 = Circle.ECircle(p3, p3 + r[2] * mn.RIGHT)
            c2.e_fade()

            new = cls(p1, p2, p3,
                      labels=labels,
                      point_labels=point_labels,
                      **kwargs)

            with new.scene.simultaneous():
                c1.e_remove()
                c2.e_remove()
                l2.e_remove()

        # just create the triangle, with no animation of construction
        else:
            new = cls(p1, p2, p3,
                      labels=labels,
                      point_labels=point_labels,
                      **kwargs)

        return new

    @classmethod
    def _calculate_SSS(cls, coord: mn.Vect3, *r: float)->tuple[Optional[mn.Vect3], Optional[mn.Vect3], Optional[mn.Vect3]]:
        next = coord + mn.RIGHT * r[1]
        c1 = Circle.VirtualCircle(coord, coord + mn.RIGHT * r[0])
        c2 = Circle.VirtualCircle(next, next + mn.RIGHT * r[2])
        p3s = c1.intersect(c2)
        c1.e_delete()
        c2.e_delete()
        if not p3s:
            mn.log.warn("circles don't intersect")
            return p3s, None, None
        if p3s[0][1] > p3s[1][1]:
            xy1 = p3s[0]
        else:
            xy1 = p3s[1]
        return xy1, coord, next

    # ---------------------------------------------------------------------------------------------------------------
    # parallelogram
    # ---------------------------------------------------------------------------------------------------------------
    @log
    @anim_speed
    def parallelogram(self, angle: Angle.EAngleBase) -> tuple[Parallelogram.EParallelogram, Angle.EAngle]:
        '''Create a parallelogram from the triangle'''

        # bisect the 2nd line
        point = self.l[1].bisect(speed=0)
        l = Line.ELine(self.p[1], self.p[2])
        l.e_fade()
        l1, l2 = l.e_split(point)
        with self.scene.simultaneous():
            l1.red()
            l2.blue()

        # Copy angle onto 2nd triangle line EC at bisect point
        side1, angle2 = angle.copy_to_line(point, l2, speed=0)
        side1.extend(mn_scale(100))
        side1.red()

        # Draw a line through triangle point 1, parallel triangle line 2
        with self.scene.trace(self.l[1], "Draw a line through triangle point 1, parallel triangle line 2"):
            line2 = self.l[1].parallel(self.p[0], speed=0)
            line2.blue()
            point2 = Point.EPoint(line2.intersect_line(side1)[0])

        # Draw a line through triangle point 3, parallel to side 1
        with self.scene.trace(side1, "Draw a line through triangle point 3, parallel to side 1"):
            line3 = side1.parallel(self.p[2], speed=0)
            line3.green()
            point3 = Point.EPoint(line3.intersect_line(line2)[0])

        # construct polygon
        poly = Para.EParallelogram(point2, point, self.p[2], point3)

        with self.scene.simultaneous():
            side1.e_remove()
            line2.e_remove()
            line3.e_remove()
            l1.e_remove()
            l2.e_remove()
            point.e_remove()
            point2.e_remove()
            point3.e_remove()

        return poly, angle2

    # ---------------------------------------------------------------------------------------------------------------
    # copy to parallelogram on line
    # ---------------------------------------------------------------------------------------------------------------
    @log
    @copy_transform()
    def copy_to_parallelogram_on_line(self, line: Line.ELine, angle: Angle.EAngleBase, speed = -1):
        # create parallelogram equal in size to triangle (I.42)
        s1, a2 = self.parallelogram(angle, speed=speed)
        a2.e_remove()

        # copy this parallelogram to the line
        s4 = s1.copy_to_line(line, speed=speed)
        s1.e_remove()
        return s4

    # ---------------------------------------------------------------------------------------------------------------
    # circumscribe
    # ---------------------------------------------------------------------------------------------------------------
    @log
    @anim_speed
    def circumscribe(self):
        # bisect two sides of the triangle
        pD = self.l[0].bisect()
        pE = self.l[2].bisect()

        # Find the centre of the circle
        l1 = self.l[0].perpendicular(pD, side = Line.LineLabelSide.INSIDE)
        l2 = self.l[2].perpendicular(pE, side = Line.LineLabelSide.INSIDE)
        p =  l1.intersect_line(l2)[0]
        p2 = Point.EPoint(p)
        c = Circle.ECircle(p, self.p[0])

        with self.scene.simultaneous():
            l1.e_remove()
            l2.e_remove()
            pD.e_remove()
            pE.e_remove()
            p2.e_remove()

        return c


    # ---------------------------------------------------------------------------------------------------------------
    # circumscribe
    # ---------------------------------------------------------------------------------------------------------------
    @classmethod
    @class_anim_speed
    def golden(cls, line: Line.ELine, clockwise=False):
        pC = line.golden_ratio()
        pB = Point.EPoint(line.get_end())
        cA = Circle.ECircle(*line.get_start_and_end())
        lAC = Line.ELine(line.get_start(), pC).red()
        lBD = lAC.copy_as_chord(cA, pB, clockwise=clockwise)

        # which way to construct triangle? make sure angles are less than 90
        a = Angle.EAngle(line, lBD)
        if a.e_angle < mn.PI:
            t = cls(line.get_start(), lBD.get_start(), line.get_end())
        else:
            t = cls(line.get_start(), line.get_end(), lBD.get_start())

        with t.scene.simultaneous():
            a.e_remove()
            pC.e_remove()
            pB.e_remove()
            lAC.e_remove()
            lBD.e_remove()
            cA.e_remove()
        return t

    # ---------------------------------------------------------------------------------------------------------------
    # copy to circle
    # ---------------------------------------------------------------------------------------------------------------
    @log
    @copy_transform()
    def copy_to_circle(self, circle: Circle.ECircle) -> ETriangle:
        '''In a given circle to inscribe a triangle equiangular with a given triangle (IV-II)'''

        if not self.is_clockwise:
            angles: GroupObject.EIndexedGroup[Angle.EAngleBase] = GroupObject.EIndexedGroup(
                Angle.EAngle(l2, l1, delay_anim=True)
                for (l1, l2) in pairwise([self.lines[-1]] + self.lines)
            )
            a1, a2 = angles[2], angles[1]

        else:
            angles: GroupObject.EIndexedGroup[Angle.EAngleBase] = GroupObject.EIndexedGroup(
                Angle.EAngle(l1, l2, delay_anim=True)
                for (l1, l2) in pairwise([self.lines[-1]] + self.lines)
            )
            a1, a2 = angles[1], angles[2]

        # Draw a line GH tangent to the circle at point A
        pA = circle.e_point_at_angle(mn.PI/2)
        with Line.ELine(circle.v, pA) as r1:
            lGA = r1.perpendicular(pA, negative=True)

        lAH = lGA.prepend_cpy(2 * circle.radius)

        # Copy the angle E to line GH, at point A (I.23)
        with with_objects(*a1.copy_to_line(pA, lAH)) as (la1, a1):
            la1.extend(2 * circle.radius)
            pts = circle.intersect_line(la1,infinite=True)

            # pick the point that is not pA
            for p in pts:
                if get_dist(pA, p) > .01:
                    pC = Point.EPoint(p)

        # Copy the angle L to line GH, at point A (I.23)
        with with_objects(*a2.copy_to_line(pA, lGA, negative=True)) as (la2, a2):
            la2.extend(2 * circle.radius)
            pts = circle.intersect_line(la2, infinite=True)

            # pick the point that is not pA
            for p in pts:
                if get_dist(pA, p) > .01:
                    pB = Point.EPoint(p)

        # create new triangle
        t = ETriangle(pA, pB, pC)

        with self.scene.simultaneous():
            pA.e_remove()
            pB.e_remove()
            pC.e_remove()
            lGA.e_remove()
            lAH.e_remove()
            for x in angles:
                x.e_remove()

        return t


    @anim_speed
    @staticmethod
    def build_equilateral(p1: [mn.Vect3 | Point.EPoint], p2: [mn.Vect3 | Point.EPoint]):
        """build an equilateral triangle where p1 and p2 are the points defining the base"""
        c1 = Circle.ECircle(p1, p2).e_fade()
        c2 = Circle.ECircle(p2, p1).e_fade()

        pts = c1.intersect(c2)
        l1 = Line.VirtualLine(p1, p2)
        l2 = Line.VirtualLine(p2, pts[0])

        th = Angle.calculateAngle(l2, l1)
        if th < mn.PI:
            C = pts[0]
        else:
            C = pts[1]

        p = Point.EPoint(C)
        t = ETriangle(p1, p2, C)
        with p.scene.simultaneous():
            c1.e_remove()
            c2.e_remove()
            l1.e_remove()
            l2.e_remove()
        t.replace_point(-1, p)
        return t