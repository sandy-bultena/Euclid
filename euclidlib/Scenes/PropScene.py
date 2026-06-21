"""The starting location for showing a proposition"""
from __future__ import annotations

import os
import sys
from itertools import pairwise
import operator as op

import manimlib as mn

import traceback
from enum import Enum

from euclidlib.Objects import *
from os import getenv
from .animate_state import AnimState
from euclidlib.CONSTANTS import *
from PIL import Image


# =====================================================================================================================
# are we writing a video, or we doing this interactively?
# =====================================================================================================================
WRITE_TO_MOVIE = "-w" in sys.argv

# =====================================================================================================================
# PropScene
# - this is the basis for all propositions, inherits from manim's InteractiveScene
# =====================================================================================================================
class PropScene(mn.InteractiveScene):
    """
    Base class for all the propositions
    """
    title: str = ''
    steps: list[Callable[[], None]] = []
    animationCountObject: mn.DecimalNumber

    # -----------------------------------------------------------------------------------------------------------------
    # required methods for PropScene inheritors
    # -----------------------------------------------------------------------------------------------------------------
    def title_page(self):
        raise NotImplementedError()

    def reset(self):
        raise NotImplementedError()

    def last_page(self):
        raise NotImplementedError()


    @mn.abstractmethod
    def go(self) -> None:
        pass

    # -----------------------------------------------------------------------------------------------------------------
    # initialization
    # -----------------------------------------------------------------------------------------------------------------
    def __init__(self, *args, **kwargs):
        self.animateState: list[AnimState] = [AnimState.NORMAL]
        self.animationsStored = []
        self.animationSpeedStack: list[float] = []
        self.traceStack: list[Text] = []
        self.debug = getenv('DEBUG') or ''
        self._speed = float(getenv('SPEED', DEFAULT_SPEED))
        self.drawing = False
        self.drawings = mn.VGroup(z_index=10)
        self.is_selecting = False
        self.to_highlight = []
        self.paused = False
        self.default_speed =float(getenv('SPEED', DEFAULT_SPEED))
        self.slide_number = 0

        super().__init__(*args, **kwargs)

    # -----------------------------------------------------------------------------------------------------------------
    # starting point of the the animation
    # -----------------------------------------------------------------------------------------------------------------
    def construct(self) -> None:
        try:
            self.animationCountObject = mn.DecimalNumber(num_decimal_places=0, fill_color=RED).to_corner(mn.DR)
            if self.debug:
                self.add(self.animationCountObject)
            self.run_full()
            self.next_page()
        except Exception:
            traceback.print_exc()

    # -----------------------------------------------------------------------------------------------------------------
    # clear everything from the page
    # -----------------------------------------------------------------------------------------------------------------
    def clear_all(self):
        with self.simultaneous(run_time=1):
            gg = EIndexedGroup((sub for sub in self.mobjects if isinstance(sub, EMObject)), scene=self)
            gg.e_remove()

    # -----------------------------------------------------------------------------------------------------------------
    # execute all the code in 'go' (which should be defined in the inherited class)
    # -----------------------------------------------------------------------------------------------------------------
    def draw_table_of_contents(self, index=0):
        pass

    def run_full(self):
        with self.animation_speed(self._speed or 1):

            # setup
            try:
                if not self.debug:
                    self.title_page()
                    self.next_page()
            except NotImplementedError:
                pass

            # main work
            self.reset()
            self.go()

            # denouement
            try:
                if not self.debug:
                    self.clear_all()
                    self.last_page()
                    self.wait(10)
                    self.clear()
                    self.draw_table_of_contents(self.prop)
                    self.next_page()
            except NotImplementedError:
                pass

    def clear(self):
        with self.simultaneous(run_time=1):
            gg = EIndexedGroup((sub for sub in self.mobjects if isinstance(sub, EMObject)), scene=self)
            gg.e_remove()

    # -----------------------------------------------------------------------------------------------------------------
    # selection tools
    # -----------------------------------------------------------------------------------------------------------------
    def gather_selection_euclid(self):
        pass
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

    # -----------------------------------------------------------------------------------------------------------------
    # handling all keyboard inputs
    # -----------------------------------------------------------------------------------------------------------------
    def on_key_press(self, symbol: int, modifiers: int) -> None:
        char = chr(symbol)
        super().on_key_press(symbol, modifiers)
        if self.paused and char == "n":
            self.paused = False

        if char == 'z':
            self.enable_selection()
        elif char == 'x':
            self.drawing = True
            self.drawings.add(mn.VMobject())
            self.add(self.drawings[-1])
        elif char == 'c':
            self.remove(self.drawings)
            self.drawings.clear()

    def on_key_release(self, symbol: int, modifiers: int) -> None:
        char = chr(symbol)
        if char == 'z':
            self.gather_selection_euclid()
            anims = [t.highlight() for t in self.to_highlight]
            if anims:
                self.play(*anims)
            self.to_highlight = []
        elif char == 'x':
            self.drawing = False
        else:
            super().on_key_press(symbol, modifiers)

    # -----------------------------------------------------------------------------------------------------------------
    # if drawing mode is on, moving mouse creates a drawing
    # -----------------------------------------------------------------------------------------------------------------
    def on_mouse_motion(self, point: Vect3, d_point: Vect3) -> None:
        if self.drawing:
            latest = self.drawings[-1]
            if not latest.has_points():
                latest.set_points_as_corners([point - d_point, point])
            else:
                latest.add_line_to(point)
        return super().on_mouse_motion(point, d_point)

    # -----------------------------------------------------------------------------------------------------------------
    # adds a counter defining which scene is currently being played
    # -----------------------------------------------------------------------------------------------------------------
    def post_play(self):
        super().post_play()
        self.animationCountObject.increment_value().to_corner(DR)

    # -----------------------------------------------------------------------------------------------------------------
    # adjust the run time so that it moves at a given speed (larger objects will take longer to draw)
    # -----------------------------------------------------------------------------------------------------------------
    def _update_runtime(self, anim: mn.AnimationType, speed: float):

        if not isinstance(anim, mn.Animation):
            # if the animation type is part of the animation builder (ex: obj.animate.set_fill(...)), then
            # create the animation (via the build command)
            anim = anim.build()
        try:
            if isinstance(anim.mobject, EStringObj) and not isinstance(anim.mobject, Label):
                speed = DEFAULT_TEXT_SPEED
        except:
            pass
        anim.set_run_time(anim.get_run_time() / speed)
        return anim

    # -----------------------------------------------------------------------------------------------------------------
    # average? the speed over all the specified speeds
    # -----------------------------------------------------------------------------------------------------------------
    def get_current_speed(self):
        # return mn.reduce(mn.op.mul, self.animationSpeedStack, 1.0)
        if len(self.animationSpeedStack) > 0:
            return self.animationSpeedStack[-1]
        else:
            return self.default_speed

    # -----------------------------------------------------------------------------------------------------------------
    # not sure why wait time should be dependent on the current speed
    # -----------------------------------------------------------------------------------------------------------------
    def wait(self, duration: float = 3, *args, **kwargs):
        super().wait(duration, *args, **kwargs)

    # -----------------------------------------------------------------------------------------------------------------
    # wait for user before printing next page, unless we are creating a video
    # -----------------------------------------------------------------------------------------------------------------
    def next_page(self):
        if WRITE_TO_MOVIE:
            self.wait(10)
            if os.environ.get("SAVE_MANIM_PDF", False):
                print("Saving png for this page!")
                self.save_as_png()
        else:
            self.paused = True
            print("\n\n", "-"*10, self.animationCountObject.get_value(), "-"*10)
            self.wait_until(lambda: not self.paused, 600)
        self.slide_number += 1

    # -----------------------------------------------------------------------------------------------------------------
    # scale
    # -----------------------------------------------------------------------------------------------------------------
    def scale(self, *objs, corner=DL, factor = 1):
        all_objs = EIndexedGroup(sub for obj in objs for sub in obj.get_e_family())
        for x in all_objs:
            if x.e_label is not None:
                x.e_label.enable_updaters()
        self.play(all_objs.animate.scale(factor, about_point=all_objs.get_corner(corner)))
        for x in all_objs:
            if x.e_label is not None:
                x.e_label.disable_updaters()


    # -----------------------------------------------------------------------------------------------------------------
    # play animations
    #   - typically called by the creation of an EuclidObject, via their version of `e_draw`
    #        but can be called by manim directly
    # -----------------------------------------------------------------------------------------------------------------
    def play(self, *anims: mn.AnimationType, **kwargs):

        # if the animation state is normal, then play the animation (makes sense)
        if self.animateState[-1] == AnimState.NORMAL:

            # adjust the speed as required
            speed = self.get_current_speed()
            if 'run_time' in kwargs:
                kwargs['run_time'] /= speed
            else:
                anims = [self._update_runtime(anim, speed) for anim in anims]

            # using manim, play the animation
            super().play(*anims, **kwargs)

            for anim in anims:
                if isinstance(anim, mn.LaggedStart):
                    for subanim in anim.animations:
                        if subanim.is_remover():
                            self.remove(subanim.mobject)
                        else:
                            self.add(subanim.mobject)

        # if `play` is being called within a simultaneous context manager, then the state will have been
        # set to STORING.  So just store the animations until later
        elif self.animateState[-1] == AnimState.STORING:
            self.animationsStored[-1].extend(anims)


        elif self.animateState[-1] == AnimState.SKIP:
            currently_skipping = self.skip_animations
            if not currently_skipping:
                self.force_skipping()
            super().play(*anims, **kwargs)
            if not currently_skipping:
                self.revert_to_original_skipping_status()
        elif self.animateState[-1] == AnimState.PAUSED:
            pass

    # -----------------------------------------------------------------------------------------------------------------
    # and the em objects to the collection of objects in this scene
    # -----------------------------------------------------------------------------------------------------------------
    def add(self, *mobjects: mn.Mobject):

        o = [str(o) for o in mobjects]
        if self.animateState[-1] != AnimState.PAUSED:
            super().add(*mobjects)
        return self

    # -----------------------------------------------------------------------------------------------------------------
    # is the animation in a paused state?
    # -----------------------------------------------------------------------------------------------------------------
    def is_paused(self):
        for x in reversed(self.animateState):
            if x == AnimState.PAUSED:
                return True
            if x == AnimState.STORING:
                continue
            return False
        return False

    # -----------------------------------------------------------------------------------------------------------------
    # remove object from scene
    # -----------------------------------------------------------------------------------------------------------------
    def e_remove(self, *obj):
        with self.simultaneous():
            for o in obj:
                o.e_remove()

    # -----------------------------------------------------------------------------------------------------------------
    # save the current scene as an image
    # -----------------------------------------------------------------------------------------------------------------
    def save_as_png(self):

        # define name of file
        name = f"{self.__class__.__name__}_{self.slide_number:03d}.png"

        # Ensure the directory exists
        path = os.path.join("media", "images", name)
        os.makedirs(os.path.dirname(path), exist_ok=True)

        # Save the current camera view as an image
        Image.fromarray(self.camera.get_pixel_array()).save(path)

    # -----------------------------------------------------------------------------------------------------------------
    # get all the lines defined by the polygon[poly_name] and assign them to lines dictionary
    # -----------------------------------------------------------------------------------------------------------------
    @staticmethod
    def extract_lines(lines: dict[str, ELine], polygons: dict[str, EPolygon], label: str, poly_name=None):
        poly_name = poly_name or label
        label2 = label + label[0]
        for l_label, line in zip(pairwise(label2), polygons[poly_name].l):
            lines[op.add(*l_label)] = line

    # -----------------------------------------------------------------------------------------------------------------
    # get all the points defined by the polygon[poly_name] and assign them to points dictionary
    # -----------------------------------------------------------------------------------------------------------------
    @staticmethod
    def extract_points(points: dict[str, EPoint], polygons: dict[str, EPolygon], label: str, poly_name=None):
        poly_name = poly_name or label
        for p_label, point in zip(label, polygons[poly_name].p):
            points[p_label] = point

    # -----------------------------------------------------------------------------------------------------------------
    # get all the angles defined by the polygon[poly_name] and assign them to angles dictionary
    # -----------------------------------------------------------------------------------------------------------------
    @staticmethod
    def extract_angles(angles: dict[str, EAngleBase], polygons: dict[str, EPolygon], label: str, poly_name=None):
        poly_name = poly_name or label
        label2 = label[-1] + label + label[0]
        for i, angle in enumerate(polygons[poly_name].a):
            if angle is not None:
                angles[label2[i:i + 3]] = angle

    # -----------------------------------------------------------------------------------------------------------------
    # get all the lines/points/angles defined by the polygon[poly_name] and assign them to their appropriate dictionary
    # -----------------------------------------------------------------------------------------------------------------
    @staticmethod
    def extract_all(lines, points, angles, polygons, label, poly_name=None):
        poly_name = poly_name or label
        PropScene.extract_lines(lines, polygons, label, poly_name)
        PropScene.extract_points(points, polygons, label, poly_name)
        PropScene.extract_angles(angles, polygons, label, poly_name)

    # -----------------------------------------------------------------------------------------------------------------
    # context for running animations simultaneously as opposed to one at a time
    # -----------------------------------------------------------------------------------------------------------------
    @mn.contextmanager
    def simultaneous(self, **kwargs):
        self.animateState.append(AnimState.STORING)
        self.animationsStored.append([])
        yield
        self.animateState.pop()
        stored_anims = self.animationsStored.pop()
        if stored_anims:
            self.play(*stored_anims, **kwargs)

    # -----------------------------------------------------------------------------------------------------------------
    # set the animation speed to be the same for everyone
    #
    # yields a list,
    #   if run_time > 0 then list is not used for anything
    #   if the run_time < 0
    #       add any objects to this list, which will be drawn after the code block is completed
    # ... example, @anim (in em_object_decorators) uses this to animate (or not) the intermediate steps
    #              in a construction method (ex: ELine.bisect())
    # -----------------------------------------------------------------------------------------------------------------
    @mn.contextmanager
    def animation_speed(self, speed: float):
        if speed > 0:
            self.animationSpeedStack.append(speed)
            yield []
            self.animationSpeedStack.pop()
        elif speed < 0:
            with self.pause_animations_for() as to_draw:
                yield to_draw
        else:
            yield []



    # -----------------------------------------------------------------------------------------------------------------
    # set the animation speed same for everyone, and draw simultaneously
    # -----------------------------------------------------------------------------------------------------------------
    @mn.contextmanager
    def simultaneous_speed(self, run_time: float, **kwargs):
        with self.animation_speed(run_time):
            with self.simultaneous(**kwargs):
                yield

    # -----------------------------------------------------------------------------------------------------------------
    # pause animation until code block is completed,
    # -----------------------------------------------------------------------------------------------------------------
    @mn.contextmanager
    def pause_animations_for(self, stop=True):
        if stop:
            # pause animations
            to_draw = []
            self.animateState.append(AnimState.PAUSED)

            yield to_draw

            # reset animation
            self.animateState.pop()

            # draw all the objects that need to be drawn
            if len(to_draw) > 0:
                with self.simultaneous():
                    for x in to_draw:
                        x.e_draw()

        else:
            yield []

    def set_base_animation_speed(self, speed: float):
        self.animationSpeedStack[0] = speed


    # -----------------------------------------------------------------------------------------------------------------
    # context for freezing certain objects during the context
    # -----------------------------------------------------------------------------------------------------------------
    @mn.contextmanager
    def freeze(self, *args: EMObject):
        for a in args:
            a.freeze()
        yield
        for a in args:
            a.unfreeze()

    # -----------------------------------------------------------------------------------------------------------------
    # -----------------------------------------------------------------------------------------------------------------
    @mn.contextmanager
    def skip_animations_for(self, stop=True):
        if stop:
            self.animateState.append(AnimState.SKIP)
            yield
            self.animateState.pop()
        else:
            yield

    # -----------------------------------------------------------------------------------------------------------------
    # the start of each animation occurs when lag_ratio percent of the previous animation is completed
    # -----------------------------------------------------------------------------------------------------------------
    @mn.contextmanager
    def staggered_animation(self, lag_ratio=0.3, **kwargs):
        self.animateState.append(AnimState.STORING)
        self.animationsStored.append([])
        yield
        self.animateState.pop()
        stored_anims = self.animationsStored.pop()
        if stored_anims:
            self.play(mn.LaggedStart(*stored_anims, lag_ratio=lag_ratio, **kwargs))
    #
    #
    # @mn.contextmanager
    # def run_animations_for(self, stop=True):
    #     if stop:
    #         self.animateState.append(AnimState.NORMAL)
    #         yield
    #         self.animateState.pop()
    #     else:
    #         yield
    #
    #
    @mn.contextmanager
    def trace(self, *data, font_size=16, **kwargs):
        if 'trace' not in self.debug:
            yield
            return

    # @mn.contextmanager
    # def trace(self, *data, font_size=16, **kwargs):
    #     if 'trace' not in self.debug:
    #         yield
    #         return
    #
    #     name = data[-1]
    #
    #     function = mn.Text(name, font_size=font_size)
    #     if self.traceStack:
    #         function.next_to(self.traceStack[-1], UP, buff=SMALL_BUFF, aligned_edge=RIGHT)
    #     else:
    #         function.next_to(self.animationCountObject, UP, aligned_edge=RIGHT)
    #     self.traceStack.append(function)
    #     with self.skip_animations_for(self.animateState[-1] == AnimState.PAUSED):
    #         self.play(
    #             mn.Write(function),
    #             run_time=1
    #         )
    #     yield
    #     with self.skip_animations_for(self.animateState[-1] == AnimState.PAUSED):
    #         self.play(
    #             mn.Write(function, rate_func=lambda a: mn.smooth(1-a), remover=True),
    #             run_time=1
    #         )
    #     self.traceStack.pop()
    #
    #
    # def animations_off(self):
    #     self.animateState[0] = AnimState.PAUSED
    #
    # def animations_off_on(self):
    #     self.animateState[0] = AnimState.NORMAL
    #

