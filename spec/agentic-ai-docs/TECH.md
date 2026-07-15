---
slug: agentic-ai-docs
title: 'Agentic AI on RCAC: guidance, MCP tooling, and shared context'
kind: feature
appetite: big
status: in_progress
branch: feature/agentic-ai-docs
base: main
current_phase: P9
last_updated: '2026-07-15'
phases:
- id: P1
  name: 'Scaffold: section hub + top-level nav anchor'
  status: done
  satisfies:
  - R1
  depends_on: []
  parallel: false
  hammerable: false
  hill: uphill
  verify: .venv/bin/mkdocs build --strict 2>&1 | python3 .agents/factory/bin/strict_check.py
    && grep -q 'agentic-ai/index.md' mkdocs.yml
- id: P2
  name: Acceptable Use & Etiquette page
  status: done
  satisfies:
  - R2
  depends_on:
  - P1
  parallel: false
  hammerable: false
  hill: uphill
  verify: .venv/bin/mkdocs build --strict 2>&1 | python3 .agents/factory/bin/strict_check.py
    && grep -q 'acceptable_use.md' mkdocs.yml
- id: P3
  name: Best Practices & Limitations page
  status: done
  satisfies:
  - R3
  depends_on:
  - P1
  parallel: false
  hammerable: true
  hill: uphill
  verify: .venv/bin/mkdocs build --strict 2>&1 | python3 .agents/factory/bin/strict_check.py
    && grep -q 'best_practices.md' mkdocs.yml
- id: P4
  name: MCP Servers page (rcac-mcp / globus-mcp / rcac-docs-mcp)
  status: done
  satisfies:
  - R7
  - R8
  - R9
  - R16
  depends_on:
  - P1
  parallel: false
  hammerable: false
  hill: uphill
  verify: .venv/bin/mkdocs build --strict 2>&1 | python3 .agents/factory/bin/strict_check.py
    && grep -q 'mcp_servers.md' mkdocs.yml
- id: P5
  name: 'Running Agents: overview + on-cluster (login nodes)'
  status: done
  satisfies:
  - R4
  - R5
  depends_on:
  - P1
  parallel: false
  hammerable: false
  hill: uphill
  verify: .venv/bin/mkdocs build --strict 2>&1 | python3 .agents/factory/bin/strict_check.py
    && grep -q 'running_agents/on_cluster.md' mkdocs.yml
- id: P6
  name: 'Running Agents: local, targeting the cluster (MCP + SSH)'
  status: done
  satisfies:
  - R4
  - R6
  depends_on:
  - P1
  - P5
  parallel: false
  hammerable: false
  hill: uphill
  verify: .venv/bin/mkdocs build --strict 2>&1 | python3 .agents/factory/bin/strict_check.py
    && grep -q 'running_agents/local.md' mkdocs.yml
- id: P7
  name: 'Shared context: hub + build/publish the 5 /etc/agents.d files'
  status: done
  satisfies:
  - R10
  - R12
  - R16
  depends_on:
  - P1
  parallel: false
  hammerable: false
  hill: uphill
  verify: .venv/bin/mkdocs build --strict 2>&1 | python3 .agents/factory/bin/strict_check.py
    && grep -q 'shared_context/context_files.md' mkdocs.yml && grep -rq RCAC_SCRATCH
    site/agentic-ai/shared_context/
- id: P8
  name: Build/publish per-harness settings & permissions (all five)
  status: done
  satisfies:
  - R11
  - R12
  depends_on:
  - P1
  - P7
  parallel: false
  hammerable: false
  hill: uphill
  verify: .venv/bin/mkdocs build --strict 2>&1 | python3 .agents/factory/bin/strict_check.py
    && grep -q 'shared_context/settings.md' mkdocs.yml && grep -rq mcpServers site/agentic-ai/shared_context/
- id: P9
  name: Gautschi 'Using AI Agents' chapter
  status: pending
  satisfies:
  - R13
  - R16
  depends_on:
  - P1
  - P4
  - P5
  - P6
  - P7
  parallel: false
  hammerable: false
  hill: uphill
  verify: .venv/bin/mkdocs build --strict 2>&1 | python3 .agents/factory/bin/strict_check.py
    && grep -q 'using_ai_agents.md' mkdocs.yml
