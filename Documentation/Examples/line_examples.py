import sys
import os

from docutils.parsers.rst.directives.tables import align

sys.path.append(os.getcwd())

from euclidlib.Scenes.PropScene import PropScene
from euclidlib.Objects import *

class Book1Prop1(PropScene):
    title = ""
    steps = []

    def run_full(self):
        brace()

    def go(self):
        pass

def transform_circle():
    l = ELine(mn_coord(350,120),mn_coord(150,100)).blue()
    with l.scene.pause_animations_for():
        l2 = ECircle(mn_coord(200,350), mn_coord(350,200), )
    l.scene.play(l.transform_to(l2))

def transform():
    l = ELine(mn_coord(350,120),mn_coord(150,100)).blue()
    with l.scene.pause_animations_for():
        l2 = ELine(mn_coord(200,350), mn_coord(350,200), )
    l.scene.play(l.transform_to(l2))


def perpendicular2():
    # inside/outside doesn't seem to be working properly... test
    l0 = ELine([-5.7,  0.,   0.],[-3., - 1.5,0.])
    l2 = ELine([-3.5,  1.,   0., ], [-5.7,  0.,   0. ])
    l0.add_label('0',side=Line.LineLabelSide.INSIDE)
    l2.add_label('2',side=Line.LineLabelSide.INSIDE)
    p = l0.bisect()
    l0.perpendicular(p, side=Line.LineLabelSide.INSIDE).blue()
    l0.perpendicular(p, side=Line.LineLabelSide.OUTSIDE).green()
    p = l2.bisect()
    l2.perpendicular(p, side=Line.LineLabelSide.INSIDE).blue()
    l2.perpendicular(p, side=Line.LineLabelSide.OUTSIDE).green()

    pass

def golden():
    t1 = TextBox(mn_coord(300,300))
    t1.math(r"AB\times PB = AP\times AP")

    a = EPoint(mn_coord(300,350), label=('A',mn.LEFT))
    b = EPoint(mn_coord(600,350), label=('B',mn.RIGHT))
    l2 = ELine(a,b,label=r'\rightarrow')
    p = l2.golden_ratio()
    p.blue().add_label("P",mn.DOWN)

def square():
    l2 = ELine(mn_coord(300,150),mn_coord(400,150)).add_label(r'\rightarrow')
    l3, l4, l1 = l2.square(speed=2)
    l1.blue()
    l2.green()
    l3.red()
    l4.white()

    l2 = ELine(mn_coord(550,150),mn_coord(450,150)).add_label(r'\leftarrow')
    l3, l4, l1 = l2.square()
    l1.blue()
    l2.green()
    l3.red()
    l4.white()

    l2 = ELine(mn_coord(450,300),mn_coord(550,300)).add_label(r'\rightarrow')
    l3, l4, l1 = l2.square(clockwise=True)
    l1.blue()
    l2.green()
    l3.red()
    l4.white()

    l2 = ELine(mn_coord(400,300),mn_coord(300,300)).add_label(r'\leftarrow')
    l3, l4, l1 = l2.square(clockwise=True)
    l1.blue()
    l2.green()
    l3.red()
    l4.white()


def fourth_proportional():
    t1 = TextBox(mn_coord(300, 50))
    t1.math(r"a:b = c:x")

    p = EPoint(mn_coord(300,100))
    l1 = ELine(mn_coord(300,150),mn_coord(400,150)).add_label(r'a=1')
    l2 = ELine(mn_coord(300,200),mn_coord(500,200)).add_label(r'b=2')
    l3 = ELine(mn_coord(300,250),mn_coord(600,250)).add_label(r'c=3')
    l4 = ELine.fourth_proportional(l1,l2,l3,p,speed=2)
    l4.add_label(r'x=(bc)/a = 6')


