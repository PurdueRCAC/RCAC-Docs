# VALIDATION — workflow-automation

The cluster validation log for this cycle (GOAL R15; PLAN §6). Step agents never run anything on a
cluster. The cycle's validator runs the PLAN §6 envelope against the committed snippet files and
records results here. Each validating phase's `verify:` in [`TECH.md`](TECH.md) greps for its
status line, so a phase closes only once its line reads `PASS`.

**Status line format** (one per phase, at the start of a line):

- `P<n>: PENDING — <files to run>` (written by the draft run)
- `P<n>: PASS — <YYYY-MM-DD>, <clusters>, HyperShell <version or commit>` (written by the validator)
- `P<n>: FAIL — <YYYY-MM-DD>, <what broke>` (written by the validator; the close run fixes and re-queues)

Under each phase heading, record: the build under test, image tags (P7), the account/partition/QOS
used (placeholders in the pages stay placeholders), the `sbatch --test-only` result per tab, the
checks from the PLAN §6 row, and any change the draft needs.

## Build under test

Publish rule (GOAL *Plan gate, 2026-11-22*): validate on Gautschi's `hypershell/develop` module
(record the exact `hs --version` each time) or a recorded `develop` commit.

*(validator: version or commit, install route, per cluster)*

## Merge hold

The draft PR may open at any time. Merge only after 2.9.0 is tagged, the default module on Gautschi
and Anvil is 2.9.0, and the tier 1 checks have been re-run on that module:

- `P4-release: PASS — <date>, Gautschi + Anvil, default module <version>` *(written by the validator)*

## P2 — Baseline tools (V2)

Validation request for draft `9849de64`, covering docs/snippets/workflows/{sample-data.sh, job_arrays/{header-anvil,header-gautschi,header-negishi,header-scholar,body}.sh, gnu_make/{header-anvil,header-gautschi,header-negishi,header-scholar,body}.sh, gnu_make/Makefile, gnu_parallel/{header-anvil,header-gautschi,header-negishi,body}.sh}; result: PASS, see Results below.

### Validation request (written by the draft run, 2026-11-22)

P2 uses no HyperShell. Record "HyperShell: not used" in the PASS line.

**Envelope.** Gautschi, `-A "$ACCT" -p cpu -q standby`, at most 1 node × 15 minutes per job,
files only under `$RCAC_SCRATCH/workflow-automation/`. `$ACCT` is the validation account from the
envelope, kept out of the repository. Every Gautschi tab already says `--partition=cpu` and asks
for 1 node and 10 or 15 minutes. Run the files unchanged and override the account and QOS on the
command line (`sbatch -A "$ACCT" -q standby …`); a command-line option overrides the matching
`#SBATCH` line. The other clusters get login-node checks and `sbatch --test-only` only.

**Assembling a tab.** Each published tab is its header file, one empty line, then the shared body.
This command reproduces the rendered tab byte for byte (checked against the built `site/` for
all 11 tabs, the sample-data block and the Makefile):

```bash
{ cat header-<cluster>.sh; echo; cat body.sh; } > <name>.sub
```

| Script | Header files (one per tab) | Body | Rendered at |
|---|---|---|---|
| `array.sub` | `job_arrays/header-{anvil,gautschi,negishi,scholar}.sh` | `job_arrays/body.sh` | `site/workflows/job_arrays/index.html` |
| `make.sub` | `gnu_make/header-{anvil,gautschi,negishi,scholar}.sh` | `gnu_make/body.sh` | `site/workflows/gnu_make/index.html` |
| `parallel.sub` | `gnu_parallel/header-{anvil,gautschi,negishi}.sh` | `gnu_parallel/body.sh` | `site/workflows/gnu_parallel/index.html` |

Also used as published, not assembled: `sample-data.sh` (the "Make sample data" block on all three
pages) and `gnu_make/Makefile` (copy it as `Makefile`). All paths are under
`docs/snippets/workflows/`.

#### A. Login-node checks (no job)

| # | Cluster(s) | Command | PASS if |
|---|---|---|---|
| A1 | Anvil, Gautschi, Gilbreth, Negishi | `module load parallel && parallel --version \| head -1`; `module spider parallel` | loads with no prerequisite module; record the version (catalog: Anvil 20200822, Gautschi 20241022, Gilbreth 20241022, Negishi 20220522) |
| A2 | Scholar | `module spider parallel` | no module found (the page says Scholar has none) |
| A3 | Anvil, Gautschi, Negishi, Scholar | `command -v make && make --version \| head -1`, with no module loaded | a system `make` is found, GNU Make 3.82 or newer (`.RECIPEPREFIX` needs 3.82); the page says no module is needed |
| A4 | Anvil and Gautschi | `module load parallel && man parallel \| col -b \| grep -A3 -E '^ +--(resume\|resume-failed\|retry-failed\|retries)( \|$)'` | all four options exist in the module's version, and the descriptions agree with the page's table (resume skips any task in the log; resume-failed runs failed then not-yet-run; retry-failed reruns failed from the log) |
| A5 | Anvil, Gautschi, Gilbreth, Negishi, Scholar | `module spider htcondor; module spider condor; command -v condor_submit condor_q` | no module and no command on any cluster. The P1 landing page says HTCondor "is not provided as a module on RCAC's clusters"; any hit is a FAIL that sends a fix to `docs/workflows/index.md` |
| A6 | Anvil, Gautschi, Negishi, Scholar | `scontrol show config \| grep -i MaxArraySize`; `sacctmgr show qos format=Name,MaxJobsPU,MaxSubmitPU` | the first prints a `MaxArraySize = <n>` line and the second a table with those three columns. Record the values here; they are not published |

#### B. `sbatch --test-only`, every tab

On each cluster's login node, with your real account there, assemble the tab and run
`sbatch --test-only -A <your account> <name>.sub` (on Scholar, run it without `-A`; the file
already says `scholar`). PASS if sbatch prints `Job <n> to start at … in partition <p>` and no
error. If Gautschi or Negishi rejects `--qos=normal` for account reasons only (no CPU purchase on
that account), record that and repeat with `-q standby`; a syntax or partition error is a FAIL.
Mark a cluster N/A if you have no account there.

| Cluster | Tabs |
|---|---|
| Anvil | `array.sub`, `make.sub`, `parallel.sub` (partition `shared`, no QOS line) |
| Gautschi | `array.sub`, `make.sub`, `parallel.sub` |
| Negishi | `array.sub`, `make.sub`, `parallel.sub` |
| Scholar | `array.sub`, `make.sub` (no GNU Parallel tab) |

#### C. Gautschi runs

Make three empty directories under `$RCAC_SCRATCH/workflow-automation/p2/` (`arrays`, `make`,
`parallel`). In each, run the sample-data block (`bash sample-data.sh`) and check: `ls data | wc -l`
is 20, `wc -l < data/sample_08.txt` is 8, `wc -l < inputs.txt` is 20. Assemble the Gautschi tab
into the matching directory.

**C1. Job array** (`arrays/`, `array.sub` from `header-gautschi.sh`):

1. Plant a failure: `chmod 000 data/sample_05.txt`.
2. `sbatch --hold -A "$ACCT" -q standby array.sub` → J1. `scontrol show job J1 | grep -o 'ArrayTaskThrottle=[0-9]*'`
   prints `ArrayTaskThrottle=5`. Then `scontrol release J1`.
3. While it runs, `squeue -u $USER -r` shows one line per array task (`J1_<n>`). N/A if the tasks
   finish before you look.
4. After it ends, `sacct -j J1 -X --format=JobID,State,ExitCode` shows 20 rows `J1_1` … `J1_20`:
   `J1_5` is `FAILED 1:0` and the other 19 are `COMPLETED 0:0`.
5. `cat results/sample_07.count` prints `7 data/sample_07.txt`; there are 20 files
   `array-J1_<n>.out`, and `head -1 array-J1_7.out` prints `Array task 7 of job J1: data/sample_07.txt`.
6. Re-run only the failure: `chmod 644 data/sample_05.txt`, then
   `sbatch -A "$ACCT" -q standby --array=5 array.sub` → J2. `sacct -j J2 -X --format=JobID,State,ExitCode`
   shows one row `J2_5 COMPLETED 0:0`, and `cat results/sample_05.count` prints `5 data/sample_05.txt`.
7. Cancel one task: `sbatch --hold -A "$ACCT" -q standby --array=1-3 array.sub` → J3,
   `scancel J3_2`, then `sacct -j J3 -X --format=JobID,State` shows `J3_2` as `CANCELLED`; then
   `scancel J3`.

**C2. GNU Make** (`make/`, `make.sub` from `header-gautschi.sh`, plus `Makefile`):

1. Plant a failure: `chmod 000 data/sample_05.txt`.
2. `sbatch -A "$ACCT" -q standby make.sub` → J4. `sacct -j J4 -X --format=JobID,State,ExitCode`
   shows `FAILED 2:0`. `ls results/*.count | wc -l` is 19, `results/sample_05.count` does not exist
   (`.DELETE_ON_ERROR`), `summary.txt` does not exist, and `slurm-J4.out` contains
   `not remade because of errors` and no `missing separator` error.
3. `chmod 644 data/sample_05.txt`; resubmit → J5 `COMPLETED 0:0`. `slurm-J5.out` shows exactly two
   recipes: `wc -w data/sample_05.txt > results/sample_05.count` and the `cat … > summary.txt` line.
   `wc -l < summary.txt` is 20 and `grep sample_05 summary.txt` prints `5 data/sample_05.txt`.
4. Resubmit unchanged → J6 `COMPLETED 0:0`; `slurm-J6.out` contains `'summary.txt' is up to date`.
5. Add one sample: `seq 21 > data/sample_21.txt`; resubmit → J7 `COMPLETED 0:0`; `slurm-J7.out`
   shows exactly two recipes (`sample_21.count` and `summary.txt`), and `wc -l < summary.txt` is 21.

**C3. GNU Parallel** (`parallel/`, `parallel.sub` from `header-gautschi.sh`):

1. Plant a failure before the first run: `echo data/sample_21.txt >> inputs.txt` (that file does
   not exist yet), so `inputs.txt` has 21 lines.
2. `sbatch -A "$ACCT" -q standby parallel.sub` → J8. `sacct -j J8 -X --format=JobID,State,ExitCode`
   shows a non-zero exit (GNU Parallel exits with the number of failed tasks: expect `FAILED 1:0`).
   `wc -l < parallel.log` is 22 (header + 21). The page's command
   `awk -F '\t' 'NR > 1 && $7 != 0' parallel.log` prints exactly one line, ending
   `wc -w data/sample_21.txt > results/sample_21.count`. `cat results/sample_07.count` prints
   `7 data/sample_07.txt`. Record whether `slurm-J8.out` contains any citation notice.
3. Fix it: `seq 21 > data/sample_21.txt`; note `stat -c %Y results/sample_07.count` → T. Resubmit
   unchanged → J9 `COMPLETED 0:0`. `wc -l < parallel.log` is 23 (one new line, sequence 21,
   `Exitval` 0); `cat results/sample_21.count` prints `21 data/sample_21.txt`; `stat -c %Y
   results/sample_07.count` still prints T (succeeded tasks were skipped).
