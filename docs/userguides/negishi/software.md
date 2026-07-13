---
tags:
  - Negishi
authors:
  - hkashgar
resource: Negishi
search:
  boost: 2
---

{% set resource = "negishi" %}

# Software on Negishi

## Software Catalog

A comprehensive list of centrally installed software applications can be found here:

[Software Catalog](../../software/app_catalog.md)

## Module system

{{ module_system(resource) }}

## Running the Apps
### Find available apps in the terminal
In addition to searching the software catalog for available applications, one can generate a list via the terminal:

``` bash
$ module avail
|---------------------- Core Applications ---------------------
   amduprof/3.4-502                hyper-shell/2.1.0                      openblas/0.3.21
   anaconda/2021.05-py38           hyper-shell/2.4.0                      openjdk/1.8.0_265-b01
   anaconda/2022.10-py39           hyper-shell/2.5.1                      openjdk/11.0.17_8
   anaconda/2024.02-py311 (D)      hyper-shell/2.5.2                      ovito/3.11.0
[MORE...]
```
### View module prequisites and license information
After finding the module that you want to load, use 'module spider' to find any prerequisites or license information, if applicable:

``` bash
$ module spider hypershell

-------------------------------------------------------------
  hypershell:
-------------------------------------------------------------
    Description:
      A cross-platform, high-throughput computing utility for processing shell commands over a
      distributed, asynchronous queue.

     Versions:
        hypershell/2.6.2
        hypershell/2.6.5
        hypershell/2.7.0

```
### Load the module
Use the command specified in the 'module spider' output to load your software module:

``` bash
module load hypershell/2.7.0
```

### Running GUI versions of apps
If the app you want to use has a GUI, you can also login to {{ resource }} via Thinlinc. More information on this process can be found [here](accounts.md#thinlinc).

## ROCm Containers

Negishi's GPU sub-cluster (Sub-cluster G) is equipped with AMD MI210 GPUs. A selection of GPU-enabled ROCm application containers from the AMD Infinity Hub collection is installed.

Users can download additional ROCm containers from the [AMD Infinity Hub](https://www.amd.com/en/technologies/infinity-hub/) and run them directly using Apptainer/Singularity. A subset of pre-downloaded ROCm containers wrapped into convenient software modules are also provided.

To see the lists of ROCm containers available as modules, use:

```bash
$ module avail rocm
```

More information on pre-downloaded ROCm containers can be found [here](./../../../software/rocm_catalog).

## BioContainers

Pre-downloaded bioinformatics containers with module wrappers are available. You can load them as standard modules:

```bash
$ module load biocontainers
```
More information on pre-downloaded Biocontainers can be found [here](https://biocontainer-doc.readthedocs.io/).

[**Back to Negishi User Guide**](index.md)
