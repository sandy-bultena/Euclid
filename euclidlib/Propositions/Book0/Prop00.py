import itertools
import sys
import os
from random import shuffle

sys.path.append(os.getcwd())
from euclidlib.Propositions.BookScene import BookScene
from euclidlib.Objects import *
from typing import Dict
from euclidlib.Objects.utils import *
from euclidlib.Objects.CustomAnimation import EAnimationOf


class Prop0(BookScene):
    steps = []
    title = ""

    def define_steps(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_h_scale(550))

        l: Dict[str | int, ELine] = {}
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}
        t: Dict[str | int, ETriangle] = {}
        s: Dict[str | int, EPolygon] = {}
        a: Dict[str | int, EAngleBase] = {}
        eq: Dict[str | int, EStringObj] = {}
        ex: Dict[str | int, Mobject] = {}

        # @self.push_step
        def dashed_test():
            t1.title("Draw Line")
            la = ELine(DL * 2, ORIGIN)
            t1.title("Make Dashed")
            la.dash(final_opacity=0)
            t1.title("Extend")
            la.extend(1)
            t1.title("Un dash")
            la.un_dash()
            self.wait(1)
            la.e_remove()
            t1.e_remove()

        @self.push_step
        def tickmark_test():
            t1.title("Draw Line")
            la = EArc(2, LEFT * 3 + UP, UP, big=True)
            t1.title("Mark Ticks")
            la.dash()
            la.even_ticks(la.get_arc_length() / 15, labels=map(str, itertools.count()))
            self.wait()
            la.e_fade()
            self.wait()
            la.e_normal()
            self.wait()
            la.e_remove()

        # @self.push_step
        def triangle_circumscribe():
            t = ETriangle(UP, LEFT, DR)
            c = t.circumscribe(speed=1)

        # @self.push_step
        def line_golden_ratio():
            line = ELine(LEFT, RIGHT)
            p = line.golden_ration(speed=1)

        # @self.push_step
        def line_copy_to_circle():
            line = ELine(LEFT * 3.5, LEFT)
            circle = ECircle(RIGHT*2, RIGHT*4)
            p = circle.point_at_angle(PI/3)
            res = line.copy_to_circle(circle, p, speed=1)

        # @self.push_step
        def triangle_golden_ration():
            line = ELine(LEFT * 3.5, LEFT)
            ETriangle.golden(line, speed=1)
