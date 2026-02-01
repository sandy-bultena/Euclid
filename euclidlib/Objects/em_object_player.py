from __future__ import annotations
import numpy as np
import manimlib as mn
from typing import TYPE_CHECKING
from euclidlib.Objects.CustomAnimation import e_animate, Indicate
if TYPE_CHECKING:
    from euclidlib.Objects.em_object_base import *

DEFAULT_TRANSFORM_RUNTIME = 0.25


# =====================================================================================================================
# NullAnimationBuilder
# example:
#    a=NullAnimationBuilder()
#    a.any_method -> return self
#    a()          -> returns self
# =====================================================================================================================
class NullAnimationBuilder:
    def __getattr__(self, item):
        return self

    def __call__(self, *args, **kwargs):
        return self


# =====================================================================================================================
# NullPlayer
# =====================================================================================================================
class NullPlayer:
    def __init__(self, obj):
        self.obj = obj

    def __getattr__(self, item):
        return self

    def __call__(self, *args, **kwargs):
        return self.obj


# =====================================================================================================================
# EMObjectPlayer
# - methods to pass into 'play' ??
# =====================================================================================================================
class EMObjectPlayer:
    """
    To create a player animation based on the current state of the EMObject
    """

    def __init__(self, eobj: EMObject):
        """
        :param eobj: the object that needs a player for animation
        """
        self.eobj = eobj
        self.rotating = False
        self._fade_opacity = eobj.fade_opacity

        # create the anim properties
        # ... read about manimgl 'animate' usage for further info
        if eobj.is_frozen:
            self.anim = NullAnimationBuilder()
        else:
            self.anim = eobj.animate

        # if the object has no label, or either obj or label is frozen, set anim properties
        if eobj.is_frozen or eobj.e_label is None or eobj.e_label.is_frozen:
            self.label_anim = NullAnimationBuilder()
        else:
            self.label_anim = eobj.e_label.animate

        # what parts to animate (fill and/or stroke for example)
        self.o_animate_part: list[str] = eobj.animate_part
        self.l_animate_part: list[str] = eobj.e_label.animate_part if eobj.e_label is not None else []

        # ??
        self.main_animate = False
        self.label_animate = False

        self.rotation = []

    def __str__(self):
        return f"EMObjectPlayer obj=<{str(self.eobj)}>"

    # ----------------------------------------------------------------------------------------------------------------
    # class methods (to find all properties and methods)
    # ----------------------------------------------------------------------------------------------------------------
    @classmethod
    def get_properties(cls):
        for name, val in cls.__dict__.items():
            if name.startswith('_'):
                continue
            if isinstance(val, property):
                yield name

    @classmethod
    def get_methods(cls):
        for name, val in cls.__dict__.items():
            if name.startswith('_'):
                continue
            if isinstance(val, property):
                continue
            if callable(val):
                yield name

    # ----------------------------------------------------------------------------------------------------------------
    # explanation
    # ----------------------------------------------------------------------------------------------------------------
    # for these animations to work,
    # 1. first they set up the animation by calling a property or a method, which returns an EMObjectPlayer.
    # 2. then this EMObjectPlayer must be called as a function (because manim does this internally, we have to mimic it)
    #
    # Example - using one of the 'properties':
    #     obj = some_em_object
    #     obj.some_property()
    #          - EMObject method calls the appropriate EMObjectPlayer.some_property function
    #          - which returns an EMObjectPlayer
    #          - which in turn calls method __call__ on the EMObjectPlayer
    #
    #     equivalent to:
    #     obj = some_em_object
    #     player = EMObjectPlayer(obj)      <- create a player object for this obj
    #     player = player.some_property     <- sets up the animation changes
    #     player()                          <- animates and returns the original object
    #
    # Example - using one of the 'methods' - Notice you call e_to_corner(), and then call the player
    #           as a function to get it to display
    #        line = ELine([2,0,0],[0,2,0],label_args=('a', mn.UP, {'alpha':0.3}))
    #        line.e_to_corner(mn.UR)(run_time=2)
    #
    # ----------------------------------------------------------------------------------------------------------------
    # fade in or return to normal
    # ----------------------------------------------------------------------------------------------------------------
    @property
    def e_fade(self):
        self.main_animate = self.label_animate = True
        for method in self.o_animate_part:
            getattr(self.anim, method)(opacity=self._fade_opacity)
        for method in self.l_animate_part:
            getattr(self.label_anim, method)(opacity=0.0)
        return self

    @property
    def e_normal(self):
        self.main_animate = self.label_animate = True
        for method in self.o_animate_part:
            getattr(self.anim, method)(opacity=1.0)
        for method in self.l_animate_part:
            getattr(self.label_anim, method)(opacity=1.0)
        return self

    # ----------------------------------------------------------------------------------------------------------------
    # colours
    # ----------------------------------------------------------------------------------------------------------------
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

    # ----------------------------------------------------------------------------------------------------------------
    # bring object to top
    # ----------------------------------------------------------------------------------------------------------------
    @property
    def lift(self):
        if self.eobj.visible():
            self.eobj.scene.add(self.eobj)
        return self

    # ----------------------------------------------------------------------------------------------------------------
    # make the object temporarily noticeable
    # ----------------------------------------------------------------------------------------------------------------
    @property
    def notice(self):
        self.eobj.scene.play(Indicate(self.eobj, color=mn.RED, scale_factor=1.5, run_time=10))
        return self

    # ----------------------------------------------------------------------------------------------------------------
    # move objects
    # ----------------------------------------------------------------------------------------------------------------
    def e_move_to(self,
                  point_or_mobject: mn.Mobject | mn.Vect3,
                  aligned_edge: mn.Vect3 = mn.ORIGIN,
                  coor_mask: mn.Vect3 = np.array([1, 1, 1])):
        self.main_animate = True
        self.anim.move_to(point_or_mobject, aligned_edge, coor_mask)
        return self

    def e_move(self, vector: mn.Vect3):
        self.main_animate = True
        self.anim.shift(vector)
        return self

    def e_to_edge(self,
                  edge: mn.Vect3 = mn.LEFT,
                  buff: float = mn.DEFAULT_MOBJECT_TO_EDGE_BUFFER):
        self.main_animate = True
        self.anim.to_edge(edge, buff)
        return self

    def e_to_corner(self,
                    corner: mn.Vect3 = mn.DL,
                    buff: float = mn.DEFAULT_MOBJECT_TO_EDGE_BUFFER):
        self.main_animate = True
        self.anim.to_corner(corner, buff)
        return self

    def e_rotate(self, about: mn.Vect3, angle: float):
        self.main_animate = True
        self.anim.rotate(angle, about_point=about)
        self.rotating = angle
        return self

    # ----------------------------------------------------------------------------------------------------------------
    # scale the object
    # ----------------------------------------------------------------------------------------------------------------
    def e_scale(self,
                scale: float,
                min_scale_factor: float = 1e-8,
                about_point: mn.Vect3 | None = None,
                about_edge: mn.Vect3 = mn.ORIGIN):
        self.main_animate = True
        self.anim.scale(scale, min_scale_factor, about_point, about_edge)
        return self

    # ----------------------------------------------------------------------------------------------------------------
    # build up all the animation from methods etc
    # ----------------------------------------------------------------------------------------------------------------
    def _build_anim(self, anim, obj: mn.VMobject, flag, **kwargs):
        if obj is None or not flag:
            return None
        if isinstance(anim, NullAnimationBuilder):
            return None
        if 'run_time' not in kwargs:
            kwargs['run_time'] = DEFAULT_TRANSFORM_RUNTIME

        if self.rotating:
            kwargs['path_arc'] = self.rotating

        anim_built = e_animate(anim(**kwargs))
        return anim_built

    # ----------------------------------------------------------------------------------------------------------------
    # animations have been build, play the animations
    # NOTE: this overrides the build in manim __call__, so it cannot become anything other than it is
    # ----------------------------------------------------------------------------------------------------------------
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


