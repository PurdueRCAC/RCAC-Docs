---
slug: agents-d-all-clusters
title: /etc/agents.d context for every cluster; retire per-harness settings
kind: feature
appetite: big
status: in_progress
branch: feature/agents-d-all-clusters
base: main
current_phase: P3
last_updated: '2026-10-09'
phases:
- id: P1
  name: Retire per-harness settings from the pages (stub, MCP docs-server tabs)
  status: done
  satisfies:
  - R4
  - R5
  depends_on: []
  parallel: false
  hammerable: false
  hill: uphill
  verify: .venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py
    && grep -q 'shared_context/settings.md' mkdocs.yml && ! grep -rlq 'managed-settings'
    site/ && grep -rq 'docs.rcac.purdue.edu/mcp' site/agentic-ai/mcp_servers/
- id: P2
  name: 'Generator: emit context only; data-driven templates; drop purgelist'
  status: done
  satisfies:
  - R2
  - R7
  depends_on:
  - P1
  parallel: false
  hammerable: false
  hill: uphill
  verify: git add -A docs/snippets/agentic-ai && .venv/bin/python tools/generate_agent_context.py
    && git diff --quiet -- docs/snippets/agentic-ai && ! grep -rq 'purgelist' docs/snippets/agentic-ai/
    && .venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py
