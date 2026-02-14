from __future__ import annotations

import itertools

from euclidlib.Objects.em_object_base import *
from euclidlib.Objects.em_object_decorators import *
from euclidlib.Utilities.coordinate_utilities import mn_scale, convert_to_coord, mn_coord, get_dist


from . import Line
from . import Point
from . import Circle
from . import Arc
import math

# ===============================================================================================================
if TYPE_CHECKING:
    from manimlib import Vect3

    ANGLE_DATA = tuple[
        Vect3 | None,
        tuple[float, float] | None,
        tuple[float, float] | None,
    ]


# ===============================================================================================================
# Get the pts where the angle (arc) starts and stops
# ===============================================================================================================
def angle_coords(l1: Line.ELine, l2: Line.ELine) -> ANGLE_DATA:
    (l1x0, l1y0, _), (l1x1, l1y1, _) = l1.get_start(), l1.get_end()
    (l2x0, l2y0, _), (l2x1, l2y1, _) = l2.get_start(), l2.get_end()

    # Have to find the common point between the two lines

    # l1[0] == l2[0]
    if abs(l1x0 - l2x0) < EPSILON and abs(l1y0 - l2y0) < EPSILON:
        common = l1.get_start()
        end1 = l1.get_end()
        end2 = l2.get_end()

    # l1[1] == l2[0]
    elif abs(l1x1 - l2x0) < EPSILON and abs(l1y1 - l2y0) < EPSILON:
        common = l1.get_end()
        end1 = l1.get_start()
        end2 = l2.get_end()

    # l1[1] == l2[1]
    elif abs(l1x1 - l2x1) < EPSILON and abs(l1y1 - l2y1) < EPSILON:
        common = l1.get_end()
        end1 = l1.get_start()
        end2 = l2.get_start()

    # l1[0] == l2[1]
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


# ===============================================================================================================
# get angle between two points
# ===============================================================================================================
def angleOf(p0: mn.Vect3, p1: mn.Vect3):
    return math.atan2(
        p1[1] - p0[1],
        p1[0] - p0[0],
    )


# ===============================================================================================================
# calculate the angle between two lines
# ===============================================================================================================
def calculateAngle(l1: Line.ELine, l2: Line.ELine)->Optional[float]:
    (vx, vy, _), vec1, vec2 = angle_coords(l1, l2)

    if vx is None:
        return None

    th1 = math.atan2(vec1[1], vec1[0])
    th2 = math.atan2(vec2[1], vec2[0])

    th_diff = th2 - th1

    return th_diff % mn.TAU


