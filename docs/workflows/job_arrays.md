---
title: Slurm Job Arrays
tags:
  - Workflows
  - Slurm
authors:
  - glentner
search:
  boost: 2
---

# Slurm Job Arrays

A Slurm job array submits many copies of one job script with a single `sbatch` command. Each
copy, called an *array task*, runs the same script with its own index in the environment variable
`SLURM_ARRAY_TASK_ID`, and the script uses that index to choose its input. Job arrays are part of
Slurm itself, so there is nothing to install and they work the same way on every RCAC cluster.
They are the baseline that every other tool in this section is compared against.

## The work it fits

Job arrays fit tens to a few hundred tasks of similar shape, each long enough to deserve its own
scheduler entry: minutes to hours, not seconds. Each array task is a full Slurm job. It waits in
the queue on its own, gets its own resources, writes its own output file, and appears in Slurm's
accounting under its own ID (`<jobid>_<index>`). That is useful when you want to watch, cancel or
account for each task separately, and it is the source of the limits described in
[When to move to HyperShell](#when-to-move-to-hypershell).

## How an array is written

You request an array with the `--array` option, either as an `#SBATCH` line in the script or on
the `sbatch` command line. The value lists the indices to run:

| Form | Runs |
|---|---|
| `--array=1-20` | tasks 1 through 20 |
| `--array=1,4,9` | tasks 1, 4 and 9 |
| `--array=1-7:2` | tasks 1, 3, 5 and 7 (every second index) |
| `--array=1-20%5` | tasks 1 through 20, at most five running at once |

The `%N` suffix throttles the array: Slurm starts no more than `N` of its tasks at a time, however
many could run. Use it to be considerate of the queue and of shared filesystems when every task
reads or writes a lot of data.

Inside each task, Slurm sets these variables:

| Variable | Value |
|---|---|
| `SLURM_ARRAY_JOB_ID` | the job ID shared by the whole array |
| `SLURM_ARRAY_TASK_ID` | this task's index |
| `SLURM_ARRAY_TASK_COUNT` | the number of tasks in the array |
| `SLURM_ARRAY_TASK_MIN`, `SLURM_ARRAY_TASK_MAX` | the lowest and highest index |

In an `--output` file name, `%A` stands for the array's job ID and `%a` for the task index, so each
task writes its own output file. The full reference is Slurm's
[job array documentation](https://slurm.schedmd.com/job_array.html).

## A worked example

This example runs one task per input file. A list, `inputs.txt`, names one file per line, and
array task *N* processes line *N*. The work in each task is counting the words in one file with
`wc`, a stand-in for your own per-file command. The same sample files appear in the
[GNU Make](gnu_make.md) and [GNU Parallel](gnu_parallel.md) examples, so you can compare the three
tools on the same work.

To try the example as written, make the sample files in an empty directory:

```bash title="Make sample data"
--8<-- "docs/snippets/workflows/sample-data.sh"
```

Then save the job script for your cluster as `array.sub` in the same directory. The `#SBATCH`
lines differ by cluster; the rest of the script is the same on every cluster.

=== "Anvil"

    ```bash title="array.sub"
    --8<-- "docs/snippets/workflows/job_arrays/header-anvil.sh"
    --8<-- "docs/snippets/workflows/job_arrays/body.sh"
    ```

=== "Gautschi"

    ```bash title="array.sub"
    --8<-- "docs/snippets/workflows/job_arrays/header-gautschi.sh"
    --8<-- "docs/snippets/workflows/job_arrays/body.sh"
    ```

=== "Negishi"

    ```bash title="array.sub"
    --8<-- "docs/snippets/workflows/job_arrays/header-negishi.sh"
    --8<-- "docs/snippets/workflows/job_arrays/body.sh"
    ```

=== "Scholar"

    ```bash title="array.sub"
    --8<-- "docs/snippets/workflows/job_arrays/header-scholar.sh"
    --8<-- "docs/snippets/workflows/job_arrays/body.sh"
    ```

Replace `myallocation` with your own account: `slist` lists your accounts on Gautschi and
Negishi, and `mybalance` lists your allocations on Anvil. On Scholar the account is always
`scholar`. On Gautschi and Negishi you can use `--qos=standby` instead of `--qos=normal` to run on
idle nodes for up to four hours without drawing on your account, at a lower priority. Each
cluster's queues page lists its partitions and limits:
[Anvil](../userguides/anvil/jobs.md#anvil-queues-partitions),
[Gautschi](../userguides/gautschi/run_jobs/queues.md),
[Negishi](../userguides/negishi/run_jobs/queues.md) and
[Scholar](../userguides/scholar/run_jobs/queues.md). Every partition on Gilbreth is a GPU
partition, so this CPU example has no Gilbreth tab.

Submit the array, then watch its tasks. The `-r` option to `squeue` shows each array task on its
own line:

```bash
sbatch array.sub
squeue -u $USER -r
```

When the array finishes, `results/` holds one `.count` file per input, and each task has left its
own `array-<jobid>_<index>.out` file.

## Checking results and re-running failures

Slurm records how each array task ended. List them with `sacct`, replacing `<jobid>` with the ID
that `sbatch` printed:

```bash
sacct -j <jobid> -X --format=JobID,State,ExitCode
```

Each array task appears on its own line as `<jobid>_<index>`, with a state such as `COMPLETED`,
`FAILED` or `TIMEOUT`. To re-run only the tasks that failed, pass their indices on the command
line. An option given to `sbatch` overrides the matching `#SBATCH` line in the script, so this runs
tasks 5 and 12 alone:

```bash
sbatch --array=5,12 array.sub
```

To cancel a single task, name it as `<jobid>_<index>`:

```bash
scancel <jobid>_<index>
```

This works, but each step is yours to do by hand. You read the `sacct` table, pick out the failed
indices, and build the resubmission yourself. A rerun is a new job with a new ID, so its record is
separate from the first run's.

## Checking your limits

Every array task counts toward the scheduler's per-user limits on running and queued jobs, and the
size of an array is capped. These commands show the limits that apply on the cluster you are
logged in to:

```bash
scontrol show config | grep -i MaxArraySize
sacctmgr show qos format=Name,MaxJobsPU,MaxSubmitPU
```

The largest array index you can use is one less than `MaxArraySize`. `MaxJobsPU` and
`MaxSubmitPU` are the per-user limits on running jobs and on running plus queued jobs for each
QOS. An empty field means that QOS sets no limit of its own. Anvil also lists per-partition job
limits in its [queue table](../userguides/anvil/jobs.md#anvil-queues-partitions). Limits change,
so check them on the cluster rather than relying on a number written down elsewhere.

## Arrays in a pipeline

A job can wait for a whole array with `--dependency=afterok:<jobid>`, which starts it only after
every task in the array has succeeded. If any task fails, the dependent job never starts and stays
pending with the reason `DependencyNeverSatisfied` until you cancel it. See
[Job Dependencies](../userguides/gautschi/run_jobs/job_dependencies.md) in the Gautschi user guide
for the dependency types Slurm offers.

## Where job arrays win

- **Nothing to install or learn beyond Slurm.** Every RCAC user already has them.
- **Each task is a scheduler job**, with its own resources, its own output file, its own
  accounting record and its own `scancel`.
- **The right size for tens to a few hundred uniform tasks**, each long enough that queue wait
  and job start-up are small next to its run time.

## When to move to HyperShell

Arrays stop serving well as tasks become many, short or numerous enough that you need a record:

- **Many short tasks.** Each array task waits in the queue and starts as its own job. When a task
  runs for seconds and the wait is minutes, most of the campaign's elapsed time is waiting.
- **Limits.** Every task counts toward your job limits and the array size cap. A campaign of many
  thousands of tasks needs several arrays, submitted as earlier ones drain.
- **The record.** `sacct` tells you each task's state, but finding the failures, resubmitting
  them, and keeping track across reruns is manual work.

HyperShell takes over here. It runs the whole task list inside one job, or a few, on as many nodes
as you give it. Its database records every task: where it ran, how long it took and its exit
status. A rerun continues where the last one stopped, and a single command re-queues exactly the
failed tasks. RCAC recommends it for this work; see
[RCAC recommends HyperShell](index.md#rcac-recommends-hypershell) for why. The HyperShell User
Guide in this section starts with one job script that runs a whole task list this way.

For more examples of job arrays on RCAC clusters, see the
[array jobs section of Running Bioinformatics Programs on RCAC](../lifesciences/guides/running-bioinformatics.md#array-jobs)
and the
[job arrays section of the HPC Exchange workshop](../workshops/hpc_exchange/week4/workload-management.md#slurm-job-arrays).

[Back to Workflow Automation](index.md){ .md-button }
