---
hide:
  - footer
search:
  exclude: true
---

# AMD ROCm containers

![NGC=](/files/knowledge/software/amd_logo.png)

## What is AMD ROCm

The AMD Infinity Hub contains a collection of advanced AMD GPU software containers and deployment guides for HPC, AI & Machine Learning applications, enabling researchers to speed up their time to science. Containerized applications run quickly and reliably in the high performance computing environment with full support of AMD GPUs. A collection of Infinity Hub tools were deployed to extend cluster capabilities and to enable powerful software and deliver the fastest results. By utilizing Singularity and Infinity Hub ROCm-enabled containers, users can focus on building lean models, producing optimal solutions and gathering faster insights. For more information, please visit [AMD Infinity Hub](https://web.archive.org/web/20230902021513/https://www.amd.com/en/technologies/infinity-hub/).

## Getting Started

Users can download ROCm containers from the [AMD Infinity Hub](https://web.archive.org/web/20230902021513/https://www.amd.com/en/technologies/infinity-hub/) and run them directly using Singularity instructions from the corresponding container’s catalog page.

In addition, a subset of pre-downloaded ROCm containers wrapped into convenient software modules are provided. These modules wrap underlying complexity and provide the same commands that are expected from non-containerized versions of each application.

On clusters equipped with AMD GPUs, type the command below to see the lists of ROCm containers we deployed.

```bash
$ module load rocmcontainers
$ module avail
# Example output
------------ ROCm-based application container modules for AMD GPUs -------------
    cp2k/20210311--h87ec1599
    deepspeed/rocm4.2_ubuntu18.04_py3.6_pytorch_1.8.1
    gromacs/2020.3  (D)
    namd/2.15a2
[....]
```

## Available ROCm Containers on RCAC Clusters
