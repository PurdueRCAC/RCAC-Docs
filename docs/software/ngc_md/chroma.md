# chroma

[Back to NGC containers](../ngc_catalog.md)

## Description

The Chroma package provides a toolbox and executables to carry out calculation of lattice Quantum Chromodynamics (LQCD). It is built on top of the QDP++ (QCD Data Parallel Layer) which provides an abstract data parallel view of the lattice and provides lattice wide types and expressions, using expression templates, to allow straightforward encoding of LQCD equations.

## NGC Catalog

[https://ngc.nvidia.com/catalog/containers/hpc:chroma](https://ngc.nvidia.com/catalog/containers/hpc:chroma)

## Available Versions on RCAC Clusters

|Cluster|Versions|
|---|---|
**GILBRETH**|2018-cuda9.0-ubuntu16.04-volta-openmpi, 2020.06, 2021.04
**SCHOLAR**|2018-cuda9.0-ubuntu16.04-volta-openmpi, 2020.06, 2021.04

## Module

You can load the container module by:

```bash
module load ngc
module load chroma
```

!!! note "Note for using `chroma`"
    Run `module spider chroma` beforehand to check available versions and any prerequisite modules.