- id: P10
  name: 'Integration: hub cards, cross-links, breadcrumbs, a11y + accuracy sweep'
  status: pending
  satisfies:
  - R14
  - R15
  - R16
  depends_on:
  - P1
  - P2
  - P3
  - P4
  - P5
  - P6
  - P7
  - P8
  - P9
  parallel: false
  hammerable: false
  hill: uphill
  verify: .venv/bin/mkdocs build --strict 2>&1 | python3 .agents/factory/bin/strict_check.py
    && .venv/bin/python tools/generate_breadcrumbs.py && grep -q 'Agentic AI' mkdocs.yml
review:
  last_reviewed_commit: ''
  verdict: none
  blocked_reason: ''
---
# TECH.md — Agentic AI on RCAC

The **context engine and finite-state machine** for authoring this job. The YAML frontmatter above
is the resume ground-truth (read it with
`python3 .agents/factory/bin/next_phase.py spec/agentic-ai-docs/TECH.md`); the per-phase checklists
below are the work. `docs-draft` executes the next actionable phase, runs its `verify:`, updates
state via `set_phase.py`, and makes one atomic content+state commit. Run from the repo root with the
project env active.

- **Vision / requirements (locked):** [`GOAL.md`](GOAL.md) — R-IDs are the contract.
- **Authoritative design:** [`PLAN.md`](PLAN.md).
- **Backing research:** [`research/00-digest.md`](research/00-digest.md) + the six briefs.

## Conventions (apply to every phase)

- Voice/archetype/load-bearing rules from [`../../AGENTS.md`](../../AGENTS.md),
  [`style-guide.md`](../../.agents/factory/style-guide.md), and
  [`invariants.md`](../../.agents/factory/invariants.md).
- One phase per `docs-draft` invocation; one atomic commit with **both** content and the `TECH.md`
  state change. Subjects: `[feature] Draft agentic-ai-docs P<n>: …`. **No `Co-Authored-By`.**
- **Adding a page updates `mkdocs.yml` `nav:` in the same commit** (else orphaned / missing-file
  `--strict` failure). Add nav lines in reading order (see PLAN §2). Regenerate breadcrumbs at P10
  (`.venv/bin/python tools/generate_breadcrumbs.py`).
- **Verbatim artifacts** (`docs/agentic-ai` pages that show config) use the proven pattern: a real
  file under `docs/snippets/agentic-ai/…` embedded in a fenced block via `--8<--` (post-Jinja, so
  literal `{{`/`{%` is safe). `check_paths:false` fails silently → each such phase greps the built
  `site/` for a sentinel and eyeballs `mkdocs serve`.
- **HPC accuracy (hammerable:false):** author from [`research/03-gautschi-facts.md`](research/03-gautschi-facts.md)
  and [`research/04-mcp-servers.md`](research/04-mcp-servers.md). **Never** emit `--partition=a10` or
  `#SBATCH -A standby`. Defer volatile numbers (quotas) to `myquota`/`slist`; don't invent
  `[UNCONFIRMED]` specifics.
- Never hand-edit generated files (catalogs, breadcrumbs) — regenerate via `tools/`.
- Each content page ends with a back-link to its hub; **sibling cross-links are deferred to P10** so
  intermediate builds stay `--strict`-clean.

---

## Phase P1 — Scaffold: section hub + nav anchor
**Satisfies:** R1 · **Depends on:** — · **hammerable:** false
**Goal:** the top-level `Agentic AI` section exists with a hub `index.md` stating RCAC's stance, is
wired into nav, and builds clean.

