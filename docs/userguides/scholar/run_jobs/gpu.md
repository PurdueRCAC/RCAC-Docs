---
tags:
  - Scholar
authors:
  - jin456
resource: scholar
host: scholar.rcac.purdue.edu
search:
  boost: 2
---

# GPU Jobs

The Scholar cluster nodes contain NVIDIA GPUs that support CUDA and OpenCL. See the [detailed hardware overview](../overview.md) for the specifics on the GPUs in Scholar.

This section illustrates how to use SLURM to submit a simple GPU program.

Suppose that you named your executable file ```gpu_hello``` from the sample code [gpu_hello.cu](../../../assets/scripts/userguides/compile/src/gpu_hello.cu) (see the section on [compiling NVIDIA GPU codes](../compile/compile_gpu.md)). Prepare a job submission file with an appropriate name, here named ```gpu_hello.sub```:

```bash
#!/bin/bash
# FILENAME:  gpu_hello.sub

module load cuda

host=`hostname -s`

echo $CUDA_VISIBLE_DEVICES

# Run on the first available GPU
./gpu_hello 0
```

Submit the job:

```bash
sbatch -A gpu --nodes=1 --gres=gpu:1 -t 00:01:00 gpu_hello.sub 
```

**Requesting a GPU from the scheduler is required.** You can specify total number of GPUs, or number of GPUs per node, or even number of GPUs per task:

```bash
sbatch -A gpu --nodes=1 --gres=gpu:1 -t 00:01:00 gpu_hello.sub
sbatch -A gpu --nodes=1 --gpus-per-node=1 -t 00:01:00 gpu_hello.sub
sbatch -A gpu --nodes=1 --gpus-per-task=1 -t 00:01:00 gpu_hello.sub
```

After job completion, view the new output file in your directory:

```bash
ls -l
gpu_hello
gpu_hello.cu
gpu_hello.sub
slurm-myjobid.out
```

View results in the file for all standard output, ```slurm-myjobid.out```

```bash
0
hello, world
```

If the job failed to run, then view error messages in the file ```slurm-myjobid.out```.

To use multiple GPUs in your job, simply specify a larger value to the GPU specification parameter. However, be aware of the number of GPUs installed on the node(s) you may be requesting. The scheduler can not allocate more GPUs than physically exist. See [detailed hardware overview](../overview.md) and output of ```sfeatures``` command for the specifics on the GPUs in Scholar.

[**Back to the Example Jobs section**](generic_slurm_jobs.md)
