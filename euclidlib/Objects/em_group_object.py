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
# EGroupedObjects
# - treats all members in "get_manager()" and "get_group" as a single group
# =====================================================================================================================
class EGroupedObjects(EMObject):

    def get_group(self):
        raise NotImplemented()

    def get_manager(self):
        return self,

    def get_e_family(self):
        return *self.get_manager(), *self.get_group()

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
# this a a list or tuple of objects that can be treated as a group, or, can be called individually
# example TextBox
#   tb = TextBox()
#   tb.explain("hi")
#   tb.explain("hello")
#   tb.green()          # turns both 'hi' and 'hello' to green
#   tb.blue(1)          # turns the 1th element to blue (i.e. hello turns 'blue', and 'hi' remains untouched
#
# NOTE: Can only change properties, you cannot specify indices when doing something like moving
#       ... to do that, try
#       tb[2].e_move(...)
# =====================================================================================================================
class EIndexedGroup[T](EGroupedObjects, EMObject, mn.VGroup[T]):

    def CreationOf(self, *args, **kwargs):
        return []
    def RemovalOf(self, *args, **kwargs):
        return []

    def except_index(self, *indices):
        exceptions = set(indices)
        full = set(range(len(self.get_group())))
        return full - exceptions

    def get_group(self):
        return self.submobjects

    def get_manager(self):
        return ()

    for name in EMObjectPlayer.get_properties():
        exec(f'''
@freezable
def {name}(self, *indices, **kwargs):
    objs = [obj for obj in [*self.get_group(), *self.get_manager()] if isinstance(obj, EMObject)]

    if indices:
        objs = [objs[i] for i in indices]

    with self.scene.simultaneous():
        for obj in objs:
            if isinstance(obj, EGroupedObjects):
                EGroupPlayer(obj).{name}(**kwargs)
            else:
                EMObjectPlayer(obj).{name}(**kwargs)
    return self
'''.strip())



