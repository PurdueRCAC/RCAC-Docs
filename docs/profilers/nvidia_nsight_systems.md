---
title: NVIDIA Nsight Systems
tags:
  - Profilers
  - NVIDIA
  - GPU
search:
  boost: 2
---

# NVIDIA Nsight Systems

## Overview

NVIDIA Nsight Systems is a powerful tool that enables tracing of any NVIDIA GPU-accelerated application. It generates a holistic, easy-to-understand, and visually pleasing timeline view of system metrics, including all available hardware resources and active processes. This helps developers find performance issues and identify optimization opportunities. Beyond performance investigations, Nsight Systems is an ideal debugging tool for asynchronous GPU computing. Nsight Systems is available as both a CLI and GUI application, useful to different user needs.

### Quick Start Guide

1. **Installation**: Load the CUDA module on your system:

    ```bash
    ml cuda/12.6
    ```

2. **Basic Profiling**: Profile your application using the CLI:

    ```bash
    nsys profile -o output_name ./your_application
    ```

3. **View Results**: Either use the CLI to view stats:

    ```bash
    nsys stats output_name.nsys-rep
    ```

    Or launch the GUI for visual analysis:

    ```bash
    nsys-ui
    ```

For more detailed instructions, see the sections below.

## Supported Platforms

Nsight Systems supports profiling on various platforms and can be used both locally—to profile code running on your machine—and remotely by connecting to targets over SSH or Bluetooth. For more details on which hosts can profile which targets, visit [NVIDIA's website](https://developer.nvidia.com/nsight-systems/get-started) for additional information.

## Installation

* If you have an NVIDIA GPU on your local system, you can install Nsight Systems by visiting [this link](https://developer.nvidia.com/nsight-systems/get-started). With your local installation, you can collect profiling data from GPU-accelerated applications running on your system or connect to other devices via Bluetooth (for devices like Jetson) or SSH to profile code on remote computers.
* On **RCAC clusters** with NVIDIA GPUs (Gautschi, Gilbreth, Anvil, and Scholar), Nsight Systems is typically installed alongside CUDA in the same binary directory. Loading the CUDA module will automatically set the paths for both the CLI tool (`nsys`) and the UI tool (`nsys-ui`) in your environment.

For example, on Gilbreth:

```bash
$ ml cuda/12.6
$ which nsys
/apps/spack/gilbreth-r9/apps/cuda/12.6.0-gcc-11.5.0-a7cv7sp/bin/nsys
```

In some cases, the tool may also exist separately within the CUDA directory. For example, we have another installation of Nsight Systems in the CUDA directory:

```bash
$ pwd
/apps/spack/gilbreth-r9/apps/cuda/12.6.0-gcc-11.5.0-a7cv7sp
$ ls
bin                gds       nsight-compute-2024.3.0  pkgconfig  tools
compute-sanitizer  gds-12.6  nsightee_plugins         README     version.json
DOCS               include   nsight-systems-2024.4.2  share
EULA.txt           lib64     nvml                     src
extras             libnvvp   nvvm                     targets
$ ls ./nsight-systems-2024.4.2/bin/nsys-ui
./nsight-systems-2024.4.2/bin/nsys-ui
```

## Profiling and Analysis

### NVIDIA Nsight System CLI (nsys)

First, ensure you have been allocated access to GPUs via the `nvidia-smi` command.

Provided you have access to GPUs, you can profile a GPU-enabled application from the command line using the `nsys` command:

```bash
nsys profile -o output_name ./your_application
```

**Common options:**

* `--gpu-metrics-device=all` – Collects GPU performance metrics (only works for Turing and newer architectures)
* `--trace=cuda,nvtx,osrt` – Specify tracing for CUDA, NVTX, and OS runtime

For example, we can track GPU usage in machine learning training with:

```bash
nsys profile --trace=cuda,nvtx,osrt -o my_profile python train_model.py
```

This will create two files, `my_profile.sqlite` and `my_profile.qdrep` (or `my_profile.nsys-rep` depending on the version) which store the results of the profiling. To analyze results directly on the command line, you can then run the following command:

```bash
nsys stats my_profile.nsys-rep
```

This command will output several tables that may be of interest for GPU optimization. For the purposes of GPU benchmarking, the CUDA API summary table will contain the statistics for the runtimes of CUDA API functions:

```text
 ** CUDA API Summary (cuda_api_sum):

 Time (%)  Total Time (ns)  Num Calls   Avg (ns)     Med (ns)    Min (ns)    Max (ns)   StdDev (ns)               Name
 --------  ---------------  ---------  -----------  -----------  ---------  ----------  -----------  ------------------------------
     87.9       94,864,569      2,560     37,056.5      7,260.5      5,496  15,974,993    575,765.3  cudaLaunchKernel
      3.9        4,182,395        484      8,641.3      9,363.5      3,857      42,452      4,478.2  cudaMemcpyAsync
      3.6        3,890,901        484      8,039.1      7,569.5      1,997      65,340      3,191.9  cudaStreamSynchronize
      1.9        2,021,777          2  1,010,888.5  1,010,888.5      2,769   2,019,008  1,425,696.3  cudaFree
      1.4        1,477,196          1  1,477,196.0  1,477,196.0  1,477,196   1,477,196          0.0  cudaHostAlloc
      1.1        1,206,049          8    150,756.1    147,012.0      4,340     394,302    139,253.6  cudaMalloc
      0.2          178,292        810        220.1        146.0         77       6,701        267.8  cuGetProcAddress_v2
      0.0           46,514         36      1,292.1        373.0        334      15,280      2,696.0  cudaEventCreateWithFlags
      0.0           11,710          2      5,855.0      5,855.0      4,559       7,151      1,832.8  cudaStreamIsCapturing_v10000
      0.0            9,806          3      3,268.7      2,574.0      2,232       5,000      1,509.1  cuInit
      0.0            2,630          3        876.7        506.0        117       2,007        998.0  cuModuleGetLoadingMode
      0.0            2,384          2      1,192.0      1,192.0        744       1,640        633.6  cudaGetDriverEntryPoint_v11030
```

If your program is frequently transferring a large amount of data to and from the GPU (for example, loading batches of training data), it may be useful to inspect the "host to device" and "device to host" memory copy times:

```text
 ** CUDA GPU MemOps Summary (by Time) (cuda_gpu_mem_time_sum):

 Time (%)  Total Time (ns)  Count  Avg (ns)  Med (ns)  Min (ns)  Max (ns)  StdDev (ns)           Operation
 --------  ---------------  -----  --------  --------  --------  --------  -----------  ----------------------------
     65.7          466,364    324   1,439.4   1,408.5     1,343     2,016         62.3  [CUDA memcpy Host-to-Device]
     34.3          243,199    160   1,520.0   1,504.0     1,472     2,944        120.4  [CUDA memcpy Device-to-Host]

 ** CUDA GPU MemOps Summary (by Size) (cuda_gpu_mem_size_sum):

 Total (MB)  Count  Avg (MB)  Med (MB)  Min (MB)  Max (MB)  StdDev (MB)           Operation
 ----------  -----  --------  --------  --------  --------  -----------  ----------------------------
      0.247    324     0.001     0.000     0.000     0.005        0.001  [CUDA memcpy Host-to-Device]
      0.001    160     0.000     0.000     0.000     0.000        0.000  [CUDA memcpy Device-to-Host]
```

* An `nsys` report is a database of collected samples and derived metrics. Using the `nsys` CLI, you can export the report into various formats, including SQLite, JSON, and more.
* For more profiling options visit [NVIDIA Nsight documentation](https://docs.nvidia.com/nsight-systems/UserGuide/index.html).

#### Limitations in Profiling

For security reasons, some profiling options and results are not available for public use. Particularly, anything that utilizes performance counters on GPUs, or performs CPU sampling, are disabled. This means that capture options utilizing performance counters, or that otherwise require root access, will not be operational for general users. These options include:

* `--gpu-metrics-device=XXX`
* `--gpu-metrics-set=XXX`
* `--sample=system-wide`
* `--event-sample=system-wide`
* `--cpu-core-events=XXX`
* `--cpu-core-metrics=XXX`
* `--cpuctxsw=system-wide`
* `--run-as=XXX`
* `--ftrace=XXX`

### NVIDIA Nsight System GUI (nsys-ui)

If you'd prefer to analyze via a graphical interface, you can use `nsys-ui` both to load the profiling results and to profile.

#### Launching GUI

**RCAC Clusters' nsys-ui App Launcher**

In some of our clusters, we have an **app-launcher** for this tool:

![Open OnDemand app launcher grid showing the Nsight Systems UI application tile alongside other cluster applications.](/assets/images/profilers/applauncher.png)

If the system provides an app launcher for nsys-ui, you can simply open it through the graphical interface without manually loading modules. Search for Nsight Systems UI in the application menu.

**Launching Without an App Launcher**

If an app launcher is unavailable, you may need to manually load the required modules before running nsys-ui.

* Prerequisite Modules:

    ```bash
    # On Gilbreth:
    $ ml cuda
    $ ml qt
    $ ml xcb-util-cursor
    $ which nsys-ui
    $ nsys-ui

    # $ ml libxcb
    # $ ml mesa-glu|mesa # (Likely required)
    ```

#### Profiling

1. Load the modules and launch Nsight Systems UI `nsys-ui`.
2. Specify the Profiling Target, which is the system where your CUDA application will run.
    * You have the option to choose a remote machine with SSH and USB connection options. However, since this tutorial is focused on profiling applications running on the RCAC cluster, you need to connect to the Localhost, as it is already one of the RCAC nodes.
    * ![Nsight Systems target-selection dropdown with Localhost selected among the available SSH and USB connection targets.](/assets/images/profilers/nsys-target.png)
3. Connect to the target machine.
4. Set up profiling configuration:
    * **Command Line with Arguments:** Provide the path to the executable file. This is the only mandatory setting.
    * **Working Directory:** Automatically set but can be changed if needed.
    * ![Nsight Systems target-application panel with fields for the command line with arguments and the working directory.](/assets/images/profilers/nsys-ui-target-app.png)
    * **Data Collection Settings:**
        + Note: Choosing too many metrics can introduce overhead, so enable only necessary ones. Consider tracing different events across multiple runs to minimize overhead.
        + There are plenty of customization options, and you will need to enable only a small subset of collection metrics.
        + An explanation of each option is available in the [Nsight Systems documentation](https://docs.nvidia.com/nsight-systems/UserGuide/index.html).
5. Click **Start** to begin data collection.
6. Then, it will create a Nsight Systems report after executing the application and display the collected metrics inside the GUI.

#### Loading Profiling results

1. Load dependent graphical utilities: `module load xcb-util-cursor xcb-util-image xcb-util-keysyms xcb-util-renderutil xcb-util-wm`, and launch the Graphical interface with `nsys-ui` (Or use the app launcher described above).
2. Open the `.nsys-rep` or `.qdrep` with **File > Open**.
3. A timeline of the processes will load. The X axis represents the runtime, and the Y axis has a breakdown of each process. Within each process, you can view the memory copy and CUDA API events.
4. You can highlight a portion of the timeline and right-click to zoom to selection.
5. Right-clicking any row on the Y axis and clicking "show in events view" will provide a summary in the bottom of the window.

![Nsight Systems GUI timeline view with per-process rows for CUDA API calls and memory copies over the run duration, and an events summary pane below.](/assets/images/profilers/nsys-ui_V1.png)

## Interpreting Results

### Understanding Timeline View

* **CPU Rows**: Show thread activity, API calls, and synchronization points
* **GPU Rows**: Display kernel executions, memory transfers, and hardware metrics
* **Memory Rows**: Indicate memory operations between host and device
* **CUDA API Rows**: Show CUDA API calls and their duration

### Common Performance Patterns

1. **GPU Idle Periods**
    * Look for gaps in GPU timeline
    * Check for CPU bottlenecks or synchronization issues
    * Consider using CUDA streams for better overlap
2. **Memory Transfer Bottlenecks**
    * Large host-to-device or device-to-host transfers
    * Consider using pinned memory or unified memory
    * Look for opportunities to reduce data movement
3. **API Call Overhead**
    * Frequent small kernel launches
    * Consider kernel fusion or batching
    * Look for unnecessary synchronization points

## Troubleshooting

### Common Issues

1. Unable to Launch nsys-ui
    * Ensure all required modules are loaded
    * Check X11 forwarding if running remotely
    * Verify GPU driver compatibility
2. Profile Collection Fails
    * Verify GPU allocation and access
    * Check available disk space
    * Ensure proper permissions
3. High Overhead During Profiling
    * Reduce the number of metrics collected
    * Use shorter collection duration
    * Apply appropriate filters

### Error Messages

* **"No CUDA application was profiled"**: Ensure your application is using CUDA and GPU resources are available
* **"Failed to load driver"**: Check CUDA installation and driver compatibility
* **"Unable to connect to target"**: Verify SSH settings and network connectivity for remote profiling

### FAQs

* **Where are the logs stored?**
    + By default, `nsys` generates `.qdrep` (or `.nsys-rep`) and `.sqlite` files, which store data in a format that the `nsys-ui` application can easily understand. If you'd like to export the data in a friendlier CSV format, you can use the following:

        ```bash
        nsys stats --export=csv -o output.csv my_profile.nsys-rep
        ```

For more details on using Nsight Systems, please check the [NVIDIA Nsight Systems documentation](https://developer.nvidia.com/nsight-systems) and the [User Guide](https://docs.nvidia.com/nsight-systems/UserGuide/).

## Additional Resources

* [NVIDIA Nsight Systems Documentation](https://docs.nvidia.com/nsight-systems/UserGuide/index.html)
* [Training Materials](https://developer.nvidia.com/nsight-systems/get-started)

[Back to Profilers Overview](index.md)
