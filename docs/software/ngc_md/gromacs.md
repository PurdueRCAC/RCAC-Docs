# gromacs

[Back to NGC containers](../ngc_catalog.md)

## Description

GROMACS is a molecular dynamics application designed to simulate Newtonian equations of motion for systems with hundreds to millions of particles. GROMACS is designed to simulate biochemical molecules like proteins, lipids, and nucleic acids that have a lot of complicated bonded interactions. More info on GROMACS can be found at http://www.gromacs.org/

## NGC Catalog

[https://ngc.nvidia.com/catalog/containers/hpc:gromacs](https://ngc.nvidia.com/catalog/containers/hpc:gromacs)

## Available Versions on RCAC Clusters

|Cluster|Versions|
|---|---|
**ANVIL**|2020.2, 2021, 2021.3

## Module

You can load the container module by:

```bash
module load ngc
module load gromacs
```

!!! note "Note for using `gromacs`"
    Run `module spider gromacs` beforehand to check available versions and any prerequisite modules.
