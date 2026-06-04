# qmcpack

[Back to NGC containers](../ngc_catalog.md)

## Description

QMCPACK is an open-source, high-performance electronic structure code that implements numerous Quantum Monte Carlo algorithms. Its main applications are electronic structure calculations of molecular, periodic 2D and periodic 3D solid-state systems. Variational Monte Carlo (VMC), diffusion Monte Carlo (DMC) and a number of other advanced QMC algorithms are implemented. By directly solving the Schrodinger equation, QMC methods offer greater accuracy than methods such as density functional theory, but at a trade-off of much greater computational expense. Distinct from many other correlated many-body methods, QMC methods are readily applicable to both bulk (periodic) and isolated molecular systems.

## NGC Catalog

[https://ngc.nvidia.com/catalog/containers/hpc:qmcpack](https://ngc.nvidia.com/catalog/containers/hpc:qmcpack)

## Available Versions on RCAC Clusters

|Cluster|Versions|
|---|---|
**GILBRETH**|v3.5.0, v3.16.0
**SCHOLAR**|v3.5.0

## Module

You can load the container module by:

```bash
module load ngc
module load qmcpack
```

!!! note "Note for using `qmcpack`"
    Run `module spider qmcpack` beforehand to check available versions and any prerequisite modules.
