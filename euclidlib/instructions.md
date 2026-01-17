## Setup

```bash
export PYTHONPATH=/Users/sandy/PycharmProjects/euclid-manim/:$PYTHONPATH
export PATH=/Library/Frameworks/Python.framework/Versions/3.12/bin/:$PATH
export EUCLID_DEBUG_LEVEL=1  # or any level that you want, defaults to zero if not defined
```

## Run
```bash
manimgl propostion_name.py
```

# Explanation(s)?

## Starting Point:

In `PropScene.py`, the function `construct` is called by `manimgl`.  This is the entry point

All proposition classes must inherit from `BookScene.py`.  `BookScene.py` has a method called `title_page` which is 
called by `PropScene` _before_ running anything in the proposition.

# User Interactions

## Draw

1. Hold `x` button and move mouse
2. Repeat as required
3. To clear, click `c`

# ?
## break into parts (TextBox)
is used so that we can align the various parts with strings above (i.e. align '>' signs, or '=' signs)

## EMObject

* at creation, will call `e_draw`
```python
        if not delay_anim:
            self.e_draw(skip_anim)
```

## Order of Execution

* manim setup - calls PropScene 'add' to add ['Group']  _no idea what it is used for_

* then PropScene.construct is called

* for any EMObject or EMObjectGroup that is created, during their `__init__`, will call `e_draw`.
```python
        if not delay_anim:
            self.e_draw(skip_anim)
```

`e_draw` then gets the relevant animations by calling `CreationOf` methods, and then calls `scene.play` if there are any animations to be done

if `with simultaneous` used, the animation state is set to STORING and `scene.play` is still called, but nothing happens, after all the block code within the `with` is executed, then all the stored animations are played at once (again, calling `scene.play`)

Although `PropScene.add` can be called anytime, it is also called by `manim.scene.play` which is called by `PropScene.play` _if_ the state is normal.

If `scene` is not defined, it is found by calling `find_scene` which works it way up the stack until it finds PropScene

