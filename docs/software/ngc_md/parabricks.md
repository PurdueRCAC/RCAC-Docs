# parabricks

[Back to NGC containers](../ngc_catalog.md)

## Description

NVIDIA's Clara Parabricks brings next generation sequencing to GPUs, accelerating an array of gold-standard tooling such as BWA-MEM, GATK4, Google's DeepVariant, and many more. Users can achieve a 30-60x acceleration and 99.99% accuracy for variant calling when comparing against CPU-only BWA-GATK4 pipelines, meaning a single server can process up to 60 whole genomes per day. These tools can be easily integrated into current pipelines with drop-in replacement commands to quickly bring speed and data-center scale to a range of applications including germline, somatic and RNA workflows.

## NGC Catalog

[ https://catalog.ngc.nvidia.com/orgs/nvidia/teams/clara/containers/clara-parabricks]( https://catalog.ngc.nvidia.com/orgs/nvidia/teams/clara/containers/clara-parabricks)

## Available Versions on RCAC Clusters

|Cluster|Versions|
|---|---|
**ANVIL**|4.0.0-1

## Module

You can load the container module by:

```bash
module load ngc
module load parabricks
```

!!! note "Note for using `parabricks`"
    Run `module spider parabricks` beforehand to check available versions and any prerequisite modules.
