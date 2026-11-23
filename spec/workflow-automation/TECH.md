---
slug: workflow-automation
title: "Workflow Automation: choosing a tool, and a tiered HyperShell user guide"
kind: feature
appetite: big
status: in_progress
branch: feature/workflow-automation
base: main
current_phase: P1
last_updated: "2026-11-22"
phases:
  - id: P1
    name: "Scaffold: section nav anchor and the landing page"
    status: pending
    satisfies: [R1, R2, R5, R13, R14]
    depends_on: []
    parallel: false
    hammerable: false
    hill: uphill
    verify: ".venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py && grep -q 'workflows/index.md' mkdocs.yml"
  - id: P2
    name: "Baseline tools: job arrays, GNU Make, GNU Parallel"
    status: pending
    satisfies: [R1, R3, R13, R14, R15]
    depends_on: [P1]
    parallel: false
    hammerable: false
    hill: uphill
    verify: ".venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py && grep -q 'workflows/job_arrays.md' mkdocs.yml && grep -q 'workflows/gnu_make.md' mkdocs.yml && grep -q 'workflows/gnu_parallel.md' mkdocs.yml && grep -rqF 'same on every cluster' site/workflows/job_arrays/ && grep -rqF 'FILENAME: array.sub' site/workflows/job_arrays/ && grep -q '^P2: PASS' spec/workflow-automation/VALIDATION.md"
  - id: P3
    name: "Workflow managers: Snakemake, Nextflow, Pegasus, Parsl"
    status: pending
    satisfies: [R1, R4, R13, R14, R15]
    depends_on: [P2]
    parallel: false
    hammerable: false
    hill: uphill
    verify: ".venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py && grep -q 'workflows/snakemake.md' mkdocs.yml && grep -q 'workflows/nextflow.md' mkdocs.yml && grep -q 'workflows/pegasus.md' mkdocs.yml && grep -q 'workflows/parsl.md' mkdocs.yml && grep -q '^P3: PASS' spec/workflow-automation/VALIDATION.md"
  - id: P4
    name: "HyperShell guide landing page and Tier 1 (one job script)"
    status: pending
    satisfies: [R1, R6, R7, R12, R13, R14, R15]
    depends_on: [P3]
    parallel: false
    hammerable: false
    hill: uphill
    verify: ".venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py && grep -q 'workflows/hypershell/index.md' mkdocs.yml && grep -q 'workflows/hypershell/single_job.md' mkdocs.yml && grep -rqF 'same on every cluster' site/workflows/hypershell/single_job/ && grep -rqF 'FILENAME: frames.sub' site/workflows/hypershell/single_job/ && grep -q '^P4: PASS' spec/workflow-automation/VALIDATION.md"
  - id: P5
    name: "GPU multiplexing and Tier 2 (extreme scale)"
    status: pending
    satisfies: [R6, R8, R11, R12, R13, R14, R15]
    depends_on: [P4]
    parallel: false
    hammerable: false
    hill: uphill
    verify: ".venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py && grep -q 'workflows/hypershell/gpu_multiplexing.md' mkdocs.yml && grep -q 'workflows/hypershell/extreme_scale.md' mkdocs.yml && grep -rqF 'FILENAME: gpu_sweep.sub' site/workflows/hypershell/gpu_multiplexing/ && grep -rqF 'FILENAME: ensemble.sub' site/workflows/hypershell/extreme_scale/ && grep -q '^P5: PASS' spec/workflow-automation/VALIDATION.md"
  - id: P6
    name: "Tier 3: a pipeline on one cluster (database, config, phases, zones, groups)"
    status: pending
    satisfies: [R6, R9, R12, R13, R14, R15]
    depends_on: [P5]
    parallel: false
    hammerable: false
    hill: uphill
    verify: ".venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py && grep -q 'workflows/hypershell/pipelines.md' mkdocs.yml && grep -rqF 'FILENAME: schedule-clients.sh' site/workflows/hypershell/pipelines/ && grep -q '^P6: PASS' spec/workflow-automation/VALIDATION.md"
  - id: P7
    name: "Tier 4: persistent service on Geddes and relay autoscaling across clusters"
    status: pending
    satisfies: [R6, R10, R11, R12, R13, R14, R15]
    depends_on: [P6]
    parallel: false
    hammerable: false
    hill: uphill
    verify: ".venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py && grep -q 'workflows/hypershell/geddes_service.md' mkdocs.yml && grep -q 'workflows/hypershell/autoscaling.md' mkdocs.yml && grep -rqF 'FILENAME: run-relay.sh' site/workflows/hypershell/autoscaling/ && grep -q '^P7: PASS' spec/workflow-automation/VALIDATION.md"
  - id: P8
    name: "Integration: hub completeness, cross-links, conventions and accessibility sweep"
    status: pending
    satisfies: [R1, R12, R13, R14, R15]
    depends_on: [P7]
    parallel: false
    hammerable: false
    hill: uphill
    verify: ".venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py && grep -q 'workflows/' docs/lifesciences/guides/nextflow.md && grep -q 'workflows/' docs/lifesciences/guides/nextflow-gautschi.md && grep -q 'workflows/hypershell/' docs/workshops/hpc_exchange/week4/workload-management.md && ! grep -rqE 'hs task|hsx? [^|]*-k( |$)' docs/workflows docs/snippets/workflows && test $(grep -c '^P[2-7]: PASS' spec/workflow-automation/VALIDATION.md) -eq 6"
