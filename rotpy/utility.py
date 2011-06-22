# utility.py

import numpy as np
from pyrotate.angles import _to_matrix_intrinsic

def ixsea_rph_to_sname_Rvn(rph):
    """Rotation matrix from Euler angles--IXSEA to SNAME convention.

    Parameters
    ----------

    Returns
    -------


    """
    r, p, h = rph
    fpm2nwu = _to_matrix_intrinsic((r, p, -h), order = (1,2,3)) # heading flip
    fsk2fpm = np.array([[1,0,0],[0,-1,0],[0,0,-1]]) # SNAME to IXSEA
    nwu2ned = np.array([[1,0,0],[0,-1,0],[0,0,-1]]) # NWU to NED
    return reduce(np.dot, [nwu2ned, fpm2nwu, fsk2fpm]) # gives fsk2ned


