from __future__ import annotations

from euclidlib.Utilities.coordinate_utilities import mn_scale, convert_to_coord, mn_coord
from euclidlib.Objects.em_object_base import *
from euclidlib.Objects.em_object_decorators import *

from . import Polygon, PolygonBase, Parallelogram
from . import Point
from . import Line

# ====================================================================================================================
# ERectangle
# ====================================================================================================================

class ERectangle(Parallelogram.EParallelogram):
    """if only 2 points are given, then assuming the rectangle is horizontal!!"""
    def __init__(self, *points: EMObject | mn.Vect3, **kwargs):
        if len(points) == 2:
            p1, p3 = map(convert_to_coord, points)
            p2 = np.array([p3[0],p1[1],0])
            super().__init__(p1,p2,p3, **kwargs)
        else:
            super().__init__(*points, **kwargs)

