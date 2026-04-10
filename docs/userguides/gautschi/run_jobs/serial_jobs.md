---
tags:
  - Gautschi
authors:
  - jin456
resource: Gautschi
search:
  boost: 2
---

This shows how to submit one of the serial programs compiled in the section [Compiling Serial Programs](placeholder).

Create a job submission file:

```bash
#!/bin/bash
# FILENAME:  serial_hello.sub

./serial_hello
```

Submit the job:

```bash
sbatch --nodes=1 --ntasks=1 --time=00:01:00 serial_hello.sub
```

After the job completes, view results in the output file:

```bash
cat slurm-myjobid.out

Runhost:gautschi-a009.rcac.purdue.edu
hello, world 
```

If the job failed to run, then view error messages in the file ```slurm-myjobid.out```.

[**Back to the Example Jobs section**](generic_slurm_jobs.md)
