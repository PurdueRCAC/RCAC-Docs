---
tags:
  - Gautschi
authors:
  - jin456
resource: Gautschi
search:
  boost: 2
---

This section illustrates how to submit a small R job to a SLURM queue. The example job computes a Pythagorean triple.

Prepare an R input file with an appropriate filename, here named ```myjob.R```:

```bash
# FILENAME:  myjob.R

# Compute a Pythagorean triple.
a = 3
b = 4
c = sqrt(a*a + b*b)
c     # display result
```

Prepare a job submission file with an appropriate filename, here named ```myjob.sub```:

```bash
#!/bin/bash
# FILENAME:  myjob.sub

module load r

# --vanilla:
# --no-save: do not save datasets at the end of an R session
R --vanilla --no-save < myjob.R
```

[Submit the Job and view the results](/docs/userguides/gautschi/run_jobs/index.md)

For other examples or R jobs:

- [The R Manuals](http://cran.r-project.org/manuals.html)
- [Other R Examples](http://www.mayin.org/ajayshah/KB/R/index.html)
- [Software Carpentry - Programming with R](https://swcarpentry.github.io/r-novice-inflammation/)
- [Data Carpentry Lessons](http://www.datacarpentry.org/lessons/)

[**Back to the R Examples section**](../r_example.md)
