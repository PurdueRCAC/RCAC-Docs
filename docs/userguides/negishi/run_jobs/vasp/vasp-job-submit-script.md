---
tags:
  - Negishi
authors:
  - hkashgar
resource: Negishi
search:
  boost: 2
---

# VASP Job Submit Script

This shows an example of a job submission file for running VASP pre-built on Negishi:

```
#!/bin/bash

#SBATCH -A myqueuename  # Queue name(use 'slist' command to find queues' name)
#SBATCH --nodes=1       # Total # of nodes 
#SBATCH --ntasks=64     # Total # of MPI tasks
#SBATCH --time=1:00:00  # Total run time limit (hh:mm:ss)
#SBATCH -J myjobname    # Job name
#SBATCH -o myjob.o%j    # Name of stdout output file
#SBATCH -e myjob.e%j    # Name of stderr error file

# Manage processing environment, load compilers and applications.
module load vasp/5.4.4.pl2  # or module load vasp/6.4.1
module list

# Launch MPI code
mpirun -np $SLURM_NTASKS vasp_std
```

[**Back to the VASP section**](../vasp.md)
