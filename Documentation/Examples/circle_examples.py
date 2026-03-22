import sys
import os
sys.path.append(os.getcwd())

from euclidlib.Scenes.PropScene import PropScene
from euclidlib.Objects import *

class Book1Prop1(PropScene):
    title = ""
    steps = []

    def run_full(self):
        intersect2()

    def go(self):
        pass

def intersect2():
    tri = ETriangle(mn_coord(130,400),mn_coord(400,450),mn_coord(350,300)).e_fill(mn.BLUE)
    c1 = ECircle(mn_coord(200,200),mn_coord(275,275))
    l = ELine([-4.99999919,  3.06066012,  0.        ], [-5.155053 ,  1.5876596  , 0.       ])
    p = c1.intersect_line(l, infinite=True)
    print(p)
    #tri.copy_to_circle(c1,speed=2)


def draw_tangent():
    c1 = ECircle(mn_coord(200,200),mn_coord(275,275))
    p = EPoint (mn_coord(350,200))
    l1 = c1.draw_tangent(p).blue()

    c2 = ECircle(mn_coord(600,200),mn_coord(675,275))
    p = EPoint (mn_coord(750,200))
    l1 = c2.draw_tangent(p, negative=True).blue()

def tangents():
    c1 = ECircle(mn_coord(200,200),mn_coord(275,275))
    p1 = c1.e_point_at_angle(mn.PI/4)

    tangents_pos = c1.tangent_points(p1)
    tangents_neg = c1.tangent_points(p1, negative=True)
    ELine(*tangents_pos).extend(mn_scale(50)).blue()
    ELine(*tangents_neg).extend(mn_scale(50)).red()



def intersect_circle2():
    c1 = ECircle(mn_coord(200,200),mn_coord(250,200)).blue()
    c2 = ECircle(mn_coord(225,225),mn_coord(275,225)).blue()

    pts=c1.intersect(c2)
    for i in pts:
        EPoint(i)

    c3 = ECircle(mn_coord(350,200),mn_coord(400,200)).green()
    c4 = ECircle(mn_coord(375,200),mn_coord(400,200)).green()

    pts=c3.intersect(c4)
    for i in pts:
        EPoint(i)

    c5 = ECircle(mn_coord(475,200),mn_coord(525,200)).red()
    c6 = ECircle(mn_coord(575,200),mn_coord(600,200)).red()

    pts=c5.intersect(c6)
    for i in pts:
        EPoint(i)

    c6 = ECircle(mn_coord(675,200),mn_coord(725,200))
    c7 = ECircle(mn_coord(675,200),mn_coord(700,200))

    pts=c6.intersect(c7)
    for i in pts:
        EPoint(i)

    c8 = ECircle(mn_coord(825, 200), mn_coord(875, 200)).green()
    c9 = ECircle(mn_coord(900, 200), mn_coord(875, 200)).green()

    pts = c8.intersect(c9)
    for i in pts:
        EPoint(i)


def intersect_line():
    c1 = ECircle(mn_coord(250,250),mn_coord(350,250))

    # intersects twice
    l = ELine(mn_coord(120,200),mn_coord(420,200))
    intersections = c1.intersect(l)
    for i in intersections:
        EPoint(i)

    # line not long enough
    l = ELine(mn_coord(120,120),mn_coord(300,300))
    intersections = c1.intersect(l)
    for i in intersections:
        EPoint(i)

    # just touches
    l = ELine(mn_coord(120,150),mn_coord(300,150))
    intersections = c1.intersect(l)
    for i in intersections:
        EPoint(i)






def point_at_angle():
    c = ECircle(mn_coord(500,400),mn_coord(400,400))
    p1 = c.e_point_at_angle(0).add_label(r"0", direction=mn.RIGHT)
    p2 = c.e_point_at_angle(mn.PI/4).add_label(r"45")
    p3 = c.e_point_at_angle(mn.PI/2).add_label(r"90")
    p4 = c.e_point_at_angle(3*mn.PI/2).add_label(r"270", direction=mn.DOWN)
    p4 = c.e_point_at_angle(-mn.PI/2).add_label(r"-90", direction=mn.UP)


def angle_of_point():
    p = EPoint(mn_coord(150,110))
    c = ECircle(mn_coord(100, 150), p)
    angle = c.angle_of_point(p)
    c.add_label(f"{angle/DEGREES:.1f}", angle)

def circle_no_label():
    c = ECircle(mn_coord(100, 100), mn_coord(150,150))

def labels():
    c1 = ECircle(mn_coord(100, 100), mn_coord(150,150), label='A')
    c2 = ECircle(mn_coord(310, 100), mn_coord(360,150)).add_label('B',outside=False)
    c3 = ECircle(mn_coord(520, 100), mn_coord(570,150), label=('C',dict(angle=-mn.PI/4, buff = 0.5*LABEL_BUFF)))

def circle_label_no_direction():
    c = ECircle(mn_coord(100, 100), mn_coord(150,150), label_args=('A',dict(angle=-45)))