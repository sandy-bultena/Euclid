import sys
import os
sys.path.append(os.getcwd())

from euclidlib.Scenes.PropScene import PropScene
from euclidlib.Objects import *

class Book1Prop1(PropScene):
    title = "To construct an equilateral triangle on a given finite straight line."
    steps = []

    def run_full(self):
        circle_no_label()

    def go(self):
        pass

def circle_no_label():
    l = ECircle(mn_coord(100, 100), mn_coord(150,150), label_args='A')
def circle_label_no_direction():
    l = ECircle(mn_coord(100, 100), mn_coord(150,150), label_args=('A',dict(angle=-45)))