review:
  last_reviewed_commit: ""
  verdict: none
  blocked_reason: ""
---

# TECH.md — Workflow Automation: choosing a tool, and a tiered HyperShell user guide

The **context engine and finite-state machine** for authoring this job. The YAML frontmatter
above is the resume ground-truth (read it with
`.venv/bin/python .agents/factory/bin/next_phase.py spec/workflow-automation/TECH.md`); the
per-phase checklists below are the work. `docs-draft` executes the next actionable phase, runs its
`verify:` command, updates state via `.venv/bin/python .agents/factory/bin/set_phase.py …`, and
makes one atomic content+state commit. Run from the repo root.

- **Vision / requirements (locked):** [`GOAL.md`](GOAL.md) — R-IDs are the contract.
- **Authoritative design:** [`PLAN.md`](PLAN.md) — page list, nav block, snippet layout, header
  conventions, risks, validation envelope (§6).
- **Backing research:** [`research/00-digest.md`](research/00-digest.md) + briefs 01–06.
- **Validation log:** [`VALIDATION.md`](VALIDATION.md) — filled by the cycle's validator, read by
  `verify:`.

## Frontmatter field reference

- `base`: **`main`** (trunk and production).
- `status` (top): `planned | in_progress | blocked | in_review | done`
- phase `status`: `pending | in_progress | done | blocked`
- `satisfies`: GOAL R-IDs this phase delivers. `depends_on`: phases that must be `done` first.
- `parallel`: `false` everywhere. Every phase edits `mkdocs.yml` nav and the section hub.
- `hammerable`: `false` everywhere. Every phase carries HPC-accuracy or build-integrity content.
- `hill`: `uphill` → `crest` → `downhill`.
- `verify`: build gate + nav check + include sentinels + (for phases with scripts) the
  validation record.

## Conventions (apply to every phase)

- Voice, archetypes and load-bearing rules: [`../../AGENTS.md`](../../AGENTS.md),
  [`../../.agents/factory/style-guide.md`](../../.agents/factory/style-guide.md),
  [`../../.agents/factory/invariants.md`](../../.agents/factory/invariants.md).
- Front-matter, tab labels, snippet layout and header conventions: PLAN §2. Headers mirror each
  cluster's `queues` page per research 06 §2; never copy `-A standby` or Gautschi `--partition=a10`
  from older example pages.
