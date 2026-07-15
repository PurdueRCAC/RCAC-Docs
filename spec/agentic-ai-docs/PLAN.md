# PLAN — Agentic AI on RCAC: guidance, MCP tooling, and shared context

> **Status:** Draft for review · **Last updated:** 2026-07-15
> **Authoritative design.** The *how*. Vision/contract is [`GOAL.md`](GOAL.md); the phased
> executable roadmap is [`TECH.md`](TECH.md). Backing detail is in [`research/`](research/).
> Every design element traces to a GOAL R-ID.

## 1. Summary

Build a net-new top-level **Agentic AI** section (hub + guidance + MCP + a mode-organized
"Running Agents" area + a "Shared Context & Settings" subdir) plus a cross-linked **Using AI
Agents** chapter in the Gautschi user guide. As a shared exercise, we also *construct* the first
real Gautschi `/etc/agents.d` context files and per-harness settings, storing them as byte-exact
canonical files under `docs/snippets/agentic-ai/` and publishing them verbatim via `--8<--` fenced
includes (proven Jinja-safe). Ten publishable phases, scaffold → content → integration; HPC
accuracy, accessibility, and build integrity are `hammerable: false`.

## 2. Design

### Archetypes

Three archetypes are in play (see [`style-guide.md`](../../.agents/factory/style-guide.md)):

- **Reference / hub / landing** — `docs/agentic-ai/index.md` and the two subdir `index.md`s.
  Front-matter: `title` + `tags: [Agentic AI]` (mirror `docs/lifesciences/index.md`); grid-cards
  body. (Hubs may add `hide: [toc]` if they end up card-only.)
- **Cluster user-guide article** — the Gautschi `using_ai_agents.md` chapter. Front-matter:
  `tags: [Gautschi]`, `authors: […]`, and `{% set resource = "gautschi" %}` where it reuses
  cluster macros.
- **Policy page** (a lighter variant, mirrored from `docs/userguides/anvil/policies.md`) — the
  acceptable-use page: `tags` + `authors`, one H1, hand-written sections + `{{ resource_use(…) }}`.

A **novel publishing pattern** (not a new archetype, but new to this repo) carries the verbatim
context/settings artifacts — see *Reuse* below.

### Page structure (files to create)

**New content pages** under `docs/agentic-ai/`:

