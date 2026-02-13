import sys
import os
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

def right_angle():
    l1 = ELine(mn_coord(130,400),mn_coord(130,150))
    l2 = ELine(mn_coord(130,400),mn_coord(500,400))
    a = EAngle(l2,l1,label="A",debug=1)

def angle():
    l1 = ELine(mn_coord(130,400),mn_coord(500,150))
    l2 = ELine(mn_coord(130,400),mn_coord(500,400))
    a = EAngle(l2,l1,label="A",debug=1)

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
