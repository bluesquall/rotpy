from distutils.dir_util import remove_tree
from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

import numpy

c_angles_ext = Extension('rotpy.c_angles', ['rotpy/c_angles.pyx'],
        include_dirs = [numpy.get_include()],
    )
c_utility_ext = Extension('rotpy.c_utility', ['rotpy/c_utility.pyx'],
        include_dirs = [numpy.get_include()],
    )
# TODO consider using pyximport instead

# remove build tree with compiled Cython
try: 
    remove_tree('./build') 
except:
    print "./build not found, continuing"

package_list = ['rotpy', ]
classifier_list = ['License :: OSI Approved :: MIT License',]
ext_module_list = [c_angles_ext, c_utility_ext]

setup(name = 'rotpy', version = '0.0.1',
      description = 'Tools and examples for rotating things.',
      author = 'M J Stanway', author_email = 'm.j.stanway@alum.mit.edu',
      packages = package_list, classifiers = classifier_list,
      ext_modules = ext_module_list, 
      cmdclass = {'build_ext': build_ext}
    )

# if things fail (esp. w/ pip) try "python setup.py build_ext --inplace"
