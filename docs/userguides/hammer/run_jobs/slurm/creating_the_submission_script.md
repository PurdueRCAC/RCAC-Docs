---
tags:
  - Hammer
authors:
  - jin456
resource: Hammer
search:
  boost: 2
---

# Job Submission Script

To submit work to a SLURM queue, you must first create a *job submission file*. This job submission file is essentially a simple shell script. It will set any required environment variables, load any necessary modules, create or modify files and directories, and run any applications that you need:

```
#!/bin/bash
# FILENAME:  myjobsubmissionfile

# Loads Matlab and sets the application up
module load matlab

# Change to the directory from which you originally submitted this job.
cd $SLURM_SUBMIT_DIR

# Runs a Matlab script named 'myscript'
matlab -nodisplay -singleCompThread -r myscript
```

Once your script is prepared, you are ready to [submit your job](submit_script.md).

## Job Script Environment Variables

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

[**Back to the Running Jobs section**](../index.md)
