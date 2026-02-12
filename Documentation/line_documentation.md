### Label Arguments

| name        | type        | default | description                                                  |
| ----------- | ----------- | ------- | ------------------------------------------------------------ |
| `label`     | `str`       |         | the string representation of the label                       |
| `direction` | ` mn.Vect3` | `mn.UP` | direction to place the label (valid for `ELine`, `EPoint`)   |
| `inside`    | `bool`      | `False` | In a `ECircle` or `ELine` overrides the `direction` argument, where inside is to the *left* of the line if you think of the line as a vector, for a circle it is obvious |
| `outside`   | `bool`      | `False` | In a `ECircle` or `ELine` overrides the `direction` argument, where inside is to the *right* of the line if you think of the line as a vector, for a circle it is obvious, but this option is ignored if `inside` is set to True |
|             |             |         |                                                              |

