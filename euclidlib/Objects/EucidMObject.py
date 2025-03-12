from __future__ import annotations

import math
from functools import partial, wraps
from math import isinf

import manimlib as mn
import numpy as np
from manimlib import Mobject

import euclidlib.Propositions.PropScene as ps
from manimlib.constants import *

from .CustomAnimation import UncreatePreserve, EShowCreation, E_MethodAnimation
from typing import Sized, Self, Callable, Tuple
from contextlib import contextmanager

DEFAULT_FADE_OPACITY = 0.15
DEFAULT_TEXT_FADE_OPACITY = 0.3
DEFAULT_CONSTRUCTION_RUNTIME = 0.5
DEFAULT_TRANSFORM_RUNTIME = 0.25


def mn_coord(x: int | float, y: int | float, z: int | float = 0):
    return np.array([
        (x - 700) * (8.0 / 800),  # (x - 700) * (8.0 * 16 / 1400 / 9),
        (400 - y) * (8.0 / 800),
        z * (8.0 / 800)
    ])


def mn_scale(f, *rest):
    if rest:
        return np.array([i * (8.0 / 800) for i in (f, *rest)])
    return f * (8.0 / 800)


def mn_h_scale(x):
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


class NullPlayer:
    def __init__(self, obj):
        self.obj = obj

    def __getattr__(self, item):
        return self

    def __call__(self, *args, **kwargs):
        return self.obj


def _build_anim_base(anim):
    if anim.overridden_animation:
        return anim.overridden_animation
    return E_MethodAnimation(anim.mobject, anim.methods, **anim.anim_args)


class EMObjectPlayer:
    def __init__(self, eobj: EMObject):
        self.rotating = False
        self.eobj = eobj

        if eobj.is_frozen:
            self.anim = NullAnimationBuilder()
        else:
            self.anim = eobj.animate

        if eobj.is_frozen or eobj.e_label is None or eobj.e_label.is_frozen:
            self.label_anim = NullAnimationBuilder()
        else:
            self.label_anim = eobj.e_label.animate

        self.o_animate_part = eobj.animate_part
        self.l_animate_part = eobj.e_label.animate_part if eobj.e_label is not None else []

        self.fade_out_flag = False
        self.fade_in_flag = False
        self.main_animate = False
        self.label_animate = False
        self.rotation = []

    @property
    def _fade_opacity(self):
        from . import T
        return DEFAULT_TEXT_FADE_OPACITY if isinstance(self.eobj, T.EStringObj) else DEFAULT_FADE_OPACITY

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
            getattr(self.anim, meth)(opacity=self._fade_opacity)
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
    def grey(self):
        return self._e_color(mn.GREY)

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
                  buff: float = DEFAULT_MOBJECT_TO_EDGE_BUFF):
        self.main_animate = True
        self.anim.to_edge(edge, buff)
        return self

    def e_to_corner(self,
                    corner: Vect3 = DL,
                    buff: float = DEFAULT_MOBJECT_TO_EDGE_BUFF):
        self.main_animate = True
        self.anim.to_to_corner(corner, buff)
        return self

    def e_rotate(self, about: Vect3, angle: float):
        self.main_animate = True
        self.anim.rotate(angle, about_point=about)
        self.rotating = angle
        return self

    def e_scale(self,
                scale: float,
                min_scale_factor: float = 1e-8,
                about_point: Vect3 | None = None,
                about_edge: Vect3 = ORIGIN):
        self.main_animate = True
        self.anim.scale(scale, min_scale_factor, about_point, about_edge)
        return self

    def _build_anim(self, anim, obj: mn.VMobject, flag, **kwargs):
        if obj is None or not flag:
            return None
        if isinstance(anim, NullAnimationBuilder):
            return None
        if 'run_time' not in kwargs:
            kwargs['run_time'] = DEFAULT_TRANSFORM_RUNTIME

        if self.rotating:
            kwargs['path_arc'] = self.rotating

        anim_built = _build_anim_base(anim(**kwargs))
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


