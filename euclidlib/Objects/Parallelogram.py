from __future__ import annotations

from euclidlib.Objects import Polygon
from euclidlib.Objects import CalculatePoints
from euclidlib.Objects import Point
from euclidlib.Objects.EucidMObject import *

class EParallelogram(Polygon.EPolygon):
    def __init__(self, *points: EMObject|Vect3, **kwargs):
        if points and isinstance(points[0], str):
            point_names = list(points[0])
            points = Point.EPoint.find_in_frame(point_names)
        assert len(points) in (3, 4)
        if len(points) == 3:
            super().__init__(*CalculatePoints.parallelogram(*points), **kwargs)
        else:
            super().__init__(*points, **kwargs)