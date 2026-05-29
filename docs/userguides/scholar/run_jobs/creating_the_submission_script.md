---
tags:
  - Scholar
authors:
  - jin456
  - remender
resource: Scholar
host: scholar.rcac.purdue.edu
search:
  boost: 2
---

# Creating the Submission Script

To submit work to a SLURM queue, you must first create a job submission file. This job submission file is essentially a simple shell script. It will set any required environment variables, load any necessary modules, create or modify files and directories, and run any applications that you need:

```bash
#!/bin/bash
# FILENAME:  myjobsubmissionfile

# Loads Matlab and sets the application up
module load matlab

# Change to the directory from which you originally submitted this job.
cd $SLURM_SUBMIT_DIR

# Runs a Matlab script named 'myscript'
matlab -nodisplay -singleCompThread -r myscript
```

## Job Script Environment Variables

SLURM sets several potentially useful environment variables which you may use within your job submission files. Here is a list of some:

| Name | Description
| -------- | ----- |
| SLURM_SUBMIT_DIR | Absolute path of the current working directory when you submitted this job |
| SLURM_JOBID | Job ID number assigned to this job by the batch system |
| SLURM_JOB_NAME | Job name supplied by the user |
| SLURM_JOB_NODELIST | Names of nodes assigned to this job |
| SLURM_CLUSTER_NAME | 	Name of the cluster executing the job |
| SLURM_SUBMIT_HOST | Hostname of the system where you submitted this job |
| SLURM_JOB_PARTITION | Name of the original queue to which you submitted this job |

[**Back to the Running Jobs section**](index.md)
