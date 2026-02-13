import sys
import os
sys.path.append(os.getcwd())

from euclidlib.Scenes.PropScene import PropScene
from euclidlib.Objects import *

class Book1Prop1(PropScene):
    title = ""
    steps = []

    def run_full(self):
        arc_bisect()

    def go(self):
        pass

def arc_bisect():
    la = EArc(2, LEFT * 3 + UP, UP, clockwise=False)
    la.bisect()

def arc_fill_test():
    la = EArc(2, LEFT * 3 + UP, UP, clockwise=False)

    pie = la.create_pie()
    pie.e_fill(BLUE)


def circle_no_label():
    l = ECircle(mn_coord(100, 100), mn_coord(150,150), label_args='A')
def circle_label_no_direction():
    l = ECircle(mn_coord(100, 100), mn_coord(150,150), label_args=('A',dict(angle=-45)))