# Job History

[Back to Week 4](./index.md)

Let's submit a job again with `sbatch` and check on it with `squeue`.

```bash
$ sbatch example.sh
Submitted batch job 19823415

$ squeue --me
JOBID     USER      ACCOUNT    NAME       NODES  CPUS   TIME_LIMIT  ST  TIME
19823415  username  lab_queue  example.sh     1     8      10:00     R  0:05

$ squeue --me
JOBID     USER      ACCOUNT    NAME       NODES  CPUS   TIME_LIMIT  ST  TIME
```

Notice that the job disappeared from the output of `squeue` after completion. How can we check on jobs after they've disappeared here? If you know the job ID, you can always run `jobinfo`:

```bash
$ jobinfo 19823415
Name       : example.sh
User       : username
Account    : lab_queue
Partition  : cpu
Nodes      : a200
Cores      : 4
GPUs       : 0
State      : COMPLETED
ExitCode   : 0:0
...
```

But how do we query the full job history?

We can use the `sacct` program to search deeper into our job history:

```bash
$ sacct -u username
JobID           Jobname  Partition    Account  AllocCPUS      State ExitCode
------------ ---------- ---------- ---------- ---------- ---------- --------
19822708     multinode+        cpu  lab_queue        256  COMPLETED      0:0
19822708.ba+      batch             lab_queue        128  COMPLETED      0:0
19822708.ex+     extern             lab_queue        256  COMPLETED      0:0
19822708.0     hostname             lab_queue        256  COMPLETED      0:0
19822977     interacti+        cpu  lab_queue          1  COMPLETED      0:0
19822977.in+ interacti+             lab_queue          1  COMPLETED      0:0
...
```

The `sacct` program is highly malleable, with many options for data filtering and output:

| Flag | Description | Example Usage |
|------|-------------|---------------|
| `-a` | Show jobs for **all users** (not just your own) | `sacct -a` |
| `-X` | Exclude **job steps**, show only top-level jobs | `sacct -X` |
| `-j` | Query **specific job(s)** by JobID | `sacct -j 12345,12346` |
| `-u` | Filter by **user** | `sacct -u jsmith` |
| `-A` | Filter by **account** | `sacct -A rcac-gpu` |
| `-r` | Filter by **partition** | `sacct -r gpu` |
| `-S` | Start time (inclusive) | `sacct -S 2026-01-01` or `sacct -S now-30days` |
| `-E` | End time (inclusive) | `sacct -E 2026-01-31` |
| `-s` | Filter by **job state** | `sacct -s COMPLETED,FAILED` |
| `-o` | Select **custom output fields** | `sacct -o JobID,User,State,Elapsed` |
| `-T` | Show **timestamps** instead of elapsed durations | `sacct -T` |
| `-P` | Output **pipe-delimited** format (script-friendly) | `sacct -P -n` |


An example of a job search that is only for a specific username with a specific submission account over the past 15 days would be:

```bash
$ sacct -X -u username -A hpcexc --starttime=now-15days -o JobID,JobName,User,State,Elapsed,NodeList

JobID           JobName      User      State    Elapsed        NodeList 
------------ ---------- --------- ---------- ---------- --------------- 
33251396       myjob.sh  username  COMPLETED   00:00:12            a006 
33251564       myjob.sh  username  COMPLETED   00:00:11            a004 
```

This shows you what jobs you have run with the `lab_queue` account.

**Next section:** [Resource Utilization and Monitoring](utilization-monitoring.md)
