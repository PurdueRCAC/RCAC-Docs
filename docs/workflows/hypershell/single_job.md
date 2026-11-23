---
title: "Tier 1: One Job Script"
tags:
  - Workflows
  - HyperShell
authors:
  - glentner
search:
  boost: 2
---

# Tier 1: One Job Script

This page gives you one Slurm job script that runs a whole list of commands with HyperShell, on one
node or several. When the job stops early, because it reached its walltime or you cancelled it, you
submit the same script again and it carries on with only the work that is left. When it is done,
HyperShell tells you which tasks failed, and re-runs exactly those when you ask. This one job
script covers most of what researchers need from a workflow tool; the later tiers of this guide are
for work that has outgrown it.

## Who this is for

Anyone with a list of independent commands, from hundreds to hundreds of thousands, that fits in
one Slurm job or a few resubmissions of it. Each command must be able to run on its own, in any
order. That describes most many-task work, so it describes most readers.

## Move on when

Your work has phases that must run in order, needs different hardware for different phases, is
submitted bit by bit over days, or has more tasks than one job can get through. If your tasks each
use only part of a GPU, read [GPU Multiplexing](gpu_multiplexing.md) next; for the rest, see
[the tiers](index.md#the-tiers).

## Minimum version

HyperShell 2.9.0. Earlier versions do not accept a task file together with `--restart`, which
this script depends on. Check with `hs --version`; see
[HyperShell versions](index.md#hypershell-versions).

## The example: rendering an animation

A lab is making an animation of a simulation for a talk: 1,200 frames, 50 seconds of film at
24 frames a second. Each frame is rendered on its own, by one command, and no frame depends on
another. In real work each command would run a renderer, such as Blender or POV-Ray, on the scene
file for one frame and write one image, and might take several minutes. Here a short shell script,
`render-frame.sh`, stands in for the renderer. It waits 20 seconds, as if it were rendering,
then writes a small greyscale image of a moving gradient, so you can run the whole example on any
cluster without special software.

Make a new directory on your scratch space and work there. Your scratch directory is
`$RCAC_SCRATCH` on Gautschi, Negishi and Scholar, and `$SCRATCH` on Anvil. Save the stand-in
renderer in that directory as `render-frame.sh`:

```bash title="render-frame.sh"
--8<-- "docs/snippets/workflows/frames/render-frame.sh"
```

The `awk` program at the end only draws the image; you do not need to follow it to use the
example.

Then make the task file. HyperShell's task file is plain text with one command per line, so this
writes the 1,200 render commands, `sh render-frame.sh 1` to `sh render-frame.sh 1200`. `seq -f`
writes one line per number, with the number in place of `%g`:

```bash
seq -f 'sh render-frame.sh %g' 1 1200 > frames.txt
```

Your own task file is the list of commands you would otherwise type one at a time, written by
whatever means suits you: a loop, a spreadsheet export, or a short script.

## The job script

Save the job script for your cluster as `frames.sub` in the same directory. The `#SBATCH` lines
differ by cluster; the rest of the script is the same on every cluster.

=== "Anvil"

    ```bash title="frames.sub"
    --8<-- "docs/snippets/workflows/frames/header-anvil.sh"
    --8<-- "docs/snippets/workflows/frames/body.sh"
    ```

=== "Gautschi"

    ```bash title="frames.sub"
    --8<-- "docs/snippets/workflows/frames/header-gautschi.sh"
    --8<-- "docs/snippets/workflows/frames/body.sh"
    ```

=== "Negishi"

    ```bash title="frames.sub"
    --8<-- "docs/snippets/workflows/frames/header-negishi.sh"
    --8<-- "docs/snippets/workflows/frames/body.sh"
    ```

=== "Scholar"

    ```bash title="frames.sub"
    --8<-- "docs/snippets/workflows/frames/header-scholar.sh"
    --8<-- "docs/snippets/workflows/frames/body.sh"
    ```

The header asks for two whole nodes, with one Slurm task per node holding all of that node's
cores. Replace `myallocation` with your own account, and see
[Slurm Job Arrays](../job_arrays.md#a-worked-example) for how to find your account, for
`--qos=standby` on Gautschi and Negishi, and for links to each cluster's partitions and limits. On
Anvil, the `wholenode` partition gives you whole nodes. Scholar's `cpu` partition has nodes with
64 and with 128 cores, so its tab asks for 64 cores per node, which fits either kind. Every
partition on Gilbreth is a GPU partition, so this CPU example has no Gilbreth tab.

The body does three things:

- **`export HYPERSHELL_SITE=…`** gives this campaign its own HyperShell directory, `hypershell/`,
  beside the job script. It holds the database that records every task, HyperShell's logs, and
  each task's captured output. Every job you submit from this directory uses the same database,
  and that shared record is what lets a resubmission continue where the last job stopped.
- **`hs --version`** writes the HyperShell version into the job's output file, so you know which
  version ran.
- **`hsx frames.txt …`** runs the task file. `hsx` starts a HyperShell server inside the job and a
  client on every node, and the clients run the tasks.

The `hsx` options are these:

| Option | What it does |
|---|---|
| `frames.txt` | The task file, one command per line. |
| `--restart` | Continue the campaign recorded in the database. Tasks that finished in an earlier job are skipped; the rest run. On the first job, every task runs. |
| `--capture` | Keep each task's standard output and standard error in its own pair of files under `hypershell/`, so you can read them later with `hs info`. |
| `--launcher="srun …"` | Start the clients with `srun`, which starts one per Slurm task: one per node here. `--cpus-per-task` gives each client all of its node's cores. |
| `-N "${SLURM_CPUS_PER_TASK}"` | The number of tasks each client runs at once (its *executors*): one per core here. |

To use one node, change `--nodes=2` to `--nodes=1`; to use more, raise it. Nothing else changes.
If each of your commands uses several cores, as many renderers do, divide the executors to match:
for example, for commands that use four cores each on Gautschi's 192-core nodes, replace
`-N "${SLURM_CPUS_PER_TASK}"` with `-N 48`.

## Run it

Submit the job from the campaign directory:

```bash
sbatch frames.sub
```

While the job runs, each finished frame appears as `frames/frame_NNNN.pgm`, and the job's output
file, `slurm-<jobid>.out`, logs a line as each task starts. The job ends when every frame has run.

## When the job stops early

A job can stop before every task has run. It reaches its walltime, or you cancel it with
`scancel`, or the node fails. Submit the same script again, unchanged:

```bash
sbatch frames.sub
```

With `--restart`, HyperShell reads the task file and the database and runs only the work that is
left. The tasks that never started run now, and so do the tasks that were cut off when the job
stopped, because they never finished. Every task that finished in an earlier job is skipped,
**whether it succeeded or failed**: HyperShell does not re-run a failed task on its own. Re-running
failures is a deliberate step, described below. You can resubmit as often as you need to, and if
every task has already run, the job finds nothing to do and ends at once.

## Check which tasks succeeded or failed

A failed frame does not fail the job. The job runs every frame it can, and Slurm reports the job
as completed even when some frames failed. The database records how each task ended, and the `hs`
commands below ask it. Run them on a login node, in the campaign directory, after setting
`HYPERSHELL_SITE` to the same directory the job used:

```bash
module load hypershell
export HYPERSHELL_SITE="$PWD/hypershell"
```

Then count the tasks by outcome:

```bash
hs list --succeeded --count
hs list --failed --count
hs list --remaining --count
```

These print the number of tasks that succeeded, that failed (finished with a non-zero exit status),
and that have not finished. To see which tasks failed, name the fields to print:

```bash
hs list id args exit_status --failed
```

Each line shows a task's ID, its command and its exit status:

```text
07cdea93-7e71-41d4-b977-aacf01825dd7    sh render-frame.sh 5     1
2203ac7b-a60e-4dc9-943e-5ace26025da9    sh render-frame.sh 17    1
```

To find out why a task failed, print the error output it left, using its ID:

```bash
hs info 07cdea93-7e71-41d4-b977-aacf01825dd7 --stderr
```

Without `--stderr`, `hs info` prints the task's whole record: where and when it ran, how long it
took, and how it ended. `hs list` without `--count` or field names prints whole records too, and
`hs list --fields` lists every field you can name.

## Re-run the failures

First fix whatever made the tasks fail. Then mark the failed tasks as not yet run, and submit the
job script again:

```bash
hs update --failed --revert
sbatch frames.sub
```

`hs update` counts the tasks it is about to change and asks you to confirm; answer `yes`. With
`--revert`, each failed task keeps its ID and command but is reset as if it had never run, so the
resubmitted job runs those tasks and nothing else.

!!! tip "Retrying failures automatically"

    For failures that come and go, such as a brief filesystem error, you can add `-r 2` to the
    `hsx` line to retry a failed task up to two more times within the same job. Each retry is a new
    task record, so `hs list --failed` then also lists the failed first attempts of tasks that a
    retry finished, and `hs update --failed --revert` would run those again. Use one approach or the
    other in a campaign.

## Adding tasks later

HyperShell remembers the task file it was given. If you change `frames.txt`, the next job stops at
once with an error that says the file changed and names `--update --restart`, rather than guessing
which tasks are new. To add
frames, append their commands to `frames.txt` and change `--restart` to `--update --restart` in
the job script. HyperShell then submits only the new lines, and runs them along with any work that
is left. The script keeps working with `--update --restart` when the file does not change.

## Make it yours

To run your own work, replace `frames.txt` with your own task file, and keep each line a complete
command that can run on its own from the campaign directory. Set the walltime, node count and
executors for the size of your work, as described under [The job script](#the-job-script). Start
each new campaign in a new directory, so that it gets its own `hypershell/` directory and its own
record.

Scratch storage is not backed up and is purged after a period of inactivity. When a campaign is
finished, copy its results, and the `hypershell/` directory if you want to keep the record, to
permanent storage.

For everything `hsx` can do, see the
[`hs cluster` reference](https://hypershell.readthedocs.io/cli/cluster.html) in
HyperShell's documentation.

[Back to HyperShell User Guide](index.md){ .md-button }
