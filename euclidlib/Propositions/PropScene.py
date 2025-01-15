from __future__ import annotations

from enum import Enum

from manimlib import *
from typing import Callable
from euclidlib.Objects import *
import roman


class AnimState(Enum):
    NORMAL = 0
    STORING = 1
    PAUSED = 2


class PropScene(InteractiveScene):
    title: str = ''
    steps: List[Callable[[], None]] = []

    def __init__(self, *args, **kwargs):
        self.animateState: List[AnimState] = [AnimState.NORMAL]
        self.animationsStored = []
        self.animationSpeedStack: List[float] = []
        super().__init__(*args, **kwargs)

    def update_runtime(self, anim: AnimationType, speed: float):
        if not isinstance(anim, Animation):
            anim = anim.build()
        anim.run_time /= speed
        return anim

    def play(self, *anims: AnimationType, **kwargs):
        if self.animateState[-1] == AnimState.NORMAL:
            speed = reduce(op.mul, self.animationSpeedStack, 1.0)
            super().play(*(self.update_runtime(anim, speed) for anim in anims), **kwargs)
        elif self.animateState[-1] == AnimState.STORING:
            self.animationsStored[-1].extend(anims)
        elif self.animateState[-1] == AnimState.PAUSED:
            for anim in anims:
                if anim.remover:
                    self.remove(anim.mobject)
                else:
                    self.add(anim.mobject)

    @contextmanager
    def simultaneous(self, **kwargs):
        self.animateState.append(AnimState.STORING)
        self.animationsStored.append([])
        yield
        self.animateState.pop()
        if self.animationsStored[-1]:
            self.play(*self.animationsStored[-1], **kwargs)
        self.animationsStored.pop()

    @contextmanager
    def pause_animations_for(self):
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
        self.title_page()
        self.wait(3)
        self.reset()
        self.wait()
        for step in self.steps:
            step()
            self.wait()

    @abstractmethod
    def define_steps(self) -> None:
        pass

    def construct(self) -> None:

        self.define_steps()
        self.runFull()
