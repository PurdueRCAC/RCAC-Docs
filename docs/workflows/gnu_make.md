---
title: GNU Make
tags:
  - Workflows
  - GNU Make
authors:
  - glentner
search:
  boost: 2
---

# GNU Make

GNU Make is the classic build tool. You describe your work in a *Makefile* as a set of rules: each
rule names a *target* file, the *prerequisite* files it is made from, and the *recipe*, the shell
commands that make it. Make compares timestamps and runs a recipe only when its target is missing
or older than one of its prerequisites. Built to compile software, it works just as well as a
small, file-driven pipeline: raw data in, results out, and only the out-of-date steps redone when
an input changes.

Make is part of the operating system on RCAC clusters, so there is no module to load. Its manual
is at [gnu.org/software/make](https://www.gnu.org/software/make/manual/).

## The work it fits

Make fits a small pipeline of files on one node that you rebuild as inputs change. Its rules form
a dependency graph of files: a summary depends on per-sample results, which depend on raw data.
With `make --jobs=N`, Make runs up to `N` independent recipes at once, so the per-sample steps run
in parallel across the cores of one node while the summary waits for all of them. When you add a
sample or fix one input, the next run rebuilds only that sample's results and the summary.

## A worked example

This example counts the words in every file under `data/`, writing one `results/<name>.count`
file per input, then collects the counts in `summary.txt`. Counting words is a stand-in for your
own per-file command. The same sample files appear in the [Slurm job array](job_arrays.md) and
[GNU Parallel](gnu_parallel.md) examples, so you can compare the three tools on the same work.

To try the example as written, make the sample files in an empty directory:

```bash title="Make sample data"
--8<-- "docs/snippets/workflows/sample-data.sh"
```

Save this file as `Makefile` in the same directory:

```make title="Makefile"
--8<-- "docs/snippets/workflows/gnu_make/Makefile"
```

Reading the Makefile from the bottom up:

- The `results` rule creates the output directory. The `| results` in the rule above it makes the
  directory a prerequisite that must exist without its timestamp triggering a rebuild.
- The pattern rule `results/%.count: data/%.txt` says how to make any `.count` file from the
  matching `.txt` file. In its recipe, `$<` is the prerequisite and `$@` is the target.
- `summary.txt` depends on every `.count` file, and its recipe concatenates them (`$^` is the list
  of all prerequisites). As the first rule in the file, it is what Make builds by default.
- `INPUTS` and `COUNTS` are computed from the files present in `data/`, so adding a sample needs no
  change to the Makefile.
- `.DELETE_ON_ERROR` removes a target whose recipe fails. Without it, a failed `wc` would leave an
  empty but up-to-date `.count` file behind, and the next run would skip it.
- `.RECIPEPREFIX = >` lets recipe lines start with `>`. Make normally requires a tab there, and a
  tab copied from a web page often becomes spaces, which Make rejects with a "missing separator"
  error.

Save the job script for your cluster as `make.sub` in the same directory. The `#SBATCH` lines
differ by cluster; the rest of the script is the same on every cluster.

=== "Anvil"

    ```bash title="make.sub"
    --8<-- "docs/snippets/workflows/gnu_make/header-anvil.sh"
    --8<-- "docs/snippets/workflows/gnu_make/body.sh"
    ```

=== "Gautschi"

    ```bash title="make.sub"
    --8<-- "docs/snippets/workflows/gnu_make/header-gautschi.sh"
    --8<-- "docs/snippets/workflows/gnu_make/body.sh"
    ```

=== "Negishi"

    ```bash title="make.sub"
    --8<-- "docs/snippets/workflows/gnu_make/header-negishi.sh"
    --8<-- "docs/snippets/workflows/gnu_make/body.sh"
    ```

=== "Scholar"

    ```bash title="make.sub"
    --8<-- "docs/snippets/workflows/gnu_make/header-scholar.sh"
    --8<-- "docs/snippets/workflows/gnu_make/body.sh"
    ```

The job asks for one task with 16 cores on one node, and `--jobs="${SLURM_CPUS_PER_TASK}"` lets
Make run that many recipes at once. Raise `--cpus-per-task` for more parallelism, up to the cores
of one node. Replace `myallocation` with your own account (Scholar's account is always `scholar`),
and see [Slurm Job Arrays](job_arrays.md#a-worked-example) for how to find your account and for
links to each cluster's partitions. Every partition on Gilbreth is a GPU partition, so this CPU
example has no Gilbreth tab.

Submit the job with `sbatch make.sub`. When it finishes, `results/` holds one `.count` file per
input and `summary.txt` holds all twenty counts. Submit it again and Make has nothing to do: the
job output reports that `summary.txt` is up to date. Change or add one file under `data/` and
submit once more, and Make rebuilds only that file's count and the summary.

## What Make remembers

Make's only memory is the files on disk and their timestamps. It does not record which recipes
ran, how long they took, or how they ended. When a recipe fails, Make prints the error to the job's
output file and, with `--keep-going`, carries on with every target that does not depend on the
failure; the job then exits with a non-zero status. To find what failed, you read the output file.
Fix the cause and resubmit: the targets that succeeded are up to date and are skipped.

## Where Make wins

- **Incremental rebuilds.** After a change, Make redoes exactly the steps whose inputs changed and
  nothing else.
- **A real dependency graph over files**, stated in a compact, widely known format.
- **Nothing to install.** Make is present on every cluster and most workstations.

## When to move to HyperShell

Make stops serving well when the work outgrows one node or needs a record:

- **One node.** `make --jobs` runs recipes on the machine Make runs on. It does not spread work
  across the nodes of a multi-node job.
- **No record.** Timestamps tell Make what is out of date, not what failed or why. There is no
  table of exit codes or run times to query after the job ends.
- **Very wide steps.** Running one command over 100,000 inputs means a rule and a target file for
  each, and a failure is found by searching the output file.

HyperShell takes over for wide, flat steps. Make, or a short shell script, can write the list of
commands, and HyperShell runs that list across one node or many, recording every task's exit
status and run time in a database. If your pipeline has a handful of ordered stages, Make can stay
as the outer driver, with each wide stage running as one HyperShell job. RCAC recommends HyperShell
for flat many-task work; see [RCAC recommends HyperShell](index.md#rcac-recommends-hypershell) for
why. The HyperShell User Guide in this section starts with one job script that runs a whole task
list this way.

[Back to Workflow Automation](index.md){ .md-button }
