from __future__ import annotations

from typing import TYPE_CHECKING
import manimlib as mn

from euclidlib.Objects.em_object_base import EMObject
from euclidlib.Objects.em_object_player import EMObjectPlayer, EGroupPlayer
from euclidlib.Objects.em_object_decorators import *

DEFAULT_FADE_OPACITY = 0.15
DEFAULT_CONSTRUCTION_RUNTIME = 0.5
DEFAULT_TRANSFORM_RUNTIME = 0.25


# *********************************************************************************************************************
# code required for objects that are collections via VGroup or similar things
# *********************************************************************************************************************


# =====================================================================================================================
# GroupedObjects
# - its like a group, but isn't really, uses "get_manager" and "get_group" to get the sub-objects
# =====================================================================================================================
class GroupedObjects(EMObject):
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


# =====================================================================================================================
# is a real group
# =====================================================================================================================
class EGroup[T](GroupedObjects, EMObject, mn.VGroup[T]):
    def CreationOf(self, *args, **kwargs):
        return []
    def RemovalOf(self, *args, **kwargs):
        return []

    def get_group(self):
        return self.submobjects

    def get_manager(self):
        return ()