def copy_to_line2():
    # the line we want to copy
    l = ELine(mn_coord(300,320),mn_coord(150,300)).blue()

    # the line we want to copy to (target_line)
    p1 = EPoint(mn_coord(150,400),label="A")
    p2 = EPoint(mn_coord(400, 500),label="B")
    l1 = ELine(p1,p2).green()

    # get the starting point of line.  It will be drawn in the same direction as the target_line is drawn
    # (from start to end
    location = EPoint(l1.point(mn_scale(50))).add_label(r"\alpha")
    l_new, p_new = l.copy_to_line(location, l1)
    p_new.add_label(r"\beta")
    l_new.red()


    # the line we want to copy to (target_line)
    p1 = EPoint(mn_coord(150,600),label="A")
    p2 = EPoint(mn_coord(400, 500),label="B")
    l1 = ELine(p1,p2).green()

    # get the starting point of line.  It will be drawn in the same direction as the target_line is drawn
    # (from start to end
    location = EPoint(l1.point(mn_scale(50))).add_label(r"\alpha")
    l_new, p_new = l.copy_to_line(location, l1)
    p_new.add_label(r"\beta")
    l_new.red()

    # the line we want to copy to (target_line)
    p1 = EPoint(mn_coord(250,600),label="B")
    p2 = EPoint(mn_coord(500, 500),label="A")
    l1 = ELine(p2,p1).green()

    # get the starting point of line.  It will be drawn in the same direction as the target_line is drawn
    # (from start to end
    location = EPoint(l1.point(mn_scale(50))).add_label(r"\alpha")
    l_new, p_new = l.copy_to_line(location, l1)
    p_new.add_label(r"\beta")
    l_new.red()

    # the line we want to copy to (target_line)
    p1 = EPoint(mn_coord(250,600),label="B")
    p2 = EPoint(mn_coord(500, 700),label="A")
    l1 = ELine(p2,p1).green()

    # get the starting point of line.  It will be drawn in the same direction as the target_line is drawn
    # (from start to end
    location = EPoint(l1.point(mn_scale(50))).add_label(r"\alpha")
    l_new, p_new = l.copy_to_line(location, l1)
    p_new.add_label(r"\beta")
    l_new.red()


    # the line we want to copy to (target_line)
    p1 = EPoint(mn_coord(250,700),label="B")
    p2 = EPoint(mn_coord(500, 700),label="A")
    l1 = ELine(p2,p1).green()

    # get the starting point of line.  It will be drawn in the same direction as the target_line is drawn
    # (from start to end
    location = EPoint(l1.point(mn_scale(50))).add_label(r"\alpha")
    l_new, p_new = l.copy_to_line(location, l1)
    p_new.add_label(r"\beta")
    l_new.red()

    # the line we want to copy to (target_line)
    p1 = EPoint(mn_coord(250,750),label="A")
    p2 = EPoint(mn_coord(500, 750),label="B")
    l1 = ELine(p1,p2).green()

    # get the starting point of line.  It will be drawn in the same direction as the target_line is drawn
    # (from start to end
    location = EPoint(l1.point(mn_scale(50))).add_label(r"\alpha")
    l_new, p_new = l.copy_to_line(location, l1)
    p_new.add_label(r"\beta")
    l_new.red()

    # the line we want to copy to (target_line)
    p1 = EPoint(mn_coord(600,200),label="A")
    p2 = EPoint(mn_coord(600, 500),label="B")
    l1 = ELine(p1,p2).green()

    # get the starting point of line.  It will be drawn in the same direction as the target_line is drawn
    # (from start to end
    location = EPoint(l1.point(mn_scale(50))).add_label(r"\alpha")
    l_new, p_new = l.copy_to_line(location, l1)
    p_new.add_label(r"\beta")
    l_new.red()

    # the line we want to copy to (target_line)
    p1 = EPoint(mn_coord(650,500),label="A")
    p2 = EPoint(mn_coord(650, 200),label="B")
    l1 = ELine(p1,p2).green()

    # get the starting point of line.  It will be drawn in the same direction as the target_line is drawn
    # (from start to end
    location = EPoint(l1.point(mn_scale(50))).add_label(r"\alpha")
    l_new, p_new = l.copy_to_line(location, l1)
    p_new.add_label(r"\beta")
    l_new.red()


