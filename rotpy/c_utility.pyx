# utility.py
"""
rotpy.c_utility
===============


"""

#import numpy as np
from numpyt import (ndarray, empty)
cimport cython
# cimport numpy as np
from numpy cimport (ndarray, empty)
#TODO determine if/when from-import is faster

#cython: boundscheck=False
#cython: wraparound=False

cdef extern from "math.h":
    double sin(double)
    double cos(double)


def ixsea_rph_to_sname_Rvn(rph):
    """Rotation matrix from Euler angles--IXSEA to SNAME convention.

    Parameters
    ----------
    rph

    Returns
    -------
    Rvn

    """
    cdef double sr = sin(rph[0]), sp = sin(rph[1]), sh = sin(rph[2])
    cdef double cr = cos(rph[0]), cp = cos(rph[1]), ch = cos(rph[2])
    cdef ndarray[double, ndim=2, mode='c'] R = empty((3, 3))

    #XXX as calculated in sage notebook `IXSEA to SNAME'
    R[0,0] = ch*cp
    R[0,1] = -sp*sr*ch - sh*cr
    R[0,2] = -sp*ch*cr + sh*sr
    R[1,0] = sh*cp
    R[1,1] = -sh*sp*sr + ch*cr
    R[1,2] = -sh*sp*cr - sr*ch
    R[2,0] = sp
    R[2,1] = sr*cp
    R[2,2] = cp*cr
    return R


def ixsea_rph_to_sname_Rnv(rph):
    """Rotation matrix from Euler angles--IXSEA to SNAME convention.
 
    Parameters
    ----------
    rph

    Returns
    -------
    Rnv

    """
    return ixsea_rph_to_sname_Rvn.transpose()


