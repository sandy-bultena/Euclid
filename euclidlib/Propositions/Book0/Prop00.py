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
        t1 = TextBox(mn_coord(800, 50), line_width=mn_h_scale(550))

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

        # @self.push_step
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
            res = line.copy_to_circle(circle, p)

        # @self.push_step
        def triangle_golden_ration():
            line = ELine(LEFT * 3.5, LEFT)
            ETriangle.golden(line, speed=1)

        # @self.push_step
        def triangle_copy_to_circle():
            tri = ETriangle(UP, LEFT, DR)
            tri.e_move(3 * LEFT)()
            tri.l0.dash()
            tri.l1.even_ticks(0.3)
            circle = ECircle(RIGHT*2, RIGHT*4)
            t1.title("Triangle to Copy (animated)")
            res = tri.copy_to_circle(circle, speed=1)
            self.wait(2)
            res.e_remove()
            t1.title("Triangle to Copy (skipped)")
            res = tri.copy_to_circle(circle, speed=-1)

        # @self.push_step
        def ticks_animated():
            line = ELine(LEFT * 4, LEFT)
            line.dash(dash_length=0.2)
            circle = ECircle(RIGHT*2, RIGHT*4)
            p = circle.e_point_at_angle(PI/4)
            res = line.copy_to_circle(circle, p)

        # @self.push_step
        def clean_bisect_test():
            tri = ETriangle(UP, LEFT, DR, angles='ABC')
            tri.a0.clean_bisect()
            tri.a1.clean_bisect(speed=1)

        # @self.push_step
        def fill_circle_test():
            circle = ECircle(RIGHT*2, RIGHT*4)
            circle2 = ECircle(ORIGIN, RIGHT*2)
            circle.e_fill(RED)
            circle2.e_fade()
            circle.e_fade()
            circle2.e_normal()
            circle.e_normal()


        # @self.push_step
        def semi_circle_test():
            cc = EArc.semi_circle(RIGHT, LEFT)

        # @self.push_step
        def arc_fill_test():
            la = EArc(2, LEFT * 3 + UP, UP, big=False)
            la.e_fill(RED)

            pie = la.create_pie()
            pie.e_fill(BLUE)

        @self.push_step
        def arc_intersection_test():
            la = EArc(2, LEFT * 3 + UP, ORIGIN, big=False)
            lb = EArc(2, UP * 2, DOWN * 2, big=False)
            ll = ELine(UP * 2.5, DL * 2)
            pts = la.intersect(lb)
            pt2 = la.intersect(ll)
            pt3 = lb.intersect(ll)

            for p in pts:
                EPoint(p, fill_color=RED)
            for p in pt2:
                EPoint(p, fill_color=BLUE)
            for p in pt3:
                EPoint(p, fill_color=GREEN)

            la.bisect(speed=1)
            lb.bisect()