from __future__ import annotations

from math import atan2, cos, sin, atan
from typing import Sized, Tuple, Any, List

import numpy as np

from euclidlib.Objects.Polygon import EPolygon, LABEL_ARGS
from euclidlib.Objects.EucidMObject import *
from . import EucidGroupMObject as G
from . import Parallelogram as Para
from . import Line as L
from . import Point as P
from . import Angel as A
from . import Circle as C


class ETriangle(EPolygon):
    @staticmethod
    def length_of(val: float | L.ELine):
        if isinstance(val, mn.TipableVMobject):
            return val.get_length()
        return val

    @staticmethod
    def angle_of(val: float | A.EAngleBase):
        if isinstance(val, A.EAngleBase):
            return val.e_angle
        return val

    @classmethod
    def SAS(cls,
            base: EMObject | Vect3,
            side1: float | L.ELine,
            angle: float | A.EAngleBase,
            side2: float | L.ELine,
            **kwargs):
        p2, p3, _ = cls.calculate_SAS(convert_to_coord(base),
                                      cls.length_of(side1),
                                      cls.angle_of(angle),
                                      cls.length_of(side2))
        return cls(base, p2, p3, **kwargs)

    @classmethod
    def calculate_SAS(cls, point: Vect3, r1: float, angle: float, r2: float):
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
            base: EMObject | Vect3,
            *sides: float | L.ELine,
            labels: LABEL_ARGS = (None, None, None),
            point_labels: LABEL_ARGS = (None, None, None),
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

        p = P.EPoint(p2, label=point_labels_full[1])

        c1 = C.ECircle(p2, p2 + RIGHT * r[0], temp_line_label=labels_full[0])
        c1.e_fade()

        l2 = L.ELine(p2, p3, label=labels_full[1])
        nextp = P.EPoint(p3, label=point_labels_full[2])

        c2 = C.ECircle(p3, p3 + r[2] * RIGHT, temp_line_label=labels_full[2])
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
    def calculate_SSS(cls, coord: Vect3, *r: float):
        next = coord + RIGHT * r[1]
        c1 = C.VirtualCircle(coord, coord + RIGHT * r[0])
        c2 = C.VirtualCircle(next, next + RIGHT * r[2])
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
    def parallelogram(self, angle: A.EAngleBase, /, speed=-1):
        with self.scene.animation_speed(speed) as draw:
            point = self.l[1].bisect()
            point.add_label('P_1', UP)
            l = L.ELine(self.p[1], self.p[2])
            l.e_fade()
            l1, l2 = l.e_split(point)
            with self.scene.simultaneous():
                l1.red()
                l2.blue()

            # Copy angle onto 2nd triangle line EC at bisect point
            side1, angle2 = angle.copy_to_line(point, l2)
            side1.extend(mn_scale(100))
            side1.red()

            # Draw a line through triangle point 1, parallel triangle line 2
            with self.scene.trace(self.l[1], "Draw a line through triangle point 1, parallel triangle line 2"):
                line2 = self.l[1].parallel(self.p[0])
                line2.blue()
                point2 = P.EPoint(line2.intersect(side1), label=("P_2", UP))

            # Draw a line through triangle point 3, parallel to side 1
            with self.scene.trace(side1, "Draw a line through triangle point 3, parallel to side 1"):
                line3 = side1.parallel(self.p[2])
                line3.green()
                point3 = P.EPoint(line3.intersect(line2), label=("P_3", UP))

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

            draw += [poly, angle2]

            return poly, angle2

    @log
    def copy_to_parallelogram_on_line(self, line: L.ELine, angle: A.EAngleBase, /, speed=-1):
        with self.scene.animation_speed(speed) as draw:
            # create parallelogram equal in size to triangle (I.42)
            s1, a2 = self.parallelogram(angle)
            # s1.e_fade()
            a2.e_remove()

            # copy this parallelogram to the line
            s4 = s1.copy_to_line(line)
            s1.e_remove()
            draw.append(s4)
            return s4

