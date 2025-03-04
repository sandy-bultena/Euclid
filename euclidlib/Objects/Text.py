from __future__ import annotations

from abc import ABC

from . import EucidMObject as E
from . import CustomAnimation as CA
from . import EucidGroupMObject as G
import re
import manimlib as mn
from functools import reduce, partial

INIT_TEXT_RUN_TIME = 0.5
INCREASE_PER_CHARACTER = 0.02
DELAYED_INCREASE = 20

# ==============================================================
# LATEX SYMBOLS
# https://tug.ctan.org/info/symbols/comprehensive/symbols-a4.pdf
# ==============================================================

MARKUP_REPLACE = (
    (re.compile(r'\{nb:(.*?)}'), r'<span allow_breaks="false">\g<1></span>'),
    (re.compile(r'(\S+)\{nb}(\S+)'), r'<span allow_breaks="false">\g<1> \g<2></span>')
)

MATH_PREAMBLE = (
    r'\usepackage{pifont}'
    r'\usepackage{unicode-math}'
    r'\usepackage[normalem]{ulem}'
    r'\newcommand{\ecrossmark}{\textrm{\ding{55}}}',
    r'\newcommand{\echeckmark}{\textrm{\ding{51}}}'
)

TEX_REPLACE = (
    (re.compile(r'\{txt:(.*?)}'), r'\\text{\1}'),
    (re.compile(r'\{mstrike:(.*?)}'), r'\\text{\\sout{\\ensuremath{\1}}}'),
    (re.compile(r'\{strike:(.*?)}'), r'\\sout{\1}'),
)

mn.TEX_TO_SYMBOL_COUNT[R"\ne"] = 1
mn.TEX_TO_SYMBOL_COUNT[R"\neq"] = 1
mn.TEX_TO_SYMBOL_COUNT[R"\relax"] = 0
mn.TEX_TO_SYMBOL_COUNT[R"\ensuremath"] = 0
mn.TEX_TO_SYMBOL_COUNT[R"\ifmmode"] = 0
mn.TEX_TO_SYMBOL_COUNT[R"\else"] = 0
mn.TEX_TO_SYMBOL_COUNT[R"\fi"] = 0
mn.TEX_TO_SYMBOL_COUNT[R"\sout"] = 1


class EStringObj(E.EMObject, mn.StringMobject, ABC):
    style = str | None
    REPLACEMENT_RULES = ()

    def __init__(self, txt, *args, write_simultaneous=False, style=None | str, animate_part=None, **kwargs):
        self.style = style
        self.write_simultaneous = write_simultaneous
        super().__init__(
            self.apply_rules(txt),
            *args,
            stroke_width=0,
            animate_part=['set_fill'] if animate_part is None else animate_part,
            **kwargs
        )

    def apply_rules(self, txt):
        return reduce(lambda part, rule: rule[0].sub(rule[1], part), self.REPLACEMENT_RULES, txt)

    def intersect(self, other: mn.Mobject, reverse=True):
        return False

    def set_parts_color(self, selector: mn.Selector, color: mn.ManimColor):
        if isinstance(selector, str):
            selector = self.apply_rules(selector)
        elif hasattr(selector, '__iter__'):
            selector = [self.apply_rules(sel) if isinstance(selector, str) else sel for sel in selector]
        self.select_parts(selector).set_color(color)
        return self

    def transform_from(self, other: mn.VGroup | EStringObj, substr: str = '', **transform_args):
        copy = other.copy() if not substr else other[substr].copy()
        if not substr and isinstance(other, EStringObj):
            animation_type = mn.TransformMatchingStrings
        elif substr == self.string:
            animation_type = CA.MoveToAndReplace#lambda a, b, **args: a.animate(**args).move_to(b)
        else:
            animation_type = mn.TransformMatchingParts
        return self.scene.play(animation_type(copy, self, **transform_args))

    @property
    def CONSTRUCTION_TIME(self):
        return INIT_TEXT_RUN_TIME + INCREASE_PER_CHARACTER * max(0, len(self.string) - DELAYED_INCREASE)

    def CreationOf(self, *args, stroke_color=mn.WHITE, stroke_width=0.5, **kwargs):
        return [mn.Write(self,
                         stroke_color=stroke_color,
                         stroke_width=stroke_width,
                         lag_ratio=(0.02 if self.write_simultaneous else -1),
                         **kwargs, )]

    def RemovalOf(self, *args, stroke_color=mn.RED_A, stroke_width=0.5, lag_ratio=0, **kwargs):
        return [CA.UnWrite(self,
                         stroke_color=stroke_color,
                         stroke_width=stroke_width,
                         lag_ratio=lag_ratio,
                         **kwargs)]

    def __getstate__(self):
        state = super().__getstate__().copy()
        if 'reconstruct_string' in state:
            del state['reconstruct_string']
        return state

    def __setstate__(self, state):
        super().__setstate__(state)
        self.parse()


