from manimlib import *

class ManimBug(Scene):
    def construct(self):
        p1 = Circle(arc_center=(1,1,0), radius=.2)
        self.play(ShowCreation(p1))

        p2 = Circle(arc_center=(2,2,0), radius=.2, stroke_color=BLUE)
        self.play(ShowCreation(p2))

        self.play(p1.animate.set_color(color=BLUE))

        self.play(p1.animate.move_to([3, 3, 0]))
        self.play(p2.animate.move_to([3, 3, 0]))

        # p1.scene.wait(0.5)
        # p1.scene.clear()
        #
        # p1 = EPoint([1, 1, 0])
        # p2 = EPoint([2, 2, 0])
        # print(p2.get_center())
        # p2.blue()
        # print(p2.get_center())
        # p1.scene.play(
        #     Write(Text(f"Yes get_center before 'blue'  before moving x={p2.get_center()[0]:.2f}", font_size=30)))
        # p1.scene.play(p1.animate.move_to([3, 3, 0]))
        # p1.scene.play(p2.animate.move_to([3, 3, 0]))
