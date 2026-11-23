---
title: "Tier 4: Autoscaling Clients Across Clusters"
tags:
  - Workflows
  - HyperShell
authors:
  - glentner
search:
  boost: 2
---

# Tier 4: Autoscaling Clients Across Clusters

[A Persistent Service on Geddes](geddes_service.md) leaves you with a HyperShell server and its
database running on Geddes, waiting for work. This page connects clusters to it. On each cluster,
one process, a HyperShell **relay**, runs on the cluster's `login00` node: it takes tasks from the
server and starts clients in Slurm jobs to run them. The server decides how many clients each zone
needs at each cluster, and the relays carry out its plan, so clients appear when work is waiting
and leave when it is done. You start with Gautschi, submit a night of the survey with zones and task
groups, and then add Negishi with the same script.

## Who this is for

Readers who have deployed the service on Geddes and want it to run work on one or more clusters
without submitting client jobs by hand.

## Move on when

This is the top tier. To run the same work on another cluster, add a relay there, as this page does
for Negishi.

## Minimum version

HyperShell 2.9.0, for the relay, zones, and autoscaling across relay sites. Task groups date from
2.8.0. The module on each cluster must have the same version as the server's image on Geddes;
check with `hs --version`, and see [HyperShell versions](index.md#hypershell-versions).

## How the work reaches the clusters

| Who | Decides or does what |
|---|---|
| You, on Gautschi's `login00` | Submit each night's tasks to the database with `hs submit`, each with a group and a zone |
| The server, on Geddes | Hands out the tasks of the current group. Once a minute, it counts the work waiting in each zone and plans how many clients each cluster should run for it, within the bounds each relay gives |
| The relay, on each cluster's `login00` | Takes tasks for the zones it serves, starts or lets go of clients to match the server's plan, and returns the results |
| Each client, in a Slurm job | Connects to its own cluster's relay, runs tasks, and exits after ten idle minutes, which ends its job |

The relay starts each client with `srun`, as one Slurm job. `srun` stays in the foreground for as
long as the client runs, which is how the relay knows which of its clients are still running.
`sbatch` returns as soon as the job is queued, so the relay would take every client for one that had
already ended; never use it as the relay's launcher.

The relay never ends a client to shrink a zone. When the plan for a zone goes down, for example
because the zone's group has finished, the relay starts no more clients there, and the ones it has
exit on their own once they have had nothing to do for ten minutes.

The relay runs on `login00` of each cluster. That is a design choice: one host per cluster for the
service's persistent, low-CPU coordination process, so that you always know where it is. The relay
spends nearly all its time waiting: the tasks themselves run only in client jobs on compute nodes.

The queue key stays on `login00`. The relay proves itself to the server with the key, but its own
clients get a different key that the relay makes for each run, so the survey's key never reaches a
compute node or a task.

## Set up the relay on Gautschi

### The survey directory

Log in to Gautschi's `login00`, where you made the credentials on the previous page, and load the
module:

```bash
ssh login00.gautschi.rcac.purdue.edu
module load hypershell
cd $HOME/survey
```

By the end of this section, the survey directory holds:

| File | What it is |
|---|---|
| `run-relay.sh` | The script that starts the relay |
| `submit-night.sh` | The script that submits a night's tasks (Gautschi only) |
| `hypershell/relay.toml` | The relay's configuration |
| `hypershell/database.toml` | The database's address, from the previous page (Gautschi only) |
| `hypershell/upstream.key`, `hypershell/db.password` | The key and the database password, readable only by you (the password on Gautschi only) |
| `hypershell/relay.log`, `hypershell/relay.pid` | The relay's log and its process ID, written by `run-relay.sh` |

### The relay's configuration

Save the configuration for your cluster as `hypershell/relay.toml`. Replace `myallocation` with your
own account and `<your-namespace>` with your Geddes namespace. In the fingerprint, keep `SHA256:` and
replace the text in angle brackets with the colon-separated digits that `openssl` printed after
`Fingerprint=` when you made the certificate.

=== "Gautschi"

    ```toml title="hypershell/relay.toml"
    --8<-- "docs/snippets/workflows/survey/relay-gautschi.toml"
    ```

=== "Negishi"

    ```toml title="hypershell/relay.toml"
    --8<-- "docs/snippets/workflows/survey/relay-negishi.toml"
    ```

| Setting | What it does |
|---|---|
| `relay.site` | The cluster's name in the server's plan and log. |
| `relay.num_threads` | How many tasks each client runs at once. It is the same for every zone a relay serves, so each zone's Slurm request below is sized around it. |
| `relay.timeout` | Seconds a client waits with nothing to do before it exits. |
| `relay.launcher` | The command that starts each client: `srun`, followed by the zone's `launcher_args` and then the client's own command. |
| `relay.upstream.host`, `relay.upstream.port` | The server's service on Geddes. |
| `relay.upstream.auth_eval` | A command whose output is the queue key, run each time the relay starts. A relay reads its key only from this setting (or `relay.upstream.auth`, or the `HYPERSHELL_RELAY_UPSTREAM_AUTH` variable), never from a command line. |
| `relay.upstream.tls.fingerprint` | The server's certificate fingerprint. The relay refuses a server whose certificate does not match it. |
| `[relay.zone.cpu]`, `[relay.zone.gpu]` | One table per zone the relay serves. `launcher_args` is the zone's Slurm request; `max` is the most clients the server's plan may give the zone on this cluster. |

The two zones ask Slurm for different hardware:

- **`cpu`**: 4 cores on a standard node in the `cpu` partition, enough for the client's 4 tasks.
- **`gpu`**: one H100 in Gautschi's `ai` partition, with 14 cores, the number of cores the `ai`
  partition requires for each GPU. The client's 4 tasks share the GPU, as on the
  [GPU multiplexing](gpu_multiplexing.md) page, which shows how to measure how many tasks a GPU can
  take. `max = 2` keeps the zone within the two GPUs that every group may use at once under the
  `normal` QOS; a group that has bought more GPUs may use more.

Clients connect to the relay on port 50002 of `login00`, which the relay opens when it starts. The
connection is encrypted with a certificate the relay makes for itself under `hypershell/lib/tls/`;
its clients find it there, because compute nodes see the same home directory.

### The relay script

Save the script as `run-relay.sh` in the survey directory:

```bash title="run-relay.sh"
--8<-- "docs/snippets/workflows/survey/run-relay.sh"
```

It sets the same two variables as every script in this guide, so that the relay reads
`hypershell/relay.toml` and nothing else. `nohup … &` starts the relay in the background and keeps it
running after you log out, and `$!` is the process ID of the command just started in the background,
which the script keeps in `hypershell/relay.pid`.

### Start the relay

Start the relay once, on `login00`, with the module loaded:

```bash
bash run-relay.sh
```

Run only one relay per cluster: before starting it again, check that the
last one has stopped (see [Keep the relays running](#keep-the-relays-running)).

The relay connects to the server and waits for a plan. Its log, `hypershell/relay.log`, shows each
zone it serves (`Upstream identity … for zone cpu at site gautschi`), the connection to the server,
`Upstream server publishes a topology - site clients follow it` and `Relay-local server ready on
0.0.0.0:50002`. On Geddes, the server's log shows `Relay site registered (site: gautschi, zone:
cpu, min: 0, init: 0, max: 8, clients: 0)`, and the same for `gpu`. With no work waiting, the plan
gives every zone zero clients, and no job starts.

## Submit a night: groups and zones together

The survey's data lives on [Data Depot](../../userguides/depot/index.md), which every cluster mounts at the
same path, so that a field calibrated on one cluster can be detected on another. Make a directory
there for the survey, such as `/depot/mygroup/survey` with your group's name, and save in it three
stand-ins for the survey's steps. Each waits a few seconds, as if working, and writes a small text
file that records the cluster and the node that ran it. Set `survey` in each to your directory.

=== "calibrate.sh"

    ```bash title="calibrate.sh"
    --8<-- "docs/snippets/workflows/survey/calibrate.sh"
    ```

=== "detect.sh"

    ```bash title="detect.sh"
    --8<-- "docs/snippets/workflows/survey/detect.sh"
    ```

=== "catalog.sh"

    ```bash title="catalog.sh"
    --8<-- "docs/snippets/workflows/survey/catalog.sh"
    ```

Then save the submission script as `submit-night.sh` in the survey directory on `login00`, with
`survey` set to the same Depot directory:

```bash title="submit-night.sh"
--8<-- "docs/snippets/workflows/survey/submit-night.sh"
```

Each phase's group is the night's date followed by the phase number: `${night}0` is the value of
`night` with a `0` after it, such as `202611230`; the braces mark where the variable's name ends. A standing server orders all the work it holds by
group, across nights, so this numbering makes every night's phases come after the night before's.
Had every night used groups 0, 1 and 2, the server would still be on group 2 when the next night
arrived, and it would run that night's catalog first.

When a night's images are in, submit the night:

```bash
bash submit-night.sh 20261123
```

`hs submit` writes 24 calibrations in zone `cpu`, 24 detections in zone `gpu`, and one catalog in
zone `cpu`, in the night's three groups. Then the service takes over:

1. The calibrations are in the lowest group, and only zone `cpu` has work in it. Within a minute,
   the server plans one `cpu` client, and the relay starts it with `srun`. While the tasks wait, the
   server adds one client a minute, up to the zone's `max`.
2. When every calibration has finished, the detections' group starts. Its tasks are in zone `gpu`,
   so the plan moves: `gpu` clients start in the `ai` partition, and the `cpu` clients, with nothing
   to do, exit after ten minutes.
3. When every detection has finished, the catalog's group starts, and the catalog runs on a `cpu`
   client: one still running, or a new one.

You can submit the next night while this one runs: its groups are higher, so it waits its turn.
Submitting the same night twice is refused, because `hs submit` refuses a task file it has already
submitted; the `&&` in the script then submits nothing more. A failed calibration holds the
detections until you settle it, as in tier 3; see [When a task fails](#when-a-task-fails).

## Follow the night

As in tier 3, every command that reads the record runs with the two variables set, here for the
database on Geddes. On Gautschi's `login00`, count the tasks of each phase that are not finished:

```bash
cd $HOME/survey
export HYPERSHELL_SITE=$HOME/survey/hypershell
export HYPERSHELL_CONFIG_FILE=$HYPERSHELL_SITE/database.toml
hs list --group 202611230 --remaining --count
hs list --group 202611231 --remaining --count
hs list --group 202611232 --remaining --count
```

The client jobs are ordinary Slurm jobs, named for their zone:

```bash
squeue --user=$USER --name=survey-cpu,survey-gpu
```

When the last count is 0, the catalog is written. Read it, and the catalog task's line in the
record, with its exit status:

```bash
cat /depot/mygroup/survey/nights/20261123/catalog.txt
hs list args exit_status --group 202611232
```

`hs list client_host` shows which node ran each task. HyperShell keeps no copy of a task's output in
this setup: what a task prints goes to `hypershell/relay.log` on the cluster that ran it. So the
stand-ins record the cluster and node in each file they write, and the catalog task's count of the
fields each cluster calibrated is in that relay's log.

## Add a second cluster

To bring Negishi in, run the same script on Negishi's `login00`, with its own configuration. Nothing
you submit changes: a zone names a kind of hardware, not a cluster, so the `cpu` tasks of every night
can now run on either cluster.

1. Log in to `login00.negishi.rcac.purdue.edu`, load the module, and make the survey directory:

    ```bash
    module load hypershell
    mkdir -p $HOME/survey/hypershell
    cd $HOME/survey
    ```

2. Copy the queue key from Gautschi. Negishi's home directory is not Gautschi's, so print the key on
   Gautschi's `login00` with `cat hypershell/upstream.key`, and on Negishi make an empty file that
   only you can read and paste the key into it with a text editor, such as `nano`:

    ```bash
    touch hypershell/upstream.key
    chmod 600 hypershell/upstream.key
    nano hypershell/upstream.key
    ```

3. Save the Negishi configuration from [the relay's configuration](#the-relays-configuration) as
   `hypershell/relay.toml`, and `run-relay.sh` as above.
4. Start the relay: `bash run-relay.sh`.

Negishi's relay serves zone `cpu` only. Its GPUs are AMD, and this survey's detection step, like the
rest of this guide's GPU material, is written for NVIDIA GPUs, so the `gpu` zone stays on Gautschi.
The server now plans the `cpu` zone over two clusters, up to 8 clients on each, and the `gpu` zone
over Gautschi alone. Negishi needs no database settings: you submit and follow the work from
Gautschi's `login00` as before. The next night's catalog counts the fields each cluster calibrated.

### Spread or fill

How the server shares a zone's clients between clusters is the `autoscale.distribution` setting,
which you gave the server on Geddes as the variable `HYPERSHELL_AUTOSCALE_DISTRIBUTION`:

| Value | What the server does | Use it when |
|---|---|---|
| `spread` | Gives each new client to the cluster that runs the fewest clients in that zone, so both clusters grow together | You want the work done soon, wherever there is room |
| `fill` | Gives each new client to the first cluster in order that is below its `max`, and only then to the next | One cluster costs your group less, for example where it has cores to spare |

For `fill`, set the order with a second variable, `HYPERSHELL_AUTOSCALE_SITES`, a comma-separated
list of site names, such as `negishi,gautschi`; sites not listed come after, in the order they
first connected. To change either, edit the workload in Rancher, change the `server` container's
variables, and save. The pod restarts with the new setting; the relays reconnect on their own, and
any task cut off by the restart runs again.

## When a task fails

A failed task holds the next group, exactly as in [tier 3](pipelines.md#when-a-task-fails). On
Gautschi's `login00`, with the two variables set, find the failed tasks, fix the cause, and run them
again, or cancel them so that the next group can start:

```bash
hs list id args exit_status --failed
hs update --failed --revert
```

`hs update` changes the tasks in the database. The server hands a reverted task to a relay that
serves its zone, and the plan brings up a client for it if none is running.

## Keep the relays running

The relay keeps running after you log out. To check it on a cluster's `login00`, give its process ID
to `ps`, which prints a line for the relay if it is running:

```bash
ps -p $(cat $HOME/survey/hypershell/relay.pid)
```

- **After `login00` restarts**, the relay is gone. Log in, load the module, and run
  `bash run-relay.sh` again. Clients that were still running carry on with their tasks. A relay
  started while an old one still runs takes over the cluster's place in the plan, and the old one
  hands back its unstarted tasks and exits.
- **For maintenance**, drain the relay. The signal `USR1` tells it to take no more work, let its
  clients finish the tasks it holds, return every result, and exit; check with `ps` until it has.
  Meanwhile the server plans the zone over the other clusters.

    ```bash
    kill -s USR1 $(cat $HOME/survey/hypershell/relay.pid)
    ```

- **To stop at once**, `kill $(cat $HOME/survey/hypershell/relay.pid)` ends the relay and its
  clients' jobs. The server notices that the relay has gone, after ten minutes without contact, and
  sets its unfinished tasks to run again elsewhere.

If the server on Geddes restarts, or the network drops for a while, the relay keeps its clients
running, keeps their results, and reconnects on its own. For upgrades, backups and new keys, see
[Operate and maintain](geddes_service.md#operate-and-maintain).

For everything a relay can do, see the
[`hs relay` reference](https://hypershell.readthedocs.io/cli/relay.html) in HyperShell's
documentation.

[Back to HyperShell User Guide](index.md){ .md-button }
