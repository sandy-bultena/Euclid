from functools import wraps

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

foo(3,4)
