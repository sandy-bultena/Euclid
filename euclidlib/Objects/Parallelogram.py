from __future__ import annotations

from euclidlib.Objects import Polygon
from euclidlib.Objects import CalculatePoints
from euclidlib.Objects import Point
from euclidlib.Objects import Line
from euclidlib.Objects.EucidMObject import *

class EParallelogram(Polygon.EPolygon):
    def __init__(self, *points: EMObject | Vect3, **kwargs):
        if points and isinstance(points[0], str):
            point_names = list(points[0])
            points = Point.EPoint.find_in_frame(point_names)
        assert len(points) in (3, 4)
        if len(points) == 3:
            super().__init__(*CalculatePoints.parallelogram(*points), **kwargs)
        else:
            super().__init__(*points, **kwargs)

    @log
    def _create_complement(self, line: Line.ELine):
        with self.scene.trace(line, "defines point 1 and 2 of 1st line of new parallelogram"):
            p1 = Point.EPoint(line.get_start(), label=('p_1', dict(away_from=line.get_end())))
            p2 = Point.EPoint(line.get_end(), label=('p_2', dict(away_from=line.get_start())))

        with self.scene.trace(self.l[1], "construct parallel to 2nd line of parallelogram at point 2"):
            l2p2 = self.l[1].parallel(p2)
            l2p2.e_fade()

        with self.scene.trace(l2p2, "Find intersect of 1st line of parallelogram to parallel line l2p2"):
            p22 = Point.EPoint(l2p2.intersect(self.l[0]), label=('p_{22}', UP))

        with self.scene.trace(p22, "Draw diagonal, find intersection with 4th line of parallelogram"):
            diag = Line.ELine(p22, p1)
            diag.e_fade()
            p44 = Point.EPoint(diag.intersect(self.l[3]), label=('p_{44}', UP))

        with self.scene.trace(self.l[2], "Draw a line at point p44, parallel to 3rd line of parallelogram"):
            l3p44 = self.l[2].parallel(p44)
            l3p44.blue()

        with self.scene.trace(l2p2, "Find intersect of l2p2 and l3p44"):
            p3 = Point.EPoint(l2p2.intersect(l3p44), label=('p_3', UP))

        with self.scene.trace(l3p44, "Fine intersect of 2nd line of parallelogram to parallel line KL"):
            p4 = Point.EPoint(self.l[1].intersect(l3p44), label=('p_4', UP))

        with self.scene.trace("construct a parallelogram"):
            poly = EParallelogram(p1, p2, p3, p4)

        # cleanup
        with self.scene.simultaneous():
            diag.e_remove()
            p1.e_remove()
            p2.e_remove()
            p3.e_remove()
            p4.e_remove()
            p22.e_remove()
            p44.e_remove()
            l2p2.e_remove()
            l3p44.e_remove()

        return poly

    @log
    def _move_to_edge(self, point1: Point.EPoint, point2: Point.EPoint):
        l1 = Line.ELine(point1, point2)
        l1.e_fade()

        # copy angle2 to create line2
        flag = 0
        if not self.a[1]:
            self.set_angles(None, " ", None)
            flag += 1

        l2, a2 = self.a[1].copy_to_line(point2, l1, negative=True)
        if flag:
            self.a[1].e_remove()
        l2.e_fade()

        # copy line 2
        l2.extend(self.l[1].get_length())
        l2.e_fade()
        nl2, np3 = self.l[1].copy_to_line(point2, l2)
        l2.e_remove()

        coords = [point1.get_center(), point2.get_center(), np3.get_center()]
        parall = EParallelogram(*coords)

        with self.scene.simultaneous():
            for o in (l1, a2, nl2, np3):
                o.e_remove()

        return parall

    @log
    def copy_to_line(self, line: Line.ELine, /, speed=1):
        with self.scene.animation_speed(speed):

            with self.scene.trace(self.l[2], "extend 3rd line"):
                t1 = self.l[2].copy().prepend(line.get_length() + mn_scale(50))
                t2, _ = t1.e_split(self.p[2])
                _.e_remove()
                with self.scene.simultaneous():
                    t1.e_fade()

            with self.scene.trace(line, "copy line to our extension"):
                l4, p4 = line.copy_to_line(self.p[2], t2)
                l4.red()
                t2.e_remove()
                p4.e_remove()


            with self.scene.trace(self, "create the complement with the given line at point 3", font_size=18):
                x = self._create_complement(l4)

            p6 = Point.EPoint(line.get_start())
            p7 = Point.EPoint(line.get_end())
            y = x._move_to_edge(p6, p7)

            with self.scene.simultaneous():
                x.e_remove()
                l4.e_remove()
                p6.e_remove()
                p7.e_remove()

            return y