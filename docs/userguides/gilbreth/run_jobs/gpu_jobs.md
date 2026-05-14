---
tags:
  - Gilbreth
authors:
  - jin456
  - verburgt
resource: Gilbreth
search:
  boost: 2
---

# GPU

The Gilbreth cluster nodes contain NVIDIA GPUs that support CUDA and OpenCL. See the [detailed hardware overview](../overview.md#gilbreth-detailed-hardware-specification) for the specifics on the GPUs in Gilbreth.

This section illustrates how to use SLURM to submit a simple GPU program.

Suppose that you named your executable file `gpu_hello` from the sample code `gpu_hello.cu`. Prepare a job submission file with an appropriate name. In this example, the file is named `gpu_hello.sub`.

## Example Job Submission File

```bash
#!/bin/bash
# FILENAME:  gpu_hello.sub

module load cuda

host=`hostname -s`

echo $CUDA_VISIBLE_DEVICES

# Run on the first available GPU
./gpu_hello 0
```

## Submit the Job

Submit the job:

```bash
sbatch -A gpu --nodes=1 --gres=gpu:1 -t 00:01:00 gpu_hello.sub
```

Requesting a GPU from the scheduler is required.

You can specify the total number of GPUs, the number of GPUs per node, or the number of GPUs per task.

```bash
sbatch -A gpu --nodes=1 --gres=gpu:1 -t 00:01:00 gpu_hello.sub
sbatch -A gpu --nodes=1 --gpus-per-node=1 -t 00:01:00 gpu_hello.sub
sbatch -A gpu --nodes=1 --gpus-per-task=1 -t 00:01:00 gpu_hello.sub
```

## View Output

After job completion, view the new output file in your directory:

```bash
ls -l
```

Example output:

```text
gpu_hello
gpu_hello.cu
gpu_hello.sub
slurm-myjobid.out
```

View results in the file for all standard output:

```bash
cat slurm-myjobid.out
```

Example output:

```text
0
hello, world
```

If the job failed to run, view error messages in the file `slurm-myjobid.out`.

## Requesting Multiple GPUs

To use multiple GPUs in your job, specify a larger value for the GPU specification parameter.

Be aware of the number of GPUs installed on the node or nodes you are requesting. The scheduler cannot allocate more GPUs than physically exist.

See the [detailed hardware overview](../overview.md#gilbreth-detailed-hardware-specification) and the output of the `sfeatures` command for specifics on the GPUs in Gilbreth.

[**Back to the Running Jobs section**](index.md)