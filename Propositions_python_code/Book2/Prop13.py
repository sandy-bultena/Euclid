import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Scenes.book02 import Book2Scene
from euclidlib.Objects import *


class Prop13(Book2Scene):
    title = ("In acute-angled triangles the square on the side subtending the "
   "acute angle is less than the squares on the sides containing the "
   "acute angle by twice the rectangle contained by one of the sides about "
   "the acute angle, namely that on which the perpendicular falls, and the "
   "straight line cut off within by the perpendicular towards the acute angle.")

    def go(self):
        # -------------------------------------------------------------------------------------------------------------
        # Definitions
        # -------------------------------------------------------------------------------------------------------------
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(500), name="explain")
        t3 = TextBox(mn_coord(160, 450))

        A = mn_coord(260, 200)
        B = mn_coord(140, 400)
        C = mn_coord(460, 400)
        D = (A[0],B[1],0)

        BCA_Colour = SKY_BLUE
        ADC_Colour = PINK
        ABD_Colour = GREEN

        # -------------------------------------------------------------------------------------------------------------
        # In other words
        # -------------------------------------------------------------------------------------------------------------
        t1.down()
        t1.title("In other words")
        t1.explain("Given an acute triangle ABC where the acute angle is at point B and the base is BC:" )
        t1.add_marker()
        t1.explain("The square of AC equals the sum of the squares of AB and BC, less...")
        t1.explain("... twice the rectangle formed by base BC and the portion of the base, BD, "
                   "where BD is the length from the base to the perpendicular from A to the base")


        sBCA = ETriangle(B, C, A, point_labels=("B","C","A")).e_fill(BCA_Colour)
        pB, pC, pA = sBCA.p
        lBC, lCA, lAB = sBCA.l
        lAD = ELine(A,D)
        lBD = ELine(B,D, skip_anim=True)
        lDC = ELine(D,C, skip_anim=True)
        pD = EPoint(D).add_label("D",mn.DOWN)

        eq = t1.math(r"AC^2 = AB^2 + BC^2 - 2\cdot BD\cdot BC")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.down()
        t1.add_marker()
        t1.explain("Or... the cosine law")
        with self.simultaneous():
            lCA.add_label("b")
            lBC.add_label("a")
            lAB.add_label("c")
        t1.math(r"BC = a, \quad AB = c, \quad AC = b")
        aABD = EAngle(lAB, lBD, label=r"\theta", size=ANGLE_SIZE)
        t1.math(r"BD = c\cos \alpha")

        t1.math(r"b^2 = c^2 + a^2 - 2ac\cos\theta", transform_from=eq,
                transform_args=dict(key_map={'BC^2':'a^2','AB^2':'c^2', 'AC^2':'b^2', r'+ 2\cdot AD\cdot AC':r'- 2ac\cos\theta'}))
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # Proof
        # -------------------------------------------------------------------------------------------------------------
        t1.delete_until_last_marker()
        t1.delete_until_last_marker()
        eq = t1.math(r"AC^2 = AB^2 + BC^2 - 2\cdot BD\cdot BC")
        t1.down()
        t1.title("Proof")
        t1.explain("The line BC is cut at a point D, and the thus the sum of the squares of BC and BD is equal to the "
                   "square of DC plus twice the rectangle formed by BC and BD (II.7)")
        with self.simultaneous():
            lAB.remove_label()
            lBC.remove_label()
            lCA.remove_label()
            lBD.add_label("x")
            lDC.add_label("y")
        t3.math(r"BC^2 + BD^2 = DC^2 + 2\cdot BD\cdot BC", is_axiom=True)
        t3.math(r"(x+y)^2 + x^2 = y^2 + 2x(x+y)", transform_from=-1,
                transform_args=dict(key_map={
                    "BC^2":"(x+y)^2", "BD^2":"x^2", "DC^2":"y^2", r"2\cdot BD\cdot BC":"2x(x+y)"
                })
                )
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        with self.simultaneous():
            t3.delete_last()
            aABD.e_hide()
            lBD.remove_label()
            lDC.remove_label()
        t1.explain("Add the square of AD to both sides of the equality")
        with self.simultaneous():
            lAD.e_fade()
            pD.e_normal()
        t3.math(r"BC^2 + (BD^2 + AD^2) = (DC^2 + AD^2) + 2\cdot BC\cdot BD",
                transform_from=-1,
                transform_args=dict(key_map={
                    "BD^2":"(BD^2 + AD^2)", "DC^2":"(DC^2 + AD^2)",
                })
                )

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("The squares of BD and AD equals the square of AB (I.47)")
        sABD = ETriangle(A,B,D, skip_anim=True)
        with self.simultaneous():
            sBCA.e_unfill()
            sABD.e_fill(ABD_Colour)
        t3.e_fade()
        t3.math("BD^2 + AD^2 = AB^2")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t3.e_normal(-2)
        t3.math(r"BC^2 + AB^2 = (DC^2 + AD^2) + 2\cdot BC\cdot BD", transform_from=-2,
                transform_args=dict(key_map={
                    "(BD^2 + AD^2)":"AB^2",
                })
                )
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("The squares of AD and DC equals the square of AC (I.47)")
        sADC = ETriangle(A,C,C, skip_anim=True)
        with self.simultaneous():
            sABD.e_unfill()
            sADC.e_fill(ADC_Colour)
        t3.e_fade()
        t3.math("BD^2 + DC^2 = AC^2")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t3.e_normal(-2)
        t3.math(r"BC^2 + AB^2 = AC^2 + 2\cdot BC\cdot BD", transform_from=-2,
                transform_args=dict(key_map={
                    "(DC^2 + AD^2)":"AC^2",
                })
                )
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Thus the square of AC is equal to the sum of the squares of BC and AB, less the rectangle "
                   "formed by BC,BD")
        t3.e_fade()
        t3.math(r"AC^2 = BC^2 + AB^2 - 2\cdot BC\cdot BD", transform_from=-1)

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        with self.simultaneous():
            sADC.e_unfill()
            lAD.e_hide()
            lAB.add_label("c")
            lCA.add_label("b")
            lBC.add_label("a")
            lBD.add_label(r"c\cos\theta")
            pD.add_label("D",mn.UR)
            aABD.e_normal()
        t3.math(r"b^2 = a^2 + c^2 - 2ac\cos\theta", transform_from=-1,
                transform_args=dict(key_map={
                    "AC^2":"b^2", "BC^2":"a^2", "AB^2":"c^2", r"2\cdot BC\cdot BD":r"2ac\cos\theta"
                })
                )
        self.next_page()


"""


    # -------------------------------------------------------------------------
    push $steps, sub {
        $t4.explain( "Thus the square of AC is equal to the sum of the "
                 . "squares of BC and AB, less the rectangle formed by BC,BD" );
        sADC.fill();
        sACB.fill($pale_pink);
        $t3.down;
        $t3.allgrey;
        $t3.black(-1);
        $t3.math(
            "AC\{squared} = BC\{squared} "
              . "+ AB\{squared} - 2\cdot BC\cdot BD"
        );
    };

    # -------------------------------------------------------------------------
    push $steps, sub {
        $t3.allgrey;
        $t3.black(-1);
    };

    return $steps;

}


"""