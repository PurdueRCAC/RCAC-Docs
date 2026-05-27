---
tags:
  - Scholar
authors:
  - jin456
  - remender
resource: scholar
host: scholar.rcac.purdue.edu
search:
  boost: 2
---

# Directives

So far these examples have shown submitting jobs with the resource requests on the ```sbatch``` command line such as:

```bash
sbatch -A scholar --nodes=1 --time=00:01:00 hello.sub
```

The resource requests can also be put into job submission file itself. Documenting the resource requests in the job submission is desirable because the job can be easily reproduced later. Details left in your command history are quickly lost. Arguments are specified with the ```#SBATCH``` syntax:

```bash
#!/bin/bash

# FILENAME: hello.sub

#SBATCH -A scholar 

#SBATCH --nodes=1 --time=00:01:00 

# Show this ran on a compute node by running the hostname command.
hostname

echo "Hello World"
```

The ```#SBATCH``` directives must appear at the top of your submission file. SLURM will stop parsing directives as soon as it encounters a line that does not start with '#'. If you insert a directive in the middle of your script, it will be ignored.

This job can be then submitted with:

```bash
sbatch hello.sub
```

[**Back to the Example Jobs section**](generic_slurm_jobs.md)
