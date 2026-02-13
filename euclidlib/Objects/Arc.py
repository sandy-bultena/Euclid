from __future__ import annotations

import itertools
import math
from enum import Enum

import manimlib as mn

from euclidlib.Objects.em_object_base import *
from euclidlib.Objects.em_object_decorators import *
from euclidlib.Utilities.coordinate_utilities import mn_scale, convert_to_coord, mn_coord
from . import Circle
from . import Line
from . import Text
from . import Point
from euclidlib.Objects import Dashable as Da
DEG = mn.TAU/360

class ArcLabelLocation(Enum):
    BY_ALPHA = 0
    AT_START = 1
    AT_END = None

# ==============================================================================================================
# Abstract Arc
# ==============================================================================================================
class AbstractArc(Da.Dashable, mn.Arc):
    size: float
    e_angle: float
    e_start_angle: float
    e_end_angle: float
    vx: float
    vy: float

    # ----------------------------------------------------------------------------------------------------------
    # Constructor
    # ----------------------------------------------------------------------------------------------------------
    def __init__(
            self,
            start_angle: float = 0,
            angle: float = mn.TAU / 4,
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

    # ----------------------------------------------------------------------------------------------------------
    # properties
    # ----------------------------------------------------------------------------------------------------------
    @property
    def v(self) -> mn.Vect3:
        return self.get_arc_center()

    @property
    def center(self) -> mn.Vect3:
        return self.get_arc_center()

    @property
    def r(self):
        return self.size

    @property
    def radius(self):
        return self.size

    @property
    def arc(self):
        return self.e_angle

    if TYPE_CHECKING:
        def add_label(self, text: str, where=ArcLabelLocation.BY_ALPHA, alpha=0.5, buff=LABEL_BUFF):
            """
            where is the arc label located?
            :param text: string
            :param where: decided by alpha, or start or end of arc
            :param alpha: what fraction along the arc do you want the label
            :param buff: how far from arc do you want the label
            """

    # ----------------------------------------------------------------------------------------------------------
    # method called by manim... used for transformations??
    # ----------------------------------------------------------------------------------------------------------
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

    # ----------------------------------------------------------------------------------------------------------
    # override manim's interpolate function
    # ----------------------------------------------------------------------------------------------------------
    # def interpolate(
    #         self,
    #         mobject1: AbstractArc,
    #         mobject2: AbstractArc,
    #         alpha: float,
    #         path_func: Callable[[np.ndarray, np.ndarray, float], np.ndarray] = mn.straight_path
    # ) -> Self:
    #     self.vx, self.vy, _ = mn.interpolate(mobject1.get_arc_center(), mobject2.get_arc_center(), alpha)
    #     self.e_start_angle = mn.interpolate(mobject1.e_start_angle, mobject2.e_start_angle, alpha)
    #     self.e_end_angle = mn.interpolate(mobject1.e_end_angle, mobject2.e_end_angle, alpha)
    #     return super().interpolate(mobject1, mobject2, alpha, path_func)

    # ----------------------------------------------------------------------------------------------------------
    # Faster method of getting arc center than the one manim uses
    # ----------------------------------------------------------------------------------------------------------
    def get_arc_center(self) -> mn.Vect3:
        return np.array([self.vx, self.vy, 0])

    # ----------------------------------------------------------------------------------------------------------
    # shift: part of manim transformation routines, but keep track of centre of arc
    # ----------------------------------------------------------------------------------------------------------
    def shift(self, vector: mn.Vect3) -> Self:
        self.vx += vector[0]
        self.vy += vector[1]
        return super().shift(vector)

    # ----------------------------------------------------------------------------------------------------------
    # rotate - but keep track of start and stop angle
    # ----------------------------------------------------------------------------------------------------------
    def rotate(self, angle: float, *args, **kwargs) -> Self:
        self.e_start_angle += angle
        self.e_end_angle += angle
        return super().rotate(angle, *args, **kwargs)

    # ----------------------------------------------------------------------------------------------------------
    # get angle proportionally between start and end of this arc
    # ----------------------------------------------------------------------------------------------------------
    def proportion_angle(self, alpha: float):
        interp = mn.interpolate(self.e_start_angle, self.e_end_angle, alpha)
        return interp

    # ----------------------------------------------------------------------------------------------------------
    # same as proportional_angle, but with alpha = 0.5
    # ----------------------------------------------------------------------------------------------------------
    def get_bisect(self):
        return self.proportion_angle(0.5)

    # ----------------------------------------------------------------------------------------------------------
    # Get the vector that points in direction of angle (right angles to the tangent of the arc)
    # ----------------------------------------------------------------------------------------------------------
    @staticmethod
    def vector_of_angle(angle):
        return np.array([math.cos(angle), math.sin(angle), 0.0])

    # ----------------------------------------------------------------------------------------------------------
    # get the vector 90 deg to the tangent of the arc at a proportional distance from the start angle
    # ----------------------------------------------------------------------------------------------------------
    def proportional_angle_dir(self, alpha=0.5):
        angle = self.proportion_angle(alpha)
        return self.vector_of_angle(angle)

    # ----------------------------------------------------------------------------------------------------------
    # highlight this arc
    # ----------------------------------------------------------------------------------------------------------
    def highlight(self, color=mn.YELLOW, scale=2.0, **args):
        return (self.animate(rate_func=mn.there_and_back, **args)
                .set_stroke(color=color, width=scale * float(self.get_stroke_width())))

    # ----------------------------------------------------------------------------------------------------------
    # initialize label or labels (not animated) (calling 'add_label' does the animations)
    # ----------------------------------------------------------------------------------------------------------
    def init_label(self, labels: str | list[str], *args, **extra_args):
        if isinstance(labels, str):
            return super().init_label(labels, *args, **extra_args)
        return Text.LabelGroup(
            labels,
            self,
            itertools.repeat(args),
            itertools.repeat(extra_args)
        )

    # ----------------------------------------------------------------------------------------------------------
    # what are the tangent directions
    # ----------------------------------------------------------------------------------------------------------
    def tangent_at_start(self):
        dir = -mn.PI / 2 if self.e_angle > 0 else mn.PI / 2
        return self.vector_of_angle(self.e_start_angle + dir)

    def tangent_at_end(self):
        dir = mn.PI / 2 if self.e_angle > 0 else -mn.PI / 2
        return self.vector_of_angle(self.e_end_angle + dir)

    def tangent_points(self, angle_or_point: float | mn.Mobject | mn.Vect3, negative=False) -> tuple[mn.Vect3, mn.Vect3]:
        """return point, and tangent direction at that point on the arc"""
        if isinstance(angle_or_point, (float, np.float32, np.float64)):
            t_point = self.point_at_angle(angle_or_point)
        else:
            t_point = convert_to_coord(angle_or_point)
        rotation = mn.PI / 2 * (1 if (negative != self.e_angle > 0) else -1)
        vec = t_point - self.v
        return t_point, t_point + mn.rotate_vector(vec / 2, rotation)

    # ----------------------------------------------------------------------------------------------------------
    # e_label_location
    # - where is the label located?
    # ----------------------------------------------------------------------------------------------------------
    def e_label_location(self, where=ArcLabelLocation.BY_ALPHA, alpha=0.5, buff=None):
        if where == ArcLabelLocation.BY_ALPHA:
            bisect_dir = self.proportional_angle_dir(alpha)
            try:
                base = self.point_from_proportion(alpha) # manimlib stuff
            except AssertionError:
                base = self.get_arc_center() + bisect_dir * self.size
            return base + bisect_dir * (buff or self.LabelBuff)

        if where == ArcLabelLocation.AT_START:
            return self.get_start() + self.tangent_at_start() * (buff or self.LabelBuff)

        return self.get_end() + self.tangent_at_end() * (buff or self.LabelBuff)

    # ----------------------------------------------------------------------------------------------------------
    # return the coordinates on the arc at a given angle
    # ----------------------------------------------------------------------------------------------------------
    def point_at_angle(self, angle) -> mn.Vect3:
        alpha = (angle - self.e_start_angle) / self.e_angle
        return self.point_from_proportion(alpha)

    # ----------------------------------------------------------------------------------------------------------
    # return a point on the arc at a given angle
    # ----------------------------------------------------------------------------------------------------------
    def e_point_at_angle(self, angle) ->Point.EPoint:
        """create and return a EPoint object on the arc, located at angle (in radians)"""
        return Point.EPoint(self.point_at_angle(angle))
    
    # ----------------------------------------------------------------------------------------------------------
    # intersect two circles
    # ----------------------------------------------------------------------------------------------------------
    def intersect_circle(self, other: AbstractArc) -> Optional[tuple[mn.Vect3,...]]:
        """Find the two points (or None) where two circles intersect"""

        p2, r2 = other.center, other.radius
        base = Line.VirtualLine(self.center, p2, scene=self.scene, stroke_color=mn.BLUE)
        d = base.get_length()

        # divide d into d1, d2,
        # corresponding to the horizontal position of the vertex
        d1 = 1 / (2 * d) * (d ** 2 + self.radius ** 2 - r2 ** 2)
        d2 = d - d1

        # calculate the height of the triangle
        hsqr = r2 ** 2 - d2 ** 2
        if abs(hsqr) < mn_scale(0.2):
            hsqr = 0

        # if hsqr is negative, then the circles don't intersect
        if hsqr < 0:
            base.e_remove()
            return None

        h = math.sqrt(hsqr)

        # ------------------------------------------------------------------------
        # find x,y coordinates for d1 and h
        # ------------------------------------------------------------------------
        sx, sy, *_ = base.get_start()
        if d1 < mn_scale(1):
            sx, sy, *_ = base.get_end()

        px, py, _ = base.point(d1)

        p4x = px + py - sy
        p4y = py - px + sx
        p1x = px - py + sy
        p1y = py + px - sx

        hline1 = Line.VirtualLine((px, py), (p4x, p4y), scene=self.scene)
        hline2 = Line.VirtualLine((px, py), (p1x, p1y), scene=self.scene)

        h1 = hline1.point(h)
        h2 = hline2.point(h)

        hline1.e_remove()
        hline2.e_remove()
        base.e_remove()

        if h1[1] < h2[1]:
            return h2, h1
        else:
            return h1, h2

    # ----------------------------------------------------------------------------------------------------------
    # intersect line
    # ----------------------------------------------------------------------------------------------------------
    def intersect_line(self, other: Line.ELine) -> Optional[tuple[mn.Vect3,...]] :
        """Find the two points (or None) where a line intersects a circle"""
        x, y, _ = self.center
        r = self.radius

        x0, y0, _ = other.get_start()
        x1, y1, _ = other.get_end()
        m = other.get_e_slope()

        if not math.isinf(m):
            # math:
            # circle eq'n: (x-$x)^2 + (y-$y)^2 = $r^2
            # line eq'n:   y = mx+b, (b = $y1 - $m * $x1)
            # Intersection of line & circle solves the following eq'n for x:
            #   (x-$x)^2 + ($m x + $b - $y)^2 = $r^2

            i = y0 - m * x0
            a = 1 + m ** 2
            b = 2 * m * (i - y) - 2 * x
            c = (i - y) ** 2 + x ** 2 - r ** 2
            sqr = b ** 2 - 4 * a * c

            if sqr < 0:
                return None

            x3 = (-b + math.sqrt(sqr)) / (2 * a)
            x4 = (-b - math.sqrt(sqr)) / (2 * a)
            y3 = m * x3 + i
            y4 = m * x4 + i
        else:
            # math:
            # circle eq'n: (x-$x)^2 + (y-$y)^2 = $r^2
            # line eq'n:   x = $x1,
            # Intersection of line & circle solves the following eq'n for y:
            #   ($x1-$x)^2 + (y-$y)^2 = $r^2
            # binomial eq'n (-b +/- sqrt(b^2 - 4ac)) / 2a

            a = 1
            b = -2 * y
            c = (x0 - x) ** 2 + y ** 2 - r ** 2

            sqr = b ** 2 - 4 * a * c

            if sqr < 0:
                return None

            x3 = x0
            x4 = x0
            y3 = (-b + math.sqrt(sqr)) / (2 * a)
            y4 = (-b - math.sqrt(sqr)) / (2 * a)

        results = []
        max_x = max(x1, x0)
        min_x = min(x1, x0)
        max_y = max(y1, y0)
        min_y = min(y1, y0)

        epsilon = mn_scale(1)

        if min_x - epsilon <= x3 <= max_x + epsilon and min_y - epsilon <= y3 < max_y + epsilon:
            results.append(np.array((x3, y3, 0)))
        if min_x - epsilon <= x4 <= max_x + epsilon and min_y - epsilon <= y4 < max_y + epsilon:
            results.append(np.array((x4, y4, 0)))

        return tuple(results)

    # ----------------------------------------------------------------------------------------------------------
    # intersect selection (which would me a rectangle)
    # ----------------------------------------------------------------------------------------------------------
    def intersect_selection(self, other: mn.Rectangle)->bool:
        """Does this circle intersect with the specified rectangle?"""
        corners = [other.get_corner(x) for x in [mn.UL, mn.UR, mn.DR, mn.DL, mn.UL]]
        return any(self.intersect(mn.Line(x, y)) for x, y in itertools.pairwise(corners))

    # ----------------------------------------------------------------------------------------------------------
    # generic intersect
    # ----------------------------------------------------------------------------------------------------------
    def intersect(self, other: mn.Mobject, reverse=True) ->  Optional[tuple[mn.Vect3,...]| bool]:
        """
        find intersection points, or true/false if other is a Rectangle
        :param other: Arc, Line or Rectangle
        :param reverse: not used
        :return:
        """
        if isinstance(other, AbstractArc):
            return self.intersect_circle(other)
        if isinstance(other, Line.ELine):
            return self.intersect_line(other)
        if isinstance(other, mn.Rectangle):
            return self.intersect_selection(other)
        return super().intersect(other)

# ==============================================================================================================
# EArc
# ==============================================================================================================

class EArc(AbstractArc):

    # --------------------------------------------------------------------------------------------------------
    # Constructor
    # --------------------------------------------------------------------------------------------------------
    def __init__(self,
                 radius: float,
                 point1: EMObject | mn.Vect3,
                 point2: EMObject | mn.Vect3,
                 clockwise=False,
                 **kwargs):

        point1 = convert_to_coord(point1)
        point2 = convert_to_coord(point2)

        d = Line.VirtualLine(point1, point2)
        if radius < d.get_length() / 2:
            raise ValueError(f"radius of curvature too small for points\n\t"
                             f"need at least {d.get_length() / 2}\n\t"
                             f"radius given is {radius}")

        c1 = Circle.VirtualCircle(point1, point1 + radius * mn.RIGHT)
        c2 = Circle.VirtualCircle(point2, point2 + radius * mn.RIGHT)
        ps = c1.intersect(c2)
        center = ps[0]
        v1 = point1 - center
        v2 = point2 - center
        diff = mn.angle_of_vector(v2) - mn.angle_of_vector(v1)

        if clockwise and diff > 0:
            diff -= mn.TAU
        elif not clockwise and diff < 0:
            diff += mn.TAU


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


    # --------------------------------------------------------------------------------------------------------
    # create a semi-circle
    # --------------------------------------------------------------------------------------------------------
    @classmethod
    def semi_circle(cls, p1: Point.EPoint | mn.Vect3, p2: Point.EPoint | mn.Vect3, clockwise=False):
        with Line.VirtualLine(p1, p2) as d:
            r = d.get_length() / 2 + mn_scale(0.0001)
        return cls(r, p1, p2, clockwise=clockwise)

    # --------------------------------------------------------------------------------------------------------
    # turn an arc segment into a pie shape
    # --------------------------------------------------------------------------------------------------------
    def create_pie(self, **kwargs):
        """Turn an arc segment into a slice of pie :) yummy!"""
        pie = EMObject(stroke_width=0, animate_part=['set_e_fill'], skip_anim=True, **kwargs)
        pie.set_points(self.get_points())
        pie.add_points_as_corners([self.v, self.get_start()])
        return pie

    # --------------------------------------------------------------------------------------------------------
    # bisect the arc
    # --------------------------------------------------------------------------------------------------------
    @anim_speed
    def bisect(self)->Optional[Point.EPoint]:
        line = Line.ELine(*self.get_start_and_end())
        p3 = line.bisect()
        perp = line.perpendicular(p3)
        perp.extend_and_prepend(2 * self.radius)
        
        pts : list[mn.Vect3] | None = self.intersect(perp)
        results = None
        if pts:
            results = Point.EPoint(pts[0])

        with self.scene.simultaneous():
            p3.e_remove()
            line.e_remove()
            perp.e_remove()     
        return results
    
    # --------------------------------------------------------------------------------------------------------
    # intersect
    # --------------------------------------------------------------------------------------------------------
    def intersect(self, other: mn.Mobject, reverse=True) -> mn.Vect3 | None:
        pts = super().intersect(other, reverse) or []
        # do the points actually intersect the arc (as opposed to the
        # circle defining the arc?)

        c = self.center

        # if an object is used as a context manager, it is removed at the end of the block
        with Circle.VirtualCircle(c, c + mn.RIGHT * self.radius) as virt:
            results = []
            start_angle, end_angle = sorted((x+0.0001*DEG) % mn.TAU for x in (self.e_start_angle, self.e_end_angle))

            if not isinstance(pts, (list, tuple)):
                pts = [pts]
            for p in pts:
                angle = virt.angle_of_point(p)
                if start_angle <= angle <= end_angle:
                    results.append(p)

        return results

