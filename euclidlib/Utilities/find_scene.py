# -----------------------------------------------------------------------------------------------------------------
# find the scene
# -----------------------------------------------------------------------------------------------------------------
from typing import Optional, TYPE_CHECKING
import manimlib as mn

def find_scene() -> Optional[mn.InteractiveScene]:
    from inspect import currentframe
    f = currentframe()

    # keep up the stack until there is no more to go
    while f:

        # if this frame is not a frame for a class object, ignore
        if 'self' in f.f_locals:

            # get the object
            f_self = f.f_locals['self']

            # if object already has scene defined, then return that
            if isinstance(f_self, mn.VMobject) and hasattr(f_self, 'scene'):
                if f_self.scene is not None:
                    return f_self.scene

            # if this is a manim scene, then this is the scene!
            if isinstance(f_self, mn.InteractiveScene):
                return f_self

        f = f.f_back
    return None
