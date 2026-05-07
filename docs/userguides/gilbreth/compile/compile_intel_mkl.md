---
tags:
  - Gilbreth
authors:
  - jin456
  - verburgt
resource: Gilbreth
search:
  boost: 2
---

# Intel MKL Library

Intel Math Kernel Library (MKL) contains ScaLAPACK, LAPACK, Sparse Solver, BLAS, Sparse BLAS, CBLAS, GMP, FFTs, DFTs, VSL, VML, and Interval Arithmetic routines. MKL resides in the directory stored in the environment variable `MKL_HOME`, after loading a version of the Intel compiler with `module`.

By using `module load` to load an Intel compiler your environment will have several variables set up to help link applications with MKL. Here are some example combinations of simplified linking options:

```bash
$ module load intel
$ echo $LINK_LAPACK
-L${MKL_HOME}/lib/intel64 -lmkl_intel_lp64 -lmkl_intel_thread -lmkl_core -liomp5 -lpthread

$ echo $LINK_LAPACK95
-L${MKL_HOME}/lib/intel64 -lmkl_lapack95_lp64 -lmkl_blas95_lp64 -lmkl_intel_lp64 -lmkl_intel_thread -lmkl_core -liomp5 -lpthread
```

RCAC recommends you use the provided variables to define MKL linking options in your compiling procedures. The Intel compiler modules also provide two other environment variables, `LINK_LAPACK_STATIC` and `LINK_LAPACK95_STATIC` that you may use if you need to link MKL statically.

RCAC recommends that you use dynamic linking of libguide. If so, define `LD_LIBRARY_PATH` such that you are using the correct version of libguide at run time. If you use static linking of libguide, then:

* If you use the Intel compilers, link in the libguide version that comes with the compiler (use the `-openmp` option).
* If you do not use the Intel compilers, link in the libguide version that comes with the Intel MKL above.

Here are some more documentation from other sources on the Intel MKL:

* [Intel MKL Documentation](http://software.intel.com/en-us/articles/intel-math-kernel-library-documentation)