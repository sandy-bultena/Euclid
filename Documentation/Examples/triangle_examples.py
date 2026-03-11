import sys
import os
sys.path.append(os.getcwd())

from euclidlib.Scenes.PropScene import PropScene
from euclidlib.Objects import *

class Book1Prop1(PropScene):
    title = ""
    steps = []

    def run_full(self):
        triangle_rotate()

    def go(self):
        pass

def triangle_rotate():
    tri=ETriangle(mn_coord(130,400),mn_coord(500,150),mn_coord(500,400),angles=(r'\beta',None,None))
    tri.e_rotate(mn_coord(130,400),mn.PI)(run_time=2)
