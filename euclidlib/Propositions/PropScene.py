from __future__ import annotations

from enum import Enum

from manimlib import *
from typing import Callable
from euclidlib.Objects import *
from os import getenv


class AnimState(Enum):
    NORMAL = 0
    STORING = 1
    PAUSED = 2


class PropScene(InteractiveScene):
    title: str = ''
    steps: List[Callable[[], None]] = []
    animationCountObject: DecimalNumber

    def __init__(self, *args, **kwargs):
        self.animateState: List[AnimState] = [AnimState.NORMAL]
        self.animationsStored = []
        self.animationSpeedStack: List[float] = []
        self.debug = bool(getenv('DEBUG'))
        super().__init__(*args, **kwargs)


    def post_play(self):
        super().post_play()
        self.animationCountObject.increment_value().to_corner(DR)


    def update_runtime(self, anim: AnimationType, speed: float):
        if not isinstance(anim, Animation):
            anim = anim.build()
        anim.set_run_time(anim.get_run_time() / speed)
        return anim

    def wait(self, *args, **kwargs):
        super().wait(*args, **kwargs)

    def play(self, *anims: AnimationType, **kwargs):
        if self.animateState[-1] == AnimState.NORMAL:
            speed = reduce(op.mul, self.animationSpeedStack, 1.0)
            if 'run_time' in kwargs:
                kwargs['run_time'] /= speed
            else:
                anims = [self.update_runtime(anim, speed) for anim in anims]
            super().play(*anims, **kwargs)
        elif self.animateState[-1] == AnimState.STORING:
            self.animationsStored[-1].extend(anims)
        elif self.animateState[-1] == AnimState.PAUSED:
            self.force_skipping()
            super().play(*anims, **kwargs)
            self.revert_to_original_skipping_status()

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
    def skip_animations_for(self):
        self.animateState.append(AnimState.PAUSED)
        yield
        self.animateState.pop()

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

    def push_step(self, func):
        if not self.steps:
            self.steps = list()
        self.steps.append(func)

    def title_page(self):
        raise NotImplemented()

    def reset(self):
        raise NotImplemented()

    def runFull(self):
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
