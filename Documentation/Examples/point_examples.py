import sys
import os
sys.path.append(os.getcwd())

from euclidlib.Scenes.PropScene import PropScene
from euclidlib.Objects import *

class Book1Prop1(PropScene):
    title = "To construct an equilateral triangle on a given finite straight line."
    steps = []

    def run_full(self):
        point_no_label()

    def go(self):
        pass

def point_no_label():
    p = EPoint(mn_coord(20, 20))