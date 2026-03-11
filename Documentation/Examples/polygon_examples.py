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
        parallelogram()


    def go(self):
        pass

def parallelogram():
    poly = EPolygon(mn_coord(200, 200), mn_coord(150,300), mn_coord(200, 400), mn_coord(400,450), mn_coord(400, 400),
                    mn_coord(370,300))
    l1 = ELine(mn_coord(200,700), mn_coord(400,700),label='a')
    l2 = ELine(mn_coord(250,150), mn_coord(350,150))
    l3 = ELine(mn_coord(250,150), mn_coord(350, 50))
    angle = EAngle(l2,l3,label=r'\alpha')
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

def move_point_to():
    p_other = EPoint(mn_coord(50, 50))
    poly = EPolygon(mn_coord(100, 100), mn_coord(100, 300), mn_coord(300, 350),
                    labels=['A','B','C'], angle_info=['a','b','c'])
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

def draw_angles():
    # create, remove and add
    poly = EPolygon(mn_coord(100, 100), mn_coord(100, 300), mn_coord(300, 350))
    poly.set_angles((r'\beta', None, r'\alpha'))
    poly.remove_angles()
    poly.set_angles((None,'A',None), (None, ANGLE_SIZE*0.75))

    # do same as above, but redraw afterwards
    poly = EPolygon(mn_coord(400, 100), mn_coord(400, 300), mn_coord(600, 350))
    poly.set_angles((r'\beta', None, r'\alpha'))
    poly.remove_angles()
    poly.set_angles((None,'A',None), (None, ANGLE_SIZE*0.75))
    ##########
    poly.draw_angles()
    ##########

def set_angles():
    poly = EPolygon(mn_coord(100, 100), mn_coord(100, 300), mn_coord(300, 350))
    poly.set_angles((r'\beta', None, r'\alpha'))

    # add 'A' angle to the second vertex
    poly.set_angles((None,'A',None), (None, ANGLE_SIZE*0.75))

    # rename the first angle to 'B' and change its size
    poly.set_angles(("B", None, None), (ANGLE_SIZE*1.5, ))


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
             angle_info=[r'\beta', r'\gamma', r'\alpha', None, mn_scale(60)],
             fill=mn.BLUE
             )
    print([a*180/mn.PI for a in p.angle_values])

    # fill can be colour, or [colour, opacity]
    EPolygon(mn_coord(500, 100), mn_coord(500, 400), mn_coord(900, 450),
             labels=['A', 'B', 'C'],
             point_labels=['b', 'c', 'a'],
             angle_info=[r'\beta', r'\gamma', r'\alpha', ANGLE_SIZE * 2, None, ANGLE_SIZE / 2],
             fill=[mn.GREEN, 0.50]
             )

def add_label():
    poly = EPolygon(mn_coord(100, 100), mn_coord(100, 300), mn_coord(300, 350)).e_fill(mn.BLUE_A)

    poly.set_labels(r'1^{st}',r'2^{nd}')
    poly.set_point_labels(
         None,
         None,
         (r'3^{rd}', dict(away_from=poly)
         ),
    )
