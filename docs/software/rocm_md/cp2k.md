# cp2k

[Back to ROCm containers](../rocm_catalog.md)

## Description

CP2K is a quantum chemistry and solid state physics software package that can perform atomistic simulations of solid state, liquid, molecular, periodic, material, crystal, and biological systems. CP2K provides a general framework for different modeling methods such as DFT using the mixed Gaussian and plane waves approaches GPW and GAPW. Supported theory levels include DFTB, LDA, GGA, MP2, RPA, semi-empirical methods (AM1, PM3, PM6, RM1, MNDO, ...), and classical force fields (AMBER, CHARMM, ...).  CP2K can do simulations of molecular dynamics, metadynamics, Monte Carlo, Ehrenfest dynamics, vibrational analysis, core level spectroscopy, energy minimization, and transition state optimization using NEB or dimer method.  CP2K is written in Fortran 2008 and can be run efficiently in parallel using a combination of multi-threading, MPI, and HIP/CUDA.

## Homepage

[  http://www.cp2k.org/](  http://www.cp2k.org/)

## Available Versions on RCAC Clusters

|Cluster|Versions|
|---|---|
**BELL**|8.2, 2022.2, 20210311--h87ec1599
**NEGISHI**|8.2, 20210311--h87ec1599

## Module

You can load the container module by:

```bash
module load rocmcontainers
module load cp2k
```
