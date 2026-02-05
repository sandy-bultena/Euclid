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

    # ----------------------------------------------------------------------------------------------------------------
    # get objects within this group
    # ----------------------------------------------------------------------------------------------------------------
    def get_group(self):
        raise NotImplemented()

    def get_manager(self):
        return self,

    def get_e_family(self):
        return *self.get_manager(), *self.get_group()

    # ----------------------------------------------------------------------------------------------------------------
    # remove all items in the group
    # ----------------------------------------------------------------------------------------------------------------
    @freezable
    def e_remove(self):
        with self.scene.simultaneous():
            for obj in self.get_group():
                if obj.in_scene():
                    obj.e_remove()
        super().e_remove()
        return self

    # ----------------------------------------------------------------------------------------------------------------
    # remove all labels within the group
    # ----------------------------------------------------------------------------------------------------------------
    @freezable
    def remove_labels(self):
        for x in self.get_group():
            x.remove_label()
        return self

    # ----------------------------------------------------------------------------------------------------------------
    # draw all the objects within the group
    # ----------------------------------------------------------------------------------------------------------------
    @freezable
    def e_draw(self, skip_anim=False, **kwargs):
        with self.scene.simultaneous():
            for obj in self.get_group():
                if not obj.visible():
                    obj.e_draw(skip_anim, **kwargs)
        super().e_draw(skip_anim, **kwargs)
        return self

    # ----------------------------------------------------------------------------------------------------------------
    # create wrapper methods for all the available player properties and methods
    # ----------------------------------------------------------------------------------------------------------------
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

    # ----------------------------------------------------------------------------------------------------------------
    # called by manim during creation and removal of this object
    # ... since it is holder for a collection of objects, nothing gets drawn when this is created
    # ----------------------------------------------------------------------------------------------------------------
    def CreationOf(self, *args, **kwargs):
        return []
    def RemovalOf(self, *args, **kwargs):
        return []

    # ----------------------------------------------------------------------------------------------------------------
    # helper function to remove indices
    # ----------------------------------------------------------------------------------------------------------------
    def except_index(self, *indices):
        exceptions = set(indices)
        full = set(range(len(self.get_group())))
        return full - exceptions

    # ----------------------------------------------------------------------------------------------------------------
    # get all the objects in the container
    # ----------------------------------------------------------------------------------------------------------------
    def get_group(self):
        return tuple(o for o in self if isinstance(o,EMObject))

    def get_manager(self):
        return ()

    # ----------------------------------------------------------------------------------------------------------------
    # subset - returns a subset of self as a new EIndexedGroup
    # ----------------------------------------------------------------------------------------------------------------
    def subset(self, item: int | slice) -> EMObject| EIndexedGroup:
        if isinstance(item, int):
            return self[item]
        elif isinstance(item,slice):
            return EIndexedGroup(*self[item])
        else:
            raise ValueError("subset item MUST be an int or a slice")


    # ----------------------------------------------------------------------------------------------------------------
    # create wrapper methods for all the available player properties and methods
    # ----------------------------------------------------------------------------------------------------------------
    for name in EMObjectPlayer.get_properties():
        exec(f'''
@freezable
def {name}(self, *indices, **kwargs):
    objs = [*self.get_group(), *self.get_manager()] 

    if indices:
        objs = []
        for index in indices:
            if isinstance(index,slice):
                objs.extend(self[index])
            else:
                objs.append(self[index])

    with self.scene.simultaneous():
        for obj in objs:
            if isinstance(obj, EGroupedObjects):
                EGroupPlayer(obj).{name}(**kwargs)
            else:
                EMObjectPlayer(obj).{name}(**kwargs)
    return self
'''.strip())


    def __str__(self):
        return f"EIndexedGroup, {self.get_group()}"

    if TYPE_CHECKING:
        def blue(self, index:(int|slice)=None)-> EIndexedGroup|EMObject: ...
        def green(self, index:(int|slice)=None)-> EIndexedGroup|EMObject: ...
        def red(self, index:(int|slice)=None)-> EIndexedGroup|EMObject: ...
        def white(self, index:(int|slice)=None)-> EIndexedGroup|EMObject: ...
        def grey(self, index:(int|slice)=None)-> EIndexedGroup|EMObject: ...
        def e_fade(self, index:(int|slice)=None)-> EIndexedGroup|EMObject: ...
        def e_normal(self, index:(int|slice)=None)-> EIndexedGroup|EMObject: ...
        def lift(self, index:(int|slice)=None)-> EIndexedGroup|EMObject: ...
        def notice(self, index:(int|slice)=None)-> EIndexedGroup|EMObject: ...


