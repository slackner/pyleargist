#!/usr/bin/env python2
from __future__ import division

from PIL import Image
import math
import numpy
import os
import sys
import unittest

import_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), "../")
sys.path.insert(1, import_path)

import leargist
import skimage.color
import PIL

class Tests(unittest.TestCase):
    def test_all(self):
        img = Image.open("../lear_gist/ar.ppm")
        descr = leargist.color_gist(img)
        self.assertTrue(numpy.allclose(descr[:4], numpy.array([0.0579, 0.1926, 0.0933, 0.0662]), atol=1e-3))
        self.assertTrue(numpy.allclose(descr[-3:], numpy.array([0.0563, 0.0575, 0.0640]), atol=1e-3))

        img = img.resize((256, 256), PIL.Image.ANTIALIAS)
        descr = leargist.color_gist(img)
        self.assertEqual(len(descr), 960)
        descr = leargist.color_gist(img, nblocks=3)
        self.assertEqual(len(descr), 540)

        img = img.convert('L')
        descr = leargist.color_gist(img)
        self.assertEqual(len(descr), 960)

        img = Image.open("roofs1.jpg")
        descr = leargist.color_gist(img)
        self.assertEqual(len(descr), 960)

        img = Image.open("roofs2.jpg")
        descr = leargist.color_gist(img)
        self.assertEqual(len(descr), 960)

if __name__ == '__main__':
    unittest.main()
