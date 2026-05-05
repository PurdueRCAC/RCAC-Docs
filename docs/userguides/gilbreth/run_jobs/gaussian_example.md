---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

# Gaussian

Gaussian is a computational chemistry software package which works on electronic structure. This section illustrates how to submit a small Gaussian job to a Slurm queue. This Gaussian example runs the Fletcher-Powell multivariable optimization.

Prepare a Gaussian input file with an appropriate filename, here named `myjob.com`. The final blank line is necessary:

```

#P TEST OPT=FP STO-3G OPTCYC=2

STO-3G FLETCHER-POWELL OPTIMIZATION OF WATER

0 1
O
H 1 R
H 1 R 2 A

R 0.96
A 104.
```

To submit this job, load Gaussian then run the provided script, named `subg16`. This job uses one compute node with ${resource.nodecores} processor cores:

```

module load gaussian16
subg16 myjob -N 1 -n ${resource.nodecores} {::if resource.qsub_needs_gpu == 1} --gres=gpu:1 {::/}
```

View job status:

```

squeue -u ${user.username}
```

View results in the file for Gaussian output, here named `myjob.log`. Only the first and last few lines appear here:

```


 Entering Gaussian System, Link 0=/apps/cent7/gaussian/g16-A.03/g16-haswell/g16/g16
 Initial command:
{::if resource.letteredscratch == true}
 /apps/cent7/gaussian/g16-A.03/g16-haswell/g16/l1.exe ${resource.scratch}/${user.usernameletter}/${user.username}/gaussian/Gau-7781.inp -scrdir=${resource.scratch}/${user.usernameletter}/${user.username}/gaussian/
{::else}
 /apps/cent7/gaussian/g16-A.03/g16-haswell/g16/l1.exe ${resource.scratch}/${user.username}/gaussian/Gau-7781.inp -scrdir=${resource.scratch}/${user.username}/gaussian/
{::/}
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
{::if resource.nodashnames == true}a012.${resource.hostname}{::else}${resource.hostname}-a012{::/}.rcac.purdue.edu
{::if resource.nodashnames == true}a012.${resource.hostname}{::else}${resource.hostname}-a012{::/}.rcac.purdue.edu
{::if resource.nodashnames == true}a012.${resource.hostname}{::else}${resource.hostname}-a012{::/}.rcac.purdue.edu
{::if resource.nodashnames == true}a012.${resource.hostname}{::else}${resource.hostname}-a012{::/}.rcac.purdue.edu
{::if resource.nodashnames == true}a012.${resource.hostname}{::else}${resource.hostname}-a012{::/}.rcac.purdue.edu
{::if resource.nodashnames == true}a012.${resource.hostname}{::else}${resource.hostname}-a012{::/}.rcac.purdue.edu
{::if resource.nodashnames == true}a012.${resource.hostname}{::else}${resource.hostname}-a012{::/}.rcac.purdue.edu
{::if resource.nodashnames == true}a012.${resource.hostname}{::else}${resource.hostname}-a012{::/}.rcac.purdue.edu
```

### Examples of Gaussian SLURM Job Submissions

Submit job using ${resource.nodecores} processor cores on a single node:

{::if resource.qsub\_needs\_gpu == 1}

```

subg16 myjob -N 1 -n ${resource.nodecores} --gres=gpu:1 -t 24:00:00 -A ${resource.queue}
```

{::else}

```

subg16 myjob  -N 1 -n ${resource.nodecores} -t 200:00:00 -A myqueuename
```

{::/}

Submit job using ${resource.nodecores} processor cores on each of 2 nodes:

{::if resource.qsub\_needs\_gpu == 1}

```

subg16 myjob  -N 2 --ntasks-per-node=${resource.nodecores} --gres=gpu:2 -t 24:00:00 -A ${resource.queue}
```

{::else}

```

subg16 myjob -N 2 --ntasks-per-node=${resource.nodecores} -t 200:00:00 -A myqueuename
```

{::/}

To submit a bash job, a submit script sample looks like:

```

#!/bin/bash 
  
#SBATCH -A myqueuename  # Queue name(use 'slist' command to find queues' name)
#SBATCH --nodes=1       # Total # of nodes 
#SBATCH --ntasks=64     # Total # of MPI tasks{::if resource.qsub_needs_gpu == 1}
#SBATCH --gpus-per-node=1 # Total # of GPUs{::/}
#SBATCH --time=1:00:00  # Total run time limit (hh:mm:ss)
#SBATCH -J myjobname    # Job name
#SBATCH -o myjob.o%j    # Name of stdout output file
#SBATCH -e myjob.e%j    # Name of stderr error file

module load gaussian16

g16 < myjob.com
```

For more information about Gaussian:

* [Gaussian Website](http://www.gaussian.com/)