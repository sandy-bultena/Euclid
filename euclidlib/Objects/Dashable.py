from typing import Self, List, Type
import manimlib as mn
import numpy as np
import euclidlib.Objects.em_object_base as EM
from euclidlib.Objects.em_group_object  import EIndexedGroup, EGroupedObjects
from euclidlib.Utilities.coordinate_utilities import mn_scale, convert_to_coord, mn_coord

from . import Line

# NEEDS MORE COMMENTING
# ================================================================================================================
# Dashable
# -- allows inherited classes to have their strokes dashed (a dashed line for example) as well as tick marks
# ================================================================================================================
class Dashable(EGroupedObjects):

    # ------------------------------------------------------------------------------------------------------------
    # constructor
    # ------------------------------------------------------------------------------------------------------------
    def __init__(self, *args, **kwargs):
        self.dash_ref: DashPath | None = None
        self.tick_marks = EIndexedGroup()
        self.tick_mark_alphas: List[float] = []
        self.dash_options = dict()
        super().__init__(*args, **kwargs)

    # ------------------------------------------------------------------------------------------------------------
    # get list of all objects (for drawing, transformations, colour changes, etc)
    # ------------------------------------------------------------------------------------------------------------
    def get_group(self):
        to_ret = [*self.tick_marks]
        if self.dash_ref is not None:
            to_ret.append(self.dash_ref)
        return to_ret

    # ------------------------------------------------------------------------------------------------------------
    # dash
    #   take parent object, and instead of a solid line, use a dashed line to draw
    # ------------------------------------------------------------------------------------------------------------
    def dash(self,
             dash_length: float = mn.DEFAULT_DASH_LENGTH,
             positive_space_ratio: float = 0.5,
             final_opacity=0,
             delay_anim=False):
        """
        Creates a NEW dashed object overlaying this particular object
        :param dash_length: length of the individual dash
        :param positive_space_ratio: what fraction is the dash compared to the total of dashed + undashed
        :param final_opacity: what is the opacity of the original object after the dashed object is created
        :param delay_anim:
        """
        assert positive_space_ratio > 0

        # remove any existing dash that might have already been there
        self.remove_dash()

        self.dash_options = dict(
            dash_length=dash_length,
            positive_space_ratio=positive_space_ratio
        )

        # animate the change
        with self.scene.simultaneous():
            self.dash_ref = DashPath(self, dash_length, positive_space_ratio, delay_anim=delay_anim or not self.visible())
            if self.visible() and not delay_anim:
                self.scene.play(self.animate.set_stroke(opacity=final_opacity))
            else:
                self.set_stroke(opacity=final_opacity)

        # define what happens while the animation is happening
        self.dash_ref.disable_updaters()
        def updater(dash_ref: DashPath):
            dash_ref.become(DashPath(self, dash_length, positive_space_ratio, delay_anim=True))
        self.dash_ref.add_updater(updater, call=False)
        return self


    # ------------------------------------------------------------------------------------------------------------
    # change the line from dashed to undashed
    # ------------------------------------------------------------------------------------------------------------
    def remove_dash(self):
        if self.dash_ref is not None:
            self.dash_ref.e_remove()
            self.dash_options = dict()
        return self

    # ------------------------------------------------------------------------------------------------------------
    # copy the dashable object
    # ------------------------------------------------------------------------------------------------------------
    def copy(self, deep: bool = False) -> Self:
        cpy: Dashable = super().copy(deep)
        if self.dash_ref is not None:
            cpy.dash_ref = self.dash_ref.copy(deep)
        cpy.tick_marks = self.tick_marks.copy(deep)
        return cpy


    # ------------------------------------------------------------------------------------------------------------
    # transform to
    # ------------------------------------------------------------------------------------------------------------
    def transform_to(self, other: Self, *sub_animations, anim: Type[mn.Animation] = mn.TransformFromCopy):
        animations = []
        if self.dash_ref is not None:
            if other.dash_ref is None:
                other.dash(**self.dash_options, delay_anim=True)
            animations.append(anim(self.dash_ref, other.dash_ref))
        if len(self.tick_marks) > 0:
            if not other.tick_marks:
                for a, t in zip(self.tick_mark_alphas, self.tick_marks):
                    other.tick_prop(a, t.get_length(), delay_anim=True)
            animations.append(anim(self.tick_marks, other.tick_marks))
        return super().transform_to(other, *animations, *sub_animations, anim=anim)

    # ------------------------------------------------------------------------------------------------------------
    # find the normal and tangent vectors (used to create tick marks)
    # ------------------------------------------------------------------------------------------------------------
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

    # ------------------------------------------------------------------------------------------------------------
    # tick_abs
    #   - no idea what this does
    # ------------------------------------------------------------------------------------------------------------
    def tick_abs(self, at_length, tick_size=mn.SMALL_BUFF, label=None, delay_anim=False):
        alpha = at_length / self.get_arc_length()
        self.tick_prop(alpha, tick_size, label, delay_anim)

    def tick_prop(self, alpha, tick_size=mn.SMALL_BUFF, label=None, delay_anim=False):
        direction = self._find_normal_vec(alpha)
        if direction[1] < 0:
            direction = -direction
        point = self.point_from_proportion(alpha)
        if isinstance(label, str):
            label = (label, -direction, dict(buff=mn.SMALL_BUFF/2 + Line.ELine.LabelBuff))

        self.tick_marks.add(Line.ELine(
            point - direction * tick_size/2,
            point + direction * tick_size/2,
            label=label,
            delay_anim=delay_anim or not self.visible()
        ))
        self.tick_mark_alphas.append(alpha)

    def even_ticks(self, period: float, tick_size=mn.SMALL_BUFF, labels=()):
        self.clear_ticks()
        position = period
        label_iter = iter(labels)
        with self.scene.staggered_animation():
            while position < (self.get_arc_length() - mn_scale(1)):
                self.tick_abs(position, tick_size, label=next(label_iter, None))
                position += period

    def clear_ticks(self):
        if self.tick_marks:
            with self.scene.simultaneous():
                self.tick_marks.e_remove()
            self.tick_marks.clear()
            self.tick_mark_alphas.clear()


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
