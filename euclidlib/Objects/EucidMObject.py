from __future__ import annotations
from functools import partial
import manimlib as mn
import euclidlib.Propositions.PropScene as ps
from manimlib.constants import *

DEFAULT_FADE_OPACITY = 0.15
DEFAULT_CONSTRUCTION_RUNTIME = 0.5
DEFAULT_TRANSFORM_RUNTIME = 0.25

def to_manim_coord(x, y):
    return (
        (x - 700) * (8.0 * 16 / 1400 / 9),
        (400 - y) * (8.0 / 800),
        0
    )

def to_manim_h_scale(x):
    return x * (8.0 * 16 / 1400 / 9)

def to_manim_v_scale(x):
    return x * (8.0 / 800)


class Label(mn.Text):
    def CreationOf(self, *args, **kwargs):
        kwargs['run_time'] = self.ref.CONSTRUCTION_TIME
        return [mn.Write(self, *args, **kwargs)]

    def __init__(self, *args, ref: EMObject, direction: mn.Vect3, **kwargs):
        super().__init__(*args, font_size=20, **kwargs)
        self.ref = ref
        self.always.next_to(ref.e_label_point(direction), direction, ref.LabelBuff)


class NullAnimationBuilder:
    def __getattr__(self, item):
        return self
    def __call__(self, *args, **kwargs):
        return self


class EMObjectPlayer:
    def __init__(self, eobj: EMObject):
        self.eobj = eobj
        self.anim = eobj.animate
        self.label_anim = eobj.e_label.animate if eobj.e_label is not None else NullAnimationBuilder()
        self.fade_out_flag = False
        self.fade_in_flag = False

    @property
    def e_fade(self):
        self.anim.set_stroke(opacity=DEFAULT_FADE_OPACITY)
        self.label_anim.set_stroke(opacity=0.0).set_fill(opacity=0.0)
        return self

    @property
    def e_normal(self):
        self.anim.set_stroke(opacity=1)
        self.label_anim.set_stroke(opacity=1).set_fill(opacity=1)
        return self

    @property
    def e_remove(self):
        self.fade_out_flag = True
        return self

    @property
    def e_draw(self):
        self.fade_in_flag = True
        return self

    def e_color(self, color: mn.Color):
        self.fade_in_flag = True
        self.e_normal.anim.set_color(color=color)
        return self

    @property
    def green(self):
        return self.e_color(mn.GREEN)

    @property
    def blue(self):
        return self.e_color(mn.BLUE)

    @property
    def red(self):
        return self.e_color(mn.RED)

    @property
    def lift(self):
        self.eobj.scene.add(self.eobj)
        return self

    def _build_anim(self, anim, obj: mn.VMobject, **kwargs):
        if obj is None:
            return None
        if 'run_time' not in kwargs:
            kwargs['run_time'] = DEFAULT_TRANSFORM_RUNTIME
        anim_built = anim(**kwargs).build()
        if self.fade_in_flag and not self.eobj.in_scene():
            obj.become(obj.target)
            anim_built = mn.FadeIn(obj, **kwargs)
        elif self.fade_out_flag and self.eobj.in_scene():
            anim_built = mn.FadeOut(obj, **kwargs)
        return anim_built

    def __call__(self, *args, **kwargs):
        anim_built = self._build_anim(self.anim, self.eobj, **kwargs)
        label_built = self._build_anim(self.label_anim, self.eobj.e_label, **kwargs)
        if label_built is not None:
            self.eobj.scene.play(anim_built, label_built)
        else:
            self.eobj.scene.play(anim_built)
        return self.eobj


class EMObject(mn.VMobject):
    LabelBuff = mn.MED_SMALL_BUFF
    CONSTRUCTION_TIME = 1

    @property
    def AUX_CONSTRUCTION_TIME(self):
        return self.CONSTRUCTION_TIME/2

    Virtual = False

    def CreationOf(self, *args, **kwargs):
        return [mn.ShowCreation(self, *args, **kwargs, run_time=self.CONSTRUCTION_TIME)]

    def in_scene(self):
        return self in self.scene.mobjects

    if TYPE_CHECKING:
        blue: EMObjectPlayer
        green: EMObjectPlayer
        red: EMObjectPlayer
        e_fade: EMObjectPlayer
        e_normal: EMObjectPlayer
        e_draw: EMObjectPlayer
        e_remove: EMObjectPlayer

    for name in filter(lambda a: not a.startswith('_'), dir(EMObjectPlayer)):
        exec(f'''
@property
def {name}(self):
    return EMObjectPlayer(self).{name}
        '''.strip())

    def add_label(self, label: str, label_dir: mn.Vect3):
        new_label = Label(label, ref=self, direction=label_dir)
        if self.e_label is not None:
            self.scene.play(mn.TransformMatchingStrings(self.e_label, new_label, run_time=0.5))
        else:
            self.scene.play(*new_label.CreationOf())
        self.e_label = new_label

    def remove_label(self):
        self.scene.play(mn.FadeOut(self.e_label))
        self.e_label = None

    def e_label_point(self, direction: mn.Vect3):
        raise NotImplementedError()

    def intersect(self, other: EMObject):
        raise NotImplementedError()

    def __init__(self, *args, scene: ps.PropScene, label: str = None, label_dir: mn.Vect3 = None, stroke_width: float = 2, **kwargs):
        self.old_fill_opacity = 0.0
        self.scene = scene
        self.animation_objects: List[mn.Mobject] = []
        kwargs['stroke_width'] = stroke_width

        if self.Virtual:
            kwargs['stroke_opacity'] = 0
            kwargs['stroke_color'] = mn.RED

        super().__init__(*args, **kwargs)
        self.e_label = Label(label, ref=self, direction=label_dir) if label else None
        if not self.Virtual:
            anims = [
                anim
                for x in (self, self.e_label)
                if x is not None
                for anim in x.CreationOf()
            ]
            if anims:
                scene.play(*anims)
            if self.animation_objects:
                for obj in self.animation_objects:
                    obj.clear_updaters()
                scene.play(*map(partial(mn.Uncreate, run_time=self.AUX_CONSTRUCTION_TIME), self.animation_objects))
        else:
            self.scene.add(self)
