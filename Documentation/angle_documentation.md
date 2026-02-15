# EAngle 

`EAngle` creates either an arc, or a box (if angle is a right angle), that is used to denote the angle between two lines. 

> Calling this function (it is not a class) will return objects of type `Gnomon| ArcAngle| RightAngle` which are all dervied classes from `EangleBase`

[base methods and properties](./base_object_documentation.md)

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

_Example_:
<img src="./images/angle_basics.png" style="zoom:30%;" />
```python
    l1 = ELine(mn_coord(130,400),mn_coord(130,150))
    l2 = ELine(mn_coord(130,400),mn_coord(300,400))
    EAngle(l1,l2,label=("right angle",dict(buff=2*LABEL_BUFF)))

    l1 = ELine(mn_coord(330,400),mn_coord(330,150))
    l2 = ELine(mn_coord(330,400),mn_coord(500,400))
    EAngle(l1,l2, no_right=True, label=("right angle, arc symbol",dict(buff=2*LABEL_BUFF)))

    l1 = ELine(mn_coord(530,400),mn_coord(580,150))
    l2 = ELine(mn_coord(530,400),mn_coord(700,400))
    EAngle(l1,l2, label=("standard",dict(buff=2*LABEL_BUFF)))
```

## Label

### `add_label`

| parameter | type               | default                     | description                                                  |
| --------- | ------------------ | --------------------------- | ------------------------------------------------------------ |
| `text`    | `str`              |                             | the label text                                               |
| `where`   | `ArcLabelLocation` | `ArcLabelLocation.BY_ALPHA` | `BY_ALPHA` - label is placed a fraction along its arc (defined by `alpha` argument)<br>`AT_START` - label is placed at the beginning of the arc (`alpha` argument is ignored)<br>`AT_END` - label is placed at the end of the arc (`alpha` argument is ignored) |
| `alpha`   | `float`            | `0.5`                       | a fractional value defining where along the arc path the label should be placed |
| `buff`    | `float`            | `LABEL_BUFF`                | the amount of space between the arc and the label            |



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

Note that the transformations only apply to the angle indicator and its label, not to the two lines that define the angle.

> See the transformations documentation for details.

Generally speaking, it is not necessary to transform an angle using a transformation methods.  

## Constructions

### `copy_to_line`

Takes an existing angle, and copies that angle onto another line.

| parameter  | type     | default | description                                                  |
| ---------- | -------- | ------- | ------------------------------------------------------------ |
| `point`    | `EPoint` |         | the point that will define the vertex of the angle           |
| `line`     | `ELine`  |         | the line to which the new angle will be drawn on             |
| `negative` | `bool`   | `False` | if true, a positive angle will be drawn, else a negative angle |
| `speed`    | `int`    | `None`  | if  `speed > 0`, the construction of the new angle will be animated, otherwise only the final angle being drawn will be animated.  The larger the `speed` number, the faster the animation |

**Returns**: `tuple[ELine, EAngleBase]`

_Example:_ Copy to line, no construction animation (click to play)
<video controls width="300" height="200" poster="placeholder_image.png">
    <source src="./images/angle_copy_to_line_speed_0.mp4" type="video/mp4">
</video>
```python
    l1 = ELine(mn_coord(100,400),mn_coord(500,150))
    l2 = ELine(mn_coord(100,400),mn_coord(500,500))
    a = EAngle(l2,l1,label="A")
    l3 = ELine(mn_coord(100,600),mn_coord(500,600))
    new_line, new_angle = a.copy_to_line(EPoint(mn_coord(100,600)),l3)
```

_Example:_ Copy to line, with construction animation (click to play)
<video controls width="300" height="200" poster="placeholder_image.png">
    <source src="./images/angle_copy_to_line_speed_1.mp4" type="video/mp4">
</video>

```python
    l1 = ELine(mn_coord(130,400),mn_coord(500,150))
    l2 = ELine(mn_coord(130,400),mn_coord(500,400))
    a = EAngle(l2,l1,label="A")
    l3 = ELine(mn_coord(100,600),mn_coord(500,600))
    new_line, new_angle = a.copy_to_line(EPoint(mn_coord(100,600)),l3,speed=1)

```

### bisect

Create a line that bisects the angle, and draws said line

| parameter | type | default | description |
| --------- | ---- | ------- | ----------- |
| `speed`    | `int`    | `None`  | if  `speed > 0`, the construction of the new angle will be animated, otherwise only the final |

**Returns**: bisecting_line

_Example:_
<img src="./images/angle_bisect.png" style="zoom:30%;" />

