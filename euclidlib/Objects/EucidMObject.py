from __future__ import annotations
from functools import partial
from math import isinf

import manimlib as mn
import euclidlib.Propositions.PropScene as ps
from manimlib.constants import *
from .CustomAnimation import UncreatePreserve
from typing import Sized, Self

# from . import Text as T

DEFAULT_FADE_OPACITY = 0.15
DEFAULT_CONSTRUCTION_RUNTIME = 0.5
DEFAULT_TRANSFORM_RUNTIME = 0.25


def mn_coord(x: int, y: int, z: int = 0):
    return (
        (x - 700) * (8.0 / 800),  # (x - 700) * (8.0 * 16 / 1400 / 9),
        (400 - y) * (8.0 / 800),
        z * (8.0 / 800)
    )


def mn_scale(f, *rest):
    if rest:
        return tuple(i * (8.0/800) for i in (f, *rest))
    return f * (8.0/800)


def to_manim_h_scale(x):
    return x * (8.0 * 16 / 1400 / 9)


def un_create_version(anim: mn.Animation):
    anim.remover = True
    anim.should_match_start = True
    curr_rate = anim.rate_func
    anim.rate_func = lambda t: curr_rate(1 - t)
    return anim


class NullAnimationBuilder:
    def __getattr__(self, item):
        return self

    def __call__(self, *args, **kwargs):
        return self


class EMObjectPlayer:
    def __init__(self, eobj: EMObject):
        self.rotating = False
        self.eobj = eobj
        self.anim = eobj.animate
        self.label_anim = eobj.e_label.animate if eobj.e_label is not None else NullAnimationBuilder()

        self.o_animate_part = eobj.animate_part
        self.l_animate_part = eobj.e_label.animate_part if eobj.e_label is not None else []

        self.fade_out_flag = False
        self.fade_in_flag = False
        self.main_animate = False
        self.label_animate = False
        self.rotation = []

    @classmethod
    def _properties(cls):
        for name, val in cls.__dict__.items():
            if name.startswith('_'):
                continue
            if isinstance(val, property):
                yield name

    @classmethod
    def _methods(cls):
        for name, val in cls.__dict__.items():
            if name.startswith('_'):
                continue
            if isinstance(val, property):
                continue
            if callable(val):
                yield name

    @property
    def e_fade(self):
        self.main_animate = self.label_animate = True
        for meth in self.o_animate_part:
            getattr(self.anim, meth)(opacity=DEFAULT_FADE_OPACITY)
        for meth in self.l_animate_part:
            getattr(self.label_anim, meth)(opacity=0.0)
        return self

    @property
    def e_normal(self):
        self.main_animate = self.label_animate = True
        for meth in self.o_animate_part:
            getattr(self.anim, meth)(opacity=1.0)
        for meth in self.l_animate_part:
            getattr(self.label_anim, meth)(opacity=1.0)
        return self

    def _e_color(self, color: mn.Color):
        self.main_animate = True
        self.e_normal.anim.set_color(color=color)
        return self

    @property
    def green(self):
        return self._e_color(mn.GREEN)

    @property
    def blue(self):
        return self._e_color(mn.BLUE)

    @property
    def red(self):
        return self._e_color(mn.RED)

    @property
    def white(self):
        return self._e_color(mn.WHITE)

    @property
    def lift(self):
        if self.eobj.visible():
            self.eobj.scene.add(self.eobj)
        return self

    @property
    def notice(self):
        self.eobj.scene.play(mn.Indicate(self.eobj, color=mn.RED))
        return self

    def e_move_to(self,
                  point_or_mobject: mn.Mobject | Vect3,
                  aligned_edge: Vect3 = ORIGIN,
                  coor_mask: Vect3 = np.array([1, 1, 1])):
        self.main_animate = True
        self.anim.move_to(point_or_mobject, aligned_edge, coor_mask)
        return self

    def e_move(self, vector: Vect3):
        self.main_animate = True
        self.anim.shift(vector)
        return self

    def e_to_edge(self,
                  edge: Vect3 = LEFT,
                  buff: float = DEFAULT_MOBJECT_TO_EDGE_BUFFER):
        self.main_animate = True
        self.anim.to_edge(edge, buff)
        return self

    def e_to_corner(self,
                    corner: Vect3 = DL,
                    buff: float = DEFAULT_MOBJECT_TO_EDGE_BUFFER):
        self.main_animate = True
        self.anim.to_to_corner(corner, buff)
        return self

    def e_rotate(self, about: Vect3, angle: float):
        self.main_animate = True
        self.anim.rotate(angle, about_point=about)
        self.rotating = True
        return self

    def _build_anim(self, anim, obj: mn.VMobject, flag, **kwargs):
        if obj is None or not flag:
            return None
        if 'run_time' not in kwargs:
            kwargs['run_time'] = DEFAULT_TRANSFORM_RUNTIME

        if self.rotating:
            kwargs['path_arc'] = PI

        anim_built = anim(**kwargs).build()
        return anim_built

    def __call__(self, *args, **kwargs):
        anim_built = self._build_anim(self.anim, self.eobj, self.main_animate, **kwargs)
        label_built = self._build_anim(self.label_anim, self.eobj.e_label, self.label_animate, **kwargs)

        if self.eobj.in_scene():
            anims = [an for an in (anim_built, label_built) if an is not None]
            if anims:
                self.eobj.scene.play(*anims)
        else:
            if self.main_animate:
                self.eobj.become(self.eobj.target)
            if self.eobj.e_label is not None and self.label_animate:
                self.eobj.e_label.become(self.eobj.e_label.target)
        return self.eobj


