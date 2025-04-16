import manimlib as mn
import numpy as np
from euclidlib.Objects import EucidMObject as EM, EGroup, PsuedoGroup, mn_scale
from euclidlib.Objects import Line as Line


class Dashable(PsuedoGroup):
    def get_group(self):
        to_ret = [*self.tick_marks]
        if self.dash_ref is not None:
            to_ret.append(to_ret)
        return to_ret

    def __init__(self, *args, **kwargs):
        self.dash_ref: DashPath | None = None
        self.tick_marks = EGroup()
        super().__init__(*args, **kwargs)

    def remove_dash(self):
        if self.dash_ref is not None:
            self.dash_ref.e_remove()

    def dash(self,
             dash_length: float = mn.DEFAULT_DASH_LENGTH,
             positive_space_ratio: float = 0.5,
             final_opacity=0):
        self.remove_dash()
        with self.scene.simultaneous():
            self.dash_ref = DashPath(self, dash_length, positive_space_ratio)
            self.scene.play(self.animate.set_stroke(opacity=final_opacity))

        self.dash_ref.disable_updaters()
        self.dash_ref.f_always.become(lambda: DashPath(self, dash_length, positive_space_ratio, delay_anim=True))

    def _find_tangent_vec(
            self,
            alpha: float,
            d_alpha: float = 1e-6,
    ):
        a1 = np.clip(alpha - d_alpha, 0, 1)
        a2 = np.clip(alpha + d_alpha, 0, 1)
        return mn.normalize(self.pfp(a2) - self.pfp(a1))

    def _find_normal_vec(self,
                         alpha: float,
                         d_alpha: float = 1e-6):
        return mn.rotate_vector(self._find_tangent_vec(alpha, d_alpha), mn.PI/2)

    def tick(self, at_length, tick_size=mn.SMALL_BUFF, label=None):
        alpha = at_length / self.get_arc_length()
        direction = self._find_normal_vec(alpha)
        if direction[1] < 0:
            direction = -direction
        point = self.point_from_proportion(alpha)
        if isinstance(label, str):
            label = (label, -direction, dict(buff=mn.SMALL_BUFF/2 + Line.ELine.LabelBuff))

        self.tick_marks.add(Line.ELine(
            point - direction * tick_size/2,
            point + direction * tick_size/2,
            label=label
        ))

    def even_ticks(self, period: float, tick_size=mn.SMALL_BUFF, labels=()):
        self.clear_ticks()
        position = period
        label_iter = iter(labels)
        with self.scene.delayed():
            while position < (self.get_arc_length() - mn_scale(1)):
                self.tick(position, tick_size, label=next(label_iter, None))
                position += period

    def clear_ticks(self):
        if self.tick_marks:
            with self.scene.simultaneous():
                self.tick_marks.e_remove()
            self.tick_marks.clear()


    def un_dash(self, final_opacity=1):
        with self.scene.simultaneous():
            self.remove_dash()
            self.scene.play(self.animate.set_stroke(opacity=final_opacity))
        self.dash_ref = None


class DashPath(mn.DashedVMobject, EM.EMObject):
    def CreationOf(self, *args, **kwargs):
        return [mn.FadeIn(self, *args, **kwargs, run_time=self.CONSTRUCTION_TIME)]

    def RemovalOf(self, *args, **kwargs):
        return [mn.FadeOut(self, *args, **kwargs, run_time=self.CONSTRUCTION_TIME)]

    @staticmethod
    def calculate_num_dashes(vmobject_ref: mn.VMobject, dash_length: float, positive_space_ratio: float) -> int:
        try:
            full_length = dash_length / positive_space_ratio
            return int(np.ceil(vmobject_ref.get_arc_length() / full_length))
        except ZeroDivisionError:
            return 1

    def __init__(self,
                 vmobject_ref: mn.VMobject,
                 dash_length: float = mn.DEFAULT_DASH_LENGTH,
                 positive_space_ratio: float = 0.5,
                 **kwargs):
        num_dashes = DashPath.calculate_num_dashes(vmobject_ref, dash_length, positive_space_ratio)
        super().__init__(vmobject_ref, num_dashes=num_dashes, positive_space_ratio=positive_space_ratio, **kwargs)
        self.set_stroke(opacity=1)

    def enable_updaters(self):
        self.resume_updating()

    def disable_updaters(self):
        self.suspend_updating()
