from __future__ import annotations
from collections import defaultdict
from typing import Mapping, TYPE_CHECKING, Optional, Literal
import manimlib as mn
import numpy as np
from euclidlib.debugging import print_debug

from .EuclidMObject import EMObject
from .EuclidGroupMObject import EGroup, PsuedoGroup
from . import Text as T
from . import CustomAnimation as CA
from contextlib import contextmanager
import sys

from euclidlib.Propositions import PropScene as ps
if TYPE_CHECKING:
    from . import EStringObj

INIT_TEXT_RUN_TIME = 0.5
INCREASE_PER_CHARACTER = 0.02
DELAYED_INCREASE = 20
DEFAULT_TEXT_FADE_OPACITY = 0.3

class StringPlacement:
    def __init__(self, align_to: Optional[EStringObj] = None, **kwargs ):
        self.align_to = align_to




# class TextBuffer(EMObject, mn.Square):
#     def CreationOf(self, *args, **kwargs):
#         return []
#
#     def __init__(self, size, scene, **kwargs):
#         super().__init__(size, stroke_opacity=0, **kwargs, scene=scene)

# =====================================================================================================================
# Fonts
# =====================================================================================================================
# Font Contenders:
# Consolas, Arial, Gotu, Menlo, Lucida Grande, Monaco, Optima, Verdana
class Fonts:
    fonts: dict[str, tuple[type[T.EStringObj], dict]]

    if sys.platform == 'darwin':  # MAC CHECK
        fonts = dict(
            title=(T.EMarkupText, dict(font_size=24, font='Gotu')),
            explain=(T.EMarkupText, dict(font_size=16, font='Gotu')),
            sidenote=(T.EMarkupText, dict(font_size=16, font='Gotu', slant='ITALIC')),
            explainM=(T.ETexText, dict(font_size=16, font='Gotu')),
            normal=(T.EText, dict(font_size=14, font='Gotu')),
            math=(T.ETex, dict(font_size=22)),
            fancy=(T.EText, dict(font_size=24, font='Charm')),
            title_screen=(T.EText, dict(font_size=48, font='Bradley Hand')),
        )

    elif sys.platform == 'linux':
        fonts = dict(
            title=(T.EMarkupText, dict(font_size=30, font='Arimo', weight=mn.BOLD)),
            explain=(T.EMarkupText, dict(font_size=18, font='Arimo')),
            sidenote=(T.EMarkupText, dict(font_size=18, font='Arimo', slant='ITALIC')),
            explainM=(T.ETexText, dict(font_size=18, font='Arimo')),
            normal=(T.EText, dict(font_size=16, font='Arimo')),
            math=(T.ETex, dict(font_size=20)),
            fancy=(T.EText, dict(font_size=36, font='Z003')),
            title_screen=(T.EText, dict(font_size=128, font='Karumbi'))
        )
    else:
        fonts = dict(
            title=(T.EMarkupText, dict(font_size=30, weight=mn.BOLD)),
            explain=(T.EMarkupText, dict(font_size=18)),
            sidenote=(T.EMarkupText, dict(font_size=18, slant='ITALIC')),
            explainM=(T.ETexText, dict(font_size=18)),
            normal=(T.EText, dict(font_size=16)),
            math=(T.ETex, dict(font_size=20)),
            fancy=(T.EText, dict(font_size=36)),
            title_screen=(T.EText, dict(font_size=128))
        )




