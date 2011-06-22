# c_angles.pyx
"""
pyrotate.c_angles
===============


See c_utility.pyx for functions to translate directly for specific conventions.
"""
cimport cython
#@cython.boundscheck(False) # would prevent segfault by accessing out-of-bounds
#@cython.wraparound(False)

cimport numpy as np

cdef extern from "math.h":
    double sin(double)
    double cos(double)

#def to_matrix(ndarray[double] angles, axes = (3, 2, 1), intrinsic=True):
#TODO this top-level function should handle any change from axes strings to tuples

def _to_matrix_intrinsic(ndarray[double] angles, axes = (3, 2, 1)):
    return reduce(np.dot [_to_matrix_about_elemental_axis(*aa)
                          for aa in reversed(zip(angles, axes))])
    # XXX does the list comprehension agtually gain me anything in pyrex?


def _to_matrix_about_elemental_axis(double angle, int axis):
    if axis == 1: return _to_matrix_about_i(angle)
    elif axis == 2: return _to_matrix_about_j(angle)
    elif axis == 3: return _to_matrix_about_k(angle)
    else: pass #TODO raise an error


def _to_matrix_about_i(double angle):
    cdef double s = sin(angle), cdef double c = cos(angle)
    return np.array([[1, 0, 0],[0, c, s],[0, -s, c]]) # e.g. roll


def _to_matrix_about_j(double angle):
    cdef double s = sin(angle), cdef double c = cos(angle)
    return np.array([[c, 0, -s],[0, 1, 0],[s, 0, c]]) # e.g. pitch


def _to_matrix_about_k(double angle):
    cdef double s = sin(angle), cdef double c = cos(angle)
    return np.array([[c, s, 0],[-s, c, 0],[0, 0, 1]]) # e.g. heading


def to_axis_angle(angles, order='xyz', intrinsic=True, ):
    raise NotImplementedError


def to_quaternion(angles, order='xyz', intrinsic=True,):
    raise NotImplementedError


