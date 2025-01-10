from __future__ import annotations
from .EucidMObject import *

class EuclidPoint(EMObject, Circle):
    LabelBuff = SMALL_BUFF

    def CreationOf(self, *args, **kwargs):
        if 'run_time' in kwargs:
            kwargs['run_time'] /= 4
        else:
            kwargs['run_time'] = 0.25
        return [ShowCreation(self, *args, **kwargs)]

    def __init__(self, center, *args, **kwargs):
        super().__init__(
            arc_center=(*center, *((0,) * (3 - len(center)))),
            radius=0.075,
            stroke_color=GREY_D,
            stroke_width=2,
            fill_color=WHITE,
            fill_opacity=1.0,
            *args,
            **kwargs)
        self.z_index += 2

    def e_label_point(self, direction: Vect3):
        return self
