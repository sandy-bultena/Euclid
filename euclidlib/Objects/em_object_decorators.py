# =====================================================================================================================
# decorators specifically for methods for EuclidMObject
# ... uses methods found in EuclidMObject
# =====================================================================================================================
from contextlib import contextmanager
from functools import wraps
from typing import TYPE_CHECKING
from . import CustomAnimation as CA
from euclidlib.Utilities.find_scene import find_scene

import manimlib as mn
if TYPE_CHECKING:
    from euclidlib.Objects.em_object_player import NullPlayer

# ---------------------------------------------------------------------------------------------------------------------
# context manager
# ---------------------------------------------------------------------------------------------------------------------
@contextmanager
def with_objects(head, *rest):
    with head:
        if rest:
            with with_objects(*rest) as sub_elements:
                yield head, *sub_elements
        else:
            yield head,


# ---------------------------------------------------------------------------------------------------------------------
# decorator - animate whatever changes happen in the function
# ---------------------------------------------------------------------------------------------------------------------
def animate(func):
    @wraps(func)
    def animate_change(self, *args, rate_func=mn.smooth, **kwargs):
        """
        :param self: EObject
        :param args:
        :param rate_func:
        :param kwargs:
        :return:
        """
        if not self.scene.is_paused():
            an = self.animate(rate_func=rate_func)
            func(self, an, *args, **kwargs)
            self.scene.play(CA.e_animate(an))
            return self
        else:
            return func(self, self, *args, **kwargs)

    return animate_change

# ---------------------------------------------------------------------------------------------------------------------
# decorator - debugging option by setting up a trace
# ---------------------------------------------------------------------------------------------------------------------
def log(func):
    @wraps(func)
    def logMethodName(self, *args, **kwargs):
        with find_scene().trace(self, f"{type(self).__name__}:{func.__name__}"):
            return func(self, *args, **kwargs)

    return logMethodName


# ---------------------------------------------------------------------------------------------------------------------
# decorator - allows objects to be frozen against any function that might modify it
# ---------------------------------------------------------------------------------------------------------------------
def freezable(func):
    @wraps(func)
    def dontIfFrozen(self, *args, **kwargs):
        if self.is_frozen:
            return self
        return func(self, *args, **kwargs)

    return dontIfFrozen

# ---------------------------------------------------------------------------------------------------------------------
# decorator - sets the animation speed for all animations happening during the function (this is a guess :( )
# ---------------------------------------------------------------------------------------------------------------------
def anim_speed(func):
    @wraps(func)
    def animate_change(*args, speed=-1, no_anim=False, **kwargs):
        scene = find_scene()

        # Note: draw is a list, so need to save all the objects to be drawn to this list
        #       ... drawing occurs in scene.animation_speed
        with scene.animation_speed(speed) as to_draw:
            x = func(*args, **kwargs)
            if not no_anim:
                if isinstance(x, (tuple, list)):
                    to_draw.extend(x)
                else:
                    to_draw.append(x)
        return x

    return animate_change


# ---------------------------------------------------------------------------------------------------------------------
# copy and transform?? (bad name)
# - the 'func' that is decorated should return objects that need to be drawn 'if' speed < 0
# - if the speed is less than zero, then don't show intermediate animations,
# - if index is not none, and speed less than zero
#     transform into the 'indexth' returned object from func, and display the rest
# ---------------------------------------------------------------------------------------------------------------------
def copy_transform(*, index=None):
    def inner(func):
        @wraps(func)
        def animate_change(self, *args, speed=-1, no_anim=False, **kwargs):

            if speed > 0:
                # call function after setting the speed for all animations
                return anim_speed(func)(self, *args, speed=speed, no_anim=no_anim, **kwargs)

            elif speed < 0:

                # pause all animations
                with self.scene.pause_animations_for():
                    x = func(self, *args, **kwargs)

                if index is None:
                    # transform self into objects returned from calling func
                    if not no_anim:
                        self.scene.play(self.transform_to(x))

                else:
                    # transform self to x[index], and then draw the remainder of the objects in 'x'
                    tmp = list(x)
                    if not no_anim:
                        with self.scene.simultaneous():
                            self.scene.play(self.transform_to(tmp[index]))
                            del tmp[index]
                            for y in tmp:
                                y.e_draw()
                return x

            else:
                # default if speed = 0
                return func(self, *args, **kwargs)

        return animate_change

    return inner


def class_anim_speed(func):
    @wraps(func)
    def animate_change(cls: type, *args, speed=-1, **kwargs):
        scene = find_scene()
        with scene.animation_speed(speed) as draw:
            x = func(cls, *args, **kwargs)
            if isinstance(x, (tuple, list)):
                draw.extend(x)
            else:
                draw.append(x)
        return x

    return animate_change


def freezable_player(func):
    @wraps(func)
    def dontIfFrozen(self, *args, **kwargs):
        if self.is_frozen:
            return NullPlayer(self)
        return func(self, *args, **kwargs)

    return dontIfFrozen