4. Resubmit unchanged once more → J10 `COMPLETED 0:0`, and `wc -l < parallel.log` is still 23
   (sequence 21's later success counts; nothing reruns). If it reruns sequence 21, record that: the
   page's "tasks that succeeded are skipped" wording then needs a caveat for tasks that failed
   once.

#### D. Not covered by this envelope (record, do not run)

The Anvil, Negishi and Scholar tabs are checked by `--test-only` (B) and the module checks (A),
not executed. In particular, the Anvil GNU Parallel tab runs `module load parallel` under
`#!/bin/bash` in a non-login batch shell and relies on Slurm exporting the submit-time module
environment (Slurm's default). Running it is outside this envelope: record "Anvil batch: not
run" as a residual risk, to clear in a later envelope or at review.

#### Results

Validated 2026-11-22 by the foreman on the clusters' login nodes and Gautschi batch, against the
snippet files of `9849de64`, assembled as above. HyperShell: not used.

- **A1** PASS. `module load parallel` loads with no prerequisite: Anvil 20200822, Gautschi 20241022,
  Gilbreth 20241022, Negishi 20220522.
- **A2** PASS. Scholar has no `parallel` module.
- **A3** PASS. System `/usr/bin/make` with no module loaded: Anvil 4.2.1, Gautschi 4.3, Negishi 4.2.1,
  Scholar 4.3 (all at least 3.82).
- **A4** PASS. `--resume`, `--resume-failed`, `--retry-failed`, `--retries n` present in the man page
  on Anvil and Gautschi.
- **A5** PASS. No `htcondor` or `condor` module and no `condor_submit`/`condor_q` on Anvil, Gautschi,
  Gilbreth, Negishi or Scholar. The P1 landing-page claim stands.
- **A6** PASS (recorded, not published). MaxArraySize: Anvil 1001, Gautschi 20001, Negishi 1001,
  Scholar 1001.
- **B** PASS, 11/11. `sbatch --test-only` prints "Job … to start at … in partition …" for every tab:
  Anvil array/make/parallel (`shared`); Gautschi, Negishi array/make/parallel (`cpu`); Scholar
  array/make (`cpu`, no `-A`). On Anvil, one allocation was refused with `AssocGrpCPUMinutesLimit`
  (an exhausted allocation, not a script fault); another allocation passed.
- **C1** PASS. `ArrayTaskThrottle=5` on the held job; `squeue -r` showed one line per task; 19 ×
  `COMPLETED 0:0` and `_5 FAILED 1:0`; `sample_07.count` = `7 data/sample_07.txt`; 20 output files;
  first line `Array task 7 of job <id>: data/sample_07.txt`. Rerun `--array=5`: `_5 COMPLETED 0:0`,
  `5 data/sample_05.txt`. `scancel <id>_2` on the held `--array=1-3` removed task 2
  (`ArrayTaskId=1,3`). Note: a task cancelled before it starts leaves **no** `sacct` row (the request
  expected `CANCELLED`); the page's `scancel` instruction is correct, and its "its own accounting
  record" bullet needs a clause for tasks cancelled before they start (close run).
- **C2** PASS. J4 `FAILED 2:0`, 19 counts, no `sample_05.count` or `summary.txt`, "Target
  'summary.txt' not remade because of errors", no "missing separator". J5 `COMPLETED`, exactly two
  recipes, 20 lines with `5 data/sample_05.txt`. J6 "'summary.txt' is up to date". J7 exactly two
  recipes, 21 lines.
- **C3** PASS. J8 `FAILED 1:0`, 22 log lines, one non-zero row (the `sample_21` command),
  `sample_07.count` = `7 data/sample_07.txt`, no citation notice in the output. J9 `COMPLETED`, 23
  lines, `21 data/sample_21.txt`, `sample_07.count` mtime unchanged (succeeded tasks skipped). J10
  `COMPLETED`, log still 23 lines.
- **Envelope deviation.** The make and parallel scripts (16 cores) sat at "Priority" with no start
  estimate on a full `cpu` partition, so J6–J10 ran with `-c 4` on the command line. Both bodies size
  their work from `$SLURM_CPUS_PER_TASK`, so the behaviour under test is unchanged. J4 and J5 ran at
  16 cores; the first 16-core J6 and J8 were cancelled while pending.
- **D** Anvil, Negishi, Scholar batch: not run (residual risk, as above).

P2: PASS — 2026-11-22 · Gautschi standby (a staff allocation), A–C as above · HyperShell: not used · close run adds the `scancel` accounting clause

## P3 — Workflow managers (V3)

Validation request for draft `36896d7f`, covering docs/workflows/{snakemake,nextflow,pegasus,parsl}.md, docs/snippets/workflows/{snakemake/Snakefile, parsl/config.py, parsl/count.py}; result: PASS, see Results below.

### Validation request (written by the draft run, 2026-11-22)

P3 uses no HyperShell and submits no jobs. Record "HyperShell: not used" in the PASS line.

**Envelope.** Login nodes only (V3): module checks on all five clusters, plus user-space installs
and a few seconds of local commands on tiny files on Gautschi and Anvil. Nothing goes to Slurm:
the one Slurm-flavoured command (B2.6) is a Snakemake dry run, which submits nothing. Files only
under `$RCAC_SCRATCH/workflow-automation/p3/`, except the Parsl environment, which the page puts
at `~/parsl-env` (B3). `$ACCT` is the validation account, kept out of the repository.

**Already confirmed (foreman, 2026-11-22; re-run only if convenient):** Anvil `nextflow` 21.10.0
and 22.10.1, `snakemake/6.8.0`, no Pegasus WMS module, no `pegasus-plan` or `condor_submit`;
Gautschi `nextflow` 24.04.3, 25.10.04, 26.04.2, and `cadence/pegasus/*` is not Pegasus WMS; no
HTCondor module or command on any of the five (P2 A5). The rows below still ask for the load and
version commands on those clusters, which the confirmation did not cover.

**Files.** The pages publish three files verbatim (copy them as named): `snakemake/Snakefile`
(rendered at `site/workflows/snakemake/index.html`), `parsl/config.py` and `parsl/count.py`
(rendered at `site/workflows/parsl/index.html`). All paths are under `docs/snippets/workflows/`.
The sample data is P2's `sample-data.sh`. The draft run checked the Snakefile steps of B2.2–B2.6
and B3.3–B3.5 on a workstation, with Snakemake 9.27.2 and snakemake-executor-plugin-slurm installed
by pip (not conda) and Parsl 2026.11.16 on Python 3.12. Snakemake 6.8.0 (B1) and the conda install
(B2.1) were not checked; the cluster run is what counts. On the workstation, building the Parsl
executor (B3.3) tried to reach `api.ipify.org` to list the host's addresses; if a login node blocks
that, a slow B3.3 is not a FAIL, but record it.

#### A. Login-node module checks (no job)

| # | Cluster(s) | Command | PASS if |
|---|---|---|---|
| A1 | Anvil | `module spider nextflow`; then, for each version, `module load nextflow/<v> && nextflow -version` | spider lists exactly 21.10.0 and 22.10.1; each loads with no prerequisite module and prints `version <v>` (`nextflow.md` table) |
| A2 | Gautschi | as A1 | spider lists exactly 24.04.3, 25.10.04, 26.04.2; each loads with no prerequisite and prints `version <v>` |
| A3 | Negishi | as A1 | spider lists exactly 22.10.1, 23.04.1, 25.10.04, 26.04.2; each loads with no prerequisite and prints `version <v>` |
| A4 | Gilbreth, Scholar | `module spider nextflow` | no module found (the page says these two have none) |
| A5 | Anvil | `module spider snakemake`; `module load snakemake && snakemake --version` | loads with no prerequisite module and prints `6.8.0` (the page says `module load snakemake` loads 6.8.0). If a prerequisite such as `biocontainers` is needed, FAIL: the close run adds that line |
| A6 | Gautschi, Gilbreth, Negishi, Scholar | `module spider snakemake` | "Unable to find" on each: PASS. A hit that spider says needs `biocontainers` loaded first: PASS, record cluster and version (the close run may add one sentence naming it). A Snakemake module that loads with no prerequisite: FAIL (`snakemake.md` says the catalog lists none outside Anvil) |
| A7 | Anvil, Gautschi, Gilbreth, Negishi, Scholar | `module spider pegasus`; `command -v pegasus-plan pegasus-version` | no Pegasus WMS module (on Gautschi, the only hits are `cadence/pegasus/*`, the unrelated EDA tool) and neither command found (`pegasus.md`: no Pegasus module on any community cluster). Negishi, Gilbreth and Scholar are the new checks |
| A8 | all five | `module spider parsl` | no module found (`parsl.md`: RCAC provides no Parsl module) |
| A9 | all five | `module load conda && conda --version` | loads and prints a version (`snakemake.md`: every RCAC cluster provides the `conda` module) |
| A10 | all five | `module load uv && uv --version` | loads and prints a version (`parsl.md` installs with the `uv` module) |

#### B. User-space installs and local runs on the login node (no job)

Make `$RCAC_SCRATCH/workflow-automation/p3/` and work in the subdirectories named below. In each,
first run `bash sample-data.sh` and check `ls data | wc -l` is 20. The commands in B1–B3 run 20
`wc` and one `cat` over files of at most 20 lines, a few seconds in all.

**B1. Snakemake 6.8.0 module** (Anvil, `smk-module/`, with `Snakefile` copied in):

1. `module load snakemake`, then `snakemake -n`: prints a job table with `count` 20, `summary` 1,
   `all` 1, total 22, and no error.
2. `snakemake --cores 2`: exits 0; `wc -l < summary.txt` is 20; `grep sample_05 summary.txt` prints
   `5 data/sample_05.txt`; `ls results | wc -l` is 20.
3. `snakemake --cores 2` again: prints `Nothing to be done`.
4. `seq 21 > data/sample_21.txt`, then `snakemake --cores 2`: runs exactly one `count` job (for
   `sample_21`), the `summary` job and `all`; `wc -l < summary.txt` is 21.

**B2. Current Snakemake from conda** (Gautschi, `smk-conda/`, with `Snakefile` copied in):

1. Run the page's install block as written: `module load conda`, then
   `conda create -n snakemake -c conda-forge -c bioconda snakemake snakemake-executor-plugin-slurm`
   (answer `y` at the prompt), `conda activate snakemake`, `snakemake --version`: the environment
   solves and installs, and the version is 8.6 or newer. Record it.
2. `snakemake -n`: the same job table as B1.1.
3. `snakemake --cores 2`: as B1.2.
4. As B1.3: `Nothing to be done`.
5. As B1.4: one `count`, `summary`, `all`; 21 lines.
6. `snakemake -n --executor slurm --jobs 20 --default-resources slurm_account="$ACCT" slurm_partition=cpu`:
   prints the job table and `This was a dry-run`, no error (warnings are fine; record any), and
   `squeue -u $USER` shows no new job. This checks that the page's executor options parse.

**B3. Parsl** (Gautschi, `parsl/`):

1. Run the page's install block as written: `module load uv`, `uv venv ~/parsl-env --python 3.12`,
   `source ~/parsl-env/bin/activate`, `uv pip install parsl`,
   `python -c "import parsl; print(parsl.__version__)"`: prints a version. Record it. If
   `~/parsl-env` already exists, move it aside first.
2. Copy `config.py` and `count.py` into `parsl/`.
3. Configuration builds (constructs objects only; nothing is submitted):
   `python -c "from config import config; p = config.executors[0].provider; print(type(p).__name__, p.account, p.partition, p.qos, p.nodes_per_block, p.max_blocks, p.walltime, p.exclusive)"`
   prints `SlurmProvider myallocation cpu normal 1 2 01:00:00 True` with no `TypeError`. (The page
   says the provider asks for whole nodes by default; `True` confirms it.)
4. The program runs, with a local thread pool standing in for `config.py` (nothing is submitted):

    ```bash
    python - <<'PY'
    import runpy, sys, types
    from parsl.config import Config
    from parsl.executors.threads import ThreadPoolExecutor
    sys.modules["config"] = types.SimpleNamespace(config=Config(executors=[ThreadPoolExecutor()]))
    runpy.run_path("count.py", run_name="__main__")
    PY
    ```

    exits 0; `wc -l < summary.txt` is 20; `grep sample_05 summary.txt` prints
    `5 data/sample_05.txt`; `ls results | wc -l` is 20; a `runinfo/` directory exists.
5. Planted failure: `chmod 000 data/sample_05.txt`, remove `summary.txt`, run B3.4 again: exits
   non-zero with a traceback ending in `parsl.dataflow.errors.DependencyError`, and `summary.txt`
   is not created (the page says the summary does not run and `.result()` raises). Then
   `chmod 644 data/sample_05.txt`.

#### C. Link checks (no cluster)

From any machine, each URL opens a live page whose title matches the link text on the page:
`https://snakemake.readthedocs.io/`, `https://snakemake.github.io/snakemake-plugin-catalog/plugins/executor/slurm.html`,
`https://snakemake.readthedocs.io/en/stable/executing/grouping.html`, `https://docs.seqera.io/nextflow/`,
`https://docs.seqera.io/nextflow/executor`, `https://nf-co.re/`, `https://pegasus.isi.edu/documentation/`,
`https://www.rcac.purdue.edu/news/7628` (dated 2026-03-10, Pegasus on Anvil), `https://pegasus.access-ci.org`,
the three ACCESS documentation pages linked from `pegasus.md` (ACCESS Pegasus, HTCondor Annex,
Pegasus Workflows), `https://parsl.readthedocs.io/`, the SlurmProvider reference and the Providers
guide linked from `parsl.md`. Optional, if you can log in to the Anvil Notebook Service with ACCESS
credentials: record whether a Pegasus environment is offered at launch (the page does not name it).

#### D. Not covered by this envelope (record, do not run)

No job runs in V3, so these page statements are checked only as far as A–C go. Record each as a
residual risk, to clear in a later envelope or at review:

- **Parsl in Slurm.** That `SlurmProvider` blocks start on Gautschi with the page's values, that
  `worker_init` finds `~/parsl-env` on the compute nodes, and that workers reach the driver on a
  login node over the network. The Anvil (`partition="wholenode"`, no `qos`) and Negishi variants
  in the prose are not built in B3.
- **Snakemake Slurm executor.** Real submission with `--executor slurm` (B2.6 is a dry run only).
- **Nextflow behaviour** (`-resume`, the `slurm` executor, `queueSize`, `submitRateLimit`) is
  described from Nextflow's documentation and the Life Sciences guides, not run here.

#### Results

Validated 2026-11-22 by the foreman on the five clusters' login nodes (no Slurm jobs), against
`36896d7f`. HyperShell: not used. Envelope note: the conda environment (B2) was created with
`conda create -p` under `$RCAC_SCRATCH/workflow-automation/p3/envs/` and the Parsl venv (B3) under
the same directory, not in the home directory; `CONDA_ENVS_DIRS` could not be used because the
conda module already sets `CONDA_ENVS_PATH` (`MultipleKeysError`). The page's install commands are
otherwise unchanged.

- **A1 Anvil nextflow** FAIL (claim). `nextflow/22.10.1` loads with no prerequisite and prints
  `version 22.10.1`. `nextflow/21.10.0` "exists but cannot be loaded as requested": it is a
  `biocontainers` module. → close-run fix C2.
- **A2 Gautschi nextflow** FAIL (claim). 25.10.04 and 26.04.2 load and print `version 25.10.4`,
  `version 26.04.2`. `nextflow/24.04.3` loads but does not run: `UnsupportedClassVersionError`
  (built for Java 11, class file 55; the system Java is 1.8.0_492). A module defect, reported
  separately. → close-run fix C3.
- **A3 Negishi nextflow** PASS. 22.10.1, 23.04.1, 25.10.4, 26.04.2 each load and print their version.
- **A4** PASS with record. Gilbreth: no nextflow module. Scholar: `module spider nextflow` finds it
  only behind `biocontainers/default`.
- **A5 Anvil snakemake** FAIL (claim). `snakemake/6.8.0` is a `biocontainers` module (a Singularity
  image run through a shell function). `module load snakemake` alone fails; `module load
  biocontainers snakemake` on one line also leaves it unloaded; `module load biocontainers` then
  `module load snakemake` (two commands) loads it, and `snakemake --version` prints 6.8.0.
  → close-run fix C1.
- **A6** PASS with record. Gilbreth: none. Gautschi, Negishi (`snakemake/6.8.0`) and Scholar: only
  behind `biocontainers`. No Snakemake module loads without a prerequisite on any cluster.
- **A7** PASS. No Pegasus WMS module and no `pegasus-plan`/`pegasus-version` on any of the five;
  Gautschi and Negishi list only `cadence/pegasus/*`.
- **A8** PASS. No `parsl` module on any of the five.
- **A9** PASS. `conda` module: Anvil 25.1.1, Gautschi 26.1.0, Gilbreth 25.3.1, Negishi 25.3.1, Scholar 25.3.1.
- **A10** PASS. `uv` module: Anvil 0.13.9, Gautschi 0.13.6, Gilbreth 0.13.6, Negishi 0.13.6, Scholar 0.12.8.
- **B1** PASS (with the `biocontainers` prerequisite). Dry run: count 20, summary 1, all 1, total 22;
  run exits 0, 20 lines, `5 data/sample_05.txt`, 20 results; rerun "Nothing to be done."; adding
  `sample_21` runs count 1, summary 1, all 1 (total 3), 21 lines.
- **B2** PASS. The page's conda install solves; Snakemake 9.27.2. B1.1–B1.4 repeat identically. The
  executor dry run with the page's options exits 0; with outputs current it reports nothing to do,
  and with `--forceall` it prints the table (total 23) and "This was a dry-run"; `squeue` shows no job.
- **B3** PASS. Parsl 2026.11.16. Config check prints `SlurmProvider myallocation cpu normal 1 2
  01:00:00 True`. Thread-pool run exits 0, 20 lines, `5 data/sample_05.txt`, 20 results, `runinfo/`.
  Planted failure exits 1 with `parsl.dataflow.errors.DependencyError`, and no `summary.txt`.
- **C** PASS. All 15 external URLs return 200 (two through a redirect; the RCAC news page checked
  from a cluster login node, title "Scientific workflow management system, Pegasus, available on Anvil").
- **D** not run, as listed (residual risks).

Close-run fixes required before P3 closes:
- **C1** `snakemake.md`: on Anvil, Snakemake 6.8.0 is a `biocontainers` module, loaded with
  `module load biocontainers` and then `module load snakemake` as two commands. Say that Gautschi,
  Negishi and Scholar also offer Snakemake 6.8.0 only through `biocontainers`, Gilbreth none; 6.8.0
  predates the Slurm executor plugin, so the conda route stays the recommendation for current
  Snakemake.
- **C2** `nextflow.md`: Anvil 21.10.0 is behind `biocontainers`; 22.10.1 loads directly. Scholar's
  Nextflow is only behind `biocontainers`.
- **C3** `nextflow.md`: drop 24.04.3 from Gautschi's list (it does not run with the system Java);
  list 25.10.04 and 26.04.2.

P3: PASS — 2026-11-22 · login nodes of all five clusters, no jobs · HyperShell: not used · conditional on close-run fixes C1–C3, re-checked by the foreman at the gate

## P4 — Guide landing page and Tier 1 (V4)

Validation request for draft `136a0f10`, covering docs/workflows/hypershell/{index,single_job}.md, docs/snippets/workflows/frames/{header-anvil,header-gautschi,header-negishi,header-scholar,body,render-frame}.sh; result: PASS, see Results below.

### Validation request (written by the draft run, 2026-11-22)

**Build under test.** Gautschi's `hypershell/develop` module (2.9.0a8 today). Record its exact
`hs --version` in the PASS line. Tier 1 depends on nothing the 2.9.0a8 known issues touch: it uses
no `hs server --initdb`, no environment variable for a key with an underscore, no key at all, no
`#` inside a task command, and no duration with units. One a8 behaviour to know: if `srun` fails to
start the clients, `hsx` on a8 waits until the walltime instead of exiting (fixed after a8), so a
job that sits with no `Running task` lines for several minutes is a launch failure; record it.

**Envelope.** Gautschi, `-A "$ACCT" -p cpu -q standby`, at most 2 nodes × 15 minutes per job, at
most 2 jobs queued at once, files only under `$RCAC_SCRATCH/workflow-automation/p4/`. `$ACCT` is
the validation account, kept out of the repository. The Gautschi tab already says
`--partition=cpu`, two nodes and 15 minutes; override the account and QOS on the command line
(`sbatch -A "$ACCT" -q standby …`), and add `-N 1` for the one-node runs (a command-line option
overrides the matching `#SBATCH` line). Anvil, Negishi and Scholar get login-node checks and
`sbatch --test-only` only.

**Assembling a tab.** As in P2, each published tab is its header file, one empty line, then the
shared body. This reproduces the rendered tab byte for byte (checked against the built `site/` for
all four tabs and `render-frame.sh`):

```bash
{ cat header-<cluster>.sh; echo; cat body.sh; } > frames.sub
```

The published header says `module load hypershell`, which on Gautschi today loads the default
2.7.0, where `hsx` refuses a task file together with `--restart`. For the Gautschi runs (C), change
that one line and nothing else, and record that you did:

```bash
{ sed 's|^module load hypershell$|module load hypershell/develop|' header-gautschi.sh; echo; cat body.sh; } > frames.sub
```

The module line itself is checked as published in A1. All paths below are under
`docs/snippets/workflows/frames/`. `render-frame.sh` is used as published (copy it as named), and
the task file comes from the page's command:
`printf 'sh render-frame.sh %d\n' $(seq 1 1200) > frames.txt`.

**Draft-run check (workstation, not a cluster).** The body ran on macOS with HyperShell 2.9.0a8
from PyPI, a stand-in `srun` that runs its command once, 40 frames, a shortened `sleep`, and
`-H 127.0.0.1` added because the workstation's host name does not resolve. Killing the job's
process group with SIGTERM mid-run left 16 succeeded, 2 failed (planted) and 22 unfinished, with no
negative exit status; the unchanged resubmit logged `Found 22 unfinished tasks` and
`Reverted 8 previously interrupted tasks`, rendered exactly the 21 frames left (the third planted
frame failed again), and exited 0; a further resubmit logged `All previous tasks completed (40) -
stopping`; `hs update --failed --revert` asked `Update affects 3 tasks, continue? yes/[no]:` and
logged `Updated 3 tasks`, and the next resubmit rendered exactly those three. Appending a line to
the task file made the next run stop with `differs from its prior submission (content changed);
pass --update --restart`, and `--update --restart` then submitted only the new line. The cluster
run is what counts.

#### A. Login-node checks (no job)

| # | Cluster(s) | Command | PASS if |
|---|---|---|---|
| A1 | Anvil, Gautschi, Negishi, Scholar | `module load hypershell && hs --version`; `module spider hypershell` | loads with no prerequisite module; record the version (catalog: 2.7.0 default on all four; a version below 2.9.0 is expected until the merge hold clears) |
| A2 | Gautschi | `module load hypershell/develop && hs --version`; `command -v hs hsx hyper-shell` | prints `HyperShell v2.9.0a8 …` or later; record the version, and which of the three executables are on `PATH` (the relay in P7 needs `hyper-shell`) |
| A3 | Gautschi, with `hypershell/develop` loaded | `hsx --help \| grep -E -- '--restart\|--update\|--capture\|--launcher'`; `hs list --help \| grep -E -- '--failed\|--succeeded\|--remaining\|--count\|--fields'`; `hs update --help \| grep -E -- '--revert\|--failed\|--no-confirm'` | every option named appears |
| A4 | Gautschi | the config-across-versions check below | recorded either way; the outcome decides a close-run line, not PASS or FAIL |

**A4. Config written for 2.9.0, read by the 2.7.0 module (PLAN §5 Q13).** `HYPERSHELL_CONFIG_FILE`
makes HyperShell read only the file it names, so your own `~/.hypershell/config.toml` is neither
read nor changed. In `$RCAC_SCRATCH/workflow-automation/p4/config/`:

```bash
umask 077
openssl rand -hex 16 > key
printf '[server]\nauth = "%s"\n' "$(cat key)" > auth.toml
printf '[server]\nauth_eval = "cat %s/key"\n' "$PWD" > auth-eval.toml
: > empty.toml
module purge; module load hypershell/2.7.0
for c in auth auth-eval empty; do echo "--- $c"; HYPERSHELL_CONFIG_FILE="$PWD/$c.toml" hs --version; done
module purge; module load hypershell/develop
for c in auth auth-eval empty; do echo "--- $c"; HYPERSHELL_CONFIG_FILE="$PWD/$c.toml" hs --version; done
```

`auth.toml` sets the key the way every version reads it; `auth-eval.toml` uses `server.auth_eval`,
which HyperShell honours for the key from 2.8.7; `empty.toml` is the config moved aside. Expected,
from a workstation run of HyperShell 2.7.0 with cmdkit 2.7.7: under 2.7.0, `auth` and `empty`
print the version, and `auth-eval` ends in a traceback with
`AttributeError: 'auth' has more than one variant` (2.7.0's built-in default sets `server.auth`, and
cmdkit before 2.8.0 cannot merge it with a file's `auth_eval`; with cmdkit 2.8.0 the same 2.7.0
prints the version). Under `develop`, all three print the version. Record each result and, if you
can, the module's cmdkit version (`"$(head -1 "$(command -v hs)" | cut -c3-)" -c 'import cmdkit;
print(cmdkit.__version__)'`; skip it if the first line of `hs` is not a Python path). Optional, to
explain the crash seen earlier: `grep -cE '^[[:space:]]*auth_(eval|env)[[:space:]]*=' ~/.hypershell/config.toml`
prints a count, not the key. **If any 2.7.0 run crashes with `'auth' has more than one variant`,
the close run adds a one-line caution to the version admonition.**

#### B. `sbatch --test-only`, every tab

On each cluster's login node, assemble the tab as published and run
`sbatch --test-only -A <your account> frames.sub` (on Scholar, without `-A`; the file already says
`scholar`). PASS if sbatch prints `Job <n> to start at … in partition <p>` and no error. If Gautschi
or Negishi rejects `--qos=normal` for account reasons only, record that and repeat with
`-q standby`; a syntax or partition error is a FAIL. Mark a cluster N/A if you have no account
there.

| Cluster | Partition in the tab | Shape |
|---|---|---|
| Anvil | `wholenode` (no QOS line) | 2 nodes × 1 task × 128 CPUs |
| Gautschi | `cpu`, `normal` | 2 nodes × 1 task × 192 CPUs |
| Negishi | `cpu`, `normal` | 2 nodes × 1 task × 128 CPUs |
| Scholar | `cpu`, `normal` | 2 nodes × 1 task × 64 CPUs (fits both node types) |

#### C. Gautschi runs

All in `$RCAC_SCRATCH/workflow-automation/p4/frames/` unless stated. Set up:

```bash
cp <snippets>/frames/render-frame.sh .
printf 'sh render-frame.sh %d\n' $(seq 1 1200) > frames.txt
{ sed 's|^module load hypershell$|module load hypershell/develop|' <snippets>/frames/header-gautschi.sh; echo; cat <snippets>/frames/body.sh; } > frames.sub
mkdir -p frames
for n in 0005 0017 0333; do touch frames/frame_$n.pgm; chmod 444 frames/frame_$n.pgm; done
```

Check `wc -l < frames.txt` is 1200 and `head -1 frames.txt` prints `sh render-frame.sh 1`. The three
read-only files are the planted failures: the renderer cannot overwrite them, so frames 5, 17 and
333 exit 1. For the `hs` commands on the login node, use the page's setup with the develop module:
`module load hypershell/develop; export HYPERSHELL_SITE="$PWD/hypershell"`. Record each job's node
list (`sacct -j <id> -X --format=JobID,State,ExitCode,Elapsed,NodeList`).

**C1. First job, one node, cancelled mid-run.**

1. `sbatch -A "$ACCT" -q standby -N 1 frames.sub` → J1. Once it runs, watch `ls frames | wc -l`;
   when it is between 300 and 900 (the first 192 frames finish 10 to 29 seconds after the start),
   `scancel J1`. Record the count.
2. `slurm-J1.out` starts with `HyperShell v2.9.0a8` (the version line), then shows
   `Found 1200 tasks in …/frames.txt`, `Submitting all 1200 tasks from …/frames.txt as a new source
   (--restart)`, and many `Running task (…)` lines. `sacct` shows J1 `CANCELLED`.
3. `ls hypershell` shows `lib` and `log`, and `hypershell/lib/main.db` exists (the SQLite database
   on scratch).
4. `hs list --count` prints 1200. `hs list --completed --count` (C1) plus
   `hs list --remaining --count` (R1) is 1200. Record C1 and R1, and
   P1 = `hs list args --remaining | grep -cE 'render-frame.sh (5|17|333)$'` (planted frames not yet
   run).
5. `hs list args exit_status --failed` lists only planted frames, each with exit status 1. **Record
   any task with a negative exit status** (for example `-15`): that would be a task recorded as
   killed rather than left unfinished, which `--restart` would not re-run. The page then needs a
   sentence (close run).

**C2. Resubmit unchanged, one node, to completion.**

1. `touch marker`, then `sbatch -A "$ACCT" -q standby -N 1 frames.sub` → J2.
2. `slurm-J2.out` shows `Restarting …/frames.txt (source …): 1200 present; submitting only new tasks`,
   `1200 tasks already present; submitting 0 new tasks`, `Found <R1> unfinished tasks` and
   `Reverted <n> previously interrupted tasks` (record n). `sacct` shows J2 `COMPLETED 0:0`
   although three frames failed (the page says Slurm reports the job as completed).
3. `hs list --count` 1200 (nothing submitted twice); `hs list --succeeded --count` 1197;
   `hs list --failed --count` 3; `hs list --remaining --count` 0; `ls frames/*.pgm | wc -l` 1200.
4. `find frames -name '*.pgm' -newer marker | wc -l` equals R1 − P1: the job rendered only the frames
   that were unfinished after J1.
5. `hs list id args exit_status --failed` prints exactly three lines, for `sh render-frame.sh 5`, `17`
   and `333`, each with exit status 1. With the ID of frame 5, `hs info <id> --stderr` prints a line
   ending `frames/frame_0005.pgm: Permission denied`, and `hs info <id>` prints the task's record.
   `hs list --fields` lists the field names, `exit_status` among them.

**C3. Resubmit with nothing left to run.** `sbatch -A "$ACCT" -q standby -N 1 frames.sub` → J3.
`slurm-J3.out` shows `All previous tasks completed (1200) - stopping`, J3 is `COMPLETED` within about
a minute of starting, and `hs list --count` is still 1200.

**C4. Re-run the failures, two nodes (the tab as published, apart from the module line).**

1. `chmod 644 frames/frame_0005.pgm frames/frame_0017.pgm frames/frame_0333.pgm`.
2. `hs update --failed --revert` asks `Update affects 3 tasks, continue? yes/[no]:`; answer `yes`; it
   logs `Updated 3 tasks`. `hs list --remaining --count` is 3.
3. `touch marker2`, then `sbatch -A "$ACCT" -q standby frames.sub` → J4. J4 `COMPLETED`;
   `slurm-J4.out` shows `Found 3 unfinished tasks`; `find frames -name '*.pgm' -newer marker2` lists
   exactly the three frames; `hs list --succeeded --count` 1200 and `hs list --failed --count` 0.
   J1, J2 and J4 together show the database path working across jobs (record whether they ran on
   different nodes).

**C5. A full two-node run, one client per node.** In a new empty directory
`$RCAC_SCRATCH/workflow-automation/p4/frames2/`, repeat the set-up without the planted failures,
then `sbatch -A "$ACCT" -q standby frames.sub` → J5.

1. While it runs: `scontrol show step J5.0 | grep -oE '(CPUs|Tasks)=[0-9]+'` shows `Tasks=2` and
   `CPUs=384` (the launcher step got every core of both nodes; `CPUs=2` would mean `--cpus-per-task`
   did not reach the step, a FAIL). Optional: run `hs list --succeeded --count` two or three times
   from the login node during the run and record whether it answers without error (if it does, the
   close run may say these commands work while the job runs).
2. J5 `COMPLETED` with `Elapsed` under 5 minutes (1,200 frames of 10 to 29 seconds on 384 executors
   take about 1 to 2 minutes; one executor per node would hit the walltime).
3. `hs list --succeeded --count` 1200; `hs list client_host --all | sort | uniq -c` shows exactly two
   hosts, J5's two nodes, with counts adding to 1200.

**C6. Adding tasks (back in `frames/`).**

1. `echo 'sh render-frame.sh 1201' >> frames.txt`, then `sbatch -A "$ACCT" -q standby -N 1 frames.sub`
   → J6. `slurm-J6.out` shows `differs from its prior submission (content changed); pass --update
   --restart`, and no task runs. Record J6's `State` and `ExitCode`.
2. Change `--restart` to `--update --restart` in `frames.sub`, as the page says
   (`sed -i 's/hsx frames.txt --restart/hsx frames.txt --update --restart/' frames.sub`), and submit
   again with `-N 1` → J7. `slurm-J7.out` shows `submitting 1 new tasks`; J7 `COMPLETED`;
   `frames/frame_1201.pgm` exists; `hs list --count` 1201 and `hs list --succeeded --count` 1201.

#### D. Not covered by this envelope (record, do not run)

- **Anvil, Negishi and Scholar batch runs.** Checked by A1 and B only. The Anvil tab, like P2's,
  runs `module load` under `#!/bin/bash` in a non-login batch shell and relies on Slurm exporting
  the submit-time module environment. Anvil batch runs are out of scope: record "Anvil batch: not
  run" as a residual risk.
- **Walltime expiry.** C1 stops the job with `scancel`; Slurm ends a job at its walltime with the
  same signals, so C1 stands in for it.
- **The released module.** The merge hold re-runs C1–C4 on the default 2.9.0 module of Gautschi and
  Anvil (`P4-release: PASS`).
- **The `-r` tip.** Described from HyperShell's documentation and checked on a workstation with
  2.9.0a8 (`hs list --failed` lists the retried first attempts), not run here.

#### Results

Validated 2026-11-22 by the foreman against `136a0f10`. Build under test: Gautschi
`hypershell/develop`, `HyperShell v2.9.0a8 (CPython 3.14.6)`. The Gautschi run script is the
published Gautschi tab with only its module line changed to `module load hypershell/develop`.

- **A1** PASS. `module load hypershell` loads with no prerequisite and prints `HyperShell v2.7.0
  (CPython 3.13.3)` on Anvil, Gautschi, Negishi and Scholar (below 2.9.0, as expected until the
  merge hold clears).
- **A2** PASS with record. `hypershell/develop` prints `HyperShell v2.9.0a8 (CPython 3.14.6)`. Its
  `bin/` holds only `hs` and `hsx`: **no `hyper-shell` executable** (the 2.7.0 module has one). P7's
  relay clients start as `hyper-shell client`, so the develop module needs that entry point before
  P7 can validate (risk carried to P7).
- **A3** PASS. `hsx --help`: `--capture --launcher --restart --update`; `hs list --help`: `--count
  --failed --fields --remaining --succeeded`; `hs update --help`: `--failed --no-confirm --revert`.
- **A4** CONFIRMED. Under 2.7.0 (cmdkit 2.7.7) with `HYPERSHELL_CONFIG_FILE`: `auth` and `empty`
  print the version; `auth-eval` ends `AttributeError: 'auth' has more than one variant`. Under
  develop all three print the version. → close-run item F1.
- **B** PASS, 4/4. `sbatch --test-only` prints a start time for Anvil (`wholenode`, 256 CPUs on 2
  nodes), Negishi (`cpu`, 256), Scholar (`cpu`, 128 on `scholar-b`) and Gautschi (`cpu`, 384). On
  Gautschi the validation account's `normal` QOS was refused with `AssocGrpGRES` (an account limit,
  not a script fault); `-q standby` passed.
- **Envelope deviation (C).** Two whole Gautschi nodes on standby showed a start estimate six days
  out, so C1–C3 and C6 ran with `-N 1 -c 32`, C4 with `-N 2 -c 16` and C5 with `-N 2 -c 32` on the
  command line. The body sizes clients and executors from `$SLURM_CPUS_PER_TASK`, so the behaviour
  under test is unchanged.
- **C1** PASS. Cancelled at 390 files on disk (4:18, node a139), `CANCELLED`. Log: `Found 1200 tasks
  in …/frames.txt`, `Submitting all 1200 tasks … as a new source (--restart)`, `Running task` lines.
  `hypershell/` holds `lib` and `log`; `lib/main.db` exists. Total 1200; completed 390; remaining
  810; P1 = 0. `--failed` lists only frames 5, 17, 333, each exit status 1; no negative exit status.
- **C2** PASS. J2 `COMPLETED 0:0` (8:39, a139). Log: `1200 tasks already present; submitting 0 new
  tasks`, `Found 810 unfinished tasks`, `Reverted 36 previously interrupted tasks`. Total 1200,
  succeeded 1197, failed 3, remaining 0; 1200 `.pgm`; 810 newer than the marker (= R1 − P1).
  `hs info <frame 5> --stderr` ends `frames/frame_0005.pgm: Permission denied`; `hs info` prints the
  record (`group: 0`, `zone: default`); `hs list --fields` includes `exit_status`.
- **C3** PASS. J3 `COMPLETED` in 0:05; log `All previous tasks completed (1,200) - stopping` (the
  count prints with a thousands separator); total still 1200.
- **C4** PASS. `hs update --failed --revert` asked `Update affects 3 tasks, continue? yes/[no]:` and
  logged `Updated 3 tasks`; remaining 3. J4 (`-N 2`) `COMPLETED` in 0:32 on a[139,258]; `Found 3
  unfinished tasks`; exactly frames 5, 17, 333 newer than marker2; succeeded 1200, failed 0. The
  database carried across four jobs and onto a second node.
- **C5** PASS. Fresh run, `-N 2 -c 32`: step `.0` (`hs`) shows `Nodes=2 CPUs=64 Tasks=2` (one client
  per node with the full per-node CPU count; 384 at the published `-c 192`). `hs list --succeeded
  --count` answered cleanly mid-run. J5 `COMPLETED` in 6:38 at 64 executors; succeeded 1200;
  `client_host` 602 a139 + 598 a258.
- **C6** PASS. Appended `sh render-frame.sh 1201`: J6 stopped in 0:04, `FAILED 2:0`, `CRITICAL …
  differs from its prior submission (content changed); pass --update --restart to submit only the
  new tasks`, no task ran. With `--update --restart`: J7 `COMPLETED` in 0:16, `1200 tasks already
  present; submitting 1 new tasks`; `frame_1201.pgm` exists; total and succeeded 1201. → close-run
  item F2.
- **D** Not run: Anvil/Negishi/Scholar batch, walltime expiry (C1's `scancel` stands in), the
  released module (merge hold, `P4-release: PASS`), the `-r` tip.

Close-run items:
- **F1** Add the one-line caution to the version admonition: a configuration that uses `auth_eval`
  (or `auth_env`), written for 2.9.0, makes the older 2.7.0 module fail at start with `'auth' has
  more than one variant`; keep those keys out of a configuration an older module reads.
- **F2** Check that "Adding tasks later" says the plain `--restart` job stops with an error (the job
  fails, exit code 2) and names `--update --restart`, as observed.

P4: PASS — 2026-11-22 · Gautschi standby, hypershell/develop 2.9.0a8 · A1–A3, B 4/4, C1–C6 (reduced cores, as noted) · A4 confirmed · close-run items F1–F2

## P5 — GPU multiplexing and Tier 2 (V5)

Validation request for the P5 draft (the commit that adds this section), covering docs/workflows/hypershell/{gpu_multiplexing,extreme_scale}.md, docs/snippets/workflows/gpu_sweep/{header-anvil,header-gautschi,header-gilbreth,header-scholar,body,gpu-pick}.sh, docs/snippets/workflows/gpu_sweep/emulator.cu, docs/snippets/workflows/ensemble/{header-anvil,header-gautschi,header-negishi,header-scholar,body,member}.sh; result: pending.

### Validation request (written by the draft run, 2026-11-22)

**Build under test.** Gautschi's `hypershell/develop` module (2.9.0a8 today). Record its exact
`hs --version` in the PASS line. Neither page needs the `hyper-shell` executable or anything the
2.9.0a8 known issues touch: no `hs server --initdb`, no key, no `#` inside a task command, no
duration with units on `-w` or `--delay-start` (both plain seconds; `-W 300` is plain seconds too),
and the only environment variables for configuration keys are `HYPERSHELL_LOGGING_LEVEL` and
`HYPERSHELL_DATABASE_FILE`, whose key names hold no underscore. As in P4: if `srun` fails to start
the clients, `hsx` on a8 waits until the walltime instead of exiting, so a tier 2 job whose task
counts do not move for several minutes is a launch failure; record it.

**Envelope.** GPU page: Gautschi `-A "$ACCT" -p ai -q "$GPU_QOS"` (`$GPU_QOS` is the foreman's
choice at run time; `ai` does not accept `standby`), 1 node, 2 GPUs, 28 cores (14 per GPU), at most
15 minutes per job, at most 2 jobs queued. The Gautschi tab already says `ai`, one node, two GPUs,
28 cores and 15 minutes; pass the account and QOS on the command line. Tier 2: Gautschi
`-A "$ACCT" -p cpu -q standby`, at most 2 nodes × 20 minutes per job, at most 2 jobs queued. The
tier 2 tab asks for 4 nodes × 192 cores × 4 hours, so every tier 2 job below passes
`-q standby -N 2 -c 32 -t 00:20:00` on the command line, as P4 did; the body sizes executors and
bundles from `$SLURM_CPUS_PER_TASK`, so the behaviour under test is unchanged. Files only under
`$RCAC_SCRATCH/workflow-automation/p5/`. `$ACCT` is the validation account, kept out of the
repository. Anvil, Gilbreth, Negishi and Scholar get login-node checks and `sbatch --test-only`
only.

**Tabs.** The GPU page's tabs are Anvil, Gautschi, Gilbreth and Scholar, as PLAN §2 lists them
(Negishi's GPUs are AMD, and no ROCm check is in this envelope). Tier 2's tabs are P4's four CPU
clusters: Anvil, Gautschi, Negishi and Scholar.

**Assembling a tab.** As in P4: the header file, one empty line, then the shared body. This
reproduces the rendered tab byte for byte (checked against the built `site/` for all eight tabs and
the three other published files). The published headers say `module load hypershell`, which loads
2.7.0 on Gautschi today: there, `gpu-pick.sh` stops with `run this under HyperShell 2.9.0 or
later`, and `hsx` refuses a task file together with `--restart`. For the Gautschi runs, change that
one line and nothing else, and record that you did:

```bash
{ sed 's|^module load hypershell$|module load hypershell/develop|' gpu_sweep/header-gautschi.sh; echo; cat gpu_sweep/body.sh; } > gpu_sweep.sub
{ sed 's|^module load hypershell$|module load hypershell/develop|' ensemble/header-gautschi.sh; echo; cat ensemble/body.sh; } > ensemble.sub
```

All snippet paths are under `docs/snippets/workflows/`. `emulator.cu`, `gpu-pick.sh` and
`member.sh` are used as published (copy them as named).

**The GPU stand-in.** `emulator.cu` is a small CUDA program the page builds on a login node with
`module load cuda` and `nvcc` (the `cuda` module is in the software catalog on Anvil, Gautschi,
Gilbreth and Scholar; on Anvil it sits under `modtree/gpu`). Each run holds 1 GiB of GPU memory and
does 50 steps of a short kernel followed by a 60 ms sleep, then writes
`results/member_NNNN.txt` with its GPU's PCI bus address, its `TASK_SLOT` and its seconds. `nvcc`
links the CUDA runtime statically by default, so the job needs only the node's driver, not the
module. Two things the draft could not check: the program was not compiled with `nvcc` (its host
code was compiled and run on a workstation against stubs), and the kernel's run time per step on an
H100 is an estimate (about 20 ms, so a run takes roughly 4 to 5 seconds alone). Neither changes the
PASS conditions below, which do not depend on the timings.

**Draft-run checks (workstation, not a cluster).** With HyperShell 2.9.0a8 from PyPI: the GPU body
with a stub `nvidia-smi`, a shell stand-in for `emulator`, 24 tasks and `CUDA_VISIBLE_DEVICES=0,1`
gave slots 0, 2, 4, 6 on GPU 0 and 1, 3, 5, 7 on GPU 1 at the default of 4 tasks per GPU, and
slots 0 to 3 split the same way at `TASKS_PER_GPU=2`; `gpu-pick.sh` stops with a message when
`TASK_SLOT` or `CUDA_VISIBLE_DEVICES` is unset, and passes a MIG-style UUID list through unchanged.
The tier 2 body, with a stand-in `srun` that runs its command once and `-H 127.0.0.1` added
(the workstation's host name does not resolve), ran 20,000 pre-submitted members: killing the job's
process group at 40 seconds left 7,992 completed and 8,000 result lines; the unchanged resubmit
finished the remaining 12,008, and the two result files held 20,008 lines and 20,000 distinct
members. The job output held only the version line (no per-task log lines). `hs submit -b 10000`
loaded 100,000 tasks in 8 seconds, and a second `hs submit` of the same file was refused with
`pass --repeat to submit it again, or --update to add only new tasks` (exit status 2). The
`--no-db --no-confirm` line ran all 20,000 members and wrote no database. With
`HYPERSHELL_DATABASE_FILE=:memory:`, `hsx` ran a five-line file and wrote no database. The cluster
run is what counts.

#### A. Login-node checks (no job)

| # | Cluster(s) | Command | PASS if |
|---|---|---|---|
| A1 | Gautschi, Gilbreth, Negishi, Scholar; Anvil after `module load modtree/gpu` | `module load hypershell && hs --version` | loads with no other prerequisite; record the version per cluster (below 2.9.0 is expected). On Anvil also run it without `modtree/gpu` (the tier 2 tab) and record both. If Anvil's `hypershell` is not visible under `modtree/gpu`, that is a FAIL for the Anvil GPU tab's module lines (record `module spider hypershell` there). |
| A2 | Gautschi, Gilbreth, Scholar; Anvil after `module load modtree/gpu` | `module load cuda && nvcc --version` | loads; record the default CUDA version per cluster |
| A3 | Gautschi, in `$RCAC_SCRATCH/workflow-automation/p5/gpu/` | `module load cuda; nvcc -O2 -o emulator emulator.cu; echo $?`; `ldd emulator \| grep -c cudart` | exit 0 with no error (record any warning); the `grep -c` prints 0 (static runtime) or record what it links |
| A4 | Gautschi, with `hypershell/develop` | `hsx --help \| grep -E -- '--no-db\|--no-confirm\|--delay-start\|--bundlesize\|--bundlewait\|--task-timeout\|--template'`; `hs submit --help \| grep -- '--bundlesize'`; `hs list --help \| grep -- '--all'` | every option named appears |
| A5 | Gautschi, Gilbreth, Anvil, Scholar | `sinfo -p <gpu partition> -o '%N %G' \| head`; for one node of each, `scontrol show node <node> \| grep -E 'Gres=\|CfgTRES'` (partitions: Gautschi `ai`, Gilbreth `a100-80gb`, Anvil `gpu`, Scholar `gpu`) | recorded either way: the GRES strings, and whether any names `mps`, `shard` or a MIG type (expected on Scholar's MIG nodes only). The outcome decides the MPS and MIG sentences in the close run, not PASS or FAIL. |
| A6 | Gautschi, with `hypershell/develop`, in `$RCAC_SCRATCH/workflow-automation/p5/mem/` | `printf 'echo %d\n' 1 2 3 > three.txt; HYPERSHELL_SITE="$PWD/site" HYPERSHELL_DATABASE_FILE=:memory: hsx three.txt -N 1; ls site/lib/main.db` | prints 1, 2 and 3 (in any order) and `ls` reports no such file: `:memory:` behaves as `--no-db`, as the tier 2 page says |

#### B. `sbatch --test-only`, every tab

On each cluster's login node, assemble the tab as published and run
`sbatch --test-only -A <your account> <file>.sub` (on Scholar, without `-A`). PASS if sbatch prints
`Job <n> to start at … in partition <p>` and no error. If a `normal` QOS is refused for account
reasons only, record that and repeat with `-q standby` (Gilbreth, Gautschi `cpu`, Negishi) or the
QOS you have (Gautschi `ai`); a syntax, partition, ratio or GRES error is a FAIL. Mark a cluster N/A
if you have no account there.

| File | Cluster | Partition in the tab | Shape |
|---|---|---|---|
| `gpu_sweep.sub` | Anvil | `gpu` (no QOS line) | 1 node × 1 task × 64 CPUs, 2 GPUs |
| `gpu_sweep.sub` | Gautschi | `ai`, `normal` | 1 node × 1 task × 28 CPUs, 2 GPUs (14 per GPU) |
| `gpu_sweep.sub` | Gilbreth | `a100-80gb`, `normal` | 1 node × 1 task × 32 CPUs, 2 GPUs, `--mem=128G` |
| `gpu_sweep.sub` | Scholar | `gpu`, `normal` | 1 node × 1 task × 16 CPUs, 2 GPUs |
| `ensemble.sub` | Anvil | `wholenode` (no QOS line) | 4 nodes × 1 task × 128 CPUs, 4 h |
| `ensemble.sub` | Gautschi | `cpu`, `normal` | 4 nodes × 1 task × 192 CPUs, 4 h |
| `ensemble.sub` | Negishi | `cpu`, `normal` | 4 nodes × 1 task × 128 CPUs, 4 h |
| `ensemble.sub` | Scholar | `cpu`, `normal` | 4 nodes × 1 task × 64 CPUs, 4 h (the `normal` maximum) |

#### C. Gautschi GPU runs

Set up in `$RCAC_SCRATCH/workflow-automation/p5/gpu/k4/`: copy `emulator.cu` and `gpu-pick.sh`,
build `emulator` as in A3 (or copy A3's), write the task file with the page's command
`printf './emulator %d\n' $(seq 1 64) > sweep.txt` (check `wc -l < sweep.txt` is 64 and
`head -1 sweep.txt` prints `./emulator 1`), and assemble `gpu_sweep.sub` as above. For `hs` commands
on the login node: `module load hypershell/develop; export HYPERSHELL_SITE="$PWD/hypershell"`.
Record each job's `sacct -j <id> -X --format=JobID,State,ExitCode,Elapsed,NodeList`.

**C1. Four tasks per GPU (the script as published).** `sbatch -A "$ACCT" -q "$GPU_QOS" gpu_sweep.sub`
→ G1.

1. `slurm-G1.out` starts with `HyperShell v2.9.0a8`, then `GPUs in this job: <list>` (record the
   list: `0,1` means Slurm renumbers the job's GPUs), then a CSV table with a header row and two
   rows of `NVIDIA H100 …`. **Record the `compute_mode` column.** `Default` is expected. If it reads
   `Exclusive_Process`, only one process can use each GPU, the runs fail with a "busy or
   unavailable" error, and the page needs a redesign: a FAIL.
2. G1 `COMPLETED`. Record `Elapsed`.
3. `ls results | wc -l` 64; `hs list --succeeded --count` 64; `hs list --failed --count` 0 (no
   out-of-memory failures at 1 GiB per run).
4. `cut -d' ' -f2 results/member_*.txt | sort | uniq -c` shows exactly two `gpu=` values, 32 runs
   each, and each matches a `pci.bus_id` in G1's table. (`nvidia-smi` prints an eight-digit domain,
   `00000000:1B:00.0`, and CUDA a four-digit one, `0000:1B:00.0`; compare from the bus number on.)
5. `awk '{print $2, $3}' results/member_*.txt | sort -u` prints eight lines: slots 0, 2, 4 and 6
   with one GPU, slots 1, 3, 5 and 7 with the other, and no slot outside 0–7.
6. In `gpu-use-G1.txt`, the busiest sample shows four processes on one GPU:
   `awk '/^[0-9][0-9]:[0-9][0-9]:[0-9][0-9]$/ {t = $0; next} {split($0, f, ", "); n[t " " f[1]]++} END {for (k in n) if (n[k] > m) m = n[k]; print m}' gpu-use-G1.txt`
   prints 4. Both bus addresses appear in the file
   (`awk -F', ' 'NF == 3 {print $1}' gpu-use-G1.txt | sort | uniq -c`). Record the largest
   per-process memory: `awk -F', ' 'NF == 3 {sub(/ MiB/, "", $3); if ($3 + 0 > m) m = $3 + 0} END {print m " MiB"}' gpu-use-G1.txt`
   (expected a little over 1024 MiB; the page says each process adds a few hundred megabytes).
   If the job finished before the first sample (under 10 seconds of tasks), the file is empty:
   record it, and 6 is N/A.
7. Record the mean seconds per run:
   `awk -F'seconds=' '{s += $2} END {printf "%.1f\n", s / NR}' results/member_*.txt`.

**C2. Two tasks per GPU.** As the page says: `mkdir ../k2; cp emulator gpu-pick.sh sweep.txt gpu_sweep.sub ../k2/; cd ../k2`,
then `sbatch -A "$ACCT" -q "$GPU_QOS" --export=ALL,TASKS_PER_GPU=2 gpu_sweep.sub` → G2. Same checks
as C1 with these numbers: 64 results, 0 failed, two GPUs with 32 runs each, slots 0 and 2 on one GPU
and 1 and 3 on the other, and the busiest sample shows 2. Record `Elapsed` and the mean seconds.

**C3. One task per GPU.** The same in `../k1` with `TASKS_PER_GPU=1` → G3: slots 0 and 1 only, one
per GPU, the busiest sample shows 1. Record `Elapsed` and the mean seconds.

Record a table of k, `Elapsed` and mean seconds per run for C1–C3. The trend is a record item, not a
PASS condition. Expected: `Elapsed` falls from k = 1 to k = 4 while the mean seconds per run rises
modestly. The close run puts the table on the page as a measured illustration and checks the page's
"What to look for" sentences against it.

**C4 (optional, one short job).** If an allocation slot is free, a 2-minute job with the Gautschi
header (module line as above) and this body instead of the page's, to settle the MPS and MIG
sentences: `nvidia-smi -q | grep -iE 'compute mode|mig mode' | sort | uniq -c; command -v nvidia-cuda-mps-control || echo 'no MPS control'; nvidia-smi | head -4`.
Record the output (MIG mode, whether the MPS control program exists on the node, and the driver's
CUDA version). Not a PASS condition.

#### D. Gautschi tier 2 runs

Set up in `$RCAC_SCRATCH/workflow-automation/p5/ensemble/run/`: copy `member.sh`, assemble
`ensemble.sub` as above, then check the page's generator at full size and use 100,000 members for
the runs:

```bash
seq 1000000 | sed 's/^/sh member.sh /' | wc -l        # 1000000
seq 1000000 | sed 's/^/sh member.sh /' | head -1      # sh member.sh 1
seq 100000 | sed 's/^/sh member.sh /' > members.txt
sh member.sh 42                                        # one line: 42 <parameter> <warming>
```

Then, on the login node, the page's loading step:
`module load hypershell/develop; export HYPERSHELL_SITE="$PWD/hypershell"; time hs submit -b 10000 members.txt`.
PASS if it logs `Submitted 100000 tasks` and `hs list --count` prints 100000; record the time.
Running the same `hs submit` again is refused with `already submitted … pass --repeat to submit it
again, or --update to add only new tasks` and exit status 2, and `hs list --count` is still 100000.
Every job below is submitted as `sbatch -A "$ACCT" -q standby -N 2 -c 32 -t 00:20:00 ensemble.sub`
(call this *the D submit*).

**D1. First job, cancelled mid-run.** The D submit → E1. Once it runs, check
`hs list --completed --count` every 30 seconds; when it is between 10,000 and 90,000, `scancel E1`
and record the count (C1). If E1 finishes first, record that, skip the cancel, and go on.

1. `slurm-E1.out` holds the version line and no per-task lines: `grep -c 'Running task' slurm-E1.out`
   prints 0.
2. While it runs: `scontrol show step E1.0 | grep -oE '(CPUs|Tasks)=[0-9]+'` shows `Tasks=2` and
   `CPUs=64` (one client per node with the job's cores).
3. `wc -l < ensemble-E1.txt` is at least C1, and at most a few hundred more (result lines of members
   whose results had not reached the database). Record both.
4. `hs list --failed --count` 0.

**D2. Resubmit unchanged, to completion.** The D submit → E2.

1. E2 `COMPLETED 0:0`; record `Elapsed`. `slurm-E2.out` holds no `Running task` lines.
2. `hs list --succeeded --count` 100000; `hs list --remaining --count` 0; `hs list --failed --count`
   0.
3. `cat ensemble-*.txt | wc -l` is 100000 plus D1's surplus (record it), and the page's
   `sort -n -u -k1,1 ensemble-*.txt > ensemble.txt; wc -l < ensemble.txt` prints 100000.
4. `hs list id | head -3` is refused with a message naming `--all` (or `--limit`), as the page says;
   `hs list id --limit 3` prints three IDs.
5. Optional, for the staggered start: `hs list client_host start_time --all | sort -k2 | awk '!seen[$1]++'`
   prints each host's first task start; record how far apart they are (up to 30 seconds expected).

**D3. Throughput, tuned against defaults (illustration).** In two fresh directories,
`$RCAC_SCRATCH/workflow-automation/p5/ensemble/{tuned,default}/`, each with `member.sh`, a 20,000-member
`members.txt` (`seq 20000 | sed 's/^/sh member.sh /' > members.txt`) and its own
`HYPERSHELL_SITE`, load the tasks with `hs submit -b 10000 members.txt`. In `tuned/`, use
`ensemble.sub` as assembled. In `default/`, remove the bundling options, as the page's *Measure
throughput* section says:
`sed 's| -b "${executors}" -w 30||' ensemble.sub > ensemble-default.sub` (check with
`grep -c -- ' -b ' ensemble-default.sub`, which prints 0). Submit each with the D submit, one after
the other. Both `COMPLETED`, each with `hs list --succeeded --count` 20000. Record each `Elapsed`
and tasks per second (20000 ÷ seconds). The numbers are illustrations, not PASS conditions; note
that `--delay-start=-30` adds up to 30 seconds to each.

**D4. Without the database.** In a fresh directory `$RCAC_SCRATCH/workflow-automation/p5/ensemble/nodb/`,
with `member.sh` and the 100,000-member `members.txt` (no `hs submit`), build the page's variant by
changing only the `hsx` line:

```bash
{ sed 's|^module load hypershell$|module load hypershell/develop|' ensemble/header-gautschi.sh; echo; sed 's|^hsx --restart \\$|hsx members.txt --no-db --no-confirm \\|' ensemble/body.sh; } > ensemble-nodb.sub
grep -n 'hsx' ensemble-nodb.sub    # hsx members.txt --no-db --no-confirm \
```

The resulting `hsx` command is the page's `--no-db` block line for line. The D submit with
`ensemble-nodb.sub` → E4. E4 `COMPLETED`; `wc -l < ensemble-E4.txt` 100000;
`sort -n -u -k1,1 ensemble-E4.txt | wc -l` 100000; `ls hypershell/lib/main.db` reports no such file.
Record `Elapsed` and tasks per second.

#### E. Not covered by this envelope (record, do not run)

- **Anvil, Gilbreth, Negishi and Scholar batch runs.** Checked by A and B only; record "batch: not
  run" as a residual risk. The Anvil GPU tab's `module load modtree/gpu` runs in a non-login batch
  shell, as in P2 and P4.
- **NVIDIA MPS, MIG slices, ROCm on Negishi, and one client per GPU.** The page gives MPS and MIG
  one sentence each, has no Negishi tab, and names the one-client-per-GPU layout as not shown or
  tested. A5 and C4 record what the close run needs to keep or adjust those sentences.
- **Scale.** No run approaches a million tasks or more than two nodes. The tier 2 page cites
  HyperShell's documentation for its scale statement (more than 1,000 nodes and 250,000 executors)
  and its large-run advice (`--delay-start` rule of thumb, bundling with executors, the submit-once
  route), and states the leadership-facility notes as general practice.
- **The task timeout.** No member runs for 300 seconds; D shows only that `-W 300` is accepted. The
  page's caveat (the timeout signals the task's shell) comes from HyperShell's open issue on signal
  teardown, not from a run.
- **Heartbeats and eviction.** The 10-second heartbeat and 600-second eviction on the page are
  HyperShell's documented defaults; nothing here loses a node.
- **The released module.** As in P4, the merge hold re-runs the tier 1 checks on the default 2.9.0
  module; it does not re-run P5.

Close-run items expected whatever the outcome:
- **F1** Add C1–C3's table to the GPU page's *Choose how many tasks share a GPU* as a measured
  illustration (H100, this stand-in), and adjust the "What to look for" sentences if the trend
  differs.
- **F2** Add D3 and D4's tasks per second to the tier 2 page's *Measure throughput* as illustrations
  (two nodes at 32 cores each, trivial tasks), labelled as such.
- **F3** Keep or adjust the MPS and MIG sentences from A5 and C4.

#### Results

*(validator)*

P5: PENDING — docs/snippets/workflows/gpu_sweep/{header-anvil,header-gautschi,header-gilbreth,header-scholar,body,gpu-pick}.sh, gpu_sweep/emulator.cu, docs/snippets/workflows/ensemble/{header-anvil,header-gautschi,header-negishi,header-scholar,body,member}.sh · A1–A6, B 8 tabs, C1–C3 (C4 optional), D1–D4

## P6 — Tier 3 (V6)

Validation request for the P6 draft (the commit that adds this section), covering docs/workflows/hypershell/pipelines.md, docs/snippets/workflows/panel/{config.toml,panel.sh,submit-phases.sh,schedule-clients.sh,header-anvil.sh,header-gautschi.sh,header-negishi.sh,header-scholar.sh,body.sh}; result: pending.

### Validation request (written by the draft run, 2026-11-23)

**Build under test.** Gautschi's `hypershell/develop` module (2.9.0a8 today). Record its exact
`hs --version` in the PASS line. Tier 3 avoids every 2.9.0a8 known issue it could meet: it runs
`hs initdb` as its own step (never `hs server --initdb`), keeps the key's `auth_eval` in the
configuration file (never `HYPERSHELL_SERVER_AUTH_EVAL`, an underscore key that a8 cannot read from
the environment), sets no configuration key from the environment at all, passes no `-k`, puts no `#`
inside a task command, uses only integer groups, and gives `-T 600` in plain seconds. It does not
need the `hyper-shell` executable. **One page statement a8 cannot validate:** the refusal of a
submission below the reached group (`Task group 0 is below the reached group 1 of the database
(nothing submitted)`, exit status 2). It landed after a8 (HyperShell #118, in 2.9.0a9); a8 accepts
such a submission. The draft checked it on a workstation (below). Optional C9 checks it on Gautschi
with 2.9.0a9 from PyPI, if the job budget allows.

**Envelope.** One HyperShell server on a Gautschi login node, run for this validation only and
stopped at the end (C11). Files only under `$RCAC_SCRATCH/workflow-automation/p6/`. Client jobs:
`-A "$ACCT" -p cpu -q standby`, 1 node × 32 cores × 15 minutes each (the page asks for 1 node; the
envelope allows 2), at most 4 client jobs over the whole run and at most 2 queued at once. The run
below needs 2 to 4 client jobs (J1 to J3, plus J1′ if J1 ends before C6), and holds at most one job
per zone at a time (`MAX_JOBS=1`), so never more than 2 at once. C0's probe is a 2-minute
single-core job, not a client job. `$ACCT` is the validation account, kept out of the repository.
Anvil, Negishi and Scholar get login-node checks and `sbatch --test-only` only.

**The login node.** The page runs the server on `login00.gautschi.rcac.purdue.edu`; the choice of
node is yours. Pick one, record `hostname -f`, and run every step of C on that node: the server, the
helper, `hs submit` and every `hs list` (the page's rule: everything that opens the database runs
on the server's host). If your shell does not stay on one node between commands, prefix each step
with `ssh <node>`, and record that you did. Background processes must outlive the command that
starts them (the page uses `nohup … &` and a PID file); if your tool ends them when a command
returns, start them with `setsid nohup …` instead, and record it.

**Assembling a tab.** As in P4: the header file, one empty line, then the shared body. This
reproduces the rendered tab byte for byte (checked against the built `site/` for all four tabs and
the four other published files):

```bash
{ cat header-<cluster>.sh; echo; cat body.sh; } > client.sub
```

The helper submits `client.sub` itself, so the envelope's settings go into the Gautschi run copy's
header, together with the module line. Change these lines and nothing else, and record that you did
(`<snippets>` is `docs/snippets/workflows`):

```bash
{ sed -e 's|^module load hypershell$|module load hypershell/develop|' \
      -e "s|^#SBATCH --account=myallocation$|#SBATCH --account=$ACCT|" \
      -e 's|^#SBATCH --qos=normal$|#SBATCH --qos=standby|' \
      -e 's|^#SBATCH --cpus-per-task=192$|#SBATCH --cpus-per-task=32|' \
      -e 's|^#SBATCH --time=04:00:00$|#SBATCH --time=00:15:00|' \
      <snippets>/panel/header-gautschi.sh; echo; cat <snippets>/panel/body.sh; } > client.sub
grep -c '^#SBATCH' client.sub     # 8
```

The body sizes the client from `$SLURM_CPUS_PER_TASK`, so the behaviour under test is the same at 32
cores. Every helper run in C sets `MAX_JOBS=1 HIGHMEM_PARTITION=cpu`: one job per zone, and the
`highmem` zone's jobs go to `cpu` as a stand-in (the envelope has no `highmem` jobs; B checks the
`highmem` partition with `--test-only`). `panel.sh`, `submit-phases.sh` and `schedule-clients.sh`
are used as published.

**Draft-run checks (workstation, not a cluster).** The whole of C ran on macOS twice, with
HyperShell 2.9.0a8 from PyPI and with 2.9.0a9 built from its tag, using stand-in `sbatch` and
`squeue` scripts (each "job" ran `client.sub` in the background with 8 cores), `panel.sh` with its
sleeps cut to 1 second, and `HYPERSHELL_SERVER_HOST=127.0.0.1` in the environment because the
workstation's host name does not resolve. Both versions gave the same results: `hs submit` loaded
48 + 48 + 24 + 1 tasks and refused the repeated batch 1 (`pass --repeat to submit it again, or
--update to add only new tasks`, exit 2); the server logged `Task group 0 waiting on zone cpu: 96
tasks, no client serving it`; the first helper pass submitted one `cpu` job and a second pass none;
with `aligned/L050.txt` read-only, 95 alignments succeeded, `align L050` failed with exit status 1,
the server logged `Failed task group 0 (at least 1 tasks exceeding allowed retries, …)` and did not
start group 1, and the helper printed `Group 0 has failed tasks: revert or cancel them with hs
update` and submitted nothing; after `chmod 644` and `hs update --failed --revert` the still-running
`cpu` client ran it, the server logged `Completed task group 0 - starting task group 1`, the next
pass submitted one `highmem` job, the idle `cpu` client ran the merge when group 2 started, `hs wait`
on the merge task returned, `panel-calls.txt` held 2,304 lines with 96 per region, and `SIGUSR1`
stopped the server, after which both client "jobs" ended. Separately, with a `highmem` task of
group 1 running, `hs submit --group 0` was refused on 2.9.0a9 with the message above (exit 2) and
accepted on 2.9.0a8; with no group-1 task sent to a client yet, both accepted it (the reached group
counts only groups with a task sent to a client). A server started on a port already in use logged
`Cannot listen on 0.0.0.0:<port> ([Errno 48] Address already in use)` and exited with status 5. The
cluster run is what counts.

#### A. Login-node checks (no job)

| # | Cluster(s) | Command | PASS if |
|---|---|---|---|
| A1 | Anvil, Negishi, Scholar | `module load hypershell && hs --version` | loads with no prerequisite; record the version (2.7.0 expected, as in P4 A1) |
| A2 | Gautschi, with `hypershell/develop` | `hs --version`; `hs submit --help \| grep -E -- '--group\|--zone'`; `hs client --help \| grep -E -- '--zone\|--capture\|--timeout'`; `hs list --help \| grep -E -- '--group\|--order-by\|--limit\|--all\|--cancelled'`; `hs server --help \| grep -- '--forever'`; `hs update --help \| grep -E -- '--revert\|--cancel\|--no-confirm'`; `hs initdb --help \| grep -- '--yes'` | `HyperShell v2.9.0a8 …` or later, and every option named appears |
| A3 | Anvil, Gautschi, Negishi, Scholar | `sinfo -s -p highmem` | a `highmem` row on Anvil, Gautschi and Negishi; none on Scholar (the page says Scholar has no high-memory partition) |
| A4 | Gautschi | `hostname -f`; `getent hosts login00.gautschi.rcac.purdue.edu`; from a login node other than login00, `ssh login00.gautschi.rcac.purdue.edu hostname` (optional) | record each: the node C will use, that login00 resolves, and whether the page's `ssh` step works from another login node |
| A5 | Gautschi | `command -v openssl seq nohup`; `seq -f 'L%03g' 1 3 \| tr '\n' ' '` | all three found; prints `L001 L002 L003` |
| A6 | Gautschi | `squeue --noheader --user="$USER" --name=panel-cpu --format=%i; echo "rc=$?"` | `rc=0` with no error (the helper's count of client jobs) |

#### B. `sbatch --test-only`, every tab

On each cluster's login node, assemble the tab as published and run the helper's own `sbatch` lines
with `--test-only` and your account: for the `cpu` zone,
`sbatch --test-only -A <your account> --job-name=panel-cpu client.sub cpu`, and for the `highmem`
zone, `sbatch --test-only -A <your account> --job-name=panel-highmem --partition=highmem client.sub highmem`
(on Scholar, without `-A`, and only the `cpu` line: the page sends Scholar's `highmem` clients to
`cpu`). PASS if sbatch prints `Job <n> to start at … in partition <p>` and no error. If a `normal`
QOS is refused for account reasons only (P4 saw `AssocGrpGRES` on Gautschi `cpu`), record that and
repeat the `cpu` line with `-q standby`; `highmem` takes only `normal` on Gautschi and Negishi, so a
refusal there for account reasons only is recorded, not a FAIL. A syntax, partition or core-count
error is a FAIL. Mark a cluster N/A if you have no account there.

| Cluster | Zone | Partition | Shape |
|---|---|---|---|
| Anvil | `cpu` | `wholenode` (no QOS line) | 1 node × 1 task × 128 CPUs, 4 h |
| Anvil | `highmem` | `highmem` | 1 node × 1 task × 128 CPUs, 4 h |
| Gautschi | `cpu` | `cpu`, `normal` | 1 node × 1 task × 192 CPUs, 4 h |
| Gautschi | `highmem` | `highmem`, `normal` | 1 node × 1 task × 192 CPUs, 4 h (more than 48 cores, as the partition requires) |
| Negishi | `cpu` | `cpu`, `normal` | 1 node × 1 task × 128 CPUs, 4 h |
| Negishi | `highmem` | `highmem`, `normal` | 1 node × 1 task × 128 CPUs, 4 h (more than 64 cores) |
| Scholar | `cpu` | `cpu`, `normal` | 1 node × 1 task × 64 CPUs, 4 h (the `normal` maximum) |

#### C. Gautschi run (server on a login node)

Set up on the chosen login node, in `$RCAC_SCRATCH/workflow-automation/p6/panel/`, following the
page's *Set up the campaign* with the develop module:

```bash
module load hypershell/develop
mkdir -p $RCAC_SCRATCH/workflow-automation/p6/panel/hypershell
cd $RCAC_SCRATCH/workflow-automation/p6/panel
export HYPERSHELL_SITE="$PWD/hypershell"
export HYPERSHELL_CONFIG_FILE="$HYPERSHELL_SITE/config.toml"
cp <snippets>/panel/panel.sh <snippets>/panel/submit-phases.sh <snippets>/panel/schedule-clients.sh .
seq -f 'L%03g' 1 48 > batch-1.txt
seq -f 'L%03g' 49 96 > batch-2.txt
(umask 077; openssl rand -hex 32 > hypershell/auth.key)
cp <snippets>/panel/config.toml hypershell/config.toml
```

Then assemble `client.sub` as above. If the chosen node is not login00, set `server.host` to its full
name (and record it): `sed -i "s|^host = .*|host = \"$(hostname -f)\"|" hypershell/config.toml`.
`HYPERSHELL_CONFIG_FILE` keeps your own `~/.hypershell/config.toml` out of every step: it is
neither read nor changed. Every `hs` command below runs in this directory with the two variables
set. Record each job's `sacct -j <id> -X --format=JobID,JobName,Partition,State,ExitCode,Elapsed,NodeList`.

**C0. Network probe first (PLAN §5 Q5).** Before starting HyperShell, check that a compute node can
reach the login node's port. On the login node:

```bash
timeout 300 python3 -c 'import socket; s = socket.socket(); s.bind(("0.0.0.0", 50101)); s.listen(); c, a = s.accept(); print("connection from", a)' > probe.txt 2>&1 &
sbatch -A "$ACCT" -p cpu -q standby -n 1 -c 1 -t 00:02:00 -o probe-%j.out \
    --wrap "timeout 10 bash -c 'exec 3<>/dev/tcp/$(hostname -f)/50101' && echo OPEN || echo CLOSED"
```

PASS if `probe-<id>.out` says `OPEN` and `probe.txt` says `connection from ('<address>', …)`
(record the address). If the bind fails with `Address already in use`, choose another port, use it
here and in `server.port`, and record it. **If the probe says `CLOSED`, stop C here and escalate**:
the design keeps the server on a login node, so a blocked port needs RCAC network help (PLAN §5 Q5),
not a redesign.

**C1. Configuration, database and server.**

1. `hs config get server.host` prints the chosen node; `hs config get server.port` prints `50101`
   (or C0's port); `hs config get database.file` prints `…/p6/panel/hypershell/lib/main.db`.
   `ls -l hypershell/auth.key` shows `-rw-------`.
2. `hs initdb` (add `--yes` if your shell has no terminal: without one, `hs initdb` refuses to run
   with `Non-interactive prompt cannot confirm (see --yes)`; record which) logs
   `SQLite database initialized automatically`; `hypershell/lib/main.db` exists.
3. Start the server as the page says: `nohup hs server --forever > hypershell/server.log 2>&1 &` then
   `echo $! > hypershell/server.pid`. Within a few seconds `hypershell/server.log` shows
   `Generated self-signed TLS certificate (…/hypershell/lib/tls/server.crt)`, `Certificate
   fingerprint: SHA256:…`, `Scheduler will run forever`, `Empty database - waiting for initial
   tasks` and `Server listening on 0.0.0.0:50101`.
4. `ps -o args= -p "$(cat hypershell/server.pid)"` prints `… hs server --forever` and nothing that
   looks like a key (R12).

**C2. Helper with nothing to do.** `MAX_JOBS=1 HIGHMEM_PARTITION=cpu sh schedule-clients.sh` prints
`No tasks waiting`, exits 0 and submits nothing.

**C3. Submit the phases, with one planted failure.**

1. `sh submit-phases.sh align batch-1.txt` logs `Submitted 48 tasks`; `head -1 tasks/align-batch-1.txt`
   prints `sh panel.sh align L001`.
2. The same command again is refused: `… was already submitted as source … pass --repeat to submit
   it again, or --update to add only new tasks`, exit status 2 (`echo $?`).
3. Plant the failure: `mkdir -p aligned; touch aligned/L050.txt; chmod 444 aligned/L050.txt`.
4. `sh submit-phases.sh align batch-2.txt` (48), `sh submit-phases.sh genotype` (24),
   `sh submit-phases.sh merge` (1), each logging `Submitted <n> tasks`.
5. `hs list group zone --remaining --all | sort | uniq -c` prints three lines: `96 0 cpu`,
   `24 1 highmem`, `1 2 cpu` (a tab between group and zone). `hypershell/server.log` shows
   `Task group 0 waiting on zone cpu: 96 tasks, no client serving it`.

**C4. First helper passes.** `MAX_JOBS=1 HIGHMEM_PARTITION=cpu sh schedule-clients.sh` prints
`Submitted batch job <J1>` and `Group 0, zone cpu: 96 tasks waiting, 0 client jobs, 1 submitted`.
Run it again at once: `Group 0, zone cpu: 96 tasks waiting, 1 client jobs, 0 submitted`, and no new
job. `squeue -j <J1> -o '%j %P %q %C %l'` prints `panel-cpu cpu standby 32 15:00`.

**C5. Group 0 runs; the failure holds group 1.**

1. Once J1 runs, `slurm-<J1>.out` starts with `HyperShell v2.9.0a8`, then `Running task (…)` lines,
   and no connection or TLS error. (If J1 runs for several minutes with no `Running task` line,
   record the output: the client cannot reach the server.)
2. When `hs list --group 0 --remaining --count` reaches 0 (about 2 to 3 minutes at 32 cores):
   `hs list --group 0 --succeeded --count` 95; `hs list id args exit_status --failed` prints one
   line, `sh panel.sh align L050` with exit status 1; `hs info <its id> --stderr` ends
   `aligned/L050.txt: Permission denied`.
3. `hypershell/server.log` shows `Failed task group 0 (at least 1 tasks exceeding allowed retries,
   example: <id>)` and no `starting task group 1`; `hs list --group 1 --completed --count` 0.
4. A helper pass prints `Group 0 has failed tasks: revert or cancel them with hs update` and
   submits nothing.

**C6. Re-run the failure.** `chmod 644 aligned/L050.txt`, then `hs update --failed --revert`: it asks
`Update affects 1 tasks, continue? yes/[no]:`; answer `yes` (with no terminal, add `--no-confirm`;
record which); it logs `Updated 1 tasks`. If J1 is still running, it runs the task within about
30 seconds (the held server polls the database at most every 30 seconds);
if J1 has ended, a helper pass submits J1′ for it (record which). Then `hs list --group 0
--succeeded --count` 96, `aligned/L050.txt` holds 24 lines, and the server log shows `Completed task
group 0 - starting task group 1`.

**C7. Group 1, zone highmem.** A helper pass prints `Submitted batch job <J2>` and
`Group 1, zone highmem: 24 tasks waiting, 0 client jobs, 1 submitted`; `squeue -j <J2> -o '%j %P'`
prints `panel-highmem cpu` (the stand-in partition). When `hs list --group 1 --remaining --count`
is 0:

1. `hs list --group 1 --succeeded --count` 24; `ls regions | wc -l` 24; `wc -l < regions/region_01.txt`
   96, which shows that genotyping started only after every line, L050 included, was aligned.
2. Only J2's client ran group 1, and J2 ran nothing else:
   `grep -o 'Running task ([0-9a-f-]*)' slurm-<J2>.out | tr -d '()' | awk '{print $3}' | sort > j2.txt`;
   `hs list id --group 1 --all | sort > g1.txt`; `cmp j2.txt g1.txt && echo same` prints `same`.

**C8. Group 2 and the end of the pipeline.** The server log shows `Completed task group 1 -
starting task group 2`. If a `cpu` client is still running (J1 or J1′, within its 10 idle minutes),
it runs the merge; otherwise a helper pass prints `Group 2, zone cpu: 1 tasks waiting, 0 client
jobs, 1 submitted` for J3 (record which). Then:

1. `hs wait "$(hs list id --group 2 --limit 1)"` returns, logging `Task completed (…)`.
2. `wc -l < panel-calls.txt` 2304; `hs info <merge id> --stdout | head -2` prints
   `region 1 96 lines` and `region 2 96 lines`.
3. `hs list --succeeded --count` 121; `hs list --failed --count` 0; `hs list --remaining --count` 0.
4. A helper pass prints `No tasks waiting`.
5. Each client job ends on its own within about 10 minutes of its last task (`-T 600`), or at its
   15-minute walltime, whichever is first: record each job's `State` and `Elapsed`.

**C9 (optional, only if C used at most 3 client jobs). The reached-group refusal on 2.9.0a9.** In a
fresh directory `$RCAC_SCRATCH/workflow-automation/p6/reached/`, install 2.9.0a9 in user space
(`module load uv; uv tool install 'hypershell==2.9.0a9' --python 3.13`; record `hs --version` and
how its `hs` gets on `PATH`, in your shell and in a batch job). Set the two variables there, make a
fresh `hypershell/` with a key and the config (`server.host` as in C, and another port if 50101 is
still in use), and start a server with that build as in C1. Then
`printf 'sleep 300\n' > slow.txt; printf 'echo late\n' > late.txt` and
`hs submit --group 1 --zone highmem slow.txt`. Submit one `highmem` client job from that directory
(a copy of C's `client.sub` whose module line is replaced by whatever puts the 2.9.0a9 `hs` on
`PATH`; `sbatch --job-name=panel-highmem client.sub highmem`). While its task runs
(`hs list --group 1 --remaining --count` 1, and the job's log shows `Running task`):
`hs submit --group 0 --zone cpu late.txt` is refused with `Task group 0 is below the reached group 1
of the database (nothing submitted)`, exit status 2, and `hs list --count` stays 1. Then `scancel`
the job and stop that server with `SIGUSR1`.

**C10. The helper loop.** With nothing waiting, start the page's loop:
`nohup sh -c 'while true; do sh schedule-clients.sh; sleep 300; done' > hypershell/scheduler.log 2>&1 &`
then `echo $! > hypershell/scheduler.pid`. Within a few seconds `hypershell/scheduler.log` holds
`No tasks waiting`. `kill $(cat hypershell/scheduler.pid)`; then `kill -0 $(cat
hypershell/scheduler.pid)` fails (the loop has ended). No job was submitted. (The loop runs with the
helper's defaults, but with no work waiting it submits nothing.)

**C11. Stop and restart the server.**

1. `kill -s USR1 $(cat hypershell/server.pid)`. Within about 30 seconds `hypershell/server.log` shows
   `Signal interrupt (SIGUSR1)` and `kill -0 $(cat hypershell/server.pid)` fails. Any client job
   still running ends within a minute (record its `State`).
2. Restart as the page says (`nohup hs server --forever …` and the PID file). The log shows `All
   previous tasks completed (121) - waiting for new tasks` and `Server listening on 0.0.0.0:50101`;
   `hs list --count` 121.
3. Stop it again with `SIGUSR1`, as in 1. Nothing of this campaign is left running on the login
   node: `ps -u "$USER" -o pid,args | grep -E '[h]s server|[s]chedule-clients'` prints nothing.

#### D. Not covered by this envelope (record, do not run)

- **Anvil, Negishi and Scholar runs, and `highmem` jobs.** Checked by A and B only; record "batch:
  not run" as a residual risk. As in P4, the tabs run `module load` in a non-login batch shell.
- **The reached-group refusal on 2.9.0a8.** Not in a8 (see *Build under test*). Without C9, the
  page's statement rests on the workstation run with 2.9.0a9 and on HyperShell's documentation.
- **A long campaign.** No run lasts days, crosses a login-node reboot, or survives the user logging
  out; C11 shows that a stopped server restarts on the same database. Whether `nohup` keeps the
  server through a logout is not tested (HyperShell also handles `SIGHUP` itself, for log rotation,
  without stopping).
- **The released module.** As in P4, the merge hold re-runs the tier 1 checks on the default 2.9.0
  module; it does not re-run P6.

Close-run items expected whatever the outcome:
- **F1** If C0 needed another port, or the login node's full host name differs from the form the
  page uses, adjust the page's port sentence or host-name sentence to match.
- **F2** Check the page's quoted log lines (server start, waiting on zone, failed group, helper
  messages) against C's output, and the *Make the key* and *Start the server* steps against what
  the validator had to change (for example `setsid`).

#### Results

*(validator)*

P6: PENDING — docs/snippets/workflows/panel/{config.toml,panel.sh,submit-phases.sh,schedule-clients.sh,header-anvil.sh,header-gautschi.sh,header-negishi.sh,header-scholar.sh,body.sh} · A1–A6, B 7 lines, C0–C8, C10–C11 (C9 optional)

## P7 — Tier 4 (V7, including the manual Rancher walk-through)

## Network confirmations

*(PLAN §5 Q5: compute node → login node port on Gautschi and Negishi; login00 → Geddes LoadBalancer)*
