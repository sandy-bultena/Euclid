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
        book_02_01(self)


    def go(self):
        pass

def book_02_01(scene):
    A = mn_coord(200, 200)
    Ap = mn_coord(350, 200)
    B = mn_coord(200, 250)
    C = mn_coord(550, 250)
    D = mn_coord(375, 250)
    E = mn_coord(500, 250)

    with scene.simultaneous():
        pA = EPoint(A, label=('A', mn.LEFT))
        pB = EPoint(B, label=("B", mn.LEFT))
        pC = EPoint(C, label=("C", mn.RIGHT))
        pD = EPoint(D, label=("D", mn.UP))
        pE = EPoint(E, label=("E", mn.UP))
        lA = ELine(Ap, A, label='a')
        lBD = ELine(B, D, label=('x', dict(side=LineLabelSide.INSIDE)))
        lDE = ELine(D, E, label=('y', dict(side=LineLabelSide.INSIDE)))
        lCE = ELine(E, C, label=('z', dict(side=LineLabelSide.INSIDE)))

    with scene.simultaneous():
        lDK = lBD.perpendicular(pD, length=lA.length)
        lEL = lDE.perpendicular(pE, length=lA.length)
        lCH = lCE.perpendicular(pC, length=lA.length)


def line_with_labels(scene):
    with scene.simultaneous():
        a = ELine([0,1,0],[1,0,0])
        a.add_label("x")
        a = ELine([1, 2, 0], [2, 1, 0])
        a.add_label("y")
    a.e_fade()
    scene.wait(1)
    a.e_normal()

def dashed_lines(scene):
    a = ELine([1, 2, 0], [2, 0, 0]).dash()
    with scene.simultaneous():
        b = ELine([0,0,0],[1,1,0]).dash()
        a.add_label("x")
        b.add_label("b")

# NOTE: don't move an object and expect the label to move with it unless it has already been defined?
def moving_polygons(scene):
    p1 = EPolygon([0,1,0],[1,0,0], [0,0,0], fill=BLUE, label="x")
    p2 = EPolygon([1,1,0],[0,1,0], [0,0,0], fill=BLUE, label="y")
    a=  ELine([0,1,0],[1,0,0])
    with scene.simultaneous():
        p1.e_move([0,-1,0])(run_time=2)
        p2.add_label("x+y")
        p2.e_move([0,1,0])(run_time=2)
        a.add_label("A")
        a.e_move([-1,1,0])(run_time=2)

