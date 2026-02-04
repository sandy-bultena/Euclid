from __future__ import annotations


import sys
import os
sys.path.append(os.getcwd())
from euclidlib.Objects import *
from euclidlib.Scenes.PropScene import *


# =====================================================================================================================
# Test some basic stuff
# =====================================================================================================================
class ManimlibTesting(PropScene):
    def go(self) -> None:
        pass

    title = "To construct an equilateral triangle on a given finite straight line."
    steps = []

    def run_full(self)->None:
        poly = ETriangle([3,3,0],[0,3,0],[3,0,0], labels=['A','B','C'])
        poly.e_fill(BLUE)
        poly.green()

        poly.e_move([-1,-1,-1])(run_time=2)

        self.next_page()
        t2 = TextBox(mn_coord(500, 430))
        t2.math("hi")   # 0
        t2.math("bye")  # 1
        t2.blue()
        t2.green(1)

        self.next_page()
        eq: dict[str | int, EStringObj | tuple[EStringObj, ...]] = {}

        eq[1] = t2.math(r'c_1 + b_3\quad\quad\quad\quad >\ c_2 + c_3')
        t2.math("x=y") # 2
        eq[2] = t2.math(r'c_1 + b_3 + b_4 >\ c_2 + c_3 + b_4 bananas',
                        break_into_parts=('c_1 + b_3 + b_4', (r'>\ c_2 + c_3 + b_4',
                                                              {"align_str":">",
                                                               "align_index":-2})
                                          )
                        )
        eq[3] = t2.math("hello") # 4
        eq[4] = t2.math("salut") # 5
        eq[2].blue()
        eq[2].parts[1].red()
        eq[3].green()

        self.next_page()
        t2.explain("by index")  # 6
        t2.e_fade()
        t2.blue(2)
        t2.red(3)
        t2.green(4)
        t2.white(5)

        self.next_page()
        t2.explain("by t2 index")  # 6
        t2.e_fade()
        t2[1].blue()
        t2[2].red()
        t2[3].green()
        t2[4].white()

        t2.explain("All done")

