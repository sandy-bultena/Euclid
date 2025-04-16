from __future__ import annotations

import itertools

from euclidlib.Objects.EucidMObject import *
from euclidlib.Objects import Circle as Cir
from manimlib import TAU
from . import Line as Ln
from . import Text as T
from . import Point as P
from euclidlib.Objects import Dashable as Da

class AbstractArc(Da.Dashable, mn.Arc):
    size: float
    e_angle: float
    e_start_angle: float
    e_end_angle: float
    vx: float
    vy: float

    def __init__(
            self,
            start_angle: float = 0,
            angle: float = TAU / 4,
            radius: float = 1.0,
            *args,
            **kwargs
    ):
        self.vx = 0.0
        self.vy = 0.0
        self.e_start_angle = 0.0
        self.e_end_angle = angle
        self.e_angle = angle
        self.size = radius
        super().__init__(start_angle, angle, radius, *args, **kwargs)

    @property
    def v(self):
        return np.array([self.vx, self.vy, 0])

    @property
    def r(self):
        return self.size

    @property
    def radius(self):
        return self.size

    def pointwise_become_partial(self, start: AbstractArc, a: float, b: float) -> Self:
        if a <= 0:
            self.e_start_angle = start.e_start_angle
        else:
            self.e_start_angle = mn.interpolate(start.e_start_angle, start.e_end_angle, a)

        if b >= 1:
            self.e_end_angle = start.e_end_angle
        else:
            self.e_end_angle = mn.interpolate(start.e_start_angle, start.e_end_angle, b)
        return super().pointwise_become_partial(start, a, b)

    def interpolate(
            self,
            mobject1: AbstractArc,
            mobject2: AbstractArc,
            alpha: float,
            path_func: Callable[[np.ndarray, np.ndarray, float], np.ndarray] = mn.straight_path
    ) -> Self:
        self.vx, self.vy, _ = mn.interpolate(mobject1.get_arc_center(), mobject2.get_arc_center(), alpha)
        self.e_start_angle = mn.interpolate(mobject1.e_start_angle, mobject2.e_start_angle, alpha)
        self.e_end_angle = mn.interpolate(mobject1.e_end_angle, mobject2.e_end_angle, alpha)
        return super().interpolate(mobject1, mobject2, alpha, path_func)

    def get_arc_center(self) -> Vect3:
        return np.array([self.vx, self.vy, 0])

    def shift(self, vector: Vect3) -> Self:
        self.vx += vector[0]
        self.vy += vector[1]
        return super().shift(vector)

    def rotate(self, angle: float, *args, **kwargs) -> Self:
        self.e_start_angle += angle
        self.e_end_angle += angle
        return super().rotate(angle, *args, **kwargs)

    def proportion_angle(self, alpha: float):
        interp = mn.interpolate(self.e_start_angle, self.e_end_angle, alpha)
        return interp

    def get_bisect(self, alpha=0.5):
        return self.proportion_angle(alpha)

    @staticmethod
    def vector_of_angle(angle):
        return np.array([math.cos(angle), math.sin(angle), 0.0])

    def get_bisect_dir(self, alpha=0.5):
        bisect = self.get_bisect(alpha)
        return self.vector_of_angle(bisect)

    def highlight(self, color=RED, scale=2.0, **args):
        return (self.animate(rate_func=mn.there_and_back, **args)
                .set_stroke(color=color, width=scale * float(self.get_stroke_width())))

    @log
    def intersect(self, other: Mobject, reverse=True):
        if isinstance(other, mn.Rectangle):
            return self.intersect_selection(other)
        super().intersect(other)

    def intersect_selection(self, other: mn.Rectangle):
        return other.is_touching(self)

    def init_label(self, labels: str | List[str], *args, **extra_args):
        if isinstance(labels, str):
            return super().init_label(labels, *args, **extra_args)
        return T.LabelGroup(
            labels,
            self,
            itertools.repeat(args),
            itertools.repeat(extra_args)
        )

    def tangent_at_start(self):
        dir = -PI / 2 if self.e_angle > 0 else PI / 2
        return self.vector_of_angle(self.e_start_angle + dir)

    def tangent_at_end(self):
        dir = PI / 2 if self.e_angle > 0 else -PI / 2
        return self.vector_of_angle(self.e_end_angle + dir)

    def tangent_points(self, angle_or_point: float | Mobject | Vect3, negative=False):
        if isinstance(angle_or_point, (float, np.float32, np.float64)):
            t_point = self.point_at_angle(angle_or_point)
        else:
            t_point = convert_to_coord(angle_or_point)
        rotation = PI / 2 * (1 if (negative != self.e_angle > 0) else -1)
        vec = t_point - self.v
        return t_point, t_point + mn.rotate_vector(vec / 2, rotation)

    def e_label_point(self, index=0, alpha=0.5, buff=None):
        if index == 0:
            bisect_dir = self.get_bisect_dir(alpha)
            try:
                base = self.point_from_proportion(alpha)
            except AssertionError:
                base = self.get_arc_center() + bisect_dir * self.size
            return base + bisect_dir * (buff or self.LabelBuff)
        if index == 1:
            return self.get_start() + self.tangent_at_start() * (buff or self.LabelBuff)
        return self.get_end() + self.tangent_at_end() * (buff or self.LabelBuff)

    def point_at_angle(self, angle):
        alpha = (angle - self.e_start_angle) / self.e_angle
        return self.point_from_proportion(alpha)

    def e_point_at_angle(self, angle):
        return P.EPoint(self.point_at_angle(angle))


class EArc(AbstractArc):
    def __init__(self,
                 radius: float,
                 point1: EMObject | Vect3,
                 point2: EMObject | Vect3,
                 big=False,
                 **kwargs):

        point1 = convert_to_coord(point1)
        point2 = convert_to_coord(point2)

        d = Ln.VirtualLine(point1, point2)
        if radius < d.get_length() / 2:
            raise ValueError(f"radius of curvature too small for points\n\tneed at least {d.get_length() / 2}")

        c1 = Cir.VirtualCircle(point1, point1 + radius * RIGHT)
        c2 = Cir.VirtualCircle(point2, point2 + radius * RIGHT)
        ps = c1.intersect(c2)
        center = ps[0]
        v1 = point1 - center
        v2 = point2 - center
        diff = mn.angle_of_vector(v2) - mn.angle_of_vector(v1)
        diff %= TAU

        if (big and diff < PI) or (diff > PI and not big):
            center = ps[1]
            v1 = point1 - center
            v2 = point2 - center
            diff = mn.angle_of_vector(v2) - mn.angle_of_vector(v1)
            diff %= TAU

        super().__init__(
            mn.angle_of_vector(v1),
            diff,
            radius=radius,
            arc_center=center,
            **kwargs
        )

        d.e_remove()
        c1.e_remove()
        c2.e_remove()
