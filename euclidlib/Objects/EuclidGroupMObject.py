from __future__ import annotations

from typing import TYPE_CHECKING
import manimlib as mn

from euclidlib.Objects.em_object_base import EMObject
from euclidlib.Objects.em_object_player import EMObjectPlayer
from euclidlib.Objects.em_object_decorators import *

DEFAULT_FADE_OPACITY = 0.15
DEFAULT_CONSTRUCTION_RUNTIME = 0.5
DEFAULT_TRANSFORM_RUNTIME = 0.25

# *********************************************************************************************************************
# code required for objects that are collections via VGroup or similar things
# *********************************************************************************************************************

class EGroupPlayer:
    def __init__(self, group: PsuedoGroup[EMObject]):
        self.obj = group
        self.group = group.get_group()
        self.manager = group.get_manager()
        self.players = [EMObjectPlayer(sub) for sub in [*self.group, *self.manager] if isinstance(sub, EMObject)]
        self.indices = None

    def __str__(self):
        return ", ".join(str(g) for g in self.group)

    # -----------------------------------------------------------------------------------------------------------------
    # this allows an EGroupPlayer instance to be called directly,
    # -----------------------------------------------------------------------------------------------------------------
    def __call__(self, *index, **kwargs):
        # print(f"EGroupPlayer.__call__ obj={str(self)}, index = {index}")
        # print(f'  ...  caller name:', inspect.stack()[0][3], inspect.stack()[0][1], inspect.stack()[0][2])
        # print(f'  ...  caller name:', inspect.stack()[1][3], inspect.stack()[1][1], inspect.stack()[1][2])
        # print(f'  ...  caller name:', inspect.stack()[2][3], inspect.stack()[2][1], inspect.stack()[2][2])
        # print(f'  ...  caller name:', inspect.stack()[3][3], inspect.stack()[3][1], inspect.stack()[3][2])
        # print(f'  ...  caller name:', inspect.stack()[4][3], inspect.stack()[4][1], inspect.stack()[4][2])
        # print(f'  ...  caller name:', inspect.stack()[5][3], inspect.stack()[5][1], inspect.stack()[5][2])
        # print(f'  ...  caller name:', inspect.stack()[6][3], inspect.stack()[6][1], inspect.stack()[6][2])

        to_exec = self.indices or self.players
        if index:
            to_exec = [self.players[i] for i in index]

        with self.obj.scene.simultaneous():
            for player in to_exec:
                player(**kwargs)
        return self.obj

    def __getitem__(self, item: int | slice):
        self.indices = self.players[item]
        return self

    for name in EMObjectPlayer.get_properties():
        exec(f'''
@property
def {name}(self):
    for player in self.players:
        player.{name}
    return self
'''.strip())

    for name in EMObjectPlayer.get_methods():
        exec(f'''
def {name}(self, *args):
    for player in self.players:
        player.{name}(*args)
    return self
'''.strip())



class PsuedoGroup(EMObject):
    if TYPE_CHECKING:
        blue: EGroupPlayer
        green: EGroupPlayer
        red: EGroupPlayer
        white: EGroupPlayer

        e_fade: EGroupPlayer
        e_normal: EGroupPlayer

        def e_move(self, vev: mn.Vect3) -> EGroupPlayer: ...
        def e_rotate(self, about: mn.Vect3, angle: float) -> EGroupPlayer: ...

    def get_group(self):
        raise NotImplemented()

    def get_manager(self):
        return self,

    def get_e_family(self):
        return *self.get_manager(), *self.get_group()

    def except_index(self, *indices):
        exceptions = set(indices)
        full = set(range(len(self.get_group())))
        return full - exceptions

    @freezable
    def e_remove(self):
        with self.scene.simultaneous():
            for obj in self.get_group():
                if obj.in_scene():
                    obj.e_remove()
        super().e_remove()
        return self

    @freezable
    def remove_labels(self):
        for x in self.get_group():
            x.remove_label()
        return self

    @freezable
    def e_draw(self, skip_anim=False, **kwargs):
        with self.scene.simultaneous():
            for obj in self.get_group():
                if not obj.visible():
                    obj.e_draw(skip_anim, **kwargs)
        super().e_draw(skip_anim, **kwargs)
        return self

    for name in EMObjectPlayer.get_properties():
        exec(f'''
@property
@freezable
def {name}(self, *args):
    return EGroupPlayer(self).{name}'''.strip())

    for name in EMObjectPlayer.get_methods():
        exec(f'''
@freezable
def {name}(self, *args):
    return EGroupPlayer(self).{name}(*args)'''.strip())


class EGroup[T](PsuedoGroup, EMObject, mn.VGroup[T]):
    def CreationOf(self, *args, **kwargs):
        return []
    def RemovalOf(self, *args, **kwargs):
        return []

    def get_group(self):
        return self.submobjects

    def get_manager(self):
        return ()

