# utility.py
"""
rotpy.c_utility
===============


"""

import numpy as np
#from numpy import ndarray, empty
cimport cython
cimport numpy as np
# from numpy cimport ndarray, empty
#TODO determine if/when from-import is faster

#cython: boundscheck=False
#cython: wraparound=False

cdef extern from "math.h":
    double sin(double)
    double cos(double)
    double tan(double)
    double atan(double)


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
    cdef np.ndarray[double, ndim=2, mode='c'] R = np.empty((3, 3))

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


def trdi_erph_to_rph(erph):
    """Transform raw TRDI sensor angles to true Euler angles.

    Transforms sensor angles (integer hundredths of degrees) to true 
    Euler angles (radians), accounting for the internal tilt to gimbal 
    angle caveat on TRDI attitude sensors.

        P = arctan(tan(t1) * cos(R))

    Parameters
    ----------
    erph : integer list

    Returns
    -------
    rph : ndarray (3-by-1)

    """
    cdef double r = np.deg2rad(erph[0] / 100.) 
    cdef double t = np.deg2rad(erph[1] / 100.)
    cdef double p = atan(tan(t) * cos(r))
    cdef double h = np.deg2rad(erph[2] / 100.)
    # TODO consider faster method for deg2rad? e.g., from math.h import M_PI?
    cdef np.ndarray[double, ndim=1, mode='c'] rph = np.array([r, p, h])
    return rph


def trdi_erph_to_Rin(erph):
    """Rotation matrix from Euler angles--TRDI instrument to SNAME navigation.

    This function transforms integer hundredths of degrees measured by the 
    internal sensors on a Teledyne RD Instruments WorkHorse Doppler velocity
    log (DVL) or acoustic Doppler current profiler (ADCP) into a rotation
    matrix transforming instrument coordinates (starboard, forward, mast) 
    to navigation coordinates in the SNAME convention (North, East, Down).

    Parameters
    ----------
    erph : list of integers

    Returns
    -------
    Rin : ndarray (3-by-3)

    See Also
    --------
    trdi_erph_to_Rig : similar function that returns rotation matrix from
        instrument coordinates to geographic (East, North, Up) coordinates.

    """
    cdef np.ndarray[double, ndim=1, mode='c'] rph = trdi_erph_to_rph(erph)
    cdef double r = rph[0], p = rph[1], h = rph[2] # TODO avoid this
    cdef double sr = sin(r), sp = sin(p), sh = sin(h)
    cdef double cr = cos(r), cp = cos(p), ch = cos(h)
    cdef np.ndarray[double, ndim=2, mode='c'] Rin = np.empty((3, 3))

    #XXX    Taken from 'ADCP coordinate transformation' and modified 
    #       to transform instrument to NED instead of ENU
    #       Also confirmed in sagenb 'TRDI WHN to SNAME'
    Rin[0,0] = sp * sr * ch - sh * cr
    Rin[0,1] = ch * cp
    Rin[0,2] = - sp * ch * cr - sh * sr
    Rin[1,0] = sh * sp * sr + ch * cr
    Rin[1,1] = sh * cp
    Rin[1,2] = - sh * sp * cr + sr * ch
    Rin[2,0] = sr * cp
    Rin[2,1] = - sp
    Rin[2,2] = - cp * cr
    return Rin


def trdi_erph_to_Rig(erph):
    """Rotation matrix from Euler angles--TRDI instrument to geographic.

    This function transforms integer hundredths of degrees measured by the 
    internal sensors on a Teledyne RD Instruments WorkHorse Doppler velocity
    log (DVL) or acoustic Doppler current profiler (ADCP) into a rotation
    matrix transforming instrument coordinates (starboard, forward, mast) 
    to geographic coordinates in the convention (East, North, Up).

    Parameters
    ----------
    erph : list of integers

    Returns
    -------
    Rig : ndarray (3-by-3)

    See Also
    --------
    trdi_erph_to_Rin : similar function that returns rotation matrix from
        instrument coordinates to SNAME (North, East, Down) coordinates.

    """
    cdef np.ndarray[double, ndim=1, mode='c'] rph = trdi_erph_to_rph(erph)
    cdef double r = rph[0], p = rph[1], h = rph[2] # TODO avoid this
    cdef double sr = sin(r), sp = sin(p), sh = sin(h)
    cdef double cr = cos(r), cp = cos(p), ch = cos(h)
    cdef np.ndarray[double, ndim=2, mode='c'] Rig = np.empty((3, 3))

    #XXX    Taken from 'ADCP coordinate transformation'
    #       Also confirmed in sagenb 'TRDI WHN to SNAME'
    Rig[0,0] = sh * sp * sr + ch * cr
    Rig[0,1] = sh * cp
    Rig[0,2] = - sh * sp * cr + sr * ch
    Rig[1,0] = sp * sr * ch - sh * cr
    Rig[1,1] = ch * cp
    Rig[1,2] = - sp * ch * cr - sh * sr
    Rig[2,0] = - sr * cp
    Rig[2,1] = sp
    Rig[2,2] = cp * cr
    return Rig



