# relion

[Back to NGC containers](../ngc_catalog.md)

## Description

RELION (for REgularized LIkelihood OptimizatioN) implements an empirical Bayesian approach for analysis of electron cryo-microscopy (Cryo-EM). Specifically it provides methods of refinement of singular or multiple 3D reconstructions as well as 2D class averages. RELION is an important tool in the study of living cells.

## NGC Catalog

[https://ngc.nvidia.com/catalog/containers/hpc:relion](https://ngc.nvidia.com/catalog/containers/hpc:relion)

## Available Versions on RCAC Clusters

|Cluster|Versions|
|---|---|
**ANVIL**|3.1.0, 3.1.2, 3.1.3, 4.0.1, 5.0.0
**GAUTSCHI**|2.1.b1, 3.0.8, 3.1.0, 3.1.2, 3.1.3, 4.0.1, 5.0.0
**GILBRETH**|2.1.b1, 3.0.8, 3.1.0, 3.1.2, 3.1.3, 4.0.1, 5.0.0
**SCHOLAR**|2.1.b1, 3.0.8, 3.1.0, 3.1.2, 3.1.3, 4.0.1, 5.0.0

## Module

You can load the container module by:

```bash
module load ngc
module load relion
```

!!! note "Note for using `relion`"
    Run `module spider relion` beforehand to check available versions and any prerequisite modules.
