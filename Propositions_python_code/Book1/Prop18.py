import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Scenes.BookScene import Book1Scene
from euclidlib.Objects import *
from typing import Dict


class Prop18(Book1Scene):
    steps = []
    title = "A greater side of a triangle is opposite a greater angle."

    def go(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(550))
        t2 = TextBox(mn_coord(475, 430))

        l: Dict[str | int, ELine] = self.l
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}
        t: Dict[str | int, ETriangle] = {}
        a: Dict[str | int, EAngleBase] = {}
        eq: Dict[str | int, EStringObj] = {}

        A = mn_coord(75, 150)
        B = mn_coord(100, 400)
        C = mn_coord(350, 400)
        D = mn_coord(450, 450)

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        t1.title("In other words:")
        t1.explain("Given a triangle ABC")
        t['ABC'] = ETriangle(
            A,B,C,
            point_labels='ABC',
            angles=(r'\alpha', (r'\beta',mn_scale(60)), r'\gamma'),
            labels=[None, 'a', 'b']
        )
        a['a'], a['b'], a['c'] = t['ABC'].a
        l['AB'], l['BC'], l['AC'] = t['ABC'].l
        p['A'], p['B'],p['C'] = t['ABC'].p

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("If line AC is greater than BC, "
                   "then angle ABC is greater than BAC")
        t2.math(r'b > a\ \implies \beta > \alpha')

        self.next_page()

        # ------------------------------------------------------------------------
        # Proof
        # ----------------------------------------------
        t2.e_remove()
        #t2.down()
        t2.math(r'AC > BC', is_axiom=True)
        t1.down()
        t1.title("Proof:")

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Create point D on line AC, such that CD equals BC")
        c['C'] = ECircle(C, B)
        pts = c['C'].intersect(l['AC'])
        p['D'] = EPoint(pts[0], label=('D', l['AC'].OUT()))
        D=p['D'].coordinates
        c['C'].e_remove()
        l['CD'], l['AD'] = l['AC'].e_split(p['D'])
        with self.simultaneous():
            l['CD'].add_label('a')
            l['AC'].remove_label()
        t2.math('DC = BC')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Create line BD")
        t1.explain("The angle CDB is an exterior angle to triangle ADB, "
                   "thus angle CDB is greater than angle DAB (I.16)")

        with self.simultaneous():
            a['b'].e_fade()
            a['c'].e_fade()

        l['BD'] = ELine(B,D)
        t['ABD'] = ETriangle.assemble(
            lines=[l['AB'], l['BD'], l['AD']],
            angles=[a['a'], None, None]
        )

        t['DBC'] = ETriangle.assemble(
            lines=[l['BD'], l['BC'], l['CD']],
            angles=[None, None, a['c']]
        )

        t['DBC'].set_angles(r'\theta', None, None)
        a['th'] = t['DBC'].a[0]

        with self.simultaneous():
            t['DBC'].e_fade()
            t['ABC'].e_fade()
            t['ABD'].e_normal()
            a['th'].e_normal()
            a['a'].e_normal()
            p['A'].e_normal()
            p['B'].e_normal()
            l['CD'].e_normal()
            p['C'].e_normal()

        t['ABD'].e_fill(BLUE_D)
        t2.math(r'\theta > \alpha')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("The triangle BCD is an isosceles triangle, "
                   "thus angles CDB and DBC are equal (I.5)")
        with self.simultaneous():
            #t['ABD'].e_fade()
            t['DBC'].e_normal()
            t['ABD'].a[0].e_normal()
            #a['a'].e_fade()
            #p['A'].e_fade()
        t['DBC'].set_angles(None, (r'\theta', mn_scale(15)), None)
        with self.simultaneous():
            t['DBC'].e_fill(GREEN_E)

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Angle ABC is greater than angle DBC, "
                   "so angle ABC is greater than angle BAC")
        #t['DBC'].e_unfill()
        with self.simultaneous():
            p['A'].e_normal()
            a['a'].e_normal()
            l['AB'].e_normal()
            l['AD'].e_normal()
            a['c'].e_fade()
            a['b'].e_normal()
        t2.math(r'\beta > \theta > \alpha')

        self.next_page()

        # ------------------------------------------------------------------------
        with self.simultaneous():
            t2.e_fade(slice(1,-1))
        t2.down()
        t2.math(r'\therefore\ \beta > \alpha')
        self.next_page()

        # ------------------------------------------------------------------------
        with self.simultaneous():
            t['ABD'].e_remove()
            t['DBC'].e_remove()
            p['D'].e_remove()
            a['a'].e_remove()
            a['b'].e_remove()
            a['c'].e_remove()
            # l['BC'].remove_label()
        with self.skip_animations_for():
            t['ABC'].e_normal()
            l['AC'].add_label('b')
        with self.simultaneous():
            with self.freeze(a['c']):
                t['ABC'].e_draw()
        with self.simultaneous():
            t2.e_fade(slice(1,-1))
        t2.down()
