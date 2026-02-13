import sys
import os
sys.path.append(os.getcwd())

from euclidlib.Scenes.PropScene import PropScene
from euclidlib.Objects import *

class Book1Prop1(PropScene):
    title = "To construct an equilateral triangle on a given finite straight line."
    steps = []

    def run_full(self):
        line_dash_and_undash()

    def go(self):
        pass

def line_dash_and_undash():
    A = (425,30)
    B = (750,30)
    t1 = TextBox(mn_coord(20, 20))

    for i in range(4):
        pos_space = (i+1) * 0.1
        op = (i+1) * 0.2
        text = f"positive_space_ratio={pos_space:.1f},   final_opacity={op:.1f}"
        t1.explain(text)
        l = ELine(mn_coord(A[0],A[1]+i*25), mn_coord(B[0],B[1]+i*25))
        l.dash(dash_length=mn.DEFAULT_DASH_LENGTH,positive_space_ratio=pos_space, final_opacity=op)


def line_no_label():
    l = ELine(mn_coord(40, 40), mn_coord(100,100))

def line_rotate():
    l = ELine(mn_coord(40, 40), mn_coord(100,100))
    l.e_rotate(mn_coord(110, 110),3.14/2)(run_time=200)

def line_label_no_direction():
    l = ELine(mn_coord(40, 40), mn_coord(100,100), label_args='A')