class EText(EStringObj, mn.Text):
    pass


class ETexText(EStringObj, mn.TexText):
    REPLACEMENT_RULES = TEX_REPLACE
    tex_environment: str = ""

    def __init__(self, text, *args, alignment='', font='', line_width=None, **kwargs):
        packages = r'''
            \usepackage[no-math]{{fontspec}}
        '''
        preamble = rf'''
            \setmainfont[Mapping=tex-text]{{{font}}}
        ''' + '\n'.join(MATH_PREAMBLE)

        if line_width:
            px = line_width / mn.FRAME_WIDTH * mn.DEFAULT_PIXEL_WIDTH / 2.5
            packages += fr'''
                \usepackage[margin=0in,paperwidth={px}pt,verbose,marginparwidth=0pt,marginparsep=0pt]{{geometry}}
            '''

        super().__init__(
            text,
            *args,
            additional_preamble=packages + preamble,
            template='empty_ctex',
            alignment=alignment,
            **kwargs)


class EMarkupText(EStringObj, mn.MarkupText):
    REPLACEMENT_RULES = MARKUP_REPLACE
    MARKUP_TAGS = {**mn.MarkupText.MARKUP_TAGS, 'nb': {"allow_breaks": 'false'}}


# CHECKMARKS AND CROSSES
# https://tex.stackexchange.com/questions/641080/different-checkmarks-and-crossmarks-xmarks-matched-very-well-with-each-other

class ETex(EStringObj, mn.Tex):
    REPLACEMENT_RULES = TEX_REPLACE

    def __init__(self, text, *args, **kwargs):
        super().__init__(
            text,
            *args,
            template='basic_ctex',
            additional_preamble='\n'.join(MATH_PREAMBLE),
            **kwargs)

    pass


class Label(ETex):
    def CreationOf(self, *args, **kwargs):
        kwargs['run_time'] = self.ref.CONSTRUCTION_TIME
        return super().CreationOf(*args, **kwargs, stroke_color=mn.GREY,
                                  rate_func=mn.squish_rate_func(mn.smooth, 0.1, 1))

    def RemovalOf(self, *args, **kwargs):
        kwargs['run_time'] = self.ref.AUX_CONSTRUCTION_TIME
        return super().RemovalOf(*args, **kwargs, rate_func=mn.squish_rate_func(mn.smooth, 1, 0.9))

    def __init__(self, text, ref: E.EMObject, *args, align=mn.ORIGIN, **extra_args):
        self.ref = ref
        self.args = args
        self.extra_args = extra_args
        self.align=align
        super().__init__(text, font_size=20, scene=ref.scene, delay_anim=True)
        self.f_always.move_to(
            lambda: ref.e_label_point(*self.args, **self.extra_args),
            aligned_edge=lambda: self.align
        )

    @property
    def is_frozen(self):
        return self._freeze or self.ref.is_frozen

    def enable_updaters(self):
        # print(f"START {self.ref} -> {self}:{self.string}")
        self.resume_updating()

    def disable_updaters(self):
        # print(f"STOP {self.ref} -> {self}:{self.string}")
        self.suspend_updating()

    def transfer_ownership(self, emobject: E.EMObject):
        if emobject.e_label is not None:
            emobject.e_label.e_remove()
        emobject.e_label = self
        self.ref.e_label = None
        self.ref = emobject
