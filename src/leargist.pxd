cdef extern from "standalone_image.h":
    ctypedef struct color_image_t:    
        int width
        int height
        float *c1		# R 
        float *c2		# G
        float *c3		# B  

    cdef color_image_t* color_image_new(int width, int height)

cdef extern from "gist.h":
    cdef float* color_gist_scaletab(color_image_t* src, int nblocks, int n_scale, int* n_orientations)


