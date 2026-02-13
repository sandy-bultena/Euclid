import sys
import os
sys.path.append(os.getcwd())

from euclidlib.Scenes.PropScene import PropScene
from euclidlib.Objects import *


class Book1Prop1(PropScene):
    title = ""
    steps = []

    def run_full(self):
        label_locations_index()

    def go(self):
        pass

def point_at_angle():
    l1 = ELine(mn_coord(130,400),mn_coord(230,100))
    l2 = ELine(mn_coord(130,400),mn_coord(500,600))
    a = EAngle(l2,l1)
    x = a.e_point_at_angle(mn.PI/4)
    x.add_label("B")
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

def get_bisect():
    l1 = ELine(mn_coord(130,400),mn_coord(130,150))
    l2 = ELine(mn_coord(130,400),mn_coord(500,400))
    a = EAngle(l2,l1,label="A")
    b = a.get_bisect()
    print(a.e_angle, type(a.e_angle), b, type(b), a.e_angle/b)

def right_angle():
    l1 = ELine(mn_coord(130,400),mn_coord(130,150))
    l2 = ELine(mn_coord(130,400),mn_coord(500,400))
    a = EAngle(l2,l1,label="A")

def angle():
    l1 = ELine(mn_coord(130,400),mn_coord(500,150))
    l2 = ELine(mn_coord(130,400),mn_coord(500,400))
    a = EAngle(l2,l1,label="A")

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
