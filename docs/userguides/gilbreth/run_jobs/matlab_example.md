---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

# Matlab

*MATLAB®* (MATrix LABoratory) is a high-level language and interactive environment for numerical computation, visualization, and programming. MATLAB is a product of [MathWorks](http://www.mathworks.com/).

MATLAB, Simulink, Compiler, and several of the optional toolboxes are available to faculty, staff, and students. To see the kind and quantity of all MATLAB licenses plus the number that you are currently using you can use the `matlab_licenses` command:

```bash
$ module load matlab
$ matlab_licenses
```

The MATLAB client can be run in the front-end for application development, however, computationally intensive jobs must be run on compute nodes.

The following sections provide several examples illustrating how to submit MATLAB jobs to a Linux compute cluster.

* [**Matlab Script (`.m` File)**](./matlab/interpreter.md)
* [**Implicit Parallelism**](./matlab/implicit_parallelism.md)
* [**Profile Manager**](./matlab/profile_manager.md)
* [**Parallel Computing Toolbox (parfor)**](./matlab/parfor.md)
* [**Parallel Toolbox (spmd)**](./matlab/spmd.md)
* [**Distributed Computing Server (parallel job)**](./matlab/mdcs_parallel.md)

[**Back to the Running Jobs section**](index.md)