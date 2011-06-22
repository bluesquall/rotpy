"""
rotpy
=====

Python module for handling rotations.

Optimized alternatives implemented in C will be loaded when present.

"""

try:
    import c_angles as angles
except ImportError:
    import angles


