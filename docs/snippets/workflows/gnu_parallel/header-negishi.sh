#!/bin/bash
# FILENAME: parallel.sub

#SBATCH --account=myallocation
#SBATCH --partition=cpu
#SBATCH --qos=normal
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=00:15:00
#SBATCH --job-name=parallel-example

module load parallel
