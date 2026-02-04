---
tags:
  - Gautschi
authors:
  - jin456
  - remender
cluster: Gautschi
search:
  boost: 2
---

Once you have a job submission script, you may submit the script to SLURM using the sbatch command. SLURM will find, or wait for, available resources matching your request and run your job there. If you have included your sbatch options as special comments in your submission script, submitting the job is as simple as:

``` bash
sbatch myjobsubmissionfile
```

Should you wish to override any of the sbatch options that you've specified in your submission script, you can add them as command-line options to the sbatch command:

``` bash
sbatch myjobsubmissionfile -q standby -t 04:00:00
```

This command will override the --qos and --time options that were specified in the script in the [Creating the submission script](creating_the_submission_script.md) section. You could also choose to omit any sbatch options from your submission script and include them all in the submission command:

``` bash
sbatch -A myLabAccount -p cpu -q normal -N1 -n1 -t 1-00:00:00 myjobsubmissionfile
```

!!! note
    Any sbatch options that you specify in the command-line submission will override what is specified in your job submission script.

[**Return to the guide**](index.md)
