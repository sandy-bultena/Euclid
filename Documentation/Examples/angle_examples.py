import sys
import os
sys.path.append(os.getcwd())

from euclidlib.Scenes.PropScene import PropScene
from euclidlib.Objects import *


class Book1Prop1(PropScene):
    title = ""
    steps = []

    def run_full(self):
        angle_move_to()

    def go(self):
        pass


from manimlib import *
def manimlib_example(self):

    circle = Circle()
    circle.set_fill(BLUE, opacity=0.5)
    circle.set_stroke(BLUE_E, width=4)
    self.play(ShowCreation(circle))

    # This opens an iPython terminal where you can keep writing
    # lines as if they were part of this construct method.
    # In particular, 'square', 'circle' and 'self' will all be
    # part of the local namespace in that terminal.
    # self.embed()

    # Try copying and pasting some of the lines below into
    # the interactive shell
    self.play(circle.animate.shift(2 * RIGHT))
    self.play(circle.animate.shift(-2 * RIGHT))
    print(-2*RIGHT)

def angle_move_to():
    l1 = ELine(mn_coord(130,400),mn_coord(500,150))
    l2 = ELine(mn_coord(130,400),mn_coord(500,400))
    a = EAngle(l2,l1,label=r'\alpha',size=mn_scale(80))
    c = ECircle([0,0,0,],[2,2,2])
    a.e_move_to(c, aligned_edge=mn.LEFT, coor_mask=[1,1,1])(run_time=1)


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
