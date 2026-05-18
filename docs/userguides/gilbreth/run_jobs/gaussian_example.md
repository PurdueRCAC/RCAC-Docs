---
tags:
  - Gilbreth
authors:
  - jin456
  - verburgt
resource: Gilbreth
search:
  boost: 2
---

# Gaussian

Gaussian is a computational chemistry software package which works on electronic structure. This section illustrates how to submit a small Gaussian job to a Slurm queue. This Gaussian example runs the Fletcher-Powell multivariable optimization.

## Gaussian Input File

Prepare a Gaussian input file with an appropriate filename. In this example, the file is named `myjob.com`.

The final blank line is necessary.

```text
#P TEST OPT=FP STO-3G OPTCYC=2

STO-3G FLETCHER-POWELL OPTIMIZATION OF WATER

0 1
O
H 1 R
H 1 R 2 A
R 0.96
A 104.
```

## Submit the Job

To submit this job, load Gaussian and then run the provided script, named `subg16`.

This job uses one compute node with 16 processor cores.

```bash
module load gaussian16
subg16 myjob -N 1 -n 16 --gres=gpu:1
```

## View Job Status

View job status with:

```bash
squeue -u myusername
```

## View Results

View results in the Gaussian output file. In this example, the output file is named `myjob.log`.

Only the first and last few lines are shown here:

```text
 Entering Gaussian System, Link 0=/apps/cent7/gaussian/g16-A.03/g16-haswell/g16/g16
 Initial command:
 /apps/cent7/gaussian/g16-A.03/g16-haswell/g16/l1.exe /scratch/gilbreth/myusername/gaussian/Gau-7781.inp -scrdir=/scratch/gilbreth/myusername/gaussian/
 Entering Link 1 = /apps/cent7/gaussian/g16-A.03/g16-haswell/g16/l1.exe PID=      7782.

 Copyright (c) 1988,1990,1992,1993,1995,1998,2003,2009,2016,
            Gaussian, Inc.  All Rights Reserved.

.
.
.
 Job cpu time:       0 days  0 hours  3 minutes 28.2 seconds.
 Elapsed time:       0 days  0 hours  0 minutes 12.9 seconds.
 File lengths (MBytes):  RWF=     17 Int=      0 D2E=      0 Chk=      2 Scr=      2
 Normal termination of Gaussian 16 at Tue May  1 17:12:00 2018.
real 13.85
user 202.05
sys 6.12
Machine:
gilbreth-a012.rcac.purdue.edu
gilbreth-a012.rcac.purdue.edu
gilbreth-a012.rcac.purdue.edu
gilbreth-a012.rcac.purdue.edu
gilbreth-a012.rcac.purdue.edu
gilbreth-a012.rcac.purdue.edu
gilbreth-a012.rcac.purdue.edu
gilbreth-a012.rcac.purdue.edu
```

## Examples of Gaussian SLURM Job Submissions

Submit a job using 16 processor cores on a single node:

```bash
subg16 myjob -N 1 -n 16 --gres=gpu:1 -t 24:00:00 -A standby
```

Submit a job using 16 processor cores on each of 2 nodes:

```bash
subg16 myjob -N 2 --ntasks-per-node=16 --gres=gpu:2 -t 24:00:00 -A standby
```

## Bash Job Submission Script

To submit a bash job, a sample submit script looks like this:

```bash
#!/bin/bash
#SBATCH -A accountname     # Queue name; use the 'slist' command to find queue names
#SBATCH --nodes=1          # Total number of nodes
#SBATCH --ntasks=64        # Total number of MPI tasks
#SBATCH --gpus-per-node=1  # Total number of GPUs
#SBATCH --time=1:00:00     # Total run time limit (hh:mm:ss)
#SBATCH -J myjobname       # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH --partition=a10
#SBATCH --mem=8G

module load gaussian16

g16 < myjob.com
```

## Additional Resources

- [Gaussian Website](https://www.gaussian.com)

[**Back to the Running Jobs section**](index.md)