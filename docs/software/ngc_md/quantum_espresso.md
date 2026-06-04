# quantum_espresso

[Back to NGC containers](../ngc_catalog.md)

## Description

Quantum ESPRESSO is an integrated suite of Open-Source computer codes for electronic-structure calculations and materials modeling at the nanoscale based on density-functional theory, plane waves, and pseudopotentials.

## NGC Catalog

[https://ngc.nvidia.com/catalog/containers/hpc:quantum_espresso](https://ngc.nvidia.com/catalog/containers/hpc:quantum_espresso)

## Available Versions on RCAC Clusters

|Cluster|Versions|
|---|---|
**ANVIL**|v6.6a1, v6.7, v7.1, v7.3.1
**GILBRETH**|qe-7.1, qe-7.3.1, v6.6a1, v6.7, v7.1
**SCHOLAR**|v6.6a1, v6.7

## Module

You can load the container module by:

```bash
module load ngc
module load quantum_espresso
```

!!! note "Note for using `quantum_espresso`"
    Run `module spider quantum_espresso` beforehand to check available versions and any prerequisite modules.
