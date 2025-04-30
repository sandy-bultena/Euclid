import itertools
import sys
import os

sys.path.append(os.getcwd())
from euclidlib.Propositions.PropScene import PropScene
from euclidlib.Objects import *
from manimlib import Text


class LineTests(PropScene):
    steps = []
    title = "Line Tests"

    def __init__(self, *args, **kwargs):
        self.title_text: Text | None = None
        self.sub_text: Text | None = None
        super().__init__(*args, **kwargs)

    def change_sub_title(self, name):
        if not name:
            if self.sub_text:
                self.play(mn.FadeOut(self.sub_text), run_time=0.5)
                self.sub_text = None
            return

        assert self.title_text is not None

        if self.sub_text is None:
            self.sub_text = Text(name, font_size=30).next_to(self.title_text, DOWN, aligned_edge=RIGHT)
            self.play(mn.Write(self.sub_text, run_time=0.5))
        else:
            new = Text(name, font_size=30).next_to(self.title_text, DOWN, aligned_edge=RIGHT)
            self.play(mn.TransformMatchingStrings(self.sub_text, new, run_time=0.5))
            self.sub_text = new

    def change_main_title(self, name):
        self.change_sub_title('')
        if self.title_text is None:
            self.title_text = Text(name).to_corner(UR)
            self.play(mn.Write(self.title_text))
        else:
            new = Text(name).to_corner(UR)
            self.play(mn.TransformMatchingStrings(self.title_text, new))
            self.title_text = new

    def push_step(self, name):
        def sub(func):
            @wraps(func)
            def wrapped_func():
                self.change_main_title(name)
                func()
                self.remove(*(x for x in self.mobjects if x is not self.title_text))
                self.change_sub_title('')

            super(LineTests, self).push_step(wrapped_func)
            return wrapped_func

        return sub

    def define_steps(self):
        @self.push_step("Create Line")
        def create_line():
            l1 = ELine(UR * 2, np.array([-2, -1]))
            l2 = ELine(UL * 2, np.array([3, -0.5]))
            self.wait()
            self.e_remove(l1, l2)

        @self.push_step("Line Labels")
        def line_labels():
            self.change_sub_title('inside/outside')
            outside_label = ELine(DL, DR, label=('outside', dict(outside=1)))
            inside_label = ELine(UL, UR, label=('inside', dict(inside=1)))
            self.wait()
            self.e_remove(outside_label, inside_label)

            self.change_sub_title('label directions')
            small_line = ELine(LEFT / 3, RIGHT / 3, label=('UR', UR))
            small_line.add_label('UL', UL)
            small_line.add_label('DL', DL)
            small_line.add_label('DR', DR)
            self.wait()
            self.e_remove(small_line)

            self.change_sub_title('label buffer')
            large_line = ELine(LEFT, RIGHT, label=(r'0', UP, dict(buff=0)))
            large_line.add_label(r's', UP, buff=SMALL_BUFF)
            large_line.add_label(r'ms', UP, buff=MED_SMALL_BUFF)
            large_line.add_label(r'ml', UP, buff=MED_LARGE_BUFF)
            large_line.add_label(r'l', UP, buff=LARGE_BUFF)
            self.wait()

            self.change_sub_title('label alpha')
            large_line.add_label(r'0.1', UP, alpha=0.1)
            large_line.add_label(r'0.3', UP, alpha=0.3)
            large_line.add_label(r'0.6', UP, alpha=0.6)
            large_line.add_label(r'0.9', UP, alpha=0.9)
            self.wait()
            self.e_remove(large_line)

        @self.push_step("ELine.point")
        def line_point():
            line = ELine(DL, UR)
            points = [
                EPoint(line.point(x), label=(str(x), UL))
                for x in (y / 10 for y in range(-10, int(15 * line.get_length()), 5))
            ]
            self.wait()
            self.e_remove(line, *points)

        @self.push_step("ELine.length_from_start/end")
        def line_length_from():
            def orth(l: mn.Line):
                tmp = mn.rotate_vector(l.get_unit_vector(), PI / 2)
                return -tmp if mn.angle_of_vector(tmp) < 0 else tmp

            line = ELine(2 * DL, 2 * UR)
            alpha = mn.ValueTracker(line.get_length() / 2)

            p = EPoint(line.point(alpha.get_value()))
            p.f_always.move_to(lambda: line.point(alpha.get_value()))

            vl1 = mn.Line(line.get_start(), p.get_center(), stroke_width=1, stroke_color=BLUE, z_index=-1)
            vl2 = mn.Line(p.get_center(), line.get_end(), stroke_width=1, stroke_color=RED, z_index=-1)
            vl1.f_always.set_points_by_ends(line.get_start, p.get_center)
            vl2.f_always.set_points_by_ends(p.get_center, line.get_end)

            brace0 = mn.Brace(vl1, orth(vl1), fill_color=BLUE)
            brace1 = mn.Brace(vl2, -orth(vl2), fill_color=RED)

            brace0.f_always.become(lambda: mn.Brace(vl1, orth(vl1), fill_color=BLUE))
            brace1.f_always.become(lambda: mn.Brace(vl2, -orth(vl2), fill_color=RED))

            legend = mn.TexText("From Start\n\nFrom End", t2c={'From Start': BLUE, 'From End': RED})
            legend.to_corner(DL)

            number0: mn.DecimalNumber = mn.DecimalNumber(0, num_decimal_places=2, font_size=24, color=BLUE)
            number1: mn.DecimalNumber = mn.DecimalNumber(0, num_decimal_places=2, font_size=24, color=RED)

            number0.f_always.next_to(brace0.get_center, lambda: orth(vl1), buff=lambda: MED_SMALL_BUFF)
            number1.f_always.next_to(brace1.get_center, lambda: -orth(vl2), buff=lambda: MED_SMALL_BUFF)

            number0.f_always.set_value(lambda: line.length_from_start(p))
            number1.f_always.set_value(lambda: line.length_from_end(p))

            brace0.suspend_updating()
            brace1.suspend_updating()
            number0.suspend_updating()
            number1.suspend_updating()
            self.add(vl1, vl2)
            self.play(mn.Write(legend),
                      mn.DrawBorderThenFill(brace0),
                      mn.Write(number0),
                      mn.DrawBorderThenFill(brace1),
                      mn.Write(number1))
            brace0.resume_updating()
            brace1.resume_updating()
            number0.resume_updating()
            number1.resume_updating()

            self.change_sub_title("Set to line.point(0.5)")
            self.play(alpha.animate.set_value(0.5), run_time=4)
            self.change_sub_title("Set to line.point(5.0)")
            self.play(alpha.animate.set_value(5), run_time=8)

            p.clear_updaters()

            self.change_sub_title("Set point off of line")
            self.play(p.animate.move_to(UR * 3), run_time=4)
            self.wait()
            self.play(p.animate.move_to(LEFT * 2.5), run_time=4)
            self.wait()

            brace0.clear_updaters()
            brace1.clear_updaters()
            number0.clear_updaters()
            number1.clear_updaters()
            vl1.clear_updaters()
            vl2.clear_updaters()
            self.play(*(mn.FadeOut(x) for x in [legend, vl1, vl2, number0, number1, brace0, brace1]))
            self.e_remove(line, p)

        @self.push_step("ELine.extend/prepend")
        def line_extend_prepend():
            with self.simultaneous():
                line0 = ELine(DL / 2 + LEFT, UR / 2 + LEFT, stroke_color=BLUE)
                line1 = ELine(DL / 2 + RIGHT, UR / 2 + RIGHT, stroke_color=RED)
                ps = [
                    EPoint(x) for x in [*line0.get_start_and_end(), *line1.get_start_and_end()]
                ]

            legend = mn.TexText("W/ Animation\n\nSkipped Animation\n\n"
                                r"\textsubscript{Because method mutates self, need to make sure that the"
                                r"line is mutated even when animations are skipped}",
                                font_size=24,
                                alignment='',
                                t2c={'W/ Animation': BLUE, 'Skipped Animation': RED})
            legend.to_corner(DL)
            self.play(mn.Write(legend))

            line0.save_state()
            line1.save_state()

            extend_values = (1, -1)

            for i in extend_values:
                self.change_sub_title(f"extend by {i}")
                line0.extend(i)
                with self.pause_animations_for():
                    line1.extend(i)

                self.wait()
                self.change_sub_title(f"prepend by {i}")
                line0.prepend(i)
                with self.pause_animations_for():
                    line1.prepend(i)

                self.wait()
                self.play(line0.animate.restore(), line1.animate.restore())

            self.change_sub_title(f"extend and prepend by {extend_values[0]}")
            line0.extend_and_prepend(extend_values[0])
            with self.pause_animations_for():
                line1.extend_and_prepend(extend_values[0])

            self.play(mn.FadeOut(legend))
            self.e_remove(line1, line0, *ps)

        @self.push_step("ELine.interpolate")
        def line_interp():
            shift_factor = 3.5

            BasePositions = [
                (np.array([-1, 0, 0]), np.array([1, 0, 0])),
                (np.array([1, -1, 0]), np.array([-1, -1, 0])),  # Swap and shift

                (np.array([1, -1, 0]), np.array([-2, -3, 0])),  # Almost Match starts
                (np.array([-.5, -4, 0]), np.array([1, -1, 0])),  # Almost Match starts (swap)

                (np.array([-2, -3, 0]), np.array([1, -1, 0])),  # Almost Match ends
                (np.array([1, -1, 0]), np.array([-3, 1, 0])),  # Almost Match ends (swap)

                (np.array([-1.5, 0, 0]), np.array([1.5, 0, 0])),  # Setup WIDE
                (np.array([0, 1.5, 0]), np.array([0, -1.5, 0])),  # orthogonal contraction
            ]

            e_lines = [ELine(x, y, delay_anim=True).shift(LEFT * shift_factor).set_stroke([RED, BLUE]) for x, y in BasePositions]
            m_lines = [mn.Line(x, y).shift(RIGHT * shift_factor).set_stroke([RED, BLUE]) for x, y in BasePositions]

            legends = [
                EText("Euclid Line", font_size=24, delay_anim=True).next_to(e_lines[0], UP),
                EText("Manim Line", font_size=24, delay_anim=True).next_to(m_lines[0], UP),
            ]
            self.play(*(mn.Write(x) for x in legends),
                      mn.ShowCreation(e_lines[0]),
                      mn.ShowCreation(m_lines[0]),
                      )

            DOT_RADIUS = 0.04
            for (ex, ey), (mx, my), (x, y) in zip(itertools.pairwise(e_lines), itertools.pairwise(m_lines), BasePositions[1:]):
                dots = mn.VGroup(mn.Dot(x + LEFT * shift_factor, fill_color=RED, radius=DOT_RADIUS),
                                 mn.Dot(y + LEFT * shift_factor, fill_color=BLUE, radius=DOT_RADIUS),
                                 mn.Dot(x + RIGHT * shift_factor, fill_color=RED, radius=DOT_RADIUS),
                                 mn.Dot(y + RIGHT * shift_factor, fill_color=BLUE, radius=DOT_RADIUS))
                self.add(dots)
                self.play(
                    mn.ReplacementTransform(ex, ey, rate_func=mn.smooth),
                    mn.ReplacementTransform(mx, my, rate_func=mn.smooth),
                    run_time=2)
                self.remove(dots)
                self.wait(0.25)

            self.play(*(mn.FadeOut(x) for x in legends))
            self.play(*(mn.FadeOut(x) for x in m_lines if x in self.mobjects))
            self.e_remove(*e_lines)

        @self.push_step("ELine.intersect_circle")
        def line_cir_intersect():
            cir = ECircle(RIGHT, RIGHT*3)
            line = ELine(2.5*(DL+LEFT), 2.5*UL).dash()

            dots = mn.VGroup(mn.Dot(), mn.Dot())
            self.add(dots)
            def create_intersect_points(dots):
                pts = line.intersect(cir) or []
                for d, pt in itertools.zip_longest(dots, pts):
                    if pt is not None:
                        d.set_opacity(1)
                        d.move_to(pt)
                    else:
                        d.set_opacity(0)
            dots.add_updater(create_intersect_points)

            line.e_move(RIGHT * 5)(run_time=5)
            self.wait()
            self.play(line.animate.set_points_by_ends(RIGHT, UR))
            self.wait()
            line.extend(2)
            self.wait()
            self.play(mn.Rotate(line, angle=TAU, about_point=line.get_start()), run_time=3)
            dots.clear_updaters()
            self.play(mn.FadeOut(dots))
            self.e_remove(cir, line)
