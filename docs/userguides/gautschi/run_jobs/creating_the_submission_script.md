---
tags:
  - Gautschi
  - Python
authors:
  - jin456
  - remender
cluster: Gautschi
search:
  boost: 2
---

To submit work to a SLURM queue, you must first create a job submission file. This job submission file is essentially a simple shell script that includes special comments to specify sbatch options. It will set any required environment variables, load any necessary modules, create or modify files and directories, and run any applications that you need. A simple submission script to the {{ resource }} cpu partition looks like:

``` bash
#!/bin/bash
# FILENAME:  myjobsubmissionfile

#SBATCH --account=myLabAccount
#SBATCH --partition=cpu
#SBATCH --qos=normal
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=1-00:00:00

# Loads Matlab and sets the application up
module load matlab

# Change to the directory from which you originally submitted this job.
cd $SLURM_SUBMIT_DIR

# Runs a Matlab script named 'myscript'
matlab -nodisplay -singleCompThread -r myscript
```

[**Return to the guide**](index.md)