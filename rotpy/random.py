#!/usr/bin/env python
"""
Random submodule for `rotpy`
============================

This module provides methods for generating random rotations.

note: Methods defined here _may_ be moved to separate modules corresponding
to each rotation parametrization in the future. That will depend on where we
take the overall package architecture.

"""

import numpy as np

def rotation_matrix(p=3, N=1, algorithm='Cayley'):
    """Random matrix in SO(p).

    Parameters
    ----------
    p : int
        Dimension of random rotation matrix.
    N : int
        Number of matrices to generate.

    Returns
    -------
    R : ndarray (N-by-N)
        Random matrix in SO(p)

    .. note:: The current code does not make matrices _uniformly_ random.

    """

    # TODO support returning multiple matrices
    if algorithm == 'Cayley':
        Q = skew_matrix(p)
        I = np.eye(p)
        R = np.linalg.solve(I - Q, I + Q)
    else:
        err = "Requested algorithm: {0} is not implemented."
        raise NotImplementedError(err.format(algorithm))
    return R


def skew_matrix(p=3, algorithm='axiom'):
    """Uniformly random skew-symmetric matrix.

    Parameters
    ----------
    p : int
        Dimension of random skew-symmetric matrix.

    Returns
    -------
    Q : ndarray (p-by-p)
        Uniformly random skew-symmetric matrix.

    """
    if algorithm == "axiom":
        A = np.random.uniform(size=[p, p])
        Q = A - A.T
    elif algorithm == "vector":
        Q = vector_to_skew_matrix(np.random.uniform(size=p))
    else:
        err = "Requested algorithm: {0} is not implemented."
        raise NotImplementedError(err.format(algorithm))
    return Q


def vector_to_skew_matrix(v):
    """Skew-symmetric matrix.

    Parameters
    ----------
    v : array_like
        Vector to skew-symmetrize.

    Returns
    -------
    Q : ndarray
        Skew-symmetric matrix.
    
    .. note::   This method is useful beyond generating random rotations,
                so it may be moved to a different module in the future.

    """
    if len(v) != 3: 
        raise NotImplementedError('only 3D is implemented')
    else:
        Q = np.zeros([len(v), len(v)])
        Q[1, 2] = -v[0]
        Q[2, 1] = v[0]
        Q[0, 2] = -v[1]
        Q[2, 0] = v[1] 
        Q[0, 1] = -v[2]
        Q[1, 0] = v[2]
    return Q
