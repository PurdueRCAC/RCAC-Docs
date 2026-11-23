#!/bin/bash
# FILENAME: gpu_sweep.sub

#SBATCH --account=scholar
#SBATCH --partition=gpu
#SBATCH --qos=normal
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --gpus-per-node=2
#SBATCH --cpus-per-task=16
#SBATCH --time=00:15:00
#SBATCH --job-name=gpu_sweep

module load hypershell
