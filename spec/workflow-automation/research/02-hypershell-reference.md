# Research 02 — HyperShell option and configuration reference (for R6–R12, R15)

Grounded reference for everything the tiered HyperShell guide uses. Read 2026-11-22.

**Sources.** The HyperShell repository (github.com/hypershell/hypershell), `develop` branch at
`54915454`, cited as repo-relative paths (`docs/cli/cluster.rst`, `docs/_include/cluster_help.rst`,
`src/hypershell/...`). Release notes on the HyperShell website (`hypershell.org/blog/hypershell-2-N-0`,
linked from the docs home page), cited as "notes vX.Y". PyPI and GHCR read on the web the same day.
Where docs are silent, `src/` is cited.

**Version marks.** `2.9.0` items were checked against the git tags. Two states matter because 2.9.0
is **not released** (see §0):

- **[a8]** in the published pre-release **2.9.0a8** (PyPI, 2026-11-14).
- **[dev]** merged to `develop` after 2.9.0a8, documented as 2.9.0, **not in any published
  package yet** (expected in final 2.9.0). A page that relies on a [dev] item must either wait for
  2.9.0 final or avoid it.

Minimum versions for pre-2.9 features come from the release notes (2.2.0 onward) or from the source
at the git tags (2.0.0–2.5.0). "unknown" means neither settles it.

---

## 0. Release status of 2.9.0 (blocking fact for R6 and the GOAL's "documents 2.9.0")

- `pyproject.toml` on `develop`: `version = "2.9.0a8"`. Git tags end at `2.9.0a8` (2026-11-13); no
  `2.9.0` tag.
- PyPI (pypi.org/project/hypershell, read 2026-11-22): latest **stable 2.8.7** (2026-11-12);
  latest **pre-release 2.9.0a8** (2026-11-14); pre-releases 2.9.0a1 (2026-07-23) … a8.
  `requires-python >=3.11`.
