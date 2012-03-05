from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
import sys, os

version = file('VERSION.txt').read().strip()

setup(name='pyleargist',
      version=version,
      description="GIST Image descriptor for scene recognition",
      long_description=file('README.txt').read(),
      classifiers=[], # Get strings from http://pypi.python.org/pypi?%3Aaction=list_classifiers
      keywords=('image-processing computer-vision scene-recognition'),
      author='Olivier Grisel',
      author_email='olivier.grisel@ensta.org',
      url='http://www.bitbucket.org/ogrisel/pyleargist/src/tip/',
      license='PSL',
      package_dir={'': 'src'},
      #packages=['leargist'],
      cmdclass = {"build_ext": build_ext},
      ext_modules=[
          Extension(
              'leargist', [
                  'lear_gist/standalone_image.c',
                  'lear_gist/gist.c',
                  'src/leargist.pyx',
              ],
              libraries=['m', 'fftw3f'],
              include_dirs=['lear_gist',],
              extra_compile_args=['-DUSE_GIST', '-DSTANDALONE_GIST'],
          ),
      ],
      )
