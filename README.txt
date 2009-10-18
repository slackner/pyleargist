Python Wrapper for the LEAR image descriptor implementation
===========================================================

:author: <olivier.grisel@ensta.org>

Library to compute GIST global image descriptors to be used to compare pictures
based on their content (to be used global scene recognition and categorization).

The GIST image descriptor theoritical definition can be found on A. Torralba's
page: http://people.csail.mit.edu/torralba/code/spatialenvelope/

The source code of the C implementation is included in the ``lear_gist``
subfolder. See http://lear.inrialpes.fr/software for the original project
information.

pyleargist is licensed under the GPL, the same license as the original C
project.


Install
-------

Install libfftw3 with development headers (http://www.fftw.org), python dev
headers, gcc and the Python Imaging Library and numpy.

Build locally for testing::

  % python setup.py buid_ext -i
  % export PYTHONPATH=`pwd`/src

Build and install system wide::

  % python setup.py build
  % sudo python setup.py install

Usage
-----

TODO

::

  >>> from PIL import Image
  >>> import leargist

