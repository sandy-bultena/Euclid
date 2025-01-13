from __future__ import annotations

import math

from .EucidMObject import *

class EuclidPoint(EMObject, mn.Circle):
    CONSTRUCTION_TIME=0.25
    LabelBuff = mn.SMALL_BUFF

    def __init__(self, center, *args, **kwargs):
        super().__init__(
            arc_center=(*center, *((0,) * (3 - len(center)))),
            radius=0.075,
            stroke_color=mn.GREY_D,
            stroke_width=2,
            fill_color=mn.WHITE,
            fill_opacity=1.0,
            *args,
            **kwargs)
        self.z_index += 2

    def e_label_point(self, direction: mn.Vect3):
        return self

    def distance_to(self, position: mn.Vect3):
        x0, y0, *_ = self.get_center()
        x1, y1, *_ = position
        dx = x1 - x0
        dy = y1 - y0
        return math.sqrt(dx**2 + dy**2)
