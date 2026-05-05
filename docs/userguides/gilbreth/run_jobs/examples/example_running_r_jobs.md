---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

# Running R jobs

This section illustrates how to submit a small R job to a {::if resource.batchsystem == slurm}SLURM{::else}PBS{::/} queue. The example job computes a Pythagorean triple.

Prepare an R input file with an appropriate filename, here named `myjob.R`:

```
# FILENAME:  myjob.R

# Compute a Pythagorean triple.
a = 3
b = 4
c = sqrt(a*a + b*b)
c     # display result
```

Prepare a job submission file with an appropriate filename, here named `myjob.sub`:

```
#!/bin/bash
# FILENAME:  myjob.sub

module load r
{::if resource.batchsystem == pbs}
cd $PBS_O_WORKDIR
{::/}
# --vanilla:
# --no-save: do not save datasets at the end of an R session
R --vanilla --no-save < myjob.R
```

[submit the job](/knowledge/${resource.hostname}/run/${resource.batchsystem}/submit)

[View job status](/knowledge/${resource.hostname}/run/${resource.batchsystem}/status)

[View results of the job](/knowledge/${resource.hostname}/run/${resource.batchsystem}/output)

For other examples or R jobs:

* [The R Manuals](http://cran.r-project.org/manuals.html)
* [Other R Examples](http://www.mayin.org/ajayshah/KB/R/index.html)
* [Software Carpentry - Programming with R](https://swcarpentry.github.io/r-novice-inflammation/)
* [Data Carpentry Lessons](http://www.datacarpentry.org/lessons/)