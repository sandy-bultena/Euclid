from manimlib import LEFT, RIGHT

from euclidlib.Objects import ELine, EPoint, ECircle, TextBox, mn_coord, mn_scale, EMObject
from euclidlib.Scenes.PropScene import PropScene

class Prop(PropScene):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    def title(self):
        pass

    def reset(self):
        for sub in self.mobjects:
            if isinstance(sub, EMObject):
               sub.e_remove()

    def go(self):
        pass
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(500))
        A = mn_coord(200, 500)
        B = mn_coord(450, 500)
        C = mn_coord(200+100, 500+100)
        D = mn_coord(450+100, 500+100)

        t = t1.explain("standard animation")
        l: dict[str | int, ELine] = {}
        p: dict[str | int, EPoint] = {}
        p['x'] = EPoint(A, label_args=("X", RIGHT))


        p['A'] = EPoint(A, scene=self, label_args=('A', LEFT))
        p['B'] = EPoint(B, scene=self, label_args=('B', RIGHT))
        l['AB'] = ELine(p['A'], p['B'], scene=self)
        p['C'] = EPoint(C, scene=self, label_args=('A', LEFT))
        p['D'] = EPoint(D, scene=self, label_args=('B', RIGHT))
        l['CD'] = ELine(p['C'], p['D'], scene=self)

        self.next_page()
        self.reset()

        t = t1.explain("simultaneous animation")

        with self.simultaneous():
            p['A'] = EPoint(A, scene=self, label_args=('A', LEFT))
            p['B'] = EPoint(B, scene=self, label_args=('B', RIGHT))
            l['AB'] = ELine(p['A'], p['B'], scene=self)
            p['C'] = EPoint(C, scene=self, label_args=('A', LEFT))
            p['D'] = EPoint(D, scene=self, label_args=('B', RIGHT))
            l['CD'] = ELine(p['C'], p['D'], scene=self)



