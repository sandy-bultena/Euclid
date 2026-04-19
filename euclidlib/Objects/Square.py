from __future__ import annotations
import manimlib as mn
from typing import cast, Optional
from euclidlib.Utilities.calculate_points import square
from euclidlib.Objects.em_object_base import EMObject
from euclidlib.Objects.em_object_decorators import *
from euclidlib.Utilities.find_scene import find_scene
if TYPE_CHECKING:
    from euclidlib.Scenes.PropScene import PropScene

from . import Parallelogram, LineLabelSide
from . import Point
from . import Line
from . import Circle

class ESquare(Parallelogram.EParallelogram):
    def __init__(self, *points: EMObject | mn.Vect3, clockwise=False, **kwargs):
        self.scene: PropScene  =  find_scene()

        if len(points) == 4:
            super().__init__(*points, **kwargs, point_calc=square)
            return

        if len(points) == 3:
            super().__init__(*square(*points), **kwargs)
            return

        with self.scene.pause_animations_for(True):
            side = LineLabelSide.INSIDE if clockwise else LineLabelSide.OUTSIDE

            # draw line perpendicular to line 2, at point2
            l2 = Line.VirtualLine(*points)
            l11 = l2.perpendicular(points[0], speed=0, side=side, length=l2.length + .2)

            # define 1st point at correct distance, and make line 1
            c = Circle.ECircle(*points)
            ps = c.intersect(l11)
            p1 = Point.EPoint(ps[0])
            point3 = p1.get_center()

            l2.e_delete()
            l11.e_delete()
            c.e_delete()
            p1.e_delete()

        super().__init__(*square(*points, point3), **kwargs)