def third_proportional():
    t1 = TextBox(mn_coord(400, 50))
    t1.math(r"a:b = b:x")

    p = EPoint(mn_coord(400,100))
    l1 = ELine(mn_coord(400,150),mn_coord(500,150)).add_label(r'a')
    l2 = ELine(mn_coord(400,200),mn_coord(600,200)).add_label(r'b')
    l3 = ELine.third_proportional(l1,l2,p)
    l3.add_label(r'x=b^2/a')

    p = EPoint(mn_coord(500,300))
    l1 = ELine(mn_coord(500,350),mn_coord(600,350)).add_label(r'a')
    l2 = ELine(mn_coord(500,400),mn_coord(700,400)).add_label(r'b')
    l3 = ELine.third_proportional(l1,l2,p,speed=2)

def meanp():
    p = EPoint(mn_coord(300,100))
    l2 = ELine(mn_coord(300,150),mn_coord(400,150)).add_label(r'a')
    l1 = ELine(mn_coord(300,200),mn_coord(600,200)).add_label(r'b')
    l3 = ELine.mean_proportional(l1,l2,p, speed=2)
    l3.add_label(r'\sqrt{ab}')

    p = EPoint(mn_coord(300,400))
    l2 = ELine(mn_coord(300,450),mn_coord(400,450)).add_label(r'a')
    l1 = ELine(mn_coord(300,500),mn_coord(600,500)).add_label(r'b')
    l3 = ELine.mean_proportional(l1,l2,p)
    l3.add_label(r'\sqrt{ab}')

def copy_as_chord():

    # copy line as chord, starting at angle 0 (default) with full animation
    l = ELine(mn_coord(300,300),mn_coord(400,300)).blue()
    c = ECircle(mn_coord(150,300), mn_coord(150,400))
    l.copy_as_chord(c, speed=10).blue()

    # copy line as chord starting at angle 120
    l = ELine(mn_coord(300,320),mn_coord(420,320)).green()
    l.copy_as_chord(c, EPoint(c.point_at_angle(3/2*mn.PI)),clockwise=True).green()

    # copy line same size as equator
    l = ELine(mn_coord(300,340),mn_coord(500,340))
    l.copy_as_chord(c)

    # line to long to fit into circle
    l = ELine(mn_coord(300,360),mn_coord(510,360)).red()
    chord = l.copy_as_chord(c)
    if chord is None:
        l.add_label(r"\text{too long}")



def parallel():
    l = ELine(mn_coord(400,420),mn_coord(150,300))
    p = EPoint(mn_coord(300,200))
    l2 = l.parallel(p, speed=2)
    l2.green()

    p = EPoint(mn_coord(200,200))
    l2 = l.parallel(p)
    l2.blue()


def perpendicular():
    l = ELine(mn_coord(400,420),mn_coord(150,300))

    # drop a perpendicular - fully animated
    p = EPoint(mn_coord(300,200))
    l.perpendicular(p,speed=2)

    # draw perpendicular from line - not fully animated
    p = EPoint(l.point(mn_scale(50)))
    l.perpendicular(p)


def brace():
    l = ELine(mn_coord(400,420),mn_coord(150,300))
    l.e_brace(side=LineLabelSide.INSIDE)

def copy_to_line():
    # the line we want to copy
    l = ELine(mn_coord(300,320),mn_coord(150,300)).blue()

    # the line we want to copy to (target_line)
    p1 = EPoint(mn_coord(150,400),label="A")
    p2 = EPoint(mn_coord(400, 400),label="B")
    l1 = ELine(p1,p2).green()

    # get the starting point of line.  It will be drawn in the same direction as the target_line is drawn
    # (from start to end
    location = EPoint(l1.point(mn_scale(50))).add_label(r"\alpha")
    l_new, p_new = l.copy_to_line(location, l1)
    p_new.add_label(r"\beta")
    l_new.red()


    # the line we want to copy to (target_line)
    p1 = EPoint(mn_coord(100, 500), label='A')
    p2 = EPoint(mn_coord(200, 500), label='B')
    l1 = ELine(p1, p2).green()

    # get the starting point of line.  It will be drawn in the same direction as the target_line is drawn
    # (from start to end
    location = EPoint(l1.point(mn_scale(50))).add_label(r"\alpha")
    l_new, p_new = l.copy_to_line(location, l1, speed=2)
    p_new.add_label(r"\beta")
    l_new.red()


    # # the line we want to copy to (target_line)
    # p1 = EPoint(mn_coord(100, 600)).e_fade()
    # p2 = EPoint(mn_coord(150, 600)).e_fade()
    # l1 = ELine(p1, p2).green()
    #
    # # get the starting point of line.  It will be drawn in the same direction as the target_line is drawn
    # # (from start to end)
    # location = EPoint(l1.point(mn_scale(50))).add_label("a")
    # l_new, p_new = l.copy_to_line(location, l1, speed=2)
    #
    # p_new.add_label("b")
    # l_new.red()


