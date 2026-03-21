import sys
import os
sys.path.append(os.getcwd())

from euclidlib.Scenes.PropScene import PropScene
from euclidlib.Objects import *

class Book1Prop1(PropScene):
    title = ""
    steps = []

    def run_full(self):
        copy_to_line()

    def go(self):
        pass

def copy_to_point():
    p = EParallelogram(mn_coord(130,400),mn_coord(400,450),mn_coord(350,300)).e_fill(mn.BLUE)
    point = EPoint(mn_coord(500,700)).red()
    new = p.copy_to_point(point, speed=5)
    new.e_fill(mn.GREEN)
    point.lift()

def copy_to_line():
    p = EParallelogram(mn_coord(130,400),mn_coord(400,450),mn_coord(350,300)).e_fill(mn.BLUE)
    line = ELine(mn_coord(150,700),mn_coord(500,700))
    new = p.copy_to_line(line,speed=5)
    new.e_fill(mn.GREEN)

    p = EParallelogram(mn_coord(530,400),mn_coord(800,450),mn_coord(750,300)).e_fill(mn.BLUE)
    line = ELine(mn_coord(550,700),mn_coord(900,700))
    new = p.copy_to_line(line)
    new.e_fill(mn.GREEN)

def parallelogram():
    p = EParallelogram(mn_coord(130,400),mn_coord(400,450),mn_coord(350,300))
