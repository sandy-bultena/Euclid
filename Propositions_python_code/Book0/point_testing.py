import itertools
import sys
import os

sys.path.append(os.getcwd())
from euclidlib.Scenes.BookScene import BookScene
from euclidlib.Objects import *
from euclidlib.Objects.utils import *
from euclidlib.Objects.CustomAnimation import EAnimationOf

class Prop0(BookScene):
    title = "Testing Points"

    def go(self):

        A = mn_coord(200, 500)
        B = mn_coord(450, 500)
        l: dict[str | int, ELine] = {}
        p: dict[str | int, EPoint] = {}
        c: dict[str | int, ECircle] = {}

        t1 = TextBox(mn_coord(800, 150), line_width=mn_h_scale(500))

        t1.title("Construction:")
        t1.explain("Start with line segment AB")
        p['A'] = EPoint(A, scene=self, label_args=('A', LEFT))
        # p['B'] = EPoint(B, scene=self, label_args=('B', RIGHT))
