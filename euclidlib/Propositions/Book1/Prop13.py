import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *
from typing import Dict


class Prop13(Book1Scene):
    steps = []
    title = ("If a straight line stands on a straight line, "
             "then it makes either two right angles or angles "
             "whose sum equals two right angles.")

    def go(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(550))
        t2 = TextBox(mn_coord(50, 500))
        t3 = TextBox(mn_coord(150, 450))

        l: Dict[str | int, ELine] = self.l
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}
        t: Dict[str | int, ETriangle] = {}
        a: Dict[str | int, EAngleBase] = {}
        eq: Dict[str | int, EStringObj] = {}

        D = mn_coord(100, 400)
        C = mn_coord(450, 400)
        A = mn_coord(400, 150)
        B = mn_coord(300, 400)

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        t1.title("In other words:")
        t1.explain("Start with an arbitrary line segment CD "
                   "and an arbitrary point B on the line")
        p['D'] = EPoint(D, label=('D', LEFT))
        p['C'] = EPoint(C, label=('C', RIGHT))
        l['CD'] = ELine(D,C)
        p['B'] = EPoint(B, label=('B', DOWN))
        l['BD'], l['BC'] = l['CD'].e_split(p['B'])

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Draw a line from point an arbitrary point A to point B")
        p['A'] = EPoint(A, label=('A', UP))
        l['AB'] = ELine(A,B)

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("The sum of the angles ABD and ABC is equal to two right angles")
        a['alpha'] = EAngle(*self.lines('ABD'), size=mn_scale(70), label=r'\alpha')
        a['beta'] = EAngle(*self.lines('CBA'), size=mn_scale(80), label=r'\beta')
        t2.math(r'\angle DBA + \angle ABC = 2 \rightangle')

        t2.math(r'\alpha + ', align_str='+')
        t2.math(r'\beta = 2 \rightangle', align_str=r'= 2', align_index=-2)

        self.next_page()

        # ------------------------------------------------------------------------
        # Proof
        # ----------------------------------------------
        t2.e_remove()
        t1.down()
        t1.title("Proof:")
        with self.simultaneous():
            a['alpha'].e_fade()
            a['beta'].e_fade()
            l['AB'].e_fade()
        t1.explain("Construct a perpendicular line to point E (I.11)")
        l['BE'] = l['CD'].perpendicular(p['B'])
        p['E'] = EPoint(l['BE'].get_end(), label=('E', UP))
        a['gamma'] = EAngle(*self.lines('CBE'), label=r'\gamma')
        a['epsilon'] = EAngle(*self.lines('EBD'), size=mn_scale(20), label=r'\epsilon')
        t1.explainM(r'1. Angles $\gamma$ and $\epsilon$ are right angles')
        eq['1'], = t3.math(r'1.\quad\quad\quad\epsilon = \gamma')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explainM(r'2. Angle $\gamma$ is the sum of angles $\beta$ and $\theta$')
        with self.simultaneous():
            a['alpha'].e_fade()
            a['epsilon'].e_fade()
            a['beta'].e_normal()
            l['AB'].e_normal()
        a['theta'] = EAngle(*self.lines('ABE'), size=mn_scale(90), label=r'\theta')

        eq['2-1'], = t3.math(r'2.')
        eq['2-2'], = t3.math(r'\gamma = \beta + \theta', align_str=r'=', align_index=-2)

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explainM(r'3. Add angle $\epsilon$ to $\gamma$ and to $\theta$ plus $\beta$')
        a['epsilon'].e_normal()
        eq['3-1'], = t3.math(r'3.')
        with self.simultaneous():
            eq['3-2'], = t3.math(
                r'\epsilon + \gamma',
                align_str=r'\gamma',
                align_index=eq['2-2'],
                transform_from=eq['2-2'],
                transform_args=dict(
                    matched_keys=[r'\gamma'],
                ),
                )
            eq['3-3'], = t3.math(
                r'= \beta + \theta + \epsilon',
                align_str=r'=',
                align_index=eq['2-2'],
                transform_from=eq['2-2'],
                transform_args=dict(
                    matched_keys=[r'\beta + \theta', r'='],
                ),
                )

        self.next_page()

        # ------------------------------------------------------------------------
        with self.simultaneous():
            a['alpha'].e_normal()
            l['BE'].e_normal()
            a['beta'].e_fade()
            a['gamma'].e_fade()

        t3.down()

        t1.explainM(r'4. Angle $\alpha$ is the sum of angles $\theta$ and $\epsilon$')
        eq['4-1'], = t3.math(r'4.')
        print(f"Equation 4-1 = {eq['4-1']}")
        with self.simultaneous():
            eq['4-3'] = t3.math(r'= \theta + \epsilon',
                                align_str='=',
                                align_index=eq['3-3'],
                                #transform_from=eq['3-3'],
                                #transform_args=dict(matched_keys=[r'\theta + \epsilon', '='], ),
                                )[-1].next_to(eq['4-1'], RIGHT, coor_mask=UP)
            eq['4-2'] = t3.math(r'\alpha',
                                align_str=(r'\gamma', r'\alpha'),
                                align_index=eq['3-2'],
                                )[-1].align_to(eq['4-3'], DOWN)

        self.next_page()

        # ------------------------------------------------------------------------
        a['beta'].e_normal()

        t1.explainM(r'5. Add angle $\beta$ to $\alpha$ and to $\theta$ plus $\epsilon$')
        eq['5-1'], = t3.math(r'5.')
        with self.simultaneous():
            eq['5-2'], = t3.math(
                r'\beta + \alpha', align_str=r'\alpha',
                align_index=eq['4-2'],
                transform_from=eq['4-2'],
                transform_args=dict(matched_keys=[r'\alpha']),
                )
            eq['5-3'], = t3.math(
                r'= \beta + \theta + \epsilon',
                align_str=r'=',
                align_index=eq['4-3'],
                transform_from=eq['4-3'],
                transform_args=dict(matched_keys=[r'\theta + \epsilon', '=']),
                )
            eq['5-2'].align_to(eq['5-3'], DOWN)

        self.next_page()

        # ------------------------------------------------------------------------
        a['gamma'].e_normal()

        t1.explainM("6. From equations 3 and 5, we have the sums of two angles "
                    r"equal to the sum of $\beta$, "
                    r"$\theta$ and $\epsilon$")
        with self.simultaneous():
            eq['3-3'].red()
            eq['5-3'].red()
        t1.explain("And since things that equal the"
                   " same thing equal each other...")
        with self.simultaneous():
            eq['3-2'].blue()
            eq['5-2'].blue()
        t1.explainM(r"The sum of $\beta$ and $\alpha$ equals the sum of the"
                    r" two right angles, $\gamma$ and~$\epsilon$")


        with self.simultaneous():
            eq['6-1'], = t3.math(r'6.')
            eq['6-2'], = t3.math(
                r'\beta + \alpha', align_str=r'\alpha',
                align_index=-3,
                transform_from=eq['5-2'],
                transform_args=dict(matched_keys=[r'\beta + \alpha']),
                t2c={r'\beta + \alpha': BLUE},
                )
            eq['6-3'] = t3.math(
                r'= \epsilon + \gamma',
                align_str=r'=',
                align_index=eq['5-3'],
                transform_from=eq['3-2'],
                t2c={r'\epsilon + \gamma': BLUE},
                )[-1].align_to(eq['6-2'], DOWN)
            eq['6-4'] = t3.math(
                r'= 2\ \rightangle',
                )[-1].next_to(eq['6-3'], RIGHT, buff=SMALL_BUFF)

        self.next_page()

        # ------------------------------------------------------------------------
        t3.down()
        a['epsilon'].e_fade()
        a['gamma'].e_fade()
        a['theta'].e_fade()
        l['BE'].e_fade()
        t3.math(r'\angle ABC + \angle ABD = 2\ \rightangle')
