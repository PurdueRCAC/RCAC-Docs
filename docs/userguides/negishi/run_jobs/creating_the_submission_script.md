---
tags:
  - Negishi
authors:
  - hkashgar
resource: Negishi
search:
  boost: 2
---

# Creating the Slurm Job Submission Script

### Script

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
Once your script is prepared, you are ready to [submit your job](./submit_script.md).

### Job Script Environment Variables

SLURM sets several potentially useful environment variables which you may use within your job submission files. Here is a list of some:

| Name | Description |
| --- | --- |
| SLURM\_SUBMIT\_DIR | Absolute path of the current working directory when you submitted this job |
| SLURM\_JOBID | Job ID number assigned to this job by the batch system |
| SLURM\_JOB\_NAME | Job name supplied by the user |
| SLURM\_JOB\_NODELIST | Names of nodes assigned to this job |
| SLURM\_CLUSTER\_NAME | Name of the cluster executing the job |
| SLURM\_SUBMIT\_HOST | Hostname of the system where you submitted this job |
| SLURM\_JOB\_PARTITION | Name of the original queue to which you submitted this job |

[**Back to the Running Jobs section**](index.md)
