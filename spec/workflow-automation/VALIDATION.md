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

P3: PENDING — docs/workflows/{snakemake,nextflow,pegasus,parsl}.md, docs/snippets/workflows/{snakemake/Snakefile, parsl/config.py, parsl/count.py} (draft `[feature] Draft workflow-automation P3`)

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

## P5 — GPU multiplexing and Tier 2 (V5)

## P6 — Tier 3 (V6)

## P7 — Tier 4 (V7, including the manual Rancher walk-through)

## Network confirmations

*(PLAN §5 Q5: compute node → login node port on Gautschi and Negishi; login00 → Geddes LoadBalancer)*
