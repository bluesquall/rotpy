from distutils.core import setup

packlist = ['rotpy', ]
classifierlist = ['License :: OSI Approved :: MIT License',]
setup(name = 'rotpy', version = '0.0.1',
      description = 'Tools and examples for rotating things.',
      author = 'M J Stanway', author_email = 'm.j.stanway@alum.mit.edu',
      packages = packlist, classifiers = classifierlist,
    )
