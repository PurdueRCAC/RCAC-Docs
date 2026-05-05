---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

# Compiling Hybrid Programs

A hybrid program combines both MPI and shared-memory to take advantage of compute clusters with multi-core compute nodes. Libraries for OpenMPI and Intel MPI (IMPI) and compilers which include OpenMP for C, C++, and Fortran are available.

Hybrid programs require including header files:

| Language | Header Files |
| --- | --- |
| Fortran 77 | ``` 
 INCLUDE 'omp_lib.h'
 INCLUDE 'mpif.h'
 ``` |
| Fortran 90 | ``` 
 use omp_lib
 INCLUDE 'mpif.h'
 ``` |
| Fortran 95 | ``` 
 use omp_lib
 INCLUDE 'mpif.h'
 ``` |
| C | ``` 
 #include <mpi.h>
 #include <omp.h>
 ``` |
| C++ | ``` 
 #include <mpi.h>
 #include <omp.h>
 ``` |

A few examples illustrate hybrid programs with task parallelism of OpenMP:

* [hybrid\_hello.f](/files/knowledge/compile/src/hybrid_hello.f)
* [hybrid\_hello.f90](/files/knowledge/compile/src/hybrid_hello.f90)
* [hybrid\_hello.f95](/files/knowledge/compile/src/hybrid_hello.f95)
* [hybrid\_hello.c](/files/knowledge/compile/src/hybrid_hello.c)
* [hybrid\_hello.cpp](/files/knowledge/compile/src/hybrid_hello.cpp)

This example illustrates a hybrid program with loop-level (data) parallelism of OpenMP:

* [hybrid\_loop.c](/files/knowledge/compile/src/hybrid_loop.c)

To see the available MPI libraries:

```

$ module avail impi
$ module avail openmpi
```

The following tables illustrate how to compile your hybrid (MPI/OpenMP) program. Any compiler flags accepted by Intel ifort/icc compilers are compatible with their respective MPI compiler.

Intel MPI (IMPI) with Intel Compiler

| Language | Command |
| --- | --- |
| Fortran 77 | ``` 
 $ mpiifort -qopenmp myprogram.f -o myprogram ``` |
| Fortran 90 | ``` 
 $ mpiifort -openmp myprogram.f90 -o myprogram ``` |
| Fortran 95 | ``` 
 $ mpiifort -openmp myprogram.f90 -o myprogram ``` |
| C | ``` 
 $ mpiicc -qopenmp myprogram.c -o myprogram ``` |
| C++ | ``` 
 $ mpiicpc -qopenmp myprogram.cpp -o myprogram ``` |

OpenMPI with GNU Compiler

| Language | Command |
| --- | --- |
| Fortran 77 | ``` 
 $ mpif77 -fopenmp myprogram.f -o myprogram ``` |
| Fortran 90 | ``` 
 $ mpif90 -fopenmp myprogram.f90 -o myprogram ``` |
| Fortran 95 | ``` 
 $ mpif90 -fopenmp myprogram.f95 -o myprogram ``` |
| C | ``` 
 $ mpicc -fopenmp myprogram.c -o myprogram ``` |
| C++ | ``` 
 $ mpiCC -fopenmp myprogram.cpp -o myprogram ``` |

The Intel and GNU compilers will not output anything for a successful compilation. Also, the Intel compiler does not recognize the suffix `.f95`.