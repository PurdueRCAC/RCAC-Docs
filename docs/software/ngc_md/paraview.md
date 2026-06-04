# paraview

[Back to NGC containers](../ngc_catalog.md)

## Description

ParaView is an open-source, multi-platform data analysis and visualization application. This ParaView container is enabled with the NVIDIA IndeX plugin and the OptiX ray-tracing backend.  It can be used in tandem with an official ParaView " .. ver .. " client or standalone as ParaView Web.  Note: no ParaView client GUI in this container, but ParaView Web application is included.

## NGC Catalog

[https://ngc.nvidia.com/catalog/containers/nvidia-hpcvis:paraview](https://ngc.nvidia.com/catalog/containers/nvidia-hpcvis:paraview)

## Available Versions on RCAC Clusters

|Cluster|Versions|
|---|---|
**GILBRETH**|5.9.0, 5.11.0
**SCHOLAR**|5.9.0

## Module

You can load the container module by:

```bash
module load ngc
module load paraview
```

!!! note "Note for using `paraview`"
    Run `module spider paraview` beforehand to check available versions and any prerequisite modules.