- `pip install hypershell` / `uv tool install hypershell` installs **2.8.7**. 2.9 needs
  `pip install --pre hypershell` or a pin (`hypershell==2.9.0a8`) (notes v2.9.0, "About these
  notes"; `docs/index.rst` "What's new" admonition).
- 56 commits on `develop` since 2.9.0a8, 17 of them `[fix]`/`[feature]` (#103–#119). `ROADMAP.md`
  still lists open items targeted at 2.9.0, including a queue-envelope change planned as
  **2.9.0a10**. So at least a9 and a10 precede final.
- **2.8 ↔ 2.9 wire incompatibility:** a 2.8 client cannot talk to a 2.9 server or the reverse; the
  mismatch fails fast with exit status 5 (notes v2.9.0, "Upgrade the server and every client
  together"). The first 2.9 process upgrades a 2.8 database in place, forward-only; back it up
  first (same section; `docs/_include/database.rst` "Initialization").
- RCAC modules top out at 2.7.0 (GOAL Clarifications). Nothing in this file is available from
  today's modules unless marked ≤2.7.

---

## 1. Command forms (R12)

`src/hypershell/__init__.py` `HyperShellApp.commands`: `cluster`, `server`, `client`, `relay`,
`submit`, `config`, `initdb`, `info`, `wait`, `run`, `list`, `update`, plus `task` ("left for
backwards compatibility"). `pyproject.toml` `[project.scripts]`: `hs`, `hsx` (= `hs cluster`),
`hyper-shell` ("do not remove").

| Doc file (HyperShell repo) | Top-level command | Top-level form since |
|---|---|---|
| `docs/cli/task_submit.rst`, `docs/cli/submit.rst` | `hs submit` | 2.7.0 (notes v2.7.0, "Simplified Command-line Interface"); `hs submit` itself 2.0.0 |
| `docs/cli/task_info.rst` | `hs info` | 2.7.0 |
| `docs/cli/task_wait.rst` | `hs wait` | 2.7.0 |
| `docs/cli/task_run.rst` | `hs run` | 2.7.0 |
| `docs/cli/task_search.rst` | `hs list` | 2.7.0 |
| `docs/cli/task_update.rst` | `hs update` | 2.7.0 (as `hs task update` since 2.2.0) |
| — | `hsx` | 2.7.0 |
| — | `hs` program name | 2.5.0 (notes v2.5.0; `hyper-shell` before) |
| `docs/cli/relay.rst` | `hs relay` | 2.9.0a6 |

Queue key on a command line: `-k/--auth` still **accepted** on `hs client`, `hs server`,
`hs submit` in 2.9.0a8 (`src/hypershell/client.py` at tag 2.9.0a8, line 1594); **refused** with a
usage error [dev] (#104; `docs/security.rst` "Authentication Key", versionchanged 2.9.0). Supply it
by `HYPERSHELL_SERVER_AUTH` or `server.auth` (or `server.auth_env` / `server.auth_eval`). `hs relay`
has no key option at all; its upstream key is `relay.upstream.auth` (+ `_env`/`_eval`) only.

---

## 2. `hs cluster` / `hsx`

Sources: `docs/cli/cluster.rst` (versionadded/changed list), `docs/_include/cluster_desc.rst`,
`docs/_include/cluster_help.rst`, `docs/_include/cluster_usage.rst`.

### 2.1 Input

| Item | Spelling | Default | Since |
|---|---|---|---|
| Task file | positional `FILE` | stdin | 2.0.0 |
| JSON plan | `--from-json FILE[@path]` | — | 2.9.0a1 (#48) |
| Inline per-line directives | `# HYPERSHELL: key:val ...` (tags, `group:N`, `cores:`, `memory:`, `timeout:`) | — | inline tags 2.6.0 (notes v2.6.0); comment-only directive lines apply to following lines 2.7.0 (notes v2.7.0) |
| `#` handling | a line whose first non-blank char is `#` is a comment; a `#` elsewhere stays in the command | — | [dev] (#118). In a8 and earlier the command is **cut at the first `#`**. |

**Correction to the brief:** `-N` is `--num-threads` (executors **per client**, default 1; `-N0`
auto-detects cores), not `--num-tasks`. `-N4 --ssh 'a[00-01]'` = 2 clients × 4 = 8 executors
(`cluster_help.rst` "-N").

### 2.2 `--restart`, `--repeat`, `--update` (R7)

| Flag | Semantics (`cluster_help.rst`) | Since |
|---|---|---|
| `--restart` (no FILE) | Resume from the database: any task scheduled but not completed is reverted, scheduling continues, cluster halts when nothing is left. | 2.0.0 |
| `FILE --restart` | File-aware, idempotent. File read up front (fingerprint + count); only tasks whose identity (hash of pre-template args, group, tags) is **not already present** from a prior submission of the same absolute path are submitted; interrupted tasks re-run. Changed content is **refused**, suggesting `--update --restart`. Safe to requeue the same job script repeatedly. | 2.9.0a1 (#50). Before 2.9, `FILE` and `--restart` were mutually exclusive. |
| `FILE --update --restart` | New source; only tasks new since the file was last seen are submitted. `--update` alone is refused. | 2.9.0a1 (#50) |
| `--repeat` | Submit all of a known file's tasks again as a new source (pair with tags for a new trial). | 2.9.0a1 (#50) |
| Re-submission gate | Submitting an already-ingested named file without `--restart`/`--update`/`--repeat` is refused. stdin and single-command submissions are exempt. | 2.9.0a1 |

Conflicts: `--restart` conflicts with `--no-db` and `--repeat`, mutually exclusive with `--forever`.

**What a rerun does and does not re-run** (`src/hypershell/server.py` scheduler start, lines
~255–275; `src/hypershell/data/model.py` `count_remaining`, `count_interrupted`,
`revert_interrupted`):

- Re-runs: tasks never started, and tasks **interrupted** (`schedule_time` set, `completion_time`
  null), which are reverted at scheduler start. This revert happens on every database-backed
  start, not only under `--restart`.
- Skips: **every completed task, failed ones included.** A task that exited non-zero has a
  `completion_time`; if every task is completed the scheduler logs "All previous tasks completed …
  stopping" and exits. A rerun does **not** re-try failures by itself.
- Failures are retried only (a) within a run via `-r/--max-retries` (a new task row per attempt;
  original kept), or (b) after the user reverts them: `hs update --failed --revert` (then rerun the
  job). Caveat for (b): `--failed` is `exit_status != 0`, which also matches cancelled tasks (−1)
  and failed originals that were already retried (`retried` true, retry in `next_id`). Narrow with
  `-w` on the `retried` field (a `Task.columns` field, `data/model.py`); the exact where-syntax for a
  boolean needs validation before publish.
- Statement R7 can make, grounded: "Rerunning the same job script with `--restart` submits only
  tasks that never landed and re-runs anything that was cut off; completed tasks, successful or
  not, are skipped. To re-run failures, revert them with `hs update` first or use `-r`."
  The GOAL's phrase "picks up only unfinished or failed work" is **not accurate** for failed
  work without one of those steps.

**Database requirement.** `--restart` needs a database (conflicts with `--no-db`). Since 2.8.0 a
SQLite database is on by default at `<site>/lib/main.db`, i.e. `~/.hypershell/lib/main.db` on Linux
(notes v2.8.0, "Local SQLite database enabled by default"; `src/hypershell/core/config.py`
`DEFAULT_DATABASE_FILE`). Every run shares that one file unless the job sets `HYPERSHELL_SITE`
(moves lib, log, local config and the default DB to `$HYPERSHELL_SITE/{lib,log,config.toml}`;
`src/hypershell/core/platform.py`, created with `makedirs`) or `HYPERSHELL_DATABASE_FILE`. The
HyperShell tutorial draft sets `HYPERSHELL_SITE` per chapter on a scratch path for exactly this
reason. A database file of `:memory:` runs as `--no-db` (2.8.6 / 2.9.0a7, notes v2.9.0). The docs
say nothing about SQLite on Lustre for the main database (only the relay DB: "node-local disk, not a
network filesystem", `docs/_include/database.rst` "Relay Database"); validate a scratch-hosted
SQLite DB on a cluster before recommending it.

### 2.3 Launch modes

| Flag | Meaning | Default | Since |
|---|---|---|---|
| (none) | clients run in-process locally | — | 2.0.0 |
| `--launcher ARGS...` | one invocation launches all clients, e.g. `--launcher=srun` or `--launcher='srun --mpi=pmi2'` | — | 2.0.0 |
| `--mpi` | = `--launcher=mpirun` | — | 2.0.0 |
| `--ssh HOST...`, `--ssh-group NAME`, `--ssh-args ARGS`, `-E/--env` | SSH launch; `--env` exports `HYPERSHELL_*` except the key | — | 2.0.0 |
| `--remote-exe PATH` | client executable on remote hosts | `sys.argv[0]` minus trailing `x` (`src/hypershell/cluster/__init__.py` l.212) | 2.0.0 |
| `-H/--bind ADDR` | server bind | localhost; 0.0.0.0 for remote clients | 2.8.0 (notes v2.8.0) |
| `--advertise ADDR` | address launched clients dial | by `-H` | [dev] (#107) |
| `-p/--port` | 50001 | | 2.0.0 |

Key hand-off: launched clients get the per-run key in `HYPERSHELL_SERVER_AUTH`; the launcher must
pass its environment through. `srun` does by default; **`srun --export=NONE` leaves clients
without a key** (2.8.5 / 2.9.0a5; `docs/security.rst` "How cluster launches hand the key to their
clients"). Open MPI launchers get the variable forwarded automatically.

Launch failure: with `--ssh/--mpi/--launcher`, if all launched processes exit, one non-zero, with
tasks left, the cluster exits non-zero naming them [dev] (#107). In a8 it waits forever.

### 2.4 Bundling, throughput, scheduling

| Flag | Default | Notes | Since |
|---|---|---|---|
| `-b/--bundlesize SIZE` | 1 | coordinate with executors per client | 2.0.0 |
| `-w/--bundlewait SEC` | 5 | units/Slurm time [dev] (#106); a8: seconds | 2.0.0 |
| `-Q/--poll SEC` | 5 (cluster help); `server.poll` default 30 (`config_param_ref.rst`) | cap of exponential back-off | functional 2.8.0 (notes v2.8.0 "Fixed server poll") |
| `-r/--max-retries NUM` | 0 | needs DB; `server.attempts` = retries+1; `hsx` reads `server.attempts` only [dev] (#117) | 2.0.0 |
| `--eager` | off | failed before new; honoured by `hs cluster` since 2.8.0 (notes v2.8.0) | 2.0.0 |
| `--no-db` | off | publish straight to queue; no restart/retry/history | 2.0.0 |
| `--no-confirm` | off | drop client receipt confirmations (throughput); disables orphan recovery | 2.2.0 (notes v2.2.0) |
| `--initdb` | — | auto-create tables (PostgreSQL); automatic for SQLite | 2.0.0 |
| `--forever` | off | keep scheduling; conflicts `--no-db`, exclusive with `--restart` | 2.0.0 |
| `-d/--delay-start SEC` | 0 | leading `-` = uniform random delay up to value (`--delay-start=-600`); write with `=`. Units [dev] (#106) | 2.0.0 |
| `-R/--ratelimit NUM` | none | tasks/s per client; fractional [dev] | 2.8.0 |
| `-T/--timeout SEC` | never | client idle shutdown; units since 2.8.7/2.9.0a7 | 2.4.0 (notes v2.4.0) |
| `-W/--task-timeout SEC` | none | per-task walltime; SIGINT→SIGTERM→SIGKILL; inline `#HYPERSHELL: timeout:1:30:00`; units since 2.8.7/2.9.0a7 | 2.4.0 |
| `-S/--signalwait SEC` | 10 | escalation wait | 2.5.0 (notes v2.5.0) |
| `-c/--cores`, `-m/--memory` | none | per-task requirement; inline `cores:`/`memory:`; units powers of 1024, read correctly since 2.8.7/2.9.0a7 | 2.8.0 |
| `-C/--client-cores`, `-M/--client-memory` | all | partition a node among clients | 2.8.0 |
| `--monitor` | off | per-task CPU/memory time series, `hs info --perf` | 2.8.0 |
| `--capture` | off | per-task `<site>/lib/task/<uuid>.out/.err` on the client host; `hs info --stdout/--stderr` (SFTP fetch if needed) | 2.0.0 |
| `-o/--output`, `-e/--errors PATH` | stdout/stderr | local mode only | 2.0.0 |
| `-f/--failures PATH` | none | write failed tasks' original args to a file | 2.0.0 |

Task never ran: exit `-1001` (template failed) and `-1002` (needs more cores/memory than client);
were `-2`/`-3` before 2.9.0a1 (notes v2.9.0). Never retried, group fails at once [dev] (#119).
A killed task records `-N` for signal N (2.9.0a1).

### 2.5 Templates (`-t/--template`, default `{}`) — `docs/_include/templates.rst`

Expanded by the client just before execution (cluster forwards it).

| Pattern | Meaning | Since |
|---|---|---|
| `{}` | whole arg line | 2.0.0 |
| `{.}` `{..}` `{/}` `{/-}` `{-}` `{+}` `{++}` | path ops | unknown (present on develop; not checked per tag) |
| `{[0]}`, `{[1:3]}`, `{[::2]}` | arg slicing | unknown |
| `{% cmd @ %}` | **shell expansion; contains literal `{%` … `%}`** | unknown |
| `{= x * math.pi =}` | Python lambda (`os`, `path`, `math`, `dt`) | unknown |
| `{key}` | named fields from `--from-json` (submit-time) | 2.9.0a1 (#48) |
| `{slot}`, `{slot_count}` | executor slot (client-side expansion only) | 2.9.0a1 (#52) |

**Jinja (MkDocs-macros) hazards.** The `macros` plugin is on in `mkdocs.yml` with default
delimiters, so any of `{{`, `{%`, `{#` in page text or code blocks is parsed:

- `{% … %}` — HyperShell's shell-expansion template. Must be escaped (raw block) if shown.
- No HyperShell syntax uses `{{`. Apptainer def files do (`{{ VERSION }}` in the repo's
  `Apptainer`), and so do GitHub-Actions-style snippets; avoid or escape.
- `{#` — Jinja comment opener: appears in bash `${#array[@]}` / `${#var}`. A helper script using
  it would be silently mangled. Avoid or escape.
- `{= =}`, `{slot}`, `{zone}`, `{/-}`, `{[0]}` are safe.

### 2.6 Autoscaling and zones on `hs cluster`

| Flag | Default | Since |
|---|---|---|
| `-A/--autoscaling [fixed\|dynamic]` | off; policy default `fixed` (`autoscale.policy`) | 2.4.0 (notes v2.4.0) |
| `-F/--factor` | 1 (task pressure = `toc / (factor × avg_duration)`; >1 adds one client) | 2.4.0 |
| `-P/--period` | 60; must be >0 [dev] (#112) | 2.4.0 |
| `-I/--init-size` | 1 | 2.4.0 |
| `-X/--min-size` | 0 | 2.4.0 |
| `-Y/--max-size` | 1 (was 2 before 2.8.0) | 2.4.0 |
| `autoscale.failed_launches` | 3 consecutive non-zero launches with no registered client stops the cluster; `0` = forever | [dev] (#107) |
| `--zone NAME` | tasks from FILE go to this zone; launched clients get the same `--zone`; needs DB | 2.9.0a4 (#78) |
| per-zone scaling, `{zone}` in `--launcher`, `HYPERSHELL_ZONE` in launcher env | each zone with tasks in the active group gets its own fleet; `--init-size`/`--min-size` apply to the cluster's own zone only; at most one client per zone per period | 2.9.0a8 (#99). The v2.9.0 notes (a7) still say "Autoscaling is not zone-aware yet": superseded in a8. |

With `--autoscaling`, `--launcher` launches **one client per call** (a scaling unit), unlike plain
`--launcher` (one call for all clients). Example launcher from the docs:
`--launcher='srun -p {zone} -n1'`, or a `sh launch.sh` that maps `$HYPERSHELL_ZONE` to a partition
(`cluster_help.rst` "-A"). `{zone}` is literal text inside `--launcher`; it is not a Jinja hazard.

Open defect: **SIGUSR1 stops an autoscaling cluster's scheduling but not the process** (it ends only
on SIGTERM) — `issues/autoscaling-cluster-ignores-usr1.md`, target 2.9.x, unshaped.

### 2.7 Signals and walltime — `docs/_include/signals.rst`, `ROADMAP.md`

- `SIGUSR1`: schedulers halt; clients finish current and locally queued tasks, then drain. Since
  2.5.0 (notes v2.5.0).
- `SIGUSR2`: same, and clients interrupt running tasks (SIGINT→SIGTERM→SIGKILL). 2.5.0.
- `SIGHUP`: rotate file log (2.8.0). A task killed by `SIGHUP` records −1 = cancelled.
- **Do not claim graceful SIGTERM.** `ROADMAP.md` "No process-group ownership; SIGTERM and Ctrl-C
  tear down without cleanup" (`issues/process-group-signal-teardown.md`, target 2.9.x, open): a plain
  `kill`/Slurm's end-of-walltime SIGTERM hits Python's default disposition, orphans task processes,
  and causes duplicate re-execution on restart; walltime (`-W`) kills only the `sh` wrapper, not a
  pipeline's children. A guide wanting a clean stop before Slurm walltime should deliver `SIGUSR1`
  (or `SIGUSR2`) to the `hsx` process ahead of the limit; exact `#SBATCH --signal` form needs
  validation (B: prefix targets only the batch shell, so `hsx` must be `exec`'d or the signal
  forwarded).

---

## 3. Checking results: `hs list`, `hs info`, `hs wait`, `hs update`, `hs run`

All of these read or write **the database directly** (no server needed), so they need the same
database configuration as the run (`docs/_include/task_search_desc.rst`: "A database must be
configured").

### `hs list` — `docs/cli/task_search.rst`, `docs/_include/task_search_help.rst`

`hs list [FIELD ...] [-w COND ...] [-t TAG ...] [-g GROUP] [--part N] [-s FIELD [--desc]]
[--count | --limit NUM | --all] [-f FORMAT | --json | --csv] [-d CHAR] [-i]
[--failed | --succeeded | --completed | --remaining] [--retries]`; also `--fields`, `--tag-keys`,
`--tag-values KEY`.

| Option | Alias for | Since |
|---|---|---|
| `-F/--failed` | `-w 'exit_status != 0'` | 2.2.0 (src at tag) |
| `-S/--succeeded` | `exit_status == 0` | 2.2.0 |
| `-C/--completed` (`--finished`) | `exit_status != null` | 2.5.0 |
| `-R/--remaining` | `exit_status == null` | 2.2.0 |
| `-X/--cancelled` | `exit_status == -1` | 2.9.0a1 |
| `--signal NAME` | `exit_status == -N` (`--signal KILL` ≈ OOM kill) | 2.9.0a1 |
| `--retries` | `attempt > 1` | unknown |
| `-w/--where` | `== != >= <= > < ~`(regex) | 2.0.0 |
| `-t/--with-tag` | key or key:value | 2.4.0 |
| `-g/--group` | one group | 2.8.0 |
| `-c/--count`, `-l/--limit`, `-s/--order-by` | | 2.0.0 |
| `--all` | required to return >1,000 rows (else refused unless `--limit`/`--count`) | 2.9.0a1 |
| `-f/--format` | `normal`, `card` (2.9.0a2), `plain`, `table`, `csv`, `json`; FIELD names ⇒ `plain` | 2.0.0 |
| `--part N`, `-i/--ignore-partitions` | SQLite rotation partitions | 2.9.0a2 / 2.8.0 |

Fields (`src/hypershell/data/model.py` `Task.columns`): `id group args submit_id submit_time
submit_host cores memory cores_max memory_max timeout server_id server_host schedule_time client_id
client_host command start_time completion_time exit_status outpath errpath csvpath attempt retried
waited duration previous_id next_id` (+ `source fingerprint zone part tag` in the model). No `--zone`
filter exists on `hs list` (usage has none). Bare `hs list` prints usage. Terminal output is colored
by exit status (2.9.0a1) — the guide must not rely on color alone (R14).

Example forms (grounded): `hs list --failed --count`; `hs list id args exit_status --failed --csv
--all`; `hs list -t trial:2 --succeeded --count`.

### `hs info` — `docs/_include/task_info_help.rst`

`hs info ID [-f normal|card|json|yaml] [--json|--yaml] [-x FIELD] [--stdout|--stderr|--perf] [-i]`.
`--stdout/--stderr` need `--capture`; `--perf` needs `--monitor` (2.8.0). `card` 2.9.0a2.

### `hs wait` — `docs/_include/task_wait_help.rst`

`hs wait ID [-n SEC] [--info [-f FORMAT] | --status | --return]`. One task ID only; there is no
"wait for a group / all tasks" form. `-r/--return` exits with the task's status.

### `hs run` — `docs/_include/task_run_desc.rst`

Submit one task and block until a server schedules it; prints its stdout/stderr locally (requires
clients with `--capture`). `hs run [-n SEC] [-t TAG ...] -- ARGS...`. Needs a database and a running
server with clients. Not a launcher.

### `hs update` — `docs/cli/task_update.rst`, `docs/_include/task_update_help.rst`

`hs update [FIELD=VALUE | KEY:VALUE ...] [--cancel | --revert | --delete] [--remove-tag TAG ...]
[-w COND ...] [-t TAG ...] [-g GROUP] [-s FIELD [--desc] --limit NUM]
[--failed|--succeeded|--completed|--remaining] [--retries] [-X] [--signal NAME] [-f/--no-confirm]`;
legacy `hs update ID FIELD VALUE`.

- `--revert`: task as new (keeps ID, submit info, tags) — the way to re-run failures.
- `--cancel`: terminal, exit −1; not scheduled, retried or reverted on `--restart`. A task already
  sent to clients cannot be cancelled this way; `kill -HUP` its process instead.
- Bulk forms `--cancel/--revert/--delete`, filters, `--no-confirm`: 2.5.0 (notes v2.5.0).
  `--delete` with `--limit`: 2.6.0. `-X`, `--signal`: 2.9.0a1. Atomic/contended semantics [dev].
- Interactive confirmation unless `-f/--no-confirm` (note: `-f` here is not `--failed`).
- Changes go **before** filters (`hs update group=7 color:red -t color:blue`).
- Does not reach tasks a relay already holds (`docs/cli/relay.rst` "What a relay does not do").

---

## 4. `hs submit` — `docs/cli/submit.rst`, `docs/_include/submit_desc.rst`, `submit_help.rst`

`hs submit [ARGS... | -f FILE | --from-json SPEC] [-q [-H ADDR] [-p NUM] | --initdb] [-b NUM]
[-w SEC] [-c NUM] [-m MEM] [-W SEC] [-g NUM] [--repeat | --update] [--template CMD] [-t TAG...]
[--zone NAME] [TLS options]`.

- Writes tasks **straight into the database** (bundled), not through the server, unless `-q`. A
  login-node `hs submit` against a remote PostgreSQL/TimescaleDB therefore needs a network route to
  the database port and the DB credentials (capstone network exposure, R10).
- A single positional non-executable file path is read as a task file; `-f/--task-file` explicit
  (2.7.0).
- `-q/--queue`: live queue, bypass DB (2.8.0); since 2.9.0a4 the server must run `--no-db`, else
  refused. Uses `server.auth`/`HYPERSHELL_SERVER_AUTH`.
- `--template CMD`: expanded **at submit time** (not `-t`, which is `--tag` here). `{slot}` is not
  available at submit time; use `TASK_SLOT`.
- `-t/--tag key:value ...`: tags (2.4.0); tags become `TASK_TAG_<KEY>` in the task env (2.5.0, notes
  v2.5.0 "Tagging system improvements").
- `-g/--group NUM` (default 0): 2.8.0. `--zone NAME`: 2.9.0a4. `--repeat`/`--update`/re-submission
  gate: 2.9.0a1. `-c/-m/-W` defaults per task: 2.8.0 (`-W` since 2.4.0 as task timeout config).

### Task groups (what a group is in 2.9.0) — `docs/_include/task_groups_alt.rst`

- An integer per task; groups run in ascending order; every task of the active group must reach a
  terminal state before the next group schedules; no order within a group. Set with `-g`, inline
  `# HYPERSHELL: group:N`, `-t group:N`, or a JSON `group` key. Persisted in the DB column `group`.
  Introduced **2.8.0** (notes v2.8.0, "Task groups for dependency management").
- A group still holding failed tasks (retries exhausted) halts scheduling with a critical message;
  under `--forever` the server warns and waits for them to be cleared or reverted with `hs update`.
- A named FILE to `hs cluster`/`hs server` is read in full first, so groups run in order regardless
  of file order (2.8.4 / 2.9.0a3). Streams schedule as they arrive (best effort).
- Integer-only groups, refusal of non-integers [dev] (#118); a8 accepts `group:x` (known issue).
- **Reached group** [dev] (#118): the highest group the current run has started (a run = work since
  the DB last held no unfinished task). With a DB, `hs submit` refuses (exit 2) any submission
  holding a task below the reached group; a submission naming no group takes the reached group.
  `hs cluster`/`hs server` refuse a FILE the same way. Not in a8 (a8 runs a late lower group after
  the current one, with a warning — 2.9.0a3).
- Clients and servers do not "select" groups: the server dispatches only the active group; clients
  select by **zone**. Autoscaler pressure counts only the active group.

### Zones — `submit_help.rst` "--zone", `client_help.rst` "--zone", notes v2.9.0 "Zones"

- A free-text name (≤256 printable chars) tying tasks to the clients allowed to run them; placement
  only. Default zone = no `--zone` (or `default`). A client with no zone runs only default-zone tasks.
- Needs a DB (not with `submit -q` or `cluster --no-db`). Retry keeps zone. A group with tasks in a
  zone no client serves stays open, logged. 2.9.0a4 (#78).
- One line each: **zone = where a task may run (placement); group = when it may run (order).**

---

## 5. `hs server` and `hs client`

### `hs server` — `docs/cli/server.rst`, `docs/_include/server_help.rst`

`hs server [FILE | --forever | --restart] [-b NUM] [-w SEC] [-r NUM [--eager]] [-c NUM] [-m MEM]
[-W SEC] [-H ADDR] [-p PORT] [-Q SEC] [--no-db [--no-confirm] | --initdb] [--print | -f PATH]
[TLS] [--autoscaling [MODE] [-F VALUE] [-P SEC]]`.

| Item | Default | Since |
|---|---|---|
| `-H/--bind` | localhost (use 0.0.0.0 for remote clients) | 2.0.0 |
| `-p/--port` | 50001 | 2.0.0 |
| `--forever` | off | 2.0.0 |
| `--restart` | revert interrupted, continue; FILE+`--restart` refused (2.8.0) | 2.0.0 |
| `--no-db` | off | 2.0.0 |
| `--initdb` | initializes DB at launch | flag 2.0.0; **broken in a8** (does not initialize; known issue in notes v2.9.0), fixed [dev] (#105). Run `hs initdb` first. |
| `server.bundlemax` | 1000 (cap per client reply; no CLI) | 2.9.0a4 |
| `server.evict` | 600 s heartbeat silence ⇒ evict | config key old; honoured by `hs cluster` [dev] |
| `-A/--autoscaling [fixed\|dynamic]` | publishes client targets for relay sites; launches nothing; implies forever; conflicts FILE, `--restart`, `--no-db`, `--no-confirm` | 2.9.0a8 (#100) |
| `-F/--factor`, `-P/--period` | 1 / 60 | 2.9.0a8 (server form) |
| `--print` / `-f/--failures` | failed args to stdout / file | 2.0.0 |

There is no `--zone` on `hs server` (zones are per task and per client).

Key: `HYPERSHELL_SERVER_AUTH` or `server.auth` (+ `auth_env`, `auth_eval`); refuses the built-in
placeholder and keys <16 chars or outside `[A-Za-z0-9._+/=-]` (2.8.0, notes v2.8.0 "Authentication
key requirements"). `auth_env`/`auth_eval` for the key broke every command before 2.8.7/2.9.0a7
(notes v2.9.0 "The key can come from an environment variable or a command").

### `hs client` — `docs/cli/client.rst`, `docs/_include/client_help.rst`

`hs client [-N NUM] [-t TEMPLATE] [-b SIZE] [-w SEC] [-H ADDR] [-p PORT]
[--capture | [-o PATH] [-e PATH]] [--no-confirm] [-d SEC] [-T SEC] [-W SEC] [-S SEC] [-R NUM]
[-C NUM] [-M MEM] [--monitor] [--zone NAME] [TLS]`.

- `-H/--host` default localhost (config `server.host`), `-p/--port` 50001.
- `-N/--num-threads` default 1; `-N0` auto.
- `-b/--bundlesize`: since 2.9.0a4 the size the client **requests**; unset ⇒ server's `-b`.
  `client.bundlesize` config honoured only [dev] (#119); in a8 `hs client` reads `submit.bundlesize`
  (known issue in notes v2.9.0).
- `-T/--timeout`: idle shutdown; clock starts after `--delay-start` (2.8.4).
- `--zone NAME`: runs only that zone's tasks (2.9.0a4).
- Key from env/config only (2.9.0 [dev] refuses `-k`; a8 still accepts it).

### TLS — `docs/_include/tls_cli_options.rst`, `docs/security.rst` "Built-in TLS"

On by default since **2.8.0**. Flags on server, client, submit, cluster: `--no-tls`, `--tls-cert`,
`--tls-key`, `--tls-ca` (default `<auto>`). Auto self-signed RSA-3072 cert at
`<site>/lib/tls/server.{crt,key}` on first start; fingerprint logged at INFO only on first generation
(`src/hypershell/core/tls.py` l.449). Config `[server.tls]`: `enabled`, `cert`, `key`, `cafile`,
`fingerprint`, `insecure`, `min_version` (TLSv1.2), `ciphers`, `servername`, `handshake` (30 s,
[dev] #108). `cafile=<auto>` trusts the server's own cert file directly, which works only on one host
or a shared filesystem; across hosts use `fingerprint` (simplest) or `cafile`+`servername`. No mutual
TLS: the key authenticates clients, TLS authenticates the server.

---

## 6. `hs relay` (R10 design input)

Sources: `docs/cli/relay.rst` (incl. "Topology", "What a relay does not do"),
`docs/_include/relay_desc.rst`, `relay_help.rst`, `relay_usage.rst`, `docs/cli/server.rst`
"Autoscaling with relay sites", `docs/security.rst` "Relays", `docs/_include/database.rst` "Relay
Database", `config_param_ref.rst` `[relay]`, `src/hypershell/relay/{__init__,site}.py`.
Introduced **2.9.0a6** (#82); topology and server-side site autoscaling **2.9.0a8** (#100, #101).

**What it is.** One process per site: upstream an ordinary *client* of a standalone `hs server`
(one connection, one identity per zone served); at its site a *server* of its own (private SQLite
"relay database") that schedules received tasks to *clients it launches* there through the site's
launcher, keeping a fleet per zone, and returns results upstream with attribution to the site
client that ran each one. Purpose: reach a site whose compute nodes cannot reach the upstream server,
without handing the campaign key to every node. "Use a relay for reach, not for throughput"
(1.2–1.4× slower than a direct `hs cluster` on 2,000 short tasks, notes v2.9.0).

**Usage:** `hs relay [-H ADDR] [-p NUM] [--no-tls] [--zone NAME ...] [-N NUM] [--launcher CMD]
[--launcher-args ARGS] [--bind ADDR] [--advertise ADDR] [--port NUM] [--database PATH]`.

| Option / key | Default | Notes |
|---|---|---|
| `-H/--upstream-host`, `relay.upstream.host` | localhost | upstream server |
| `-p/--upstream-port`, `relay.upstream.port` | 50001 | |
| `relay.upstream.auth` (+`_env`, `_eval`) | — | **only** source of upstream key; never `[server]`, never CLI |
| `--no-tls`, `relay.upstream.tls.{enabled,cert,cafile,fingerprint}` | TLS on | verify upstream with `cafile` (CA or the server's own cert) or `fingerprint`. TLS on/off mismatch exits at once [dev] (#103); in a8 it retries forever as a connection error. |
| `--zone NAME` (repeatable), `relay.zone` (name, list, or `[relay.zone.NAME]` tables) | default zone | per-zone `launcher`, `launcher_args`, `size`, `min`, `max`, `init` |
| `-N/--size`, `relay.size` | 1 (≥1) | clients kept launched; vs an autoscaling server = default `max` |
| `relay.min` / `relay.max` / `relay.init` | 0 / size / min | bounds advertised upstream (2.9.0a8, #100); `min ≤ init ≤ max`; read at start (restart to change) |
| `--launcher CMD`, `relay.launcher` | none (clients run on relay host) | each client launched as `CMD [ARGS] hyper-shell client ...`; `{zone}` substituted; `HYPERSHELL_ZONE` set; must pass env (site key arrives in `HYPERSHELL_SERVER_AUTH`) |
| `--launcher-args`, `relay.launcher_args` | none | one quoted string |
| `--bind`, `relay.bind` | 0.0.0.0 | site clients connect here; must be reachable from compute nodes |
| `--advertise`, `relay.advertise` | by bind (0.0.0.0 ⇒ host name) | [dev] (#116) |
| `--port`, `relay.port` | 50002 | |
| `--database`, `relay.database` | `<lib>/relay/<host>.db` | always private SQLite; put on node-local disk; one relay per file (lock) |
| `relay.num_threads` / `relay.template` / `relay.timeout` | 1 / `{}` / 0 (never) | site client `-N`, `-t`, `-T`; **no CLI flags** |
| `relay.bundlesize` / `bundlewait` / `poll` / `retention` | 1 (≥num_threads) / 5 / 0.1 / 300 | |
| `relay.upstream.bundlesize` / `heartrate` / `deadline` / `backoff` / `evict_hint` | 1000 / 10 / 30 / 60 / 600 | set `evict_hint` = upstream `server.evict` |
| `relay.site` | relay host name | name used upstream; `autoscale.sites` order for `fill` |
| `--no-confirm` | — | parsed but **refused** (`src/hypershell/relay/__init__.py` l.1125) |

**Behaviour that matters for the design.**

- Upstream must be a standalone **`hs server`** with an operator-set key (an `hs cluster` run mints a
  key no one is shown; `docs/security.rst`). The relay holds ≤ ~2 × site clients × bundlesize tasks.
- The site never retries; failures go upstream and the upstream server's `-r` decides.
- Outage ≠ failure: site keeps running, results kept, reconnect with back-off; outage longer than
  upstream eviction ⇒ results refused as stale, tasks re-run elsewhere.
- Drain: `SIGUSR1`/`SIGUSR2` (finish everything held, return results, end). `SIGINT`/`SIGTERM`: end
  at once, kill its launched clients; upstream re-queues on eviction.
- A relay with **no client at its site never asks upstream for work** (it then never hears an
  upstream shutdown). With `-N ≥ 1` against a non-autoscaling upstream this is avoided; against an
  autoscaling upstream a zone's `min` defaults to 0.
- Restarting a relay while the old one runs: newer wins the site; old one hands back unstarted
  tasks and exits (2.9.0a8, #101).
- `hs update` upstream does not reach tasks a relay holds; `hs info --stdout/--stderr` reads captured
  output from the host that ran the task.
- Keep relay hosts' clocks in sync with the upstream server (notes v2.9.0 known issues).

**Upstream `hs server --autoscaling` with relay sites** (`docs/cli/server.rst`
"Autoscaling with relay sites"): the server keeps no launcher; any relay connecting with its key takes
part (no site list needed). Each period it reads each zone's work in the active group, holds each
site's `min` (and `init` at start), grows a zone by demand at most one client per check up to the sum
of live sites' `max`, places new clients by `autoscale.distribution` = `spread` (default, fewest
first) or `fill` (saturate sites in `autoscale.sites` order — "prefer the cheaper site"), and
publishes a topology each relay fetches at heartbeat. Nothing is terminated to reconcile; extra
clients leave by idle timeout (`relay.timeout`). `autoscale.size.*`/`autoscale.launcher` do not
apply. Docs example (container server): `export HYPERSHELL_SERVER_AUTH=...;
export HYPERSHELL_AUTOSCALE_DISTRIBUTION=fill; export HYPERSHELL_AUTOSCALE_SITES=east,west;
hs server --autoscaling=dynamic -H 0.0.0.0`.

**Answers to the design questions (login00 relay feeding a persistent server).**

1. *One relay, several schedulers?* The documented model is **one relay per site** ("Run relay
   for one site", `relay_desc.rst`). Mechanically each zone table may name its own `launcher`, so a
   zone's launcher could be any command, but: the launcher must pass the environment (the site key is
   an env var; plain `ssh` does not forward env), must stay in the foreground for the client's life,
   and the launched client must reach the relay's bind port (50002) from wherever it runs. Launching
   through a second cluster's scheduler from Gautschi's login00 would need cross-cluster compute →
   login00 reachability and env passing; nothing in the docs covers it. **Recommendation:** add a
   second cluster by starting **a second relay on that cluster's login node**, same upstream server
   and key, distinct `relay.site`, serving that cluster's zones (or a shared zone so the server spreads
   or fills across both).
2. *How it reaches the server:* outbound TCP from the relay host to the upstream host:port (default
   50001), TLS on, upstream trust via `relay.upstream.tls.cafile` (e.g. the server's certificate) or
   `fingerprint`, key via `relay.upstream.auth_env`/`auth_eval`.
3. *What the relay host needs:* HyperShell **2.9.0a8+** installed with the **`hyper-shell`
   executable on PATH for launched clients** — site clients are started literally as
   `hyper-shell client …` (`src/hypershell/relay/site.py` `zone_launch` → `DEFAULT_REMOTE_EXE =
   'hyper-shell'`, `src/hypershell/cluster/remote.py` l.54); the docs' LMOD recipe
   (`docs/install.rst` "HPC Module (LMOD)") symlinks only `hs` and `hsx`, so an RCAC module built that
   way would break relay launches — **validate on the module**; `uv tool install` exposes all three.
   Also: the site launcher (`srun`) usable from the login node with account/partition/time in
   `launcher_args` (each `srun` outside an allocation is one Slurm job per client); inbound TCP from
   compute nodes to the relay port; a node-local disk for the relay DB; a synced clock; and a way to
   keep a long-lived process running on the login node (RCAC policy question, not covered by the
   HyperShell docs). Site TLS uses the relay's own `[server.tls]` auto cert under `~/.hypershell/lib/tls`,
   which compute nodes trust via the shared home (`cafile=<auto>`).
4. *Relation to autoscaling:* a relay is itself a small autoscaling cluster at its site (fixed fleet
   of `size`, relaunching exits, or following the upstream topology). `autoscale.failed_launches`
   does not apply to relays: a relay keeps relaunching failing site clients, warning each time
   (`config_param_ref.rst` `failed_launches`).

---

## 7. `hs initdb`, `hs config`, configuration

### `hs initdb` — `docs/cli/initdb.rst`, `docs/_include/initdb_help.rst`

`hs initdb [--truncate | --vacuum | --rotate | --backup PATH] [--yes]`. Creates tables (SQLite does
it automatically), upgrades an older DB in place (2.9.0a2, #69), and under `timescale` checks the
server and shapes the hypertable. `-v/--vacuum`, `-b/--backup PATH` (SQLite), `-r/--rotate` (SQLite):
2.7.0; `-t/--truncate`, `-y/--yes`: unknown. Exists since 2.0.0.

### `hs config` — `docs/_include/config_*_usage.rst`, `config_*_help.rst`

- `hs config get SECTION[...].VAR [-x/--expand] [-r/--raw] [--system|--user|--local|--default]`
- `hs config set SECTION[...].VAR VALUE [--system|--user(default)|--local]` (typed by key [dev] #117)
- `hs config edit [--system|--user|--local]` (uses `EDITOR`)
- `hs config which SECTION[...].VAR [--site]`
- `hs config --user` etc. prints the file path. `--local`, `--default`, `--site`: 2.5.0.

### Files and precedence — `docs/_include/config_intro.rst`, `docs/config.rst`, `src/hypershell/core/platform.py`

Lowest → highest: system `/etc/hypershell.toml` < user `~/.hypershell/config.toml` < local
`./.hypershell/config.toml` (or `$HYPERSHELL_SITE/config.toml`) < `HYPERSHELL_*` env vars <
command-line options. `HYPERSHELL_CONFIG_FILE=path` loads **only** that file (empty = env-only) —
recommended on HPC to isolate many instances (`config_site_vars.rst`). Site dirs on Linux: user
`~/.hypershell/{lib,log}`; system `/var/lib/hypershell`, `/var/log/hypershell` (root only).

### Environment mapping — `config_intro.rst` "Environment Variables"

`HYPERSHELL_` + key path with `.`→`_` (`logging.level` ⇒ `HYPERSHELL_LOGGING_LEVEL`). Keys whose own
name holds `_` (e.g. `HYPERSHELL_RELAY_LAUNCHER_ARGS`, `HYPERSHELL_AUTOSCALE_FAILED_LAUNCHES`),
relay zone tables (`HYPERSHELL_RELAY_ZONE_<ZONE>_<KEY>`), typed values: **[dev] (#113)**; the
`ROADMAP` evidence of 2026-11-14 records underscore keys "still unreachable" before it — so on a8 put
such keys in a file. `HYPERSHELL_EXPORT_<NAME>` ⇒ task variable `<NAME>`. Not config keys:
`HYPERSHELL_SITE`, `HYPERSHELL_CONFIG_FILE`, `HYPERSHELL_PYTHONPATH` (2.6.5), `HYPERSHELL_ZONE`.

### `_env` / `_eval` indirection

Any key ending `_env` (read named env var) or `_eval` (run shell command, take stdout) in a file, or
`HYPERSHELL_<KEY>_ENV` / `_EVAL` in the env: e.g. `[database] password_eval = "pass …"`,
`[server] auth_eval = "cat /etc/hypershell/auth.key"`, `HYPERSHELL_SERVER_AUTH_ENV=MY_KEY`
(`config_intro.rst`; `docs/security.rst`). In config files since 2.0.0 (docs at tag). For the key
specifically, works since 2.8.7/2.9.0a7. Env-var `_ENV`/`_EVAL` forms [dev].

### Sections and keys the guide would use — `docs/_include/config_param_ref.rst`

- `[logging]` `level` (INFO default since 2.8.0), `style`, `color`, `[logging.file]` `path`,
  `level` (TRACE), `style`, `rotate`, `compress`, `keep` (file logging 2.8.0; per-process
  `server-<host>.log`, `client-<host>.log`).
- `[database]` `url`, `provider` (`sqlite`|`postgres`|`timescale`/`timescaledb`), `file`, `database`,
  `schema`, `host`, `port`, `user`, `password` (+`_env`/`_eval`), `echo`, `[connect_args]`,
  `[pragmas]` (SQLite, 2.7.0), `[timescale]` (2.9.0a3).
- `[server]` `bind`, `host` (where clients/`submit -q` dial), `advertise` [dev], `port`, `auth`,
  `queuesize`, `bundlesize`, `bundlemax` (2.9.0a4), `attempts`, `eager`, `poll`, `evict`, `[tls]`.
- `[client]` `bundlesize` [dev-honoured], `bundlewait`, `heartrate`, `timeout`, `cores`, `memory`,
  `ratelimit`.
- `[submit]` `bundlesize`, `bundlewait`.
- `[task]` `cwd`, `cores`, `memory`, `timeout`, `signalwait`.
- `[ssh]` `config`, `args`, `[nodelist]`.
- `[autoscale]` `policy`, `factor`, `period`, `launcher`, `distribution` (2.9.0a8), `sites`
  (2.9.0a8), `failed_launches` [dev], `[size]` `init`/`min`/`max`.
- `[relay]` (§6), `[relay.upstream]`, `[relay.upstream.tls]`, `[relay.zone.NAME]`.
- `[console]` `theme`; `[export]` (task env vars; lists joined with `:`).

---

## 8. Database — `docs/database.rst`, `docs/_include/database.rst`

- **SQLite** default provider (default file since 2.8.0). Auto-initialized. Pragmas re-applied per
  connection, e.g. `pragmas = {journal_mode = "wal", cache_size = 10000, busy_timeout = 5000}`.
  `hs initdb --rotate` partitions (2.7.0; `part` column 2.9.0a2).
- **PostgreSQL**: `provider = "postgres"`, extra `postgres` (binary psycopg v3) | `postgres-system` |
  `postgres-c` (psycopg v3 since 2.8.0). Must be initialized: `hs initdb`, or `--initdb` on
  `hs submit`/`hs cluster` (and `hs server` [dev]). Without it, a never-initialized DB stops the server.
  PostgreSQL support itself: 2.0.0 (`provider` in 2.0.0 config).
- **TimescaleDB** (2.9.0a3, #71): `provider = "timescale"`; needs extras **`postgres` and `uuid7`
  on every process that submits tasks** (UUIDv4 inserts fail and abort the bundle; HyperShell refuses
  to start without the extra). Server must offer the extension, preload it
  (`shared_preload_libraries`), version **≥2.22.0**; policy needs ≥2.25.0; Community license for
  columnstore (Apache/-oss edition: hypertable only). `hs initdb` makes `task` a hypertable by `id`
  (UUIDv7) in 1-week chunks, columnstore segmented by `client_id`, ordered `id DESC`, policy at 4 weeks;
  idempotent. Tune in `[database.timescale]` `chunk_interval`, `columnstore`, `segmentby`, `orderby`,
  `policy`, `compress_after`. Converts `task` only while empty. Official `timescale/timescaledb`
  images are Community edition. TimescaleDB 2.29+ lock-race caveat (server re-runs detected writes; a
  few rare writes still exposed — notes v2.9.0 known issues).
- **Open defect relevant to the capstone:** on PostgreSQL (so TimescaleDB too) the `memory` column is
  32-bit, so **a task requesting ≥2 GB memory (`-m 4G`) is refused at insert and then hangs**
  (`ROADMAP.md` "On PostgreSQL, a task cannot ask for 2 GB of memory or more", target 2.9.0,
  unshaped). Do not show `-m`/`memory:` ≥2G against a PostgreSQL/Timescale DB.
- Upgrades: in place, forward-only (2.9.0a2); PostgreSQL holds table locks up to 15 min.
- **Two servers on one database are not supported** (notes v2.9.0 "In-place database upgrade").

## 9. Task environment and GPU multiplexing (R11) — `docs/_include/config_task_env.rst`, `templates.rst`

Every task gets: `TASK_ID`, `TASK_ARGS`, `TASK_SUBMIT_ID`, `TASK_SUBMIT_HOST`, `TASK_SUBMIT_TIME`,
`TASK_SERVER_ID`, `TASK_SERVER_HOST`, `TASK_SCHEDULE_TIME`, `TASK_CLIENT_ID`, `TASK_CLIENT_HOST`,
`TASK_COMMAND`, `TASK_ATTEMPT`, `TASK_PREVIOUS_ID`, `TASK_CWD`, `TASK_START_TIME`, `TASK_WAITED`,
`TASK_OUTPATH`, `TASK_ERRPATH`, `TASK_SLOT` (0..N−1), `TASK_SLOT_COUNT` (N) (slots 2.9.0a1, #52);
tags as `TASK_TAG_<KEY>`; `[export]`/`HYPERSHELL_EXPORT_*`. `TASK_ID` exists at 2.0.0
(`src/hypershell/client.py` at tag); others' first versions unknown. The key is stripped from the task
env (2.8.5/2.9.0a5).

GPU: HyperShell does **no** GPU detection or `CUDA_VISIBLE_DEVICES` management (no GPU code in
`src/`; only a comment in `src/hypershell/client.py` l.582). The documented pattern is the slot:
`hsx tasks.in -N4 -t 'CUDA_VISIBLE_DEVICES={slot} python train.py {}'` (`docs/getting_started.rst`;
notes v2.9.0 "Per-executor task slots"). Multiplexing several tasks per GPU is not documented
(derive, e.g., `{= =}` or `TASK_SLOT` modulo GPUs; must be validated). Slots need 2.9.0a1+; for
≤2.8 there is no per-executor index. Resource-aware `-c/-m` and `-C/-M` (2.8.0) partition CPU/memory,
not GPUs. Zones (2.9.0a4) route GPU tasks to GPU clients (`--zone gpu`; relay
`launcher_args = "--gres=gpu:1"` example in `config_param_ref.rst` `relay.zone`).

## 10. Logging, monitoring, scale guidance

- Console default INFO (2.8.0): "INFO level messages are reserved for clients when tasks begin
  running" (`config_param_ref.rst` `logging.level`) ⇒ one line per task at INFO; at large scale set
  `HYPERSHELL_LOGGING_LEVEL=warning` (inference from that sentence; not a stated recommendation).
- File logging opt-in (`logging.file`), per-role per-host files, default file level TRACE, rotation by
  size/cron, compression (2.8.0; `docs/logging.rst`).
- Docs claims: "Scale to 1000+ nodes, 250k+ workers without crashing the server" (`docs/index.rst`).
  One server "tops out near 1,000 connected clients" (maintainer observation, unmeasured;
  `issues/cluster-relay-fanout.md`), so at scale run **one client per node with many executors**
  (`-N`), not one client per core.
- Large-run practices documented in the CLI help: larger `-b` matched to executors per client and
  longer `-w`; `--delay-start=-<task length>` to stagger thousands of clients; `--no-confirm` (with
  `--no-db`) for max throughput; `-Q` raises/lowers DB polling; `server.queuesize`, `server.bundlemax`
  for many clients; for very large workflows a one-time `hs submit` then bare `hsx --restart` is
  cheaper than re-feeding the FILE each requeue (`cluster_desc.rst`); SQLite WAL/busy_timeout
  pragmas; TimescaleDB for long-lived DBs; `hs initdb --rotate` for long SQLite history.
- Throughput datapoint: 2.9.0a4 client-requested bundles 1.43× 2.8.3 (201 vs 141 tasks/s, 4 nodes,
  3×16 executors, SQLite, TLS) (notes v2.9.0).
- Open-file reserve: server refuses a connection that would use its last 32 fds (2.9.0a4).

## 11. Containers and install

- Install: `uv tool install hypershell` (recommended), `pip`, Homebrew tap, extras
  `postgres`, `postgres-system`, `postgres-c`, `uuid7`, `zstd`, `cron` (`docs/install.rst`).
  `pipx` is not mentioned in the docs. Python **3.11–3.14** (since 2.8.0; 3.15 unsupported).
  Pre-release: `pip install --pre hypershell` / `uv tool install --prerelease=allow hypershell`
  (the uv form is not in HyperShell docs; validate).
- Image: **`ghcr.io/hypershell/hypershell`**, multi-arch amd64/arm64, cosign-signed, SLSA provenance,
  for tagged releases from 2.9 (2.9.0a1; `docs/install.rst` "Docker and Apptainer";
  `.github/workflows/docker.yml`, tags `type=pep440` + `sha`). Base `python:3.14-slim` + `libpq5`;
  `uv sync --frozen` installs the dev dependency group, which includes `psycopg` and `uuid-utils`, so
  the image can use `postgres` and `timescale`. Runs as uid/gid 1001 `hypershell` (no home created);
  `ENTRYPOINT ["/opt/hypershell/bin/hs", "server"]`, `CMD ["--forever"]`; env
  `HYPERSHELL_LOGGING_LEVEL=TRACE`, `HYPERSHELL_LOGGING_STYLE=SYSTEM` (`Dockerfile`).
- GHCR on 2026-11-22 lists tag **`2.9.0a8`** and `sha-2ffb5cc` among recent tags; **no `latest` tag
  is listed**, though `docs/install.rst` says `docker pull ghcr.io/hypershell/hypershell:latest`.
  Pin a version tag. The Kubernetes example in `docs/security.rst` uses `hypershell/hypershell:latest`
  (a Docker Hub-style name that is not the published registry) — do not copy it.
- Container caveats to validate for the Geddes pod: uid 1001 has no home, so the default user site
  (`~/.hypershell/lib`, TLS auto-cert, default DB) may be unwritable; set `HYPERSHELL_SITE` to a
  writable persistent volume path (it is created with `makedirs`) or supply cert/key via secret;
  `/var/lib/hypershell` is created by root in the image and is used only when running as root.
- `Apptainer` def file at repo root (not a directory): same base, `%runscript exec /bin/hs "$@"`;
  not published.

---

## 12. Features by minimum version

| Feature | Min version | Source |
|---|---|---|
| `hs cluster/server/client/submit/config/initdb`; `--restart` (bare), `--launcher`, `--mpi`, `--ssh`, `--remote-exe`, `-b`, `-w`, `-d`, `-r`, `--eager`, `-f/--failures`, `--forever`, `--no-db`, `--initdb`, `--capture`, `-t`; PostgreSQL; `_env`/`_eval`; `TASK_ID` | 2.0.0 | src/docs at tag 2.0.0 |
| `--no-confirm`; task recovery on eviction; `hs task update`; `--failed/--succeeded/--remaining` | 2.2.0 | notes v2.2.0; src at tag |
| Tags; `-W` task timeout; `-T` client timeout; `--autoscaling` fixed/dynamic | 2.4.0 | notes v2.4.0 |
| `hs` name; bulk `hs update --cancel/--revert/--delete`; `--completed`; SIGUSR1/SIGUSR2; `-S`; `hs config --local/--default/--site`; tags in task env | 2.5.0 | notes v2.5.0 |
| Inline `#HYPERSHELL` tags | 2.6.0 | notes v2.6.0 |
| `HYPERSHELL_PYTHONPATH` | 2.6.5 | notes v2.6.5 |
| Top-level `hs list/info/wait/run/update`, unified `hs submit`, `hsx`; SQLite rotation/vacuum/backup; UUIDv7 extra; pragmas | 2.7.0 | notes v2.7.0 |
| TLS default; `-c/-m/-C/-M`; `--monitor`; `submit -q`; `-R`; **task groups**; file logging; default SQLite DB; INFO default; key policy; `-H/--bind` on cluster; Python ≥3.11; psycopg v3 | 2.8.0 | notes v2.8.0 |
| Groups load in order from a named FILE; idle-clock fix | 2.8.4 | notes v2.8.x |
| Key off command lines for launched clients | 2.8.5 | notes v2.8.x |
| Units on memory and `-W`/`-T`; key `auth_env`/`auth_eval` | 2.8.7 | notes v2.8.x |
| `--from-json`; FILE-aware `--restart`, `--repeat`, `--update`; task slots (`{slot}`, `TASK_SLOT`); `--signal`, `-X`; `--all`; container images; new never-ran codes | 2.9.0a1 | notes v2.9.0 |
| In-place DB upgrade; `card` format; `part` column | 2.9.0a2 | notes v2.9.0 |
| TimescaleDB provider; stale results refused | 2.9.0a3 | notes v2.9.0 |
| **Zones**; client-requested bundles; `server.bundlemax`; in-process queue | 2.9.0a4 | notes v2.9.0 |
| **`hs relay`** | 2.9.0a6 | notes v2.9.0; `docs/cli/relay.rst` |
| Per-zone autoscaling (`{zone}`, `HYPERSHELL_ZONE`); `hs server --autoscaling` with relay sites; relay `min/max/init`; `autoscale.distribution`/`sites`; superseded relay retires | 2.9.0a8 | git log 2.9.0a7..2.9.0a8 (#99, #100, #101) |
| `-k` refused; `hs server --initdb` works; units on `-w/-S/-Q/-P/-d`; cluster stops on failed launches; `--advertise` (cluster, relay); `autoscale.failed_launches`; env vars for every key (underscores, zone tables, `_ENV/_EVAL`); `client.bundlesize` honoured; `#` stays in command; integer groups; reached-group refusal; idle clients return at once; `server.attempts`/`eager` read by `hsx`; TLS handshake deadline; relay TLS-mismatch exits | [dev] (unreleased 2.9.0) | `git log 2.9.0a8..develop` (#103–#119) |

## 13. What the guide must NOT claim

- That 2.9.0 is released, or that `pip install hypershell` gives 2.9 (it gives 2.8.7).
- That a `--restart` rerun re-runs failed tasks (it skips all completed tasks; see §2.2).
- `-N` = number of tasks (it is executors per client).
- Graceful handling of SIGTERM / Slurm walltime kill; that `-W` bounds a pipeline's children
  (open: `issues/process-group-signal-teardown.md`).
- That SIGUSR1 ends an autoscaling `hs cluster` (open, 2.9.x).
- That a relay increases throughput, or that `hs update`/`hs info --stdout` reach across a relay.
- That one relay is the intended way to drive several clusters' schedulers (documented model: one
  relay per site).
- That HyperShell manages GPUs or sets `CUDA_VISIBLE_DEVICES` itself.
- That `hs cluster` can bring up relays itself (`issues/cluster-relay-fanout.md`, unscheduled).
- Mutual TLS or client certificates (none).
- That `hs wait` waits on a group or a whole run (one task ID only).
- A `--zone` filter on `hs list` (none).
- Task memory ≥2 GB on PostgreSQL/TimescaleDB (open defect, target 2.9.0).
- Two servers sharing one database (unsupported).
- `ghcr.io/hypershell/hypershell:latest` or a Docker Hub image (only versioned GHCR tags verified).
- On a8: that `hs server --initdb` initializes, that `-k` is refused, that durations with units work
  on `-w/-d/-S/-Q/-P`, or that `[client] bundlesize` takes effect.
- Coordinator resilience (servers/clients surviving a DB lock or server restart): targeted 2.10.0
  (`ROADMAP.md` "Transient coordinator failures should degrade to retry").

## 14. Validation envelope items raised here (for R15)

1. Release state at publish time: re-check PyPI/tags; decide whether pages wait for 2.9.0 final or
   avoid every [dev] item.
2. RCAC module (once ≥2.9) exposes `hyper-shell` on PATH (relay site clients need it).
3. SQLite main DB on cluster scratch (Lustre) under `hsx`: correctness and locking.
4. Clean pre-walltime stop: `#SBATCH --signal` form that reaches `hsx` with `SIGUSR1`.
5. `hs update --failed --revert` scoped to unretried failures (`-w` on `retried`).
6. Relay on login00: `srun` from a login node as relay launcher (one job per client),
   compute-node → login00:50002 reachability, node-local relay DB path, long-running process policy.
7. Upstream server in a Geddes pod: inbound 50001 from login00 (and any second cluster's login node);
   PostgreSQL port reachable from login nodes for `hs submit`/`hs list`; writable `HYPERSHELL_SITE`
   for uid 1001; TLS trust (fingerprint or CA) from relays and submitters.
8. GPU multiplexing template (several tasks per GPU) on a GPU cluster.
