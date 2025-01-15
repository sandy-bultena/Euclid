from __future__ import annotations

from abc import ABC

from . import EucidMObject as E
from . import CustomAnimation as CA
import re
import manimlib as mn

INIT_TEXT_RUN_TIME = 0.5
INCREASE_PER_CHARACTER = 0.02
DELAYED_INCREASE = 20


class EStringObj(E.EMObject, mn.StringMobject, ABC):
    def __init__(self, *args, animate_part=None, **kwargs):
        super().__init__(
            *args,
            stroke_width=0,
            animate_part=['set_fill'] if animate_part is None else animate_part,
            **kwargs
        )

    @property
    def CONSTRUCTION_TIME(self):
        return INIT_TEXT_RUN_TIME + INCREASE_PER_CHARACTER * max(0, len(self.string) - DELAYED_INCREASE)

    def CreationOf(self, *args, stroke_color=mn.BLUE, stroke_width=1, **kwargs):
        return [mn.Write(self, *args, **kwargs, stroke_color=stroke_color, stroke_width=stroke_width)]

    def RemovalOf(self, *args, stroke_color=mn.RED, stroke_width=1, **kwargs):
        return [CA.UnWrite(self, *args, **kwargs, stroke_color=stroke_color, stroke_width=stroke_width)]


class EText(EStringObj, mn.Text):
    pass


class EMarkupText(EStringObj, mn.MarkupText):
    MARKUP_TAGS = {**mn.MarkupText.MARKUP_TAGS, 'nb': {"allow_breaks": 'false'}}

    def markup_to_svg(self, markup_str: str, file_name: str) -> str:
        temp = re.sub(r'\{nb:(.*?)}', r'<span allow_breaks="false">\g<1></span>', markup_str)
        temp = re.sub(r'(\S+)\{nb}(\S+)', r'<span allow_breaks="false">\g<1> \g<2></span>', temp)
        return super().markup_to_svg(temp, file_name)


class ETex(EStringObj, mn.Tex):
    pass


class Label(ETex):
    def CreationOf(self, *args, **kwargs):
        kwargs['run_time'] = self.ref.CONSTRUCTION_TIME
        return super().CreationOf(*args, **kwargs, stroke_color=mn.GREY)

    def RemovalOf(self, *args, **kwargs):
        kwargs['run_time'] = self.ref.AUX_CONSTRUCTION_TIME
        return super().RemovalOf(*args, **kwargs)

    def __init__(self, text, *args, ref: E.EMObject, direction: mn.Vect3, **kwargs):
        self.ref = ref
        super().__init__(text, *args, font_size=20, **kwargs, scene=ref.scene, delay_anim=True)
        self.f_always.next_to(
            lambda: ref.e_label_point(direction),
            direction if callable(direction) else lambda: direction,
            lambda: ref.LabelBuff
        )
