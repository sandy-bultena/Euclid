"""Any text of string object"""
from __future__ import annotations

import itertools
from abc import ABC
from typing import Optional, Iterable, Any
import re
import manimlib as mn
from functools import reduce, partial

from euclidlib.CONSTANTS import *
from euclidlib.Objects.em_object_base import EMObject
from euclidlib.Objects import CustomAnimation as CA, EGroupedObjects, EIndexedGroup

# =====================================================================================================================
# numbers used to calculate how fast the text is written to the screen
# =====================================================================================================================
INIT_TEXT_RUN_TIME = 0.5
INCREASE_PER_CHARACTER = 0.02
DELAYED_INCREASE = 20

# =====================================================================================================================
# LATEX SYMBOLS
# https://tug.ctan.org/info/symbols/comprehensive/symbols-a4.pdf
# =====================================================================================================================

MARKUP_REPLACE = (
    (re.compile(r'\{nb:(.*?)}'), r'<span allow_breaks="false">\g<1></span>'),
    (re.compile(r'(\S+)\{nb}(\S+)'), r'<span allow_breaks="false">\g<1> \g<2></span>')
)

MATH_PREAMBLE = (
    r'\usepackage{pifont}'
    # r'\usepackage{unicode-math}'
    r'\usepackage[normalem]{ulem}'
    r'\usepackage{stix}'
    r'\newcommand{\ecrossmark}{\textrm{\ding{55}}}',
    r'\newcommand{\echeckmark}{\textrm{\ding{51}}}'
)

TEX_REPLACE = (
    (re.compile(r'\{txt:(.*?)}'), r'\\text{\1}'),
    (re.compile(r'\{mstrike:(.*?)}'), r'\\text{\\sout{\\ensuremath{\1}}}'),
    (re.compile(r'\{strike:(.*?)}'), r'\\sout{\1}'),
    #(re.compile(r'\\square'),r'\\blacksquare')
)

# not sure what this is for
mn.TEX_TO_SYMBOL_COUNT[R"\ne"] = 1
mn.TEX_TO_SYMBOL_COUNT[R"\neq"] = 1
mn.TEX_TO_SYMBOL_COUNT[R"\relax"] = 0
mn.TEX_TO_SYMBOL_COUNT[R"\ensuremath"] = 0
mn.TEX_TO_SYMBOL_COUNT[R"\ifmmode"] = 0
mn.TEX_TO_SYMBOL_COUNT[R"\else"] = 0
mn.TEX_TO_SYMBOL_COUNT[R"\fi"] = 0
mn.TEX_TO_SYMBOL_COUNT[R"\sout"] = 1


