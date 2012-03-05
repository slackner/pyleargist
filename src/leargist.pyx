cimport leargist
import numpy as np 
cimport numpy as np

np.import_array()

def color_gist(im, nblocks=4, orientations=(8, 8, 4)):
     """Compute the GIST descriptor of an RGB image"""
     scales = len(orientations)
     orientations = np.array(orientations, dtype=np.int32)

     # check minimum image size
     if im.size[0] < 8 or im.size[1] < 8:
          raise ValueError(
               "image size should at least be (8, 8), got %r" % (im.size,))
         
     # ensure the image is encoded in RGB
     im = im.convert(mode='RGB')
         
     # build the lear_gist color image C datastructure
     arr = np.fromstring(im.tostring(), np.uint8)
     arr.shape = list(im.size) + [3]
     arr = arr.transpose(2, 0, 1)
     arr = np.ascontiguousarray(arr, dtype=np.float32)

     width, height = im.size
     cdef leargist.color_image_t* _c_color_image_t = leargist.color_image_new(width, height)
     cdef int i = _c_color_image_t.width 

     _c_color_image_t.c1 = <float*>np.PyArray_DATA(arr[0])
     _c_color_image_t.c2 = <float*>np.PyArray_DATA(arr[1])
     _c_color_image_t.c3 = <float*>np.PyArray_DATA(arr[2])

     cdef int nb = nblocks
     cdef int s = scales
     cdef int* no = <int*>np.PyArray_DATA(orientations)
     cdef float* gist = leargist.color_gist_scaletab(_c_color_image_t, nb, s, no)
         
     cdef np.npy_intp dim = <np.npy_intp> nblocks * nblocks * orientations.sum() * 3
     cdef np.ndarray g = np.PyArray_SimpleNewFromData(1, &dim, np.NPY_FLOAT, <void *> gist)
     return g 

