import manimlib as mn

class UncreatePreserve(mn.Uncreate):
    def __init__(self, obj: mn.Mobject, *args, **kwargs):
        super().__init__(obj, *args, **kwargs)
        obj.save_state()

    def clean_up_from_scene(self, scene: mn.Scene):
        mn.Animation.clean_up_from_scene(self, scene)
        self.mobject.restore()

class UnWrite(mn.Write):
    def __init__(
            self,
            obj: mn.VMobject,
            *args,
            rate_func=mn.linear,
            remover=True,
            **kwargs
    ):
        super().__init__(obj, *args, **kwargs, remover=remover, rate_func=lambda a: rate_func(1-a))
        obj.save_state()

    def clean_up_from_scene(self, scene: mn.Scene):
        mn.Animation.clean_up_from_scene(self, scene)
        self.mobject.restore()

    def get_sub_alpha(
        self,
        alpha: float,
        index: int,
        num_submobjects: int
    ) -> float:
        return super().get_sub_alpha(alpha, num_submobjects-index-1, num_submobjects)


class WriteUnWrite(mn.AnimationGroup):
    def __init__(self, source, target, **kwargs):
        super().__init__(UnWrite(source), mn.Write(target), **kwargs)