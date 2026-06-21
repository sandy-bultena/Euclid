import sys
import os
sys.path.append(os.getcwd())

from euclidlib.Scenes.book08 import Book8Scene
from euclidlib.Objects import *
from euclidlib.Utilities.e_numbers import ENumbers

PPURPLE       = Colour.add( PURPLE,    PURPLE )
REALLY_PURPLE = Colour.add( PPURPLE, PURPLE )

class Prop26(Book8Scene):
    title = ("Similar plane numbers have to one another the ratio which a square "
    "number has to a square number"
    )

    def go(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(500), name="explanation")
        t2 = TextBox(mn_coord(140, 300), name="math")
        t3 = TextBox(mn_coord(500, 480))

        origin = mn_coord(100, 160)
        unit = mn_scale(10)
        dy = mn_scale(30)
        dx = mn_scale(50)
        mls = MultipleLines(origin, unit, dx, dy)
        n1, n2, n3 = ENumbers.find_continued_proportion(2, 3, 3)

        mls.define_line_coordinates('A', 2 * n1)
        mls.define_line_coordinates('D', n1, after='ABC', next_line=False)
        mls.define_line_coordinates('C', 2 * n2)
        mls.define_line_coordinates('E', n2, after='ABC', next_line=False)
        mls.define_line_coordinates('B', 2 * n3)
        mls.define_line_coordinates('F', n3, after='ABC', next_line=False)

        # -------------------------------------------------------------------------------------------------------------
        # In Other Words
        # -------------------------------------------------------------------------------------------------------------
        t1.title("In other words")
        t1.explain("If A and B are similar plane numbers ...")
        mls.draw_lines('AB')
        t2.math(r"A \sim B \quad\quad (A=pq,\, B=ij\quad p:q = i:j)", is_axiom=True)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("... then the ratio of A to B can also be expressed as a ratio of two squares")
        t2.math(r"A\ratio B = x^2\ratio y^2")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # Proof
        # -------------------------------------------------------------------------------------------------------------
        t1.e_remove()
        t2.delete_last()
        t2.down()
        t1.title("Proof")
        t1.explain("Since A and B are similar plane numbers, one mean proportional number falls between them")
        mls.draw_lines("C")
        t2.math(r"A\ratio C = C\ratio B")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Let D, E, F be the least numbers that have the same ratio as A, C, B (VII.33) or (VIII.2)")
        t2.e_fade(0)
        mls.draw_lines("DEF")
        t2.math(r"D\ratio E = E\ratio F")
        t2.math(r"D\ratio F = A\ratio B \quad\quad (\text{D,F are least numbers})")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Therefore the extremes D and F are square (VIII.2.Por)")
        t2.e_fade(1,3)
        t2.math("D=x^2")
        t2.math("F=y^2")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("And A is to B as D is to F, so the ratio of A and B can be expressed as a ratio of two squares")
        t2.e_fade(2)
        t2.e_normal(3)
        t2.math(r"A\ratio B = x^2\ratio y^2")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t2.e_fade(slice(1,-1))
        t2.e_normal(0,-1)
        self.next_page()

