# cp2k

[Back to NGC containers](../ngc_catalog.md)

## Description

CP2K is a quantum chemistry and solid state physics software package that can perform atomistic simulations of solid state, liquid, molecular, periodic, material, crystal, and biological systems. CP2K provides a general framework for different modeling methods such as DFT using the mixed Gaussian and plane waves approaches GPW and GAPW. Supported theory levels include DFTB, LDA, GGA, MP2, RPA, semi-empirical methods (AM1, PM3, PM6, RM1, MNDO, ...), and classical force fields (AMBER, CHARMM, ...). CP2K can do simulations of molecular dynamics, metadynamics, Monte Carlo, Ehrenfest dynamics, vibrational analysis, core level spectroscopy, energy minimization, and transition state optimization using NEB or dimer method.

## NGC Catalog

[https://ngc.nvidia.com/catalog/containers/hpc:cp2k](https://ngc.nvidia.com/catalog/containers/hpc:cp2k)

## Available Versions on RCAC Clusters

|Cluster|Versions|
|---|---|
**ANVIL**|2023.1

## Module

You can load the container module by:

```bash
module load ngc
module load cp2k
```

!!! note "Note for using `cp2k`"
    Run `module spider cp2k` beforehand to check available versions and any prerequisite modules.
