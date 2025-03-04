from __future__ import annotations

from enum import Enum

from manimlib import *
from euclidlib.Objects import *
from euclidlib.Objects import EucidMObject as EM
from euclidlib.Objects import CustomAnimation as CA
from os import getenv
import pyglet


class AnimState(Enum):
    NORMAL = 0
    STORING = 1
    PAUSED = 2
    SKIP = 3


class PropScene(InteractiveScene):
    title: str = ''
    steps: List[Callable[[], None]] = []
    animationCountObject: DecimalNumber

    def __init__(self, *args, **kwargs):
        self.animateState: List[AnimState] = [AnimState.NORMAL]
        self.animationsStored = []
        self.animationSpeedStack: List[float] = []
        self.debug = bool(getenv('DEBUG'))
        self._speed = float(getenv('SPEED', 1))
        super().__init__(*args, **kwargs)

    def gather_selection_euclid(self):
        self.is_selecting = False
        self.to_highlight = []
        if self.selection_rectangle in self.mobjects:
            self.remove(self.selection_rectangle)
            single = False
            if self.selection_rectangle.get_arc_length() < 1e-2:
                single = True
                self.selection_rectangle.set_width(0.1)
                self.selection_rectangle.set_height(0.1)
            for mob in reversed(self.get_selection_search_set()):
                if not isinstance(mob, EM.EMObject):
                    continue
                if not mob.visible():
                    continue
                try:
                    if mob.intersect(self.selection_rectangle):
                        self.to_highlight.append(mob)
                        if single:
                            break

                except NotImplementedError as e:
                    log.warn(str(e))
                    pass

    def on_key_press(self, symbol: int, modifiers: int) -> None:
        super().on_key_press(symbol, modifiers)
        char = chr(symbol)
        if char == 'z' and (modifiers & ALL_MODIFIERS) == 0:
            self.enable_selection()
        else:
            super().on_key_press(symbol, modifiers)

    def on_key_release(self, symbol: int, modifiers: int) -> None:
        char = chr(symbol)
        if char == 'z':
            self.gather_selection_euclid()
            anims = [t.highlight() for t in self.to_highlight]
            if anims:
                self.play(*anims)
            self.to_highlight = []
        else:
            super().on_key_press(symbol, modifiers)

    def post_play(self):
        super().post_play()
        self.animationCountObject.increment_value().to_corner(DR)

    def update_runtime(self, anim: AnimationType, speed: float):
        if not isinstance(anim, Animation):
            anim = anim.build()
        anim.set_run_time(anim.get_run_time() / speed)
        return anim

    def get_current_speed(self):
        return reduce(op.mul, self.animationSpeedStack, 1.0)

    def wait(self, duration: float = None, *args, **kwargs):
        if not duration:
            duration = self.default_wait_time
        super().wait(duration / self.get_current_speed(), *args, **kwargs)

    def play(self, *anims: AnimationType, **kwargs):
        if self.animateState[-1] == AnimState.NORMAL:
            speed = self.get_current_speed()
            if 'run_time' in kwargs:
                kwargs['run_time'] /= speed
            else:
                anims = [self.update_runtime(anim, speed) for anim in anims]
            super().play(*anims, **kwargs)
            for anim in anims:
                if isinstance(anim, LaggedStart):
                    for subanim in anim.animations:
                        if subanim.is_remover():
                            self.remove(subanim.mobject)
                        else:
                            self.add(subanim.mobject)
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

    def add(self, *mobjects: mn.Mobject):
        if self.animateState[-1] != AnimState.PAUSED:
            super().add(*mobjects)
        return self

    @contextmanager
    def simultaneous(self, **kwargs):
        self.animateState.append(AnimState.STORING)
        self.animationsStored.append([])
        yield
        self.animateState.pop()
        stored_anims = self.animationsStored.pop()
        if stored_anims:
            self.play(*stored_anims, **kwargs)

    @contextmanager
    def delayed(self, **kwargs):
        self.animateState.append(AnimState.STORING)
        self.animationsStored.append([])
        yield
        self.animateState.pop()
        stored_anims = self.animationsStored.pop()
        if stored_anims:
            self.play(LaggedStart(*stored_anims, **kwargs))

    @contextmanager
    def freeze(self, *args: EMObject):
        for a in args:
            a.freeze()
        yield
        for a in args:
            a.unfreeze()

    @contextmanager
    def skip_animations_for(self, stop=True):
        if stop:
            self.animateState.append(AnimState.SKIP)
            yield
            self.animateState.pop()
        else:
            yield

    @contextmanager
    def pause_animations_for(self, stop=True):
        if stop:
            self.animateState.append(AnimState.PAUSED)
            yield
            self.animateState.pop()
        else:
            yield

    @contextmanager
    def run_animations_for(self):
        self.animateState.append(AnimState.NORMAL)
        yield
        self.animateState.pop()

    @contextmanager
    def animation_speed(self, run_time: float):
        self.animationSpeedStack.append(run_time)
        yield
        self.animationSpeedStack.pop()

    @contextmanager
    def simultaneous_speed(self, run_time: float, **kwargs):
        with self.animation_speed(run_time):
            with self.simultaneous(**kwargs):
                yield

    def animations_off(self):
        self.animateState[0] = AnimState.PAUSED

    def animations_off_on(self):
        self.animateState[0] = AnimState.NORMAL

    def set_base_animation_speed(self, speed: float):
        self.animationSpeedStack[0] = speed

    def push_step(self, func):
        if not self.steps:
            self.steps = list()
        self.steps.append(func)

    def title_page(self):
        raise NotImplemented()

    def reset(self):
        raise NotImplemented()

    def runFull(self):
        with self.animation_speed(self._speed or 1):
            if not self.debug:
                self.title_page()
                self.wait(3)
            self.reset()
            self.wait()
            for step in self.steps:
                if self.debug:
                    print(f" Running func={step.__name__} | anim={self.num_plays}")
                step()
                self.wait()
            print(f" DONE | anim={self.num_plays}")

    @abstractmethod
    def define_steps(self) -> None:
        pass

    def construct(self) -> None:
        self.animationCountObject = DecimalNumber(num_decimal_places=0).to_corner(DR)
        if self.debug:
            self.add(self.animationCountObject)
        self.define_steps()
        self.runFull()
