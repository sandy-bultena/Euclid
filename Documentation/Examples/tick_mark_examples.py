import itertools
import sys
import os

from numpy.ma.core import negative

sys.path.append(os.getcwd())

from euclidlib.Scenes.PropScene import PropScene
from euclidlib.Objects import *


class Book1Prop1(PropScene):
    title = ""
    steps = []

    def run_full(self):
        print(mn.__version__)
        tickmark_arc()

    def go(self):
        pass

def dashed_test():
    t1 = TextBox(mn_coord(800, 50), line_width=mn_scale(550))

    t1.explain("Draw Line")
    la = ELine(DL * 2, ORIGIN)
    t1.explain("Make Dashed")
    la.dash(final_opacity=0)
    t1.explain("Extend")
    la.extend(1)
    t1.explain("Un dash")
    la.un_dash()
    la.scene.wait(1)
    la.e_remove()
    t1.e_remove()

def tickmark_simple():
    t1 = TextBox(mn_coord(100, 50), line_width=mn_scale(550))
    t1.explain("Draw Line")
    l = ELine(mn_coord(100,300), mn_coord(500,300))
    t1.explain("Draw Ticks with labels")
    l.ticks_evenly(l.get_length() / 5, labels=map(str, itertools.count()))

    t1.explain("Draw Line")
    l = ELine(mn_coord(100,400), mn_coord(500,400))
    t1.explain("Draw Single Tick at length 50")
    l.tick_abs(mn_scale(50), label="ha")

    t1.explain("Draw Line")
    l = ELine(mn_coord(100,500), mn_coord(500,500))
    t1.explain("Draw Single 75% mark")
    l.tick_prop(0.75, label="75%")

def tickmark_with_animations():
    t1 = TextBox(mn_coord(100, 50), line_width=mn_scale(550))
    t1.explain("Draw Line")
    l = ELine(mn_coord(100,300), mn_coord(300,300))
    t1.explain("Draw Ticks with labels")
    l.ticks_evenly(l.get_length() / 5, labels=map(str, itertools.count()))
    t1.explain("change colour")
    l.blue()
    l.scene.wait(15)
    t1.explain("fade")
    l.e_fade()
    l.scene.wait(15)
    t1.explain("normal")
    l.e_normal()
    l.scene.wait(15)
    t1.explain("remove")
    l.e_remove()

def tickmark_arc():
    t1 = TextBox(mn_coord(800, 50), line_width=mn_scale(550))
    t1.explain("Draw Line")
    la = EArc(2, LEFT * 3 + UP, UP, big=True)
    la.dash()
    t1.explain("Mark Ticks")
    la.ticks_evenly(la.get_arc_length() / 15, labels=map(str, itertools.count()))
    t1.explain("Tick marks should be visible now")
    la.scene.wait(15)
    la.e_fade()
    la.scene.wait(15)
    la.e_normal()
    la.scene.wait(15)
    la.e_remove()


def dashed_animated():
    t1 = TextBox(mn_coord(800, 50), line_width=mn_scale(550))
    line = ELine(LEFT * 4, LEFT)
    line.dash(dash_length=0.2)
    circle = ECircle(RIGHT * 2, RIGHT * 4)
    p = circle.e_point_at_angle(PI / 4)
    res = line.copy_as_chord(circle, p)
