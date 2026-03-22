from euclidlib.Objects import EIndexedGroup
from euclidlib.Scenes.prop_scene import PropScene

class TestProp(PropScene):
    def __init__(self,*args, **kwargs):
        super().__init__(args, **kwargs)

    def reset(self):
       pass

    def go(self):
        pass

    def title_page(self):
        pass