- [x] Create `docs/agentic-ai/index.md` (hub archetype, mirror `docs/lifesciences/index.md`):
      `title: Agentic AI`, `tags: [Agentic AI]`; one H1; a stance intro (proactive engagement, not
      prohibition; "mostly harmless"; verify, don't forbid — from GOAL/paper). Grid-card links are
      **deferred to P10** (children don't exist yet) — for now a short "in this section" prose list
      with **no dead links**, or cards pointing only to pages that exist.
- [x] Insert the top-level `Agentic AI` nav block after Life Sciences (`mkdocs.yml:361`), initially
      containing only `- agentic-ai/index.md`.
- **Verify:** `.venv/bin/mkdocs build --strict 2>&1 | python3 .agents/factory/bin/strict_check.py && grep -q 'agentic-ai/index.md' mkdocs.yml`
- **Touches:** `docs/agentic-ai/index.md`, `mkdocs.yml`.

## Phase P2 — Acceptable Use & Etiquette
**Satisfies:** R2 · **Depends on:** P1 · **hammerable:** false
**Goal:** a page stating the rules for running agents on RCAC systems, consistent with the existing
AUP, with a link to the Purdue IT policy of record.

- [x] Create `docs/agentic-ai/acceptable_use.md` (policy archetype, mirror
      `docs/userguides/anvil/policies.md`): `tags`+`authors`; one H1; hand-written sections — no
      heavy compute on login nodes (quote/echo the Gautschi Running-Jobs rule), jobs via Slurm with
      `--time`, no sensitive data in world-readable paths, no secrets/credentials in context,
      destructive actions require confirmation, agent output is the user's responsibility.
- [x] Reuse the canonical AUP block: `{% set resource = "gautschi" %}` then
      `{{ resource_use(resource) }}` (or link Purdue IT Acceptable Use Policy V.4.1 directly if a
      single-cluster `resource` reads oddly for cross-cluster policy — see research 02).
- [x] Add nav line under the section; back-link to the hub.
- **Verify:** `… strict_check.py && grep -q 'acceptable_use.md' mkdocs.yml`
- **Touches:** `docs/agentic-ai/acceptable_use.md`, `mkdocs.yml`.

## Phase P3 — Best Practices & Limitations
**Satisfies:** R3 · **Depends on:** P1 · **hammerable:** true
**Goal:** a page distinguishing agents *for research* vs *for operations*, covering context
engineering, verification, and caution/blast-radius.

- [x] Create `docs/agentic-ai/best_practices.md`: research-vs-operations distinction; context
      engineering ("Tea, Earl Grey, hot" — specificity); verification ("augmented, not outsourced";
      ask *why* not just *what*; the expertise paradox); **let agents run read-only sanity checks
      eagerly** (`myquota`, `slist`, `sfeatures`, `module list`, `module avail`) to ground themselves
      before acting; caution/blast-radius (destructive commands, allocation exhaustion,
      credential/secret leakage; existing HPC confinement contains blast radius). **Container note:
      RCAC uses Apptainer (not Docker), and its config auto bind-mounts `/home`, `/depot`, `/scratch`
      — so containers give limited protection and the likeliest failure is an agent *editing files*;
      don't imply Docker-style sandboxing.** Frame from the paper's Discussion; professional voice.
- [x] Add nav line; back-link to hub.
- **Verify:** `… strict_check.py && grep -q 'best_practices.md' mkdocs.yml`
- **Touches:** `docs/agentic-ai/best_practices.md`, `mkdocs.yml`.

## Phase P4 — MCP Servers
**Satisfies:** R7, R8, R9, R16 · **Depends on:** P1 · **hammerable:** false
**Goal:** document the three RCAC MCP servers accurately (why MCP; current focus; verified connect
commands; the `/etc/agents.d` injection), presenting the tooling as prototype/evolving.

- [x] Create `docs/agentic-ai/mcp_servers.md`: "why MCP" (context that knows our clusters); present
      **all three as actively-developed working prototypes**; a per-server section for **rcac-mcp**
      (HPC ops, stdio via `uvx`, runs over the user's existing SSH, tool list, `rcac://context`),
      **globus-mcp** (transfers, beta, user's Globus OAuth), **rcac-docs-mcp** (hosted HTTP at
      `docs.rcac.purdue.edu/mcp`, `doc_search`/`doc_load`). Link each public repo. Use the
      **verified** connect blocks from research 04 (inline fenced JSON/TOML — short, no Jinja triggers).
- [x] State that the HPC server reads the host's `/etc/agents.d` markdown over SSH and injects it as
      context (R8).
- [x] **Explicitly call out the planned rename / re-architecture of `rcac-mcp`** toward the HPC-only
      plugin model (`cluster-mcp[slurm,lmod,…]`) — framed as a **stated direction / planned&evolving**,
      NOT shipped fact (human-confirmed framing 2026-07-15; research 04 marks it `[UNVERIFIED]`).
- [x] Add nav line; back-link to hub.
- **Verify:** `… strict_check.py && grep -q 'mcp_servers.md' mkdocs.yml`
- **Touches:** `docs/agentic-ai/mcp_servers.md`, `mkdocs.yml`.

## Phase P5 — Running Agents: overview + on-cluster
**Satisfies:** R4, R5 · **Depends on:** P1 · **hammerable:** false
**Goal:** the `Running Agents` area exists (mode overview) plus the on-cluster (login-node) page
covering all five harnesses with the login-node constraints.

- [x] Create `docs/agentic-ai/running_agents/index.md` (subdir hub): explain the two deployment
      modes (on-cluster vs local MCP+SSH); card/links to the two mode pages (local link deferred to
      P10 if `local.md` not yet created — or ordered so on_cluster exists here and local added P6).
- [x] Create `docs/agentic-ai/running_agents/on_cluster.md`: install/run each of Claude Code, Codex,
      Gemini CLI, opencode on a login node (Linux); the login-node compute constraint (mirror the
      Gautschi Running-Jobs rule); point writable work at `$RCAC_SCRATCH`; note OS sandboxes are
      often unavailable on shared nodes (RCAC uses **Apptainer**, which auto bind-mounts
      `/home`/`/depot`/`/scratch` → limited protection). **Warp:** state honestly it is a local
      desktop GUI and **cannot** run on a login node — but it is **RCAC's recommended harness for most
      users**; run it on your workstation and SSH in (point to the local page for the recommended
      workflow).
- [x] Add the `Running Agents` nav sub-section (index + On the Cluster); back-links to hub.
- **Verify:** `… strict_check.py && grep -q 'running_agents/on_cluster.md' mkdocs.yml`
- **Touches:** `docs/agentic-ai/running_agents/{index,on_cluster}.md`, `mkdocs.yml`.

## Phase P6 — Running Agents: local (MCP + SSH)
**Satisfies:** R4, R6 · **Depends on:** P1, P5 · **hammerable:** false
**Goal:** the local-mode page — agent runs in the user's own environment, executes remotely over
existing SSH via the MCP servers.

- [x] Create `docs/agentic-ai/running_agents/local.md`: the local-first architecture (no new
      credentials, no hosted infra — "if you can SSH to the cluster, your agent can too"); how to
      register `rcac-mcp` (and globus-mcp / rcac-docs-mcp) in each harness (reference research 05
      MCP-config forms); cite `docs/lifesciences/guides/vscode.md` as prior art for external-tool →
      cluster tunneling. **Feature Warp first-class and up front — it is RCAC's recommended harness
      for most users: tell the story of using it *well* locally (Agent Mode on the workstation,
      targeting Gautschi over SSH, with `rcac-mcp` connected).** Back-link to hub; forward links to
      `mcp_servers.md` deferred to P10.
- [x] Add the `Local (MCP + SSH)` nav line under Running Agents.
- **Verify:** `… strict_check.py && grep -q 'running_agents/local.md' mkdocs.yml`
- **Touches:** `docs/agentic-ai/running_agents/local.md`, `mkdocs.yml`.

## Phase P7 — Shared context: hub + build/publish the 5 context files
**Satisfies:** R10, R12, R16 · **Depends on:** P1 · **hammerable:** false
**Goal:** author the five Gautschi `/etc/agents.d` context files (byte-exact, HPC-accurate) and
publish them verbatim; the shared-context hub explains the model + how to give feedback.

- [x] Author canonical files under `docs/snippets/agentic-ai/agents.d/`: `unix.md`, `filesystems.md`,
      `lmod.md`, `slurm.md`, `policies.md` — each *fact → correct command/path → "do not…" →
      rationale* (outlines in research 06), grounded in verified Gautschi facts (research 03). Also
      write `agents.d/AGENTS.md` (the concatenated canonical context harnesses read). Instruct the
      agent to **eagerly run read-only sanity checks** (`myquota`, `slist`, `sfeatures`,
      `module list`, `module avail`) before acting. **Accuracy gate:** partitions
      cpu/ai/highmem/smallgpu/profiling; QOS normal/standby/preemptible; `-A` (via `slist`) + `-q` +
      `-p` mandatory; filesystems **`/home` ZFS · `/depot` GPFS · `/scratch` (`$RCAC_SCRATCH`) Lustre,
      60-day purge**, `myquota`/`findscratch`; GCC 14.1.0 + OpenMPI; **Apptainer (not Docker), config
      auto bind-mounts `/home`/`/depot`/`/scratch` → limited protection**; **no `--partition=a10`,
      no `-A standby`**; defer quota numbers to `myquota`.
- [x] Create `docs/agentic-ai/shared_context/index.md` (subdir hub): what `/etc/agents.d` is, that
      these files are the **canonical single source of truth** copied into cluster config management
      (Puppet) and injected by the MCP server over SSH, and **how to contribute feedback/corrections**
      (RCAC-Docs GitHub issues + rcac-help@purdue.edu + Discord).
- [x] Create `docs/agentic-ai/shared_context/context_files.md`: publish each context file verbatim
      via `--8<--` fenced `markdown` blocks with `title=` labels.
- [x] Add the `Shared Context & Settings` nav sub-section (index + Context Files); back-links to hub.
- [x] `mkdocs serve` — confirm the included blocks render non-empty (check_paths footgun).
- **Verify:** `… strict_check.py && grep -q 'shared_context/context_files.md' mkdocs.yml && grep -rq RCAC_SCRATCH site/agentic-ai/shared_context/`
- **Touches:** `docs/snippets/agentic-ai/agents.d/*.md`, `docs/agentic-ai/shared_context/{index,context_files}.md`, `mkdocs.yml`.

## Phase P8 — Build/publish per-harness settings & permissions
**Satisfies:** R11, R12 · **Depends on:** P1, P7 · **hammerable:** false
**Goal:** author and publish verbatim the per-harness settings/permission files for all five
harnesses, wiring in the shared context and encoding a starting-point enforced-permission policy.

- [x] Author canonical files under `docs/snippets/agentic-ai/`. Every file must both **allow-list
      read-only sanity commands** (`myquota`, `slist`, `sfeatures`, `module list`, `module avail`) so
      they run without prompting, **and deny** destructive/dangerous ops (`rm -rf`, `sudo`):
      `claude/settings.json` (`permissions.allow` for the sanity commands + `permissions.deny` for
      `rm -rf`/`sudo`; note managed `/etc/claude-code/managed-settings.json` as the enforcement point;
      `mcpServers` for rcac-mcp; CLAUDE.md→AGENTS.md bridge), `codex/config.toml`
      (`approval_policy`/`sandbox_mode`; `[mcp_servers.rcac]`; AGENTS.md native — note Codex has no
      per-command allowlist, so rely on approval/sandbox mode), `gemini/settings.json` (`tools.core`
      allow-list `run_shell_command(myquota)`/`(slist)`/`(module)`… + `tools.exclude`
      `run_shell_command(rm)`/`(sudo)`; note system `/etc/gemini-cli/settings.json` as the enforcement
      point; `mcpServers`), `opencode/opencode.json` (`permission` bash-pattern map — allow the sanity
      commands, deny `rm -rf *`/`sudo *`, **catch-all first**; `mcp` local), `warp/AGENTS.md` (Warp has
      no server-side settings file — represent it as the repo AGENTS.md + a documented Agent-Profile
      allow/deny list; note Run-until-completion bypasses the denylist). Use research 05 for exact
      schema; mark any `[UNVERIFIED]` key honestly.
- [x] Create `docs/agentic-ai/shared_context/settings.md`: publish each settings file verbatim via
      `--8<--` fenced blocks (json/toml/markdown); explain each harness's permission model briefly,
      that this is a **v0 starting point** inviting feedback, and where config-management enforcement
      lives (managed/system files). Note OS-sandbox weakness on shared nodes.
- [x] Add the `Harness Settings & Permissions` nav line; back-link to hub.
- [x] `mkdocs serve` — confirm blocks render non-empty.
- **Verify:** `… strict_check.py && grep -q 'shared_context/settings.md' mkdocs.yml && grep -rq mcpServers site/agentic-ai/shared_context/`
- **Touches:** `docs/snippets/agentic-ai/{claude,codex,gemini,opencode,warp}/…`, `docs/agentic-ai/shared_context/settings.md`, `mkdocs.yml`.

## Phase P9 — Gautschi "Using AI Agents" chapter
**Satisfies:** R13, R16 · **Depends on:** P1, P4, P5, P6, P7 · **hammerable:** false
**Goal:** a Gautschi user-guide chapter giving cluster-specific setup pointers, cross-linked with the
top-level section.

- [ ] Create `docs/userguides/gautschi/using_ai_agents.md` (userguide archetype): `tags: [Gautschi]`,
      `authors`, `{% set resource = "gautschi" %}`; Gautschi-specific quick-start (login host
      `gautschi.rcac.purdue.edu`, `slist`/`myquota`, partitions/QOS reminders), and links into the
      top-level Agentic AI pages (MCP servers, running-agents, shared context). Reuse macros for
      SSH/module/Slurm background where helpful.
- [ ] Insert the `Using AI Agents` nav line between Compiling Source Code (`mkdocs.yml:144`) and FAQs.
- **Verify:** `… strict_check.py && grep -q 'using_ai_agents.md' mkdocs.yml`
- **Touches:** `docs/userguides/gautschi/using_ai_agents.md`, `mkdocs.yml`.

## Phase P10 — Integration: cards, cross-links, breadcrumbs, sweep
**Satisfies:** R14, R15, R16 · **Depends on:** P1–P9 · **hammerable:** false
**Goal:** the section reads as one coherent whole; every internal link resolves; breadcrumbs are
current; a11y and HPC accuracy pass a final review.

- [ ] Populate the hub grid-cards (`agentic-ai/index.md`) linking every subpage; add the
      Running-Agents index card to `local.md`; add sibling cross-links (running-agents ↔ mcp_servers
      ↔ shared_context ↔ Gautschi chapter).
- [ ] `.venv/bin/python tools/generate_breadcrumbs.py` (nav changed).
- [ ] a11y sweep: one H1/page, descending headings, header rows on tables, descriptive link text,
      alt text on any image.
- [ ] HPC-accuracy final pass against research 03/04: partitions, QOS, paths, commands, MCP connect
      strings; confirm **no `--partition=a10` / `-A standby`** anywhere in the new pages/snippets.
- [ ] Full `mkdocs serve` eyeball of the whole section.
- **Verify:** `… strict_check.py && .venv/bin/python tools/generate_breadcrumbs.py && grep -q 'Agentic AI' mkdocs.yml`
- **Touches:** `docs/agentic-ai/**`, `docs/userguides/gautschi/using_ai_agents.md`, `docs/assets/data/breadcrumbs.json`, `mkdocs.yml`.

---

## How `docs-draft` drives this

1. `next_phase.py spec/agentic-ai-docs/TECH.md` prints the next actionable phase (statuses are
   authoritative).
2. Pre-flight: clean tree, on `feature/agentic-ai-docs`, `main` reachable, env active
   (`.venv/bin/python -c "import yaml, mkdocs"`).
3. Execute every `[ ]` in the phase (consult `PLAN.md` / `research/` / `style-guide.md`).
4. Run the phase's `verify:` — never advance on a checkbox alone.
5. Amend this file if reality diverges (`set_phase.py`; note in the commit body). STOP and escalate
   only on a **`GOAL.md` contradiction** or a phase stuck `uphill` across drafts (raised hand — esp.
   the `cluster-mcp` framing and any newly-surfaced `[UNCONFIRMED]` HPC spec).
6. Mark the phase `done`, advance `current_phase`, `--touch`; one `[feature]` commit; stop & report.
