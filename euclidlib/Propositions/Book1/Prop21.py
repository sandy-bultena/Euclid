import sys
import os

from manimlib import Mobject

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *
from typing import Dict


class Prop21(Book1Scene):
    steps = []
    title = ("I")
    # title = ("If from the ends of one of the sides of a triangle two straight lines "
    #          "are constructed meeting within the triangle, then the sum of the "
    #          "straight lines so constructed is less than the sum of the remaining "
    #          "two sides of the triangle, but the constructed straight lines contain "
    #          "a greater angle than the angle contained by the remaining two sides.")

    def go(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(550))
        t2 = TextBox(mn_coord(375, 200))
        t3 = TextBox(mn_coord(300, 250))

        l: Dict[str | int, ELine] = {}
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}
        t: Dict[str | int, ETriangle] = {}
        a: Dict[str | int, EAngleBase] = {}
        eq: Dict[str | int, EStringObj | Tuple[EStringObj, ...]] = {}
        ex: Dict[str | int, Mobject] = {}

        A = mn_coord(200, 200)
        B = mn_coord(25, 600)
        C = mn_coord(400, 600)
        D = mn_coord(215, 400)

        # TESTING
        line_property = ELine(A,B)
        line_method = ELine(A,C)
        line_property.green
        line_property.green()
        self.next_page()
        eq[1] = t2.math(r'c_1 + b_3\quad\quad\quad\quad >\ c_2 + c_3')
        t2.math("x=y")
        print()
        print(f"All super classes of eq1: \n{eq[1].__class__.__mro__}")
        print()
        print("*** Property green")
        eq[1].green
        self.next_page()
        print()
        print("*** Method green")
        eq[1].green()
        self.next_page()
        print()
        print("*** TextBox Method blue")
        x=t2.blue(1 )
        # print()
        # print(f"x=")
        # print()
        # z = t2.red(1)
        # print(f"z=",z)
        # #t2.red(2)
        self.next_page()
        t2.blue(35)
        with self.simultaneous():
            eq[2] = t2.math(r'c_1 + b_3 + b_4 >\ c_2 + c_3 + b_4 bananas',
                            break_into_parts=('c_1 + b_3 + b_4', (r'>\ c_2 + c_3 + b_4', {"align_str":">"})
                                              )
                            )
        eq[3] = t2.math("hello")
        eq[4] = t2.math("salut")
        eq[2].blue()
        eq[2].parts[1].red()
        eq[3].green()



        # eq[1] = t2.math(r'c_1 + b_3\quad\quad\quad\quad >\ c_2 + c_3',
        #                 break_into_parts=('c_1 + b_3', r'>\ c_2 + c_3'))
        # print(f"eq[1][0] = {eq[1][0]}")
        # print(f"eq[1][1] = {eq[1][1]}")
        # self.next_page()
        # eq[2] = t2.math(r'c_1 + b_3 + b_4 >\ c_2 + c_3 + b_4',
        #                  break_into_parts=(
        #                      'c_1 + b_3 + b_4',
        #                      (r'>\ c_2 + c_3 + b_4', dict(align_to_args=(eq[1][1],LEFT))),
        #                  )
        #                  )
        t2.explain("All done")
        self.next_page()
        t2.explain("next page")
        #eq[2][1].align_to(eq[1][1])
        self.next_page()




        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        t1.title("In other words:")
        t1.explain("Given a triangle ABC")
        t['ABC'] = ETriangle(
            A,B,C,
            point_labels='ABC',
            labels='c_1 a b_1'.split()
        )
        t['ABC'].e_fill(BLUE_D)

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("From a point within the triangle ABC...")
        p['D'] = EPoint(D)

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("... construct a second triangle DBC")
        t['DBC'] = ETriangle(
            D,B,C,
            point_labels=(('D', dict(away_from=C)), None, None),
            labels='c_2 a b_2'.split()
        )
        t['DBC'].e_fill(TEAL_D)

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("The sum of the lines BD and DC is less than the sum of "
                   "the lines BA and AC, and the angle BDC is greater than angle BAC")
        with self.simultaneous():
            t['ABC'].set_angles(r'\alpha')
            t['DBC'].set_angles(r'\theta')

        t2.math(r'c_1 + b_1 > c_2 + b_2')
        t2.math(r'\theta\ >\ \alpha', align_str='>')

        self.next_page()

        # ------------------------------------------------------------------------
        # Proof
        # ----------------------------------------------
        with self.simultaneous(run_time=1):
            t2.e_remove()
            t1.e_remove()
        t1.title("Proof:")

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Extend BD such that it intersects AC at point E")
        with self.simultaneous():
            t['ABC'].e_unfill()
            t['DBC'].e_unfill()
        with self.simultaneous():
            t['ABC'].a[0].e_fade()
            t['ABC'].l[0].e_fade()
            t['ABC'].l[1].e_fade()
            t['DBC'].a[0].e_fade()
            t['DBC'].l[1].e_fade()
            t['DBC'].l[2].e_fade()

        l['BX'] = t['DBC'].l[0].copy().prepend(mn_scale(200))
        pts = l['BX'].intersect(t['ABC'].l[2])
        p['E'] = EPoint(pts, label=('E', RIGHT))

        l['EX'], l['BE'] = l['BX'].e_split(p['E'])
        l['DE'], l['BD'] = l['BE'].copy().e_split(t['DBC'].p[0])

        l['EX'].e_fade()

        # split line AC at point E
        l['AC'] = t['ABC'].l[2].copy()
        l['CE'], l['AE'] = l['AC'].e_split(p['E'])

        # define new triangles

        t['EDC'] = ETriangle.assemble(lines=[l['DE'], t['DBC'].l[2], l['CE']])
        t['EDC'].set_labels('c_3', (), 'b_4')

        t['ABE'] = ETriangle.assemble(
            lines=[t['ABC'].l[0], l['BE'], l['AE']],
            angles=[t['ABC'].a[0], None, None]
        )
        t['ABE'].set_labels((), (), 'b_3')

        b1 = t['ABC'].l[2]
        b1.add_label('b_1', outside=True, buff=ELine.LabelBuff * 2 + MED_LARGE_BUFF)
        ex['b1'] = mn.Brace(b1, direction=b1.OUT(), buff=ELine.LabelBuff * 2)
        self.play(mn.FadeInFromPoint(ex['b1'], point=b1.e_label.get_center()))
        b1.freeze()

        t2.math('b_1 = b_3 + b_4')

        self.next_page()

        # ------------------------------------------------------------------------
        l['EX'].e_remove()
        t1.explain("Consider triangle ABE")
        t1.explain("The sum of lines AB and AE is greater than BE (I.18)")
        with self.simultaneous():
            t['DBC'].e_fade()
            t['ABC'].e_fade()
            t['EDC'].e_fade()
            t['ABE'].e_normal()
            t['ABC'].p[0].e_normal()
            t['ABC'].p[1].e_normal()
            t['DBC'].l[0].e_normal()
            t['EDC'].l[0].e_normal()

        t['ABE'].e_fill(PURPLE)
        t2.e_fade()
        eq[1] = t2.math(r'c_1 + b_3\quad\quad >\ c_2 + c_3',
                        break_into_parts=('c_1 + b_3', r'>\ c_2 + c_3'))

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Add length EC to both each part of the inequality")
        with self.simultaneous():
            # ****** WTF, why can l[2] call e_normal() in one case but not the other???
            t['EDC'].l[2].e_normal
            t['ABC'].l[2].e_normal
            t['ABC'].p[2].e_normal

        eq[2] = t2.math(r'c_1 + b_3 + b_4 >\ c_2 + c_3 + b_4',
                         break_into_parts=(
                             'c_1 + b_3 + b_4',
                             (r'>\ c_2 + c_3 + b_4',{'align_to':eq[1][1]})),
                         )

        """
                eq['6-4'] = t3.math(
                r'= 2\ \rightangle',
                )[-1].next_to(eq['6-3'], RIGHT, buff=SMALL_BUFF)
        """
        # self.set_base_animation_speed(1)
        # x = t2.math(r'c_1 + b_3 + b_4')[-1]
        # y= t2.math(r'>\ c_2 + c_3 + b_4')[-1].align_to(eq[1][1],LEFT).next_to(x, RIGHT, buff=SMALL_BUFF)
        # eq[2] = (x,y)
        # eq[2] = t2.math_align_to(txt=r'c_1 + b_3 + b_4 >\ c_2 + c_3 + b_4',
        #                            break_into_parts=('c_1 + b_3 + b_4', r'>\ c_2 + c_3 + b_4'),
        #                            which_part = 1,
        #                            aligned_to=eq[1][1],
        #                            side=LEFT)
        # eq[2] = t2.math(r'c_1 + b_3 + b_4 >\ c_2 + c_3 + b_4',
        #                 break_into_parts=('c_1 + b_3 + b_4', r'>\ c_2 + c_3 + b_4'),
        #                 delay_anim=True)
        # Calling ETex: >\ c_2 + c_3 + b_4.align_to(ETex: >\ c_2 + c_3, [-1.  0.  0.])
        # Calling ETex: >\ c_2 + c_3 + b_4.align_to(ETex: >\ c_2 + c_3, [-1.  0.  0.]
        # print(f"Calling {eq[2][1]}.align_to({eq[1][1]},{LEFT}")
        # eq[2][1].align_to(eq[1][1], LEFT)
        # self.play(mn.Write(mn.VGroup(*eq[2][0:2])))
        # self.add(*eq[2][0:2])


        t2.explain("STOP")

        self.next_page()

        # ------------------------------------------------------------------------
        with self.simultaneous():
            t2.e_fade()
            t2.e_normal(0)
            t2.e_normal[-3:-1]()
        eq[3] = t2.math(r'c_1 + b_1 >\ c_2 + c_3 + b_4',
                        break_into_parts=('c_1 + b_1', r'>\ c_2 + c_3 + b_4'),
                        delay_anim=True)
        eq[3][1].align_to(eq[1][1], LEFT)
        with self.simultaneous():
            eq[3][0].transform_from(eq[2][0])
            eq[3][1].transform_from(eq[2][1])

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Consider triangle DEC")
        t1.explain("The sum of lines DE and EC is greater than CD (I.18)")
        with self.simultaneous():
            t['ABE'].e_fade()
            p['D2'] = EPoint(D, label=('D', dict(away_from=C)))
            t['DBC'].l[0].e_fade()
            l['BD'].e_fade()
            t['EDC'].e_normal()
        t['EDC'].e_fill(PINK)

        with self.simultaneous():
            t2.e_fade()

        eq[4] = t2.math(r'c_3 + b_4\ >\quad\quad\ b_2',
                        break_into_parts=(r'c_3 + b_4\ >', r'b_2'),
                        align_str=r'c_3 + b_4',
                        align_index=eq[3][1])

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Add BD to both sides of the inequality")
        with self.simultaneous():
            l['BD'].e_normal()
            t['DBC'].l[0].e_normal()
        eq[5] = t2.math(r'c_2 + c_3 + b_4\ >\ c_2 + b_2',
                        break_into_parts=(r'c_2 + c_3 + b_4\ >', r'c_2 + b_2'),
                        align_str=r'c_3 + b_4\ >',
                        delay_anim=True)
        eq[5][1].align_to(eq[4][1], RIGHT)
        self.play(mn.Write(mn.VGroup(*eq[5][0:2])))
        self.add(*eq[5][0:2])

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Thus, the sum of AB and AC is greater than the sum of "
                   "DB and DC")
        with self.simultaneous():
            t['ABE'].e_fade()
            t['EDC'].e_fade()
            t['ABC'].e_normal()
            t['DBC'].e_normal()

        self.play(mn.FadeOut(ex['b1']))
        t['ABC'].l[2].unfreeze()
        t['ABC'].l[2].add_label('b_1', outside=True)

        with self.simultaneous(run_time=1):
            t2.e_fade()
            eq[3][0].e_normal()
            eq[3][1].e_normal()
            eq[5][0].e_normal()
            eq[5][1].e_normal()

        p['D2'].e_delete()

        eq[6] = t2.math(r'c_1 + b_1\ >\ c_2 + b_2',
                        break_into_parts=(r'c_1 + b_1', '>', r'c_2 + b_2'),
                        align_str=r'>',
                        delay_anim=True)
        left, op, right, _ = eq[6]
        self.wait(0.5)
        with self.simultaneous(run_time=2):
            left.transform_from(eq[3][0])
            right.transform_from(eq[5][1])
            op.transform_from(mn.VGroup(
                eq[3][1]['c_2 + c_3 + b_4'],
                eq[5][0]['c_2 + c_3 + b_4'],
            ))

        self.next_page()

        # ------------------------------------------------------------------------
        with self.simultaneous():
            t2.e_fade()
            eq[6][0].blue.e_normal()
            eq[6][1].blue.e_normal()
            eq[6][2].blue.e_normal()

        self.next_page()

        # ------------------------------------------------------------------------
        t1.down()
        t2.down()
        t1.explain("Angle BDC is an exterior angle to triangle DCE, hence "
                   "it is larger than the angle DEC (I.16)")
        with self.simultaneous():
            t['ABE'].e_fade()
            t['ABC'].e_fade()
            t['DBC'].e_fade()
            t['EDC'].e_normal()#.remove_labels()
            t['DBC'].a[0].e_normal()
            t['EDC'].set_angles(r'\epsilon', None, None, mn_scale(20))
            for pts in t['ABC'].p:
                pts.e_normal()

        with self.simultaneous():
            t2.e_fade()
        t2.indent(LARGE_BUFF)
        eq[7] = t2.math(r'\theta > \epsilon')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Angle DEC is an exterior angle to triangle EAB, hence "
                   "it is larger than the angle EAB (I.16)")
        with self.simultaneous():
            t['ABC'].e_fade()
            t['DBC'].e_fade()
            t['EDC'].e_fade()
            t['ABE'].e_normal()
            t['ABE'].a[0].e_normal()
            for pts in t['ABC'].p:
                pts.e_normal()

        eq[8] = t2.math(r'\epsilon > \alpha', align_str=r'\epsilon')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Thus, angle BDC is greater than angle ABC")
        eq[9] = t2.math(r'\theta > \alpha',
                        break_into_parts=(r'\theta', '>', r'\alpha'),
                        delay_anim=True)
        left, op, right, _ = eq[9]
        self.wait(0.5)
        left.align_to(eq[7][r'\theta'], LEFT)
        op.next_to(eq[8][r'\epsilon'], DOWN, coor_mask=RIGHT)
        right.align_to(eq[8][r'\alpha'], LEFT)
        with self.simultaneous(run_time=2):
            left.transform_from(eq[7], r'\theta')
            right.transform_from(eq[8], r'\alpha')
            op.transform_from(mn.VGroup(
                eq[7][r'\epsilon'],
                eq[8][r'\epsilon'],
            ))

        self.next_page()

        # ------------------------------------------------------------------------
        with self.simultaneous():
            t['ABC'].e_normal()
            t['DBC'].e_normal()
        with self.freeze(*t['ABC'].get_group(), *t['DBC'].get_group()):
            with self.simultaneous():
                t['EDC'].e_remove()
                t['ABE'].e_remove()
                p['E'].e_remove()

        with self.simultaneous():
            t['ABC'].e_fill(BLUE_D)
            t['DBC'].e_fill(TEAL_D)

        with self.delayed():
            t2.e_fade()
            eq[6][0].e_normal()
            eq[6][1].e_normal()
            eq[6][2].e_normal()
            eq[9][0].blue.e_normal()
            eq[9][1].blue.e_normal()
            eq[9][2].blue.e_normal()


