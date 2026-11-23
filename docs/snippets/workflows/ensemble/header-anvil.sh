#!/bin/bash
# FILENAME: ensemble.sub

#SBATCH --account=myallocation
#SBATCH --partition=wholenode
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=128
#SBATCH --time=04:00:00
#SBATCH --job-name=ensemble

module load hypershell
