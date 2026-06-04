# tensorflow

[Back to NGC containers](../ngc_catalog.md)

## Description

TensorFlow is an open-source software library for numerical computation using data flow graphs. Nodes in the graph represent mathematical operations, while the graph edges represent the multidimensional data arrays (tensors) that flow between them. This flexible architecture lets you deploy computation to one or more CPUs or GPUs in a desktop, server, or mobile device without rewriting code.

## NGC Catalog

[https://ngc.nvidia.com/catalog/containers/nvidia:tensorflow](https://ngc.nvidia.com/catalog/containers/nvidia:tensorflow)

## Available Versions on RCAC Clusters

|Cluster|Versions|
|---|---|
**ANVIL**|20.06-tf1-py3, 20.06-tf2-py3, 20.11-tf1-py3, 20.11-tf2-py3, 20.12-tf1-py3, 20.12-tf2-py3, 21.06-tf1-py3, 21.06-tf2-py3, 21.09-tf1-py3, 21.09-tf2-py3

## Module

You can load the container module by:

```bash
module load ngc
module load tensorflow
```

!!! note "Note for using `tensorflow`"
    Run `module spider tensorflow` beforehand to check available versions and any prerequisite modules.
