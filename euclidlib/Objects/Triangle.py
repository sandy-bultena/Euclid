from __future__ import annotations

import math
from itertools import pairwise
from math import  cos, sin, atan

import numpy as np
import manimlib as mn
from euclidlib.Objects.em_object_base import EMObject
from euclidlib.Objects.em_object_decorators import *
from euclidlib.Utilities.coordinate_utilities import convert_to_coord, mn_scale

from . import Polygon
from . import em_group_object as GroupObject
from . import Parallelogram as Para
from . import Line
from . import Point
from . import Angle
from . import Circle


class ETriangle(Polygon.EPolygon):
    @staticmethod
    def length_of(val: float | Line.ELine):
        if isinstance(val, mn.TipableVMobject):
            return val.get_length()
        return val

    @staticmethod
    def angle_of(val: float | Angle.EAngleBase):
        if isinstance(val, Angle.EAngleBase):
            return val.e_angle
        return val

    @classmethod
    def SAS(cls,
            base: EMObject | mn.Vect3,
            side1: float | Line.ELine,
            angle: float | Angle.EAngleBase,
            side2: float | Line.ELine,
            **kwargs):
        p2, p3, _ = cls.calculate_SAS(convert_to_coord(base),
                                      cls.length_of(side1),
                                      cls.angle_of(angle),
                                      cls.length_of(side2))
        return cls(base, p2, p3, **kwargs)

    @classmethod
    def calculate_SAS(cls, point: mn.Vect3, r1: float, angle: float, r2: float):
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

    @classmethod
    def SSS(cls,
            base: EMObject | mn.Vect3,
            *sides: float | Line.ELine,
            labels: Polygon.LABEL_ARGS = (None, None, None),
            point_labels: Polygon.LABEL_ARGS = (None, None, None),
            **kwargs):
        assert (len(sides) == 3)
        coord = convert_to_coord(base)
        r = [cls.length_of(s) for s in sides]

        p1, p2, p3 = cls.calculate_SSS(coord, *r)
        if p2 is None:
            return p1
        center = mn.center_of_mass([p1, p2, p3])

        labels_full = [cls._filter_side_labels(x) for x in labels]
        point_labels_full = [
            cls._filter_point_labels_with_center(x, center)
            for x in point_labels]

        p = Point.EPoint(p2, label=point_labels_full[1])

        c1 = Circle.ECircle(p2, p2 + mn.RIGHT * r[0], temp_line_label=labels_full[0])
        c1.e_fade()

        l2 = Line.ELine(p2, p3, label=labels_full[1])
        nextp = Point.EPoint(p3, label=point_labels_full[2])

        c2 = Circle.ECircle(p3, p3 + r[2] * mn.RIGHT, temp_line_label=labels_full[2])
        c2.e_fade()

        new = cls(p1, p2, p3,
                  labels=[labels_full[0], None, labels_full[2]],
                  point_labels=[point_labels_full[0], None, None],
                  **kwargs)
        if p.e_label is not None:
            p.e_label.transfer_ownership(new.p[1])
        if nextp.e_label is not None:
            nextp.e_label.transfer_ownership(new.p[2])
        if l2.e_label is not None:
            l2.e_label.transfer_ownership(new.l[1])
        with new.scene.simultaneous():
            c1.e_remove()
            c2.e_remove()
            p.e_remove()
            nextp.e_remove()
            l2.e_remove()
        return new

    @classmethod
    def calculate_SSS(cls, coord: mn.Vect3, *r: float):
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

    @log
    @anim_speed
    def parallelogram(self, angle: Angle.EAngleBase):
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
            point2 = Point.EPoint(line2.intersect(side1))

        # Draw a line through triangle point 3, parallel to side 1
        with self.scene.trace(side1, "Draw a line through triangle point 3, parallel to side 1"):
            line3 = side1.parallel(self.p[2], speed=0)
            line3.green()
            point3 = Point.EPoint(line3.intersect(line2))

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

    @log
    @copy_transform()
    def copy_to_parallelogram_on_line(self, line: Line.ELine, angle: Angle.EAngleBase):
        # create parallelogram equal in size to triangle (I.42)
        s1, a2 = self.parallelogram(angle, speed=0)
        a2.e_remove()

        # copy this parallelogram to the line
        s4 = s1.copy_to_line(line, speed=0)
        s1.e_remove()
        return s4

    @log
    @anim_speed
    def circumscribe(self):
        # bisect two sides of the triangle
        pD = self.l0.bisect()
        pE = self.l2.bisect()

        # Find the centre of the circle
        l1 = self.l0.perpendicular(pD, inside=True)
        l2 = self.l2.perpendicular(pE, inside=True)
        p=  l1.intersect(l2)

        c = Circle.ECircle(p, self.p0)

        with self.scene.simultaneous():
            l1.e_remove()
            l2.e_remove()
            pD.e_remove()
            pE.e_remove()

        return c


    @classmethod
    @class_anim_speed
    def golden(cls, line: Line.ELine, negative=False):
        pC = line.golden_ration(speed=0)
        pB = Point.EPoint(line.get_end())
        cA = Circle.ECircle(*line.get_start_and_end())
        lAC = Line.ELine(line.get_start(), pC).red()
        lBD = lAC.copy_to_circle(cA, pB, negative=negative)

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

    @log
    @copy_transform()
    def copy_to_circle(self, circle: Circle.ECircle) -> ETriangle:
        if self.is_clockwise:
            angles: GroupObject.EGroup[Angle.EAngleBase] = GroupObject.EGroup(
                Angle.EAngle(l2, l1, delay_anim=True)
                for (l1, l2) in pairwise([self.lines[-1]] + self.lines)
            )
            a1, a2 = angles[2], angles[1]
        else:
            angles: GroupObject.EGroup[Angle.EAngleBase] = GroupObject.EGroup(
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
            pts = circle.intersect(la1)
            pC = Point.EPoint(pts[0])

        # Copy the angle L to line GH, at point A (I.23)
        with with_objects(*a2.copy_to_line(pA, lGA, negative=True)) as (la2, a2):
            la2.extend(2 * circle.radius)
            pts = circle.intersect(la2)
            pB = Point.EPoint(pts[1])

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

    def true_area(self) -> float:
        a = self.l0.get_length()
        b = self.l1.get_length()
        c = self.l2.get_length()
        s = .5 * (a + b + c)
        return math.sqrt(s * (s-a) * (s-b) * (s-c))