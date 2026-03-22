import sys
import os

from numpy.ma.core import negative
from pyrr.ray import direction

sys.path.append(os.getcwd())

from euclidlib.Scenes.PropScene import PropScene
from euclidlib.Objects import *


class Book1Prop1(PropScene):
    title = ""
    steps = []

    def run_full(self):
        tangent_pt_not_on_line()

    def go(self):
        pass

def is_point_on_arc():
    e = EArc(mn_scale(200), mn_coord(40, 500), mn_coord(300, 500))
    p = EPoint(mn_coord(100,500))
    e.add_label(str(e.is_point_on_arc(p)))


def arc_label_with_align():

    e = EArc(mn_scale(200), mn_coord(40, 500), mn_coord(300, 500))
    e.add_label(r'\text{start}', where=ArcLabelLocation.AT_START, align=mn.RIGHT)

    e = EArc(mn_scale(200), mn_coord(40, 600), mn_coord(300, 600))
    e.add_label(r'\text{start}', where=ArcLabelLocation.AT_START, align=mn.LEFT)



def intersect_arc2():
    a1 = EArc(mn_scale(200), mn_coord(600, 500), mn_coord(340, 400))
    a2 = EArc(mn_scale(200), mn_coord(700, 500), mn_coord(440, 400))
    a3 = EArc(mn_scale(100), mn_coord(700, 500), mn_coord(540, 400))
    a4 = EArc(mn_scale(100), mn_coord(540, 400), mn_coord(700, 500))

    pts=a1.intersect(a2)
    for i in pts:
        EPoint(i)

    pts=a1.intersect(a3)
    for i in pts:
        EPoint(i)

    pts=a1.intersect(a4)
    for i in pts:
        EPoint(i)

def intersect_arc_end_points():
    a1 = EArc(mn_scale(200), mn_coord(600, 500), mn_coord(340, 400))
    a2 = EArc(mn_scale(200), mn_coord(340, 400), mn_coord(600, 500))
    pts=a1.intersect(a2)
    for i in pts:
        EPoint(i)


def intersect_line_end_points():
    a = EArc(mn_scale(200), mn_coord(600, 500), mn_coord(340, 400))

    l = ELine(mn_coord(600, 500),mn_coord(300,300))
    intersections = a.intersect(l, reverse=True)
    for i in intersections:
        EPoint(i)

    l = ELine(mn_coord(520,620), mn_coord(340, 400))
    intersections = a.intersect(l)
    for i in intersections:
        EPoint(i)


def intersect_line():
    a = EArc(mn_scale(200), mn_coord(600, 500), mn_coord(340, 400))

    # intersects
    l = ELine(mn_coord(800,900),mn_coord(300,300))
    intersections = a.intersect(l, reverse=True)
    for i in intersections:
        EPoint(i)

    # line not long enough
    l = ELine(mn_coord(520,620),mn_coord(420,420))
    intersections = a.intersect(l)
    for i in intersections:
        EPoint(i)

    # two points
    l = ELine(mn_coord(600,450),mn_coord(340,350))
    intersections = a.intersect(l)
    for i in intersections:
        EPoint(i)

def tangent_pt_not_on_line():
    a = EArc(mn_scale(200), mn_coord(650, 500), mn_coord(400, 450))
    p = EPoint(mn_coord(550, 350)).add_label('A')
    ELine(a.center, p).e_fade()
    tangents_pos = a.tangent_points(p)
    ELine(*tangents_pos).extend(mn_scale(50)).blue()


def tangent_at_start():
    a = EArc(mn_scale(200), mn_coord(600, 500), mn_coord(340, 400))
    tangent = a.tangent_at_start()
    ELine(a.point1_coord, a.point1_coord-mn_scale(150)*tangent).blue()
    tangent = a.tangent_at_end()
    ELine(a.point2_coord, a.point2_coord-mn_scale(150)*tangent).red()

