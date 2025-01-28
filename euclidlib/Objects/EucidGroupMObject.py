from __future__ import annotations
from euclidlib.Objects.EucidMObject import *

DEFAULT_FADE_OPACITY = 0.15
DEFAULT_CONSTRUCTION_RUNTIME = 0.5
DEFAULT_TRANSFORM_RUNTIME = 0.25


class EGroupPlayer:
    def __init__(self, group: PsuedoGroup[EMObject]):
        self.obj = group
        self.group = group.get_group()
        self.manager = group.get_manager()
        self.players = [EMObjectPlayer(sub) for sub in [*self.group, *self.manager] if isinstance(sub, EMObject)]

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
        return self.obj

    def __getitem__(self, item: int | slice):
        if isinstance(item, slice):
            for player in self.players[item]:
                player()
        else:
            self.players[item]()
        return self.obj


class PsuedoGroup(EMObject):
    if TYPE_CHECKING:
        blue: EGroupPlayer
        green: EGroupPlayer
        red: EGroupPlayer
        white: EGroupPlayer

        e_fade: EGroupPlayer
        e_normal: EGroupPlayer

        def e_move(self, vev: Vect3) -> EGroupPlayer: ...
        def e_rotate(self, about: Vect3, angle: float) -> EGroupPlayer: ...

    def get_group(self):
        raise NotImplemented()

    def get_manager(self):
        return self,

    def except_index(self, *indices):
        exceptions = set(indices)
        full = set(range(len(self.get_group())))
        return full - exceptions

    def e_remove(self):
        print(*self.get_group())
        for obj in self.get_group():
            if obj.in_scene():
                obj.e_remove()
        super().e_remove()
        return self

    def remove_labels(self):
        for x in self.get_group():
            x.remove_label()
        return self

    def e_draw(self, skip_anim=False):
        for obj in self.get_group():
            if not obj.visible():
                obj.e_draw(skip_anim)
        super().e_draw(skip_anim)
        return self

    for name in EMObjectPlayer._properties():
        exec(f'''
@property
def {name}(self, *args):
    return EGroupPlayer(self).{name}'''.strip())

    for name in EMObjectPlayer._methods():
        exec(f'''
def {name}(self, *args):
    return EGroupPlayer(self).{name}(*args)'''.strip())


class EGroup[T](PsuedoGroup, EMObject, mn.VGroup[T]):
    def CreationOf(self, *args, **kwargs):
        return []
    def RemovalOf(self, *args, **kwargs):
        return []

    def get_group(self):
        return self

    def get_manager(self):
        return ()

