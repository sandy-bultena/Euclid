from __future__ import annotations

import math
from functools import partial

from manimlib import *
import euclidlib.Propositions.PropScene as ps

class EMObject(VMobject):
    LabelBuff = MED_SMALL_BUFF

    def CreationOf(self, *args, **kwargs):
        return [ShowCreation(self, *args, **kwargs)]

    def dullout(self):
        anims = [self.animate.set_stroke(opacity=0.2)]
        if self.e_label is not None:
            anims.append(self.e_label.animate.set_stroke(opacity=0).set_fill(opacity=0))
        self.scene.play(*anims, run_time=0.25)

    def normal(self):
        anims = [self.animate.set_stroke(opacity=1)]
        if self.e_label is not None:
            anims.append(self.e_label.animate.set_stroke(opacity=1).set_fill(opacity=1))
        self.scene.play(*anims, run_time=0.25)

    def add_label(self, label: str, label_dir: Vect3):
        self.e_label = Label(label, ref=self, direction=label_dir)
        self.scene.play(*self.e_label.CreationOf())

    def e_label_point(self, direction: Vect3):
        raise NotImplementedError()

    def __init__(self, *args, scene: ps.PropScene, label: str = None, label_dir: Vect3 = None, **kwargs):
        self.scene = scene
        self.animation_objects: List[Mobject] = []
        super().__init__(*args, **kwargs)
        self.e_label = Label(label, ref=self, direction=label_dir) if label else None
        anims = [
            anim
            for x in (self, self.e_label)
            if x is not None
            for anim in x.CreationOf()
        ]
        scene.play(*anims)
        if self.animation_objects:
            for obj in self.animation_objects:
                obj.clear_updaters()
            scene.play(*map(partial(Uncreate, run_time=0.5), self.animation_objects))

class EuclidPoint(EMObject, Circle):
    LabelBuff = SMALL_BUFF

    def __init__(self, center, *args, **kwargs):
        super().__init__(
            arc_center=(*center, *((0,)*(3-len(center)))),
            radius=0.1,
            stroke_color=GREY,
            stroke_width=3,
            fill_color=WHITE,
            fill_opacity=1.0,
            *args,
            **kwargs)

    def e_label_point(self, direction: Vect3):
        return self

class EuclidCircle(EMObject, Circle):
    def CreationOf(self, *args, **kwargs):
        tmpLine = Line(self.e_center, self.get_end(), stroke_color=RED)
        self.animation_objects.append(tmpLine)
        self.scene.play(ShowCreation(tmpLine, run_time=0.5))
        tmpLine.f_always.set_points_by_ends(lambda: self.e_center, lambda: self.get_end())
        return super().CreationOf(*args, **kwargs)

    def e_label_point(self, direction: Vect3):
        return self.get_edge_center(direction)

    def __init__(self, center, point, *args, **kwargs):
        self.e_center = center.get_center() if isinstance(center, Mobject) else center
        self.e_point = point.get_center() if isinstance(point, Mobject) else point

        dx = self.e_point[0]-self.e_center[0]
        dy = self.e_point[1]-self.e_center[1]
        radius = math.sqrt(dx**2 + dy**2)
        angle = math.atan2(dy, dx)

        super().__init__(
            start_angle=angle,
            arc_center=self.e_center,
            radius=radius,
            stroke_color=WHITE,
            *args,
            **kwargs
        )

class EuclidLine(EMObject, Line):

    def __init__(self, start: Mobject, end: Mobject, *args, **kwargs):
        self.e_start = start
        self.e_end = end
        super().__init__(start, end, *args, **kwargs)

    def e_label_point(self, direction: Vect3):
        return self.get_center()



class Label(Text):
    def CreationOf(self, *args, **kwargs):
        return [Write(self, *args, **kwargs)]

    def __init__(self, *args, ref: EMObject, direction: Vect3, **kwargs):
        super().__init__(*args, font_size=20, **kwargs)
        self.always.next_to(ref.e_label_point(direction), direction, ref.LabelBuff)
