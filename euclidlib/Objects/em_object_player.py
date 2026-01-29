from euclidlib.Objects.em_object_base import *

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
    For a manim object to be animated, there are specific animators that are needed (ex. Write(TextObj)

    * this class manages the 'players' that animate the objects
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
        return f"EMObjectPlayer obj={str(self.eobj)}"

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
    # defines the properties of
    # ----------------------------------------------------------------------------------------------------------------
    @property
    def e_fade(self):
        self.main_animate = self.label_animate = True
        for method in self.o_animate_part:
            getattr(self.anim, method)(opacity=self.eobj.fade_opacity)
        for method in self.l_animate_part:
            getattr(self.label_anim, method)(opacity=0.0)
        return self

    @property
    def e_normal(self):
        print("inside e_normal")
        self.main_animate = self.label_animate = True
        for method in self.o_animate_part:
            getattr(self.anim, method)(opacity=1.0)
            print(f"... calling {method}")
        for method in self.l_animate_part:
            getattr(self.label_anim, method)(opacity=1.0)
            print(f"... calling {method}")
        return self

    def _e_color(self, color: mn.Color):
        print(f"EMObjectPlayer._e_color({self}, {color}")
        self.main_animate = True
        print("Set main_animate to true")
        self.e_normal.anim.set_color(color=color)
        print("Color has been set")
        print()
        return self

    @property
    def green(self):
        print("EMObjectPlayer.green", self)
        return self._e_color(mn.GREEN)

    @property
    def blue(self):
        print("EMObjectPlayer.blue", self)
        return self._e_color(mn.BLUE)

    @property
    def red(self):
        print("EMObjectPlayer.red", self)
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
        self.eobj.scene.play(mn.Indicate(self.eobj, color=mn.RED, scale_factor=1.5, run_time=10))
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

        anim_built = e_animate(anim(**kwargs))
        return anim_built

    def __call__(self, *args, **kwargs):
        print(f"***** EMobjectPlayer {self} is being called as a function")
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

