from __future__ import annotations

from euclidlib.Objects import Polygon
from euclidlib.Objects import Parallelogram
from euclidlib.Objects import CalculatePoints
from euclidlib.Objects import Point
from euclidlib.Objects import Line
from euclidlib.Objects import Circle
from euclidlib.Objects.EucidMObject import *

class ESquare(Parallelogram.EParallelogram):
    def __init__(self, *points: EMObject | Vect3, **kwargs):
        self.scene = find_scene()
        if len(points) == 4:
            super().__init__(*points, **kwargs, point_calc=CalculatePoints.square)
            return

        if len(points) == 3:
            super().__init__(*CalculatePoints.square(*points), **kwargs)
            return

        with self.scene.pause_animations_for(True):
            l2 = Line.VirtualLine(*points)
            l11 = l2.perpendicular(points[0])
            c = Circle.ECircle(*points)
            p1 = Point.EPoint(c.intersect(l11)[0])

            point3 = p1.get_center()

            l2.e_delete()
            l11.e_delete()
            c.e_delete()
            p1.e_delete()

        super().__init__(*CalculatePoints.square(*points, point3), **kwargs)