from __future__ import annotations
from euclidlib.Objects.EucidMObject import *
from .Line import EuclidLine
from manimlib import TAU
from . import Text as T
import math
from typing import Tuple, Any

EPSILON = to_manim_v_scale(1)
ANGLE_DATA = tuple[
    float | None,
    float | None,
    tuple[float, float] | None,
    tuple[float, float] | None,
]


def angle_coords(l1: EuclidLine, l2: EuclidLine) -> ANGLE_DATA:
    (l1x0, l1y0, _), (l1x1, l1y1, _) = l1.get_start(), l1.get_end()
    (l2x0, l2y0, _), (l2x1, l2y1, _) = l2.get_start(), l2.get_end()

    # l10 and l20
    if abs(l1x0 - l2x0) < EPSILON and abs(l1y0 - l2y0) < EPSILON:
        common = l1.get_start()
        end1 = l1.get_end()
        end2 = l2.get_end()

    # l11 and l20
    elif abs(l1x1 - l2x0) < EPSILON and abs(l1y1 - l2y0) < EPSILON:
        common = l1.get_end()
        end1 = l1.get_start()
        end2 = l2.get_end()

    # l11 and l21
    elif abs(l1x1 - l2x1) < EPSILON and abs(l1y1 - l2y1) < EPSILON:
        common = l1.get_end()
        end1 = l1.get_start()
        end2 = l2.get_start()

    # l10 and l21
    elif abs(l1x0 - l2x1) < EPSILON and abs(l1y0 - l2y1) < EPSILON:
        common = l1.get_start()
        end1 = l1.get_end()
        end2 = l2.get_start()

    else:
        return None, None, None, None

    vx, vy, _ = common
    vx1, vy1, _ = end1
    vx2, vy2, _ = end2

    return vx, vy, (vx1 - vx, vy1 - vy), (vx2 - vx, vy2 - vy)


def angleOf(p0: mn.Vect3, p1: mn.Vect3):
    return math.atan2(
        p1[1] - p0[1],
        p1[0] - p0[0],
    )


def calculateAngle(l1: EuclidLine, l2: EuclidLine):
    # assert l1.get_start() == l2.get_start()

    vx, vy, vec1, vec2 = angle_coords(l1, l2)

    if vx is None:
        return None

    th1 = math.atan2(vec1[1], vec1[0])
    th2 = math.atan2(vec2[1], vec2[0])

    th_diff = th2 - th1

    return th_diff % TAU


class ArcAngle(EMObject, mn.Arc):
    LabelBuff = SMALL_BUFF
    def __init__(self,
                 l1: EuclidLine,
                 l2: EuclidLine,
                 size: float,
                 angle_data: ANGLE_DATA,
                 angle1: float,
                 angle2: float,
                 angle: float,
                 **kwargs):
        self.l1 = l1
        self.l2 = l2
        self.size = size
        self.e_angle = angle
        self.vx, self.vy, self.vec1, self.vec2 = angle_data

        super().__init__(
            angle1,
            angle,
            radius=size,
            arc_center=(self.vx, self.vy, 0),
            **kwargs
        )

    def get_bisect(self):
        return self.get_start_angle() + self.e_angle/2

    def get_bisect_dir(self):
        bisect = self.get_bisect()
        return math.cos(bisect), math.sin(bisect)

    def get_label_dir(self):
        return np.array([*self.get_bisect_dir(), 0.0])

    def e_label_point(self, direction):
        x, y, _ = self.get_arc_center()
        bisect_dir = self.get_bisect_dir()
        return (
            bisect_dir[0] * self.size + x,
            bisect_dir[1] * self.size + y,
            0
        )

    def init_label(self, label: str, label_dir) -> T.Label | None:
        if label:
            return T.Label(label, ref=self, direction=self.get_label_dir)


class RightAngle(EMObject, mn.VMobject):
    def CreationOf(self, *args, **kwargs):
        self.add_points_as_corners((
            (self.vx + self.size * math.cos(self.angle1), self.vy + self.size * math.sin(self.angle1)),
            (self.vx + self.size * math.cos(self.angle1) + self.size * math.cos(self.angle2),
             self.vy + self.size * math.sin(self.angle1) + self.size * math.sin(self.angle2)),
            (self.vx + self.size * math.cos(self.angle2), self.vy + self.size * math.sin(self.angle2)),
        ))
        return super().CreationOf(*args, **kwargs)

    def __init__(self,
                 l1: EuclidLine,
                 l2: EuclidLine,
                 size: float,
                 angle_data: ANGLE_DATA,
                 angle1: float,
                 angle2: float,
                 angle: float,
                 **kwargs):
        self.l1 = l1
        self.l2 = l2
        self.size = size/2
        self.angle1 = angle1
        self.angle2 = angle2
        self.vx, self.vy, self.vec1, self.vec2 = angle_data
        super().__init__(**kwargs)

    def get_label_dir(self):
        avg_th = (self.angle1 + self.angle2) / 2
        return math.cos(avg_th), math.sin(avg_th)

    def init_label(self, label: str, label_dir) -> T.Label | None:
        if label:
            return T.Label(label, ref=self, direction=self.get_label_dir())



class EuclidAngle(EMObject):
    def __new__(cls,
                l1: EuclidLine,
                l2: EuclidLine,
                size: float = to_manim_v_scale(40),
                no_right: bool = False,
                **kwargs):

        px, py, v1, v2 = angle_coords(l1, l2)

        if px is None:
            raise Exception(f"No Common Midpoint: {l1.get_start(), l1.get_end()} | {l2.get_start(), l2.get_end()}")

        th1 = math.atan2(v1[1], v1[0])
        th2 = math.atan2(v2[1], v2[0])
        th_diff = th2 - th1

        if abs(th_diff) > PI:
            th_diff = th_diff - TAU

        if abs(abs(th_diff) - PI) < 0.1 and not no_right:
            angle_obj = super().__new__(RightAngle)
        else:
            angle_obj = super().__new__(ArcAngle)
        angle_obj.__init__(l1, l2, size, (px, py, v1, v2), th1, th2, th_diff, **kwargs)
        return angle_obj
