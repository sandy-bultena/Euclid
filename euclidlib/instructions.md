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