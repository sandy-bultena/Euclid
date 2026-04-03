import sys
import os
sys.path.append(os.getcwd())

from euclidlib.Scenes.PropScene import PropScene
from euclidlib.Objects import *
from euclidlib.Utilities.coordinate_utilities import *
from manimlib import *

class Book1Prop1(PropScene):
    title = "To construct an equilateral triangle on a given finite straight line."
    steps = []

    def run_full(self):
        notice()

    def go(self):
        pass

def notice():
    p1 = EPoint([1,1,0])
    p1.notice()

def move_to():

    p1 = EPoint([1,1,0])
    print("Create p2")
    p2 = EPoint([2,2,0])
    print(p2.get_center())
    print("blue p2")
    p2.scene.play(p2.animate.set_color(color=mn.BLUE))
    p2.blue()
    print("p2.get_center")
    print(p2.get_center())
    p1.scene.play(Write(Text(f"No get_center before 'blue'  before moving x={p2.get_center()[0]:.2f}", font_size=30)))
    p1.scene.play(p1.animate.move_to([3,3,0]))
    p1.scene.play(p2.animate.move_to([3,3,0]))


    p1.scene.wait(0.5)
    p1.scene.clear()


    p1 = EPoint([1,1,0])
    p2 = EPoint([2,2,0])
    print(p2.get_center())
    p2.blue()
    print(p2.get_center())
    p1.scene.play(Write(Text(f"Yes get_center before 'blue'  before moving x={p2.get_center()[0]:.2f}", font_size=30)))
    p1.scene.play(p1.animate.move_to([3,3,0]))
    p1.scene.play(p2.animate.move_to([3,3,0]))


def point_no_label():
    p = EPoint(mn_coord(20, 20))

def point_with_label():
    p = EPoint(mn_coord(100, 100), label='A')

def clock():
    p = EPoint(mn_coord(500,150)).add_label(r"\text{aligned left}", align=mn.LEFT)
    p = EPoint(mn_coord(500,200)).add_label(r"\text{aligned right}", align=mn.RIGHT)

    # center of clock
    p = EPoint(mn_coord(400,400))

    # labels on the outside, use 'away_from'= mn.Vect3
    for hour in range(1,13):
        xc,yc,_ = p.coordinates
        angle = (mn.PI/2 - mn.PI/6 * hour)%mn.TAU
        x = xc + mn_scale(100)*math.cos(angle)
        y = yc + mn_scale(100)*math.sin(angle)
        EPoint((x,y,0)).add_label(str(hour),away_from=[xc,yc,0])

    # center of clock
    p = EPoint(mn_coord(800,400))

    # labels on the outside, use 'towards'= mn.Object
    for hour in range(1,13):
        xc,yc,_ = p.coordinates
        angle = (mn.PI/2 - mn.PI/6 * hour)%mn.TAU
        x = xc + mn_scale(120)*math.cos(angle)
        y = yc + mn_scale(120)*math.sin(angle)
        EPoint((x,y,0)).add_label(str(hour),towards=p)