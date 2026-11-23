# Research digest — workflow-automation

Synthesized 2026-11-22 from six research briefs. Each brief is sourced in detail (file:line, doc
section, or URL); this digest records only the conclusions PLAN relies on.

| Brief | Topic |
|---|---|
| [01-site-integration.md](01-site-integration.md) | Nav placement, hub archetype, front-matter, cross-link spots, tabs + snippets pattern, Jinja hazards, build baseline |
| [02-hypershell-reference.md](02-hypershell-reference.md) | HyperShell 2.9.0 options, config keys, env vars, relay, database, minimum versions, what not to claim |
| [03-landscape.md](03-landscape.md) | Tool dimensions, per-tool briefs, RCAC availability, job-array limits, Pegasus in depth |
| [04-tiers-and-gpu.md](04-tiers-and-gpu.md) | Tier structure from the HyperShell website draft, one scenario per tier, GPU multiplexing |
| [05-geddes-capstone.md](05-geddes-capstone.md) | Geddes Rancher style, images, pod design, network exposure, relay and the second cluster |
| [06-cluster-headers-and-validation.md](06-cluster-headers-and-validation.md) | Per-cluster `#SBATCH` headers, module lines, login nodes, 2.9.0 build route, validation inputs |

## Settled facts

**Site.** `mkdocs build --strict` passes today with an empty baseline (01). Broken `#anchor` links
log only at INFO and escape `--strict`; add a log grep for new paths (01 §build). The section goes
under RCAC Resources between Profilers and RCAC Workshops, shaped like the Agentic AI section (a hub,
flat pages, a subsection with its own `index.md`) (01). `content.tabs.link` is on, so tabs labeled
identically switch together site-wide; the labels `Anvil`, `Gautschi`, `Gilbreth`, `Negishi`,
`Scholar` match existing tabs in `docs/faqs.md` (01). A content tab cannot sit inside a code block
and no macro emits per-cluster Slurm headers; a pattern of one complete script per tab, assembled
from two `--8<--` includes (a per-cluster header file and one shared body file), was built in a
scratch copy and passed `--strict`, and keeps script bodies outside the Jinja pass (01). Bash
`${#arr[@]}`, GNU Parallel `{#}`, HyperShell's `{% … %}` shell-expansion template, and Snakemake
`{{ }}` all break the macros pass if pasted into a page; HyperShell's `{}` templates are safe (01, 02).
Mermaid is not configured; diagrams are tables or images with alt text (01).

