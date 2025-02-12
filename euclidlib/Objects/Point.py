from __future__ import annotations

import math
from typing import Iterable

from .EucidMObject import *
from .utils import call_or_get


def darken(colour: ManimColor):
   return [
       mn.interpolate_color(colour, BLACK, 2/3)
       for color in mn.listify(colour)
   ]

class EuclidPoint(EMObject, mn.Circle):
    CONSTRUCTION_TIME=0.25
    LabelBuff = mn.MED_SMALL_BUFF

    @staticmethod
    def find_in_frame(names):
        from inspect import currentframe
        point_names = list(names)
        f = currentframe()
        while (f := f.f_back) is not None:
            if 'p' in f.f_locals or all(p in f.f_locals for p in point_names):
                break
        if f is None:
            raise Exception(f"Can't Find Points dict or Point variables {', '.join(names)}")
        points = [f.f_locals.get(p, f.f_locals.get('p', {}).get(p)) for p in names]
        if all(p is not None for p in points):
            return points

        raise Exception(f"Can't find point(s) {', '.join( n for p, n in zip(points, names) if p is None)}")

    def __init__(self, center, animate_part=None, *args, **kwargs):
        super().__init__(
            arc_center=convert_to_coord(center),
            radius=0.05,
            stroke_color=darken(mn.GREY),
            stroke_width=2,
            fill_color=mn.WHITE,
            fill_opacity=1.0,
            animate_part=['set_fill', 'set_stroke'] if animate_part is None else animate_part,
            *args,
            **kwargs)
        self.z_index += 2


    def set_color(
            self,
            color: ManimColor | Iterable[ManimColor] | None,
            opacity: float | Iterable[float] | None = None,
            recurse: bool = True
    ) -> Self:
        self.set_fill(color, opacity=opacity, recurse=recurse)
        self.set_stroke(darken(color), opacity=opacity, recurse=recurse)
        return self

    def e_label_point(self,
                      direction: mn.Vect3 = None,
                      *,
                      away_from: Callable[[], mn.Vect3] | float = None,
                      towards: Callable[[], mn.Vect3] | float = None,
                      buff: float = None
                      ):
        center = self.get_arc_center()
        if away_from is not None:
            direction = mn.normalize(center - call_or_get(away_from))
        elif towards is not None:
            direction = mn.normalize(call_or_get(towards) - center)
        return center + direction * (buff or self.LabelBuff)

    def distance_to(self, position: mn.Vect3):
        x0, y0, *_ = self.get_arc_center()
        x1, y1, *_ = position
        dx = x1 - x0
        dy = y1 - y0
        return math.sqrt(dx**2 + dy**2)
