from __future__ import annotations

from .EucidMObject import *
from .utils import call_or_get
import manimlib as mn


def darken(colour: ManimColor):
   return [
       mn.interpolate_color(color, BLACK, 2/3)
       for color in mn.listify(colour)
   ]


# ================================================================================================================
# Point is just a manim circle
# ================================================================================================================
class EPoint(EMObject, mn.Circle):
    CONSTRUCTION_TIME=0.25
    LabelBuff = mn.MED_SMALL_BUFF

    # ----------------------------------------------------------------------------------------------------------------
    # initialize
    # ----------------------------------------------------------------------------------------------------------------
    def __init__(self, center, animate_part=None, *args, fill_color=mn.WHITE, radius=0.075, **kwargs):
        super().__init__(
            arc_center=convert_to_coord(center),
            radius=radius,
            stroke_color=darken(mn.GREY),
            stroke_width=2,
            fill_color=fill_color,
            fill_opacity=1.0,
            animate_part=['set_fill', 'set_stroke'] if animate_part is None else animate_part,
            *args,
            **kwargs)
        self.z_index += 2


    # ----------------------------------------------------------------------------------------------------------------
    # set the colour
    # ----------------------------------------------------------------------------------------------------------------
    def set_color(
            self,
            color: ManimColor | Iterable[ManimColor] | None,
            opacity: float | Iterable[float] | None = None,
            recurse: bool = True
    ) -> Self:
        self.set_fill(color, opacity=opacity, recurse=recurse)
        self.set_stroke(darken(color), opacity=opacity, recurse=recurse)
        return self

    # ----------------------------------------------------------------------------------------------------------------
    # get the point where the label should be drawn
    # ----------------------------------------------------------------------------------------------------------------
    def e_label_location(self,
                         direction: mn.Vect3 = None,
                         buff: float = None,
                         *,
                         away_from: Callable[[], mn.Vect3] | float = None,
                         towards: Callable[[], mn.Vect3] | float = None,
                         ):
        center = self.get_arc_center()
        if away_from is not None:
            direction = mn.normalize(center - call_or_get(away_from))
        elif towards is not None:
            direction = mn.normalize(call_or_get(towards) - center)
        return center + direction * (buff or self.LabelBuff)

    # ----------------------------------------------------------------------------------------------------------------
    # get distance between this point, and an x,y,z position (always a positive number)
    # ----------------------------------------------------------------------------------------------------------------
    def distance_to(self, position: mn.Vect3) -> float:
        x0, y0, z0 = self.get_arc_center()
        x1, y1, z1 = position
        dx = x1 - x0
        dy = y1 - y0
        dz = z1 - z0
        return math.sqrt(dx**2 + dy**2 + dz**2)

    # ----------------------------------------------------------------------------------------------------------------
    # get distance between two points
    # ----------------------------------------------------------------------------------------------------------------
    @classmethod
    def distance_between(cls, p1: EPoint | Vect3, p2: EPoint | Vect3):
        x0, y0, z0 = convert_to_coord(p1)
        x1, y1, z1 = convert_to_coord(p2)
        dx = x1 - x0
        dy = y1 - y0
        dz = z1 - z0
        return math.sqrt(dx**2 + dy**2 + dz**2)

    # ----------------------------------------------------------------------------------------------------------------
    # highlight the point
    # ----------------------------------------------------------------------------------------------------------------
    def highlight(self, color=RED, scale=2.0, **args):
        target = self.animate(rate_func=mn.there_and_back, **args)
        target.scale(scale)
        target.set_color(color)
        return target

    # ----------------------------------------------------------------------------------------------------------------
    # two points overlap?
    # ----------------------------------------------------------------------------------------------------------------
    def intersect(self, other: Mobject, reverse=True):
        if isinstance(other, mn.Rectangle):
            return self.intersect_selection(other)
        super().intersect(other)

    # ----------------------------------------------------------------------------------------------------------------
    # is point touching a rectangle?
    # ----------------------------------------------------------------------------------------------------------------
    def intersect_selection(self, other: mn.Rectangle):
        return other.is_touching(self)

    # # ================================================================================================================
    # # given names of points, return the point objects
    # # ================================================================================================================
    # @staticmethod
    # def find_in_frame(names: Iterable) -> list[EPoint]:
    #     """
    #     Based on the variable(?) names of the points, get the objects by going up the
    #     call stack and finding the values according to their name
    #     """
    #     from inspect import currentframe
    #     point_names = list(names)
    #     f = currentframe()
    #
    #     # go up the stack and look for points in the local variables in the specific frame
    #     while (f := f.f_back) is not None:
    #         if 'p' in f.f_locals or all(p in f.f_locals for p in point_names):
    #             break
    #     if f is None:
    #         raise Exception(f"Can't Find Points dict or Point variables {', '.join(names)}")
    #
    #     # get the point objects
    #     points = [f.f_locals.get(p, f.f_locals.get('p', {}).get(p)) for p in names]
    #     if all(p is not None for p in points):
    #         return points
    #
    #     raise Exception(f"Can't find point(s) {', '.join( n for p, n in zip(points, names) if p is None)}")
    #


class VirtualPoint(EPoint):
    Virtual = True