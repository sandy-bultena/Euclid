from functools import wraps
from typing import Callable, TypeVar, cast


#from typing import Any

#from manimlib import *

# class SingleLineColor(Scene):
#     def construct(self):
#         text = MarkupText(
#             f'all in red <span fgcolor="{YELLOW}">except this</span>', color=RED
#         )
#         self.add(text)
#
# class SquareToCircle(Scene):
#     def construct(self):
#         circle = Circle()
#         circle.set_fill(BLUE, opacity=0.5)
#         circle.set_stroke(BLUE_E, width=4)
#         square = Square()
#
#         self.play(ShowCreation(square))
#         self.wait()
#         self.play(ReplacementTransform(square, circle))
#         self.wait()
#
#         self.embed()

def anim_speed(func):
    print("in anim_speed")
    @wraps(func)
    def animate_change(*args, speed=-1, **kwargs):
        print(f"animate_change {args}, speed={speed}" )
        x = func(*args, **kwargs)
        return x
    return animate_change


def copy_transform(*args, index=None):
    print(f"copy_transform: {args=}, {index=}")
    def inner(func):
        @wraps(func)
        def animate_change( *args, speed=-1, no_anim=False, **kwargs):
            if speed > 0:
                return anim_speed(func)( *args, speed=speed, **kwargs)
            elif speed < 0:
                func(*args, **kwargs)
            else:
                func(*args, **kwargs)

        return animate_change

@copy_transform
def foo(n,y):
    print(f"Foo: {n=} {y=}")

docstr = """This is the doc string for abc"""
def abc():
    """whatever"""
abc.__doc__ = docstr




CommonFunc = Callable[[str, int], bool]
F = TypeVar("F", bound=CommonFunc)

def shared_signature_and_doc(func: F) -> F:
    """A decorator to apply a common docstring.
        This is a shared docstring applied by a decorator.

        Args:
            name: The name parameter (str).
            value: The value parameter (int).

        Returns:
            A boolean indicating success or failure.
    """
    # Cast is used here to help the type checker understand the return type
    return cast(F, func)

@shared_signature_and_doc
def func_e(name: str, value: int) -> bool:
    """Placeholder docstring gets replaced."""
    return True

import functools
@functools.wraps(shared_signature_and_doc)
def func_f(name: str, value: int) -> bool:
    """other docstring"""
    return False

# You can now see the shared docstring is present
# print(func_e.__doc__)


func_f("a",3)
