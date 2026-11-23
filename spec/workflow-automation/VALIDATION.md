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

P2: PENDING — docs/snippets/workflows/{sample-data.sh, job_arrays/{header-anvil,header-gautschi,header-negishi,header-scholar,body}.sh, gnu_make/{header-anvil,header-gautschi,header-negishi,header-scholar,body}.sh, gnu_make/Makefile, gnu_parallel/{header-anvil,header-gautschi,header-negishi,body}.sh} (draft `[feature] Draft workflow-automation P2`)

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

*(validator)*

## P3 — Workflow managers (V3)

## P4 — Guide landing page and Tier 1 (V4)

## P5 — GPU multiplexing and Tier 2 (V5)

## P6 — Tier 3 (V6)

## P7 — Tier 4 (V7, including the manual Rancher walk-through)

## Network confirmations

*(PLAN §5 Q5: compute node → login node port on Gautschi and Negishi; login00 → Geddes LoadBalancer)*
