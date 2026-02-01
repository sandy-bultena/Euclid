from functools import cache

import manimlib as mn
from manimlib import Scene
from typing import Callable

from . import em_object_base as E

@cache
def EAnimationOf(anim_type: type):
    return type(f'E_{anim_type.__name__}', (anim_type, EuclidAnimation), {})


# ====================================================================================================================
# class UncreatePreserve
# ====================================================================================================================
class UncreatePreserve(mn.Uncreate):
    """remove from scene but save the object state (I think??)"""
    def __init__(self, obj: mn.Mobject, *args, **kwargs):
        super().__init__(obj, *args, **kwargs)
        obj.save_state()

    def clean_up_from_scene(self, scene: mn.Scene):
        super().clean_up_from_scene(scene)
        self.mobject.pointwise_become_partial(self.starting_mobject, 0, 1)

# ---------------------------------------------------------------------------------------------------------------------
# get the animation methods
# ---------------------------------------------------------------------------------------------------------------------
def e_animate(anim):
    """
    for the specific object that can be animated, find the animation methods for that object
    :param anim: Mobject
    :return: methods ??
    """
    if anim.overridden_animation:
        return anim.overridden_animation
    return E_MethodAnimation(anim.mobject, anim.methods, **anim.anim_args)


# ====================================================================================================================
# class: Euclid Animation
# ====================================================================================================================
class EuclidAnimation(mn.Animation):
    """standard manim animation, plus handling labels and dashes"""

    mobject: 'E.EMObject'

    def __init__(self, mobject: 'E.EMObject', *args, **kwargs):
        """
        :param mobject: Mobject,
        :param run_time:
        :param time_span:  # Tuple of times, between which the animation will run
        :param lag_ratio: If 0=> animate all submobjects simultaneously, 1=> successively, 0 < lag_ratio < 1 => its applied to each with lagged start times
        :param rate_func: Callable[[float], float] = smooth,
        :param name: str = "",
        :param remover: bool = False, (Does this animation add or remove a mobject form the screen
        :param final_alpha_value: float = 1.0, # What to enter into the update function upon completion
        """
        assert(isinstance(mobject, E.EMObject))
        super().__init__(mobject, *args, **kwargs)

    def __str__(self):
        return f"{type(self).__name__}"

    # ----------------------------------------------------------------------------------------------------------------
    # begin
    #   This is called right as an animation is being played.  As much initialization as possible,
    #   especially any mobject copying, should live in this method
    # ----------------------------------------------------------------------------------------------------------------
    def begin(self) -> None:
        super().begin()

        # enable all the updaters for dashes and labels
        if self.mobject.e_label:
            self.mobject.e_label.enable_updaters()
        if hasattr(self.mobject, 'dash_ref') and self.mobject.dash_ref is not None:
            self.mobject.dash_ref.enable_updaters()

    # ----------------------------------------------------------------------------------------------------------------
    # clean up after the animation
    # ----------------------------------------------------------------------------------------------------------------
    def clean_up_from_scene(self, scene: Scene) -> None:

        # question - should we call super() ???
        # disable all the updaters for dashes and labels
        if self.mobject.e_label:
            self.mobject.e_label.disable_updaters()
        if hasattr(self.mobject, 'dash_ref') and self.mobject.dash_ref is not None:
            self.mobject.dash_ref.disable_updaters()


# ====================================================================================================================
# class: Indicate
# ====================================================================================================================
class Indicate(mn.Transform):
    """bring users eye to object by changing colour and growing in size a bit"""

    mobject: mn.VMobject

    # ----------------------------------------------------------------------------------------------------------------
    # initialization
    # ----------------------------------------------------------------------------------------------------------------
    def __init__(
        self,
        mobject: mn.VMobject,
        scale_factor: float = 1.2,
        color = mn.YELLOW,
        rate_func: Callable[[float], float] = mn.there_and_back,
        **kwargs
    ):
        self.scale_factor = scale_factor
        self.color = color
        super().__init__(mobject, rate_func=rate_func, **kwargs)

    # ----------------------------------------------------------------------------------------------------------------
    # this is what we want the object to look like when it is indicated (called by super class)
    # ----------------------------------------------------------------------------------------------------------------
    def create_target(self) -> mn.VMobject:
        target = self.mobject.copy()
        target.set_stroke(width=self.scale_factor*target.get_stroke_width())
        target.set_color(self.color)
        return target


