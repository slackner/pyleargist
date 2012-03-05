from libc.stdlib cimport free
from cpython cimport PyObject, Py_INCREF

cimport leargist
import numpy as np 
cimport numpy as np

np.import_array()

cdef class ArrayWrapper:
    cdef void* data_ptr
    cdef int size

    cdef set_data(self, int size, void* data_ptr):
        """ Set the data of the array
        This cannot be done in the constructor as it must recieve C-level
        arguments.
        
        Parameters:
        -----------
        size: int
        Length of the array.
        data_ptr: void*
        Pointer to the data
        
        """
        self.data_ptr = data_ptr
        self.size = size

    def __array__(self):
        """ Here we use the __array__ method, that is called when numpy
tries to get an array from the object."""
        cdef np.npy_intp shape[1]
        shape[0] = <np.npy_intp> self.size
        # Create a 1D array, of length 'size'
        ndarray = np.PyArray_SimpleNewFromData(1, shape,
                                               np.NPY_FLOAT, self.data_ptr)
        return ndarray

    def __dealloc__(self):
        """ Frees the array. This is called by Python when all the
references to the object are gone. """
        free(<void*>self.data_ptr)

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
     cdef float* array = leargist.color_gist_scaletab(_c_color_image_t, nb, s, no)

     size  = nblocks * nblocks * orientations.sum() * 3	       
         
     array_wrapper = ArrayWrapper()
     array_wrapper.set_data(size, <void*> array)
     ndarray = np.array(array_wrapper, copy=False)
     # Assign our object to the 'base' of the ndarray object
     #ndarray.base = <PyObject*> array_wrapper
     ndarray.base =  array_wrapper
     # Increment the reference count, as the above assignement was done in
     # C, and Python does not know that there is this additional reference
     Py_INCREF(array_wrapper)
     return ndarray

