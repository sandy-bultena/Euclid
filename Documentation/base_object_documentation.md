# Base Objects

## Arguments

| name           | type                    | default | description                                                  |
| -------------- | ----------------------- | ------- | ------------------------------------------------------------ |
| `*args`        |                         |         | Arguments that are specific for the derived class.  These arguments will be passed onto the appropriate object constructor |
| `stroke_width` | `float`                 | 2       | width of the line that draws the object                      |
| `delay_anim`   | `bool`                  | False   | don't animate the object right now, because you... the user of this library... will animate it later (via a transform maybe?) |
| `skip_anim`    | `bool`                  | False   | do all the work, but do not animate anything!                |
| `scene`        | `PropScene`             | `None`  | doesn't actually need to be set, because if it is not set, some coding magic will find the `PropScene` object by itself |
| `label_args`   | `tuple[str, ...] | str` | `None`  | Either a `str` which is the label of the object, or a tuple that can be used to defined a label (description of valid label_args are not the same for each derived class, and as such, they will be described for each class as necessary) |
| `**kwargs`     | `dict[str,Any]`         |         | Any key/value pairs that will be passed to the manim library constructor |



## Changing Properties:

A change in property will be animated (fading from the old state to the new state)

### Single objects (`Eline`, `ETriangle`, etc)

```python
def blue(self)->     EMObject: ... # change stroke and fill colour
def green(self)->    EMObject: ... # change stroke and fill colour
def red(self)->      EMObject: ... # change stroke and fill colour
def white(self)->    EMObject: ... # change stroke and fill colour
def grey(self)->     EMObject: ... # change stroke and fill colour
def e_fade(self) ->  EMObject: ... # change the opacity to a lower value so object appears 'faded'
def e_normal(self)-> EMObject: ... # change the opacity back to its default value
def lift(self)->     EMObject: ... # bring the object to the top of scene (in front of all other objects)
def notice(self)->   EMObject: ... # temporarily enlarge and colour change the object, so as to make it visibly noticable
```

### Collection objects (`TextBox`, etc)

Similar to single objects, but individual objects within the collection can be uniquely selected for the property change

```python
def blue(self,     *index:(int|slice))-> EIndexedGroup|EMObject: ...
def green(self,    *index:(int|slice))-> EIndexedGroup|EMObject: ...
def red(self,      *index:(int|slice))-> EIndexedGroup|EMObject: ...
def white(self,    *index:(int|slice))-> EIndexedGroup|EMObject: ...
def grey(self,     *index:(int|slice))-> EIndexedGroup|EMObject: ...
def e_fade(self,   *index:(int|slice))-> EIndexedGroup|EMObject: ...
def e_normal(self, *index:(int|slice))-> EIndexedGroup|EMObject: ...
def lift(self,     *index:(int|slice))-> EIndexedGroup|EMObject: ...
def notice(self,   *index:(int|slice))-> EIndexedGroup|EMObject: ...
```

> (see `TextBox` section for example of usage)

### Animation Methods:

**<font color=red>For each of these methods, an `EMObjectPlayer` is returned, which must, in turn, be called for the animation to be processed.</font>**

eg. 

<font color=red>`line.e_rotate([0.0.0], mn.PI)` DOES NOTHING!</font>

`line.e_rotate([0.0.0], mn.PI)()` works, 

`line.e_rotate([0.0.0], mn.PI)(run_time=2)` works, 

| Method                                                       | Description                                                  |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| **`e_move(self, vector: mn.Vect3`**                          | moves object by `vector` amount                              |
| **`e_move_to(self, point_or_mobject: mn.Mobject|mn.Vect3, aligned_edge = mn.ORIGIN, coor_mask = np.array([1, 1, 1]))`** | moves object *to* the new specified location                 |
| **`e_rotate(self, about: mn.Vect3, angle: float)`**          | rotates object around the `about` point by `angle` radians (NOT degrees) |
| **`e_scale(self, scale: float, min_scale_factor = 1e-8, about_point = None, about_edge = mn.ORIGIN)`** | change the size of the object                                |
| **`e_to_edge(self, edge = mn.LEFT, buff = mn.DEFAULT_MOBJECT_TO_EDGE_BUFFER)`** |                                                              |
| **`e_to_corner(self, corner: mn.Vect3 = mn.DL, buff: float = mn.DEFAULT_MOBJECT_TO_EDGE_BUFFER)`** |                                                              |



### Other Methods

| Method                                              | Description                                                  |
| --------------------------------------------------- | ------------------------------------------------------------ |
| **`visible(self) -> bool:`**                        | Is the object visible in the scene?                          |
| **`add_label(self, *args, **label_args) -> Self:`** | Add a label to the object (if the object supports labels, if it doesn't, program will crash).  `*args` and `**kwargs` are specific to the derived class. |
| **`remove_label(self) -> Self:`**                   | Label fades out of existence                                 |
| **`e_remove(self, anim_args=None)`**                | Animated removal of object from scene, `anim_args` could be (`run_time`) |
| **`e_delete(self)`**                                | Deletes object from scene (no animation)                     |
| **`copy(self, deep = False) -> Self:`**             | Makes a copy of the object (no animation)                    |
| **`get_label(self):`**                              | Gest the label object                                        |
| **`freeze(self)`**                                  | Sets the object to be frozen, so any changes requested on this object will be ignored |
| **`unfreeze(self)`**                                | Unfreezes the object                                         |
| **`e_fill(self, color, opacity=1)`**                | Fills the object with the specified colour and opacity.  Note that the opacity will be multiplied by the maximum opacity allowed (defined in constants.py) |
| **`e_unfill(self)`**                                | Removes the fill colour                                      |





