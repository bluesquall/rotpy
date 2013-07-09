#!/usr/bin/env python
"""
Estimation module for `rotpy`
=============================

This module defines methods useful for estimating unknown rotations from
input-output data.

"""

import numpy as np

def matrix_solve_rotation(a, b, allow_reflection=False):
    """Find the rotation matrix that best fits the data.
    
    Solve for a rotation matrix using the method published by Umeyama in 1991.
    
    a = Rb
    
    Parameters
    ----------
    a : array
    b : array
    allow_reflection : boolean
        If True, this method may return a rotoreflection instead of a proper
        rotation. 
    
    Returns
    -------
    R : ndarray (N-by-N)
        Best-fit rotation matrix in SO(3)
    
    Examples
    --------
    >>> a = np.random.normal(0,1,[3,21]) # generate some random vector data
    >>> a = a / np.sum(a**2, axis=0)**0.5 # normalize
    >>> Rtrue = rotpy.random.rotation_matrix(3)
    >>> b = np.dot(Rtrue.T, a)
    >>> Rfit = rotpy.estimate.matrix_solve_rotation(a, b)
    >>> np.allclose(Rtrue, Rfit)
    True
    
    """
    abt = np.dot(a, b.T) # data covariance matrix
    detabt = np.linalg.det(abt)
    S = np.eye(a.shape[0])
    if detabt < 0 :
        print "reflection fits better than rotation"
        if not allow_reflection:
            print 'reflection not allowed, restricting'
            S[-1,-1] = -1
    U, D, VH = np.linalg.svd(abt)
    R = np.dot(U, np.dot(S, VH))
    # TODO optionally include error metrics
    return R
    

def matrix_solve_general_least_squares(a, b):
    """Convenience method to find best fit general matrix.
    
    This is primarily for comparison to the `matrix_solve_rotation` method 
    in this module.

    a = Gb
    
    Parameters
    ----------
    a : array
    b : array
    
    Returns
    -------
    G : ndarray (N-by-N)
        Best-fit general matrix
            
    """
    G = np.linalg.lstsq(b.T, a.T)[0].T
    # TODO optionally include error metrics
    return G


