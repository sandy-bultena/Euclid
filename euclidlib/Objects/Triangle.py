from __future__ import annotations

from math import atan2, cos, sin, atan
from typing import Sized, Tuple, Any, List
from euclidlib.Objects.Polygon import EPolygon
from euclidlib.Objects.EucidMObject import *
from . import EucidGroupMObject as G
from . import Line as L
from . import Point as P
from . import Angel as A


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
