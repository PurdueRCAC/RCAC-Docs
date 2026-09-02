---
title: NVIDIA Nsight Tools on RCAC Clusters
tags:
  - Profilers
  - NVIDIA
  - GPU
search:
  boost: 2
---

# NVIDIA Nsight Tools on RCAC Clusters

## Tools installed along with CUDA on RCAC clusters

NVIDIA Nsight tools are installed along with CUDA on the clusters. Below is a list of the tools that can be found on the clusters. Some of these tools have both command-line interface (CLI) and graphical user interface (GUI) versions; for example, `nsys` has a corresponding GUI version called `nsys-ui`.

| Tool in `bin/` | Corresponding NVIDIA Profiling Tool | Purpose |
| --- | --- | --- |
| `nsys` | **Nsight Systems (CLI)** | System-wide performance profiling for CPUs & GPUs |
| `nsys-ui` | **Nsight Systems (GUI)** | Graphical user interface for Nsight Systems |
| `ncu` | **Nsight Compute (CLI)** | Kernel-level CUDA performance profiling |
| `ncu-ui` | **Nsight Compute (GUI)** | Graphical user interface for Nsight Compute |
| `nvprof` | **Deprecated CUDA Profiler** | Legacy CUDA profiling tool (replaced by Nsight Compute & Nsight Systems) |
| `nvvp` | **Nsight Visual Profiler (deprecated)** | GUI tool for visualizing `nvprof` results |
| `compute-sanitizer` | **Compute Sanitizer** | Memory and correctness checks for CUDA applications |
| `cuda-gdb` | **CUDA-GDB** | Debugging CUDA applications using GDB |
| `cuda-gdbserver` | **CUDA-GDB Server** | Remote CUDA debugging |
| `nsight-sys` | Not recommended, use `nsys` or `nsys-ui` | (Alias for `nsys`, use CLI or GUI version instead) |

## Versions Available on RCAC Clusters

| Cluster | CUDA | Nsight Systems (`nsys`) | Nsight Compute (`ncu`) | Compute Sanitizer (`compute-sanitizer`) | nvprof (`nvprof`) | CUDA GDB (`cuda-gdb`) |
| --- | --- | --- | --- | --- | --- | --- |
| Gautschi | 12.6.0 | 2024.4.2 | 2024.3.0 | 2024.3.0 | 12.6.37 | 12.6 (Based on GDB 13.2) |
| Anvil | 12.0.1 | 2022.4.2 | 2022.4.1 | 2022.4.1 | 12.0.147 | 12.0 (Based on GDB 12.1) |
| Anvil | 11.4.2 | 2021.3.2 | 2021.2.2 | 2021.2.1 | 11.4.120 | 11.4 (Based on GDB 10.1) |
| Anvil | 11.2.2 | 2020.4.3 | 2020.3.1 | 2020.3.1 | 11.2.152 | 11.2 (Based on GDB 8.3.1) |
| Anvil | 11.0.3 | 2020.3.2 | 2020.1.2 | 2020.1.2 | 11.0.221 | 11.0 (Based on GDB 8.2) |
| Gilbreth | 12.6.0 | 2024.4.2 | 2024.3.0 | 2024.3.0 | 12.6.37 | 12.6 (Based on GDB 13.2) |
| Gilbreth | 12.1.1 | 2023.1.2 | 2023.1.1 | 2023.1.1 | 12.1.105 | 12.1 (Based on GDB 12.1) |
| Scholar | 12.1.0 | 2024.4.2 | 2024.3.0 | 2024.3.0 | 12.6.37 | 12.6 (Based on GDB 13.2) |

## Where to Find Nsight Tools

When you load a CUDA module, the NVIDIA Nsight tools path will be set depending on the CUDA module you are loading. After loading the CUDA module, you can find the corresponding Nsight tools using commands like `which nsys`. For example, here is the path on Gautschi:

```bash
$ ml spider cuda
----------------------------------------------------------------------------
  cuda: cuda/12.6.0
----------------------------------------------------------------------------
     Other possible modules matches:
        cuda-quantum

    This module can be loaded directly: module load cuda/12.6.0
----------------------------------------------------------------------------
  To find other possible module matches execute:
      $ module -r spider '.*cuda.*'

$ ml cuda/12.6.0
$ which nsys
/apps/gautschi/cuda/12.6/bin/nsys
```

[Back to Profilers Overview](index.md)
