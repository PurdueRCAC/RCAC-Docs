# ROCm Containers Collection

What is ROCm Containers?
------------------------

The AMD Infinity Hub contains a collection of advanced AMD GPU software containers and deployment guides for HPC, AI & Machine Learning applications, enabling researchers to speed up their time to science. Containerized applications run quickly and reliably in the high performance computing environment with full support of AMD GPUs. A collection of Infinity Hub tools were deployed to extend cluster capabilities and to enable powerful software and deliver the fastest results. By utilizing Singularity and Infinity Hub ROCm-enabled containers, users can focus on building lean models, producing optimal solutions and gathering faster insights. For more information, please visit [AMD Infinity Hub](https://web.archive.org/web/20230902021513/https://www.amd.com/en/technologies/infinity-hub/).

### Getting Started

Users can download ROCm containers from the [AMD Infinity Hub](https://web.archive.org/web/20230902021513/https://www.amd.com/en/technologies/infinity-hub/) and run them directly using Singularity instructions from the corresponding container’s catalog page.

In addition, a subset of pre-downloaded ROCm containers wrapped into convenient software modules are provided. These modules wrap underlying complexity and provide the same commands that are expected from non-containerized versions of each application.

On Bell, type the command below to see the lists of ROCm containers we deployed.

```

module load rocmcontainers
module avail

------------ ROCm-based application container modules for AMD GPUs -------------
   cp2k/20210311--h87ec1599
   deepspeed/rocm4.2_ubuntu18.04_py3.6_pytorch_1.8.1
   gromacs/2020.3                                    (D)
   namd/2.15a2
   openmm/7.4.2
   pytorch/1.8.1-rocm4.2-ubuntu18.04-py3.6
   pytorch/1.9.0-rocm4.2-ubuntu18.04-py3.6           (D)
   specfem3d/20201122--h9c0626d1
   specfem3d_globe/20210322--h1ee10977
   tensorflow/2.5-rocm4.2-dev
[....]
```

Some of these modules use the container build-in MPI libraries (you may get some error messages like "Cannot load module because these module(s) are loaded: openmpi") and may require `module unload openmpi`.

### Examples of running ROCm-based containers on AMD GPUs

Examples below show how to run some containerized applications using `rocmcontainers` modules. In all cases, the general workflow follows the same pattern (load the `rocmcontainers` module; load specific application's module; run the application as if it was built natively). Additional information can be found in `module help` output and on each application's [AMD Infinity Hub](https://web.archive.org/web/20230902021513/https://www.amd.com/en/technologies/infinity-hub/) page.

## In This Section

- [GROMACS](rocmcontainers/gromacs.md)
- [Tensorflow](rocmcontainers/tensorflow.md)
