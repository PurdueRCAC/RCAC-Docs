---
title: "Tier 2: Extreme Scale"
tags:
  - Workflows
  - HyperShell
authors:
  - glentner
search:
  boost: 2
---

# Tier 2: Extreme Scale

The [tier 1](single_job.md) job script runs on many nodes as it stands: raise `--nodes` and it
starts one more client for each node. What it does not do is cut the cost HyperShell adds to each
task. That cost is small, a few round trips between client and server, a database write, a log
line, and is invisible when tasks take minutes. When tasks take a second or two and there are
millions of them, it can rival the work itself. This page describes the HyperShell options and
practices for that kind of run.

Purdue workloads rarely need this page. Most campaigns on RCAC's clusters, even large ones, run
well with the tier 1 script. The page is written so that it also serves as guidance for running
HyperShell at a leadership-class computing facility, where one job can span hundreds or thousands
of nodes.

## Who this is for

Readers with millions of tasks lasting seconds each, or anyone running HyperShell at a
leadership-class facility.

## Move on when

Throughput is fine with the defaults: then go back to [tier 1](single_job.md), which is simpler.
If your problem is structure rather than scale, such as phases that must run in order or need
different hardware, see [the tiers](index.md#the-tiers).

## Minimum version

HyperShell 2.9.0, the version this guide documents. Most options on this page are older: bundling,
staggered starts, running without a database and loading tasks with `hs submit` date from 2.0.0,
dropping confirmations from 2.2.0, and task timeouts from 2.4.0. Check with `hs --version`; see
[HyperShell versions](index.md#hypershell-versions).

## Where the time goes

For every task, HyperShell's server picks the task from the database and sends it to a client; the
client starts it, logs that it started, waits for it, and sends the result back; the server writes
the result to the database. With default settings, much of this happens one task at a time. The
options on this page change that:

- **Bundling** moves tasks and results in groups instead of one at a time.
- **One client per node, with many executors,** keeps the number of connections to the server small.
- **Staggered starts** spread the moment thousands of clients first connect.
- **Quiet logging and aggregated output** avoid writing a log line and two files for every task.
- **Running without the database** removes the database write, at the cost of the record.

## The example: a million-member climate ensemble

A climate group studies how uncertain a model's warming is. It runs a simple energy-balance model
a million times, each member with a different value of one uncertain parameter, and looks at the
spread of the results. Each member is one short command. In real work a member might run for a
second or two; here a short shell script, `member.sh`, stands in for the model and runs in a few
milliseconds, so a run of the example shows mostly HyperShell's own cost per task. Each member
prints one line: its number, its parameter, and its warming.

Make a new directory on your scratch space and work there. Save the stand-in as `member.sh`:

```bash title="member.sh"
--8<-- "docs/snippets/workflows/ensemble/member.sh"
```

Write the task file, one member per line, `sh member.sh 1` to `sh member.sh 1000000`:

```bash
seq 1000000 | sed 's/^/sh member.sh /' > members.txt
```

### Load the tasks once

In tier 1, each job reads the task file and checks it against the database. That check is quick,
but with a million lines HyperShell's documentation recommends a different route for very large
runs: load the task file into the database once, with `hs submit`, and have each job run
`hsx --restart` with no task file, so that it takes up whatever is left. On a login node, in the
campaign directory:

```bash
module load hypershell
export HYPERSHELL_SITE="$PWD/hypershell"
hs submit -b 10000 members.txt
```

`hs submit` writes the tasks straight into the campaign's database. `-b 10000` writes them in
groups of 10,000; without it, each task is a separate write. Like `hsx`, `hs submit` refuses to load the same file twice, so running it again
by mistake does no harm.

## The job script

Save the job script for your cluster as `ensemble.sub` in the same directory. The `#SBATCH` lines
differ by cluster; the rest of the script is the same on every cluster.

=== "Anvil"

    ```bash title="ensemble.sub"
    --8<-- "docs/snippets/workflows/ensemble/header-anvil.sh"
    --8<-- "docs/snippets/workflows/ensemble/body.sh"
    ```

=== "Gautschi"

    ```bash title="ensemble.sub"
    --8<-- "docs/snippets/workflows/ensemble/header-gautschi.sh"
    --8<-- "docs/snippets/workflows/ensemble/body.sh"
    ```

=== "Negishi"

    ```bash title="ensemble.sub"
    --8<-- "docs/snippets/workflows/ensemble/header-negishi.sh"
    --8<-- "docs/snippets/workflows/ensemble/body.sh"
    ```

=== "Scholar"

    ```bash title="ensemble.sub"
    --8<-- "docs/snippets/workflows/ensemble/header-scholar.sh"
    --8<-- "docs/snippets/workflows/ensemble/body.sh"
    ```

The header has the same shape as tier 1's, with four whole nodes and four hours. Replace
`myallocation` with your own account, and see [the tier 1 job script](single_job.md#the-job-script)
for notes on each cluster's partition. Every partition on Gilbreth is a GPU partition, so this CPU
example has no Gilbreth tab.

The body sets two environment variables and runs `hsx`:

- **`HYPERSHELL_SITE`** keeps the campaign's database and logs in `hypershell/` beside the script,
  as in tier 1. It must name the same directory you used with `hs submit`.
- **`HYPERSHELL_LOGGING_LEVEL=warning`** turns off the line HyperShell logs as each task starts. At
  a million tasks, those lines alone would fill a file of about 70 MB. Warnings and errors still
  appear in the job's output file.

| Option | What it does |
|---|---|
| `--restart` | With no task file: run whatever the database holds that has not finished. |
| `--launcher="srun …"` | As in tier 1: start one client per node, with all of the node's cores. |
| `-N "${executors}"` | Executors per client: one per core. |
| `-b "${executors}"` | Bundle size. Each client asks for this many tasks at a time and sends results back in bundles of the same size. |
| `-w 30` | Bundle wait: a client sends back a part-full bundle of results after 30 seconds rather than wait for it to fill. |
| `--delay-start=-30` | Each client waits a random time of up to 30 seconds before it connects. Write it with `=`, because the value starts with `-`. |
| `-W 300` | Task timeout: a member still running after 300 seconds is stopped and recorded as failed. |
| `> "ensemble-${SLURM_JOB_ID}.txt"` | Without `--capture`, each task's output goes to its client's output, which `srun` passes back to `hsx`. This collects every member's result line in one file per job. |

## Run it

Submit the job from the campaign directory:

```bash
sbatch ensemble.sub
```

If the job reaches its walltime before every member has run, submit it again, unchanged, as in
tier 1; each job runs only what is left. Check progress from a login node with the same
`HYPERSHELL_SITE`:

```bash
hs list --succeeded --count
hs list --failed --count
hs list --remaining --count
```

When every member has run, combine the jobs' result files:

```bash
sort -n -u -k1,1 ensemble-*.txt > ensemble.txt
wc -l < ensemble.txt
```

A job that stops early can leave a few result lines for members whose results had not yet reached
the database. Those members run again in the next job and print their line a second time. Each
line starts with its member number, so `sort -u -k1,1` keeps one line per member. Give your own
tasks' output a key of this kind.

## Practices for very large runs

### Bundle tasks and results

With the default bundle size of 1, every task and every result is its own message, and the server
writes each result to the database on its own. Raise `-b` to match the number of executors in each
client, as the script does, so that each request fills a client's executors at once. Raise `-w` so
that most bundles of results go back full; it only matters near the end of a run or when tasks are
uneven. The server never hands a client more than 1,000 tasks in one reply, whatever its `-b`.

### One client per node, many executors

Every client holds a connection to the server. Run one client per node, with an executor per core,
as the script does, rather than one client per core. HyperShell's documentation states that it
scales to more than 1,000 nodes and 250,000 executors.

### Stagger client starts

When a job starts, every node's client tries to connect at the same moment. `--delay-start` with a
negative value spreads that over a random interval. HyperShell's documentation suggests a delay of
about one task length at large scale: for 30-minute tasks on 1,000 nodes, `--delay-start=-1800`.
For tasks of seconds, a few tens of seconds is enough to smooth the connections.

### Keep output out of per-task files

`--capture` writes two files for every task, two million files for a million tasks: avoid it at this
scale, and avoid having each task write its own small file on a parallel filesystem. Have each task
print a short result line, and collect the lines as the script does. If tasks must write files,
write them to the node's local disk (`/tmp`) during the job and copy them to scratch in a few large
pieces at the end.

### Keep logging quiet

At the default level, HyperShell logs one line for every task that starts. Set
`HYPERSHELL_LOGGING_LEVEL=warning` at scale, as the script does. To keep a full record of a run for
debugging, enable HyperShell's file logging instead (see
[logging](https://hypershell.readthedocs.io/logging.html) in HyperShell's documentation).

### Choose the database on purpose

The script keeps the default database, a SQLite file under `HYPERSHELL_SITE`, which is all one
campaign run from one directory needs; it is what lets a resubmitted job continue. `hs list`
refuses to print more than 1,000 records unless you add `--all` or `--limit`, so ask it for counts,
as above, or pass `--all` when you mean it. For a campaign that runs for weeks, or whose tasks
are submitted from more than one host, a PostgreSQL database is the better home; tier 4 sets one
up.

Without a database, HyperShell sends tasks straight from the task file to the clients. Nothing is
written per task, but nothing is recorded either: no `--restart`, no `hs list`, no retries, and a
resubmitted job starts the whole file again. Add `--no-confirm` as well, which stops clients from
confirming each bundle they receive; HyperShell then also cannot recover the tasks of a client
that is lost. In the script, the `hsx` line becomes:

```bash
hsx members.txt --no-db --no-confirm \
    --launcher="srun --cpus-per-task=${SLURM_CPUS_PER_TASK}" \
    -N "${executors}" -b "${executors}" -w 30 \
    --delay-start=-30 -W 300 \
    > "ensemble-${SLURM_JOB_ID}.txt"
```

The result file is then the only record of what ran. Use this only when each job can finish its
whole task file: split a larger list into several task files, one per job. Setting HyperShell's
database file to `:memory:` has the same effect as `--no-db`.

### Bound each task

`-W` stops a task that runs too long, so one stuck task cannot hold an executor until the job ends.
The timeout signals the shell that runs the task; a task that starts other programs in the
background, or in a pipeline, can leave them running. Make each task one program where you can, as
`member.sh` does by starting `awk` with `exec`.

### Requeue rather than run forever

Split a long campaign into jobs of a few hours and resubmit the same script, rather than asking for
the longest walltime a partition allows. Shorter jobs start sooner, and each resubmission picks up
where the last one stopped.

### Know how a lost client is handled

Each client sends the server a heartbeat every 10 seconds. A client that is silent for 10 minutes
is evicted, and the tasks it held go back to the queue, unless `--no-confirm` is in use.

## Running at a leadership-class facility

The same script carries over to the large national computing facilities, with a few changes. Read
the facility's own user guide first; these points are general practice, not any one site's rules.

- **The server stays inside the job.** `hsx` runs its server on the job's first node, so the clients
  need only reach that node. Compute nodes at large facilities often cannot reach login nodes or
  the internet, and this layout does not need them to.
- **Use the site's launcher.** `--launcher` takes the whole launch command, so give it whatever
  the site uses to start one process per node, such as `srun` or `mpiexec` with the options for
  one process per node; `--mpi` is short for `--launcher=mpirun`. The launcher must
  pass the job's environment to the clients, because that is how `hsx` hands them the key to its
  queue: with `srun`, do not add `--export=NONE`.
- **Mind the filesystem.** Parallel filesystems at these sites serve thousands of users at once.
  Keep the task count per file and the file count per task low, as described above, and put the
  HyperShell site directory on the scratch or project filesystem the site recommends for job I/O.
- **Install HyperShell where the compute nodes can see it**, from the site's module, a Python
  environment on a shared filesystem, or a container, following the site's guidance. HyperShell's
  [installation guide](https://hypershell.readthedocs.io/install.html) lists the options.
- **Measure before the big run.** Run a few thousand tasks on a few nodes, compute tasks per
  second as below, and scale up only once the number holds as you add nodes.

## Measure throughput

To see what bundling buys for your tasks, run a sample of a few thousand tasks once with the
script's settings and once with `-b 1` and without `-w`, each in a fresh campaign directory. For each
job, divide the number of tasks that succeeded by how long the job ran:

```bash
sacct -j <jobid> -X --format=JobID,Elapsed
hs list --succeeded --count
```

As an illustration, the stand-in ensemble on two Gautschi nodes, with 32 cores each, ran:

| Settings | Members | Tasks per second |
|---|---|---|
| The script as published (`-b` and `-w` set) | 20,000 | about 310 |
| Defaults (no `-b` or `-w`) | 20,000 | about 47 |
| Without the database (`--no-db --no-confirm`) | 100,000 | about 1,300 |

Each run's time includes up to 30 seconds of `--delay-start`, and the members do almost no work, so
these figures show HyperShell's own cost per task on a small run. They are illustrations, not
benchmarks: your tasks, node count and filesystem will give other numbers.

Throughput that does not rise when you add nodes means the server, the database or the filesystem
has become the limit, not the nodes. Larger bundles, or running without the database, are then the
remaining options.

For everything `hsx` can do, see the
[`hs cluster` reference](https://hypershell.readthedocs.io/cli/cluster.html) in
HyperShell's documentation.

[Back to HyperShell User Guide](index.md){ .md-button }
