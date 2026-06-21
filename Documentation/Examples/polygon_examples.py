import sys
import os

from docutils.parsers.rst.directives.tables import align

sys.path.append(os.getcwd())

from euclidlib.Scenes.PropScene import PropScene
from euclidlib.Objects import *
from manimlib import *
from euclidlib.Utilities import Colour


class Book1Prop1(PropScene):
    title = ""
    steps = []

    def run_full(self):
        rectangle2()


    def go(self):
        pass

def hide():
    poly1 = EPolygon(mn_coord(200, 200), mn_coord(150,300), mn_coord(200, 400), mn_coord(400,450), mn_coord(400, 400),
                    mn_coord(370,300)).e_fill(mn.BLUE).add_label("a")
    poly1.scene.wait(2)
    poly1.e_hide()
    poly1.scene.wait(2)
    poly1.e_normal()

def rectangle2():
    p1 = mn_coord(150, 650)
    p2 = mn_coord(550, 250)
    r = ERectangle(p1,p2, fill=SKY_BLUE).e_remove_points()
    for i in range(8):
        pt = 0.5 * (p1+p2)
        ERectangle(p1,pt,fill=YELLOW).e_remove_points()
        ELine( [pt[0], p1[1], 0], [pt[0],p2[1],0])
        ELine( [p1[0], pt[1], 0], [p2[0],pt[1],0])
        p1 = pt



def polygon():

    t1 = TextBox(mn_coord(300,100))
    t1.math(r"A_a = A_c\quad\quad b\sim d")

    p = EPoint(mn_coord(700, 400))

    # create polygon 1
    poly1 = EPolygon(mn_coord(200, 200), mn_coord(150,300), mn_coord(200, 400), mn_coord(400,450), mn_coord(400, 400),
                    mn_coord(370,300)).e_fill(mn.BLUE).add_label("a")

    # create polygon 2
    poly2 = EPolygon(mn_coord(500, 200), mn_coord(500, 400),  mn_coord(550, 400), mn_coord(600,300),
                     ).e_fill(mn.GREEN).add_label("b")

    poly1.copy_to_polygon_shape(p, poly2).e_fill(Colour.add(mn.BLUE, mn.GREEN)).add_label('c')


def similar_shape():
    # create polygon
    poly = EPolygon(mn_coord(300, 200), mn_coord(250,300), mn_coord(300, 400), mn_coord(500,450), mn_coord(500, 400),
                    mn_coord(470,300))

    # create line to draw
    p0 = mn_coord(600, 200)
    p1 = p0 + 0.75*poly.l[0].get_length()*poly.l[0].get_unit_vector()
    l1 = ELine(p0,p1,label='a')

    # copy to line animating intermediate steps
    poly.copy_to_similar_shape(l1, speed=2)

    # create line to draw
    p0 = mn_coord(900, 200)
    p1 = p0 + 0.75 * poly.l[0].get_length() * poly.l[0].get_unit_vector()
    l1 = ELine(p0, p1, label='a')

    # copy to line without animating intermediate steps
    poly.copy_to_similar_shape(l1)


def rectangle():
    t1 = TextBox(mn_coord(300,100))
    t1.explain(r"both polygons have the same area")
    poly = EPolygon(mn_coord(300, 200), mn_coord(250,300), mn_coord(300, 400), mn_coord(500,450), mn_coord(500, 400),
                    mn_coord(470,300)).e_fill(mn.BLUE)
    p1 = EPoint( mn_coord(700,400),label=('a',mn.DL))
    p2 = poly.copy_to_rectangle(p1)
    p2.e_fill(mn.GREEN)


def parallelogram_on_point():
    t1 = TextBox(mn_coord(300,100))
    t1.explain(r"both polygons have the same area")

    l2 = ELine(mn_coord(50,300), mn_coord(150,350))
    l3 = ELine(mn_coord(50,300), mn_coord(150,250))
    angle = EAngle(l2,l3,label=r'\alpha')

    poly = EPolygon(mn_coord(300, 200), mn_coord(250,300), mn_coord(300, 400), mn_coord(500,450), mn_coord(500, 400),
                    mn_coord(470,300)).e_fill(mn.BLUE)
    p1 = EPoint( mn_coord(700,400),label=('a',mn.DL))

    p2 = poly.copy_to_parallelogram_on_point(p1,angle)
    poly.copy_to_rectangle(p1)
    p2.add_angles(None,r'\alpha')
    p2.e_fill(mn.GREEN)


    p2 = poly.copy_to_parallelogram_on_point(p1, angle, negative=True)
    p2.add_angles(None, r'\alpha')
    p2.e_fill(mn.GREEN_E)


def parallelogram():
    # create angle
    l2 = ELine(mn_coord(50,300), mn_coord(150,350))
    l3 = ELine(mn_coord(50,300), mn_coord(150,250))
    angle = EAngle(l2,l3,label=r'\alpha')

    # create parallelogram with intermediate animation
    poly = EPolygon(mn_coord(300, 200), mn_coord(250,300), mn_coord(300, 400), mn_coord(500,450), mn_coord(500, 400),
                    mn_coord(470,300)).e_fill(mn.BLUE)
    l1 = ELine(mn_coord(300,700), mn_coord(500,700),label='a')
    poly.copy_to_parallelogram_on_line(l1,angle, speed=2)

    # create parallelogram no intermediate animation
    poly = EPolygon(mn_coord(600, 200), mn_coord(550,300), mn_coord(600, 400), mn_coord(800,450), mn_coord(800, 400),
                    mn_coord(770,300)).e_fill(mn.GREEN)
    l1 = ELine(mn_coord(600,700), mn_coord(800,700),label='a')
    poly.copy_to_parallelogram_on_line(l1,angle)

def triangles():
    poly = EPolygon(mn_coord(200, 200), mn_coord(150,300), mn_coord(200, 400), mn_coord(400,450), mn_coord(400, 400),
                    mn_coord(370,300))
    triangles = poly.copy_to_triangles()
    colour = Colour.string("misty rose")
    for t in triangles:
        t.e_fill(colour)
        colour = Colour.darken(colour)
    print(triangles)