def copy_to_point():
    l = ELine(mn_coord(350,120),mn_coord(150,100)).blue()
    p = EPoint(mn_coord(250,180)).blue()
    l1,p1 = l.copy_to_point(p)
    l1.red()
    p1.red()

    l = ELine(mn_coord(350,120),mn_coord(150,100)).blue()
    p = EPoint(mn_coord(200,200)).blue()
    l.copy_to_point(p,speed = 2)


def show_parts():
    l = ELine(mn_coord(350,120),mn_coord(150,100))
    l.show_parts(3)
    l.show_parts(5,buff=2*LINE_SHOW_PARTS_BUFF, color=mn.RED)

def rotate_to():
    pass

def subtract():
    l = ELine(mn_coord(250,300),mn_coord(150,100)).green()
    l2 = ELine(mn_coord(300,100), mn_coord(250, 120)).red()
    l3 = l.subtract(l2, speed = 1).white()
    EPoint(l3.e_start).add_label('start', align=mn.DL)
    EPoint(l3.e_end).add_label('end', align=mn.DL)

def e_split():
    A = EPoint(mn_coord(250,300)).add_label("A")
    B = EPoint(mn_coord(150,100)).add_label("B")

    l = ELine(mn_coord(250,300),mn_coord(150,100)).green()

    C = l.bisect().add_label("C")
    print(C)

    lines = l.e_split(C)
    lines[0].green()
    lines[1].red()

def bisect():
    l = ELine(mn_coord(250,300),mn_coord(150,100)).green()
    p = l.bisect()
    p.add_label("B")

def extend():
    # adjusts existing line
    A = EPoint(mn_coord(250,300)).add_label("A")
    B = EPoint(mn_coord(150,100)).add_label("B")
    l = ELine(A,B).green()
    l.prepend(mn_scale(50))
    l.extend(mn_scale(50))

    # makes new lines
    A = EPoint(mn_coord(400,300)).add_label("A")
    B = EPoint(mn_coord(300,100)).add_label("B")
    l = ELine(A,B)
    l.prepend_cpy(mn_scale(50)).green()
    l.extend_cpy(mn_scale(50)).blue()

    # places original line on top of other lines
    l.white()

def intersect_unbound_lines():
    l = ELine(mn_coord(250,300),mn_coord(150,100)).green()
    l2 = ELine(mn_coord(150,300),mn_coord(250,100)).green()
    intersections = l.intersect_line(l2)
    for i in intersections:
        EPoint(i)

    l = ELine(mn_coord(360,180),mn_coord(400,100)).red()
    l2 = ELine(mn_coord(340,180),mn_coord(300,100)).red()
    intersections = l.intersect_line(l2)
    for i in intersections:
        EPoint(i)

    l = ELine(mn_coord(510,180),mn_coord(550,100)).blue()
    l2 = ELine(mn_coord(550,300),mn_coord(450,100)).blue()
    intersections = l.intersect_line(l2)
    for i in intersections:
        EPoint(i)

    l = ELine(mn_coord(600,300),mn_coord(700,100))
    l2 = ELine(mn_coord(620,300),mn_coord(720,100))
    intersections = l.intersect_line(l2)
    for i in intersections:
        EPoint(i)


