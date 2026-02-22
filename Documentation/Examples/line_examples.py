import sys
import os
sys.path.append(os.getcwd())

from euclidlib.Scenes.PropScene import PropScene
from euclidlib.Objects import *

class Book1Prop1(PropScene):
    title = "To construct an equilateral triangle on a given finite straight line."
    steps = []

    def run_full(self):
        intersect_bound_lines()

    def go(self):
        pass

def intersect_bound_lines():
    l = ELine(mn_coord(250,300),mn_coord(150,100)).green()
    l2 = ELine(mn_coord(150,300),mn_coord(250,100)).green()
    intersections = l.intersect_bound_lines(l2)
    for i in intersections:
        EPoint(i)


    l = ELine(mn_coord(360,180),mn_coord(400,100)).red()
    l2 = ELine(mn_coord(340,180),mn_coord(300,100)).red()
    intersections = l.intersect_bound_lines(l2)
    for i in intersections:
        print(euclid_coord(*i))
        EPoint(i)

    l = ELine(mn_coord(510,180),mn_coord(550,100)).blue()
    l2 = ELine(mn_coord(550,300),mn_coord(450,100)).blue()
    i = l.intersect(l2)
    print(euclid_coord(*i[0]))
    intersections = l.intersect_bound_lines(l2)
    for i in intersections:
        print(euclid_coord(*i))
        EPoint(i)

def intersects():

    # intersects EArc
    l = ELine(mn_coord(500,300),mn_coord(400,100)).blue()
    a = EArc(mn_scale(200), mn_coord(600, 250), mn_coord(400, 200)).blue()
    intersections = l.intersect(a, reverse=True)
    for i in intersections:
        EPoint(i)

    # intersect circle
    l = ELine(mn_coord(120,120),mn_coord(250,250))
    c1 = ECircle(mn_coord(250,250),mn_coord(350,250))
    intersections = l.intersect(c1)
    for i in intersections:
        EPoint(i)

    # intersect line
    l = ELine(mn_coord(750,300),mn_coord(650,100)).green()
    l2 = ELine(mn_coord(650,300),mn_coord(750,100)).green()
    intersections = l.intersect(l2)
    for i in intersections:
        EPoint(i)


    # intersect line
    l = ELine(mn_coord(870,195),mn_coord(850,100)).red()
    l2 = ELine(mn_coord(900,250),mn_coord(950,100)).red()
    intersections = l.intersect(l2)
    for i in intersections:
        print(euclid_coord(*i))
        EPoint(i)





def point():
    l1 = ELine(mn_coord(140, 140), mn_coord(300,200))
    p = l1.point(mn_scale(200))
    EPoint(p).add_label("r=200", align=mn.LEFT)
    p = l1.point(mn_scale(-30))
    EPoint(p).add_label("r=-30", align=mn.RIGHT)
    p = l1.point(mn_scale(50))
    EPoint(p).add_label("r=50", align=mn.LEFT)



def line_labels():
    l1 = ELine(mn_coord(140, 140), mn_coord(300,200))
    l1.add_label('A',direction=mn.RIGHT)

    l2 = ELine(mn_coord(140, 240), mn_coord(300,300))
    l2.add_label('B',side=LineLabelSide.INSIDE)

    l3 = ELine(mn_coord(140, 340), mn_coord(300,400))
    l3.add_label('C',side=LineLabelSide.OUTSIDE)

    l4 = ELine(mn_coord(440, 140), mn_coord(600,200))
    l4.add_label('D',side=LineLabelSide.OUTSIDE, alpha = 0.1)

    l5 = ELine(mn_coord(440, 240), mn_coord(600,300))
    l5.add_label('E',direction=mn.LEFT, alpha = 0.0)

def line_dash_and_undash():
    A = (425,30)
    B = (750,30)
    t1 = TextBox(mn_coord(20, 20))

    for i in range(4):
        pos_space = (i+1) * 0.1
        op = (i+1) * 0.2
        text = f"positive_space_ratio={pos_space:.1f},   final_opacity={op:.1f}"
        t1.explain(text)
        l = ELine(mn_coord(A[0],A[1]+i*25), mn_coord(B[0],B[1]+i*25))
        l.dash(dash_length=mn.DEFAULT_DASH_LENGTH,positive_space_ratio=pos_space, final_opacity=op)

def highlight():
    l = ELine(mn_coord(40, 40), mn_coord(100,100))
    l.notice()

def line_no_label():
    p1 = EPoint(mn_coord(140,300))
    p2 = EPoint(mn_coord(300,140))
    l1 = ELine(mn_coord(140, 140), mn_coord(300,300))
    l2 = ELine(p1,p2).blue()

def line_rotate():
    l = ELine(mn_coord(40, 40), mn_coord(100,100))
    l.e_rotate(mn_coord(110, 110),3.14/2)(run_time=200)

def line_label_no_direction():
    l = ELine(mn_coord(40, 40), mn_coord(100,100), label_args='A')