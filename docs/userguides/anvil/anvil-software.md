---
tags:
  - Anvil
authors:
  - jin456
---

# Software on Anvil

Anvil provides a number of software packages to users of the system via the `module` command. To check the list of applications installed as modules on Anvil and their user guides, please go to the [RCAC Applications](../../software/index.md) page. For some common applications such as Python, Singularity, Horovod and R, we also provide detailed instructions and examples on this user guide page.

## Module system

{% set resource = "anvil" %}

{{ module_system(resource) }}

## Compiling, performance, and optimization on Anvil

Anvil CPU nodes have GNU, Intel, and AOCC (AMD) compilers available along with multiple MPI implementations (OpenMPI, Intel MPI (IMPI) and MVAPICH2). Anvil GPU nodes also provide the PGI compiler. Users may want to note the following AMD Milan specific optimization options that can help improve the performance of your code on Anvil:

1. The majority of the applications on Anvil are built using ${resource.compiler} which features an AMD Milan specific optimization flag (`-march=znver3`).
2. AMD Milan CPUs support the Advanced Vector Extensions 2 (AVX2) vector instructions set. GNU, Intel, and AOCC compilers all have flags to support AVX2. Using AVX2, up to eight floating point operations can be executed per cycle per core, potentially doubling the performance relative to non-AVX2 processors running at the same clock speed.
3. In order to enable AVX2 support, when compiling your code, use the `-march=znver3` flag (for GCC 11.2 and newer, Clang and AOCC compilers), `-march=znver2` flag (for GCC 10.2), or `-march=core-avx2` (for Intel compilers and GCC prior to 9.3).

Other Software Usage Notes:

1. Use the same environment that you compile the code to run your executables. When switching between compilers for different applications, make sure that you load the appropriate modules before running your executables.
2. Explicitly set the optimization level in your makefiles or compilation scripts. Most well written codes can safely use the highest optimization level (`-O3`), but many compilers set lower default levels (e.g. GNU compilers use the default `-O0`, which turns off all optimizations).
3. Turn off debugging, profiling, and bounds checking when building executables intended for production runs as these can seriously impact performance. These options are all disabled by default. The flag used for bounds checking is compiler dependent, but the debugging (`-g`) and profiling (`-pg`) flags tend to be the same for all major compilers.
4. Some compiler options are the same for all available compilers on Anvil (e.g. `-o`), while others are different. Many options are available in one compiler suite but not the other. For example, Intel, PGI, and GNU compilers use the `-qopenmp`, `-mp`, and `-fopenmp` flags, respectively, for building OpenMP applications.
5. MPI compiler wrappers (e.g. mpicc, mpif90) all call the appropriate compilers and load the correct MPI libraries depending on the loaded modules. While the same names may be used for different compilers, keep in mind that these are completely independent scripts.

For Python users, Anvil provides two Python distributions: 1) a natively compiled Python module with a small subset of essential numerical libraries which are optimized for the AMD Milan architecture and 2) binaries distributed through Anaconda. Users are recommended to use virtual environments for installing and using additional Python packages.

A broad range of application modules from various science and engineering domains are installed on Anvil, including mathematics and statistical modeling tools, visualization software, computational fluid dynamics codes, molecular modeling packages, and debugging tools.

In addition, Singularity is supported on Anvil and Nvidia GPU Cloud containers are available on Anvil GPU nodes.

## Example application installation
This section provides some instructions for installing and compiling some common applications on Anvil.

- [VASP](install_software/vasp.md)
- [LAMMPS](install_software/lammps.md)