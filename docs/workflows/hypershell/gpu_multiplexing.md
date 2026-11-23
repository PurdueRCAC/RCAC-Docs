---
title: GPU Multiplexing
tags:
  - Workflows
  - HyperShell
authors:
  - glentner
search:
  boost: 2
---

# Running Many Small Tasks on Large GPUs

A modern data-center GPU has tens of gigabytes of memory and thousands of cores. Many research
tasks need only a fraction of that: training a small model, running a short inference batch, or
rendering a small scene. Run one such task per GPU and most of the GPU sits idle, while you pay for
all of it. This page shows how to run several tasks at once on each GPU of a job with HyperShell,
using the same kind of job script as [tier 1](single_job.md) plus one short wrapper script.

## Who this is for

Readers who have used [Tier 1: One Job Script](single_job.md) and whose tasks each use only part of
a large GPU: small models, short inference runs or small renders.

## Move on when

Each task fills a GPU on its own. Then give each task a whole GPU (this page with one task per GPU),
or, for one model spread across several GPUs, use a distributed-training tool instead. For phases
that need different hardware, see [the tiers](index.md#the-tiers).

## Minimum version

HyperShell 2.9.0, for executor slots and for a task file together with `--restart`. Check with
`hs --version`; see [HyperShell versions](index.md#hypershell-versions).

## How tasks share a GPU

In tier 1, one HyperShell client on each node runs as many tasks at once as it has *executors*,
set with `-N`. Each executor has a fixed number, its *slot*, from 0 up to one less than the number
of executors. HyperShell gives every task its executor's slot in the `TASK_SLOT` environment
variable. That is all a task needs to pick a GPU without colliding with its neighbours.

The pattern on this page:

- The job asks Slurm for *n* GPUs on one node. Slurm lists them in the `CUDA_VISIBLE_DEVICES`
  environment variable.
- One client runs *n* × *k* executors, where *k* is the number of tasks you want on each GPU at
  once.
- A wrapper script, `gpu-pick.sh`, runs each task with `CUDA_VISIBLE_DEVICES` narrowed to one of
  the job's GPUs, chosen by its slot. Slot *s* gets GPU number *s* mod *n*, so each GPU always has
  *k* executors.

HyperShell itself does not know about GPUs. It does not set `CUDA_VISIBLE_DEVICES`, and it does not
track GPU memory: its `-c` and `-m` options describe CPU cores and host memory only. The number of
executors and the wrapper are what control how tasks share the GPUs.

Another layout gives each GPU its own client: a launcher such as `srun` starts one client per GPU,
Slurm hands each client one GPU, and each client runs *k* executors. That layout needs no wrapper,
but it is not shown or tested here.

When several processes use one NVIDIA GPU in its default mode, the GPU takes turns between them
rather than running their work at the same instant. Sharing pays off because small tasks leave the
GPU idle much of the time: while one task prepares its next batch of data on the CPU, or reads and
writes files, another task's work runs on the GPU. The more time each task spends away from the GPU,
the more tasks one GPU can serve before they start waiting on each other.

## The example: a sweep of small climate emulators

A climate group trains small machine-learning emulators that stand in for an expensive model
component. To choose the network's size and learning rate, it trains 64 of them, one per
combination of settings. Each training run needs about a gigabyte of GPU memory and spends most of
its time preparing data on the CPU, so one run uses a small fraction of a GPU.

In real work, each task would run a training script, such as `python train.py --width 64 --lr 0.003`.
Here a small CUDA program, `emulator`, stands in for it, so you can run the example with nothing but
the CUDA compiler. Each run holds 1 GiB of GPU memory and does 50 "training steps", each a short
burst of GPU work followed by a pause, as if the CPU were preparing the next batch. When it
finishes, it writes one line to `results/member_NNNN.txt` saying which GPU it ran on, which executor
slot ran it, and how long it took.

Make a new directory on your scratch space and work there. Save the stand-in as `emulator.cu`:

```cuda title="emulator.cu"
--8<-- "docs/snippets/workflows/gpu_sweep/emulator.cu"
```

Build it once, on a login node, with the CUDA compiler from the `cuda` module. On Anvil, run
`module load modtree/gpu` first.

```bash
module load cuda
nvcc -O2 -o emulator emulator.cu
```

Save the wrapper as `gpu-pick.sh` in the same directory:

```bash title="gpu-pick.sh"
--8<-- "docs/snippets/workflows/gpu_sweep/gpu-pick.sh"
```

Then write the task file, one training run per line, `./emulator 1` to `./emulator 64`:

```bash
printf './emulator %d\n' $(seq 1 64) > sweep.txt
```

## The job script

Save the job script for your cluster as `gpu_sweep.sub` in the same directory. The `#SBATCH` lines
differ by cluster; the rest of the script is the same on every cluster.

=== "Anvil"

    ```bash title="gpu_sweep.sub"
    --8<-- "docs/snippets/workflows/gpu_sweep/header-anvil.sh"
    --8<-- "docs/snippets/workflows/gpu_sweep/body.sh"
    ```

=== "Gautschi"

    ```bash title="gpu_sweep.sub"
    --8<-- "docs/snippets/workflows/gpu_sweep/header-gautschi.sh"
    --8<-- "docs/snippets/workflows/gpu_sweep/body.sh"
    ```

=== "Gilbreth"

    ```bash title="gpu_sweep.sub"
    --8<-- "docs/snippets/workflows/gpu_sweep/header-gilbreth.sh"
    --8<-- "docs/snippets/workflows/gpu_sweep/body.sh"
    ```

=== "Scholar"

    ```bash title="gpu_sweep.sub"
    --8<-- "docs/snippets/workflows/gpu_sweep/header-scholar.sh"
    --8<-- "docs/snippets/workflows/gpu_sweep/body.sh"
    ```

Each header asks for two GPUs on one node, with one Slurm task that holds all of the job's CPU
cores. Replace `myallocation` with your own account. The GPU partitions differ by cluster:

- **Anvil:** the `gpu` partition has four NVIDIA A100 GPUs and 128 cores per node, so two GPUs come
  with 64 cores. GPU software on Anvil is visible only after `module load modtree/gpu`. See
  [Anvil's queues](../../userguides/anvil/jobs.md#anvil-queues-partitions).
- **Gautschi:** the `ai` partition has eight NVIDIA H100 GPUs per node. A job there must ask for
  exactly 14 CPU cores per GPU, so two GPUs need 28 cores; Slurm rejects other ratios. Each GPU
  hour is charged to your account, which is one more reason to keep each GPU busy. The `ai`
  partition does not offer the `standby` QOS. See
  [Gautschi's queues](../../userguides/gautschi/run_jobs/queues.md#ai-partition).
- **Gilbreth:** the partition chooses the GPU type; `a100-80gb` nodes have two NVIDIA A100 GPUs and
  32 or 64 cores, so the tab asks for 32 cores, which fits either kind. GPU jobs on Gilbreth must
  state their memory. Use `--qos=standby` for jobs of up to four hours that do not draw on your
  account's GPUs. See [Gilbreth's queues](../../userguides/gilbreth/run_jobs/queues.md).
- **Scholar:** the `gpu` partition mixes nodes with different kinds and numbers of GPUs. Asking for
  two GPUs and 16 cores fits every node with at least two. See
  [Scholar's queues](../../userguides/scholar/run_jobs/queues.md#gpu-partition).

Negishi's GPUs are AMD, not NVIDIA, so this page, which relies on `CUDA_VISIBLE_DEVICES` and
`nvidia-smi`, has no Negishi tab.

The body does what tier 1's does, with three additions:

- **`echo` and `nvidia-smi --query-gpu=…`** write the job's GPUs into the job's output file: the
  list Slurm gave the job, then a table with each GPU's index, PCI bus address, model, memory and
  compute mode.
- **The sampling loop** records, every 10 seconds, which processes are running on each GPU and how
  much GPU memory each one holds, in `gpu-use-<jobid>.txt`. It is how you see the sharing happen,
  and how you check memory before raising *k*.
- **`hsx sweep.txt …`** runs the task file with these options:

| Option | What it does |
|---|---|
| `sweep.txt` | The task file, one training run per line. |
| `--restart` | As in tier 1: a resubmitted job runs only what is left. |
| `--capture` | As in tier 1: keep each task's output and errors for `hs info`. |
| `-t 'sh gpu-pick.sh {}'` | A *template*: run each line of the task file through `gpu-pick.sh`. HyperShell replaces `{}` with the line. |
| `-N "$(( gpus * tasks_per_gpu ))"` | The number of executors: the number of GPUs times the number of tasks to run on each at once. |

The number of tasks on each GPU comes from the `TASKS_PER_GPU` environment variable, and is 4 when
it is not set. There is no `--launcher` option: with one node, `hsx` runs its one client itself, on
the job's node, where Slurm has set `CUDA_VISIBLE_DEVICES`.

## Run it

Submit the job from the campaign directory:

```bash
sbatch gpu_sweep.sub
```

The job ends when every training run has finished. Then look at the results:

```bash
cat results/member_*.txt
```

Each line names the GPU a run used (by its PCI bus address, as in the table at the top of the job's
output file), the executor slot that ran it, and how many seconds it took. With two GPUs and four
tasks per GPU, slots 0, 2, 4 and 6 run on the first GPU and slots 1, 3, 5 and 7 on the second.
Each GPU gets close to half of the runs, but not always exactly half: an executor takes the next run
as soon as it is free, so the split depends on timing (34 and 30 in one test). `gpu-use-<jobid>.txt`
shows four processes on each GPU at a time while the job runs.

Checking which runs failed, re-running them, and resubmitting after the walltime all work exactly
as in tier 1: see [Check which tasks succeeded or failed](single_job.md#check-which-tasks-succeeded-or-failed)
and [Re-run the failures](single_job.md#re-run-the-failures).

## Choose how many tasks share a GPU

The right number of tasks per GPU depends on your tasks, so measure it rather than guess. Run the
same sweep with one, two and four tasks per GPU, each in a fresh copy of the campaign directory so
that each run starts its own record, and compare the time each job took. Submit one job at a time,
since several two-GPU jobs at once can exceed your group's GPU limit. For example, for two tasks
per GPU:

```bash
mkdir ../sweep-k2
cp emulator gpu-pick.sh sweep.txt gpu_sweep.sub ../sweep-k2/
cd ../sweep-k2
sbatch --export=ALL,TASKS_PER_GPU=2 gpu_sweep.sub
```

`--export=ALL,TASKS_PER_GPU=2` passes your environment to the job as usual, with `TASKS_PER_GPU`
set to 2. When each job has finished, compare how long it ran:

```bash
sacct -j <jobid> -X --format=JobID,Elapsed,State
```

Also compare the `seconds` in each run's result line, and check the job for failures with
`hs list --failed --count`. What to look for: while the tasks on a GPU fill the gaps in each
other's GPU use, raising the number of tasks per GPU makes the whole sweep finish sooner, and each
run takes only a little longer.

As an illustration, here is this page's stand-in sweep (64 runs on two H100 GPUs on Gautschi), run
once at each setting. These numbers describe this stand-in, which leaves the GPU idle most of each
step; your tasks will differ.

| Tasks per GPU | Time for the whole sweep | Average time per run |
|---|---|---|
| 1 | 2 min 38 s | 4.4 s |
| 2 | 1 min 28 s | 4.7 s |
| 4 | 1 min 1 s | 6.0 s |

Going from one to four tasks per GPU cut the sweep's time by more than half, while each run took
about a third longer. Once the GPU is busy all the time, another task per GPU only makes
each run slower in proportion, and the sweep finishes no sooner. Stop there, or sooner if runs begin
to fail.

## Limits to keep in mind

- **GPU memory.** Every task holds its own GPU memory, plus a few hundred megabytes that each
  process needs to use the GPU at all. The tasks on one GPU must fit in its memory together, or the
  last to start fails with an out-of-memory error. HyperShell cannot check this for you. Use the
  `used_memory` column of `gpu-use-<jobid>.txt` from a short trial to size *k*. The GPUs in this
  page's tabs hold 40 GB (Anvil's A100) or 80 GB (Gautschi's H100 and Gilbreth's `a100-80gb`
  A100); on Scholar, from 16 GB to 48 GB, by node type.
- **CPU cores and host memory.** All the tasks share the job's CPU cores and memory. Ask for enough
  cores that each running task has at least one, and on clusters where memory follows cores, enough
  memory too.
- **One task can crowd out the others.** Nothing stops one task from taking more GPU memory than
  its share; when it does, the other tasks on that GPU fail as they ask for theirs.
- **NVIDIA MPS.** NVIDIA's Multi-Process Service, which lets several processes' work run on one GPU
  at the same instant instead of taking turns, is not offered as a service on RCAC's clusters, so
  this page does not use it.
- **MIG.** NVIDIA's Multi-Instance GPU, which splits one GPU into smaller isolated GPUs, is not
  offered through Slurm on RCAC's clusters, so every GPU this page uses is a whole GPU.

## Make it yours

To run your own sweep, replace the lines of `sweep.txt` with your own commands, each a complete
command that runs on one GPU and uses whatever that GPU is, without naming a device itself. If your
commands need software such as a Python environment, load or activate it in the job script, after
the `module` lines. Then measure how many tasks each GPU can take, as above, and set
`TASKS_PER_GPU`, or the number in the script, to match.

To use more GPUs, raise `--gpus-per-node` and the cores with it, within the partition's limits; on
Gautschi, keep 14 cores per GPU. The body counts the GPUs it is given, so nothing else changes.

`gpu-pick.sh` reads `TASK_SLOT` from its environment, so it works the same way when tasks reach
clients by other routes, as they do in the later tiers. There, use `gpu-pick.sh` (or `TASK_SLOT`)
rather than HyperShell's `{slot}` template field, which is not available when tasks are submitted
with `hs submit`.

For HyperShell's description of executor slots, see
[templates](https://hypershell.readthedocs.io/templates.html) in HyperShell's documentation.

[Back to HyperShell User Guide](index.md){ .md-button }
