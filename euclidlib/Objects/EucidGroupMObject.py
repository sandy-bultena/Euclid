from __future__ import annotations
from euclidlib.Objects.EucidMObject import *

DEFAULT_FADE_OPACITY = 0.15
DEFAULT_CONSTRUCTION_RUNTIME = 0.5
DEFAULT_TRANSFORM_RUNTIME = 0.25


class EGroupPlayer:
    def __init__(self, group: EGroup[EMObject]):
        self.group = group
        self.players = [EMObjectPlayer(sub) for sub in group]

    for name in EMObjectPlayer._properties():
        exec(f'''
@property
def {name}(self):
    for player in self.players:
        player.{name}
    return self
'''.strip())

    for name in EMObjectPlayer._methods():
        exec(f'''
def {name}(self, *args):
    for player in self.players:
        player.{name}(*args)
    return self
'''.strip())

    def __call__(self, *index, **kwargs):
        to_exec = self.players

        if index:
            to_exec = [self.players[i] for i in index]

        for player in to_exec:
            player(**kwargs)
        return self.group


class EGroup[T](EMObject, mn.VGroup[T]):
    def CreationOf(self, *args, **kwargs):
        return []

    if TYPE_CHECKING:
        blue: EGroupPlayer
        green: EGroupPlayer
        red: EGroupPlayer
        white: EGroupPlayer

        e_fade: EGroupPlayer
        e_normal: EGroupPlayer

        def e_move(self, vev: Vect3) -> EGroupPlayer: ...
        def e_rotate(self, about: Vect3, angle: float) -> EGroupPlayer: ...

    for name in EMObjectPlayer._properties():
        exec(f'''
@property
def {name}(self, *args):
    return EGroupPlayer(self).{name}
'''.strip())

    for name in EMObjectPlayer._methods():
        exec(f'''
def {name}(self, *args):
    return EGroupPlayer(self).{name}(*args)
'''.strip())

    def e_draw(self):
        for obj in self:
            if not obj.in_scene():
                obj.e_draw()

    def e_remove(self):
        for obj in self:
            if obj.in_scene():
                obj.e_remove()

    def remove_labels(self):
        for x in self:
            x.remove_label()
