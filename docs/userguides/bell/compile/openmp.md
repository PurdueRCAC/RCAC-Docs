---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Compiling OpenMP Programs

All compilers installed on Brown include OpenMP functionality for C, C++, and Fortran. An OpenMP program is a single process that takes advantage of a multi-core processor and its shared memory to achieve a form of parallel computing called multithreading. It distributes the work of a process over processor cores in a single compute node without the need for MPI communications.

OpenMP programs require including a header file:

| Language | Header Files |
| --- | --- |
| Fortran 77 | ``` 
 INCLUDE 'omp_lib.h' ``` |
| Fortran 90 | ``` 
 use omp_lib ``` |
| Fortran 95 | ``` 
 use omp_lib ``` |
| C | ``` 
 #include <omp.h> ``` |
| C++ | ``` 
 #include <omp.h> ``` |

Sample programs illustrate task parallelism of OpenMP:

* [omp\_hello.f](/files/knowledge/compile/src/omp_hello.f)
* [omp\_hello.f90](/files/knowledge/compile/src/omp_hello.f90)
* [omp\_hello.f95](/files/knowledge/compile/src/omp_hello.f95)
* [omp\_hello.c](/files/knowledge/compile/src/omp_hello.c)
* [omp\_hello.cpp](/files/knowledge/compile/src/omp_hello.cpp)

A sample program illustrates loop-level (data) parallelism of OpenMP:

* [omp\_loop.c](/files/knowledge/compile/src/omp_loop.c)

To load a compiler, enter one of the following:

```

$ module load intel
$ module load gcc
```

The following table illustrates how to compile your shared-memory program. Any compiler flags accepted by ifort/icc compilers are compatible with OpenMP.

| Language | Intel Compiler | GNU Compiler |
| --- | --- | --- |
| Fortran 77 | ``` 
 $ ifx -qopenmp myprogram.f -o myprogram ``` | ``` 
 $ gfortran -fopenmp myprogram.f -o myprogram ``` |
| Fortran 90 | ``` 
 $ ifx -qopenmp myprogram.f90 -o myprogram ``` | ``` 
 $ gfortran -fopenmp myprogram.f90 -o myprogram ``` |
| Fortran 95 | ``` 
 $ ifx -qopenmp myprogram.f90 -o myprogram ``` | ``` 
 $ gfortran -fopenmp myprogram.f95 -o myprogram ``` |
| C | ``` 
 $ icx -qopenmp myprogram.c -o myprogram ``` | ``` 
 $ gcc -fopenmp myprogram.c -o myprogram ``` |
| C++ | ``` 
 $ icpx -qopenmp myprogram.cpp -o myprogram ``` | ``` 
 $ g++ -fopenmp myprogram.cpp -o myprogram ``` |

The Intel and GNU compilers will not output anything for a successful compilation. Also, the Intel compiler does not recognize the suffix ".f95".

Here is some more documentation from other sources on OpenMP:

* [OpenMP Home](http://www.openmp.org/)
* [Community of OpenMP Users](http://www.compunity.org/)
* [Intel OpenMP](http://software.intel.com/en-us/articles/getting-started-with-openmp/)
* [GCC OpenMP](http://gcc.gnu.org/wiki/openmp)