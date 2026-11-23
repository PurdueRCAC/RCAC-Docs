---
title: "Tier 3: A Pipeline on One Cluster"
tags:
  - Workflows
  - HyperShell
authors:
  - glentner
search:
  boost: 2
---

# Tier 3: A Pipeline on One Cluster

In [tier 1](single_job.md), one job script holds everything: the server, the clients, the task file
and the database all live and die with the job. That stops fitting when your work comes in
**phases**: when one step must finish for every sample before the next step can start, when
different steps need different hardware, and when the work arrives over days rather than all at
once. This page takes the pieces of tier 1 apart. A server that you start once runs on a login
node, with a database and a configuration file chosen on purpose. You submit each phase of the
work to it from the login node. Clients run in batch jobs that a small helper script submits as
the work needs them. **Task groups** put the phases in order, and **zones** send each phase to
the hardware it needs.

## Who this is for

Groups whose work has distinct phases with different hardware needs, and which outlives any one
job, all on one cluster.

## Move on when

The pipeline should run as a standing service that nobody has to start, scale its own clients, or
span more than one cluster. Tier 4 covers that; see [the tiers](index.md#the-tiers).

## Minimum version

HyperShell 2.9.0, for zones and for the refusal of a submission below the reached group (see
[Task groups](#task-groups-when-a-task-may-run)). Task groups date from 2.8.0, and reading the key
with a command from the configuration file (`auth_eval`) from 2.8.7. Check with `hs --version`;
see [HyperShell versions](index.md#hypershell-versions).

## The example: genotyping a crop diversity panel

A plant genomics group genotypes a diversity panel: many inbred lines of one crop, each sequenced
on its own. The sequencing center returns the lines in batches, days apart. The pipeline has three
phases:

| Phase | Tasks | Needs | Group | Zone |
|---|---|---|---|---|
| Align | One per line of the panel, run as each batch arrives | A standard CPU node | 0 | `cpu` |
| Genotype | One per region of the genome, each reading every line | More memory per core than a standard node has | 1 | `highmem` |
| Merge | One, combining every region | A standard CPU node | 2 | `cpu` |

Genotyping a region compares every line of the panel at once, so no region can start until the
last line is aligned, and the merge cannot start until the last region is done. That is what the
groups express. The genotype step needs more memory per core than a standard node gives, so it
runs on high-memory nodes. That is what the zones express.

In real work, each task would run an aligner or a variant caller for minutes to hours. Here three
short shell scripts, `align.sh`, `genotype.sh` and `merge.sh`, stand in for the three steps. Each
waits a few seconds, as if working, and writes small text files, so you can run the whole example
on any cluster without special software. This example has 96 lines in two batches of 48 and a genome cut into 24 regions; a real
panel has several hundred lines.

## How the pieces fit

| Piece | Where it runs | What it does |
|---|---|---|
| Campaign directory | Scratch | Holds the scripts, the inputs and outputs, and `hypershell/`: the configuration, the key, the database and the logs |
| Server | One login node, for the life of the campaign | Holds the queue, hands tasks to clients, and records every result in the database |
| `hs submit` | The same login node, when a phase is ready | Writes a phase's tasks into the database, with its group and zone |
| `schedule-clients.sh` | The same login node, in a loop | Submits client jobs for a zone that has work waiting |
| Client jobs | Compute nodes, in batch jobs | Connect to the server over the network and run the tasks of their zone |

Everything that reads or writes the database runs on one host: the server, `hs submit`, and the
commands you use to follow the work, such as `hs list`. Clients never open the database; they talk
to the server.

This page runs the server on `login00.gautschi.rcac.purdue.edu`. That is a design choice: one host
per cluster for the campaign's persistent, low-CPU coordination processes, here the server and the
helper loop, so that you always know where they are. The tasks themselves run only in client jobs
on compute nodes. On another cluster, choose one of its login nodes in the same way and use its full
host name throughout.

## Groups and zones

Groups and zones are the two new ideas in this tier. A group says *when* a task may run; a zone
says *where*.

### Task groups: when a task may run

Every task has a group number, 0 unless you give another with `hs submit --group`. The server runs
the groups in ascending order: it starts no task of a group until every task of every lower group
has finished. Within a group, tasks run in any order. Groups act as barriers between phases.

Use groups when a step needs the output of a whole earlier step, as genotyping needs every
alignment. You can submit a later phase as soon as you know its tasks; the server holds it until
its turn. Tasks that only need their own earlier step, one sample at a time, do not need groups:
put both steps in one command instead.

Two rules follow from the barrier:

- **A failed task holds the next group.** If a task in group 0 fails, the server does not start
  group 1. It waits until you re-run the failed task or cancel it, as described in
  [When a task fails](#when-a-task-fails). A cancelled task counts as finished.
- **A late submission below the reached group is refused.** The *reached group* is the highest
  group from which the server has sent a task to a client. Until every task in the database has
  finished, `hs submit` refuses tasks for any group below it, and submits nothing:
  `Task group 0 is below the reached group 1 of the database (nothing submitted)`. So submit the
  genotype phase only after the last batch of lines is in: once genotyping is under way, a late
  batch of alignments is refused.

### Zones: where a task may run

A zone is a name you give to a kind of client. `hs submit --zone highmem` puts tasks in the
`highmem` zone, and only a client started with `hs client --zone highmem` runs them. A client with
no zone runs only tasks with no zone. Zones place tasks; they do not order them.

Use zones when different phases need different hardware. On Slurm, a zone usually means a
partition: here, `cpu` tasks run in client jobs on standard nodes, and `highmem` tasks in client
jobs on the high-memory partition. The zone names are yours to choose; HyperShell does not look
at partition names. It is `schedule-clients.sh` that turns a zone into a partition when it submits
a client job.

Zones and groups work together. The server hands out only the tasks of the current group, and only
to clients of each task's zone. While genotyping runs, `cpu` clients get no work, and they exit on
their own after ten idle minutes; one that is still running when the merge's turn comes runs it.

## Set up the campaign

### Log in to the server's login node

Log in to Gautschi, then to its `login00` node, where the server and every `hs` command of this
campaign will run:

```bash
ssh login00.gautschi.rcac.purdue.edu
```

### Make the campaign directory

Make a directory on your scratch space and set the two variables that every step of this page
uses. `HYPERSHELL_SITE` names the campaign's HyperShell directory, `hypershell/`, which holds its
database, logs and captured task output, as in tier 1. `HYPERSHELL_CONFIG_FILE` names the
configuration file, so that HyperShell reads that file and no other, whatever your own HyperShell
configuration says.

```bash
module load hypershell
mkdir -p $RCAC_SCRATCH/panel/hypershell
cd $RCAC_SCRATCH/panel
export HYPERSHELL_SITE="$PWD/hypershell"
export HYPERSHELL_CONFIG_FILE="$HYPERSHELL_SITE/config.toml"
```

The scripts on this page set the same two variables themselves, from the directory they run in. Run
them from the campaign directory. When you log in again later, repeat the `cd` and the two `export`
lines before running any `hs` command.

Save the stand-ins for the three steps as `align.sh`, `genotype.sh` and `merge.sh`:

```bash title="align.sh"
--8<-- "docs/snippets/workflows/panel/align.sh"
```

```bash title="genotype.sh"
--8<-- "docs/snippets/workflows/panel/genotype.sh"
```

```bash title="merge.sh"
--8<-- "docs/snippets/workflows/panel/merge.sh"
```

Then write the two batches of line names that the sequencing center would send, `L001` to `L048`
and `L049` to `L096`:

```bash
seq -f 'L%03g' 1 48 > batch-1.txt
seq -f 'L%03g' 49 96 > batch-2.txt
```

### Make the key

In this tier you run the server yourself, so you supply the key that clients prove themselves with.
Make an empty key file that only you can read, then write a random key into it:

```bash
touch hypershell/auth.key
chmod 600 hypershell/auth.key
openssl rand -hex 32 > hypershell/auth.key
```

The configuration file below reads the key from this file each time HyperShell starts. The key is
never in the configuration file, and never on a command line, where other users of the login node
could read it in the process list.

### Write the configuration file

Save this as `hypershell/config.toml`:

```toml title="hypershell/config.toml"
--8<-- "docs/snippets/workflows/panel/config.toml"
```

| Setting | What it does |
|---|---|
| `database.provider` | The kind of database. SQLite keeps the whole database in one file, here `hypershell/lib/main.db`, which is all one campaign on one host needs. |
| `server.bind` | The addresses the server listens on. `0.0.0.0` means every network interface of the login node, so that compute nodes can reach it. |
| `server.host` | The host name clients connect to: the login node the server runs on. Change it if you choose another login node. |
| `server.port` | The port the server listens on and clients connect to. Every HyperShell server uses 50001 unless told otherwise, so choose your own number on a shared login node. If another program already uses it, the server stops at start (see [Start the server](#start-the-server)); choose another. |
| `server.auth_eval` | A command whose output is the key. HyperShell runs it each time a server or client starts. |

Because the file uses `auth_eval`, it needs HyperShell 2.8.7 or later; an older module stops at
start when it reads it (see [HyperShell versions](index.md#hypershell-versions)). Only commands
run with this campaign's two variables read this file, so your other HyperShell work is not
affected.

The connection between server and clients is encrypted. The server makes its own certificate the
first time it starts, under `hypershell/lib/tls/`, and clients trust it because they find the same
file in the same campaign directory on scratch. There is nothing more to set up.

To check what HyperShell will use, ask for a setting's value. The second command prints the
database file, `hypershell/lib/main.db` under your campaign directory:

```bash
hs config get server.host
hs config get database.file
```

### Create the database

```bash
hs initdb
```

With SQLite, HyperShell would create the database on first use anyway. Running `hs initdb` now
creates the file and proves that the configuration works before anything depends on it.

## Start the server

Start the server in the background, so that it keeps running after you log out, and note its
process ID for later:

```bash
nohup hs server --forever > hypershell/server.log 2>&1 &
echo $! > hypershell/server.pid
```

`nohup` and the `&` at the end run the server in the background, with its messages in
`hypershell/server.log`, and `$!` is the process ID of the command just started. With `--forever`, the server never stops on its own when it runs out of tasks: it waits for the
next phase. Check its log, `hypershell/server.log`. The first time the server starts, the log
records the certificate it made, then `Server listening on 0.0.0.0:50101`. If it ends instead with
`Cannot listen on 0.0.0.0:50101` and `Address already in use`, another program has that port:
change `server.port` in the configuration file and start the server again. The server uses little
CPU: it spends nearly all its time waiting for clients and for new tasks.

## Submit the phases

`hs submit` writes tasks straight into the database; it does not need the server or the key. Each
phase is one `hs submit` command, with the phase's group and zone. When the first batch of lines
arrives, submit its alignments:

```bash
hs submit --group 0 --zone cpu --template 'sh align.sh {}' batch-1.txt
```

`--template 'sh align.sh {}'` makes one task from each line of `batch-1.txt`, with the line in
place of `{}`: `sh align.sh L001`, `sh align.sh L002`, and so on. `hs submit` refuses to submit the
same file twice, so running the command again by mistake does no harm.

When the second batch arrives, submit it the same way. Then, with every line in, submit the last
two phases: one genotyping task per region of the genome, `01` to `24`, and the one merge task. The
server holds them until their turn:

```bash
hs submit --group 0 --zone cpu --template 'sh align.sh {}' batch-2.txt
seq -w 1 24 > regions.txt
hs submit --group 1 --zone highmem --template 'sh genotype.sh {}' regions.txt
hs submit --group 2 --zone cpu sh merge.sh
```

The last command submits a single task, the command that follows the options. To see what was
submitted, list each task's group, zone and command with `hs list group zone args`.

The tasks wait in the database until a client of their zone connects. The server's log says so:
`Task group 0 waiting on zone cpu: 96 tasks, no client serving it`.

## Schedule client jobs

### The client job script

Each client job runs one HyperShell client on one node, for one zone. Save the job script for your
cluster as `client.sub` in the campaign directory. The `#SBATCH` lines differ by cluster; the rest
of the script is the same on every cluster.

=== "Anvil"

    ```bash title="client.sub"
    --8<-- "docs/snippets/workflows/panel/header-anvil.sh"
    --8<-- "docs/snippets/workflows/panel/body.sh"
    ```

=== "Gautschi"

    ```bash title="client.sub"
    --8<-- "docs/snippets/workflows/panel/header-gautschi.sh"
    --8<-- "docs/snippets/workflows/panel/body.sh"
    ```

=== "Negishi"

    ```bash title="client.sub"
    --8<-- "docs/snippets/workflows/panel/header-negishi.sh"
    --8<-- "docs/snippets/workflows/panel/body.sh"
    ```

=== "Scholar"

    ```bash title="client.sub"
    --8<-- "docs/snippets/workflows/panel/header-scholar.sh"
    --8<-- "docs/snippets/workflows/panel/body.sh"
    ```

The header asks for one whole node, in the partition for the `cpu` zone. Replace `myallocation`
with your own account; see [the tier 1 job script](single_job.md#the-job-script) for notes on each
cluster's partitions. You do not submit this script yourself: `schedule-clients.sh` does, with the
zone on the command line and the partition for that zone's jobs.

| Option | What it does |
|---|---|
| `--zone "${zone}"` | Run only the tasks of this zone. The zone comes from the command line. |
| `--capture` | Keep each task's output in its own files under `hypershell/`, for `hs info`. |
| `-N "${SLURM_CPUS_PER_TASK}"` | Run one task per core of the node at once. |
| `-T 600` | Exit after 600 seconds (10 minutes) with no task to run. A client whose zone has no work in the current group ends its job instead of holding the node. |

The client finds the server, the port and the key in `hypershell/config.toml`, through the two
variables the script sets.

### The helper script

`schedule-clients.sh` looks at the work waiting in the current group for one zone and submits a
client job to match: up to two jobs for a zone that has work, never more jobs than tasks, and none
for a zone with nothing to do. Save it in the campaign directory:

```bash title="schedule-clients.sh"
--8<-- "docs/snippets/workflows/panel/schedule-clients.sh"
```

It finds the current group with `hs list`, counts that group's unfinished tasks in the zone, and
counts the client jobs you already have for the zone with `squeue`, by their job name,
`panel-cpu` or `panel-highmem`. It submits nothing while a lower group holds a failed task,
because the server will not start the current group until that is settled. Each run submits at
most one job, so a zone reaches `MAX_JOBS` over several runs rather than all at once. To keep more
client jobs per zone, change `MAX_JOBS=2` at the top of the script.

The script takes two words on its command line: the zone, and the partition for that zone's client
jobs. On Gautschi and Negishi:

```bash
sh schedule-clients.sh cpu cpu
```

```text
Group 0, zone cpu: 96 tasks waiting, 0 client jobs
Submitted batch job 4205133
```

The partitions differ by cluster:

- **`cpu` zone:** the partition in your `client.sub`: `cpu` on Gautschi, Negishi and Scholar, and
  `wholenode` on Anvil.
- **`highmem` zone:** `highmem` on Anvil, Gautschi and Negishi. On Gautschi and Negishi it accepts
  only the `normal` QOS, which their `client.sub` already names, and only jobs that use a large
  share of a node's cores (more than 48 of 192 on Gautschi, more than 64 of 128 on Negishi); a whole
  node qualifies. On Anvil, `highmem` jobs are charged at four times the rate of `wholenode` jobs.
  Scholar has no high-memory partition: there, give `cpu` for the `highmem` zone as well.

The script does not check that the server is running. If it is not, the client jobs it submits find
no server to connect to and end; start the server first. Tasks in a zone you do not name on its
command line get no client jobs.

Then leave the helper running in a loop on the login node, for both zones, once every five
minutes, so that each phase gets its clients as soon as its turn comes. Save the loop as
`keep-scheduling.sh`, with the partitions for your cluster:

```bash title="keep-scheduling.sh"
--8<-- "docs/snippets/workflows/panel/keep-scheduling.sh"
```

Start it in the background, as you started the server:

```bash
nohup sh keep-scheduling.sh > hypershell/scheduler.log 2>&1 &
echo $! > hypershell/scheduler.pid
```

## Follow the pipeline

Every command in this section reads the database, so run it on the server's login node, in the
campaign directory, with the two variables set. Count the tasks of each phase by outcome with the
`--group` option:

```bash
hs list --group 0 --succeeded --count
hs list --group 1 --remaining --count
hs list --failed --count
```

To see each phase at a glance, list the group and zone of every unfinished task, and let `sort`
and `uniq -c` count the lines that are the same:

```bash
hs list group zone --remaining --all | sort | uniq -c
```

The merge is one task, the last of the campaign. To wait until it has run, print its ID, then give
the ID to `hs wait`, which returns when the task has finished:

```bash
hs list id --group 2
hs wait <id>
```

When it has run, `panel-calls.txt` holds every call: 24 regions × 96 lines, 2,304 lines. The merge
task's output counts the lines in each region's file, 96 each, and the total; print it with
`hs info <id> --stdout`, using the merge task's ID.

## When a task fails

A failed task does not stop the other tasks of its group. When the rest of the group has finished,
though, the server does not move on. Its log says why:
`Failed task group 0 (at least 1 tasks exceeding allowed retries, …)`. `schedule-clients.sh` reports
the same, and submits no client jobs for the next group. Find the failed tasks and why they failed:

```bash
hs list id args exit_status --failed
hs info <id> --stderr
```

Then settle them in one of two ways. Fix the cause and re-run them; a client of their zone that is
still running picks them up, and otherwise the helper submits one on its next pass:

```bash
hs update --failed --revert
```

Or, if a task cannot succeed, such as a line whose sequencing failed, cancel it, and the next group
starts without it:

```bash
hs update --failed --cancel
```

`hs update` counts the tasks it is about to change and asks you to confirm; answer `yes`. A
cancelled task keeps an exit status of -1, so `hs list --failed` still counts it; `hs list
--cancelled` lists only the cancelled ones.

## Stop and restart

Between campaigns, or for maintenance of the login node, stop the helper loop and then the server:

```bash
kill $(cat hypershell/scheduler.pid)
kill -s USR1 $(cat hypershell/server.pid)
```

`SIGUSR1` tells the server to stop scheduling, tell its clients to finish and exit, and then exit
itself. The database keeps the whole record. To carry on later, log in to the same login node, set
the two variables in the campaign directory, and start the server and the helper loop again as
above. When the server starts, any task that was cut off is set to run again.

When the campaign is finished, copy `panel-calls.txt`, and `hypershell/` if you want to keep the
record, to permanent storage: scratch is not backed up and is purged after a period of inactivity.

## When the campaign outgrows one cluster

One SQLite file on one host is enough for a campaign that runs on one cluster and is driven from
one login node. When the work should run as a standing service, with a database that several hosts
can reach and that keeps months of history, the step up is PostgreSQL, and the server moves off
the login node. Tier 4 runs the server and a PostgreSQL (TimescaleDB) database as a persistent
service on Geddes, with clients that scale themselves on more than one cluster.

For everything `hs submit`, `hs server` and `hs client` can do, see the
[`hs submit` reference](https://hypershell.readthedocs.io/cli/submit.html),
[`hs server` reference](https://hypershell.readthedocs.io/cli/server.html) and
[`hs client` reference](https://hypershell.readthedocs.io/cli/client.html) in HyperShell's
documentation.

[Back to HyperShell User Guide](index.md){ .md-button }
