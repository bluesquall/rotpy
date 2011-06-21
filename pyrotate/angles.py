""" 
pyrotate.angles
===============

Rotations defined by Euler angles.

Euler angles are intuitive because they are the first rotation representation
introduced to many people. They have several deficiencies, but they are here
to stay. Try not to use Euler angles for internal representation of rotations. 
Feel free to use them for communicating and plotting, but be sure to document
the convention you use!

"""

# use intrinsic/extrinsic flag to differentiate body/fixed axes
def to_matrix(angles, order='xyz', intrinsic=True,):
    raise NotImplementedError


def to_axis_angle(angles, order='xyz', intrinsic=True, ):
    raise NotImplementedError


def to_quaternion(angles, order='xyz', intrinsic=True,):
    raise NotImplementedError