# ===============================================================================================================
# class EAngle Base
# ===============================================================================================================
class EAngleBase(Arc.AbstractArc):
    LabelBuff = 0.15
    l1: Line.ELine
    l2: Line.ELine
    size: float
    e_angle: float
    e_start_angle: float
    e_end_angle: float
    vx: float
    vy: float
    vec1: mn.Vect2
    vec2: mn.Vect2

    # -----------------------------------------------------------------------------------------------------------------
    # properties
    # -----------------------------------------------------------------------------------------------------------------
    @property
    def lines(self):
        return self.l1, self.l2

    # -----------------------------------------------------------------------------------------------------------------
    # copy to line (index = 1 means transform into final angle, but still display the created line)
    # Proposition I.23
    # -----------------------------------------------------------------------------------------------------------------
    @log
    @copy_transform(index=1)
    def copy_to_line(self, point: Point.EPoint, line: Line.ELine, negative=False) -> tuple[Line.ELine, EAngleBase]:
        """copy this angle to another line, point must be at either end of the line"""
        start, end = line.get_start_and_end()
        if not any(get_dist(x, point.get_center()) < mn_scale(0.01) for x in (start, end)):
            mn.log.error("When copying an angle to a line, "
                         "the point must be one of the endpoints\n"
                         f"{point.get_center()=} | {start=} | {end=}")
            raise ValueError()

        # if point is at end of line, swap 'end', 'start' of line
        if np.array_equal(end, point.get_center()):
            end, start = start, end

        # clone the line to draw on
        clone = Line.ELine(start, end, stroke_color=mn.BLUE)
        if clone.get_length() < mn_scale(500):
            clone.extend_and_prepend(mn_scale(250))

        min_length = min(self.l1.get_length(),
                         self.l2.get_length(),
                         line.get_length()) - mn_scale(10)

        # ------------------------------------------------------------------------
        # define point D and E on angle
        # "Construct triangle DCE by constructing the line DE"
        # ------------------------------------------------------------------------
        c1 = Circle.ECircle(self.v, self.v + mn.RIGHT * min_length)
        p1 = c1.intersect(self.l1)
        p2 = c1.intersect(self.l2)
        pn1 = Point.EPoint(p1[0], label=('E', dict(away_from=p2[0])))
        pn2 = Point.EPoint(p2[0], label=('D', dict(away_from=p1[0])))
        c1.e_remove()

        # ------------------------------------------------------------------------
        # Copy this triangle onto line segment AB, using the methods described in I.22
        # copy CE to AF
        # ------------------------------------------------------------------------
        l1 = Line.ELine(self.v, p1[0], stroke_color=mn.GREEN)
        ln1, o = l1.copy_to_point(point)
        ln1.green()
        c2 = Circle.ECircle(point, ln1.get_end(), stroke_color=mn.GREEN)
        with self.scene.staggered_animation():
            for x in (ln1, o):
                x.e_remove()
        p3 = c2.intersect(line)
        if not p3:
            for i in range(5):
                clone.extend(100)
                p3 = c2.intersect(clone)

        pn3 = Point.EPoint(p3[0], fill_color=mn.GREEN)
        l1.white()
        c2.white.e_fade()

        # ------------------------------------------------------------------------
        # Copy length CD, start at point A (I.2), and then construct a circle with radius CD
        # ------------------------------------------------------------------------
        l3 = Line.ELine(p1[0], p2[0], stroke_color=mn.GREEN)
        ln3, o2 = l3.copy_to_point(pn3)
        c3 = Circle.ECircle(pn3, ln3.get_end())
        c2.e_normal()

        # ------------------------------------------------------------------------
        # Copy length DE, start at point F (I.2), and then construct a circle with radius DE
        # ------------------------------------------------------------------------
        p4 = c3.intersect(c2)
        lt1 = Line.ELine(point, p4[0], delay_anim=True)
        lt2 = Line.ELine(point, p4[1], delay_anim=True)

        # ------------------------------------------------------------------------
        # Construct triangle AFG, where G is the intersection of the two circles
        lt3 = Line.ELine(point, point.get_center() - lt1.get_unit_vector(), delay_anim=True)
        lt4 = Line.ELine(point, point.get_center() - lt2.get_unit_vector(), delay_anim=True)

        with self.scene.staggered_animation():
            for x in (l1, pn3, pn1, pn2, l3, ln3, o2):
                x.e_remove()

        # ------------------------------------------------------------------------
        # calculate the two possible angles, and return the smallest angle
        # ------------------------------------------------------------------------
        lines = [lt1, lt2, lt3, lt4]
        if negative:
            angles = [EAngle(l, line, delay_anim=True) for l in lines]
        else:
            angles = [EAngle(line, l, delay_anim=True) for l in lines]

        def smallest_diff(line_angle):
            i, _, angle = line_angle
            return abs(angle.e_angle - self.e_angle)

        final_index, final_line, final_angle = min(zip(range(4), lines, angles), key=smallest_diff)

        if final_index < 2:
            final_line.e_draw()
            final_angle.e_draw()
        else:
            lines[final_index-2].e_draw()
            final_line.e_draw()
            final_angle.e_draw()

        # ------------------------------------------------------------------------
        # remove all unnecessary objects
        # ------------------------------------------------------------------------
        with self.scene.staggered_animation():
            for x in (*lines, *angles, c2, c3, clone):
                if x is final_line:
                    continue
                if x is final_angle:
                    continue
                x.e_remove()

        # ------------------------------------------------------------------------
        # return final line, final angle
        # ------------------------------------------------------------------------
        return final_line, final_angle

    # -----------------------------------------------------------------------------------------------------------------
    # bisect angle (I.9)
    # -----------------------------------------------------------------------------------------------------------------
    @anim_speed
    def bisect(self)-> tuple[Line.ELine, Point.EPoint, Circle.ECircle, Circle.ECircle, Circle.ECircle]:
        """ bisects the angle, and draws and returns all objects used in its construction """
        vx, vy, _ = self.get_arc_center()
        v1 = np.array([math.cos(self.e_start_angle), math.sin(self.e_start_angle), 0.0])
        v2 = np.array([math.cos(self.e_end_angle), math.sin(self.e_end_angle), 0.0])

        # ------------------------------------------------------------------------
        # make two temporary lines
        # ------------------------------------------------------------------------
        with self.scene.simultaneous():
            s1 = Line.ELine(self.get_arc_center(), self.get_arc_center() + v1).e_fade()
            s2 = Line.ELine(self.get_arc_center(), self.get_arc_center() + v2).e_fade()

        # ------------------------------------------------------------------------
        # define points B and C on the two lines, equidistance from the vertex
        # ------------------------------------------------------------------------
        # pick the shorter of the two lines to find the initial point
        short = self.l1 if self.l1.get_length() <= self.l2.get_length() else self.l2
        p = s1.point(0.75 * short.get_length())
        pB = Point.EPoint(p)
        cA = Circle.ECircle(self.get_arc_center(), pB).e_fade()
        p = cA.intersect(self.l2)
        pC = Point.EPoint(p[0])

        # ------------------------------------------------------------------------
        # draw two circles, radius BC, centers: B & Circle.
        # - find the intersection points between two circles
        # ------------------------------------------------------------------------
        c1 = Circle.ECircle(pB, pC).e_fade()
        c2 = Circle.ECircle(pC, pB).e_fade()
        ps = c1.intersect(c2)
        if mn.norm_squared(ps[1] - self.get_arc_center()) < mn.norm_squared(ps[0] - self.get_arc_center()):
            p1 = Point.EPoint(ps[0])
        else:
            p1 = Point.EPoint(ps[1])

        # ------------------------------------------------------------------------
        # draw a line to intersection
        # ------------------------------------------------------------------------
        lAD = Line.ELine(self.get_arc_center(), p1)

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

    # -----------------------------------------------------------------------------------------------------------------
    # clean_bisect - same as bisect, but removes all objects except the bisect line
    # -----------------------------------------------------------------------------------------------------------------
    @log
    @anim_speed
    def clean_bisect(self):
        line, *rest = self.bisect(speed=0)
        with self.scene.simultaneous():
            for x in rest:
                x.e_remove()
        return line


