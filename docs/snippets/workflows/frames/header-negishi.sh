#!/bin/bash
# FILENAME: frames.sub

#SBATCH --account=myallocation
#SBATCH --partition=cpu
#SBATCH --qos=normal
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=128
#SBATCH --time=00:15:00
#SBATCH --job-name=frames

module load hypershell
