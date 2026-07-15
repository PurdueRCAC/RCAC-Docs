# REVIEW — Agentic AI on RCAC: guidance, MCP tooling, and shared context

> Adversarial QA by `docs-review`, run in an isolated/clean context. The correctness pass grades the
> branch diff against [`GOAL.md`](GOAL.md) + the invariants + the style guide **only** — it does not
> see `PLAN.md`/`TECH.md` (avoids grading-its-own-homework / plan-sycophancy). Every finding cites
> **evidence** — a build/render/link result or a direct read of the diff — not an assertion.

- **Reviewed commit:** d7465e42  ·  **Base:** main  ·  **Date:** 2026-07-15
- **Verdict:** approved
- **Cycle:** 1 of ≤3 (escalate to human on non-convergence)

## Verification run

Commands actually executed / pages actually rendered, and their outcomes (the spine of the review):

- `.venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py`
  → **PASS: no new --strict warnings (7 present, all in baseline of 7). EXIT_STATUS=0.** Independently
  re-run by the orchestrator with the identical result. `strict-baseline.txt` diff is a comment-only
  `python3`→`.venv/bin/python` edit — no warning entries added/removed; the gate was not weakened.
- `.venv/bin/mkdocs serve` + built-`site/` inspection of the new pages → snippet `--8<--` includes
  expanded verbatim (`grep "Rocky Linux 9" site/…/context_files/index.html` → 2 hits), macros
  rendered (no leaked raw `{{`/`{%`), admonitions/tables/code blocks intact, partition table has a
  header row.
- nav check: all **11** new pages present in `mkdocs.yml` `nav:` — 10 under `docs/agentic-ai/**`
  (`mkdocs.yml:363-375`) + `docs/userguides/gautschi/using_ai_agents.md` (`mkdocs.yml:145`); none
  orphaned; `--strict` raises no "not included in nav" warning.
- front-matter / a11y spot-check → hub/landing pages carry `hide:`; no content images (alt vacuously
  satisfied); no absolute `](/…)` page-to-page links; one H1 per page; headings descend without skips.

## Requirement → evidence matrix

Bidirectional traceability. Every R-ID R1–R16 has an implementing change and was verified by an
executed command or a direct render/diff read.

| R-ID | Implemented by (file) | Verified how | Status |
|------|------------------------|--------------|--------|
| R1 | `agentic-ai/index.md:11-15,34-81`; `mkdocs.yml:363-375` | render + nav grep; stance present, cards link every subpage | ✅ |
| R2 | `agentic-ai/acceptable_use.md:21-71` | render; login-node / Slurm `--time` / world-readable / destructive-confirm rules + Purdue IT-16 link (via `resource_use`) | ✅ |
| R3 | `agentic-ai/best_practices.md:17-107` | render; research-vs-ops, context-eng, augmented-not-outsourced, blast-radius | ✅ |
| R4 | `running_agents/index.md:9-25`; `on_cluster.md`; `local.md` | render; two modes, all five harnesses in each | ✅ |
| R5 | `running_agents/on_cluster.md:23-35` | diff vs gold-standard `run_jobs/queues.md` login-node guidance | ✅ |
| R6 | `running_agents/local.md:25-37` | render; own-env / existing-SSH / no-new-creds / no-hosted-infra | ✅ |
| R7 | `mcp_servers.md:10-19,21-26,38/113/147,100-109` | render; 3 repos, why-MCP, prototype admonition, `cluster-mcp[…]` rename call-out | ✅ |
| R8 | `mcp_servers.md:89-98` | render; `/etc/agents.d`, "configurable location", injected over SSH | ✅ |
| R9 | `mcp_servers.md:80-86,140-143,154-158` + `uvx` blocks | **PLAUSIBLE** — private repos unreachable at review time; nothing looks fabricated (see F1) | ⚠️ |
| R10 | `snippets/agentic-ai/agents.d/{unix,filesystems,lmod,slurm,policies}.md` | render verbatim; HPC facts cross-checked vs gold-standard; filesystem-tech labels PLAUSIBLE (F2) | ✅ (tech labels ⚠️) |
| R11 | `snippets/agentic-ai/{claude,codex,gemini,opencode}/*` + Warp inline in `settings.md` | read; deny `rm -rf`/`sudo`, allow-list `myquota`/`slist`/`sfeatures`/`module list`/`avail`; Codex caveat (F3) | ✅ |
| R12 | `shared_context/index.md:9-52` | render; injected/enforced, canonical SoT copied to `/etc/agents.d`, feedback path | ✅ |
| R13 | `userguides/gautschi/using_ai_agents.md`; `mkdocs.yml:145` | render + nav; cross-linked up/down with the section | ✅ |
| R14 | `mkdocs.yml`; strict gate | **CONFIRMED** — 11/11 in nav, gate exit 0, no new warnings | ✅ |
| R15 | all new pages | render; relative links / absolute assets / heading descent / table headers | ✅ |
| R16 | new pages + context files | partitions/QOS/host/modules CONFIRMED vs gold-standard; tech-labels + MCP tool-names PLAUSIBLE tail | ✅ (tail ⚠️) |

**Key refinements (part of the contract):** all verified SATISFIED — "mostly harmless"/"cross the
streams"/"kung fu" = 0 hits; "Tea, Earl Grey, hot" = exactly 1 (`best_practices.md:39`); PEARC'26
paper is a footer note (`index.md:89-91`), not the lead; Warp documented as riding a live user SSH
session, **not** the `rcac-mcp` bridge (`local.md:103-110`); CLI harnesses use the `rcac-mcp` SSH
bridge for local mode; settings framed as RCAC-deployed/enforced with correct managed paths (Codex
honestly has none; Warp is an inline Agent Profile); cluster-side settings register only the hosted
docs MCP (`docs.rcac.purdue.edu/mcp`), never `rcac-mcp`; Apptainer-not-Docker with auto-bind-mount
limited-protection caveat present.