def intersect_bound_lines():
    l = ELine(mn_coord(250,300),mn_coord(150,100)).green()
    l2 = ELine(mn_coord(150,300),mn_coord(250,100)).green()
    intersections = l.intersect_bound_lines(l2)
    for i in intersections:
        EPoint(i)


    l = ELine(mn_coord(360,180),mn_coord(400,100)).red()
    l2 = ELine(mn_coord(340,180),mn_coord(300,100)).red()
    intersections = l.intersect_bound_lines(l2)
    for i in intersections:
        EPoint(i)

    l = ELine(mn_coord(510,180),mn_coord(550,100)).blue()
    l2 = ELine(mn_coord(550,300),mn_coord(450,100)).blue()
    intersections = l.intersect_bound_lines(l2)
    for i in intersections:
        EPoint(i)

def intersects():

    # intersects EArc
    l = ELine(mn_coord(500,300),mn_coord(400,100)).blue()
    a = EArc(mn_scale(200), mn_coord(600, 250), mn_coord(400, 200)).blue()
    intersections = l.intersect(a, reverse=True)
    for i in intersections:
        EPoint(i)

    # intersect circle
    l = ELine(mn_coord(120,120),mn_coord(250,250))
    c1 = ECircle(mn_coord(250,250),mn_coord(350,250))
    intersections = l.intersect(c1)
    for i in intersections:
        EPoint(i)

    # intersect line
    l = ELine(mn_coord(750,300),mn_coord(650,100)).green()
    l2 = ELine(mn_coord(650,300),mn_coord(750,100)).green()
    intersections = l.intersect(l2)
    for i in intersections:
        EPoint(i)


    # intersect line
    l = ELine(mn_coord(870,195),mn_coord(850,100)).red()
    l2 = ELine(mn_coord(900,250),mn_coord(950,100)).red()
    intersections = l.intersect(l2)
    for i in intersections:
        print(euclid_coord(*i))
        EPoint(i)





def point():
    l1 = ELine(mn_coord(140, 140), mn_coord(300,200))
    p = l1.point(mn_scale(200))
    EPoint(p).add_label("r=200", align=mn.LEFT)
    p = l1.point(mn_scale(-30))
    EPoint(p).add_label("r=-30", align=mn.RIGHT)
    p = l1.point(mn_scale(50))
    EPoint(p).add_label("r=50", align=mn.LEFT)



def line_labels():
    l1 = ELine(mn_coord(140, 140), mn_coord(300,200))
    l1.add_label('A',direction=mn.RIGHT)

    l2 = ELine(mn_coord(140, 240), mn_coord(300,300))
    l2.add_label('B',side=LineLabelSide.INSIDE)

    l3 = ELine(mn_coord(140, 340), mn_coord(300,400))
    l3.add_label('C',side=LineLabelSide.OUTSIDE)

    l4 = ELine(mn_coord(440, 140), mn_coord(600,200))
    l4.add_label('D',side=LineLabelSide.OUTSIDE, alpha = 0.1)

    l5 = ELine(mn_coord(440, 240), mn_coord(600,300))
    l5.add_label('E',direction=mn.LEFT, alpha = 0.0)

def line_dash_and_undash():
    A = (425,30)
    B = (750,30)
    t1 = TextBox(mn_coord(20, 20))

    for i in range(4):
        pos_space = (i+1) * 0.1
        op = (i+1) * 0.2
        text = f"positive_space_ratio={pos_space:.1f},   final_opacity={op:.1f}"
        t1.explain(text)
        l = ELine(mn_coord(A[0],A[1]+i*25), mn_coord(B[0],B[1]+i*25))
        l.dash(dash_length=mn.DEFAULT_DASH_LENGTH,positive_space_ratio=pos_space, final_opacity=op)

def highlight():
    l = ELine(mn_coord(40, 40), mn_coord(100,100))
    l.notice()

def line_no_label():
    p1 = EPoint(mn_coord(140,300))
    p2 = EPoint(mn_coord(300,140))
    l1 = ELine(mn_coord(140, 140), mn_coord(300,300))
    l2 = ELine(p1,p2).blue()

def line_rotate():
    l = ELine(mn_coord(40, 40), mn_coord(100,100))
    l.e_rotate(mn_coord(110, 110),3.14/2)(run_time=200)

def line_label_no_direction():
    l = ELine(mn_coord(40, 40), mn_coord(100,100), label='A')