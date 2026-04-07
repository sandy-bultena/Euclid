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

## Other

* `center_of_mass` is a manim method

## Updaters
what are `updaters` - they are methods (like `f_always` that keep are called at every frame change)

## Labels

### Label Updaters

in `Text:Label`, an updater is created which calls `e_label_location` on every frame,

```python
        self.f_always.move_to(
            lambda: em_object.e_label_location(*self.args, **self.extra_args),
            aligned_edge=lambda: self.align
        )
```

### Label Location

label location is defined by its updater `e_label_location`, NOT by `add_label`, or `init_label`

NOTE: it is important that if the `e_label_location` is relies on elements of the object it is attached to, then those elements must be modified if the object is being modified via animations (so you must create your own animation (see Arc as an example))

### images to pdfs
```text
Method 1: img2pdf (Lossless & Fast)
This tool ensures the PNG is embedded directly into the PDF without re-encoding, preserving quality and reducing file size. 
Install via pip3: pip3 install img2pdf.
Convert: Run this in your terminal:
bash
img2pdf *.png -o output.pdf
This converts all PNGs in the current folder, ordered alphabetically, into output.pdf. 

```