def tangent_at_point():
    # by point
    a = EArc(mn_scale(200), mn_coord(300, 500), mn_coord(40, 400))
    p1 = a.e_point_at_angle(mn.PI/4)
    tangents_pos = a.tangent_points(p1)
    ELine(*tangents_pos).extend(mn_scale(50)).blue()

    # by angle
    a = EArc(mn_scale(200), mn_coord(700, 500), mn_coord(440, 400))
    tangents_pos = a.tangent_points(mn.PI/4)
    ELine(*tangents_pos).extend(mn_scale(50)).blue()

    # by point not on circle
    a = EArc(mn_scale(200), mn_coord(600, 600), mn_coord(400, 600))
    p = EPoint(mn_coord(500,500))
    tangents_pos = a.tangent_points(p)
    ELine(*tangents_pos).extend(mn_scale(50)).blue()



def tangents():
    a = EArc(mn_scale(200), mn_coord(300, 500), mn_coord(40, 400))
    p1 = a.e_point_at_angle(mn.PI/4)

    tangents_pos = a.tangent_points(p1)
    tangents_neg = a.tangent_points(p1, negative=True)
    ELine(*tangents_pos).extend(mn_scale(50)).blue()
    ELine(*tangents_neg).extend(mn_scale(50)).red()

    a = EArc(mn_scale(200), mn_coord(700, 500), mn_coord(440, 400))
    EPoint(a.point1_coord)
    EPoint(a.point2_coord)

    tangent = a.tangent_at_start()
    ELine(a.point1_coord+mn_scale(100)*tangent, a.point1_coord-mn_scale(100)*tangent).blue()

    tangent = a.tangent_at_end()
    ELine(a.point2_coord+mn_scale(100)*tangent, a.point2_coord-mn_scale(100)*tangent).red()



def bisect():
    a = EArc(mn_scale(200), mn_coord(300, 400), mn_coord(40, 450))
    p = a.bisect()
    print(p)

def pie():
        a = EArc(mn_scale(200),mn_coord(300,400),mn_coord(40,400))
        a_pie = a.create_pie()
        a_pie.e_fill(mn.BLUE)
        b = EArc(mn_scale(200),mn_coord(600,400),mn_coord(340,400), big=True)
        b_pie = b.create_pie()
        b_pie.e_fill(mn.GREEN)



def semi_circle():
    a = EArc.semi_circle(mn_coord(40,400),mn_coord(300,400), label=r"\alpha")

def highlight():
    a = EArc(mn_scale(180),mn_coord(400,400),mn_coord(140,400))
    a.notice()

def point_at_angle():
    a = EArc(mn_scale(180),mn_coord(400,400),mn_coord(140,400), big=True)
    p1 = a.e_point_at_angle(0).add_label(r"0")
    p2 = a.e_point_at_angle(mn.PI/4).add_label(r"45")
    p3 = a.e_point_at_angle(mn.PI/2).add_label(r"90")
    p4 = a.e_point_at_angle(3*mn.PI/2).add_label(r"270").red()
    p5 = a.e_point_at_angle(-mn.PI/2).add_label(r"-90").red()


def labels():
    e = EArc(mn_scale(200),mn_coord(40,400),mn_coord(300,400))
    e.add_label(r'\text{default}')

    e = EArc(mn_scale(200),mn_coord(40,500),mn_coord(300,500))
    e.add_label(r'\text{start}',where=ArcLabelLocation.AT_START)

    e = EArc(mn_scale(200),mn_coord(40,600),mn_coord(300,600))
    e.add_label(r'\text{end}',where=ArcLabelLocation.AT_END)

    e = EArc(mn_scale(200),mn_coord(40,700),mn_coord(300,700))
    e.add_label(r'0.25',alpha=0.25)



def basic():
    EArc(mn_scale(200),mn_coord(40,400),mn_coord(300,400), label=r"\alpha")

def direction_matters():
    A = EPoint(mn_coord(40,400),label="A")
    B = EPoint(mn_coord(300,400),label="B")
    EArc(mn_scale(150),A,B, label=r"A\rightarrow B")

    A = EPoint(mn_coord(440,400),label=("A",dict(direction=mn.DOWN)))
    B = EPoint(mn_coord(700,400),label=("B",dict(direction=mn.DOWN)))
    EArc(mn_scale(150),B,A, label=r"B\rightarrow A")

def big_vs_small():
    A = EPoint(mn_coord(40,400),label="A")
    B = EPoint(mn_coord(300,400),label="B")
    EArc(mn_scale(150),A,B, label=r"\text{small}")
    EArc(mn_scale(150),A,B, big=True, label=r"\text{big}")

