import sys
import os
sys.path.append(os.getcwd())

from euclidlib.Scenes.PropScene import PropScene
from euclidlib.Objects import *

class Book1Prop1(PropScene):
    title = ""
    steps = []

    def run_full(self):
        parallelogram()

    def go(self):
        pass

def equilateral():
    t1 = TextBox(mn_coord(100, 50))
    t1.explain("Construct an equilateral triangle")
    p = ETriangle.build_equilateral(mn_coord(100,300), mn_coord(300,300), speed=2)
    p = ETriangle.build_equilateral(mn_coord(400,300), mn_coord(600,300))

def copy_to_triangle():
    # ∼
    t1 = TextBox(mn_coord(100, 50))
    t1.explain("In a given circle to inscribe a triangle equiangular with a given triangle")
    tri = ETriangle(mn_coord(130,200),mn_coord(350,100),mn_coord(400,250)).e_fill(mn.BLUE)
    c1 = ECircle(mn_coord(600,200),mn_coord(675,275))
    tri.copy_to_circle(c1,speed=2).e_fill(mn.GREEN)



def golden():
    # class method
    line = ELine(mn_coord(600,450), mn_coord(900,450))
    tri = ETriangle(line,speed=2)
    tri.add_labels()

    for l in tri.l:
        print(l.length)

def circumscribe():
    tri = ETriangle(mn_coord(130,400),mn_coord(400,550),mn_coord(350,300)).e_fill(mn.BLUE)
    c = tri.circumscribe(speed=2)

def copy_to_parallelogram_on_line():
    tri = ETriangle(mn_coord(130,400),mn_coord(400,450),mn_coord(350,300)).e_fill(mn.BLUE)
    line = ELine(mn_coord(600,450), mn_coord(900,450))

    l1 = ELine(mn_coord(300,250), mn_coord(450,250))
    l2 = ELine(mn_coord(300,250), mn_coord(450,150))
    a = EAngle(l1,l2,label=r'\alpha')

    p = tri.copy_to_parallelogram_on_line(line,a)
    p.e_fill(mn.GREEN)

def parallelogram():
    tri = ETriangle(mn_coord(130,400),mn_coord(400,450),mn_coord(350,300)).e_fill(mn.BLUE)
    l1 = ELine(mn_coord(300,150), mn_coord(400,150))
    l2 = ELine(mn_coord(300,150), mn_coord(400,50))
    a = EAngle(l1,l2,label=r'\alpha')

    p,angle = tri.parallelogram(a,speed=2)
    p.e_fill(mn.GREEN)
    angle.add_label(r'\alpha')

    tri = ETriangle(mn_coord(530,400),mn_coord(800,450),mn_coord(750,300)).e_fill(mn.BLUE)
    p,angle = tri.parallelogram(a)
    p.e_fill(mn.GREEN)
    angle.add_label(r'\alpha')


def SAS():
    p=EPoint(mn_coord(100,200))
    angle = 45/180 * mn.PI
    ETriangle.SAS(p, mn_scale(300), angle, mn_scale(350), labels='abc', point_labels='ABC')

    p=EPoint(mn_coord(400,200))
    angle = 25/180 * mn.PI
    ETriangle.SAS(p, mn_scale(300), angle, mn_scale(350), labels='abc', point_labels='ABC')

def SSS():
    p=EPoint(mn_coord(100,400))
    r2 = mn_scale(100)
    ETriangle.SSS(p, mn_scale(270), r2, mn_scale(250), labels='abc', point_labels='ABC',speed=2)
    p.lift().blue()

    p=EPoint(mn_coord(400,400))
    r2 = mn_scale(200)
    ETriangle.SSS(p, mn_scale(270), r2, mn_scale(250), labels='abc', point_labels='ABC')
    p.lift().blue()

def triangle_rotate():
    tri=ETriangle(mn_coord(130,400),mn_coord(500,150),mn_coord(500,400),angles=(r'\beta',None,None))
    tri.e_rotate(mn_coord(130,400),mn.PI)(run_time=2)
