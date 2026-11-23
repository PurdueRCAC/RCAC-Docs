#!/bin/sh
# FILENAME: gpu-pick.sh
# Run one task on one of this job's GPUs, chosen by the HyperShell
# executor that runs it. "sh gpu-pick.sh ./emulator 17" runs
# "./emulator 17" with CUDA_VISIBLE_DEVICES set to a single GPU.

# HyperShell numbers its executors 0, 1, 2, ... and gives each task its
# executor's number in TASK_SLOT. The job script sets GPUS. Executor s
# takes the GPU at position (s mod GPUS) + 1 in the job's list, so every
# GPU gets the same number of executors.
position=$(( TASK_SLOT % GPUS + 1 ))

# Slurm lists the job's GPUs in CUDA_VISIBLE_DEVICES, for example 0,1.
# Keep only the GPU at that position.
export CUDA_VISIBLE_DEVICES=$(echo "$CUDA_VISIBLE_DEVICES" | cut -d, -f "$position")

# Run the task: "$@" is the command given to this script.
"$@"
