from __future__ import annotations

from typing import Optional, Self, Type, Iterable, Union, TYPE_CHECKING, Callable
from contextlib import contextmanager
import manimlib as mn
import numpy as np

# local imports
from euclidlib.Utilities.find_scene import find_scene
import euclidlib.Objects.CustomAnimation as custom_anim
from euclidlib.Objects.em_object_decorators import freezable, freezable_player
from euclidlib.Objects.CustomAnimation import EuclidAnimation
from euclidlib.Objects.em_object_player import EMObjectPlayer

if TYPE_CHECKING:
    import euclidlib.Objects.Text as Text

# global constants
DEFAULT_FADE_OPACITY = 0.15
DEFAULT_TEXT_FADE_OPACITY = 0.30

# =====================================================================================================================
# EMObject
# =====================================================================================================================

class EMObject(mn.VMobject):
    LabelBuff = mn.MED_SMALL_BUFF
    CONSTRUCTION_TIME = 1

    @property
    def AUX_CONSTRUCTION_TIME(self):
        return self.CONSTRUCTION_TIME / 2

    Virtual = False

    # -----------------------------------------------------------------------------------------------------------------
    # initialize
    # -----------------------------------------------------------------------------------------------------------------
    def __init__(self,
                 *args,
                 stroke_width: float = 2,
                 animate_part=None,
                 delay_anim=False,
                 skip_anim=False,
                 debug=False,
                 scene = None,
                 label_args: tuple[str, ...] | str | None = None,
                 label: tuple[str, ...] | str | None = None,
                 **kwargs):
        """
        :param args: generic arguments
        :param stroke_width: width of the outline of the object
        :param animate_part: what methods do we want to animate (default: ['set_stroke', 'set_e_fill'])
        :param delay_anim: do animation later
        :param skip_anim: skip animation altogether
        :param debug: print extra info if debug
        :param label_args: labels with options
        :param label: same as above
        :param kwargs: extra stuff to pass to manim
        """

        # can't do anything unless we have a scene object to draw to

        if scene is None:
            scene = find_scene()
            if scene is None:
                raise Exception("Could Not Find Scene Object")
        self.scene = scene

        # set stroke width accordingly
        kwargs['stroke_width'] = stroke_width
        if self.Virtual:
            kwargs['stroke_opacity'] = 0.5 if self.scene.debug else 0.0
            kwargs['stroke_width'] = 2 * stroke_width
            kwargs['stroke_color'] = mn.RED

        # setup some default parameters
        self._debug = debug
        self._freeze = False
        self.animate_part = ['set_stroke', 'set_e_fill'] if animate_part is None else animate_part
        self.animation_objects: list[mn.Mobject] = []
        self.e_label = None
        self.cached_opacity = 1
        self.e_stroke_color:mn.Color = mn.WHITE
        self.e_fill_color:Optional[mn.Color] = None
        self.e_fill_opacity_factor = 0.5

        # create the manim object
        super().__init__(*args, **kwargs)

        # handle the label stuff
        label_args = label_args or label
        if label_args:

            # label is defined as a simple string (label="A")
            if isinstance(label_args, str):
                string = label_args
                label_args = ()

            # label is defined as a string, with additional arguments (label=("A",arg,...,{key=value,...})
            else:
                string, *label_args = label_args

            # split label args into arguments vs keyword arguments
            if label_args and isinstance(label_args[-1], dict):
                *label_args, l_kwargs = label_args
            else:
                l_kwargs = {}

            # create the label
            self.e_label = self.init_label(string, *label_args, **l_kwargs)

        # if we are not delay the animation, then animate
        if not delay_anim:
            self.e_draw(skip_anim)


    # -----------------------------------------------------------------------------------------------------------------
    # animations/changes
    #   These methods are created during runtime,
    #   but essentially they all just call their equivalent ObjectPlayer method
    # -----------------------------------------------------------------------------------------------------------------
    if TYPE_CHECKING:
        def blue(self)-> EMObject: ...
        def green(self)-> EMObject: ...
        def red(self)-> EMObject: ...
        def white(self)-> EMObject: ...
        def grey(self)-> EMObject: ...
        def e_fade(self) -> EMObject: ...
        def e_normal(self)-> EMObject: ...
        def lift(self)-> EMObject: ...
        def notice(self)-> EMObject: ...

        def e_move(self, vev: mn.Vect3) -> EMObjectPlayer: ...

        def e_rotate(self, about: mn.Vect3, angle: float) -> EMObjectPlayer: ...

        def e_scale(self,
                    scale: float,
                    min_scale_factor: float = 1e-8,
                    about_point: mn.Vect3 | None = None,
                    about_edge: mn.Vect3 = mn.ORIGIN) -> EMObjectPlayer: ...

        def e_move_to(self,
                      point_or_mobject: mn.Mobject | mn.Vect3,
                      aligned_edge: mn.Vect3 = mn.ORIGIN,
                      coor_mask: mn.Vect3 = np.array([1, 1, 1]))-> EMObjectPlayer: ...

        def e_to_edge(self,
                      edge: mn.Vect3 = mn.LEFT,
                      buff: float = mn.DEFAULT_MOBJECT_TO_EDGE_BUFFER)-> EMObjectPlayer: ...

        def e_to_corner(self,
                        corner: mn.Vect3 = mn.DL,
                        buff: float = mn.DEFAULT_MOBJECT_TO_EDGE_BUFFER)-> EMObjectPlayer: ...

    # -----------------------------------------------------------------------------------------------------------------
    # properties
    # -----------------------------------------------------------------------------------------------------------------
    @property
    def fade_opacity(self):
        from . import Text
        return DEFAULT_TEXT_FADE_OPACITY if isinstance(self, Text.EStringObj) else DEFAULT_FADE_OPACITY

    # -----------------------------------------------------------------------------------------------------------------
    # default animation
    # -----------------------------------------------------------------------------------------------------------------
    def CreationOf(self, *args, **kwargs) -> list[EuclidAnimation]:
        """default animation"""
        return [custom_anim.EShowCreation(self, *args, **kwargs, run_time=self.CONSTRUCTION_TIME)]

    # -----------------------------------------------------------------------------------------------------------------
    # default removal of object from scene
    # -----------------------------------------------------------------------------------------------------------------
    def RemovalOf(self, *args, **kwargs) -> list[mn.Uncreate]:
        t = self.CONSTRUCTION_TIME
        if hasattr(self, "DE_CONSTRUCTION_TIME"):
            t = self.DE_CONSTRUCTION_TIME
        return [custom_anim.UncreatePreserve(self, *args, **kwargs, run_time=t)]

    # -----------------------------------------------------------------------------------------------------------------
    # is object in the scene?
    # -----------------------------------------------------------------------------------------------------------------
    def in_scene(self) -> bool:
        return self in self.scene.mobjects


    # -----------------------------------------------------------------------------------------------------------------
    # is visible? (in scene and is shown)
    # Note: get_fill_opacity is a manim property
    # -----------------------------------------------------------------------------------------------------------------
    def visible(self) -> bool:
        return self.in_scene() and (self.get_stroke_opacity() != 0 or self.get_fill_opacity() != 0)

    # -----------------------------------------------------------------------------------------------------------------
    # add a label
    # -----------------------------------------------------------------------------------------------------------------
    @freezable
    def add_label(self, *args, **label_args) -> Self:
        """different arguments for different EObjects"""

        # separate the arguments and key/value pairs
        if isinstance(args[-1], dict) and not label_args:
            *args, label_args = args

        # create new label
        new_label = self.init_label(*args, **label_args)

        # if this object is currently visible, than animate
        if self.visible():

            # transform old label to new label
            if self.e_label is not None:
                self.scene.play(mn.TransformMatchingStrings(self.e_label, new_label, run_time=0.5))

            # use animations to create new label
            else:
                self.scene.play(*new_label.CreationOf())

            # disable updaters (the things that are used during creation)
            new_label.disable_updaters()

        # save info
        self.e_label = new_label

        return self

    # -----------------------------------------------------------------------------------------------------------------
    # initialize a label - creates a label, but doesn't draw or animate it
    # -----------------------------------------------------------------------------------------------------------------
    def init_label(self, label: str, *args, **extra_args) -> Optional[Text.Label]:
        import euclidlib.Objects.Text as Text
        if label:
            return Text.Label(label, self, *args, **extra_args)
        return None


    # -----------------------------------------------------------------------------------------------------------------
    # remove a label
    # -----------------------------------------------------------------------------------------------------------------
    """
            if self.e_label is not None:
            if not self.e_label.visible():
                self.scene.remove(self.e_label)
            else:
                self.scene.play(mn.FadeOut(self.e_label))
        self.e_label = None
        return self
"""

    @freezable
    def remove_label(self) -> Self:
        if self.e_label is not None:
            if not self.e_label.visible():
                self.scene.remove(self.e_label)
            else:
                self.scene.play(mn.FadeOut(self.e_label))

        self.e_label = None

        return self

    # -----------------------------------------------------------------------------------------------------------------
    # undraw a label
    # -----------------------------------------------------------------------------------------------------------------
    @freezable
    def undraw_label(self) -> Self:
        if self.e_label is not None and self.e_label.visible():
            self.scene.play(mn.FadeOut(self.e_label))
        return self

    def label_fade(self) -> Self:
        return self.undraw_label()

    # -----------------------------------------------------------------------------------------------------------------
    # Functions that should be defined in inherited classes
    # -----------------------------------------------------------------------------------------------------------------
    def e_label_location(self, *args, **kwargs):
        raise NotImplementedError(f"{self.__class__.__name__} e_label_location is Undefined")

    def highlight(self):
        raise NotImplementedError(f"{self.__class__.__name__} Highlighting is Undefined")

    def intersect(self, other: mn.Mobject, reverse=True):
        if reverse and isinstance(other, EMObject):
            return other.intersect(self, False)
        raise NotImplementedError(f"{self.__class__.__name__}-{other.__class__.__name__} Intersection is Undefined")

    # -----------------------------------------------------------------------------------------------------------------
    # transform to
    # -----------------------------------------------------------------------------------------------------------------
    def transform_to(self, other: Self, *sub_animations, anim: Type[mn.Animation] = mn.TransformFromCopy):
        return mn.AnimationGroup(
            anim(self, other),
            *sub_animations
        )

    # -----------------------------------------------------------------------------------------------------------------
    # get all the animations necessary for this object
    # -----------------------------------------------------------------------------------------------------------------
    def _get_draw_animations(self):
        return [
            anim
            for x in (self, self.e_label)
            if x is not None
            for anim in x.CreationOf()
        ]

    # -----------------------------------------------------------------------------------------------------------------
    # draws the object onto the scene (with animation)
    # -----------------------------------------------------------------------------------------------------------------
    @freezable
    def e_draw(self, skip_anim=False, anim_args=None, removal_args=None):
        """draws the object on the scene"""

        # if it's already visible, don't bother
        if self.visible():
            return

        # setup animation and removal animation arguments
        anim_args = anim_args or dict()
        removal_args = anim_args if removal_args is None else removal_args

        # if we need to animate
        if not skip_anim and not self.Virtual:
            anims = self._get_draw_animations()

            if anims:
                self.scene.play(*anims, **anim_args)

            # If there are additional elements being animated (via f_always for example)
            # example: the line object in drawing a circle is updated every frame to keep pace with the
            #          animation of the circle.  To do this, an updater was constructed and it needs to be
            #          removed
            if self.animation_objects:

                # remove the updaters
                for obj in self.animation_objects:
                    obj.clear_updaters()

                # after the updaters have been removed, this additional animated object needs to be removed
                with self.scene.simultaneous(**removal_args):
                    for obj in self.animation_objects:
                        if isinstance(obj, EMObject):
                            obj.e_remove()
                        else:
                            self.scene.play(mn.Uncreate(obj))

        # we are not animating, so just add the object to the scene
        else:
            self.scene.add(self)
            if self.scene.debug:
                self.scene.update_frame()
        return self

    # -----------------------------------------------------------------------------------------------------------------
    # entry and exit routines for context managers
    # -----------------------------------------------------------------------------------------------------------------
    def __enter__(self):
        self.e_draw()
        raise TypeError("Time to figure out what this method is for")
        #return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.e_remove()

    # -----------------------------------------------------------------------------------------------------------------
    # rotate the object (adds the rotation of the label as well as the object)
    # -----------------------------------------------------------------------------------------------------------------
    @freezable
    def rotate(
            self,
            angle: float,
            axis: mn.Vect3 = mn.OUT,
            about_point: mn.Vect3 | None = None,
            **kwargs
    ) -> Self:
        if self.get_label() and hasattr(self.get_label(), 'direction') and not callable(self.e_label.direction):
            self.e_label.direction = mn.rotate_vector(self.e_label.direction, angle)
        return super().rotate(angle, axis, about_point, **kwargs)

    # -----------------------------------------------------------------------------------------------------------------
    # set debug mode
    # -----------------------------------------------------------------------------------------------------------------
    def debug(self, dd=True):
        self._debug = dd

    # -----------------------------------------------------------------------------------------------------------------
    # generate target (used by manim's transformations, adds the label to the transformation)
    # -----------------------------------------------------------------------------------------------------------------
    def generate_target(self, use_deepcopy: bool = False) -> Self:
        trgt = super().generate_target(use_deepcopy)
        if trgt.get_label() is not None:
            trgt.e_label = trgt.e_label.generate_target()
        return trgt

    # -----------------------------------------------------------------------------------------------------------------
    # remove the object from the scene (animated using RemovalOf)
    # -----------------------------------------------------------------------------------------------------------------
    @freezable
    def e_remove(self, anim_args=None):
        anim_args = anim_args or dict()
        if 'run_time' not in anim_args:
            anim_args['run_time'] = self.CONSTRUCTION_TIME
        if not self.Virtual and self.visible():
            anims = self.RemovalOf()
            self.undraw_label()
            if anims:
                self.scene.play(*anims, **anim_args)
        else:
            self.scene.remove(self)
        return self

    # -----------------------------------------------------------------------------------------------------------------
    # removes object from scene, no animation
    # -----------------------------------------------------------------------------------------------------------------
    @freezable
    def e_delete(self):
        self.scene.remove(self)
        if self.e_label:
            self.scene.remove(self.e_label)
        return self

    # -----------------------------------------------------------------------------------------------------------------
    # copies the object, and the label
    # -----------------------------------------------------------------------------------------------------------------
    def copy(self, deep: bool = False) -> Self:
        cpy = super().copy(deep)
        if self.get_label() and self.e_label:
            cpy.e_label = self.e_label.copy()
        return cpy

    # -----------------------------------------------------------------------------------------------------------------
    # get the label object
    # -----------------------------------------------------------------------------------------------------------------
    def get_label(self):
        if hasattr(self, 'e_label'):
            return self.e_label

    # -----------------------------------------------------------------------------------------------------------------
    # set and unset the freezing of an object
    # -----------------------------------------------------------------------------------------------------------------
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

    # -----------------------------------------------------------------------------------------------------------------
    # fill and unfill (colour the insides) of the object and animate
    # -----------------------------------------------------------------------------------------------------------------
    def e_fill(self, color: mn.ManimColor = None, opacity=1):

        if color is None:
            opacity = 0
        elif opacity == 0:
            self.e_fill_color = None
        else:
            self.e_fill_color = color

        self.scene.play(
            self.animate.set_fill(color=color, opacity=opacity*self.e_fill_opacity_factor, recurse=False)
        )
        return self

    def e_unfill(self):
        return self.e_fill(opacity=0)

    # -----------------------------------------------------------------------------------------------------------------
    # set the colour of the insides, but don't animate it...
    # this method is used as animation method during creation of
    # i.e. it is one of the default methods saved in self.animation_part
    # -----------------------------------------------------------------------------------------------------------------
    def set_e_fill(
            self,
            color: mn.ManimColor | Iterable[Union[str|mn.Color|None]] = None,
            opacity: float | Iterable[float] | None = None,
            border_width: float | None = None,
            recurse: bool = True
    ) -> Self:
        if self.e_fill_color is not None and color is None:
            color = self.e_fill_color
        if color is None:
            opacity = 0
            self.e_fill_color = None
        else:
            self.e_fill_color = color
        return self.set_fill(color, opacity*self.e_fill_opacity_factor, border_width, recurse)

    # -----------------------------------------------------------------------------------------------------------------
    # interpolate finds the intermediate steps between two states, used for animation
    # it appears that this is here to make sure that the label is animated as well
    # -----------------------------------------------------------------------------------------------------------------
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
            curr_pos = l0.ref.e_label_location(l1.direction)
            start_pos = l1.ref.e_label_location(l1.direction)
            end_pos = l2.ref.e_label_location(l2.direction)
            self.e_label.direction = path_func(start_pos + l1.direction, end_pos + l2.direction, alpha) - curr_pos
        return super().interpolate(mobject1, mobject2, alpha, path_func)

    # -----------------------------------------------------------------------------------------------------------------
    # helpers for pickle (used by manim)
    # -----------------------------------------------------------------------------------------------------------------
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

    # -----------------------------------------------------------------------------------------------------------------
    # for all the properties and methods available for EMObject Player, create equivalent propert/methods here
    # that call the player class ... (which plays whatever) ... and then returns this object
    # -----------------------------------------------------------------------------------------------------------------
    for name in EMObjectPlayer.get_properties():
        exec(f'''
@property
def {name}(self):
    return EMObjectPlayer(self).{name}
        '''.strip())

    for name in EMObjectPlayer.get_methods():
        exec(f'''
def {name}(self, *args):
    return EMObjectPlayer(self).{name}(*args)
        '''.strip())


# ====================================================================================================================
# rejects
# ====================================================================================================================




# def un_create_version(anim: mn.Animation):
#     anim.remover = True
#     anim.should_match_start = True
#     curr_rate = anim.rate_func
#     anim.rate_func = lambda t: curr_rate(1 - t)
#     return anim
