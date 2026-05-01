---
tags:
  - Gautschi
authors:
  - jin456
resource: Gautschi
search:
  boost: 2
---

# Compiling Hybrid Programs

Hybrid programs require including header files:

| Language | Header Files |
| -------- | -------- |
| Fortran 77 | ```INCLUDE 'omp_lib.h'``` <br> ```INCLUDE 'mpif.h'```|
| Fortran 90 | ```use omp_lib``` <br> ```INCLUDE 'mpif.h'``` |
| Fortran 95 | ```use omp_lib``` <br> ```INCLUDE 'mpif.h'``` |
| C | ```#include <mpi.h>``` <br> ```#include <omp.h>``` |
| C++ | ```#include <mpi.h>``` <br> ```#include <omp.h>``` |

A few examples illustrate hybrid programs with task parallelism of OpenMP:

- [hybrid_hello.f](src/hybrid_hello_f.md)
- [hybrid_hello.f90](src/hybrid_hello_f90.md)
- [hybrid_hello.f95](src/hybrid_hello_f95.md)
- [hybrid_hello.c](src/hybrid_hello_c.md)
- [hybrid_hello.cpp](src/hybrid_hello_cpp.md)

This example illustrates a hybrid program with loop-level (data) parallelism of OpenMP:

- [hybrid_loop.c](src/hybrid_loop_c.md)

To see the available MPI libraries:

```bash
$ module avail impi
$ module avail openmpi
```

The following tables illustrate how to compile your hybrid (MPI/OpenMP) program. Any compiler flags accepted by Intel ifort/icc compilers are compatible with their respective MPI compiler.

**Intel MPI (IMPI) with Intel Compiler**

| Language | Command |
| -------- | -------- |
| Fortran 77 | ```$ mpiifort -qopenmp myprogram.f -o myprogram``` |
| Fortran 90 | ```$ mpiifort -openmp myprogram.f90 -o myprogram``` |
| Fortran 95 | ```$ mpiifort -openmp myprogram.f90 -o myprogram``` |
| C | ```$ mpiicc -qopenmp myprogram.c -o myprogram``` |
| C++ | ```$ mpiicpc -qopenmp myprogram.cpp -o myprogram``` |

**OpenMPI with GNU Compiler**

| Language | Command |
| -------- | -------- |
| Fortran 77 | ```$ mpif77 -fopenmp myprogram.f -o myprogram``` |
| Fortran 90 | ```$ mpif90 -fopenmp myprogram.f90 -o myprogram``` |
| Fortran 95 | ```$ mpif90 -fopenmp myprogram.f95 -o myprogram``` |
| C | ```$ mpicc -fopenmp myprogram.c -o myprogram``` |
| C++ | ```$ mpiCC -fopenmp myprogram.cpp -o myprogram``` |

The Intel and GNU compilers will not output anything for a successful compilation. Also, the Intel compiler does not recognize the suffix ```.f95```.

[Back to the Compiling Programs section](../compile.md)
