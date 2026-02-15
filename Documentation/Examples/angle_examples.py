import sys
import os

from numpy.ma.core import negative

sys.path.append(os.getcwd())

from euclidlib.Scenes.PropScene import PropScene
from euclidlib.Objects import *


class Book1Prop1(PropScene):
    title = ""
    steps = []

    def run_full(self):
        right_angle()

    def go(self):
        pass


def colour():
    l1 = ELine(mn_coord(130,400),mn_coord(500,150))
    l2 = ELine(mn_coord(130,400),mn_coord(500,400))
    a = EAngle(l2,l1,label=r'\alpha',size=mn_scale(80))
    a.blue()

def angle_move():
    l1 = ELine(mn_coord(130,400),mn_coord(500,150))
    l2 = ELine(mn_coord(130,400),mn_coord(500,400))
    a = EAngle(l2,l1,label=r'\alpha')
    a.e_move(mn_scale(100,50))(run_time=1)


def angle_rotate():
    l1 = ELine(mn_coord(130,400),mn_coord(500,150))
    l2 = ELine(mn_coord(130,400),mn_coord(500,400))
    a = EAngle(l2,l1, size=mn_scale(80))
    a.add_label(r'\alpha', alpha=0.75,buff=1*LABEL_BUFF)
    print()
    print(a.add_label, type(a.add_label))
    a.scene.wait(10)
    a.e_rotate(mn_coord(130,400),mn.PI)(run_time=2)

def angles_line_order():
    l1 = ELine(mn_coord(130,400),mn_coord(500,150), label=('l1',dict(inside=True)))
    l2 = ELine(mn_coord(130,400),mn_coord(500,400), label=('l2',dict(outside=True)))
    a = EAngle(l2,l1,size=mn_scale(80))
    a.add_label("A")
    b = EAngle(l1,l2)
    b.add_label("B", buff=LABEL_BUFF)



def point_at_angle():
    l1 = ELine(mn_coord(130,400),mn_coord(230,100))
    l2 = ELine(mn_coord(130,400),mn_coord(500,600))
    a = EAngle(l2,l1,size=mn_scale(100))
    x = a.e_point_at_angle(0)
    x.add_label("B",direction=mn.RIGHT)
    y = a.e_point_at_angle(mn.PI)
    y.add_label("C",direction=mn.LEFT)
    z = a.e_point_at_angle(-mn.PI/2)
    z.add_label("D",direction=mn.DOWN)
    print(x, type(x))

def label_locations_index():
    l1 = ELine(mn_coord(130,400),mn_coord(230,100))
    l2 = ELine(mn_coord(130,400),mn_coord(500,400))
    a = EAngle(l2,l1)
    a.add_label("A",where=ArcLabelLocation.BY_ALPHA, alpha = 0.25, buff = 0.001)
    l1 = ELine(mn_coord(130,500),mn_coord(230,200))
    l2 = ELine(mn_coord(130,500),mn_coord(500,500))
    a = EAngle(l2,l1)
    a.add_label("A",where=ArcLabelLocation.AT_START)
    l1 = ELine(mn_coord(130,600),mn_coord(230,300))
    l2 = ELine(mn_coord(130,600),mn_coord(500,600))
    a = EAngle(l2,l1)
    a.add_label("A",where=ArcLabelLocation.AT_END)

def bisect():
    l1 = ELine(mn_coord(130,400),mn_coord(130,150))
    l2 = ELine(mn_coord(130,400),mn_coord(500,500))
    a = EAngle(l2,l1,label=("A",dict(alpha=.25)))
    l3 = a.bisect()
    a_half = EAngle(l1,l3, label="B", size=mn_scale(60))

def bisect_animated():
    l1 = ELine(mn_coord(130,400),mn_coord(130,150))
    l2 = ELine(mn_coord(130,400),mn_coord(500,500))
    a = EAngle(l2,l1,label=("A",dict(alpha=.25)))
    l3 = a.bisect(speed=1)
    a_half = EAngle(l1,l3, label="B", size=mn_scale(60))

def right_angle():
    l1 = ELine(mn_coord(130,400),mn_coord(130,150))
    l2 = ELine(mn_coord(130,400),mn_coord(500,400))
    a = EAngle(l2,l1,label="A")
    a.blue()
    a.e_move([1,1,0])

def right_and_normal_angles():
    l1 = ELine(mn_coord(130,400),mn_coord(130,150))
    l2 = ELine(mn_coord(130,400),mn_coord(300,400))
    EAngle(l1,l2,label=("right angle",dict(buff=2*LABEL_BUFF)))

    l1 = ELine(mn_coord(330,400),mn_coord(330,150))
    l2 = ELine(mn_coord(330,400),mn_coord(500,400))
    EAngle(l1,l2,no_right=True, label=("right angle, arc symbol",dict(buff=2*LABEL_BUFF)))

    l1 = ELine(mn_coord(530,400),mn_coord(580,150))
    l2 = ELine(mn_coord(530,400),mn_coord(700,400))
    EAngle(l1,l2, label=("standard",dict(buff=2*LABEL_BUFF)))


def angle():
    l1 = ELine(mn_coord(130,400),mn_coord(500,150))
    l2 = ELine(mn_coord(130,400),mn_coord(500,400))
    l3 = ELine(mn_coord(130,400),mn_coord(20,300))
    a = EAngle(l2,l1)
    a.add_label(r'\alpha', alpha = 0.25)
    b = EAngle(l2,l3, size=mn_scale(30), label_args=(r'\beta', dict(where=ArcLabelLocation.AT_START)))



def angle_clean_bisect():
    l1 = ELine(mn_coord(130,400),mn_coord(500,150))
    l2 = ELine(mn_coord(130,400),mn_coord(500,400))
    a = EAngle(l2,l1,label="A")
    a.clean_bisect(speed=1)

def angle_bisect():
    l1 = ELine(mn_coord(130,400),mn_coord(500,150))
    l2 = ELine(mn_coord(130,400),mn_coord(500,400))
    a = EAngle(l2,l1,label="A")
    a.bisect(speed=1)

def angle_bisect_no_speed():
    l1 = ELine(mn_coord(130,400),mn_coord(500,150))
    l2 = ELine(mn_coord(130,400),mn_coord(500,400))
    a = EAngle(l2,l1,label="A")
    a.bisect()

def angle_copy_to_line_speed_1():
    l1 = ELine(mn_coord(130,400),mn_coord(500,150))
    l2 = ELine(mn_coord(130,400),mn_coord(500,400))
    a = EAngle(l2,l1,label="A")
    l3 = ELine(mn_coord(100,600),mn_coord(500,600))
    a.copy_to_line(EPoint(mn_coord(100,600)),l3,speed=1)

def angle_copy_to_line_speed_0():
    l1 = ELine(mn_coord(100,400),mn_coord(500,150))
    l2 = ELine(mn_coord(100,400),mn_coord(500,500))
    a = EAngle(l2,l1,label="A")
    l3 = ELine(mn_coord(100,600),mn_coord(500,600))
    a.copy_to_line(EPoint(mn_coord(100,600)),l3)

def angle_copy_negative():
    l1 = ELine(mn_coord(100,400),mn_coord(500,150))
    l2 = ELine(mn_coord(100,400),mn_coord(500,500))
    a = EAngle(l2,l1,label="A")
    l3 = ELine(mn_coord(100,600),mn_coord(500,600))
    a.copy_to_line(EPoint(mn_coord(100,600)),l3, negative=True)
