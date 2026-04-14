---
tags:
  - Gautschi
authors:
  - jin456
resource: Gautschi
search:
  boost: 2
---

# Compiling GPU Programs

The Gautschi cluster nodes contain 6 GPUs that support CUDA and OpenCL. This section focuses on using CUDA.

A simple CUDA program has a basic workflow:

- Initialize an array on the host (CPU).
- Copy array from host memory to GPU memory.
- Apply an operation to array on GPU.
- Copy array from GPU memory to host memory.

Here is a sample CUDA program:

- [gpu_hello.cu](src/gpu_hello.md)

Both front-ends and GPU-enabled compute nodes have the CUDA tools and libraries available to compile CUDA programs. To compile a CUDA program, load CUDA, and use ```nvcc``` to compile the program:

```bash
$ module load gcc/11.4.1 cuda/12.6.0
$ nvcc gpu_hello.cu -o gpu_hello
./gpu_hello
No GPU specified, using first GPUhello, world
```

The example illustrates only how to copy an array between a CPU and its GPU but does not perform a serious computation.

The following program times three square matrix multiplications on a CPU and on the global and shared memory of a GPU:

- [mm.cu](src/gpu_mm.md)

```bash
$ module load cuda
$ nvcc mm.cu -o mm
$ ./mm 0
                                                            speedup
                                                            -------
Elapsed time in CPU:                    6555.2 milliseconds
Elapsed time in GPU (global memory):      32.9 milliseconds  199.1
Elapsed time in GPU (shared memory):       3.0 milliseconds  2191.8
```

For best performance, the input array or matrix must be sufficiently large to overcome the overhead in copying the input and output data to and from the GPU.

For more information about NVIDIA, CUDA, and GPUs:

- [NVIDIA CUDA C Best Practices Guide](http://developer.download.nvidia.com/compute/DevZone/docs/html/C/doc/CUDA_C_Best_Practices_Guide.pdf)
- [NVIDIA CUDA C Programming Guide](http://developer.download.nvidia.com/compute/DevZone/docs/html/C/doc/CUDA_C_Programming_Guide.pdf)
- [NVIDIA GPU Computing Documentation](http://developer.nvidia.com/nvidia-gpu-computing-documentation)
- [NVIDIA The CUDA Compiler Driver NVCC](http://developer.download.nvidia.com/compute/DevZone/docs/html/C/doc/nvcc.pdf)
- [NVIDIA CUDA-GDB Debugger](http://developer.download.nvidia.com/compute/DevZone/docs/html/C/doc/cuda-gdb.pdf)
- [NVIDIA GPU Computing Webinars](http://developer.nvidia.com/gpu-computing-webinars)
- [NVIDIA](http://www.nvidia.com/page/home.html)
- [General-Purpose Computation on Graphics Hardware](http://gpgpu.org/)

[Back to the Compiling Programs section](../compile.md)
