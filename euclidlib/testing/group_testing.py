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
