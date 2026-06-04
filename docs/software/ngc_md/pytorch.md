# pytorch

[Back to NGC containers](../ngc_catalog.md)

## Description

PyTorch is a GPU accelerated tensor computational framework with a Python front end. Functionality can be easily extended with common Python libraries such as NumPy, SciPy, and Cython. Automatic differentiation is done with a tape-based system at both a functional and neural network layer level. This functionality brings a high level of flexibility and speed as a deep learning framework and provides accelerated NumPy-like functionality.

## NGC Catalog

[https://ngc.nvidia.com/catalog/containers/nvidia:pytorch](https://ngc.nvidia.com/catalog/containers/nvidia:pytorch)

## Available Versions on RCAC Clusters

|Cluster|Versions|
|---|---|
**ANVIL**|20.06-py3, 20.11-py3, 20.12-py3, 21.06-py3, 21.09-py3

## Module

You can load the container module by:

```bash
module load ngc
module load pytorch
```

!!! note "Note for using `pytorch`"
    Run `module spider pytorch` beforehand to check available versions and any prerequisite modules.