- id: P3
  name: 'Anvil: data model and Using AI Agents chapter'
  status: pending
  satisfies:
  - R1
  - R2
  - R3
  depends_on:
  - P2
  parallel: false
  hammerable: false
  hill: uphill
  verify: git add -A docs/snippets/agentic-ai && .venv/bin/python tools/generate_agent_context.py
    && git diff --quiet -- docs/snippets/agentic-ai && ! (grep -h 'slist\|findscratch\|RCAC_SCRATCH\|hsi\|htar\|standby\|rcac-help'
    docs/snippets/agentic-ai/anvil/agents.d/*.md | grep -v 'Do NOT' | grep -q .) &&
    .venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py
    && grep -q 'userguides/anvil/using_ai_agents.md' mkdocs.yml && grep -q 'anvil.yml'
    site/userguides/anvil/using_ai_agents/index.html
- id: P4
  name: 'Scholar: data model and Using AI Agents chapter'
  status: pending
  satisfies:
  - R1
  - R2
  - R3
  depends_on:
  - P3
  parallel: false
  hammerable: false
  hill: uphill
  verify: git add -A docs/snippets/agentic-ai && .venv/bin/python tools/generate_agent_context.py
    && git diff --quiet -- docs/snippets/agentic-ai && ! (grep -h 'standby\|preemptible'
    docs/snippets/agentic-ai/scholar/agents.d/*.md | grep -v 'Do NOT' | grep -q .)
    && ! grep -q 'None' docs/snippets/agentic-ai/scholar/agents.d/AGENTS.md && .venv/bin/mkdocs
    build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py &&
    grep -q 'userguides/scholar/using_ai_agents.md' mkdocs.yml && grep -q 'scholar.yml'
    site/userguides/scholar/using_ai_agents/index.html
- id: P5
  name: 'How the context reaches an agent: per-harness opt-in and rcac://context'
  status: pending
  satisfies:
  - R6
  depends_on:
  - P4
  parallel: false
  hammerable: false
  hill: uphill
  verify: .venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py
    && grep -rq 'etc/agents.d/AGENTS.md' site/agentic-ai/shared_context/ && ! grep
    -rqi 'symlinked to' site/agentic-ai/
- id: P6
  name: Plain-language pass over the section and the five chapters
  status: pending
  satisfies:
  - R8
  depends_on:
  - P5
  parallel: false
  hammerable: true
  hill: uphill
  verify: .venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py
    && ! grep -rqi 'absorbs the cluster\|not prohibition\|push back' docs/agentic-ai/
    docs/userguides/*/using_ai_agents.md
- id: P7
  name: 'Integration: cross-links to all five chapters, breadcrumbs, final checks'
  status: pending
  satisfies:
  - R3
  - R4
  - R7
  - R9
  depends_on:
  - P6
  parallel: false
  hammerable: false
  hill: uphill
  verify: git add -A docs/snippets/agentic-ai && .venv/bin/python tools/generate_agent_context.py
    && git diff --quiet -- docs/snippets/agentic-ai && .venv/bin/python tools/generate_breadcrumbs.py
    && test -z "$(git status --porcelain docs/assets/data/breadcrumbs.json)" && .venv/bin/mkdocs
    build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py &&
    ! grep -rlq 'managed-settings' site/ && for c in anvil gautschi gilbreth negishi
    scholar; do grep -q "$c.yml" site/userguides/$c/using_ai_agents/index.html ||
    exit 1; done
review:
  last_reviewed_commit: ''
  verdict: none
  blocked_reason: ''
---
# TECH.md — `/etc/agents.d` context for every cluster; retire per-harness settings

The finite-state machine for this job. The YAML frontmatter is the resume ground truth
(`.venv/bin/python .agents/factory/bin/next_phase.py spec/agents-d-all-clusters/TECH.md`).

- **Vision / requirements (locked):** [`GOAL.md`](GOAL.md).
- **Authoritative design:** [`PLAN.md`](PLAN.md).
- **Backing research:** [`research/00-digest.md`](research/00-digest.md).

## Conventions (apply to every phase)

- Constitution: [`../../AGENTS.md`](../../AGENTS.md), [`style-guide.md`](../../.agents/factory/style-guide.md),
  [`invariants.md`](../../.agents/factory/invariants.md).
- One phase per `docs-draft` pass; one commit with content and `TECH.md` state:
  `[feature] Draft agents-d-all-clusters P<n>: …`. No `Co-Authored-By` trailer.
- A nav change regenerates breadcrumbs in the same commit.
- Never hand-edit `docs/snippets/agentic-ai/**` or `breadcrumbs.json`.
- Public repository: no page, artifact or commit names internal configuration or deployment
  detail. Say where the files are and what users do.
- Plain language (R8) applies to every line a phase writes, not only in P6.

---

## Phase P1 — Retire per-harness settings from the pages
**Satisfies:** R4, R5 · **Depends on:** —
**Goal:** no page presents a settings file as RCAC-deployed; the old URL resolves to a stub.

- [x] Replace `docs/agentic-ai/shared_context/settings.md` with the stub (PLAN §2.3).
- [x] `mcp_servers.md`: add the four-tab docs-server registration block (Claude Code, Codex,
      Gemini CLI, opencode) carried over from the settings templates; re-check each form
      against `research/05`.
- [x] Remove the `managed-settings.json` paragraph and include from the three chapters.
- [x] Replace the settings sentences in `index.md`, `acceptable_use.md`, `best_practices.md`,
      `running_agents/on_cluster.md`, `running_agents/local.md`, `shared_context/index.md`
      (research/05 C.2) with harness-own approval advice.
- [x] `mkdocs.yml`: relabel "Shared Context & Settings" → "Shared Context" and the settings
      entry → "Harness Settings (Retired)"; regenerate breadcrumbs.
- **Verify:** see frontmatter.
- **Touches:** `docs/agentic-ai/**`, `docs/userguides/{gautschi,gilbreth,negishi}/using_ai_agents.md`,
  `mkdocs.yml`, `docs/assets/data/breadcrumbs.json`.

## Phase P2 — Generator: context only, data-driven templates
**Satisfies:** R2, R7 · **Depends on:** P1
**Goal:** the generator emits only `agents.d/`; templates read commands, QOS and support text
from data; the existing three regenerate identically apart from `purgelist`.

- [x] Delete the settings code paths and docstring text; `git rm` the four template dirs and the
      twelve generated settings files.
- [x] Add `DEFAULTS` and a deep-merge (PLAN §2.1); make the five templates read them.
- [x] Wrap the `-A standby` prohibition; generic QOS mapping branch; `os: null` and
      `purge_days: null` branches; `notes.<topic>` bullets; optional `filesystems.project`.
- [x] Remove the `purgelist` bullet.
- [x] Before committing, diff the regenerated Gautschi, Gilbreth and Negishi `agents.d/` against
      `main`: only the `purgelist` lines may change.
- [x] Update `docs/snippets/agentic-ai/GENERATED.md`.
- **Touches:** `tools/generate_agent_context.py`, `tools/agent_context/templates/**`,
  `docs/snippets/agentic-ai/**`.

## Phase P3 — Anvil
**Satisfies:** R1, R2, R3 · **Depends on:** P2
**Goal:** Anvil's context is correct for Anvil and is shown in its guide.

- [ ] Write `tools/agent_context/clusters/anvil.yml` (PLAN §2.2; cite sources in comments).
- [ ] Regenerate; read the five rendered files line by line against `research/01`.
- [ ] Create `docs/userguides/anvil/using_ai_agents.md`; add it to nav after
      `anvil-software.md` and to `docs/userguides/anvil/index.md` before FAQs; regenerate
      breadcrumbs.
- **Touches:** `tools/agent_context/clusters/anvil.yml`, `docs/snippets/agentic-ai/anvil/**`,
  `docs/userguides/anvil/{using_ai_agents,index}.md`, `mkdocs.yml`, `breadcrumbs.json`.

## Phase P4 — Scholar
**Satisfies:** R1, R2, R3 · **Depends on:** P3
**Goal:** Scholar's context is correct for Scholar and is shown in its guide.

- [ ] Write `tools/agent_context/clusters/scholar.yml` (PLAN §2.2).
- [ ] Regenerate; read the rendered files against `research/03`.
- [ ] Create `docs/userguides/scholar/using_ai_agents.md`; nav after Scholar `compile.md`;
      `index.md` entry; breadcrumbs.
- **Touches:** `tools/agent_context/clusters/scholar.yml`, `docs/snippets/agentic-ai/scholar/**`,
  `docs/userguides/scholar/{using_ai_agents,index}.md`, `mkdocs.yml`, `breadcrumbs.json`.

## Phase P5 — How the context reaches an agent
**Satisfies:** R6 · **Depends on:** P4
**Goal:** the pages describe what is true: files on login and compute nodes, a one-time
per-cluster opt-in per harness, and `rcac://context` on demand for local agents.

> **Amended 2026-10-09 (P1):** the page rewrites for this phase landed in P1, because the same
> paragraphs carried the settings text: `shared_context/index.md` (Load the context in your
> harness), `context_files.md`, `mcp_servers.md`, `running_agents/{on_cluster,local}.md`, and
> the chapter shape. P5 now re-reads those pages against `research/05` A–B and checks that
> the Anvil and Scholar chapters carry the same wording.

- [ ] `shared_context/index.md`: "Load it in your harness" section with tabs (research/05 A.1–A.5),
      including the Codex existing-file and Gemini `fileName`-order caveats; local agents via
      `rcac://context`; remove the symlink claim.
- [ ] `context_files.md`, `running_agents/on_cluster.md`, `running_agents/local.md`,
      `mcp_servers.md`, the five chapters: align the delivery sentences (research/05 C.3).
- **Touches:** `docs/agentic-ai/**`, `docs/userguides/*/using_ai_agents.md`.

## Phase P6 — Plain-language pass
**Satisfies:** R8 · **Depends on:** P5
**Goal:** the section and the five chapters state facts and instructions plainly.

- [ ] Apply research/05 C.1 rewrites on lines that remain; drop decorative bold.
- [ ] Read each page top to bottom once more for slogans and rhetorical framing.
- **Touches:** `docs/agentic-ai/**`, `docs/userguides/*/using_ai_agents.md`.

## Phase P7 — Integration
**Satisfies:** R3, R4, R7, R9 · **Depends on:** P6
**Goal:** every hub lists all five chapters; generated files and breadcrumbs are in sync.

- [ ] Hubs (`agentic-ai/index.md`, `context_files.md`) link all five chapters.
- [ ] Regenerate context and breadcrumbs; both must leave the tree clean.
- [ ] `mkdocs serve`: eyeball the stub, the tab blocks and each chapter.
- **Touches:** hubs, `breadcrumbs.json`.

---

## How `docs-draft` drives this

1. `next_phase.py` prints the next actionable phase.
2. Pre-flight: clean tree, on `branch`, `.venv` present.
3. Execute every `[ ]` in the phase.
4. Run the phase's `verify:`; never advance on a checkbox alone.
5. Amend this file if reality diverges; STOP only on a `GOAL.md` contradiction.
6. Mark `done`, advance `current_phase`, `--touch`; one commit; stop and report.