# =====================================================================================================================
# String Object - Base Class for EText, ETexText, EMarkupText, Label
# =====================================================================================================================
class EStringObj(EGroupedObjects, mn.StringMobject, ABC):
    style = str | None
    REPLACEMENT_RULES = ()

    # -----------------------------------------------------------------------------------------------------------------
    # initialize
    # -----------------------------------------------------------------------------------------------------------------
    def __init__(self, txt, *args, write_simultaneous=False, style=None | str, colours = None, animate_part=None, **kwargs):

        self.style = style
        self.write_simultaneous = write_simultaneous
        if not hasattr(self, 'em_object'):
            self.em_object: Optional[EMObject] = None
        self.original_text = txt
        self.text = self.apply_rules(txt)
        self.parts: list[EStringObj] = []
        if "stroke_width" not in kwargs:
            kwargs["stroke_width"]=0

        ordered_colours = []
        if style == "math":
            self.text, ordered_colours = self.replace_squares(colours)

        super().__init__(
            self.text,
            *args,
            animate_part=['set_fill'] if animate_part is None else animate_part,
            isolate=r"\blacksquare",
            **kwargs
        )

        # colouring parts
        for index, colour in enumerate(ordered_colours):
            self.get_parts_by_tex(r"\blacksquare")[index].set_color(Colour.on_top_of(colour, BACKGROUND_COLOUR,
                                                                                     (1-E_FILL_OPACITY_FACTOR)))


        if colours is not None and style != "math":
            for txt, colour in colours:
                if Colour.luminosity(colour) > MATH_SQUARE_MIN_LUMINOSITY:
                    colour = Colour.set_luminosity(colour, MATH_SQUARE_MIN_LUMINOSITY)
                self.set_color_by_tex(txt, colour)

    # -----------------------------------------------------------------------------------------------------------------
    # in math mode, change \square to blacksquare, if there is a colour associated with it
    # -----------------------------------------------------------------------------------------------------------------
    def replace_squares(self, colours: Optional[dict[str,str]] = None) -> tuple[str, list[str]]:
        if colours is None:
            return self.text, []
        final_colours = []
        squares = [(match.span(),match.group(1)) for match in re.finditer(r'\\square\s+([A-Za-z]+)', self.text)]
        new_text = ""
        pos = 0
        for square in squares:
            new_text += self.text[pos:square[0][0]]
            if square[1] in colours:
                final_colours.append(colours[square[1]])
                new_text += fr'\blacksquare {square[1]}'
            else:
                new_text += fr'\square {square[1]}'
            pos = square[0][1]

        new_text += self.text[pos:]
        return new_text, final_colours

    # -----------------------------------------------------------------------------------------------------------------
    # only 'group' like required methods
    # -----------------------------------------------------------------------------------------------------------------
    def get_group(self):
        if self.parts:
            return mn.VGroup(*self.parts)
        else:
            return []

    def get_manager(self):
        if self.parts:
            return []
        else:
            return self,

    # -----------------------------------------------------------------------------------------------------------------
    # modify the text based on any rules that apply
    # -----------------------------------------------------------------------------------------------------------------
    def apply_rules(self, txt):
        """apply substitutions on the txt according to the specified rules"""
        return reduce(lambda part, rule: rule[0].sub(rule[1], part), self.REPLACEMENT_RULES, txt)

    # -----------------------------------------------------------------------------------------------------------------
    # create the text by transforming other text into this text
    # -----------------------------------------------------------------------------------------------------------------
    def transform_from(self, other: mn.VGroup | EStringObj, substr: str = '', **transform_args):
        copy = other.copy() if not substr else other[substr].copy()
        if not substr and isinstance(other, EStringObj):
            animation_type = mn.TransformMatchingStrings
        elif substr == self.string:
            animation_type = CA.MoveToAndReplace  # lambda a, b, **args: a.animate(**args).move_to(b)
        else:
            animation_type = mn.TransformMatchingParts
        return self.scene.play(animation_type(copy, self, **transform_args))


    # -----------------------------------------------------------------------------------------------------------------
    # properties
    # -----------------------------------------------------------------------------------------------------------------
    @property
    def is_frozen(self):
        if self.em_object is not None:
            return self._freeze or self.em_object.is_frozen
        else:
            return self._freeze

    @property
    def CONSTRUCTION_TIME(self):
        return INIT_TEXT_RUN_TIME + INCREASE_PER_CHARACTER * max(0, len(self.string) - DELAYED_INCREASE)


    # -----------------------------------------------------------------------------------------------------------------
    # highlight the text
    # -----------------------------------------------------------------------------------------------------------------
    def notice(self, color=mn.RED, *args, **kwargs):
        return mn.FlashAround(self, *args, color=color, **kwargs)

    # -----------------------------------------------------------------------------------------------------------------
    # create or remove
    # -----------------------------------------------------------------------------------------------------------------
    def CreationOf(self, *args, stroke_color=STROKE_COLOUR, stroke_width=0.5, **kwargs):
        return [mn.Write(self,
                         stroke_color=stroke_color,
                         stroke_width=stroke_width,
                         lag_ratio=(0.02 if self.write_simultaneous else -1),
                         **kwargs, )]

    def RemovalOf(self, *args, stroke_color=TEXT_REMOVAL_STROKE_COLOUR, stroke_width=0.5, lag_ratio=0, **kwargs):
        return [CA.UnWrite(self,
                           stroke_color=stroke_color,
                           stroke_width=stroke_width,
                           lag_ratio=lag_ratio,
                           **kwargs)]

    def __str__(self):
        return f"[{type(self).__name__}: {self.text}]"
    def __repr__(self):
        return str(self)

    # -----------------------------------------------------------------------------------------------------------------
    # get and set state - not sure what this is for
    # -----------------------------------------------------------------------------------------------------------------
    # def __getstate__(self):
    #     state = super().__getstate__().copy()
    #     if 'reconstruct_string' in state:
    #         del state['reconstruct_string']
    #     return state
    #
    # def __setstate__(self, state):
    #     super().__setstate__(state)
    #     self.parse()

    # def intersect(self, other: mn.Mobject, reverse=True):
    #     return False
    #
    # def set_parts_color(self, selector: mn.Selector, color: mn.ManimColor):
    #     if isinstance(selector, str):
    #         selector = self.apply_rules(selector)
    #     elif hasattr(selector, '__iter__'):
    #         selector = [self.apply_rules(sel) if isinstance(selector, str) else sel for sel in selector]
    #     self.select_parts(selector).set_color(color)
    #     return self