def convert_to_coord(obj: mn.Mobject | Sized[float]):
    if isinstance(obj, mn.Mobject):
        return obj.get_center()
    else:
        return *obj, *((0.0,) * (3 - len(obj)))


class EMObject(mn.VMobject):
    LabelBuff = mn.MED_SMALL_BUFF
    CONSTRUCTION_TIME = 1

    @property
    def AUX_CONSTRUCTION_TIME(self):
        return self.CONSTRUCTION_TIME / 2

    Virtual = False

    def CreationOf(self, *args, **kwargs):
        return [mn.ShowCreation(self, *args, **kwargs, run_time=self.CONSTRUCTION_TIME)]

    def RemovalOf(self, *args, **kwargs):
        return [UncreatePreserve(self, *args, **kwargs, run_time=self.CONSTRUCTION_TIME)]

    def in_scene(self):
        return self in self.scene.mobjects

    if TYPE_CHECKING:
        blue: EMObjectPlayer
        green: EMObjectPlayer
        red: EMObjectPlayer
        white: EMObjectPlayer
        e_fade: EMObjectPlayer
        e_normal: EMObjectPlayer
        lift: EMObjectPlayer

        def e_move(self, vev: Vect3) -> EMObjectPlayer: ...

        def e_rotate(self, about: Vect3, angle: float) -> EMObjectPlayer: ...

    for name in EMObjectPlayer._properties():
        exec(f'''
@property
def {name}(self):
    return EMObjectPlayer(self).{name}
        '''.strip())

    for name in EMObjectPlayer._methods():
        exec(f'''
def {name}(self, *args):
    return EMObjectPlayer(self).{name}(*args)
        '''.strip())

    def visible(self):
        return self.in_scene() and (self.get_stroke_opacity() != 0 or self.get_fill_opacity() != 0)

    def add_label(self, label: str, label_dir: mn.Vect3):
        new_label = self.init_label(label, label_dir)
        if self.e_label is not None:
            self.scene.play(mn.TransformMatchingStrings(self.e_label, new_label, run_time=0.5))
        else:
            self.scene.play(*new_label.CreationOf())
        self.e_label = new_label

    def remove_label(self):
        if self.e_label is not None:
            if not self.e_label.visible():
                self.scene.remove(self.e_label)
            else:
                self.scene.play(mn.FadeOut(self.e_label))
        self.e_label = None

    def e_label_point(self, direction: mn.Vect3):
        raise NotImplementedError()

    def intersect(self, other: EMObject):
        raise NotImplementedError()

    def init_label(self, label: str, label_dir: mn.Vect3):
        from . import T
        if label:
            return T.Label(label, ref=self, direction=label_dir)

    def e_draw(self, skip_anim=False):
        if not skip_anim and not self.Virtual:
            anims = [
                anim
                for x in (self, self.e_label)
                if x is not None
                for anim in x.CreationOf()
            ]

            if anims:
                self.scene.play(*anims)
            if self.animation_objects:
                for obj in self.animation_objects:
                    obj.clear_updaters()
                self.scene.play(*map(partial(mn.Uncreate, run_time=self.AUX_CONSTRUCTION_TIME), self.animation_objects))
        else:
            self.scene.add(self)

    def e_remove(self):
        if not self.Virtual:
            anims = self.RemovalOf()
            self.remove_label()
            if anims:
                self.scene.play(*anims, run_time=self.CONSTRUCTION_TIME)
        else:
            self.scene.remove(self)

    def e_delete(self):
        self.scene.remove(self)
        if self.e_label:
            self.scene.remove(self.e_label)

    def __find_scene(self):
        from inspect import currentframe
        f = currentframe()
        while f.f_back:
            f = f.f_back
            if 'self' not in f.f_locals:
                continue
            f_self = f.f_locals['self']
            if isinstance(f_self, EMObject) and hasattr(f_self, 'scene'):
                return f_self.scene
            if isinstance(f_self, ps.PropScene):
                return f_self

    def __init__(self,
                 *args,
                 label: str = None,
                 label_dir: mn.Vect3 = None,
                 stroke_width: float = 2,
                 animate_part=None,
                 delay_anim=False,
                 skip_anim=False,
                 scene: ps.PropScene = None,
                 **kwargs):

        scene = scene or self.__find_scene()
        if scene is None:
            raise Exception("Could Not Find Scene Object")
        self.animate_part = ['set_stroke'] if animate_part is None else animate_part
        self.old_fill_opacity = 0.0
        self.scene = scene
        self.animation_objects: List[mn.Mobject] = []
        kwargs['stroke_width'] = stroke_width

        if self.Virtual:
            kwargs['stroke_opacity'] = 0.2 if self.scene.debug else 0.0
            kwargs['stroke_color'] = mn.RED

        super().__init__(*args, **kwargs)
        self.e_label = self.init_label(label, label_dir)
        if not delay_anim:
            self.e_draw(skip_anim)
