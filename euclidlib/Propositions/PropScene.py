from __future__ import annotations

from enum import Enum

from manimlib import *
from typing import Callable

def to_manim_coord(x, y):
    return (
        (x - 700) * (8.0 * 16 / 1400 / 9),
        (400 - y) * (8.0 / 800)
    )


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
        super().__init__(*args, **kwargs)

    def play(self, *anims: AnimationType, **kwargs):
        if self.animateState == AnimState.NORMAL:
            super().play(*anims, **kwargs)
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

    def animations_off(self):
        self.animateState = AnimState.PAUSED

    def animations_off_on(self):
        self.animateState = AnimState.NORMAL


    def push_step(self, func):
        if not self.steps:
            self.steps = list()
        self.steps.append(func)

    def runFull(self):
        print(self.steps)
        for step in self.steps:
            step()
            self.wait()


    @abstractmethod
    def define_steps(self) -> None:
        pass


    def construct(self) -> None:
        self.define_steps()
        self.runFull()
