# rapidsai

[Back to NGC containers](../ngc_catalog.md)

## Description

The RAPIDS suite of software libraries gives you the freedom to execute end-to-end data science and analytics pipelines entirely on GPUs. It relies on NVIDIA® CUDA® primitives for low-level compute optimization, but exposes that GPU parallelism and high-bandwidth memory speed through user-friendly Python interfaces.

## NGC Catalog

[https://ngc.nvidia.com/catalog/containers/nvidia/rapidsai:rapidsai](https://ngc.nvidia.com/catalog/containers/nvidia/rapidsai:rapidsai)

## Available Versions on RCAC Clusters

|Cluster|Versions|
|---|---|
**ANVIL**|21.06, 21.10
**GILBRETH**|0.12, 0.13, 0.14, 0.15, 0.16, 0.17, 21.06, 21.10, 23.06
**SCHOLAR**|0.12, 0.13, 0.14, 0.15, 0.16, 0.17, 21.06, 21.10

## Module

You can load the container module by:

```bash
module load ngc
module load rapidsai
```

!!! note "Note for using `rapidsai`"
    Run `module spider rapidsai` beforehand to check available versions and any prerequisite modules.