# =====================================================================================================================
# Text Box - inherits from EGroup with StringObj
# =====================================================================================================================
class TextBox(EGroup[T.EStringObj]):
    """A Container of StringObj
        TextBox inherits from EGroup and manimgl.VGroup"""
    # -----------------------------------------------------------------------------------------------------------------
    # Class properties
    # -----------------------------------------------------------------------------------------------------------------
    AUX_CONSTRUCTION_TIME = 0.1
    ALIGNMENT = {
        None: (mn.Mobject.get_left, mn.LEFT),
        'e': (mn.Mobject.get_left, mn.LEFT),
        'w': (mn.Mobject.get_right, mn.RIGHT),
        'n': None,
    }

    # -----------------------------------------------------------------------------------------------------------------
    # define buffer size between text objects
    # -----------------------------------------------------------------------------------------------------------------
    @property
    def buff_size(self):
        """define buffer size between text objects"""
        return self._buff_size if self else 0

    # -----------------------------------------------------------------------------------------------------------------
    # initialization
    # -----------------------------------------------------------------------------------------------------------------
    def __init__(self,
                 absolute_position: tuple[float, float, float],
                 scene: ps.PropScene | None = None,
                 *args,
                 line_width: float = None,
                 alignment: Optional[Literal['n','e','w']]=None,
                 buff_size=mn.SMALL_BUFF,
                 **kwargs):
        """
        :param absolute_position: the position to place this textbox (north-west corner)
        :param scene: where are the text objects going to be played (Proposition Scene)
        :param args: additional arguments which are being ignored here, but passed to superclass (EGroup)
        :param line_width: specify the line width of the text
        :param alignment: text to be aligned in this box via 'n', 'e', or 'w' directions
        :param buff_size: space between subsequent texts being added to this textbox
        :param kwargs: additional keyword arguments being ignored here, but passed to superclass (EGroup)
        """

        self.abs_position = absolute_position
        self.scene = scene
        self.line_width = line_width
        self.alignment = self.ALIGNMENT[alignment]
        self._buff_size = buff_size

        self.extra_buffer_size = 0
        self.indent_value = 0
        self.bullet_symbol = None
        super().__init__(*args, **kwargs, scene=scene, stroke_width=0)

    def __str__(self):
        return f"[{type(self).__name__}: {self.abs_position} {self.line_width=}]"
    def __repr__(self):
        return str(self)

    # -----------------------------------------------------------------------------------------------------------------
    # generate the text
    # -----------------------------------------------------------------------------------------------------------------
    def _generate_text(self,
                       text_str: str,
                       style: str = '',
                       /,
                       align_index: int | T.EStringObj = -1,
                       align_str: mn.SingleSelector | tuple[mn.SingleSelector, mn.SingleSelector] | None = None,
                       align_to_args:Optional[list|tuple] = None,
                       transform_from: T.EStringObj | int = None,
                       transform_args: dict = None,
                       delay_anim=False,
                       skip_anim=False,
                       break_into_parts: tuple[str, ...] | str | None = None,
                       **other_options) -> tuple[EStringObj, ...]:
        """

        :param text_str:
        :param style:
        :param align_index:
        :param align_str:
        :param align_to_args:
        :param transform_from:
        :param transform_args:
        :param delay_anim:
        :param skip_anim:
        :param break_into_parts:
        :param other_options:
        :return:
        """
        cls, kwargs = self._setup_kwargs(style, other_options)
        bullet = None
        parts = None
        print()
        print(f"{text_str=} align_str='{align_str}' {break_into_parts=} {align_to_args=}")

        with self.scene.simultaneous():
            # create the text and fix the text in frame (is always displayed at a fixed position on the screen)
            newline = cls(text_str, **kwargs, scene=self.scene, delay_anim=True)
            newline.fix_in_frame()

            # place the text
            if align_to_args:
                self.align_to(*align_to_args)
            elif align_str:
                self.align_string_with_other_string(newline, align_str, align_index)
                self.extra_buffer_size = 0
            else:
                newline.next_to(self.get_bottom(), mn.DOWN, buff=self.buff_size + self.extra_buffer_size)
                self.extra_buffer_size = 0
                self.justify_text(newline)

            # add bullet_symbol (i.e. bullet marker)
            if self.bullet_symbol:
                bullet = cls(self.bullet_symbol, **kwargs, scene=self.scene, delay_anim=True)
                bullet.next_to(newline[0], mn.LEFT, buff=mn.SMALL_BUFF)
                bullet.e_draw(skip_anim)

            # break the text into parts (so that later we can use individual parts for animation)
            # and do no further processing
            if break_into_parts:
                parts = self._break_into_parts(newline, break_into_parts, delay_anim, skip_anim)

            # not delaying the animation...
            elif not delay_anim:

                if transform_from is not None:
                    self.e_transform_to(newline, transform_args, transform_from)
                else:
                    newline.e_draw(skip_anim)

        # save the text object in the VGroup
        self.add(newline)

        if parts is not None:
            return *parts, newline
        return newline,

    # -----------------------------------------------------------------------------------------------------------------
    # where to put the text with respect to another string
    # -----------------------------------------------------------------------------------------------------------------
    def align_string_with_other_string(self, original_str: EStringObj,
                                       align_str: mn.SingleSelector | tuple[mn.SingleSelector, mn.SingleSelector] | None,
                                       align_index: int | T.EStringObj,
                                       align_to_args):

        # get the object we need to align to
        print(f"---- align_str {align_str}")
        if isinstance(align_str, str):
            align_str = (align_str, align_str)
        align_obj = align_index if isinstance(align_index, T.EStringObj) else self[align_index]
        print(f"--- align_obj = {align_obj}")
        print()
        print()

        # align string "align_str[0]" to "align_str[1]" (below)
        original_str.next_to(
            align_obj[align_str[0]].get_bottom(),
            mn.DOWN,
            buff=self.buff_size + self.extra_buffer_size,
            index_of_submobject_to_align=align_str[1],
        )
        original_str.next_to(align_obj, mn.DOWN, buff=self.buff_size, coor_mask=mn.UP)


    # -----------------------------------------------------------------------------------------------------------------
    # align text (north, south, east, west)
    # -----------------------------------------------------------------------------------------------------------------
    def justify_text(self, newline):
        if self.alignment:
            (get_side, side) = self.alignment
            newline.align_to(get_side(self), side)
            newline.shift(mn.RIGHT * self.indent_value)

    # -----------------------------------------------------------------------------------------------------------------
    # break the text into parts (purpose: so that you can use the different parts for transform_from later on
    # -----------------------------------------------------------------------------------------------------------------
    def _break_into_parts(self,
                          text_obj:EStringObj,
                          break_into_parts: Optional[tuple[str|tuple[str,dict], ...] | str],
                          delay_anim,
                          skip_anim,
                          ):
        text_str: str = text_obj.text

        # if the break_into_parts is a string instead of an array, use that to break text into its parts
        if isinstance(break_into_parts, str):
            break_into_parts = text_str.split(break_into_parts)

        # create the text objects for each part
        parts = []
        for part in break_into_parts:
            print(f"part={part}")
            if isinstance(part, str):
                parts.extend(self._generate_text(part, text_obj.style, delay_anim=True))
            else:
                part,kwargs = part[0:2]
                print(f"...PART: {part} ")
                print(f"...KWARGS: {kwargs}")
                parts.extend(self._generate_text(part, text_obj.style, delay_anim=True, **kwargs))

        # align the parts next to each other
        for p, t in zip(parts, break_into_parts):
            if isinstance(p, str):
                parts.extend(self._generate_text(p, text_obj.style, delay_anim=True))
            else:
                p = p[0]
            p.next_to(text_obj[t], mn.ORIGIN, buff=0)
            if not delay_anim:
                p.e_draw(skip_anim)

        return *parts,

    # -----------------------------------------------------------------------------------------------------------------
    # transform text from one object to another
    # -----------------------------------------------------------------------------------------------------------------
    def e_transform_to(self, text_obj, transform_args, transform_from):
        transform_args = transform_args or {}

        if isinstance(transform_from, int):
            transform_from = self[transform_from]

        self.scene.play(mn.TransformMatchingStrings(
            transform_from.copy(),
            text_obj,
            **transform_args,
        ))

    # -----------------------------------------------------------------------------------------------------------------
    # managing items
    # -----------------------------------------------------------------------------------------------------------------
    def e_remove(self):
        super().e_remove()
        self.clear()

    def __delitem__(self, key):
        self[key].e_remove()
        self.remove(self[key])

    def __delslice__(self, i, j):
        for x in self[i:j]:
            x.e_remove()
        self.remove(*self[i:j])

    def delete_last(self):
        del self[-1]

    # -----------------------------------------------------------------------------------------------------------------
    # return all string objects
    # -----------------------------------------------------------------------------------------------------------------
    def get_group(self):
        """return all EStringObj objects in this textbox"""
        return [x for x in self if isinstance(x, T.EStringObj)]

    # -----------------------------------------------------------------------------------------------------------------
    # calculate the bounding box
    # -----------------------------------------------------------------------------------------------------------------
    def compute_bounding_box(self):
        """
        If there are objects stored in 'self', then return the manim calculated bounding box (3d) for all elements, or
        return a 3d bound box around the n/w corner of this text box
        :return:  Lower left and upper right corners of bounding box
        """
        if self:
            return super().compute_bounding_box()
        x, y, _ = self.abs_position
        return np.array([[x, y, 0]] * 3)


    # -----------------------------------------------------------------------------------------------------------------
    # managing items
    # -----------------------------------------------------------------------------------------------------------------
    def e_update(self, index, text: str, transform_args=None, **kwargs):
        old = self[index]
        transform_args = transform_args or {}
        assert isinstance(old, T.EStringObj)
        new = self._generate_text_no_anim(text, old.style, **kwargs)
        new.next_to(old.get_corner(mn.UL), mn.DR, buff=0)
        self.scene.play(CA.AppendString(old, new, **transform_args))
        self.replace_submobject(index, new)

    def e_append(self, index, text: str, **kwargs):
        old = self[index]
        assert isinstance(old, T.EStringObj)
        new = self._generate_text_no_anim(text, old.style, **kwargs)
        new.next_to(old.get_right(), mn.RIGHT, buff=mn.SMALL_BUFF)
        new.e_draw()
        old.add(*new.submobjects)

    def e_append_morph(self, index, text: str, color: None = None, transform_args=None, **kwargs):
        if color:
            kwargs['t2c'] = {text: color}
        transform_args = transform_args or {}
        if 'run_time' not in transform_args:
            transform_args['run_time'] = 0.5
        old = self[index]
        new = self._generate_text_no_anim(f"{old.string} {text}", old.style, **kwargs)
        new.next_to(old.get_corner(mn.UL), mn.DR, buff=0)
        self.scene.play(CA.AppendString(old, new, **transform_args))
        self.replace_submobject(index, new)

    # -----------------------------------------------------------------------------------------------------------------
    # managing location of new text strings
    # -----------------------------------------------------------------------------------------------------------------
    def down(self, buff=mn.MED_SMALL_BUFF):
        self.extra_buffer_size = buff

    def indent(self, buff=mn.MED_SMALL_BUFF):
        self.indent_value += buff

    def unindent(self, buff=mn.MED_SMALL_BUFF):
        self.indent_value -= buff

    # -----------------------------------------------------------------------------------------------------------------
    # managing bullets
    # -----------------------------------------------------------------------------------------------------------------
    def set_bullet_symbol(self, text='–'):
        self.bullet_symbol = text

    def reset_bullet_symbol(self):
        self.bullet_symbol = None

    # -----------------------------------------------------------------------------------------------------------------
    # fade/normalize specific objects
    # -----------------------------------------------------------------------------------------------------------------

    def fade_text_objs(self, *objs):
        with self.scene.simultaneous():
            if not objs:
                objs = self.get_group()
            for text_obj in objs:
                text_obj.e_fade()


    def normalize_text_objs(self, *objs):
        with self.scene.simultaneous():
            if not objs:
                objs = self.get_group()
            for text_obj in objs:
                text_obj.e_normal()

    # ----------------------------------------------------------------------------------------------------------------
    # aligning two text strings
    # ----------------------------------------------------------------------------------------------------------------
    def e_math_align_to(self, txt: str,
                        break_into_parts:list[str],
                        which_part: str|int,
                        aligned_to: T.EStringObj,
                        side=mn.LEFT,
                        **kwargs):

        # create the text, but don't animate anything yet
        parts = self.math(txt, break_into_parts=break_into_parts, delay_anim=True, **kwargs)

        # if which_part is a string, find the index that this string is part of
        index = which_part
        if isinstance(which_part, str):
            index = 0
            for i,p in enumerate(parts):
                if p == which_part:
                    index = i
                    break

        # align the bits
        parts[index].align_to(aligned_to, side)

        # animate
        self.scene.play(mn.Write(mn.VGroup(*parts[:-1])))
        self.add(*parts[:-1])

        # return the created parts
        return *parts,

    # ----------------------------------------------------------------------------------------------------------------
    # aligning two text strings AND transform them
    # ----------------------------------------------------------------------------------------------------------------
    def math_align_to_and_transform(self, txt: str,
                        break_into_parts:list[str],
                        which_part: str|int,
                        aligned_to: T.EStringObj,
                        side=mn.LEFT,
                        **kwargs):

        # create the text, but don't animate anything yet
        parts = self.math(txt, break_into_parts=break_into_parts, delay_anim=True, **kwargs)

        # if which_part is a string, find the index that this string is part of
        index = which_part
        if isinstance(which_part, str):
            index = 0
            for i,p in enumerate(parts):
                if p == which_part:
                    index = i
                    break

        # align the bits
        parts[index].align_to(aligned_to, side)

        # animate
        self.scene.play(mn.Write(mn.VGroup(*parts[:-1])))
        self.add(*parts[:-1])

        # return the created parts
        return *parts,

    # -----------------------------------------------------------------------------------------------------------------
    # Private: generate the text preamble
    # -----------------------------------------------------------------------------------------------------------------
    def _setup_kwargs(self, style, other_options)->tuple[type[T.EStringObj], dict]:
        cls, kwargs = Fonts.fonts[style]
        kwargs = kwargs | other_options
        kwargs['style'] = style
        if ((cls is T.ETexText or issubclass(cls, (mn.MarkupText, T.ETexText))) and
                self.line_width is not None):
            kwargs['line_width'] = self.line_width
        return cls, kwargs

    # -----------------------------------------------------------------------------------------------------------------
    # Private: generate text but don't add it to the scene
    # -----------------------------------------------------------------------------------------------------------------
    def _generate_text_no_anim(self, text: str, style: str = '', delay_anim=True, **other_options):
        cls, kwargs = self._setup_kwargs(style, other_options)
        newline = cls(text, **kwargs, scene=self.scene, delay_anim=delay_anim)
        newline.fix_in_frame()
        return newline



    # ----------------------------------------------------------------------------------------------------------------
    # create functions for all of the text styles
    # ----------------------------------------------------------------------------------------------------------------
    def title(self, text: str,
              align_index: int | T.EStringObj = -1,
              align_str: mn.SingleSelector | tuple[mn.SingleSelector, mn.SingleSelector] | None = None,
              transform_from: T.EStringObj | int = None,
              transform_args: dict = None,
              break_into_parts: tuple[str, ...] | str | None = None,
              **kwargs,
              ) -> T.EStringObj: ...

    def explain(self, text: str,
                align_index: int | T.EStringObj = -1,
                align_str: mn.SingleSelector | tuple[mn.SingleSelector, mn.SingleSelector] | None = None,
                transform_from: T.EStringObj | int = None,
                transform_args: dict = None,
                break_into_parts: tuple[str, ...] | str | None = None,
                **kwargs,
                ) -> T.EStringObj: ...

    def explainM(self, text: str,
                 align_index: int | T.EStringObj = -1,
                 align_str: mn.SingleSelector | tuple[mn.SingleSelector, mn.SingleSelector] | None = None,
                 transform_from: T.EStringObj | int = None,
                 transform_args: dict = None,
                 break_into_parts: tuple[str, ...] | str | None = None,
                 **kwargs,
                 ) -> T.EStringObj: ...

    def normal(self, text: str,
               align_index: int | T.EStringObj = -1,
               align_str: mn.SingleSelector | tuple[mn.SingleSelector, mn.SingleSelector] | None = None,
               transform_from: T.EStringObj | int = None,
               transform_args: dict = None,
               break_into_parts: tuple[str, ...] | str | None = None,
               **kwargs,
               ) -> T.EStringObj: ...

    def math(self, text: str,
             align_index: int | T.EStringObj = -1,
             align_str: mn.SingleSelector | tuple[mn.SingleSelector, mn.SingleSelector] | None = None,
             transform_from: T.EStringObj | int = None,
             transform_args: dict = None,
             break_into_parts: tuple[str, ...] | str | None = None,
             **kwargs,
             ) -> T.EStringObj: ...

    def fancy(self, text: str,
              align_index: int | T.EStringObj = -1,
              align_str: mn.SingleSelector | tuple[mn.SingleSelector, mn.SingleSelector] | None = None,
              transform_from: T.EStringObj | int = None,
              transform_args: dict = None,
              break_into_parts: tuple[str, ...] | str | None = None,
              **kwargs,
              ) -> T.EStringObj: ...

    def title_screen(self, text: str,
                     align_index: int | T.EStringObj = -1,
                     align_str: mn.SingleSelector | tuple[mn.SingleSelector, mn.SingleSelector] | None = None,
                     transform_from: T.EStringObj | int = None,
                     transform_args: dict = None,
                     break_into_parts: tuple[str, ...] | str | None = None,
                     **kwargs,
                     ) -> T.EStringObj: ...

    def sidenote(self, text: str,
                     align_index: int | T.EStringObj = -1,
                     align_str: mn.SingleSelector | tuple[mn.SingleSelector, mn.SingleSelector] | None = None,
                     transform_from: T.EStringObj | int = None,
                     transform_args: dict = None,
                     break_into_parts: tuple[str, ...] | str | None = None,
                     **kwargs,
                     ) -> T.EStringObj: ...

    def _write_text(self, style, text: str, **kwargs):
        objs, *rest = self._generate_text(text, '{style}', **kwargs)
        print(text)
        return objs, *rest

    for style in Fonts.fonts:
        exec(f"""
def {style}(self, text: str, **kwargs):
    objs, *rest = self._generate_text(text, '{style}', **kwargs)
    print(text)
    return (objs,*rest)
""")