# =====================================================================================================================
# EText
# =====================================================================================================================
class EText(EStringObj, mn.Text):
    pass


# =====================================================================================================================
# ETexText (Tex stuff)
# =====================================================================================================================
class ETexText(EStringObj, mn.TexText):
    REPLACEMENT_RULES = TEX_REPLACE
    tex_environment: str = ""


    # -----------------------------------------------------------------------------------------------------------------
    # init
    # -----------------------------------------------------------------------------------------------------------------
    def __init__(self, text, *args, alignment='', font='', line_width=None, **kwargs):

        # set the packages required for tex
        packages = r'''
            \usepackage[no-math]{{fontspec}}
        '''
        preamble = '\n'.join(MATH_PREAMBLE) + rf'''
            \setmainfont[Mapping=tex-text]{{{font}}}
        '''

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


# =====================================================================================================================
# ETexText (Tex stuff)
# =====================================================================================================================
class EMarkupText(EStringObj, mn.MarkupText):
    REPLACEMENT_RULES = MARKUP_REPLACE
    MARKUP_TAGS = {**mn.MarkupText.MARKUP_TAGS, 'nb': {"allow_breaks": 'false'}}


# CHECKMARKS AND CROSSES
# https://tex.stackexchange.com/questions/641080/different-checkmarks-and-crossmarks-xmarks-matched-very-well-with-each-other

# =====================================================================================================================
# ETex (Tex Math stuff)
# =====================================================================================================================
class ETex(EStringObj, mn.Tex):
    REPLACEMENT_RULES = TEX_REPLACE

    def __init__(self, text, *args, is_axiom=False,  **kwargs):
        if is_axiom:
            kwargs['fill_color'] = E_BLUE
        super().__init__(
            text,
            *args,
            template='empty_ctex',
            additional_preamble='\n'.join([
                r'\usepackage{amsmath}',
                r'\usepackage{amssymb}',
                r'\usepackage{xcolor}',
                *MATH_PREAMBLE
            ]),
            **kwargs)




