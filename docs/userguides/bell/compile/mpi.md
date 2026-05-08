---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Compiling MPI Programs

OpenMPI and Intel MPI (IMPI) are implementations of the Message-Passing Interface (MPI) standard. Libraries for these MPI implementations and compilers for C, C++, and Fortran are available on all clusters.

MPI programs require including a header file:

| Language | Header Files |
| --- | --- |
| Fortran 77 | ``` 
 INCLUDE 'mpif.h' ``` |
| Fortran 90 | ``` 
 INCLUDE 'mpif.h' ``` |
| Fortran 95 | ``` 
 INCLUDE 'mpif.h' ``` |
| C | ``` 
 #include <mpi.h> ``` |
| C++ | ``` 
 #include <mpi.h> ``` |

Here are a few sample programs using MPI:

* [mpi\_hello.f](/files/knowledge/compile/src/mpi_hello.f)
* [mpi\_hello.f90](/files/knowledge/compile/src/mpi_hello.f90)
* [mpi\_hello.f95](/files/knowledge/compile/src/mpi_hello.f95)
* [mpi\_hello.c](/files/knowledge/compile/src/mpi_hello.c)
* [mpi\_hello.cpp](/files/knowledge/compile/src/mpi_hello.cpp)

To see the available MPI libraries:

```

$ module avail openmpi 
$ module avail impi
```

The following table illustrates how to compile your MPI program. Any compiler flags accepted by Intel ifort/icc compilers are compatible with their respective MPI compiler.

| Language | Intel MPI | OpenMPI |
| --- | --- | --- |
| Fortran 77 | ``` 
 $ mpiifort program.f -o program ``` | ``` 
 $ mpif77 program.f -o program ``` |
| Fortran 90 | ``` 
 $ mpiifort program.f90 -o program ``` | ``` 
 $ mpif90 program.f90 -o program ``` |
| Fortran 95 | ``` 
 $ mpiifort program.f95 -o program ``` | ``` 
 $ mpif90 program.f95 -o program ``` |
| C | ``` 
 $ mpiicc program.c -o program ``` | ``` 
 $ mpicc program.c -o program ``` |
| C++ | ``` 
 $ mpiicpx program.cpp -o program ``` | ``` 
 $ mpiCC program.cpp -o program ``` |

The Intel and GNU compilers will not output anything for a successful compilation. Also, the Intel compiler does not recognize the suffix ".f95".

Here is some more documentation from other sources on the MPI libraries:

* [Message Passing Interface Forum](http://www.mpi-forum.org/)
* [Open MPI Home](http://www.open-mpi.org/)
* [Open MPI Documentation](http://www.open-mpi.org/doc/)