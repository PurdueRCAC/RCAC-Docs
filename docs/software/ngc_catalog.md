---
hide:
  - footer
search:
  exclude: true
---

# NVIDIA NGC Containers

## What is NGC?

![NGC=](/files/knowledge/software/nvidia_logo.png)

Nvidia GPU cloud (NGC) is a GPU-accelerated cloud platform optimized for deep learning and scientific computing. NGC offers a comprehensive catalogue of GPU-accelerated containers, so the application runs quickly and reliably on the high performance computing environment. NGC was deployed to extend the cluster capabilities and to enable powerful software and deliver the fastest results. By utilizing Singularity and NGC, users can focus on building lean models, producing optimal solutions and gathering faster insights. For more information, please visit  [https://www.nvidia.com/en-us/gpu-cloud](https://www.nvidia.com/en-us/gpu-cloud/) and [NGC software catalog](https://ngc.nvidia.com/catalog/).

## Getting Started

Users can download containers from the  [NGC software catalog](https://ngc.nvidia.com/catalog)  and run them directly using Singularity instructions from the corresponding container’s catalog page.

In addition, a subset of pre-downloaded NGC containers wrapped into convenient software modules are provided. These modules wrap underlying complexity and provide the same commands that are expected from non-containerized versions of each application.

On clusters equipped with NVIDIA GPUs (Anvil, Gilbreth, Gautschi, Scholar), type the command below to see the lists of NGC containers we deployed.

```bash
$ module load ngc 
$ module avail
# Example output
----------- NVIDIA GPU Cloud (NGC) container modules -----------
autodock/2020.06                 
julia/v2.4.2                      
nvhpc/21.5                     
quantum_espresso/v7.1           
tensorflow/20.06-tf2-py3
cp2k/2023.1               (D)    
lammps/10Feb2021
[....]
```

## Available NGC Containers on RCAC Clusters

