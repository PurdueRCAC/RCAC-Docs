---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

# Compiling Serial Programs

A serial program is a single process which executes as a sequential stream of instructions on one processor core. Compilers capable of serial programming are available for C, C++, and versions of Fortran.

Here are a few sample serial programs:

* [serial\_hello.f](/files/knowledge/compile/src/serial_hello.f)
* [serial\_hello.f90](/files/knowledge/compile/src/serial_hello.f90)
* [serial\_hello.f95](/files/knowledge/compile/src/serial_hello.f95)
* [serial\_hello.c](/files/knowledge/compile/src/serial_hello.c)
* [serial\_hello.cpp](/files/knowledge/compile/src/serial_hello.cpp)

  To load a compiler, enter one of the following:

```

$ module load intel
$ module load gcc
```

The following table illustrates how to compile your serial program:

| Language | Intel Compiler | GNU Compiler |
| --- | --- | --- |
| Fortran 77 | ``` 
 $ {::if resource.name == Gautschi}ifx {::else}ifort{::/} myprogram.f -o myprogram ``` | ``` 
 $ gfortran myprogram.f -o myprogram ``` |  |
| Fortran 90 | ``` 
 $ {::if resource.name == Gautschi}ifx {::else}ifort{::/} myprogram.f90 -o myprogram ``` | ``` 
 $ gfortran myprogram.f90 -o myprogram ``` |  |
| Fortran 95 | ``` 
 $ {::if resource.name == Gautschi}ifx {::else}ifort{::/} myprogram.f90 -o myprogram ``` | ``` 
 $ gfortran myprogram.f95 -o myprogram ``` |  |
| C | ``` 
 $ {::if resource.name == Gautschi}icx {::else}icc{::/} myprogram.c -o myprogram ``` | ``` 
 $ gcc myprogram.c -o myprogram ``` |
| C++ | ``` 
 $ {::if resource.name == Gautschi}icpx {::else}icc{::/} myprogram.cpp -o myprogram ``` | ``` 
 $ g++ myprogram.cpp -o myprogram ``` |

The Intel and GNU compilers will not output anything for a successful compilation. Also, the Intel compiler does not recognize the suffix ".f95".