import sys
import os
sys.path.append(os.getcwd())

from euclidlib.Scenes.PropScene import PropScene
from euclidlib.Objects import *

class Book1Prop1(PropScene):
    title = "To construct an equilateral triangle on a given finite straight line."
    steps = []

    def run_full(self):
        line_rotate()

    def go(self):
        pass

def line_no_label():
    l = ELine(mn_coord(40, 40), mn_coord(100,100))

def line_rotate():
    l = ELine(mn_coord(40, 40), mn_coord(100,100))
    l.e_rotate(mn_coord(110, 110),3.14/2)(run_time=200)

def line_label_no_direction():
    l = ELine(mn_coord(40, 40), mn_coord(100,100), label_args='A')