# ====================================================================================================================
# class: AppendString
# ====================================================================================================================
class AppendString(mn.TransformMatchingStrings):

    # ----------------------------------------------------------------------------------------------------------------
    # initialization
    # ----------------------------------------------------------------------------------------------------------------
    def __init__(self, *args, **kwargs):
        """
        :param source: StringMobject,
        :param target: StringMobject,
        :param matched_keys: Iterable[str] = [],
        :param key_map: dict[str, str] = dict(),
        :param matched_pairs: Iterable[tuple[VMobject, VMobject]] = [],
        """
        super().__init__(*args, **kwargs)
        # manim will create a list of 'anims' between the source and the target

        self.anims = list(map(self.transform_fade_in, self.anims))
        self.animations = list(map(mn.prepare_animation, self.anims))
        self.build_animations_with_timings(0)

    # ----------------------------------------------------------------------------------------------------------------
    # transform the animations so that if it is not fading in from a point, then write the text as animation
    # ----------------------------------------------------------------------------------------------------------------
    @staticmethod
    def transform_fade_in(anim: mn.Animation):
        if not isinstance(anim, mn.FadeInFromPoint):
            return anim
        return mn.Write(anim.mobject, run_time=anim.run_time)


# ====================================================================================================================
# class: Move To And Replace
# ====================================================================================================================
class MoveToAndReplace(mn.MoveToTarget):

    # ----------------------------------------------------------------------------------------------------------------
    # initialization
    # ----------------------------------------------------------------------------------------------------------------
    def __init__(self, source: mn.Mobject, target: mn.Mobject, **kwargs):
        self.source = source
        self.true_target = target
        source.generate_target().move_to(target)
        super().__init__(source, **kwargs)

    # ----------------------------------------------------------------------------------------------------------------
    # after animation, remove source, and add target to scene
    # ----------------------------------------------------------------------------------------------------------------
    def clean_up_from_scene(self, scene: Scene) -> None:
        super().clean_up_from_scene(scene)
        scene.remove(self.source)
        scene.add(self.true_target)


# ====================================================================================================================
# class: EShowCreation
# ====================================================================================================================
class EShowCreation(mn.ShowCreation, EuclidAnimation):
    """Shows the creation of the object, and additional any labels or dashes"""
    pass


# ====================================================================================================================
# class: Euclid Method Animation
# ====================================================================================================================
class E_MethodAnimation(mn.MoveToTarget, EuclidAnimation):
    def __init__(self, mobject: mn.Mobject, methods: list[Callable], **kwargs):
        """
        :param mobject: object to animate
        :param methods: used to apply existing Mobject methods (like shift, scale, rotate) as an animation
        """
        self.methods = methods
        super().__init__(mobject, **kwargs)


# ====================================================================================================================
# class: UnWrite
# ====================================================================================================================
class UnWrite(mn.Write):
    """removes text from the scene"""
    # Not sure what the saving state and restore are doing

    # ----------------------------------------------------------------------------------------------------------------
    # initialization
    # ----------------------------------------------------------------------------------------------------------------
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

    # ----------------------------------------------------------------------------------------------------------------
    # clean up from scene, not sure how this is different than the 'super().clean_up_from_scene'
    # ----------------------------------------------------------------------------------------------------------------
    def clean_up_from_scene(self, scene: mn.Scene):
        super().clean_up_from_scene(scene)
        self.mobject.restore()

    # - seems to be just be calling the super anyways, except that it is modifying the index.  Why
    #   calculate the specific, adjusted progress
    def get_sub_alpha(
            self,
            alpha: float,
            index: int,
            num_submobjects: int
    ) -> float:
        return super().get_sub_alpha(alpha, num_submobjects - index - 1, num_submobjects)


# # ====================================================================================================================
# # class: Write UnWrite
# # ====================================================================================================================
# class WriteUnWrite(mn.AnimationGroup):
#     def __init__(self, source, target, **kwargs):
#         super().__init__(UnWrite(source), mn.Write(target), **kwargs)
