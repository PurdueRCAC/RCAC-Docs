#!/bin/bash
# FILENAME: client.sub

#SBATCH --account=scholar
#SBATCH --partition=cpu
#SBATCH --qos=normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=64
#SBATCH --time=04:00:00
#SBATCH --job-name=panel

module load hypershell
