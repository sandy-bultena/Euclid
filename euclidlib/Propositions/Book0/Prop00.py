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

        # @self.push_step
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

        # @self.push_step
        def pentagon_test():
            pent = RegularPolygons.pentagon(ORIGIN, 2)
            self.wait()
            pent.e_remove()
            pent = RegularPolygons.pentagon(ORIGIN, 2, speed=1)

        # @self.push_step
        def copy_para_to_point_test():
            para = EParallelogram(LEFT, ORIGIN, UR)
            point = EPoint(DL*2 + RIGHT)
            res = para.copy_to_point(point)
            res.e_remove()
            para.copy_to_point(point, speed=1)

        # @self.push_step
        def reposition_test():
            para = EParallelogram(DL * 3, DOWN * 3, UR * 3, fill=[RED])
            up_tracker = mn.ValueTracker(3)
            para.f_always.reposition(
                lambda: DL * 3,
                lambda: DOWN * 3,
                lambda: RIGHT * 3 + UP * up_tracker.get_value(),
                lambda: UP * up_tracker.get_value()
            )
            self.play(up_tracker.animate(run_time=6, rate_func=mn.linear).set_value(-2.5))
            para.clear_updaters()

        # @self.push_step
        def line_mean_proportional_test():
            l1 = ELine(ORIGIN, RIGHT * 2)
            l2 = ELine(ORIGIN, RIGHT * 4)
            p = EPoint(ORIGIN)

            l1.to_corner(UL, buff=1)
            l2.next_to(l1, DOWN, aligned_edge=LEFT)
            p.move_to(l1.get_start() + DOWN)
            p2 = p.copy().shift(DOWN * MED_SMALL_BUFF)
            self.add(p2)

            l3 = ELine.mean_proportional(l1, l2, p2, 0, speed=1)
            l4 = ELine.mean_proportional(l1, l2, p, 0)

        # @self.push_step
        def poly_copy_similar_bug():
            poly = EPolygon(
                np.array([-1, 0]),
                np.array([0, 0]),
                np.array([1, 2]),
                np.array([0, 1]),
                np.array([-2, 2]),
            )
            ln = ELine(
                np.array([-1, -3]), np.array([-0.5, -2.5])
            )
            new = poly.copy_to_similar_shape(ln, speed=1)
            self.wait()
            new.e_remove()
            new = poly.copy_to_similar_shape(ln)

        # @self.push_step
        def poly_copy_similar_test():
            poly = EPolygon(
                np.array([-1, 0]),
                np.array([0, 0]),
                np.array([1, 2]),
                np.array([-0.5, 1.25]),
                np.array([-2, 2]),
            )
            ln = ELine(
                np.array([-1, -3]), np.array([-0.5, -2.5])
            )
            new = poly.copy_to_similar_shape(ln, speed=1)
            self.wait()
            new.e_remove()
            new = poly.copy_to_similar_shape(ln)

        # @self.push_step
        def poly_copy_to_polygon_shape_test():
            poly = EPolygon(
                np.array([-1, 0]),
                np.array([0, 0]),
                np.array([1, 2]),
                np.array([-0.5, 1.25]),
                np.array([-2, 2]),
            )
            square = ESquare(ORIGIN, RIGHT).e_move(RIGHT * 2 + UP)()
            pt = EPoint([-3, -2])
            # new = square.copy_to_polygon_shape(pt, poly, speed=1)
            # new.e_remove()
            new = square.copy_to_polygon_shape(pt, poly)
            print(f'{square.true_area()=}')
            print(f'   {new.true_area()=}')

        # @self.push_step
        def line_subtract():
            l1 = ELine(ORIGIN, RIGHT * 4, stroke_color=RED)
            l2 = ELine(ORIGIN, RIGHT * 1.5)

            self.play(e_animate(l1.animate.to_corner(UL, buff=1)))
            self.play(e_animate(l2.animate.next_to(l1, DOWN, aligned_edge=LEFT)))

            l3 = l1.subtract(l2).blue()
            l3.subtract(l2, speed=1/2).green()


        # @self.push_step
        def line_third_proportional_test():
            l1 = ELine(ORIGIN, RIGHT)
            l2 = ELine(ORIGIN, RIGHT * 2)
            p = EPoint(ORIGIN)

            # l1.to_corner(UL, buff=1)
            l1.shift(LEFT)
            l2.next_to(l1, DOWN, aligned_edge=LEFT)
            p.move_to(l1.get_start() + DOWN)
            p2 = p.copy().shift(DOWN * MED_SMALL_BUFF)
            self.add(p2)

            l3 = ELine.third_proportional(l1, l2, p2, 0, speed=1)
            l4 = ELine.third_proportional(l1, l2, p, 0)

            print(f'{l2.get_length()/l1.get_length()=}')
            print(f'{l3.get_length()/l2.get_length()=}')


        # @self.push_step
        def line_forth_proportional_test():
            l1 = ELine(LEFT, ORIGIN)
            l2 = ELine(LEFT + DOWN/2, RIGHT + DOWN/2)
            l3 = ELine(LEFT+ DOWN, LEFT/2+ DOWN)
            p = EPoint(l1.get_start() + DOWN*1.5)
            p2 = p.copy().shift(DOWN * MED_SMALL_BUFF)
            self.add(p2)

            l4 = ELine.fourth_proportional(l1, l2, l3, p2, 0, speed=1)
            l5 = ELine.fourth_proportional(l1, l2, l3, p, 0)

            print(f'{l2.get_length()/l1.get_length()=}')
            print(f'{l4.get_length()/l3.get_length()=}')


        # @self.push_step
        def line_square_test():
            l1 = ELine(LEFT, ORIGIN)
            l2, l3, l4 = l1.square(speed=1)
            l2, l3, l4 = l1.square(negative=True)


        @self.push_step
        def line_parts():
            l1 = ELine(np.array([3, -3]), np.array([-3, 2]))
            l1.show_parts(5, color=RED, speed=1)
            l1.show_parts(5, color=BLUE, edge=UP)