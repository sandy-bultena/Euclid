ManimGL [32mv1.7.1[0m
<class 'manimlib.mobject.svg.text_mobject.Text'> get_center [17.4375     26.23632801  0.        ]
<class 'manimlib.mobject.svg.text_mobject.Text'> get_center [ 8.734375   44.59570312  0.        ]
<class 'manimlib.mobject.numbers.DecimalNumber'> get_center [0.23639688 0.         0.        ]
<class 'manimlib.mobject.numbers.DecimalNumber'> get_center [0.23639688 0.         0.        ]
<class 'manimlib.mobject.numbers.DecimalNumber'> get_center [0.23639688 0.         0.        ]
<class 'manimlib.mobject.numbers.DecimalNumber'> get_center [0.23639688 0.         0.        ]
<class 'manimlib.mobject.numbers.DecimalNumber'> get_center [0.23639688 0.         0.        ]
<class 'manimlib.mobject.numbers.DecimalNumber'> get_center [0.23639688 0.         0.        ]
<class 'manimlib.mobject.types.vectorized_mobject.VGroup'> get_center [0.7648 0.     0.    ]
<class 'manimlib.mobject.numbers.DecimalNumber'> get_center [0.09507188 0.         0.        ]
<class 'manimlib.mobject.numbers.DecimalNumber'> get_center [0.09507188 0.         0.        ]
<class 'manimlib.mobject.types.vectorized_mobject.VGroup'> get_center [38.25  0.    0.  ]
<class 'manimlib.mobject.numbers.DecimalNumber'> get_center [0. 0. 0.]

  File "/Library/Frameworks/Python.framework/Versions/3.12/bin/manimgl", line 8, in <module>
    sys.exit(main())
   File "/Library/Frameworks/Python.framework/Versions/3.12/lib/python3.12/site-packages/manimlib/__main__.py", line 25, in main
    scene.run()
   File "/Library/Frameworks/Python.framework/Versions/3.12/lib/python3.12/site-packages/manimlib/scene/scene.py", line 163, in run
    self.construct()
   File "/Users/sandy/PycharmProjects/euclid-manim/euclidlib/Scenes/PropScene.py", line 71, in construct
    self.run_full()
   File "/Users/sandy/PycharmProjects/euclid-manim/Documentation/Examples/polygon_examples.py", line 18, in run_full
    move_point_to()
   File "/Users/sandy/PycharmProjects/euclid-manim/Documentation/Examples/polygon_examples.py", line 31, in move_point_to
    EPoint(mn_coord(450,50), radius=mn_scale(1))
   File "/Users/sandy/PycharmProjects/euclid-manim/euclidlib/Objects/Point.py", line 31, in __init__
    super().__init__(
   File "/Users/sandy/PycharmProjects/euclid-manim/euclidlib/Objects/em_object_base.py", line 86, in __init__
    super().__init__(*args, **kwargs)
   File "/Library/Frameworks/Python.framework/Versions/3.12/lib/python3.12/site-packages/manimlib/mobject/geometry.py", line 296, in __init__
    super().__init__(
   File "/Library/Frameworks/Python.framework/Versions/3.12/lib/python3.12/site-packages/manimlib/mobject/geometry.py", line 222, in __init__
    self.scale(radius, about_point=ORIGIN)
   File "/Library/Frameworks/Python.framework/Versions/3.12/lib/python3.12/site-packages/manimlib/mobject/mobject.py", line 967, in scale
    self.apply_points_function(
   File "/Library/Frameworks/Python.framework/Versions/3.12/lib/python3.12/site-packages/manimlib/mobject/mobject.py", line 224, in wrapper
    result = func(self, *args, **kwargs)
   File "/Library/Frameworks/Python.framework/Versions/3.12/lib/python3.12/site-packages/manimlib/mobject/mobject.py", line 294, in apply_points_function
    arrs.append(mob.get_bounding_box())
   File "/Library/Frameworks/Python.framework/Versions/3.12/lib/python3.12/site-packages/manimlib/mobject/mobject.py", line 341, in get_bounding_box
    self.print_debug(*traceback.format_stack())

<class 'euclidlib.Objects.Point.EPoint'> 
 [[-1. -1.  0.]
 [ 0.  0.  0.]
 [ 1.  1.  0.]]

  File "/Library/Frameworks/Python.framework/Versions/3.12/bin/manimgl", line 8, in <module>
    sys.exit(main())
   File "/Library/Frameworks/Python.framework/Versions/3.12/lib/python3.12/site-packages/manimlib/__main__.py", line 25, in main
    scene.run()
   File "/Library/Frameworks/Python.framework/Versions/3.12/lib/python3.12/site-packages/manimlib/scene/scene.py", line 163, in run
    self.construct()
   File "/Users/sandy/PycharmProjects/euclid-manim/euclidlib/Scenes/PropScene.py", line 71, in construct
    self.run_full()
   File "/Users/sandy/PycharmProjects/euclid-manim/Documentation/Examples/polygon_examples.py", line 18, in run_full
    move_point_to()
   File "/Users/sandy/PycharmProjects/euclid-manim/Documentation/Examples/polygon_examples.py", line 31, in move_point_to
    EPoint(mn_coord(450,50), radius=mn_scale(1))
   File "/Users/sandy/PycharmProjects/euclid-manim/euclidlib/Objects/Point.py", line 31, in __init__
    super().__init__(
   File "/Users/sandy/PycharmProjects/euclid-manim/euclidlib/Objects/em_object_base.py", line 86, in __init__
    super().__init__(*args, **kwargs)
   File "/Library/Frameworks/Python.framework/Versions/3.12/lib/python3.12/site-packages/manimlib/mobject/geometry.py", line 296, in __init__
    super().__init__(
   File "/Library/Frameworks/Python.framework/Versions/3.12/lib/python3.12/site-packages/manimlib/mobject/geometry.py", line 223, in __init__
    self.shift(arc_center)
   File "/Library/Frameworks/Python.framework/Versions/3.12/lib/python3.12/site-packages/manimlib/mobject/mobject.py", line 940, in shift
    self.apply_points_function(
   File "/Library/Frameworks/Python.framework/Versions/3.12/lib/python3.12/site-packages/manimlib/mobject/mobject.py", line 224, in wrapper
    result = func(self, *args, **kwargs)
   File "/Library/Frameworks/Python.framework/Versions/3.12/lib/python3.12/site-packages/manimlib/mobject/mobject.py", line 294, in apply_points_function
    arrs.append(mob.get_bounding_box())
   File "/Library/Frameworks/Python.framework/Versions/3.12/lib/python3.12/site-packages/manimlib/mobject/mobject.py", line 341, in get_bounding_box
    self.print_debug(*traceback.format_stack())

<class 'euclidlib.Objects.Point.EPoint'> 
 [[-0.01 -0.01  0.  ]
 [ 0.    0.    0.  ]
 [ 0.01  0.01  0.  ]]
[12:41:33] INFO                                                                                                 scene.py:201
                    Tips: Using the keys `d`, `f`, or `z` you can interact with the scene. Press `command + q`              
                    or `esc` to quit                                                                                        
