from __future__ import annotations

import math
from typing import Iterable

from .EucidMObject import *

def darken(colour: ManimColor):
   return [
       mn.interpolate_color(colour, BLACK, 2/3)
       for color in mn.listify(colour)
   ]

class EuclidPoint(EMObject, mn.Circle):
    CONSTRUCTION_TIME=0.25
    LabelBuff = mn.SMALL_BUFF

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

    def e_label_point(self, direction: mn.Vect3):
        return self.get_arc_center()

    def distance_to(self, position: mn.Vect3):
        x0, y0, *_ = self.get_arc_center()
        x1, y1, *_ = position
        dx = x1 - x0
        dy = y1 - y0
        return math.sqrt(dx**2 + dy**2)
