"""The starting location for showing a proposition"""
from __future__ import annotations
import inspect

import manimlib as mn

import traceback
from enum import Enum

from euclidlib.Objects import *
from os import getenv

from euclidlib.debugging import print_debug
DEFAULT_SPEED = 3

class AnimState(Enum):
    NORMAL = 0
    STORING = 1
    PAUSED = 2
    SKIP = 3

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

        super().__init__(*args, **kwargs)

    # -----------------------------------------------------------------------------------------------------------------
    # starting point of the the animation
    # -----------------------------------------------------------------------------------------------------------------
    def construct(self) -> None:
        try:
            self.animationCountObject = mn.DecimalNumber(num_decimal_places=0).to_corner(mn.DR)
            if self.debug:
                self.add(self.animationCountObject)
            self.run_full()
        except Exception:
            traceback.print_exc()

    # -----------------------------------------------------------------------------------------------------------------
    # go through all the steps, and run them
    # -----------------------------------------------------------------------------------------------------------------
    def run_full(self):
        with self.animation_speed(self._speed or 1):
            try:
                if not self.debug:
                    print_debug(txt="TITLE PAGE")
                    self.title_page()
                    self.next_page()
                    self.reset()
                    print_debug(txt="Finished TITLE PAGE")
            except NotImplementedError:
                pass

            print_debug(txt="Running prop scene", level=10)
            self.go()

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
    #
    # # -----------------------------------------------------------------------------------------------------------------
    # # adds a counter defining which scene is currently being played
    # # -----------------------------------------------------------------------------------------------------------------
    # def post_play(self):
    #     super().post_play()
    #     self.animationCountObject.increment_value().to_corner(DR)

    # -----------------------------------------------------------------------------------------------------------------
    # adjust the run time so that it moves at a given speed (larger objects will take longer to draw)
    # -----------------------------------------------------------------------------------------------------------------
    def _update_runtime(self, anim: mn.AnimationType, speed: float):
        if not isinstance(anim, mn.Animation):
            print(f"****** anim is not an mn.Animation type, instead {type(anim)}")
            anim = anim.build()
        anim.set_run_time(anim.get_run_time() / speed)
        return anim

    # -----------------------------------------------------------------------------------------------------------------
    # average? the speed over all the specified speeds
    # -----------------------------------------------------------------------------------------------------------------
    def _get_current_speed(self):
        return mn.reduce(mn.op.mul, self.animationSpeedStack, 1.0)

    # -----------------------------------------------------------------------------------------------------------------
    # not sure why wait time should be dependent on the current speed
    # -----------------------------------------------------------------------------------------------------------------
    def wait(self, duration: float = 3, *args, **kwargs):
        super().wait(duration / self._get_current_speed(), *args, **kwargs)

    # -----------------------------------------------------------------------------------------------------------------
    # wait for user before printing next page
    # -----------------------------------------------------------------------------------------------------------------
    def next_page(self):
        print("\nHit key for next page")
        self.paused = True
        self.wait_until(lambda : not self.paused, 600)


    # -----------------------------------------------------------------------------------------------------------------
    # play animations
    #   - typically called by the creation of an EuclidObject, via their version of `e_draw`
    #        but can be called by manim directly
    # -----------------------------------------------------------------------------------------------------------------
    def play(self, *anims: mn.AnimationType, **kwargs):
        print()
        print(f"  PropScene play {anims} {self.animateState}")
        # print(f'  ...  caller name:', inspect.stack()[1][3], inspect.stack()[1][1])
        # print(f'  ...  caller name:', inspect.stack()[2][3],inspect.stack()[2][1], inspect.stack()[2][2])
        # print(f'  ...  caller name:', inspect.stack()[3][3],inspect.stack()[3][1], inspect.stack()[3][2])

        # if the animation state is normal, then play the animation (makes sense)
        if self.animateState[-1] == AnimState.NORMAL:

            # adjust the speed as required
            speed = self._get_current_speed()
            if 'run_time' in kwargs:
                kwargs['run_time'] /= speed
            else:
                anims = [self._update_runtime(anim, speed) for anim in anims]

            # using manim, play the animation
            super().play(*anims, **kwargs)

            for anim in anims:
                if isinstance(anim, mn.LaggedStart):
                    print(f"************ WTF is this 'LaggedStart'")
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
            print("****** WE ARE SKIPPING")
            currently_skipping = self.skip_animations
            if not currently_skipping:
                self.force_skipping()
            super().play(*anims, **kwargs)
            if not currently_skipping:
                self.revert_to_original_skipping_status()
        elif self.animateState[-1] == AnimState.PAUSED:
            pass
        print("  END PLAY")

    # -----------------------------------------------------------------------------------------------------------------
    # and the em objects to the collection of objects in this scene
    # -----------------------------------------------------------------------------------------------------------------
    def add(self, *mobjects: mn.Mobject):

        o = [str(o) for o in mobjects]
        print(f'      PropScene.add {o}')
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
    # not sure
    # -----------------------------------------------------------------------------------------------------------------
    def e_remove(self, *obj):
        print(f"******** called e_romove {obj}")
        with self.simultaneous():
            for o in obj:
                o.e_remove()

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
    # -----------------------------------------------------------------------------------------------------------------
    @mn.contextmanager
    def animation_speed(self, run_time: float):
        if run_time > 0:
            self.animationSpeedStack.append(run_time)
            yield []
            self.animationSpeedStack.pop()
        elif run_time < 0:
            with self.pause_animations_for() as l:
                yield l
        else:
            yield []

    # -----------------------------------------------------------------------------------------------------------------
    # context for freezing certain objects during the context
    # -----------------------------------------------------------------------------------------------------------------
    # @mn.contextmanager
    # def freeze(self, *args: EMObject):
    #     for a in args:
    #         a.freeze()
    #     yield
    #     for a in args:
    #         a.unfreeze()


    # @mn.contextmanager
    # def delayed(self, **kwargs):
    #     self.animateState.append(AnimState.STORING)
    #     self.animationsStored.append([])
    #     yield
    #     self.animateState.pop()
    #     stored_anims = self.animationsStored.pop()
    #     if stored_anims:
    #         self.play(mn.LaggedStart(*stored_anims, **kwargs))
    #
    # @mn.contextmanager
    # def skip_animations_for(self, stop=True):
    #     if stop:
    #         self.animateState.append(AnimState.SKIP)
    #         yield
    #         self.animateState.pop()
    #     else:
    #         yield
    #
    # @mn.contextmanager
    # def pause_animations_for(self, stop=True):
    #     if stop:
    #         to_draw = []
    #         self.animateState.append(AnimState.PAUSED)
    #         yield to_draw
    #         self.animateState.pop()
    #         if len(to_draw) > 1:
    #             with self.simultaneous():
    #                 for x in to_draw:
    #                     x.e_draw()
    #         if len(to_draw) == 1:
    #             to_draw[0].e_draw()
    #
    #     else:
    #         yield []
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
    # @mn.contextmanager
    # def simultaneous_speed(self, run_time: float, **kwargs):
    #     with self.animation_speed(run_time):
    #         with self.simultaneous(**kwargs):
    #             yield
    #
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
    # def set_base_animation_speed(self, speed: float):
    #     self.animationSpeedStack[0] = speed