| File | H1 / purpose | R-IDs |
|------|--------------|-------|
| `index.md` | *Agentic AI at RCAC* — stance (proactive engagement, not prohibition; verify, don't forbid), grid-card nav to subpages | R1 |
| `acceptable_use.md` | *Acceptable Use & Etiquette* — rules for agents on RCAC systems; reuse `{{ resource_use(resource) }}`; link Purdue IT AUP | R2 |
| `best_practices.md` | *Best Practices & Limitations* — agent *for research* vs *for operations*; context engineering; verification ("augmented, not outsourced"); caution/blast-radius | R3 |
| `mcp_servers.md` | *RCAC MCP Servers* — why MCP; the three **actively-developed prototypes** with verified connect commands; `/etc/agents.d` injection; **call out the `rcac-mcp` rename/re-architecture** | R7, R8, R9, R16 |
| `running_agents/index.md` | *Running Agents* — the two deployment modes explained; card links | R4 |
| `running_agents/on_cluster.md` | *On the Cluster (Login Nodes)* — five harnesses on login nodes; login-node constraints; Warp = local-only note | R4, R5, R16 |
| `running_agents/local.md` | *Local, Targeting the Cluster (MCP + SSH)* — local-first architecture; connect each harness to the MCP servers; **feature Warp prominently (RCAC's recommended harness)** | R4, R6 |
| `shared_context/index.md` | *Shared Context & Settings* — how `/etc/agents.d` + settings fit; canonical source-of-truth → Puppet + MCP injection; **how to contribute feedback** | R12 |
| `shared_context/context_files.md` | *Context Files (`/etc/agents.d`)* — the five Gautschi context files, published verbatim | R10, R16 |
| `shared_context/settings.md` | *Harness Settings & Permissions* — the five per-harness settings, published verbatim; **deny destructive ops + allow-list read-only sanity commands** | R11 |

**New Gautschi chapter:** `docs/userguides/gautschi/using_ai_agents.md` (R13, R16).

**New canonical artifact files** (byte-exact source of truth; under `docs/snippets/agentic-ai/`,
excluded from nav by `exclude_docs: snippets/`, `--8<--`-included — never nav pages):

```
docs/snippets/agentic-ai/
  agents.d/unix.md          agents.d/filesystems.md   agents.d/lmod.md
  agents.d/slurm.md         agents.d/policies.md
  agents.d/AGENTS.md        # concatenated canonical context (the assembled file harnesses read)
  claude/settings.json      codex/config.toml         gemini/settings.json
  opencode/opencode.json    warp/AGENTS.md            # + warp profile-denylist note in prose
```

### Navigation placement (exact)

Insert a **top-level section after Life Sciences** (`mkdocs.yml:361`, before the commented Tags line):

```yaml
  - Agentic AI:
    - agentic-ai/index.md
    - Acceptable Use & Etiquette: agentic-ai/acceptable_use.md
    - Best Practices & Limitations: agentic-ai/best_practices.md
    - MCP Servers: agentic-ai/mcp_servers.md
    - Running Agents:
      - agentic-ai/running_agents/index.md
      - On the Cluster (Login Nodes): agentic-ai/running_agents/on_cluster.md
      - Local (MCP + SSH): agentic-ai/running_agents/local.md
    - Shared Context & Settings:
      - agentic-ai/shared_context/index.md
      - Context Files (/etc/agents.d): agentic-ai/shared_context/context_files.md
      - Harness Settings & Permissions: agentic-ai/shared_context/settings.md
```

Insert the Gautschi chapter **between Compiling Source Code (`mkdocs.yml:144`) and FAQs (`:145`)**:

```yaml
      - Using AI Agents: userguides/gautschi/using_ai_agents.md
```

**Nav is added incrementally, in lockstep with page creation** (a nav line pointing at a missing
file, or a page absent from nav, both fail `--strict`). Reading/nav order == phase order. Breadcrumbs
regenerate at the integration phase (`python tools/generate_breadcrumbs.py`).

### Reuse (macros, snippets, gold-standard pages)

- **Verbatim-publishing pattern** (research 02, proven): each artifact is a real file under
  `docs/snippets/agentic-ai/…`, embedded in a fenced block:
  ````markdown
  ```json title="~/.claude/settings.json"
  --8<-- "docs/snippets/agentic-ai/claude/settings.json"
  ```
  ````
  `--8<--` content is spliced **after** the Jinja pass, so literal `{{`/`{%` never breaks the build.
  Single source of truth, syntax-highlighted. Fence languages: `json` (Claude/Gemini/opencode),
  `toml` (Codex), `markdown` (agents.d/*, Warp AGENTS.md).
- **Macros for background prose** (call, don't hardcode): `{{ resource_use(resource) }}` (AUP block,
  acceptable-use page), `{{ module_system(resource) }}`, `{{ slurm_general_overview(resource) }}`,
  `{{ ssh_keys_snippet(resource) }}`, `{{ storage_quota(resource) }}`, `{{ scratch_purge(resource) }}`
  — chiefly on the Gautschi chapter and where HPC background is summarized. **Do not** source the
  *context files* from these macros (they emit generic RCAC text; the context files must be authored
  from verified Gautschi facts — research 03).
- **Gold-standard pages to mirror:** `docs/lifesciences/index.md` (hub + grid cards);
  `docs/userguides/anvil/policies.md` (policy page); `docs/lifesciences/guides/vscode.md`
  (external-tool → login → compute prior art, for the local mode).

### Assets

None required for a first cut (text + code blocks + admonitions + grid cards). If an architecture
diagram is added later for the local-first MCP+SSH flow, it goes under
`docs/assets/images/agentic-ai/` with an absolute path and descriptive alt text (deferred; not a
GOAL requirement).

### Cross-links & tags

- Tag new pages `Agentic AI`; the Gautschi chapter `Gautschi`.
- Hub grid-cards → each subpage; each subpage ends with a back-link to its hub.
- Cross-links: `running_agents/local.md` ↔ `mcp_servers.md`; `mcp_servers.md` ↔
  `shared_context/context_files.md` (the `/etc/agents.d` injection); `shared_context/settings.md` ↔
  `running_agents/*` (where to install each config); Gautschi chapter ↔ the top-level section.
  **Sibling cross-links are added in the integration phase** (P10) so every intermediate build is
  `--strict`-clean; each content phase only back-links to an already-existing hub.

### Accessibility plan (R15)

One `#` H1 per page; headings descend without skipping; grid-card links use descriptive text (not
"click here"); every table has a header row; no meaning by color alone; any future image gets
meaningful alt text. Code blocks carry a `title=` label. This is content-level a11y (owned on
`main`); no theme/CSS/`overrides` changes (invariants §2).

### Requirement → design map

| R-ID | Design element(s) that satisfy it |
|------|-----------------------------------|
| R1 | `docs/agentic-ai/index.md` hub + top-level `Agentic AI` nav section |
| R2 | `agentic-ai/acceptable_use.md` (policy archetype + `{{ resource_use }}` + Purdue AUP link) |
| R3 | `agentic-ai/best_practices.md` (research-vs-ops, context engineering, verification, caution) |
| R4 | `running_agents/{index,on_cluster,local}.md` organized by deployment mode, five harnesses each |
| R5 | `running_agents/on_cluster.md` login-node constraints (mirrors Gautschi Running Jobs) |
| R6 | `running_agents/local.md` local-first architecture (no new credentials/hosted infra) |
| R7 | `mcp_servers.md` — three servers, focus + repo links, "why MCP" |
| R8 | `mcp_servers.md` — HPC server reads `/etc/agents.d` over SSH, injects as context |
| R9 | `mcp_servers.md` — install/connect commands verified against the live repos (research 04) |
| R10 | `docs/snippets/agentic-ai/agents.d/*.md` (Gautschi-accurate; `/home` ZFS · `/depot` GPFS · `/scratch` Lustre; quotas via `myquota`) + `shared_context/context_files.md` |
| R11 | `docs/snippets/agentic-ai/{claude,codex,gemini,opencode,warp}/…` (deny destructive ops + **allow-list read-only sanity commands**) + `shared_context/settings.md` |
| R12 | `shared_context/index.md` — how it fits, source-of-truth → Puppet + MCP, feedback channels |
| R13 | `docs/userguides/gautschi/using_ai_agents.md` + Gautschi nav entry + cross-links |
| R14 | Every phase adds its nav line; every `verify:` runs `mkdocs build --strict` |
| R15 | a11y plan above; final sweep in P10 |
| R16 | context files/MCP commands/Gautschi facts authored from research 03/04; verified P4/P7/P9/P10 |

## 3. Invariant gate (constitution check)

Checked against [`invariants.md`](../../.agents/factory/invariants.md) before research and again
after this design. Touched sections and how the design honors each:

- **§1 branch/deploy** — all work on `feature/agentic-ai-docs`; squash PR to `main` at publish. No
  direct `main`/`dev` edits.
- **§2 dev-only a11y layer** — **untouched.** No edits to `docs/stylesheets/`, `overrides/`,
  `a11y.js`, or any force-preserved path. Content-level a11y only.
- **§3 generated-content firewall** — no hand-edits to catalogs or `breadcrumbs.json`; breadcrumbs
  are **regenerated** via `tools/generate_breadcrumbs.py` after the nav change. `docs/snippets/
  agentic-ai/*` are hand-authored source, not generated outputs.
- **§4 nav-is-manual** — every new page gets a `mkdocs.yml` `nav:` entry in the same phase; snippet
  files are correctly *not* in nav (excluded, `--8<--`-only).
- **§5 links relative / assets absolute** — page-to-page links relative; any asset absolute.
- **§6 front-matter per archetype** — hub (`title`+`tags`), policy page (`tags`+`authors`),
  userguide chapter (`tags`+`authors`+`{% set resource %}`).
- **§7 macros / Jinja escaping** — verbatim config is `--8<--`-included (post-Jinja, immune);
  background prose reuses macros. No literal `{{`/`{%` pasted into page source unescaped.
- **§8 build integrity** — each phase gates on `mkdocs build --strict | strict_check.py` (zero new
  warnings vs the 7-line baseline).
- **§9 content WCAG** — a11y plan above; finalized P10.
- **§10 per-cluster parallelism** — a Gautschi-only "Using AI Agents" chapter creates deliberate
  per-cluster asymmetry; **explicitly scoped** as a pilot in GOAL non-goals (other clusters follow).
  See deviation table.
- **§11 HPC accuracy** — context files/MCP/Gautschi facts authored strictly from verified research;
  the two known Gautschi doc-errors (`--partition=a10`, `-A standby`) are excluded by design;
  volatile numbers (quotas) are deferred to `myquota`/`slist` rather than hardcoded.
- **§12 commit/PR** — `[feature] …` subjects, no `Co-Authored-By`; squash PR; `Closes #NN` if an
  issue is filed.

### Deviation justifications

| Deviation | Why needed | Simpler alternative rejected because |
|-----------|-----------|--------------------------------------|
| Gautschi-only `Using AI Agents` chapter (per-cluster asymmetry, §10) | GOAL scopes this feature to Gautschi as the pilot; the cross-cluster home is the top-level section | Adding the chapter to all 8 clusters now blows the appetite and would duplicate not-yet-verified per-cluster facts; scoped as a follow-up in GOAL non-goals |
| New verbatim-config publishing pattern (`--8<--` fenced includes from `docs/snippets/agentic-ai/`) | R10/R11 require publishing real, byte-exact config as the single source of truth | Hand-pasting config into pages needs `{% raw %}` and duplicates content (drift); this pattern is proven `--strict`-safe (research 02) and stays within §7 (snippets are a sanctioned mechanism) |

## 4. Rabbit holes (resolved)

- **Will publishing verbatim config with literal `{{`/`{%` break the macros build?** → No.
  `--8<--` splices files *after* the Jinja pass; proven with an isolated `mkdocs build --strict`
  (exit 0) ([`research/02-macros-and-jinja.md`](research/02-macros-and-jinja.md)).
- **What are the *real* Gautschi partitions/QOS/paths/commands?** → Extracted with citations, plus
  an `[UNCONFIRMED]` list and two doc-errors to avoid
  ([`research/03-gautschi-facts.md`](research/03-gautschi-facts.md)).
- **Do the MCP servers exist, and what are the real connect commands/tools?** → Yes; all three
  public, `uvx`-installed, verified configs + tool lists
  ([`research/04-mcp-servers.md`](research/04-mcp-servers.md)).
- **What is each harness's settings/permissions/MCP/context-file contract?** → Full per-harness
  table, incl. system/managed enforcement points and Warp's GUI-only caveat
  ([`research/05-harness-configs.md`](research/05-harness-configs.md)).
- **What should the `/etc/agents.d` files contain, and how do they reach each harness?** → Per-file
  outlines + the concatenate-to-`AGENTS.md` mapping
  ([`research/06-context-and-conventions.md`](research/06-context-and-conventions.md)).
- **Where exactly does this live in the site?** → Top-level after Life Sciences + Gautschi chapter;
  exact nav lines ([`research/01-site-architecture.md`](research/01-site-architecture.md)).

## 5. Risks & open questions

- **`cluster-mcp` / HPC-only refocus is [UNVERIFIED] publicly** (research 04): the public
  `rcac-mcp` is a prototype that still bundles docs tools; the plugin architecture
  (`cluster-mcp[slurm,lmod,…]`) has no public trace. **Human confirmed the framing (2026-07-15):**
  treat all three servers as **actively-developed working prototypes** and **explicitly call out the
  planned rename/re-architecture of `rcac-mcp`** — as a stated direction, not shipped fact. No longer
  a blocker; keep the "planned/evolving" labeling.
- **Gautschi `[UNCONFIRMED]` facts** — exact home/scratch quotas (illustrative only), Depot mount
  path, OpenMPI version, default shell, availability of `sinfo`/`sacct`/`jobinfo`, a Purdue AUP
  direct URL. **Mitigation:** context files tell the agent to run `myquota`/`findscratch`/`slist`
  instead of hardcoding; state only verified facts; use the AUP block from `resource_use` / link
  Purdue IT Policy V.4.1 (from `resourceuse.md`). **Filesystem tech now confirmed** (human): `/home`
  ZFS · `/depot` GPFS · `/scratch` Lustre.
- **Warp is a local desktop GUI, not a headless CLI** — cannot be installed on a login node
  (research 05) — **but it is RCAC's *recommended* harness for most users** (human, 2026-07-15).
  **Mitigation:** give Warp **first-class, prominent** treatment in the **local (MCP + SSH)** guidance
  — tell the story of using it well ("run on your workstation, SSH in"); represent its "settings" as
  `AGENTS.md` + a documented Agent-Profile denylist, and note the Run-until-completion denylist bypass.
- **Enforced-permissions policy is a v0 starting point** (GOAL clarification) — label it as such and
  invite feedback. It must both **deny** destructive ops (`rm -rf`, `sudo`) **and allow-list common
  read-only sanity commands** (`myquota`, `slist`, `sfeatures`, `module list`, `module avail`, …) so
  agents run them eagerly without prompting (human, 2026-07-15). **Container model is Apptainer, not
  Docker:** RCAC's Apptainer config **auto bind-mounts `/home`, `/depot`, `/scratch`** → limited
  protection (editing files is the real risk; bind-mounts disable-able on explicit invocation) — the
  caution/best-practices content must reflect this, not imply Docker sandboxing. The real
  config-management enforcement points are Claude `/etc/claude-code/managed-settings.json` and Gemini
  `/etc/gemini-cli/settings.json`.
- **`check_paths:false`** — a mistyped `--8<--` path fails **silently** (empty block, no `--strict`
  error). **Mitigation:** each context/settings phase greps the built `site/` for a sentinel token.
- **Feedback channel** for context corrections — default to the RCAC-Docs GitHub issues +
  rcac-help@purdue.edu + Discord (from AGENTS.md contact); confirm at draft.

## 6. Verification strategy

Seeds each phase's `verify:` in `TECH.md`:

- **Build integrity:** `.venv/bin/mkdocs build --strict 2>&1 | python3 .agents/factory/bin/strict_check.py`
  (no new warnings vs `strict-baseline.txt`) — every phase.
- **Nav:** `grep` the phase's page path in `mkdocs.yml` (no "not in nav"/"missing file" warning).
- **Verbatim includes (P4/P7/P8):** `grep -rq <sentinel> site/agentic-ai/…` to defeat the
  `check_paths:false` silent-empty footgun (e.g. `RCAC_SCRATCH`, `mcpServers`).
- **Render:** `mkdocs serve` and eyeball layout (grid cards, tabs, admonitions, macro expansion,
  code blocks non-empty) — in the phase steps where layout matters.
- **Front-matter:** matches the archetype (hub `title`+`tags`; policy/userguide `tags`+`authors`).
- **Accessibility:** images (if any) have alt text; headings descend; tables have header rows;
  descriptive link text — final sweep P10.
- **HPC accuracy:** every factual claim checked against a gold-standard Gautschi page or
  `research/03`; MCP commands against `research/04`; **no `--partition=a10`, no `-A standby`**;
  volatile numbers deferred to runtime commands.

---

*Backing research: [`research/00-digest.md`](research/00-digest.md).*
