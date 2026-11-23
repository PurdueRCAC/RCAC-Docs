---
title: Snakemake
tags:
  - Workflows
  - Snakemake
authors:
  - glentner
search:
  boost: 2
---

# Snakemake

Snakemake is a workflow manager for reproducible, scalable data analysis, widely used in
bioinformatics. You describe the work in a *Snakefile* as a set of rules. Each rule names the
files it reads, the files it writes, and the command or Python code that makes them. Snakemake
works out the dependency graph by matching the files one rule needs to the files another rule
makes, then runs only the steps whose outputs are missing or out of date. If you know
[GNU Make](gnu_make.md), the idea is the same, written in a Python-based language and built for
data pipelines rather than software builds.

The project's documentation is at [snakemake.readthedocs.io](https://snakemake.readthedocs.io/).

## Getting Snakemake

Anvil, Gautschi, Negishi and Scholar offer Snakemake 6.8.0 as a module in the BioContainers
collection, which runs Snakemake from a container. Load the collection, then Snakemake, as two
separate commands; naming both in one `module load` command does not load Snakemake:

```bash
module load biocontainers
module load snakemake
snakemake --version
```

Gilbreth has no Snakemake module.

Snakemake 6.8.0 predates the executor plugins that Snakemake 8 introduced, including the Slurm
executor described below. For a current release, install Snakemake in your own environment with
the `conda` module, which every RCAC cluster provides. This command also installs the Slurm
executor plugin:

```bash
module load conda
conda create -n snakemake -c conda-forge -c bioconda snakemake snakemake-executor-plugin-slurm
conda activate snakemake
snakemake --version
```

See the [conda catalog page](../software/apps_md/conda.md) for the `conda` versions on each
cluster.

## How Snakemake describes work

A rule has inputs, outputs and a command. File names can carry *wildcards* in braces, such as
`{sample}`, so one rule covers every sample. This Snakefile does the same work as the examples on
the [job array](job_arrays.md), [GNU Make](gnu_make.md) and [GNU Parallel](gnu_parallel.md) pages:
it counts the words in every file under `data/`, one result per file, then collects the counts in
`summary.txt`.

```python title="Snakefile"
--8<-- "docs/snippets/workflows/snakemake/Snakefile"
```

Reading it from the top:

- `glob_wildcards` finds every `data/<sample>.txt` file and collects the sample names.
- `rule all` asks for `summary.txt`. As the first rule in the file, it is what Snakemake builds by
  default.
- `rule summary` needs one `.count` file per sample; `expand` writes out that list.
- `rule count` says how to make any `results/<sample>.count` from the matching
  `data/<sample>.txt`. In its command, `{input}` and `{output}` stand for the rule's files.
  Snakemake creates the `results/` directory itself.

To try it, make the sample files in an empty directory with the "Make sample data" block from the
[GNU Make page](gnu_make.md#a-worked-example), and save the Snakefile there. A dry run with `-n`
shows the plan without running anything: 20 `count` jobs, one `summary` and one `all`.

```bash
snakemake -n
```

Inside a batch job, `snakemake --cores "${SLURM_CPUS_PER_TASK}"` runs the whole graph on that job's
cores, in the same way as the [GNU Make job script](gnu_make.md#a-worked-example). Run it a second
time and Snakemake reports that there is nothing to be done. Add or change one file under `data/`,
and the next run makes only that file's count and the summary. Snakemake keeps its own records in a
hidden `.snakemake/` directory next to the Snakefile.

## Running rules as Slurm jobs

With Snakemake 8.6 or later and the Slurm executor plugin, Snakemake submits each job of the graph
to Slurm as its own batch job, and waits for it before submitting the jobs that depend on it:

```bash
snakemake --executor slurm --jobs 20 \
    --default-resources slurm_account=myallocation slurm_partition=cpu
```

`--jobs` caps how many of its jobs Snakemake keeps in the queue at once. Replace `myallocation`
with your own account and `cpu` with a partition from your cluster's queues page. Rules can ask
for their own resources, so a memory-hungry step can go to a different partition than the rest.
The plugin's options, including the quality of service (QOS) and other `sbatch` flags, are listed
in the [Slurm executor plugin documentation](https://snakemake.github.io/snakemake-plugin-catalog/plugins/executor/slurm.html).
That documentation expects Snakemake itself to run outside a Slurm job, where it stays running,
lightly, until the workflow ends.

Each job of the graph becomes one scheduler job. For 20 counts that is fine. For 20,000 short
ones it is the job-per-task pattern that the
[Workflow Automation landing page](index.md#why-you-need-a-workflow-tool) warns about. Snakemake's
job grouping (the `group` directive and the `--group-components` option) bundles many small jobs
into one submission; see
[grouping jobs](https://snakemake.readthedocs.io/en/stable/executing/grouping.html) in its
documentation.

## Where Snakemake wins

- **A real dependency graph over files.** When step B consumes step A's outputs, and step C
  consumes both, Snakemake works out the order from the file names alone.
- **Reruns of only what changed.** Like Make, a rerun redoes exactly the steps whose inputs
  changed or whose outputs are missing.
- **A software environment per rule.** A rule can name its own conda environment or container,
  so each step runs with the software it needs, and the workflow records how to rebuild it.
- **A large community.** Many published bioinformatics workflows are written in Snakemake.

## When to bring in HyperShell

Snakemake earns its cost when the work is a graph. When the work is a flat list of commands, a
sweep or a conversion over every file with nothing feeding anything else, the Snakefile is a
translation of a list you already have, and the graph engine has nothing to do. Use HyperShell
for that work.

The two also compose. When a graph has one very wide, flat step, such as the same command over
100,000 inputs, let Snakemake own the graph, its environments and its reruns, and let that step be
a single job that writes the list of commands and hands it to HyperShell inside one allocation.
The graph stays in Snakemake, and the wide step runs as a few jobs instead of thousands, with a
record of every task. RCAC recommends HyperShell for flat many-task work; see
[RCAC recommends HyperShell](index.md#rcac-recommends-hypershell) for why. The HyperShell User
Guide in this section starts with one job script that runs a whole task list this way.

[Back to Workflow Automation](index.md){ .md-button }
