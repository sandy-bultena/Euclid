from __future__ import annotations
from euclidlib.Objects.EucidMObject import *
from .Line import EuclidLine
from manimlib import TAU
from . import Text as T
from . import Point as P
from . import Circle as C
import math
from typing import Tuple, Any, Self, Callable

EPSILON = mn_scale(1)
if TYPE_CHECKING:
    from manimlib import Vect3
    ANGLE_DATA = tuple[
        Vect3 | None,
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
        return None, None, None

    vx, vy, _ = common
    vx1, vy1, _ = end1
    vx2, vy2, _ = end2

    return common, (vx1 - vx, vy1 - vy), (vx2 - vx, vy2 - vy)


def angleOf(p0: mn.Vect3, p1: mn.Vect3):
    return math.atan2(
        p1[1] - p0[1],
        p1[0] - p0[0],
    )


def calculateAngle(l1: EuclidLine, l2: EuclidLine):
    (vx, vy, _), vec1, vec2 = angle_coords(l1, l2)

    if vx is None:
        return None

    th1 = math.atan2(vec1[1], vec1[0])
    th2 = math.atan2(vec2[1], vec2[0])

    th_diff = th2 - th1

    return th_diff % TAU


class EuclidAngleBase(EMObject):
    LabelBuff = 0.15
    l1: EuclidLine
    l2: EuclidLine
    size: float
    e_angle: float
    e_start_angle: float
    e_end_angle: float
    vx: float
    vy: float
    vec1: mn.Vect2
    vec2: mn.Vect2

    def pointwise_become_partial(self, start: ArcAngle, a: float, b: float) -> Self:
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
            mobject1: ArcAngle,
            mobject2: ArcAngle,
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

    def get_bisect_dir(self, alpha=0.5):
        bisect = self.get_bisect(alpha)
        return np.array([math.cos(bisect), math.sin(bisect), 0.0])

    def e_label_point(self, alpha=0.5, buff=None):
        bisect_dir = self.get_bisect_dir(alpha)
        try:
            base = self.point_from_proportion(alpha)
        except AssertionError:
            base = self.get_arc_center() + bisect_dir * self.size
        return base + bisect_dir * (buff or self.LabelBuff)

    def bisect(self, speed):
        vx, vy, _ = self.get_arc_center()
        v1 = np.array([math.cos(self.e_start_angle), math.sin(self.e_start_angle), 0.0])
        v2 = np.array([math.cos(self.e_end_angle), math.sin(self.e_end_angle), 0.0])

        with self.scene.animation_speed(speed):
            # ------------------------------------------------------------------------
            # make two temporary lines
            # ------------------------------------------------------------------------
            with self.scene.simultaneous():
                s1 = EuclidLine(self.get_arc_center(), self.get_arc_center() + v1).e_fade()
                s2 = EuclidLine(self.get_arc_center(), self.get_arc_center() + v2).e_fade()

            # ------------------------------------------------------------------------
            # define points B and C on the two lines, equidistance from the vertex
            # ------------------------------------------------------------------------
            # pick the shorter of the two lines to find the initial point
            short = self.l1 if self.l1.get_length() <= self.l2.get_length() else self.l2
            p = s1.point(0.75 * short.get_length())
            pB = P.EuclidPoint(p)
            cA = C.EuclidCircle(self.get_arc_center(), pB).e_fade()
            p = cA.intersect(self.l2)
            pC = P.EuclidPoint(p[0])

            # ------------------------------------------------------------------------
            # draw two circles, radius BC, centers: B & C.
            # - find the intersection points between two circles
            # ------------------------------------------------------------------------
            c1 = C.EuclidCircle(pB, pC).e_fade()
            c2 = C.EuclidCircle(pC, pB).e_fade()
            ps = c1.intersect(c2)
            if mn.norm_squared(ps[1] - self.get_arc_center()) < mn.norm_squared(ps[0] - self.get_arc_center()):
                p1 = P.EuclidPoint(ps[0])
            else:
                p1 = P.EuclidPoint(ps[1])

            # ------------------------------------------------------------------------
            # draw a line to intersection
            # ------------------------------------------------------------------------
            lAD = EuclidLine(self.get_arc_center(), p1)

            # ------------------------------------------------------------------------
            # cleanup
            # ------------------------------------------------------------------------
            with self.scene.simultaneous():
                c1.e_fade()
                c2.e_fade()
                cA.e_fade()
                s1.e_remove()
                s2.e_remove()
                pB.e_remove()
                pC.e_remove()

            # ------------------------------------------------------------------------
            # return new line, point, all circles
            # ------------------------------------------------------------------------
            return lAD, p1, c1, c2, cA


class ArcAngle(EuclidAngleBase, mn.Arc):
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
        self.e_start_angle = 0.0
        self.vx, self.vy = 0, 0
        self.e_end_angle = angle
        center, self.vec1, self.vec2 = angle_data

        if kwargs.get('debug', None):
            scene = find_scene()
            self.tmp_start = mn.Line(stroke_color=RED)
            self.tmp_end = mn.Line(stroke_color=BLUE)
            self.tmp_mid = mn.Line(stroke_color=GREEN)
            self.tmp_txt = mn.Line(stroke_color=YELLOW)
            self.tmp_start.f_always.set_points_by_ends(
                lambda: center,
                lambda: center + size * np.array([math.cos(self.e_start_angle), math.sin(self.e_start_angle), 0]))
            self.tmp_end.f_always.set_points_by_ends(
                lambda: center,
                lambda: center + size * np.array([math.cos(self.e_end_angle), math.sin(self.e_end_angle), 0]))
            self.tmp_mid.f_always.set_points_by_ends(
                lambda: center,
                lambda: center + size * self.get_bisect_dir(self.label_dir))
            self.tmp_txt.f_always.set_points_by_ends(
                lambda: center + size * self.get_bisect_dir(self.label_dir),
                lambda: center + size * self.get_bisect_dir(self.label_dir) + self.LabelBuff * (
                    0 if hasattr(self, 'e_label') and self.e_label is None else self.get_label_dir()))
            scene.add(self.tmp_start, self.tmp_end, self.tmp_mid, self.tmp_txt)

        super().__init__(
            angle1,
            angle,
            radius=size,
            arc_center=center,
            **kwargs
        )




class RightAngle(EuclidAngleBase, mn.VMobject):
    LabelBuff = 0.15
    def __init__(self,
                 l1: EuclidLine,
                 l2: EuclidLine,
                 size: float,
                 angle_data: ANGLE_DATA,
                 angle1: float,
                 angle2: float,
                 angle: float,
                 delay_anim=False,
                 **kwargs):
        self.l1 = l1
        self.l2 = l2
        self.size = size / math.sqrt(2)

        self.e_start_angle = 0.0
        self.e_end_angle = angle
        self.vx, self.vy = 0, 0

        super().__init__(**kwargs, delay_anim=True)

        part_size = 1 / math.sqrt(2)
        if angle > 0:
            self.set_points_as_corners([
                RIGHT * part_size,
                UR * part_size,
                UP * part_size,
            ])
        else:
            self.set_points_as_corners([
                RIGHT * part_size,
                DR * part_size,
                DOWN * part_size,
            ])

        center, self.vec1, self.vec2 = angle_data
        self.rotate(angle1, about_point=ORIGIN)
        self.scale(size, about_point=ORIGIN)
        self.shift(center)
        if not delay_anim:
            self.e_draw()



def EuclidAngle(l1: EuclidLine | str,
                l2: EuclidLine = None,
                size: float = mn_scale(40),
                no_right: bool = False,
                **kwargs):
    if isinstance(l1, str):
        l1, l2 = EuclidLine.find_in_frame(l1)

    assert (l2 is not None)

    data = angle_coords(l1, l2)
    c, v1, v2 = data

    if c is None:
        raise Exception(f"No Common Midpoint: {l1.get_start(), l1.get_end()} | {l2.get_start(), l2.get_end()}")

    th1 = math.atan2(v1[1], v1[0])
    th2 = math.atan2(v2[1], v2[0])
    th_diff = th2 - th1

    if th_diff > PI:
        th_diff = th_diff - TAU
    elif th_diff < -PI:
        th_diff = TAU + th_diff

    if abs(abs(th_diff) - PI/2) < (0.1*DEGREES) and not no_right:
        return RightAngle(l1, l2, size, data, th1, th2, th_diff, **kwargs)
    else:
        return ArcAngle(l1, l2, size, data, th1, th2, th_diff, **kwargs)


