from __future__ import annotations

from enum import Enum

from manimlib import *
from typing import Callable

class AnimState(Enum):
    NORMAL = 0
    STORING = 1
    PAUSED = 2

class PropScene(InteractiveScene):
    title: str = ''
    steps: List[Callable[[], None]] = []

    def __init__(self, *args, **kwargs):
        self.animateState: AnimState = AnimState.NORMAL
        self.animationsStored = []
        self.animationSpeedStack: List[float] = []
        super().__init__(*args, **kwargs)

    def update_runtime(self, anim: AnimationType, speed: float):
        if not isinstance(anim, Animation):
            anim = anim.build()
        anim.run_time /= speed
        return anim

    def play(self, *anims: AnimationType, run_time: float = None, **kwargs):
        if self.animateState == AnimState.NORMAL:
            speed = reduce(op.mul, self.animationSpeedStack, 1.0)
            super().play(*(self.update_runtime(anim, speed) for anim in anims),**kwargs)
        elif self.animateState == AnimState.STORING:
            self.animationsStored.extend(anims)
        elif self.animateState == AnimState.PAUSED:
            for anim in anims:
                if anim.remover:
                    self.remove(anim.mobject)
                else:
                    self.add(anim.mobject)

    @contextmanager
    def simultaneous(self, **kwargs):
        self.animateState = AnimState.STORING
        yield
        self.animateState = AnimState.NORMAL
        self.play(*self.animationsStored, **kwargs)
        self.animationsStored.clear()

    @contextmanager
    def pause_animations_for(self):
        self.animateState = AnimState.PAUSED
        yield
        self.animateState = AnimState.NORMAL

    @contextmanager
    def animation_speed(self, run_time: float):
        self.animationSpeedStack.append(run_time)
        yield
        self.animationSpeedStack.pop()

    def animations_off(self):
        self.animateState = AnimState.PAUSED

    def animations_off_on(self):
        self.animateState = AnimState.NORMAL


    def push_step(self, func):
        if not self.steps:
            self.steps = list()
        self.steps.append(func)

    def runFull(self):
        for step in self.steps:
            step()
            self.wait()


    @abstractmethod
    def define_steps(self) -> None:
        pass


    def construct(self) -> None:
        self.define_steps()
        self.runFull()