```python
    l1 = ELine(mn_coord(130,400),mn_coord(130,150))
    l2 = ELine(mn_coord(130,400),mn_coord(500,500))
    a = EAngle(l2,l1,label=("A",dict(alpha=.25)))
    l3 = a.bisect()
    a_half = EAngle(l1,l3, label="B", size=mn_scale(60))
```





```

    


# ==============================================================================================================
# Arc Angle class
# - base class for Angle and Gnomon
# ==============================================================================================================
class ArcAngle(EAngleBase, mn.Arc):
    def __init__(self,
                 l1: Line.ELine,
                 l2: Line.ELine,
                 size: float,
                 angle_data: ANGLE_DATA,
                 angle1: float,
                 angle: float,
                 **kwargs):
        self.l1 = l1
        self.l2 = l2
        center, self.vec1, self.vec2 = angle_data

        self.angle_indicator = super().__init__(
            angle1,
            angle,
            radius=size,
            arc_center=center,
            **kwargs
        )

# ==============================================================================================================
# Right Angle class
# - draws 'half a square' as the angle indicator instead of an arc
# ==============================================================================================================
class RightAngle(EAngleBase):
    LabelBuff = 0.15

    def __init__(self,
                 l1: Line.ELine,
                 l2: Line.ELine,
                 size: float,
                 angle_data: ANGLE_DATA,
                 angle1: float,
                 angle: float,
                 delay_anim=False,
                 **kwargs):
        self.l1 = l1
        self.l2 = l2
        self.size = size / math.sqrt(2)

        super().__init__(**kwargs, delay_anim=True)

        part_size = 1 / math.sqrt(2)
        if angle > 0:
            self.set_points_as_corners([
                mn.RIGHT * part_size,
                mn.UR * part_size,
                mn.UP * part_size,
            ])
        else:
            self.set_points_as_corners([
                mn.RIGHT * part_size,
                mn.DR * part_size,
                mn.DOWN * part_size,
            ])

        center, self.vec1, self.vec2 = angle_data
        self.rotate(angle1, about_point=mn.ORIGIN)
        self.scale(size, about_point=mn.ORIGIN)
        self.shift(center)
        if not delay_anim:
            self.e_draw()


# ==============================================================================================================
# Gnomon
# - not sure why we have an empty class, but I guess I'll figure out why later
# ==============================================================================================================
class Gnomon(ArcAngle):
    """the part of a parallelogram left when a similar parallelogram has been taken from its corner."""
    pass


# ==============================================================================================================
# EAngle - whoa - EAngle is not a class... didn't know that
# ==============================================================================================================
def EAngle(l1: Line.ELine | str,
           l2: Line.ELine = None,
           size: float = mn_scale(40),
           no_right: bool = False,
           gnomon: bool = False,
           **kwargs) -> Gnomon| ArcAngle| RightAngle:

    # to be deleted later, I don't want to support this, its too weird
    if isinstance(l1, str):
        l1, l2 = Line.ELine.find_in_frame(l1)

    assert (l2 is not None)

    # ----------------------------------------------------------------------------------------------------------
    # get info about the angle
    # ----------------------------------------------------------------------------------------------------------
    data = angle_coords(l1, l2)
    c, v1, v2 = data

    if c is None:
        raise Exception(f"No Common Midpoint: {l1.get_start(), l1.get_end()} | {l2.get_start(), l2.get_end()}")

    th1 = math.atan2(v1[1], v1[0])
    th2 = math.atan2(v2[1], v2[0])
    th_diff = th2 - th1

    # ----------------------------------------------------------------------------------------------------------
    # if this is a gnomon (a 270 degree angle defining a weird L-shape right angled polygon)
    # ----------------------------------------------------------------------------------------------------------
    if gnomon:
        if 0 < th_diff < mn.PI:
            th_diff = th_diff - mn.TAU
        elif -mn.PI < th_diff < mn.PI:
            th_diff = mn.TAU + th_diff
        return Gnomon(l1, l2, size, data, th1, th_diff, **kwargs)

    # ----------------------------------------------------------------------------------------------------------
    # Just a regular angle
    # ----------------------------------------------------------------------------------------------------------
    if th_diff > mn.PI:
        th_diff = th_diff - mn.TAU
    elif th_diff < -mn.PI:
        th_diff = mn.TAU + th_diff

    if abs(abs(th_diff) - mn.PI / 2) < (1 * mn.DEGREES) and not no_right:
        return RightAngle(l1, l2, size, data, th1, th_diff, **kwargs)
    else:
        return ArcAngle(l1, l2, size, data, th1, th_diff, **kwargs)
```
