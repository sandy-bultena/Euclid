import sys
import os

sys.path.append(os.getcwd())
from euclidlib.Scenes.BookScene import Book1Scene

from euclidlib.Objects import *
from typing import Dict


class Book1Prop2(Book1Scene):
    title = ("To place a straight line equal to a given straight line "
             "with one end at a given point.")

    def go(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(550))
        t2 = TextBox(mn_coord(580, 430), line_width=mn_scale(500))
        t3 = TextBox(mn_coord(800, 150), line_width=mn_scale(500))
        A = mn_coord(200, 500)
        B = mn_coord(300, 500)
        C = mn_coord(440, 400)
        D = mn_coord(250, 400)

        l: Dict[str | int, ELine] = {}
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}
        t: Dict[str | int, ETriangle] = {}

        # ------------------------------------------------------------------------
        # Construction
        # ------------------------------------------------------------------------

        t1.title("Construction:")
        t1.explain("Start with line segment AB and Point C")

        p['A'] = EPoint(A, label=('A', dict(away_from=B)))
        p['B'] = EPoint(B, label=('B', dict(away_from=A)))
        l['AB'] = ELine(p['A'], p['B'], stroke_color=BLUE)
        p['C'] = EPoint(C, label=('C', dict(away_from=A)))
        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Construct line segment AC")
        l['AC'] = ELine(p['A'], p['C'])
        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Construct an equilateral triangle on line AC (I.1)")
        t[1] = ETriangle.build_equilateral(A, C)
        p['D'] = t[1].p[-1]
        self.remove(l['AC'])
        l['AC'] = t[1].l[0]
        l['CD'] = t[1].l[1]
        l['AD'] = t[1].l[2]
        p['D'].add_label('D', away_from=t[1].get_center_of_mass())
        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Draw a circle with A as the center and AB as the radius")
        c['A'] = ECircle(A, B)
        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Label the intersection of the circle and line AD as E")
        pts = c['A'].intersect(l['AD'])
        p['E'] = EPoint(pts[0], label=('E', DL))
        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Draw a circle with D as the center and ED as the radius")
        c['A'].e_fade()
        c['D'] = ECircle(p['D'], p['E'])
        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Label the intersection of the circle and line CD as F")
        pts = c['D'].intersect(l['CD'])
        p['F'] = EPoint(pts[0], label=('F', RIGHT))
        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Line AB is equal to line CF")
        with self.simultaneous():
            c['D'].e_fade()
            l['AC'].e_fade()
            t[1].e_fade()
            l['CD'].e_fade()
            l['AD'].e_fade()
        l['CF'] = ELine(C, p['F'])
        self.next_page()

        # ------------------------------------------------------------------------
        # Proof
        # ------------------------------------------------------------------------
        t1.down()
        t1.title("Proof:")
        self.next_page()

        # ------------------------------------------------------------------------
        with self.simultaneous():
            l['CD'].e_normal()
            l['AD'].e_normal()
            p['D'].e_normal()
            l['AB'].e_fade()
            p['E'].e_remove()
            p['F'].e_remove()
            l['CF'].e_remove()

        t1.explain("Line AD is equal to line DC (equilateral triangle)")
        l['CD'].add_label("x")
        l['AD'].add_label("x")
        eq_ad_dc_x = t2.math("AD = DC = x")
        self.next_page()

        # ------------------------------------------------------------------------

        t1.explain("DE and DF are equal (radii of the same circle)")
        with self.simultaneous():
            l['AD'].green()
            l['AC'].e_fade()
            l['CD'].green()
            c['D'].e_normal()
        with self.simultaneous():
            p['E'].e_draw()
            p['F'].e_draw()
        with self.simultaneous():
            l['DE'] = ELine(p['D'], p['E'], label=('y', dict(side=LineLabelSide.INSIDE)))
            l['DF'] = ELine(p['D'], p['F'], label=('y'))
        with self.simultaneous():
            eq_ad_dc_x.e_fade()
        eq_de_df_y = t2.math("DE = DF = y")
        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("AE is the difference between DA and DE")
        with self.simultaneous():
            c['D'].e_fade()
            if 'AE' in l:
                l['AE'].e_remove()
            l['CD'].e_fade()
            l['AD'].e_fade()
            l['DE'].e_fade()

        l['AE'] = ELine(A, p['E'], label=('x-y', dict(align=RIGHT, side=LineLabelSide.INSIDE)))
        t2.e_normal()
        eq_ae_eq_ad_m_de = t2.math("AE = AD - DE")
        eq_ae_eq_x_m_y = t2.math("AE = x  - y")
        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("CF is the difference between DC and DF")
        with self.simultaneous():
            c['D'].e_fade()
            if l['CF'].in_scene():
                l['CF'].e_remove()
            l['CD'].e_fade()
            l['DF'].e_fade()

        l['CF'] = ELine(C, p['F'], label=('x-y', dict(align=LEFT)))

        with self.simultaneous():
            eq_ae_eq_ad_m_de.e_fade()
            eq_ae_eq_x_m_y.e_fade()
        eq_cf_eq_dc_m_df = t2.math("CF = DC - DF")
        eq_cf_eq_c_m_y = t2.math("CF = x  - y")
        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain(
            "AE and FC are the differences of equals, "
            "so they are equal")
        with self.simultaneous():
            l['AD'].e_fade()
            l['CD'].e_fade()
            l['DE'].e_fade()
            l['DF'].e_fade()

        with self.simultaneous():
            l['AE'].add_label('z', side=LineLabelSide.INSIDE)
            l['CF'].add_label('z')

        t2.e_fade()
        eq_ae_cf_z = t2.math("AE = CF = z")
        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("AB and AE are radii of the same circle")
        with self.simultaneous():
            c['A'].e_normal()
            l['AB'].e_normal()
            l['AD'].e_fade()
            l['CD'].e_fade()
            l['CF'].e_fade()

        l['AB'].add_label('z')
        t2.e_fade()
        eq_ab_ae_z = t2.math("AB = AE = z")
        self.next_page()

        # ------------------------------------------------------------------------
        with self.simultaneous():
            c['A'].e_fade()
            l['AD'].e_fade()
            l['AE'].e_fade()
            l['CF'].e_normal()

        t1.explain("AB and CF are equal")
        with self.simultaneous():
            eq_ae_cf_z.e_normal()
            eq_ab_ae_z.e_normal()
        eq_ab_cf_z = t2.math("AB = CF = z")
        self.next_page()

        # ------------------------------------------------------------------------
        self.next_page()
        with self.simultaneous():
            eq_ae_cf_z.e_fade()
            eq_ab_ae_z.e_fade()

        # ------------------------------------------------------------------------
        # clean and do second construction
        # ------------------------------------------------------------------------
        with self.simultaneous(run_time=1):
            t1.e_remove()
            t2.e_remove()
            for group in (p, l, c, t):
                for obj in group.values():
                    obj.e_remove()
                group.clear()

        t3.title("But what if?")
        t3.explain("Start with line segment AB and point C")
        p['A'] = EPoint(A, label=('A', dict(away_from=B)))
        p['B'] = EPoint(C, label=('B', dict(away_from=A)))
        l['AB'] = ELine(p['A'], p['B'], stroke_color=BLUE)
        p['C'] = EPoint(D, label=('C', dict(away_from=A)))
        self.next_page()

        # ------------------------------------------------------------------------
        t3.explain("Construct line segment AC")
        l['AC'] = ELine(A, D)
        self.next_page()

        # ------------------------------------------------------------------------
        t3.explain("Construct an equilateral triangle on line AC")
        t[2] = ETriangle.build_equilateral(A, D)
        p['D'] = t[2].p[-1]
        with self.simultaneous():
            l['AD'] = t[2].l[2]
            l['CD'] = t[2].l[1]
            p['D'].add_label('D', away_from=t[2].get_center_of_mass())
        self.next_page()

        # ------------------------------------------------------------------------
        t3.explain("Draw a circle with A as the center and AB as the radius")
        c['A'] = ECircle(A, C)
        self.next_page()

        # ------------------------------------------------------------------------
        t3.explain("Label the intersection of the circle and line AD as E ")
        t3.explain("  ...hang on... there isn't any intersection point, what now?")
        self.next_page()

        # ------------------------------------------------------------------------
        t3.explain("Extend DA and DC such that they intersect the circle")
        l['AD'].extend(mn_scale(400))
        l['CD'].prepend(mn_scale(400))
        self.next_page()

        # ------------------------------------------------------------------------
        t3.explain("Label the intersection of the circle and line AD as E")
        pts = c['A'].intersect(l['AD'])
        p['E'] = EPoint(pts[0], label=('E', RIGHT))
        self.next_page()

        # ------------------------------------------------------------------------
        c['A'].e_fade()
        t3.explain("Draw a circle with D as the center and ED as the radius")
        c['D'] = ECircle(p['D'], p['E'])
        self.next_page()

        # ------------------------------------------------------------------------
        t3.explain("Label the intersection of the circle and line CD as F")
        pts = c['D'].intersect(l['CD'])
        p['F'] = EPoint(pts[0], label=('F', RIGHT))
        self.next_page()

        # ------------------------------------------------------------------------
        with self.simultaneous():
            c['D'].e_fade()
            t[2].e_fade()
            l['AC'].e_fade()
            l['CD'].e_fade()
            l['AD'].e_fade()

        t3.explain("Line AB is equal to line CF")
        l['CF'] = ELine(D, p['F'])
        self.next_page()

        # ------------------------------------------------------------------------
        # Proof
        # ------------------------------------------------------------------------
        t3.down()
        t3.title("Proof:")
        self.next_page()

        # ------------------------------------------------------------------------
        t3.explain("... I will leave it to the reader to prove ...")
        self.next_page()

        # ------------------------------------------------------------------------
        with self.simultaneous():
            t3.e_remove()
        with self.simultaneous():
            for group in (p, l, c, t):
                for obj in group.values():
                    obj.e_remove()
                group.clear()
