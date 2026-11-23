---
title: GNU Parallel
tags:
  - Workflows
  - GNU Parallel
authors:
  - glentner
search:
  boost: 2
---

# GNU Parallel

GNU Parallel runs shell commands in parallel. You give it a command template and a list of inputs,
and it runs the command once per input, keeping as many running at once as you allow. Of the tools
in this section it is the closest to HyperShell in feel: the work is a shell command, and the list
of tasks is a list of inputs. It needs no server or setup, and it has the richest input templating
of any tool here.

GNU Parallel is a module on Anvil, Gautschi, Gilbreth and Negishi; load it with
`module load parallel`. Scholar has no GNU Parallel module. Versions differ by cluster: see the
[GNU Parallel catalog page](../software/apps_md/parallel.md), or run `module spider parallel` on the
cluster. The project's documentation is at
[gnu.org/software/parallel](https://www.gnu.org/software/parallel/).

## The work it fits

GNU Parallel fits a few thousand quick, independent commands inside one job on one node. Inside a
job, it turns a list of inputs into a stream of tasks that keeps every core busy, without
submitting a scheduler job per task.

Its templating is what sets it apart. In a command, `{}` stands for the input, `{.}` for the input
without its extension, `{/}` for the input's file name without its directory, and `{/.}` for the
file name without directory or extension. Inputs can come from a file (`::::`), from a list on the
command line (`:::`), or from several lists at once, in which case GNU Parallel runs every
combination. The [GNU Parallel tutorial](https://www.gnu.org/software/parallel/parallel_tutorial.html)
covers these in depth.

## A worked example

This example counts the words in every file named in `inputs.txt`, one task per file, writing one
`results/<name>.count` file per input. Counting words is a stand-in for your own per-file command.
The same sample files appear in the [Slurm job array](job_arrays.md) and [GNU Make](gnu_make.md)
examples, so you can compare the three tools on the same work.

To try the example as written, make the sample files in an empty directory:

```bash title="Make sample data"
--8<-- "docs/snippets/workflows/sample-data.sh"
```

Then save the job script for your cluster as `parallel.sub` in the same directory. The `#SBATCH`
lines differ by cluster; the rest of the script is the same on every cluster.

=== "Anvil"

    ```bash title="parallel.sub"
    --8<-- "docs/snippets/workflows/gnu_parallel/header-anvil.sh"
    --8<-- "docs/snippets/workflows/gnu_parallel/body.sh"
    ```

=== "Gautschi"

    ```bash title="parallel.sub"
    --8<-- "docs/snippets/workflows/gnu_parallel/header-gautschi.sh"
    --8<-- "docs/snippets/workflows/gnu_parallel/body.sh"
    ```

=== "Negishi"

    ```bash title="parallel.sub"
    --8<-- "docs/snippets/workflows/gnu_parallel/header-negishi.sh"
    --8<-- "docs/snippets/workflows/gnu_parallel/body.sh"
    ```

The job asks for one task with 16 cores on one node, and `--jobs "${SLURM_CPUS_PER_TASK}"` keeps up
to that many commands running at once. Raise `--cpus-per-task` for more parallelism, up to the
cores of one node. In the command, `{}` is the input path (`data/sample_07.txt`) and `{/.}` is its
bare name (`sample_07`). Replace `myallocation` with your own account, and see
[Slurm Job Arrays](job_arrays.md#a-worked-example) for how to find your account and for links to
each cluster's partitions. Every partition on Gilbreth is a GPU partition, so this CPU example has
no Gilbreth tab, and Scholar has no tab because it has no GNU Parallel module.

Submit the job with `sbatch parallel.sub`. When it finishes, `results/` holds one `.count` file per
input, and `parallel.log` holds one line per task.

## Resuming and re-running failures

The `--joblog` file is GNU Parallel's record of a run. It has a header line and then one
tab-separated line per finished task. Its columns include the task's sequence number, start time,
run time, exit status (`Exitval`, the seventh column) and command. To list the tasks that failed:

```bash
awk -F '\t' 'NR > 1 && $7 != 0' parallel.log
```

The job log also makes a run resumable on one node. GNU Parallel offers three options that read it
when you run the same command again:

| Option | On a rerun, GNU Parallel |
|---|---|
| `--resume` | skips every task already in the job log, whatever its exit status, and runs the rest |
| `--resume-failed` | runs the tasks the job log records as failed, then the tasks not yet run |
| `--retry-failed` | runs only the tasks the job log records as failed, taking their commands from the log |

The example script uses `--resume-failed`. If the job reaches its walltime or some tasks fail,
fix the cause and submit the same script again: tasks that succeeded are skipped, and the failed
and unfinished ones run. Within a single run, `--retries N` retries a failing task up to `N` times
before recording it as failed.

GNU Parallel matches tasks between runs by their sequence number, which is their position in the
input. Keep the input list, the command and the job log file unchanged between runs. If you edit or
reorder `inputs.txt`, the numbers no longer point at the same tasks, and a resumed run can skip or
repeat the wrong ones.

## Where GNU Parallel wins

- **Zero setup.** Load the module and run. There is no server, no database and no configuration.
- **Templating.** Replacement strings and combinations of input lists turn a short command line
  into thousands of tasks.
- **Resume and re-run on one node.** With `--joblog`, `--resume` and `--resume-failed`, a
  single-node job picks up where it stopped and re-runs its failures.

## When to move to HyperShell

GNU Parallel stops serving well when the work outgrows one node or one job:

- **More than one node.** GNU Parallel can run tasks on other machines over SSH
  (`--sshloginfile`), but inside a Slurm job that means building a host list from the job's nodes
  and relying on SSH between them, which is more fragile than staying on one node.
- **A record you can query.** The job log is a flat file in one directory, tied to one input list.
  Asking which tasks failed across several runs, or how long a whole class of tasks took, means
  writing your own scripts over those files.
- **Workers that come and go.** A run lives inside one job. It cannot take on more nodes from a
  second job while it runs, or hand unfinished work to another job.

HyperShell takes over here. Its clients run on as many nodes as you give it, in one job or across
several, and they can join and leave while the work runs. Every task, with its exit status, run
time and host, is a row in a database you can query with `hs list` and `hs info`. A rerun
continues where the last one stopped, and failed tasks can be re-queued with one command. RCAC
recommends HyperShell for flat many-task work; see
[RCAC recommends HyperShell](index.md#rcac-recommends-hypershell) for why. The HyperShell User
Guide in this section starts with one job script that runs a whole task list this way.

[Back to Workflow Automation](index.md){ .md-button }
