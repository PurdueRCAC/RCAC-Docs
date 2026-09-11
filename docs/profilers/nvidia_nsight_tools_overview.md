---
title: NVIDIA Nsight Tools Overview
tags:
  - Profilers
  - NVIDIA
  - GPU
search:
  boost: 2
---

# NVIDIA Nsight Tools Overview

## Overview

NVIDIA Nsight tools are a powerful suite of libraries, SDKs, and developer tools designed for profiling, debugging, and optimizing software that utilizes NVIDIA's latest accelerated computing hardware. These tools support both different platforms targets which incorporate NVIDIA GPU computations, and they assist developers in CUDA development as well as visual computing applications.

Multiple NVIDIA Nsight Developer Tools are available to assist developers with debugging and profiling, with a complete list accessible [here](https://developer.nvidia.com/tools-overview). This user guide focuses on [NVIDIA Nsight Systems](https://developer.nvidia.com/nsight-systems) and [NVIDIA Nsight Compute](https://developer.nvidia.com/nsight-compute).

See the list of available Nsight tools installed on RCAC clusters [here](nvidia_nsight_tools_on_rcac_clusters.md).

## Available Tools

### [NVIDIA Nsight Systems](nvidia_nsight_systems.md)

Nsight Systems is a system-wide performance analysis tool that provides insight into CPU/GPU interactions, memory transfers, and API calls.

**Key Profiling Features**

* CPU/GPU utilization tracking
* API call monitoring
* Memory copy analysis
* System-wide performance bottlenecks detection
* Visualizing how data moves through the system
* Parallelization insights for task execution

**When to Use**

* Starting point for performance analysis
* Identifying system-wide bottlenecks
* Understanding CPU/GPU interactions
* Analyzing memory transfer patterns

### [NVIDIA Nsight Compute](https://developer.nvidia.com/nsight-compute)

An interactive kernel profiler for CUDA applications, providing detailed performance metrics and API debugging capabilities.

**Key Features**

* Detailed kernel performance metrics
* API debugging capabilities
* Low-level GPU optimization insights
* Guided performance analysis
* Line-by-line code analysis
* Customizable profiling configurations

**When to Use**

* Optimizing specific CUDA kernels
* Deep-diving into GPU performance
* Debugging CUDA code
* Fine-tuning kernel configurations

For more information, refer to the [NVIDIA Nsight Compute user guide](https://docs.nvidia.com/nsight-compute/NsightCompute/index.html).

## Additional Resources

* [NVIDIA Developer Tools Overview](https://developer.nvidia.com/tools-overview)
* [Training Materials](https://developer.nvidia.com/nsight-systems/get-started)

*Source: [NVIDIA Tools Ecosystem Session](https://www.nvidia.com/en-us/on-demand/session/other2024-toolseco/?playlistId=playList-c9450de5-2ffd-4ea9-8a1b-24aeeaf49d4e)*

[Back to Profilers Overview](index.md)
