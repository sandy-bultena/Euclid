import sys
import os
sys.path.append(os.getcwd())

from euclidlib.Scenes.PropScene import PropScene
from euclidlib.Objects import *

class Book1Prop1(PropScene):
    title = "To construct an equilateral triangle on a given finite straight line."
    steps = []

    def run_full(self):
        line_labels()

    def go(self):
        pass

def line_labels():
    l1 = ELine(mn_coord(140, 140), mn_coord(300,200))
    l1.add_label('A',direction=mn.RIGHT)

    l2 = ELine(mn_coord(140, 240), mn_coord(300,300))
    l2.add_label('B',side=LineLabelSide.INSIDE)

    l3 = ELine(mn_coord(140, 340), mn_coord(300,400))
    l3.add_label('C',side=LineLabelSide.OUTSIDE)

    l4 = ELine(mn_coord(440, 140), mn_coord(600,200))
    l4.add_label('D',side=LineLabelSide.OUTSIDE, alpha = 0.1)

    l5 = ELine(mn_coord(440, 240), mn_coord(600,300))
    l5.add_label('E',direction=mn.LEFT, alpha = 0.0)

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

def highlight():
    l = ELine(mn_coord(40, 40), mn_coord(100,100))
    l.notice()

def line_no_label():
    p1 = EPoint(mn_coord(140,300))
    p2 = EPoint(mn_coord(300,140))
    l1 = ELine(mn_coord(140, 140), mn_coord(300,300))
    l2 = ELine(p1,p2).blue()

def line_rotate():
    l = ELine(mn_coord(40, 40), mn_coord(100,100))
    l.e_rotate(mn_coord(110, 110),3.14/2)(run_time=200)

def line_label_no_direction():
    l = ELine(mn_coord(40, 40), mn_coord(100,100), label_args='A')