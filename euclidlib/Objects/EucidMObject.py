from __future__ import annotations
from functools import partial
from manimlib import *
import euclidlib.Propositions.PropScene as ps


class Label(Text):
    def CreationOf(self, *args, **kwargs):
        return [Write(self, *args, **kwargs)]

    def __init__(self, *args, ref: EMObject, direction: Vect3, **kwargs):
        super().__init__(*args, font_size=20, **kwargs)
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
        self.anim.set_stroke(opacity=0.15)
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

    def e_color(self, color: Color):
        self.fade_in_flag = True
        self.e_normal.anim.set_color(color=color)
        return self

    @property
    def green(self):
        return self.e_color(GREEN)

    @property
    def blue(self):
        return self.e_color(BLUE)

    @property
    def red(self):
        return self.e_color(RED)

    def _build_anim(self, anim, **kwargs):
        kwargs['run_time'] = kwargs.get('run_time', 1.0) * 0.5
        anim_built = anim(**kwargs).build()
        if self.fade_in_flag and not self.eobj.in_scene():
            anim_built = FadeTransform(self.eobj, self.eobj.target, **kwargs)
        if self.fade_out_flag and self.eobj.in_scene():
            anim_built = FadeOut(self.eobj, **kwargs)
        return anim_built

    def __call__(self, *args, **kwargs):
        anim_built = self._build_anim(self.anim, **kwargs)
        label_built = self._build_anim(self.label_anim, **kwargs) if not isinstance(self.label_anim,
                                                                              NullAnimationBuilder) else None
        if label_built is not None:
            self.eobj.scene.play(anim_built, label_built)
        else:
            self.eobj.scene.play(anim_built)
        return self.eobj


class EMObject(VMobject):
    LabelBuff = MED_SMALL_BUFF
    Virtual = False

    def CreationOf(self, *args, **kwargs):
        return [ShowCreation(self, *args, **kwargs)]

    def in_scene(self):
        return self in self.scene.mobjects

    if TYPE_CHECKING:
        blue: EMObjectPlayer
        green: EMObjectPlayer
        redd: EMObjectPlayer
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

    def add_label(self, label: str, label_dir: Vect3):
        new_label = Label(label, ref=self, direction=label_dir)
        if self.e_label is not None:
            self.scene.play(TransformMatchingStrings(self.e_label, new_label, run_time=0.5))
        else:
            self.scene.play(*new_label.CreationOf())
        self.e_label = new_label

    def e_label_point(self, direction: Vect3):
        raise NotImplementedError()

    def intersect(self, other: EMObject):
        raise NotImplementedError()

    def __init__(self, *args, scene: ps.PropScene, label: str = None, label_dir: Vect3 = None, stroke_width: float = 2, **kwargs):
        self.old_fill_opacity = 0.0
        self.scene = scene
        self.animation_objects: List[Mobject] = []
        self.e_removed = False
        kwargs['stroke_width'] = stroke_width

        if self.Virtual:
            kwargs['stroke_opacity'] = 0
            kwargs['stroke_color'] = RED

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
                scene.play(*map(partial(Uncreate, run_time=0.5), self.animation_objects))
        else:
            self.scene.add(self)