Unmapped changes (possible scope creep): the `.agents/**` + `AGENTS.md` `[harness]` commits — see
**Completeness sub-pass** and **Human-gate triggers** below. No `docs/**` content scope-creep; no
non-goal leakage (Gautschi-only; no theme/CSS/JS; no catalog hand-edits; `breadcrumbs.json`
regenerated as expected; no blog post; no MCP-server code).

## Findings

No **CONFIRMED** defects. All items below are **PLAUSIBLE** (human triage) or minor notes — none
auto-loops to `docs-draft`.

### [LOW/PLAUSIBLE] F1 — MCP tool names & install commands not verifiable against live repos
- **Where:** `docs/agentic-ai/mcp_servers.md:80-86` (rcac-mcp tools), `140-143` (globus-mcp tools),
  `154-158` (`doc_search`/`doc_load`), and the `uvx git+https://…` / `--ssh-host` / `RCAC_SSH_HOST`
  blocks.
- **Concern:** the review sandbox cannot reach `github.com/PurdueRCAC/{rcac-mcp,globus-mcp,rcac-docs-mcp}`.
  Nothing looks fabricated and the commands are internally consistent, but R9 requires verification
  against the live repos. Minor org-case cosmetics: prose links use `PurdueRCAC/…`, `uvx` args use
  `purduercac/…` (GitHub redirects both — not a defect).
- **Authoritative source to check:** the three public repos (a maintainer with access confirms the
  tool lists and the `--ssh-host`/`RCAC_SSH_HOST` flags match the shipped servers).

### [LOW/PLAUSIBLE] F2 — filesystem *technology* labels not on the gold-standard Gautschi storage page
- **Where:** `docs/snippets/agentic-ai/agents.d/filesystems.md` — asserts `/home`=ZFS, `/scratch`=Lustre,
  `/depot`=GPFS.
- **Concern:** `docs/userguides/gautschi/storage.md` does not state these technologies; corroborated
  only indirectly (`docs/snippets/home_directory.md` mentions ZFS; Anvil pages mention GPFS/Lustre).
- **Note (mitigates):** these exact labels are the **human-corrected authoritative facts recorded in
  `GOAL.md`** ("Filesystem technologies (authoritative, human-corrected): `/home` is ZFS, `/depot` is
  GPFS, `/scratch` is Lustre") — i.e. already confirmed by the human during shaping. Residual risk is
  low; a confirming nod at publish is sufficient.

### [LOW] F3 — Codex permission encoding is coarser than the other harnesses (honest, defensible)
- **Where:** `docs/snippets/agentic-ai/codex/config.toml`.
- **Note:** Codex has no per-command allow/deny list, so the file relies on `approval_policy` /
  `sandbox_mode` and states this honestly — inventing allow/deny syntax would violate R9. "Deny
  login-node heavy compute" is carried by the context files, not the permission JSON. Defensible;
  recorded for transparency, not a defect.

## Human-gate triggers

No CONFIRMED finding touches a high-impact file, so no **mandatory** human sign-off gate is triggered
by a *defect*. Two advisory triggers apply:

1. **Advisory (rubric §"Mandatory human sign-off gate"):** two **PLAUSIBLE HPC/accuracy** items
   (F1 MCP tool-names/commands; F2 filesystem-tech labels) remain on what will be a **new,
   high-traffic section that auto-deploys to production within ~5 minutes with no staging gate**. A
   brief human eyeball of those two specifics before `docs-publish` is advisable. Nothing blocks.
2. **Publish-time scope decision (from the completeness sub-pass):** nine `[harness]` commits touch
   the high-impact-adjacent factory tooling (`.agents/**`) and `AGENTS.md`. They do **not** touch the
   published site, but a squash-merge would fold them into a single content-titled commit on `main`.
   This is a human decision at `/docs-publish` (split into a separate PR / use a merge commit /
   accept the fold) — see below.

## Optional completeness sub-pass (separate reviewer; saw `TECH.md`)

- **All 10 content phases (P1–P10) shipped**; each phase marked `done` has its deliverable present in
  the diff (no done-but-absent red flags). Every R-ID R1–R16 maps to ≥1 shipped phase.
- **One planned file deliberately trimmed:** `docs/snippets/agentic-ai/warp/AGENTS.md` was dropped
  during the human-review pass because Warp has no settings file; R11's "all five harnesses" is
  satisfied for Warp inline (documented, justified trim — commit `66642d3f`, not a silent drop).
- **Scope-creep — `.agents/**` + `AGENTS.md` (`~1k lines / 24 files`, 9 `[harness]` commits):**
  legitimate self-improvement-loop harness work (added `docs-harness`, `META.md`/`meta_status.py`/
  `harness-log.md`, standardized on `.venv`, hardened the build gate on ERRORs), correctly
  `[harness]`-categorized — but **outside this feature's content appetite** and co-developed on the
  content branch. **Squash-PR implication:** `docs-publish` squashes to `main`, collapsing all 26
  commits into one content-titled commit and losing the `[harness]` categorization / mixing tooling
  with published content. Recommend a human decision at publish: split the harness work into its own
  PR (merged first), or use a non-squash merge — but AGENTS.md mandates a squash PR, so this needs a
  human call.
- **Non-goal leakage:** none on the content side.
- **Completeness verdict:** content **COMPLETE**; overall **SCOPE-CONCERN** due to the bundled
  harness commits.