def freezable(func):
    @wraps(func)
    def dontIfFrozen(self, *args, **kwargs):
        if self.is_frozen:
            return self
        return func(self, *args, **kwargs)

    return dontIfFrozen


def freezable_player(func):
    @wraps(func)
    def dontIfFrozen(self, *args, **kwargs):
        if self.is_frozen:
            return NullPlayer(self)
        return func(self, *args, **kwargs)

    return dontIfFrozen


def find_scene():
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


class EMObject(mn.VMobject):
    LabelBuff = mn.MED_SMALL_BUFF
    CONSTRUCTION_TIME = 1

    @property
    def AUX_CONSTRUCTION_TIME(self):
        return self.CONSTRUCTION_TIME / 2

    Virtual = False

    def CreationOf(self, *args, **kwargs):
        return [EShowCreation(self, *args, **kwargs, run_time=self.CONSTRUCTION_TIME)]

    def RemovalOf(self, *args, **kwargs):
        return [UncreatePreserve(self, *args, **kwargs, run_time=self.CONSTRUCTION_TIME)]

    def in_scene(self):
        return self in self.scene.mobjects

    if TYPE_CHECKING:
        blue: EMObjectPlayer
        green: EMObjectPlayer
        red: EMObjectPlayer
        white: EMObjectPlayer
        grey: EMObjectPlayer
        e_fade: EMObjectPlayer
        e_normal: EMObjectPlayer
        lift: EMObjectPlayer

        def e_move(self, vev: Vect3) -> EMObjectPlayer: ...

        def e_rotate(self, about: Vect3, angle: float) -> EMObjectPlayer: ...

        def e_scale(self,
                scale: float,
                min_scale_factor: float = 1e-8,
                about_point: Vect3 | None = None,
                about_edge: Vect3 = ORIGIN) -> EMObjectPlayer: ...

    for name in EMObjectPlayer._properties():
        exec(f'''
@property
@freezable_player
def {name}(self):
    return EMObjectPlayer(self).{name}
        '''.strip())

    for name in EMObjectPlayer._methods():
        exec(f'''
@freezable_player
def {name}(self, *args):
    return EMObjectPlayer(self).{name}(*args)
        '''.strip())

    def visible(self):
        return self.in_scene() and (self.get_stroke_opacity() != 0 or self.get_fill_opacity() != 0)

    @freezable
    def add_label(self, *args, **label_args):
        if isinstance(args[-1], dict) and not label_args:
            *args, label_args = args
        new_label = self.init_label(*args, **label_args)

        if self.visible():
            if self.e_label is not None:
                self.scene.play(mn.TransformMatchingStrings(self.e_label, new_label, run_time=0.5))
            else:
                self.scene.play(*new_label.CreationOf())
            new_label.disable_updaters()
        self.e_label = new_label
        return self

    @freezable
    def remove_label(self):
        if self.e_label is not None:
            if not self.e_label.visible():
                self.scene.remove(self.e_label)
            else:
                self.scene.play(mn.FadeOut(self.e_label))
        self.e_label = None
        return self

    @freezable
    def undraw_label(self):
        if self.e_label is not None and self.e_label.visible():
            self.scene.play(mn.FadeOut(self.e_label))
        return self

    def e_label_point(self, *args, **kwargs):
        raise NotImplementedError()

    def highlight(self):
        raise NotImplementedError(f"{self.__class__.__name__} Highlighting is Undefined")

    def intersect(self, other: mn.Mobject, reverse=True):
        if reverse and isinstance(other, EMObject):
            return other.intersect(self, False)
        raise NotImplementedError(f"{self.__class__.__name__}-{other.__class__.__name__} Intersection is Undefined")

    def init_label(self, label: str, *args, **extra_args):
        from . import T
        if label:
            return T.Label(label, self, *args, **extra_args)

    @freezable
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
        return self

    def interpolate(
            self,
            mobject1: EMObject,
            mobject2: EMObject,
            alpha: float,
            path_func: Callable[[np.ndarray, np.ndarray, float], np.ndarray] = mn.straight_path
    ) -> Self:
        if self.get_label() and hasattr(self.e_label, 'direction') and not callable(self.e_label.direction):
            l0 = self.e_label
            l1 = mobject1.e_label
            l2 = mobject2.e_label
            curr_pos = l0.ref.e_label_point(l1.direction)
            start_pos = l1.ref.e_label_point(l1.direction)
            end_pos = l2.ref.e_label_point(l2.direction)
            self.e_label.direction = path_func(start_pos + l1.direction, end_pos + l2.direction, alpha) - curr_pos
        return super().interpolate(mobject1, mobject2, alpha, path_func)

    @freezable
    def rotate(
            self,
            angle: float,
            axis: Vect3 = OUT,
            about_point: Vect3 | None = None,
            **kwargs
    ) -> Self:
        if self.get_label() and hasattr(self.get_label(), 'direction') and not callable(self.e_label.direction):
            self.e_label.direction = mn.rotate_vector(self.e_label.direction, angle)
        return super().rotate(angle, axis, about_point, **kwargs)

    def debug(self, dd=True):
        self._debug = dd

    def generate_target(self, use_deepcopy: bool = False) -> Self:
        trgt = super().generate_target(use_deepcopy)
        if trgt.get_label() is not None:
            trgt.e_label = trgt.e_label.generate_target()
        return trgt

    @freezable
    def e_remove(self):
        if not self.Virtual and self.visible():
            anims = self.RemovalOf()
            self.undraw_label()
            if anims:
                self.scene.play(*anims, run_time=self.CONSTRUCTION_TIME)
        else:
            self.scene.remove(self)
        return self

    @freezable
    def e_delete(self):
        self.scene.remove(self)
        if self.e_label:
            self.scene.remove(self.e_label)
        return self

    def copy(self, deep: bool = False) -> Self:
        cpy = super().copy(deep)
        if self.get_label() and self.e_label:
            cpy.e_label = self.e_label.copy()
        return cpy

    def get_label(self):
        if hasattr(self, 'e_label'):
            return self.e_label

    def freeze(self):
        self._freeze = True

    def unfreeze(self):
        self._freeze = False

    @property
    def is_frozen(self):
        return self._freeze

    @contextmanager
    def as_frozen(self):
        self.freeze()
        yield
        self.unfreeze()



    def __getstate__(self):
        state = super().__getstate__().copy()
        if 'scene' in state:
            del state['scene']
        if 'shader_wrapper' in state:
            del state['shader_wrapper']
        return state

    def __setstate__(self, state):
        self.__dict__.update(state)
        self.scene = find_scene()
        self.shader_wrapper = None

    def __init__(self,
                 *args,
                 stroke_width: float = 2,
                 animate_part=None,
                 delay_anim=False,
                 skip_anim=False,
                 scene: ps.PropScene = None,
                 debug=False,
                 label_args: Tuple[str, ...] | str | None = None,
                 label: Tuple[str, ...] | str | None = None,
                 **kwargs):
        label_args = label_args or label
        self._debug = debug
        self._freeze = False
        scene = scene or find_scene()
        if scene is None:
            raise Exception("Could Not Find Scene Object")
        self.animate_part = ['set_stroke'] if animate_part is None else animate_part
        self.old_fill_opacity = 0.0
        self.scene = scene
        self.animation_objects: List[mn.Mobject] = []
        kwargs['stroke_width'] = stroke_width

        if self.Virtual:
            kwargs['stroke_opacity'] = 0.5 if self.scene.debug else 0.0
            kwargs['stroke_width'] = 2 * stroke_width
            kwargs['stroke_color'] = mn.RED

        super().__init__(*args, **kwargs)
        self.e_label = None
        if label_args:
            if isinstance(label_args, str):
                string = label_args
                label_args = ()
            else:
                string, *label_args = label_args

            if label_args and isinstance(label_args[-1], dict):
                *label_args, l_kwargs = label_args
            else:
                l_kwargs = {}
            self.e_label = self.init_label(string, *label_args, **l_kwargs)

        if not delay_anim:
            self.e_draw(skip_anim)
