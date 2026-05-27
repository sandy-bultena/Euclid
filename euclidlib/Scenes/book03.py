# =====================================================================================================================
# Book 3
# =====================================================================================================================
from euclidlib.Scenes.BookScene import BookScene
from euclidlib.Scenes.table_of_contents import TOC, TOCEntry
from euclidlib.Objects import *
from euclidlib.CONSTANTS import *
from euclidlib.Scenes.animate_state import AnimState
DEG = mn.PI/180


class Book3Scene(BookScene):

    def title_page(self):

            title_box = TextBox(mn_coord(600, 400, 0),
                                alignment='e'
                                )
            with self.simultaneous():
                super().title_page()

                with self.pause_animations_for() as draw:
                    title_box.fancy("A circle is a round straight line with a hole in the middle.", font_size=24,
                                    write_simultaneous=True)
                    title_box.indent()
                    title_box.explain("""<b>Mark Twain</b>, quoting a schoolchild in "-English as She Is Taught-" """, font_size=16)

                    title_box.unindent()
                    title_box.down()
                    title_box.down()
                    title_box.fancy("If people stand in a circle long enough, "
                                    "they'll eventually begin to dance.", font_size=24, write_simultaneous=True)
                    title_box.indent()
                    title_box.explain("""
                    <b>George Carlin</b>, Napalm and Silly Putty (2001)
                    """, font_size=16)
                    #title_box[-1].align_to(title_box[-2], mn.RIGHT)
                    draw.append(title_box)

                c1 = mn_coord(260, 360)
                r1 = mn_scale(180)
                c2 = c1 + mn_scale(80, 0, 0)

                with self.pause_animations_for() as draw:
                    cA = ECircle(c1, c1 + r1 * mn.RIGHT)
                    pE = EPoint(c1, label=('E', mn.DL))
                    pF = EPoint(c2, label=('F', mn.DR))

                    pA = cA.e_point_at_angle(mn.PI).add_label('A', away_from=c2)
                    lFA = ELine(c2, pA)

                    pD = cA.e_point_at_angle(0).add_label('D', away_from=c2)
                    lFD = ELine(c2, pD)

                    pB = cA.e_point_at_angle(140 * DEG).add_label('B', away_from=c2)
                    lFB = ELine(c2, pB)

                    pC = cA.e_point_at_angle(100 * DEG).add_label('C', away_from=c2)
                    lFC = ELine(c2, pC)

                    pG = cA.e_point_at_angle(mn.PI/4).add_label('G', away_from=c2)
                    lFG = ELine(c2, pG)

                    pH = cA.e_point_at_angle(-mn.PI/4).add_label('H', away_from=c2)
                    lFH = ELine(c2, pH)

                    draw.extend([cA, pE, pF, pA, lFA, pD, lFD, pB, lFB, pC, lFC, pG, lFG, pH, lFH])
                    draw.append(ELine(pB, pE))
                    draw.append(ELine(pC, pE))
                    draw.append(ELine(pG, pE))
                    draw.append(ELine(pH, pE))

    def next_page_func(self):
        self.next_page()
        self.clear()

    def draw_table_of_contents(self, index=0):
        toc = TOC3("Table of Contents - Book 2", y_padding=0.35, next_page_func=self.next_page_func)
        self.animateState.append(AnimState.SKIP)
        toc.draw(self.prop)
        self.animateState.pop()


class TOC3(TOC):
    def __init__(self,title,book='III', **kwargs):
        super().__init__(title,book, **kwargs)

        self.add_entry(TOCEntry(1,"To find the centre of a circle"))
        self.add_entry(TOCEntry(2,"A chord of a circle always lies inside the circle"))
        self.add_entry(TOCEntry(3,"A line through the centre of a circle bisects a chord, and vice versa"))
        self.add_entry(TOCEntry(4,"A line not through the centre of a circle does not bisect a chord"))
        self.add_entry(TOCEntry(5,"If two circles cut one another, they will not have the same center"))
        self.add_entry(TOCEntry(6,"If two circles touch one another, they will not have the same center"))
        self.add_entry(TOCEntry(7,"Consider two lines from a point inside a circle to the edge, the longer one will be the one closest to the longest part of the diameter passing through the original point"))
        self.add_entry(TOCEntry(8,"Consider two lines from a point outside a circle to the edge, the line closest to the centre will be longer on the concave side and shorter on the convex side"))
        self.add_entry(TOCEntry(9,"If three lines, starting at a point 'A' and touching the circle, are all equal, then 'A' is the centre of the circle"))
        self.add_entry(TOCEntry(10,"A circle does not cut a circle at more points than two"))
        self.add_entry(TOCEntry(11,"Point of contact between two internal circles, and their centres, are collinear"))
        self.add_entry(TOCEntry(12,"Point of contact between two external circles, and their centres, are collinear"))
        self.add_entry(TOCEntry(13,"A circle does not touch a circle at more points than one, whether it touch it internally or externally."))
        self.add_entry(TOCEntry(14,"In a circle equal straight lines are equally distant from the centre, and those which are equally distant from the centre are equal to one another."))
        self.add_entry(TOCEntry(15,"The longest line in a circle is its diameter, shorter the farther away from the diameter"))
        self.add_entry(TOCEntry(16,"A line on the circle, perpendicular to the diameter, lies outside the circle"))
        self.add_entry(TOCEntry(17,"From a given point to draw a straight line touching a given circle"))
        self.add_entry(TOCEntry(18,"If line touches a circle, then it is perpendicular to the diameter that touches that point"))
        self.add_entry(TOCEntry(19,"If line touches a circle, then the centre of the circle lies on a line perpendicular to the original"))
        self.add_entry(TOCEntry(20,"The angle at the centre of a circle is twice that from an angle from the circumference"))
        self.add_entry(TOCEntry(21,"In a circle the angles in the same segment are equal to one another"))
        self.add_entry(TOCEntry(22,"The opposite angles of quadrilaterals in circles are equal to two right angles"))
        self.add_entry(TOCEntry(23,"On the same straight line there cannot be constructed two similar and unequal segments of circles on the same side"))
        self.add_entry(TOCEntry(24,"Similar segments of circles on equal straight lines are equal to one another"))
        self.add_entry(TOCEntry(25,"Given a segment of a circle, to describe the complete circle of which it is a segment."))
        self.add_entry(TOCEntry(26,"In equal circles equal angles stand on equal circumferences"))
        self.add_entry(TOCEntry(27,"In equal circles angles standing on equal circumferences are equal to one another"))
        self.add_entry(TOCEntry(28,"In equal circles equal straight lines cut off equal circumferences"))
        self.add_entry(TOCEntry(29,"In equal circles equal circumferences are subtended by equal straight lines"))
        self.add_entry(TOCEntry(30,"To bisect a given circumference"))
        self.add_entry(TOCEntry(31,"In a circle the angle in the semicircle is right ..."))
        self.add_entry(TOCEntry(32,"The angle between a tangent and a straight line cutting a circle is equal to the angle in the alternate segment"))
        self.add_entry(TOCEntry(33,"Construct a circle segment on a given line, such that the angle within the segment is equal to a given angle"))
        self.add_entry(TOCEntry(34,"Construct a circle segment on a given circle, such that the angle within the segment is equal to a given angle"))
        self.add_entry(TOCEntry(35,"If two circle chords intersect, the segments on one multiplied together equals the segments of the other multiplied together"))
        self.add_entry(TOCEntry(36,"Secant-tangent law"))
        self.add_entry(TOCEntry(37,"Converse of the secant-tangent law"))



