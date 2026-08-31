---
tags:
  - Negishi
authors:
  - hkashgar
resource: Negishi
search:
  boost: 2
---

# Submitting Fluent jobs to SLURM

The Fluent simulations can also run in batch. In this section we provide an example script for submitting Fluent jobs to the SLURM scheduler. Please refer to the  [Running Jobs](../../run_jobs/index.md) section of our user guide for detailed tutorials of submitting jobs.

```bash
#!/bin/bash
# Job script for submitting a FLUENT job on multiple cores on a single node 

# Apply resources via SLURM
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --time=01:00:00
#SBATCH --job-name=fluent_test
#SBATCH -o fluent_test_%j.out
#SBATCH -e fluent_test_%j.err

# Loads Ansys and sets the application up
module purge
module load ansys/2022R1

#Initiating Fluent and reading input journal file
fluent 3ddp -t$NTASKS -g -i testJournal.jou
```

For more information about submitting Fluent jobs, please refer to [Fluent FAQ]( https://www.cfd-online.com/Wiki/Fluent_FAQ) .

[**Back to Ansys Fluent**](../ansysfluent.md)