# =====================================================================================================================
# Label (written in math Tex)
# =====================================================================================================================
class Label(ETex):

    # -----------------------------------------------------------------------------------------------------------------
    # initialize
    # -----------------------------------------------------------------------------------------------------------------
    def __init__(self, text, em_object: EMObject, *args, align=mn.ORIGIN, **extra_args):
        self.em_object = em_object
        self.args = args
        self.extra_args = extra_args
        self.align = align
        super().__init__(text, font_size=LABEL_FONT_SIZE, scene=em_object.scene, delay_anim=True)

        # if you move the object, you move the label text
        self.f_always.move_to(
            lambda: em_object.e_label_location(*self.args, **self.extra_args),
            aligned_edge=lambda: self.align
        )

    # -----------------------------------------------------------------------------------------------------------------
    # CreationOf and RemovalOf are used to define the animations for the manim 'play'
    # -----------------------------------------------------------------------------------------------------------------
    def CreationOf(self, *args, **kwargs):
        if self.em_object is not None:
            kwargs['run_time'] = self.em_object.CONSTRUCTION_TIME
        return super().CreationOf(*args, **kwargs, stroke_color=mn.GREY,
                                  rate_func=mn.squish_rate_func(mn.smooth, 0.1, 1))

    def RemovalOf(self, *args, **kwargs):
        if self.em_object is not None:
            kwargs['run_time'] = self.em_object.CONSTRUCTION_TIME
        kwargs['run_time'] = self.em_object.AUX_CONSTRUCTION_TIME
        return super().RemovalOf(*args, **kwargs, rate_func=mn.squish_rate_func(mn.smooth, 1, 0.9))

    # -----------------------------------------------------------------------------------------------------------------
    # manim stuff maybe?
    # -----------------------------------------------------------------------------------------------------------------
    def enable_updaters(self):
        self.resume_updating()

    def disable_updaters(self):
        # print(f"STOP {self.em_object} -> {self}:{self.string}")
        self.suspend_updating()

    # -----------------------------------------------------------------------------------------------------------------
    # change the EMObject that this label is associated with
    # -----------------------------------------------------------------------------------------------------------------
    def transfer_ownership(self, emobject: EMObject):
        if emobject.e_label is not None:
            emobject.e_label.e_remove()
        emobject.e_label = self
        self.em_object.e_label = None
        self.em_object = emobject


# =====================================================================================================================
# A group of labels (used for a gnomon)
# =====================================================================================================================
class LabelGroup(EIndexedGroup[Label]):

    # -----------------------------------------------------------------------------------------------------------------
    # initialize
    # -----------------------------------------------------------------------------------------------------------------
    def __init__(self, labels, em_object: EMObject):

        """
        :param labels: a list of labels where each label could contain positional arguments and keyword arguments
        :param em_object: the object that this label will be attached to
        """
        self.em_object = em_object
        super().__init__(animate_part=['set_e_fill'])

        with self.scene.simultaneous():
            for txt, pos, kw in labels:
                self.add(Label (txt, em_object, *pos, **kw))

    # -----------------------------------------------------------------------------------------------------------------
    # defining how 'e_set_fill' will work for a label group
    # -----------------------------------------------------------------------------------------------------------------
    def set_e_fill(self, *args, **kwargs):
        with self.scene.simultaneous():
            for label in self:
                if isinstance(label, Label):
                    label.set_fill(*args, **kwargs)


    # -----------------------------------------------------------------------------------------------------------------
    # overload CreationOf by specifying
    # -----------------------------------------------------------------------------------------------------------------
    def CreationOf(self, *args, **kwargs):
        kwargs['run_time'] = self.em_object.CONSTRUCTION_TIME
        return [
            y
            for x in self
            for y in x.CreationOf(*args, **kwargs)
        ]

    def RemovalOf(self, *args, **kwargs):
        kwargs['run_time'] = self.em_object.AUX_CONSTRUCTION_TIME

        return [
            y
            for x in self
            for y in x.RemovalOf(*args, **kwargs)
        ]

    # -----------------------------------------------------------------------------------------------------------------
    # manim stuff
    # -----------------------------------------------------------------------------------------------------------------
    def enable_updaters(self):
        for x in self:
            x.resume_updating()

    def disable_updaters(self):
        for x in self:
            x.suspend_updating()

    # apply the manim 'become' to all labels
    def become(self,obj,*args):
        with self.scene.simulataneous():
            for label in self:
                if isinstance(label, Label):
                    super().become(label,*args)

    # -----------------------------------------------------------------------------------------------------------------
    # change the EMObject that these labels are associated with
    # -----------------------------------------------------------------------------------------------------------------
    def transfer_ownership(self, emobject: EMObject):
        if emobject.e_label is not None:
            emobject.e_label.e_remove()
        emobject.e_label = self
        self.em_object.e_label = None
        self.em_object = emobject


