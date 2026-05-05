---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

# GPU

The Gilbreth cluster nodes contain {::if resource.amdgpu == true}AMD{::else}NVIDIA{::/} {::if resource.nodegpus == 1}GPU{::else}GPUs{::/} that support {::if resource.amdgpu == true}*ROCm*, *HIP*,{::/} *CUDA* and *OpenCL*. See the [detailed hardware overview](/knowledge/${resource.dir}/overview) for the specifics on the GPUs in Gilbreth.

This section illustrates how to use SLURM to submit a simple GPU program.

Suppose that you named your executable file `gpu_hello` from the sample code {::if resource.amdgpu == true}[`gpu_hello_hip.cpp`](/files/knowledge/compile/src/gpu_hello_hip.cpp){::else}[`gpu_hello.cu`](/files/knowledge/compile/src/gpu_hello.cu){::/} (see the section on {::if resource.amdgpu == true}[compiling AMD GPU codes](/knowledge/${resource.dir}/compile/amdgpu){::else}[compiling NVIDIA GPU codes](/knowledge/${resource.dir}/compile/gpu){::/}). Prepare a job submission file with an appropriate name, here named `gpu_hello.sub`:

```
#!/bin/bash
# FILENAME:  gpu_hello.sub

module load {::if resource.amdgpu == true}rocm{::else}cuda{::/}

host=`hostname -s`

echo {::if resource.amdgpu == true}$ROCR_VISIBLE_DEVICES{::else}$CUDA_VISIBLE_DEVICES{::/}

# Run on the first available GPU
./gpu_hello 0
```

Submit the job:

```
sbatch{::if resource.name == Gautschi} -A myallocation -p ${resource.gpuqueue}{::else} -A {::if resource.queuemodel == partner}partner{::elseif resource.gpuqueue == true}${resource.gpuqueue}{::else}${resource.queue}{::/}{::/} --nodes=1 --gres=gpu:1 -t 00:01:00 gpu_hello.sub
```

**Requesting a GPU from the scheduler is required.**  
You can specify total number of GPUs, or number of GPUs per node, or even number of GPUs per task:

```
sbatch{::if resource.name == Gautschi} -A myallocation -p ${resource.gpuqueue}{::else} -A {::if resource.queuemodel == partner}partner{::elseif resource.gpuqueue == true}${resource.gpuqueue}{::else}${resource.queue}{::/}{::/} --nodes=1 --gres=gpu:1 -t 00:01:00 gpu_hello.sub
sbatch{::if resource.name == Gautschi} -A myallocation -p ${resource.gpuqueue}{::else} -A {::if resource.queuemodel == partner}partner{::elseif resource.gpuqueue == true}${resource.gpuqueue}{::else}${resource.queue}{::/}{::/} --nodes=1 --gpus-per-node=1 -t 00:01:00 gpu_hello.sub
sbatch{::if resource.name == Gautschi} -A myallocation -p ${resource.gpuqueue}{::else} -A {::if resource.queuemodel == partner}partner{::elseif resource.gpuqueue == true}${resource.gpuqueue}{::else}${resource.queue}{::/}{::/} --nodes=1 --gpus-per-task=1 -t 00:01:00 gpu_hello.sub
```

After job completion, view the new output file in your directory:

```
ls -l
gpu_hello
{::if resource.amdgpu == true}gpu_hello_hip.cpp{::else}gpu_hello.cu{::/}
gpu_hello.sub
slurm-myjobid.out
```

View results in the file for all standard output, `slurm-myjobid.out`

```
0
hello, world
```

If the job failed to run, then view error messages in the file `slurm-myjobid.out`.

To use multiple GPUs in your job, simply specify a larger value to the GPU specification parameter. However, be aware of the number of GPUs installed on the node(s) you may be requesting. The scheduler can not allocate more GPUs than physically exist. See [detailed hardware overview](/knowledge/${resource.dir}/overview) and output of `sfeatures` command for the specifics on the GPUs in Gilbreth.