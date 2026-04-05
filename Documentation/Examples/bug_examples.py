import sys
import os


sys.path.append(os.getcwd())

from euclidlib.Scenes.PropScene import PropScene
from euclidlib.Objects import *


class Book1Prop1(PropScene):
    title = ""
    steps = []

    def run_full(self):
        print(mn.__version__)
        simultaneous()

    def go(self):
        pass

def simultaneous():
    scene = find_scene()
    A=[-1,-1,0]
    B=[0,0,0]
    C=[0,-1,0]

    t1 = TextBox(mn_coord(100, 50))
    t1.explain("Construction without simultaneous")

    l1 = ELine(A, B).blue()
    l2 = ELine(B,C).green()
    l3 = ELine(C,A).red()
    sABD = ETriangle.assemble(lines=[l1,l2,l3]).e_fill(mn.BLUE)

    with scene.simultaneous():
        A += 2*mn.RIGHT
        B += 2*mn.RIGHT
        C += 2*mn.RIGHT
        t1.explain("Construction with simultaneous")
        l1 = ELine(A, B).blue()
        l2 = ELine(B, C).green()
        l3 = ELine(C, A).red()
        sABD = ETriangle.assemble(lines=[l1, l2, l3]).e_fill(mn.BLUE)

    with scene.simultaneous():
        A += 2*mn.RIGHT
        B += 2*mn.RIGHT
        C += 2*mn.RIGHT
        t1.explain("Construction with simultaneous  - but no triangle assemble")
        l1 = ELine(A, B).blue()
        l2 = ELine(B, C).green()
        l3 = ELine(C, A).red()
