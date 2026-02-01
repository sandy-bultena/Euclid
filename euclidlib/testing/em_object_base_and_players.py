from __future__ import annotations

# ====================================================================================================================
# for testing purposes, remove .euclidlib.Objects.__init__.py
# ====================================================================================================================

import manimlib as mn


import sys
import os
sys.path.append(os.getcwd())

#from euclidlib.Objects.em_object_player import *
from euclidlib.Objects.em_object_base import *
from euclidlib.Objects.em_object_decorators import *
from euclidlib.Scenes.PropScene import *


# =====================================================================================================================
# Test some basic stuff
# =====================================================================================================================
class ManimlibTesting(PropScene):
    title = "To construct an equilateral triangle on a given finite straight line."
    steps = []

    def run_full(self)->None:
        # should create a line and display it automatically
        line = ELine([0,0,0],[1,1,1])
        line.scene.wait()

        # change colour
        line.blue()
        line.scene.wait()

        # make the line noticeable
        line.notice()
        line.scene.wait()

        # add a label
        line.add_label("a",)
        line.add_label(r'0.1', mn.UP, alpha=0.1)
        line.add_label(r'0.3', mn.UP, alpha=0.3)
        line.add_label(r'0.6', mn.UP, alpha=0.6)
        line.add_label(r'0.9', mn.UP, alpha=0.9)

        # create a line with label at same time
        line = ELine([2,0,0],[0,2,0],label_args=('a', mn.UP, {'alpha':0.3}))
        line.e_to_corner()()




# =====================================================================================================================
# Line
# =====================================================================================================================
class ELine(EMObject, mn.Line):

    # -----------------------------------------------------------------------------------------------------------------
    # init
    # -----------------------------------------------------------------------------------------------------------------
    def __init__(self, start: mn.Vect3, end: mn.Vect3, *args, **kwargs):
        """create a new line"""
        super().__init__(start, end, *args, **kwargs)

    def e_label_location(self, direction: mn.Vect3 = None, inside=None, outside=None, alpha=0.5, buff=None):
        """By default, finds the middle of the line, calculates the position where the label should go"""

        # get mid-point (or the alpha percentage of the line) - uses manimlib stuff
        try:
            point = self.point_from_proportion(alpha)
        except AssertionError:
            point = self.get_start()

        # calculate the position
        vec = self.get_unit_vector()
        direction = mn.rotate_vector(vec, -mn.PI / 2)

        return point + (buff or self.LabelBuff) * direction

    # -----------------------------------------------------------------------------------------------------------------
    # highlight the line
    # -----------------------------------------------------------------------------------------------------------------
    def highlight(self, color=mn.RED, scale=3.0, **args):
        return (self.animate(rate_func=mn.there_and_back, **args)
                .set_stroke(color=color, width=scale * float(self.get_stroke_width())))
