# milc

[Back to NGC containers](../ngc_catalog.md)

## Description

MILC represents part of a set of codes written by the MIMD Lattice Computation (MILC) collaboration used to study quantum chromodynamics (QCD), the theory of the strong interactions of subatomic physics. It performs simulations of four dimensional SU(3) lattice gauge theory on MIMD parallel machines. \"Strong interactions\" are responsible for binding quarks into protons and neutrons and holding them all together in the atomic nucleus.

## NGC Catalog

[https://ngc.nvidia.com/catalog/containers/hpc:milc](https://ngc.nvidia.com/catalog/containers/hpc:milc)

## Available Versions on RCAC Clusters

|Cluster|Versions|
|---|---|
**GILBRETH**|quda0.8-patch4Oct2017, quda1.1.0-November2022
**SCHOLAR**|quda0.8-patch4Oct2017

## Module

You can load the container module by:

```bash
module load ngc
module load milc
```

!!! note "Note for using `milc`"
    Run `module spider milc` beforehand to check available versions and any prerequisite modules.
