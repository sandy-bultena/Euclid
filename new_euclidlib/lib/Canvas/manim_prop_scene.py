from __future__ import annotations

import traceback
from enum import Enum
import sys
import os
from typing import Callable, Optional

sys.path.append(os.getcwd())

import manimlib as mn
from os import getenv

ALL_MODIFIERS = mn.SHIFT_MODIFIER | mn.COMMAND_MODIFIER



class AnimState(Enum):
    NORMAL = 0
    STORING = 1
    PAUSED = 2
    SKIP = 3


class PropScene(mn.InteractiveScene):
    title: str = ''
    steps: list[Callable[[], None]] = []
    animationCountObject: mn.DecimalNumber

    # -------------------------------------------------------------------------------------------------------------
    # initialize
    # -------------------------------------------------------------------------------------------------------------
    def __init__(self, *args, **kwargs):
        self.animateState: list[AnimState] = [AnimState.NORMAL]
        self.animationsStored = []
        self.animationSpeedStack: list[float] = []
        self.traceStack: list[str] = []
        self.default_wait_time = 2

        self.paused = False

        self.drawing = False
        self.drawings = mn.VGroup(z_index=10)

        self.title: Optional[str] = kwargs.pop("title", None)
        self.number: Optional[str] = kwargs.pop("number", None)

        super().__init__(*args, **kwargs)

        # modifications made while running this code through environment variables
        self.debug = getenv('DEBUG') or ''
        self._speed = float(getenv('SPEED', 1))

    def construct(self):
        try:
            self.animationCountObject = mn.DecimalNumber(num_decimal_places=0).to_corner(mn.DR)
            if self.debug:
                self.add(self.animationCountObject)
            circle = mn.Circle()
            self.add(circle)
            #self.run_full()
        except Exception:
            traceback.print_exc()

    # -------------------------------------------------------------------------------------------------------------
    # drawing subs
    # -------------------------------------------------------------------------------------------------------------
    def enable_draw(self):
        self.drawing = True
    def disable_draw(self):
        self.drawing = False
    def toggle_draw(self):
        self.drawing = not self.drawing

    # def gather_selection_euclid(self):
    #     self.is_selecting = False
    #     self.to_highlight = []
    #     if self.selection_rectangle in self.mobjects:
    #         self.remove(self.selection_rectangle)
    #         single = False
    #         if self.selection_rectangle.get_arc_length() < 1e-2:
    #             single = True
    #             self.selection_rectangle.set_width(0.1)
    #             self.selection_rectangle.set_height(0.1)
    #         for mob in reversed(self.get_selection_search_set()):
    #             if not isinstance(mob, EM.EMObject):
    #                 continue
    #             if not mob.visible():
    #                 continue
    #             try:
    #                 if mob.intersect(self.selection_rectangle):
    #                     self.to_highlight.append(mob)
    #                     if single:
    #                         break
    #
    #             except NotImplementedError as e:
    #                 log.warn(str(e))
    #                 pass

    # -------------------------------------------------------------------------------------------------------------
    # setup up key presses for additional functionality
    # -------------------------------------------------------------------------------------------------------------
    def on_key_press(self, symbol: int, modifiers: int):

        # (manimgl Interactive Scene already has default bindings)
        # SELECT_KEY = 's'
        # UNSELECT_KEY = 'u'
        # GRAB_KEY = 'g'
        # X_GRAB_KEY = 'h'
        # Y_GRAB_KEY = 'v'
        # GRAB_KEYS = [GRAB_KEY, X_GRAB_KEY, Y_GRAB_KEY]
        # RESIZE_KEY = 't'
        # COLOR_KEY = 'c'
        # INFORMATION_KEY = 'i'
        # CURSOR_KEY = 'k'
        # COPY_FRAME_POSITION_KEY = 'p'

        super().on_key_press(symbol, modifiers)
        char = chr(symbol)
        print(f"on key press: {char} {modifiers}")

        if char == 'z' and (modifiers & ALL_MODIFIERS) == 0:
            pass
            # self.enable_selection()


    def on_key_release(self, symbol: int, modifiers: int) -> None:
        char = chr(symbol)
        print(f"on key release: {char} {modifiers}")
        if char == 'z':
            pass
            # self.gather_selection_euclid()
            # anims = [t.highlight() for t in self.to_highlight]
            # if anims:
            #     self.play(*anims)
            # self.to_highlight = []
        elif char == 'x' and (modifiers & ALL_MODIFIERS) == 0:
            self.toggle_draw()
            if self.drawing:
                self.enable_draw()
                self.drawings.add(mn.VMobject())
                self.add(self.drawings[-1])

        elif char == 'c' and (modifiers & ALL_MODIFIERS) == 0:
            self.remove(self.drawings)
            self.drawings.clear()
            self.disable_draw()

        else:
                super().on_key_press(symbol, modifiers)

    def on_mouse_motion(self, point: mn.Vect3, d_point: mn.Vect3) -> None:
        pass
        if self.drawing:
            latest = self.drawings[-1]
            if not latest.has_points():
                latest.set_points_as_corners([point - d_point, point])
            else:
                latest.add_line_to(point)
        return super().on_mouse_motion(point, d_point)

    # -------------------------------------------------------------------------------------------------------------
    # wait until next step should be drawn ... pause is undone if 'space' key is pressed
    # -------------------------------------------------------------------------------------------------------------
    def pause(self):

        # Start a loop that runs until the user unpauses
        self.paused = True
        while True:
            if not self.paused:
                break
            self.wait(1)


