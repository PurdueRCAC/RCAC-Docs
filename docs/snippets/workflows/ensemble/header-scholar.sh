#!/bin/bash
# FILENAME: ensemble.sub

#SBATCH --account=scholar
#SBATCH --partition=cpu
#SBATCH --qos=normal
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=64
#SBATCH --time=04:00:00
#SBATCH --job-name=ensemble

module load hypershell
