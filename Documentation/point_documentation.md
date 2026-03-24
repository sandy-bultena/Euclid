# EPoint

> [base methods and properties](./base_object_documentation.md)

```
def __init__(self, center, label, fill_color, radius, **kwargs):
```


## Arguments

| variable     | type                     | default    | description                                                  |
| ------------ | ------------------------ | ---------- | ------------------------------------------------------------ |
| `center`     | `mn.Vect3`               |            | the coordinates of the point                                 |
| `fill_color` | `mn.Color`               | `mn.White` | the width of the line outlining the object                   |
| `label`      | `str`, `tuple[str,dict]` | `None`     | Instead of using the method `add_label`, you can add a label here |
| `radius`     | `float`,                 | `mn_scale(7)`     | Radius of the circle indicating the point |
| `**kwargs`   |                          |            | Extra arguments for the animation                            |



## EPoint Properties

| Property      | type       | Description                               |
| ------------- | ---------- | ----------------------------------------- |
| `coordinates` | `mn.Vect3` | the coordinates of the start of the point |



## Label

### `add_label(self, text, direction, buff, away_from, towards, align) -> ELine`


| name        | type                   | default      | description                                                  |
| ----------- | ---------------------- | ------------ | ------------------------------------------------------------ |
| `text`      | `str`                  |              | the string representation of the label                       |
| `direction` | ` mn.Vect3`            | `mn.UP`      | what direction do you want to put the label (up, down, right, left) (overides 'side' parameter).  Note that it goes in the direction based on the point calculated by `alpha`, and not 'up' of the line per se |
| `buff`      | `float`                | `LABEL_BUFF` | how far away from the line do you want the label             |
| `away_from` | `Callable[[],mn.Vect3]`, `mn.Vect3` | `None` | The label will be on the farther side from the away_from location.  If set, overides the `direction` argument and ignores the `towards` argument |
| `towards` | `Callable[[],mn.Vect3]`, `mn.Vect3`, | `None` | The label will be on the closer side from the away_from location.  If set, overides the `direction` argument |
| `align`     |                        | `mn.ORIGIN`  | which side to align the text to                              |

> **away_from**, and **towards** accept the following:
>
> * a function that returns a coordinate (`mn.Vect3`)
> * a coordinate (`mn.Vect3`)
> * an `mn.Object` where the center of that object will be used as the coordinates

_Example_: labels
<img src="./images/point_labels.png" style="zoom:30%;" />

```python
    p = EPoint(mn_coord(500,150)).add_label(r"\text{aligned left}", align=mn.LEFT)
    p = EPoint(mn_coord(500,200)).add_label(r"\text{aligned right}", align=mn.RIGHT)

    # center of clock
    p = EPoint(mn_coord(400,400))

    # labels on the outside, use 'away_from'= mn.Vect3
    for hour in range(1,13):
        xc,yc,_ = p.coordinates
        angle = (mn.PI/2 - mn.PI/6 * hour)%mn.TAU
        x = xc + mn_scale(100)*math.cos(angle)
        y = yc + mn_scale(100)*math.sin(angle)
        EPoint((x,y,0)).add_label(str(hour),away_from=[xc,yc,0])

    # center of clock
    p = EPoint(mn_coord(800,400))

    # labels on the inside, use 'towards'= mn.Object
    for hour in range(1,13):
        xc,yc,_ = p.coordinates
        angle = (mn.PI/2 - mn.PI/6 * hour)%mn.TAU
        x = xc + mn_scale(120)*math.cos(angle)
        y = yc + mn_scale(120)*math.sin(angle)
        EPoint((x,y,0)).add_label(str(hour),towards=p) 
```

## Class Methods

### `distance_between( cls, p1, p2)-> float`

calculates the distance between the two points

| name | type              | default | description                                      |
| ---- | ----------------- | ------- | ------------------------------------------------ |
| `p1` | `EPoint|mn.Vect3` |         | first point or coordinate                        |
| `p2` | `EPoint|mn.Vect3` |         | 2nd point or coordinate                          |