# ==============================================================================================================
# Arc Angle class
# - base class for Angle and Gnomon
# ==============================================================================================================
class ArcAngle(EAngleBase, mn.Arc):
    def __init__(self,
                 l1: Line.ELine,
                 l2: Line.ELine,
                 size: float,
                 angle_data: ANGLE_DATA,
                 angle1: float,
                 angle: float,
                 **kwargs):
        self.l1 = l1
        self.l2 = l2
        center, self.vec1, self.vec2 = angle_data

        super().__init__(
            angle1,
            angle,
            radius=size,
            arc_center=center,
            **kwargs
        )
    def get_group(self):
        return self.l1, self.l2

# ==============================================================================================================
# Right Angle class
# - draws 'half a square' as the angle indicator instead of an arc
# ==============================================================================================================
class RightAngle(EAngleBase):
    LabelBuff = 0.15

    def __init__(self,
                 l1: Line.ELine,
                 l2: Line.ELine,
                 size: float,
                 angle_data: ANGLE_DATA,
                 angle1: float,
                 angle: float,
                 delay_anim=False,
                 **kwargs):
        self.l1 = l1
        self.l2 = l2
        self.size = size / math.sqrt(2)

        super().__init__(**kwargs, delay_anim=True)

        part_size = 1 / math.sqrt(2)
        if angle > 0:
            self.set_points_as_corners([
                mn.RIGHT * part_size,
                mn.UR * part_size,
                mn.UP * part_size,
            ])
        else:
            self.set_points_as_corners([
                mn.RIGHT * part_size,
                mn.DR * part_size,
                mn.DOWN * part_size,
            ])

        center, self.vec1, self.vec2 = angle_data
        self.rotate(angle1, about_point=mn.ORIGIN)
        self.scale(size, about_point=mn.ORIGIN)
        self.shift(center)
        if not delay_anim:
            self.e_draw()


# ==============================================================================================================
# Gnomon
# - not sure why we have an empty class, but I guess I'll figure out why later
# ==============================================================================================================
class Gnomon(ArcAngle):
    """the part of a parallelogram left when a similar parallelogram has been taken from its corner."""
    pass


# ==============================================================================================================
# EAngle - whoa - EAngle is not a class... didn't know that
# ==============================================================================================================
def EAngle(l1: Line.ELine | str,
           l2: Line.ELine = None,
           size: float = mn_scale(40),
           no_right: bool = False,
           gnomon: bool = False,
           **kwargs) -> Gnomon| ArcAngle| RightAngle:

    # to be deleted later, I don't want to support this, its too weird
    if isinstance(l1, str):
        l1, l2 = Line.ELine.find_in_frame(l1)

    assert (l2 is not None)

    # ----------------------------------------------------------------------------------------------------------
    # get info about the angle
    # ----------------------------------------------------------------------------------------------------------
    data = angle_coords(l1, l2)
    c, v1, v2 = data

    if c is None:
        raise Exception(f"No Common Midpoint: {l1.get_start(), l1.get_end()} | {l2.get_start(), l2.get_end()}")

    th1 = math.atan2(v1[1], v1[0])
    th2 = math.atan2(v2[1], v2[0])
    th_diff = th2 - th1

    # ----------------------------------------------------------------------------------------------------------
    # if this is a gnomon (a 270 degree angle defining a weird L-shape right angled polygon)
    # ----------------------------------------------------------------------------------------------------------
    if gnomon:
        if 0 < th_diff < mn.PI:
            th_diff = th_diff - mn.TAU
        elif -mn.PI < th_diff < mn.PI:
            th_diff = mn.TAU + th_diff
        return Gnomon(l1, l2, size, data, th1, th_diff, **kwargs)

    # ----------------------------------------------------------------------------------------------------------
    # Just a regular angle
    # ----------------------------------------------------------------------------------------------------------
    if th_diff > mn.PI:
        th_diff = th_diff - mn.TAU
    elif th_diff < -mn.PI:
        th_diff = mn.TAU + th_diff

    if abs(abs(th_diff) - mn.PI / 2) < (1 * mn.DEGREES) and not no_right:
        return RightAngle(l1, l2, size, data, th1, th_diff, **kwargs)
    else:
        return ArcAngle(l1, l2, size, data, th1, th_diff, **kwargs)
