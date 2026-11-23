#!/bin/sh
# FILENAME: gpu-pick.sh
# Run a command on one of this job's GPUs, chosen by the HyperShell
# executor that runs it. "sh gpu-pick.sh ./emulator 17" runs
# "./emulator 17" with CUDA_VISIBLE_DEVICES set to a single GPU.
# Executor slots are numbered 0, 1, 2, ...; slot s gets the GPU at
# position s mod n in the job's list of n GPUs, so with k executors
# per GPU, each GPU runs k tasks at once.
: "${TASK_SLOT:?run this under HyperShell 2.9.0 or later}"
: "${CUDA_VISIBLE_DEVICES:?this job has no GPUs}"
gpus=$(printf '%s' "$CUDA_VISIBLE_DEVICES" | tr ',' ' ')
n=$(echo $gpus | wc -w)
i=$(( TASK_SLOT % n + 1 ))
CUDA_VISIBLE_DEVICES=$(echo $gpus | cut -d' ' -f"$i")
export CUDA_VISIBLE_DEVICES
exec "$@"
