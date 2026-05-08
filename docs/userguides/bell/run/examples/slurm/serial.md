---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Serial Jobs

This shows how to submit one of the serial programs compiled in the section [Compiling Serial Programs](/knowledge/${resource.hostname}/compile/serial).

Create a job submission file:

```

#!/bin/bash
# FILENAME:  serial_hello.sub

./serial_hello
```

Submit the job:

{::if resource.qsub\_needs\_gpu == 1}

```

sbatch --nodes=1 --ntasks=1 --gpus-per-node=1 --time=00:01:00 serial_hello.sub
```

{::else}

```

sbatch --nodes=1 --ntasks=1 --time=00:01:00 serial_hello.sub
```

{::/}

After the job completes, view results in the output file:

```

cat slurm-myjobid.out
{::if resource.name != Weber}
Runhost:{::if resource.nodashnames == true}a009.${resource.hostname}{::else}${resource.hostname}-a009{::/}.rcac.purdue.edu
hello, world
{::else}
Runhost:${resource.hostname}.rcac.purdue.edu
hello, world
{::/}
```

If the job failed to run, then view error messages in the file `slurm-myjobid.out`.