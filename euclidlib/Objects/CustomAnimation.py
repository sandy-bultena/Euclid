from functools import cache

import manimlib as mn
from manimlib import Scene
from typing import Callable

from . import EucidMObject as E

class UncreatePreserve(mn.Uncreate):
    def __init__(self, obj: mn.Mobject, *args, **kwargs):
        super().__init__(obj, *args, **kwargs)
        obj.save_state()

    def clean_up_from_scene(self, scene: mn.Scene):
        super().clean_up_from_scene(scene)
        self.mobject.pointwise_become_partial(self.starting_mobject, 0, 1)


class EuclidAnimation(mn.Animation):
    mobject: 'E.EMObject'
    def __init__(self, obj: 'E.EMObject', *args, **kwargs):
        assert(isinstance(obj, E.EMObject))
        super().__init__(obj, *args, **kwargs)

    def begin(self) -> None:
        super().begin()
        if self.mobject.e_label:
            self.mobject.e_label.enable_updaters()

    def clean_up_from_scene(self, scene: Scene) -> None:
        if self.mobject.e_label:
            self.mobject.e_label.disable_updaters()



class AppendString(mn.TransformMatchingStrings):
    @staticmethod
    def transform_fade_in(anim: mn.Animation):
        if not isinstance(anim, mn.FadeInFromPoint):
            return anim
        return mn.Write(anim.mobject, run_time=anim.run_time)

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.anims = list(map(self.transform_fade_in, self.anims))
        self.animations = list(map(mn.prepare_animation, self.anims))
        self.build_animations_with_timings(0)



class MoveToAndReplace(mn.MoveToTarget):
    def __init__(self, source: mn.Mobject, target: mn.Mobject, **kwargs):
        self.source = source
        self.true_target = target
        source.generate_target().move_to(target)
        super().__init__(source, **kwargs)

    def clean_up_from_scene(self, scene: Scene) -> None:
        super().clean_up_from_scene(scene)
        scene.remove(self.source)
        scene.add(self.true_target)


class EShowCreation(mn.ShowCreation, EuclidAnimation):
    pass


class E_MethodAnimation(mn.MoveToTarget, EuclidAnimation):
    def __init__(self, mobject: mn.Mobject, methods: list[Callable], **kwargs):
        self.methods = methods
        super().__init__(mobject, **kwargs)


class UnWrite(mn.Write):
    def __init__(
            self,
            obj: mn.VMobject,
            *args,
            rate_func=mn.linear,
            remover=True,
            **kwargs
    ):
        super().__init__(obj, *args, **kwargs, remover=remover, rate_func=lambda a: rate_func(1 - a))
        obj.save_state()

    def clean_up_from_scene(self, scene: mn.Scene):
        super().clean_up_from_scene(scene)
        self.mobject.restore()

    def get_sub_alpha(
            self,
            alpha: float,
            index: int,
            num_submobjects: int
    ) -> float:
        return super().get_sub_alpha(alpha, num_submobjects - index - 1, num_submobjects)


class WriteUnWrite(mn.AnimationGroup):
    def __init__(self, source, target, **kwargs):
        super().__init__(UnWrite(source), mn.Write(target), **kwargs)
