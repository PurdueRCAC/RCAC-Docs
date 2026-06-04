# namd

[Back to NGC containers](../ngc_catalog.md)

## Description

NAMD is a parallel molecular dynamics code designed for high-performance simulation of large biomolecular systems. NAMD uses the popular molecular graphics program VMD for simulation setup and trajectory analysis, but is also file-compatible with AMBER, CHARMM, and X-PLOR.

## NGC Catalog

[https://ngc.nvidia.com/catalog/containers/hpc:namd](https://ngc.nvidia.com/catalog/containers/hpc:namd)

## Available Versions on RCAC Clusters

|Cluster|Versions|
|---|---|
**ANVIL**|3.0-alpha3-singlenode (D), 3.0.1
**GAUTSCHI**|3.0-beta5
**GILBRETH**|2.13-multinode, 2.13-singlenode (D), 3.0-alpha3-singlenode
**SCHOLAR**|2.13-multinode, 2.13-singlenode (D), 3.0-alpha3-singlenode

(D): Default Module

## Module

You can load the container module by:

```bash
module load ngc
module load namd
```

!!! note "Note for using `namd`"
    Run `module spider namd` beforehand to check available versions and any prerequisite modules.