- **HyperShell conventions (R12):** top-level commands only (`hs submit`, `hs list`, `hs info`,
  `hs wait`, `hs run`, `hs update`, `hs server`, `hs client`, `hs cluster`/`hsx`, `hs relay`,
  `hs config`, `hs initdb`), never `hs task …`. Never put the queue key on a command line: use
  `HYPERSHELL_SERVER_AUTH` or `server.auth` (the relay's upstream key: `relay.upstream.auth_eval`).
  Ground every option in research 02 and use only what it marks as present in 2.9.0. Honour its
  "must not claim" list (§13): no graceful-walltime claim, no `-m ≥ 2G` on PostgreSQL, no `:latest`
  image.
- **Jinja safety:** scripts live in `docs/snippets/workflows/` and are included inside fenced blocks.
  Before committing, `grep -nE '\{\{|\{%|\{#' docs/workflows/*.md docs/workflows/hypershell/*.md`
  must show only intentional `{% raw %}` wrappers.
- **Anchors:** after the build, grep its INFO output for anchor messages naming `workflows/`
  (anchors are not `--strict`-checked); fix any.
- **Adding a page updates `mkdocs.yml` `nav:` in the same commit** (block in PLAN §2, own lines
  only), then `.venv/bin/python tools/generate_breadcrumbs.py`. Add the page's card to the
  relevant hub in the same phase.
- One atomic commit per `docs-draft` run: `[feature] Draft workflow-automation P<n>: …`, no
  `Co-Authored-By` trailer.

### Validating phases: draft run, then validation, then close

P2–P7 each carry a `verify:` ending in `grep -q '^P<n>: PASS' spec/workflow-automation/VALIDATION.md`.
They close in two runs:

1. **Draft run (`docs-draft`).** Author the phase. Run the verify command *without* its last
   clause (the build, nav and sentinel checks) until it passes. Mark the phase
   `--phase-status in_progress --hill crest`, add a `P<n>: PENDING` line with the files to run to
   `VALIDATION.md`, commit (`[feature] Draft workflow-automation P<n>: … (awaiting validation)`),
   and stop. The full `verify:` fails by design until validation passes.
2. **Validation (the cycle's validator, on clusters; never a step agent).** Execute the phase's
   rows of the PLAN §6 envelope against the committed snippet files. Record results under the
   phase's heading in `VALIDATION.md` and change the line to `P<n>: PASS — <date>, <clusters>,
   HyperShell <version or commit>` (or `FAIL` with what broke).
3. **Close run (`docs-draft`).** Apply any fixes validation required (a changed script returns to
   step 2), run the full `verify:`, mark the phase `done`, and commit.

P1 and P8 carry no scripts and close in one run.

---

## Phase P1 — Scaffold: section nav anchor and the landing page
**Satisfies:** R1, R2, R5, R13, R14 · **Depends on:** —
**Goal:** the `Workflow Automation` section exists in nav with a complete landing page that
carries the landscape argument; later phases add cards for their pages.

- [ ] Create `docs/workflows/index.md` (hub archetype; front-matter per PLAN §2; mirror the
  Agentic AI hub and `docs/lifesciences/index.md`).
- [ ] Write: the job-per-task anti-pattern; the four dimensions; the placement table (header row;
  all 11 tools; research 03 §2.10); the case for intentional simplicity in flat work; the HyperShell
  recommendation alongside each tool's honest "where it wins" line (research 03, Recommendations);
  a short "Which tool?" list; *Other tools you may meet* (HTCondor, Dask, Ray paragraphs); a
  closing link to `../software/workflow_catalog.md`. Availability wording per research 03: no
  version pins on this page.
- [ ] Grid cards: only for pages that exist (none yet besides the hub). Card stubs for later pages
  are added by their phases. Tool names in the placement table stay plain text until their pages exist.
- [ ] Insert the `- Workflow Automation:` block with only `workflows/index.md` under RCAC Resources
  after Profilers (PLAN §2); regenerate breadcrumbs.
- [ ] `.venv/bin/mkdocs serve` and eyeball the table and prose.
- **Verify:** `.venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py && grep -q 'workflows/index.md' mkdocs.yml`
- **Touches:** `docs/workflows/index.md`, `mkdocs.yml`, `docs/assets/data/breadcrumbs.json` (generated).

## Phase P2 — Baseline tools: job arrays, GNU Make, GNU Parallel
**Satisfies:** R1, R3, R13, R14, R15 · **Depends on:** P1 · **Validation:** V2 (draft run → validation → close run)
**Goal:** three tool pages, each stating what the tool is, the work it fits, where it wins over
HyperShell, and where it stops serving and HyperShell takes over.

- [ ] `docs/workflows/job_arrays.md` with a tabbed worked array script from
  `docs/snippets/workflows/job_arrays/{header-<cluster>.sh, body.sh}` (header `# FILENAME: array.sub`;
  body first line `# --- same on every cluster ---`; `--array` with `%N`). Check-your-limits
  commands without numbers. Link `../lifesciences/guides/running-bioinformatics.md#array-jobs` and
  each cluster's queues page.
- [ ] `docs/workflows/gnu_make.md`: one small in-job `make -j` example (a Makefile shown inline
  only if free of `{`-hazards, else a snippet).
- [ ] `docs/workflows/gnu_parallel.md`: one in-job example. Keep GNU Parallel's `{#}` and similar
  replacement strings in a snippet file (Jinja hazard). Note no Scholar module. Link
  `../software/apps_md/parallel.md`.
- [ ] Each page ends with "When to move to HyperShell" linking `hypershell/index.md`, added in P4.
  Until then, link the section hub and leave a TODO-free sentence that P4 turns into a link.
- [ ] Nav lines + hub cards; breadcrumbs.
- [ ] Draft run ends per Conventions → *Validating phases*. `VALIDATION.md`: `P2: PENDING`, files to run.
- **Verify:** see frontmatter (build + nav ×3 + sentinels + `P2: PASS`).
- **Touches:** the three pages, `docs/snippets/workflows/job_arrays/*`, any Make/Parallel snippet
  files, `docs/workflows/index.md`, `mkdocs.yml`, breadcrumbs, `VALIDATION.md` (status line only).

## Phase P3 — Workflow managers: Snakemake, Nextflow, Pegasus, Parsl
**Satisfies:** R1, R4, R13, R14, R15 · **Depends on:** P2 · **Validation:** V3 (login-node checks)
**Goal:** four short tool pages stating what each tool is, how it describes work, and where it
genuinely wins, with availability statements that match verified facts.

- [ ] `snakemake.md`: Anvil module 6.8.0 (live-checked) and Biocontainers per V3. Any Snakefile
  shown goes in a snippet (doubled-brace hazard).
- [ ] `nextflow.md`: cross-link both Life Sciences Nextflow guides; availability per the catalog
  and live check; composition over a lower-level executor in general terms only (research 03 §6),
  with no mention of any unreleased executor.
- [ ] `pegasus.md`: research 03 §5(d) wording. The Anvil Notebook Service route links
  `../userguides/anvil/notebook.md` and RCAC news 7628. ACCESS Pegasus via HTCondor Annex with an
  Anvil allocation. State that there is no community-cluster route. Do not print the `htcondor annex
  create` command (unverified). Do not link the HUBzero `pegasuswf.md` page.
- [ ] `parsl.md`: user `conda`/`uv` environment (link `../software/apps_md/uv.md` if present); Slurm
  provider in general terms. Any code shown is checked against Parsl's current docs.
- [ ] Nav lines + hub cards; breadcrumbs.
- [ ] Draft run ends per *Validating phases*; `P3: PENDING` lists every availability statement and
  command to confirm.
- **Verify:** see frontmatter.
- **Touches:** four pages, `docs/workflows/index.md`, `mkdocs.yml`, breadcrumbs, `VALIDATION.md`.

## Phase P4 — HyperShell guide landing page and Tier 1 (one job script)
**Satisfies:** R1, R6, R7, R12, R13, R14, R15 · **Depends on:** P3 · **Validation:** V4
**Goal:** the guide subsection exists with its landing page (version admonition, tier map) and a
complete, validated tier 1 script.

- [ ] `docs/workflows/hypershell/index.md`: PLAN §2 content. The **version admonition** (GOAL gate
  wording + `hs --version`; module versions differ by cluster). Tier map table from research 04 §3.
  Unpinned `module load hypershell`. Key handling (R12). Cards to tier pages as they appear (this
  phase: tier 1).
- [ ] `docs/workflows/hypershell/single_job.md`: Who this is for / Move on when / Minimum version
  (2.9.0). VFX frame-render scenario with a stand-in renderer (`render-frame.sh`). Tabbed script
  from `docs/snippets/workflows/frames/` (header `# FILENAME: frames.sub`). Body: a stable
  `HYPERSHELL_SITE` per campaign (path per V4), `hsx frames.txt --restart`, one client per node via
  `--launcher=srun` for multi-node, `-N` executors, `--capture` or failures file as validated.
  Sections on resubmitting after walltime (only unfinished frames run), checking outcomes
  (`hs list --failed`, `--completed`, `hs info`), re-running failures (`hs update --failed --revert`
  then resubmit; or `-r`). State plainly that this one script addresses most needs.
- [ ] Turn the P2 pages' "move to HyperShell" sentences into links to `hypershell/index.md`.
- [ ] Nav: `HyperShell User Guide:` subsection with index + tier 1; hub card for the guide;
  breadcrumbs.
- [ ] Draft run ends per *Validating phases*; `P4: PENDING`.
- **Verify:** see frontmatter.
- **Touches:** `docs/workflows/hypershell/{index,single_job}.md`, `docs/snippets/workflows/frames/*`,
  `docs/workflows/{index,job_arrays,gnu_make,gnu_parallel}.md`, `mkdocs.yml`, breadcrumbs, `VALIDATION.md`.

## Phase P5 — GPU multiplexing and Tier 2 (extreme scale)
**Satisfies:** R6, R8, R11, R12, R13, R14, R15 · **Depends on:** P4 · **Validation:** V5
**Goal:** a validated GPU multiplexing page after tier 1, and a tier 2 page for very large runs.

- [ ] `gpu_multiplexing.md`: research 04 §4(d) design; `docs/snippets/workflows/gpu_sweep/`
  (header `# FILENAME: gpu_sweep.sub`, `gpu-pick`, body). Tabs: Anvil, Gautschi, Gilbreth, Scholar
  (Negishi only if V5 validates the ROCm variant). MPS and MIG blocks only if V5's live checks pass,
  else one sentence each. Minimum version 2.9.0 (slots).
- [ ] `extreme_scale.md`: research 02 §2.4 and §10 options; states Purdue workloads rarely need
  it; leadership-facility framing; `docs/snippets/workflows/ensemble/` (header
  `# FILENAME: ensemble.sub`). Throughput figures only as validated illustrations.
- [ ] Nav lines (GPU page directly after tier 1, then tier 2); guide-landing cards; breadcrumbs.
- [ ] Draft run ends per *Validating phases*; `P5: PENDING`.
- **Verify:** see frontmatter.
- **Touches:** two pages, `docs/snippets/workflows/{gpu_sweep,ensemble}/*`, `docs/workflows/hypershell/index.md`,
  `mkdocs.yml`, breadcrumbs, `VALIDATION.md`.

## Phase P6 — Tier 3: a pipeline on one cluster
**Satisfies:** R6, R9, R12, R13, R14, R15 · **Depends on:** P5 · **Validation:** V6
**Goal:** a validated on-cluster pipeline with an intentional database and configuration, `hs submit`
phases on a login node, and a helper that schedules client jobs; groups and zones explained where
introduced.

- [ ] `pipelines.md`: research 04 tier 3 scenario. `docs/snippets/workflows/panel/`: `config.toml`
  (database, server, `server.auth` via `_eval` or `HYPERSHELL_SERVER_AUTH`), `submit-phases.sh`,
  `schedule-clients.sh` (opens `# FILENAME: schedule-clients.sh`), per-cluster `client-<cluster>.sh`
  headers as tabs. Server placement per PLAN §5 Q4 outcome. Groups: what, when, the reached-group
  rule. Zones: what, when, matching client jobs to partitions. `TASK_SLOT`, not `{slot}`, under
  `hs submit`. Minimum version 2.9.0 (zones), groups 2.8.0.
- [ ] Nav line; guide-landing card; breadcrumbs.
- [ ] Draft run ends per *Validating phases*; `P6: PENDING`.
- **Verify:** see frontmatter.
- **Touches:** `pipelines.md`, `docs/snippets/workflows/panel/*`, `docs/workflows/hypershell/index.md`,
  `mkdocs.yml`, breadcrumbs, `VALIDATION.md`.

## Phase P7 — Tier 4: persistent service on Geddes and relay autoscaling
**Satisfies:** R6, R10, R11, R12, R13, R14, R15 · **Depends on:** P6 · **Validation:** V7 (includes the manual Rancher walk-through)
**Goal:** two validated capstone pages: the Geddes pod (server + TimescaleDB) through Rancher, and
the relay-based autoscaling script on login00 with a second cluster, zones and groups together.

- [ ] `geddes_service.md`: research 05 §7.1 outline, Rancher steps in the
  `../../userguides/geddes/examples/database.md` style (link it as the base). Secrets, PVC
  (TimescaleDB `2.32.1-pg17`, mount per research 05 §2.3), the server container (image tag matching
  the validated build; arguments only; `hs` path note for Execute Shell), Recreate policy,
  LoadBalancer on the private pool with 50001 and 5432 and the DNS name. Explicit statements of
  credential storage, persistence and network exposure. At most one collapsed container-entries
  reference. One-line MCP note.
- [ ] `autoscaling.md`: login00 config (`docs/snippets/workflows/survey/relay.toml`),
  `run-relay.sh` (opens `# FILENAME: run-relay.sh`; `srun` launcher, never `sbatch`), drain and
  stop, login-node etiquette, `submit-night.sh` with zones + groups, *Adding a second cluster* per
  PLAN §5 Q3 outcome, operate and maintain. Link the GPU page from the GPU zone.
- [ ] Nav lines; guide-landing cards; breadcrumbs.
- [ ] Draft run ends per *Validating phases*; `P7: PENDING` lists the Rancher walk-through and the
  live checks (PLAN §6 V7, §5 Q4–Q8).
- **Verify:** see frontmatter.
- **Touches:** two pages, `docs/snippets/workflows/survey/*`, `docs/workflows/hypershell/index.md`,
  `mkdocs.yml`, breadcrumbs, `VALIDATION.md`.

## Phase P8 — Integration: hub completeness, cross-links, sweeps
**Satisfies:** R1, R12, R13, R14, R15 · **Depends on:** P7
**Goal:** the section is complete, cross-linked from its neighbours, and passes the convention and
accessibility sweeps.

- [ ] Hub: a card for every tool page and the guide (R1); guide landing: a card per tier page and
  the GPU page; the placement table's tool names link their pages.
- [ ] One-sentence "See also" in `docs/lifesciences/guides/nextflow.md` (after line 22) and
  `docs/lifesciences/guides/nextflow-gautschi.md` (after line 55) to `../../workflows/index.md`; one
  sentence appended at `docs/workshops/hpc_exchange/week4/workload-management.md` line 195 linking
  `../../../workflows/hypershell/index.md`. No other edits to those pages.
- [ ] R12 sweep (`hs task`, `-k`), Jinja grep, anchor-log grep, back-links at page ends.
- [ ] Accessibility sweep (R14): one H1, heading order, table header rows, descriptive link text,
  alt text on any image.
- [ ] Confirm `VALIDATION.md` shows PASS for P2–P7; if a P8 edit touches a script, re-validate it.
- [ ] Regenerate breadcrumbs; `.venv/bin/mkdocs serve` walk-through of the whole section.
- [ ] On done: `--top-status in_review`.
- **Verify:** see frontmatter.
- **Touches:** `docs/workflows/**`, the three cross-link pages, `mkdocs.yml` (only if nav fixes),
  breadcrumbs.

---

## How `docs-draft` drives this

1. `next_phase.py` prints the next actionable phase.
2. Pre-flight: clean tree, on `branch`, `.venv` present.
3. Execute every `[ ]` in the phase (consult `PLAN.md` / `research/` / `style-guide.md`).
4. Run the phase's `verify:` (for P2–P7 in a draft run, the clauses before the `VALIDATION.md` grep;
   see *Validating phases*).
5. Amend this file if reality diverges (via `set_phase.py`; note it in the commit body). STOP only
   on a `GOAL.md` contradiction.
6. Update state, one `[feature]` commit, stop and report.
