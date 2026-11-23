#!/bin/bash
# FILENAME: array.sub

#SBATCH --account=myallocation
#SBATCH --partition=cpu
#SBATCH --qos=normal
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=00:10:00
#SBATCH --job-name=array-example
#SBATCH --output=array-%A_%a.out
#SBATCH --array=1-20%5