**Bell.** Decommissioned; its docs were removed on 2026-11-04 (commit 258ebfe6, PR #323). No user
guide, nav entry or catalog row. The guide's tabs are five: Anvil, Gautschi, Gilbreth, Negishi,
Scholar (01, 03, 06).

**HyperShell release status.** 2.9.0 is not released. PyPI: stable 2.8.7 (2026-11-12),
pre-release 2.9.0a8 (2026-11-14); Python ≥ 3.11. The `develop` branch carries fixes merged after a8
that its docs describe as 2.9.0, among them `hs server --initdb` (broken in a8), environment
variables for config keys containing an underscore (e.g. `auth_eval`), refusal of `-k`, duration
units, and refusal of submissions below the reached group. 2.8 and 2.9 are wire-incompatible (02).
RCAC modules: Anvil, Gautschi, Negishi, Scholar default 2.7.0; Gilbreth 2.5.2 only; Gautschi also
has `develop` (catalog + login-node check, 06).

**`--restart` semantics (R7).** `hsx FILE --restart` (file-aware, 2.9.0) submits only tasks that
never landed and re-runs interrupted ones; every completed task is skipped, failed ones included.
Failed tasks re-run only with `-r/--max-retries` during a run, or after `hs update --failed
--revert` before the rerun. Before 2.9.0, `FILE` and `--restart` were mutually exclusive, so the
tier 1 script fails on a 2.7.0 module (02 §2.2).

**Database location.** Since 2.8.0 a SQLite database is on by default at `~/.hypershell/lib/main.db`;
a job sets `HYPERSHELL_SITE` (or `HYPERSHELL_DATABASE_FILE`) to keep one database per campaign at a
path that survives between jobs. SQLite locking is unreliable on many network filesystems; the
docs say so for the relay database and are silent for the main one, so the chosen path must be
validated (02 §2.2, §8).

**Zones and groups.** Zone = where a task may run (a name matched by clients; 2.9.0a4). Group = when
it may run (an integer; each group finishes before the next starts; 2.8.0). `hs submit`, `hs list`,
`hs info`, `hs wait` and `hs update` talk to the database, not the queue (02 §4).

**Relay.** `hs relay` (2.9.0a6; topology and server-side autoscaling across relays 2.9.0a8) runs
once per site: upstream an ordinary client of a standalone `hs server` with an operator-set key; at
its site a private SQLite server that launches clients through a launcher (`srun`, never `sbatch`:
the relay counts live child processes). An upstream `hs server --autoscaling` plans clients across
connected relays (`spread` or `fill`). Site clients start as `hyper-shell client`, so the module
must expose that executable. The upstream key is `relay.upstream.auth` (`auth_eval`/`auth_env`),
never a command-line flag (02 §6, 05 §4).

**GPU.** HyperShell has no GPU accounting. 2.9.0 provides `{slot}`/`TASK_SLOT` (and `_COUNT`); the
documented pattern is choosing a device by slot. `{slot}` is unavailable when the template expands
at submit time, so `hs submit` workflows use `TASK_SLOT` (02 §9, 04 §4). The site states MIG only
for Scholar's A30 slices and never mentions MPS. Negishi's GPUs are AMD MI210 (04, 06).

**Pegasus.** No cluster-side Pegasus WMS (Anvil login-node check; Gautschi's `cadence/pegasus` is
Cadence's EDA tool). Two hosted routes reach Anvil: Pegasus in the Anvil Notebook Service (RCAC news
item 7628, 2026-03-10; stub section in `docs/userguides/anvil/notebook.md`), and ACCESS Pegasus
(`pegasus.access-ci.org`, run by ISI) through HTCondor Annex with an Anvil allocation. Purdue-only
community-cluster users have no verified route. `docs/hubzero/tools/developers/grid/pegasuswf.md`
covers a HUBzero tool-developer `submit` path and does not apply to cluster users (03 §5).

**Availability (catalog-derived unless noted).** Nextflow: Anvil (21.10.0 live, 22.10.1),
Gautschi (live: 24.04.3, 25.10.04, 26.04.2), Negishi; not Gilbreth or Scholar. GNU Parallel: all but
Scholar (Anvil `parallel/20200822` live). Snakemake: Anvil `snakemake/6.8.0` (live; no catalog
page; predates Snakemake 8 executor plugins), elsewhere via Biocontainers (needs live check).
Parsl, Dask, Ray: no modules; the user's own `conda` or `uv` environment. Slurm `MaxArraySize` and
per-user submit limits are not stated on the site; pages show how to check (03, 06).

**Headers.** Every tab sets `-A`, `-p`, `--time`, and `-q` where a QOS exists (not Anvil);
placeholder `myallocation`, Scholar `-A scholar`. Cores per CPU node: Gautschi 192, Anvil 128,
Negishi 128, Scholar mixed 128/64. Gilbreth is GPU-only. Older example pages carry errors not to copy
(`-A standby`; `--partition=a10` on Gautschi) (06).

**Geddes.** Mirror `docs/userguides/geddes/examples/database.md`: Rancher click paths, Opaque
Secrets, a PVC, a LoadBalancer Service with the `geddes-private-pool` annotation and a DNS name
`<service>.<namespace>.geddes.rcac.purdue.edu`. Ingress is HTTP only, so the raw-TCP queue needs the
LoadBalancer. The HyperShell image is `ghcr.io/hypershell/hypershell` (entrypoint `hs server`, default
`--forever`, uid 1001 without a writable home, `hs` not on `PATH`); tags today are only `2.9.0a8`
and a `sha-` tag, no `latest`. No GHCR cache is documented on Geddes. TimescaleDB:
`timescale/timescaledb:2.32.1-pg17` through the Docker Hub cache keeps the database guide's storage
steps word for word. The site also documents a Geddes2 migration whose registry and ingress differ
(05).

**Login-node policy.** RCAC's front-end policy limits login nodes to job preparation and submission
and terminates processes using significant CPU or memory; it says nothing about long-running,
low-CPU processes. `login00` is not described as special anywhere on the site (05 §5, 06).

## Open, carried to PLAN §5

The 2.9.0 release and the module update (publish timing); R7's wording against `--restart`
semantics; the second relay's host versus R10's "runs on login00"; persistent HyperShell processes on
login nodes (tier 3 server, tier 4 relay); Geddes versus Geddes2 as the capstone target; the image
source on Geddes (GHCR direct versus a Harbor copy); network reachability (compute node → login node
port; login00 → Geddes LoadBalancer); MIG/MPS availability; the `hyper-shell` executable in the
module.
