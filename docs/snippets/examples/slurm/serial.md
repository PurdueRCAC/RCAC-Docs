# Serial Jobs

This shows how to submit one of the serial programs compiled in the section [Compiling Serial Programs](../../../compile/serial.md).

Create a job submission file:

```

#!/bin/bash
# FILENAME:  serial_hello.sub

./serial_hello
```

Submit the job:


```

sbatch --nodes=1 --ntasks=1 --time=00:01:00 serial_hello.sub
```


After the job completes, view results in the output file:

```

cat slurm-myjobid.out

Runhost:bell-a009.rcac.purdue.edu
hello, world

```

If the job failed to run, then view error messages in the file `slurm-myjobid.out`.
