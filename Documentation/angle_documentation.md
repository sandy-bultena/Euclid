# EAngle 

`EAngle` creates either an arc, or a box (if angle is a right angle), that is used to denote the angle between two lines. 

> Calling this function (it is not a class) will return objects of type `Gnomon| ArcAngle| RightAngle` which are all dervied classes from `EangleBase`

```
size: float = mn_scale(40),
no_right: bool = False,
gnomon: bool = False,
**kwargs) -> Gnomon| ArcAngle| RightAngle:
```

## Arguments

| variable    | type                    | default              | description                                                  |
| ----------- | ------------------------|------------- | ------------------------------------------------------------ |
| `l1`        | `ELine`                 |             | one of the two lines denoting the angle                      |
| `l2`        | `ELine`                 |             | the second of the two lines denoting the angle (the two lines ***must*** have a common vertex!) |
| `size`      | `float`                 | `mn_scale(40)` | The radius of the arc which indicates the angle              |
| `no_right` | `bool` | `False` | If set to True, the angle will be indicated by an arc, even if the angle is 90 degrees |
| `gnomon` | `bool` | `False` | Is  or is not an angle describing an gnomon (the part of a parallelogram left when a similar parallelogram has been taken from its corner) |
| `**kwargs` |                          |               | Extra arguments for the animation |
|||||

## Properties

| Property        | type                 | Description                                                  |
| --------------- | -------------------- | ------------------------------------------------------------ |
| `lines`         | `tuple[ELine,ELine]` | the two lines that define the angle                          |
| `center`        | `mn.Vect3`           | the coordinates of the vertex of the two lines defining the angle |
| `e_start_angle` | `float` (radians)    | the angle (in radians) where the angle starts (i.e. the smaller of the two angles defined by the two lines) |
| `e_angle`       | `float` (radians)    | the total angle (in radians)                                 |
| `radius`        | `float`              | the radius of the arc indicating the angle                   |
|                 |                      |                                                              |

## Label

### `add_label(self, text: str, where=ArcLabelLocation.BY_ALPHA, alpha=0.5, buff=LABEL_BUFF)`

Defines the label and where the label will be located

* `text` - the label string
* `where` [`ArcLabelLocation.BY_ALPHA` | `ArcLabelLocation.AT_START` | `ArcLabelLocation.AT_END` ]`
  * `BY_ALPHA` - label is placed a fraction along its arc (defined by `alpha` argument)
  * `AT_START` - label is placed at the beginning of the arc (`alpha` argument is ignored)
  * `AT_END` - label is placed at the end of the arc (`alpha` argument is ignored)

* `alpha` - a fractional value defining where along the arc path the label should be placed
* `buff` - the amount of space between the arc and the label

_Example_:
<img src="./images/angle_label.png" alt="textbox_params" style="zoom:30%;" />

```python
    l1 = ELine(mn_coord(130,400),mn_coord(500,150))
    l2 = ELine(mn_coord(130,400),mn_coord(500,400))
    l3 = ELine(mn_coord(130,400),mn_coord(20,300))
    
    # add label after the fact
    a = EAngle(l2,l1)
    a.add_label(r'\alpha', alpha = 0.25)
    
    # add label as part of the creation of the angle
    b = EAngle(l2,l3, size=mn_scale(30), label_args=(r'\beta', dict(where=ArcLabelLocation.AT_START)))
    
```



## Transformations

For each of these methods, an `EMObjectPlayer` is returned, which must, in turn, be called for the animation to be processed.</font>**

eg. 

<font color=red>`angle.e_rotate([0.0.0], mn.PI)` DOES NOTHING!</font>

`angle.e_rotate([0.0.0], mn.PI)()` works, 

`angle.e_rotate([0.0.0], mn.PI)(run_time=2)` works, 

### `e_move(self, vector: mn.Vect3)`

move object by fixed amount

* `vector` - a 3d vector specifying the amount the of movement should occur 

_Example:_

```python
    l1 = ELine(mn_coord(130,400),mn_coord(500,150))
    l2 = ELine(mn_coord(130,400),mn_coord(500,400))
    a = EAngle(l2,l1,label=r'\alpha')
    
    a.e_move( mn_scale(100,50) )(run_time=1)  # NB: mn_scale returns a 3d-vector if a tuple is given as input
```



### `e_move_to(self, point_or_mobject: mn.Mobject|mn.Vect3, aligned_edge = mn.ORIGIN, coor_mask = np.array([1, 1, 1]))`

move object from its current location to a new point, or to the location of an existing object

* `point_or_mobject` - a vector, or a manim object.  This would be the location of the final object
* 



| Method                                                       | Description                                                  |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| **`e_move(self, vector: mn.Vect3)`**                         | moves object by `vector` amount                              |
| **`e_move_to(self, point_or_mobject: mn.Mobject                                                        | mn.Vect3, aligned_edge = mn.ORIGIN, coor_mask = np.array([1, 1, 1]))`** | moves object *to* the new specified location                 |
| **`e_rotate(self, about: mn.Vect3, angle: float)`**          | rotates object around the `about` point by `angle` radians (NOT degrees) |
| **`e_scale(self, scale: float, min_scale_factor = 1e-8, about_point = None, about_edge = mn.ORIGIN)`** | change the size of the object                                |
| **`e_to_edge(self, edge = mn.LEFT, buff = DEFAULT_EDGE_BUFFER)`** |                                                              |
| **`e_to_corner(self, corner: mn.Vect3 = mn.DL, buff: float = DEFAULT_EDGE_BUFFER)`** |                                                              |



def highlight(self, color=mn.YELLOW, scale=2.0, **args):

def tangent_points(self, angle_or_point: float | mn.Mobject | mn.Vect3, negative=False) -> tuple[mn.Vect3, mn.Vect3]:

def e_point_at_angle(self, angle) ->Point.EPoint:
    """create and return a EPoint object on the arc, located at angle (in radians),
    IF it falls into the range within the arc, otherwise defaults at 'start' or 'stop' of angle """
    return Point.EPoint(self.point_at_angle(angle))
