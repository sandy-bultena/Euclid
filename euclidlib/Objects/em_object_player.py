import numpy as np
from euclidlib.Objects.em_object_base import *
from euclidlib.Objects.CustomAnimation import e_animate, Indicate


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

    # ----------------------------------------------------------------------------------------------------------------
    # fade in or return to normal
    # ----------------------------------------------------------------------------------------------------------------
    def e_fade(self, *args, **kwargs)->EMObject:
        self.main_animate = self.label_animate = True
        for method in self.o_animate_part:
            getattr(self.anim, method)(opacity=self.eobj.fade_opacity)
        for method in self.l_animate_part:
            getattr(self.label_anim, method)(opacity=0.0)
        return self._play_animation(*args, **kwargs)

    def e_normal(self, *args, **kwargs)->EMObject:
        self.main_animate = self.label_animate = True
        for method in self.o_animate_part:
            getattr(self.anim, method)(opacity=1.0)
        for method in self.l_animate_part:
            getattr(self.label_anim, method)(opacity=1.0)
        return self._play_animation(*args, **kwargs)

    # ----------------------------------------------------------------------------------------------------------------
    # colours
    # ----------------------------------------------------------------------------------------------------------------
    def _e_color(self, color: mn.Color, *args, **kwargs)->EMObject:
        self.main_animate = True
        with (self.eobj.scene.simultaneous()):
            self.e_normal()
            self.anim.set_color(color=color)
        return self._play_animation(*args, **kwargs)

    def green(self, *args, **kwargs)->EMObject:
        return self._e_color(mn.GREEN)

    def blue(self, *args, **kwargs)->EMObject:
        return self._e_color(mn.BLUE)

    def red(self, *args, **kwargs)->EMObject:
        return self._e_color(mn.RED)

    def white(self, *args, **kwargs)->EMObject:
        return self._e_color(mn.WHITE)

    def grey(self, *args, **kwargs)->EMObject:
        return self._e_color(mn.GREY)

    # ----------------------------------------------------------------------------------------------------------------
    # bring object to top
    # ----------------------------------------------------------------------------------------------------------------
    def lift(self, *args, **kwargs)->EMObject:
        if self.eobj.visible():
            self.eobj.scene.add(self.eobj)
        return self._play_animation(*args, **kwargs)

    # ----------------------------------------------------------------------------------------------------------------
    # make the object temporarily noticeable
    # ----------------------------------------------------------------------------------------------------------------
    def notice(self, *args, **kwargs)->EMObject:
        self.eobj.scene.play(Indicate(self.eobj, color=mn.RED, scale_factor=1.5, run_time=10))
        return self.eobj

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
        self.anim.to_to_corner(corner, buff)
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
            kwargs['run_time'] = mn.DEFAULT_TRANSFORM_RUNTIME

        if self.rotating:
            kwargs['path_arc'] = self.rotating

        anim_built = e_animate(anim(**kwargs))
        return anim_built

    # ----------------------------------------------------------------------------------------------------------------
    # animations have been build, play the animations
    # ----------------------------------------------------------------------------------------------------------------
    def _play_animation(self, *args, **kwargs):
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

