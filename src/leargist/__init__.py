import os
from ctypes import CFUNCTYPE
from ctypes import POINTER
from ctypes import pointer
from ctypes import Structure
from ctypes import c_float
from ctypes import c_int
from ctypes import c_longlong
from ctypes import c_void_p
import numpy as np

leargist_folder = os.path.abspath(__file__).rsplit(os.path.sep, 1)[0]
leargist_name = "_gist"
libleargist = np.ctypeslib.load_library(leargist_name, leargist_folder)

class GistColorImage(Structure):
    _fields_ = [
        ("width", c_int), # stride = width
        ("height", c_int),
        ("c1", POINTER(c_float)), # R
        ("c2", POINTER(c_float)), # G
        ("c3", POINTER(c_float)), # B
    ]

libleargist.color_gist_scaletab.argtypes = (
    POINTER(GistColorImage), c_int, c_int, POINTER(c_int))
libleargist.color_gist_scaletab.returntype = POINTER(c_float)

def color_gist(im, nblocks=4, orientations=(8, 8, 4)):
    scales = len(orientations)
    if scales > 50:
        raise ValueError("lear_gist supportsmaximum 50 scales")
    orientations = np.array(orientations, dtype=np.int32)

    # ensure the image is encoded in RGB
    im = im.convert(mode='RGB')

    # build the lear_gist color image C datastructure
    arr = np.fromstring(im.tostring(), np.uint8)
    arr.shape = list(im.size) + [3]
    arr = np.ascontiguousarray(arr.transpose(2,0,1))

    gci = GistColorImage(
        im.size[0],
        im.size[1],
        arr[0].ctypes.data_as(POINTER(c_float)),
        arr[1].ctypes.data_as(POINTER(c_float)),
        arr[2].ctypes.data_as(POINTER(c_float)))

    libleargist.color_gist_scaletab(
        pointer(gci), nblocks, scales,
        orientations.ctypes.data_as(POINTER(c_int)))

