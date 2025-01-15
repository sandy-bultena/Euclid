from __future__ import annotations

from euclidlib.Objects import Point as P
from euclidlib.Objects import Circle
from euclidlib.Objects import Triangle as T
import math
from euclidlib.Objects import EquilateralTriangle
from typing import Dict, Tuple
from euclidlib.Objects.EucidMObject import *

class EuclidLine(EMObject, mn.Line):
    CONSTRUCTION_TIME = 0.5
    LabelBuff = mn.SMALL_BUFF

    def __init__(self, start: EMObject | mn.Vect3, end: EMObject | mn.Vect3, *args, **kwargs):
        self.e_start = convert_to_coord(start)
        self.e_end = convert_to_coord(end)
        super().__init__(start, end, *args, **kwargs)

    def e_label_point(self, direction: mn.Vect3):
        return mn.midpoint(self.get_start(), self.get_end())

    def point(self, r: float):
        p3x, p3y, *_ = self.get_end()
        xs, ys, *_ = self.get_start()
        dx = p3x - xs
        dy = p3y - ys
        if dx == dy == 0:
            return xs, ys

        x = r / math.sqrt(dy**2 + dx**2) * dx + xs
        y = r / math.sqrt(dy**2 + dx**2) * dy + ys
        return x, y

    def extend(self, r: float):
        x2, y2 = self.point(r + self.get_length())
        self.e_end = (x2, y2, 0)
        self.scene.play(self.animate.set_points_by_ends(self.e_start, self.e_end))

    def prepend(self, r: float):
        x2, y2 = self.point(-r)
        self.e_start = (x2, y2, 0)
        self.scene.play(self.animate.set_points_by_ends(self.e_start, self.e_end))

    def copy_to_point(self, target: P.EuclidPoint, speed=1) -> Tuple[EuclidLine, P.EuclidPoint]:
        A = self.e_start
        B = self.e_end
        C = target.get_center()

        l: Dict[str | int, EuclidLine] = {}
        p: Dict[str | int, P.EuclidPoint] = {}
        c: Dict[str | int, Circle.EuclidCircle] = {}
        t: Dict[str | int, T.EuclidTriangle] = {}

        with self.scene.animation_speed(speed):
            # ------------------------------------------------------------------------
            # If point is already on the line, just make a clone, and return results
            # ------------------------------------------------------------------------
            if abs(A[0] - C[0]) < 0.1 and abs(A[1] - C[1] < 0.1):
                lCF = self.copy()
                pF = P.EuclidPoint(C, scene=self.scene)
                return lCF, pF

            # ------------------------------------------------------------------------
            # Copy the line to the new point using methods from proposition 2
            # ------------------------------------------------------------------------

            # join the two lines
            l['AC'] = EuclidLine(A, C, scene=self.scene).e_fade()

            # construct equilateral on above line (D = apex of triangle)
            t[1], p['D'] = EquilateralTriangle.build(self.scene, A, C)
            with self.scene.simultaneous():
                l['AD'] = t[1].l[2]
                l['CD'] = t[1].l[1]
            with self.scene.simultaneous():
                t[1].e_fade()

            def find_extended_intersection(p1, p2, circle, line):
                c[circle] = Circle.EuclidCircle(p1, p2, scene=self.scene).e_fade()
                pts = c[circle].intersect(l[line])
                for _ in range(100):
                    if pts:
                        break
                    l[line].extend(to_manim_v_scale(100))
                    pts = c[circle].intersect(l[line])
                else:
                    raise Exception("Infinite Loop")
                l[line].e_fade()
                return pts


            pts = find_extended_intersection(A, B, 'C', 'AD')

            p['E'] = P.EuclidPoint(pts[0], scene=self.scene)
            p['B'] = P.EuclidPoint(B, scene=self.scene)

            if p['D'].distance_to(pts[0]) > 1:
                F = find_extended_intersection(p['D'], p['E'], 'D', 'CD')
            else:
                F = p['E'].get_center()

            pF = P.EuclidPoint(F[0], scene=self.scene)
            lCF = EuclidLine(C, F[0], scene=self.scene)

            with self.scene.simultaneous():
                for group in (p, l, c, t):
                    for obj in group.values():
                        obj.e_remove()

            return lCF, pF




class VirtualLine(EuclidLine):
    Virtual = True