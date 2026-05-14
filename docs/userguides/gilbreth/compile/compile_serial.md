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

- [serial_hello.f](../../../assets/scripts/userguides/gilbreth/compile/src/serial_hello.f)
- [serial_hello.f90](../../../assets/scripts/userguides/gilbreth/compile/src/serial_hello.f90)
- [serial_hello.f95](../../../assets/scripts/userguides/gilbreth/compile/src/serial_hello.f95)
- [serial_hello.c](../../../assets/scripts/userguides/gilbreth/compile/src/serial_hello.c)
- [serial_hello.cpp](../../../assets/scripts/userguides/gilbreth/compile/src/serial_hello.cpp)

To load a compiler, enter one of the following:

```bash
$ module load intel
$ module load gcc
```

**The following table illustrates how to compile your serial program:**

| Language | Intel Compiler | GNU Compiler |
| -------- | -------- | -------- |
| Fortran 77 | ```$ ifx  myprogram.f -o myprogram``` | ```$ gfortran myprogram.f -o myprogram``` |
| Fortran 90 | ```$ ifx  myprogram.f90 -o myprogram``` | ```$ gfortran myprogram.f90 -o myprogram``` |
| Fortran 95 | ```$ ifx  myprogram.f90 -o myprogram``` | ```$ gfortran myprogram.f95 -o myprogram``` |
| C | ```$ icx  myprogram.c -o myprogram``` | ```$ gcc myprogram.c -o myprogram``` |
| C++ | ```$ icpx  myprogram.cpp -o myprogram``` | ```$ g++ myprogram.cpp -o myprogram``` |

The Intel and GNU compilers will not output anything for a successful compilation. Also, the Intel compiler does not recognize the suffix ```.f95```.

[**Back to the Compiling Programs section**](../compile.md)