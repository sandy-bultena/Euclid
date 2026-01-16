from euclidlib.Objects import EGroup
from euclidlib.Propositions.prop_scene import PropScene

class TestProp(PropScene):
    def __init__(self,*args, **kwargs):
        super().__init__(args, **kwargs)

    def reset(self):
       pass

    def go(self):
        pass

    def title_page(self):
        pass
