import sys
import os

from docutils.parsers.rst.directives.tables import align

sys.path.append(os.getcwd())

from euclidlib.Scenes.PropScene import PropScene
from euclidlib.Objects import *

from manimlib import *


class Book1Prop1(PropScene):
    title = ""
    steps = []

    def run_full(self):
        draw_angles()


    def go(self):
        pass

def area():
    poly = ETriangle(mn_coord(100, 100), mn_coord(100, 300), mn_coord(300, 350))
    txt = r"A = (1/2) \sum_{i=0}^{n-1} a_i \quad\text{where}\quad a_i = x_i y_{i+1} - x_{i+1} y_i"
    t1 = TextBox(mn_coord(300, 100))
    t1.math(txt)
    print(poly.area)

def label():
    EPolygon(mn_coord(100, 100), mn_coord(100, 300), mn_coord(300, 350),label='A')
    poly = EPolygon(mn_coord(400, 100), mn_coord(400, 300), mn_coord(600, 350))
    poly.add_label("a")

def move_point_to():
    p_other = EPoint(mn_coord(50, 50))
    poly = EPolygon(mn_coord(100, 100), mn_coord(100, 300), mn_coord(300, 350),
                    labels=['A','B','C'], angles=['a','b','c'])
    poly.e_fill(mn.BLUE)

    poly.move_point_to(0, p_other)

def replace_line():
    l =  ELine(mn_coord(100, 100),mn_coord(100, 300)).dash()
    poly = EPolygon(mn_coord(100, 100), mn_coord(100, 300), mn_coord(300, 350))
    poly.replace_line(0,l)

def replace_point():
    p =  EPoint(mn_coord(100, 100)).add_label("A").red()
    poly = EPolygon(mn_coord(100, 100), mn_coord(100, 300), mn_coord(300, 350))
    poly.replace_point(0,p)

def angle_label_without_angle():
    # create, remove and add
    poly = EPolygon(mn_coord(100, 100), mn_coord(100, 300), mn_coord(300, 350))
    poly.a[0].add_label("a")

def draw_angles():
    # create, remove and add
    poly = EPolygon(mn_coord(100, 100), mn_coord(100, 300), mn_coord(300, 350))
    poly.add_angles(r'\beta', None, r'\alpha')
    poly.remove_angles()
    poly.add_angles(None,('A',ANGLE_SIZE*0.75))

    # do same as above, but redraw afterwards
    poly = EPolygon(mn_coord(400, 100), mn_coord(400, 300), mn_coord(600, 350))
    poly.add_angles(r'\beta', None, r'\alpha')
    poly.remove_angles()
    poly.add_angles(None,('A',ANGLE_SIZE*0.75),None)

    poly.draw_angles()

def set_angles():
    poly = EPolygon(mn_coord(100, 100), mn_coord(100, 300), mn_coord(300, 350))
    poly.add_angles(r'\beta', None, r'\alpha')

    # add 'A' angle to the second vertex
    poly.add_angles(None,('A',ANGLE_SIZE*0.75),None)

    # rename the first angle to 'B' and change its size
    poly.set_angles(("B",ANGLE_SIZE*1.5), None, None)


def assemble():
    p1 = EPoint(mn_coord(100, 100))
    p2 = EPoint(mn_coord(100, 300))
    p3 = EPoint(mn_coord(300, 350))

    line1 = ELine(mn_coord(100, 100), mn_coord(100, 300))
    line2 = ELine(mn_coord(100, 300), mn_coord(300, 350))
    line3 = ELine(mn_coord(300, 350), mn_coord(100, 100))

    poly = EPolygon.assemble(points=[p1, p2, p3], lines=[line1, line2, line3]).e_fill(mn.BLUE)

    # line2 and poly[1] point to the same object
    line2.red()


def assemble_lines_dont_match_points():
    p1=EPoint(mn_coord(100,100))
    p2=EPoint(mn_coord(100,300))
    p3=EPoint(mn_coord(300,350))

    line1 = ELine( mn_coord(100,100), mn_coord(100,300))
    line2 = ELine( mn_coord(100,300), mn_coord(300,450))
    line3 = ELine( mn_coord(300,450), mn_coord(100,100))

    poly = EPolygon.assemble(points=[p1,p2,p3],lines=[line1,line2,line3]).e_fill(mn.BLUE)
    poly.l[1].red()

def basic():
    # angle radius size default is ANGLE_SIZE, 'None' size reverts to default size,
    p= EPolygon(mn_coord(100, 100), mn_coord(100, 400), mn_coord(400, 450),
             labels=['A', 'B', 'C'],
             point_labels=['b', 'c', 'a'],
             angles=[r'\beta', r'\gamma', r'\alpha', None, mn_scale(60)],
             fill=mn.BLUE
             )
    print([a*180/mn.PI for a in p.angle_values])

    # fill can be colour, or [colour, opacity]
    EPolygon(mn_coord(500, 100), mn_coord(500, 400), mn_coord(900, 450),
             labels=['A', 'B', 'C'],
             point_labels=['b', 'c', 'a'],
             angles=[r'\beta', r'\gamma', r'\alpha', ANGLE_SIZE * 2, None, ANGLE_SIZE / 2],
             fill=[mn.GREEN, 0.50]
             )

def add_line_labels():
    poly = EPolygon(mn_coord(100, 100), mn_coord(100, 300), mn_coord(300, 350), label='A').e_fill(mn.BLUE_A)

    poly.add_line_labels([
        r'1^{st}',dict(buff=0.2*LABEL_BUFF,align=mn.RIGHT,alpha=.15)],  # line 1 label options
        r'2^{nd}')                                                      # line 2 label options

    EPolygon(mn_coord(400, 100), mn_coord(400, 300), mn_coord(600, 350),
                    label = 'B',
                    labels = [
                        [r'1^{st}',dict(buff=0.2*LABEL_BUFF,align=mn.RIGHT,alpha=.85)],
                        r'2^{nd}'
                    ]
                    ).e_fill(mn.GREEN)


def add_point_labels():
    poly = EPolygon(mn_coord(100, 100), mn_coord(100, 300), mn_coord(300, 350), label='A').e_fill(mn.BLUE)

    poly.set_point_labels(
         None,                              # point 1 label options
         ('P2', dict(direction=mn.DOWN)      # point 2 label options
         ),
    )

    EPolygon(mn_coord(400, 100), mn_coord(400, 300), mn_coord(600, 350),
                    label = 'B',
                    point_labels = [
                        None,
                        ('P2', dict(direction=mn.LEFT)),
                    ]
                    ).e_fill(mn.GREEN)

