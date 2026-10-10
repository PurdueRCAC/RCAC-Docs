# REVIEW — `/etc/agents.d` context for every cluster; retire per-harness settings

> Adversarial QA by `docs-review`, run in a clean context. The correctness pass graded the branch
> diff against [`GOAL.md`](GOAL.md), the invariants and the style guide only; it did not see
> `PLAN.md`, `TECH.md` or `research/`.

- **Reviewed commit:** 43bd6b2af46d45711eab5113763c62435eb64166  ·  **Base:** main  ·  **Date:** 2026-10-09
- **Verdict:** approved (no CONFIRMED findings; seven PLAUSIBLE/low items, all addressed after review)
- **Cycle:** 1 of ≤3

## Verification run

- `.venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py` → PASS, 0 warnings.
- Generator run in an empty scratch copy; `diff -r` against `docs/snippets/agentic-ai` → identical
  except the hand-maintained `GENERATED.md`. Breadcrumbs regenerate identically.
- Built pages: each `site/userguides/<c>/using_ai_agents/index.html` embeds only its own
  `clusters/<c>.yml`; no Bell chapter; the settings stub URL resolves; anchors to
  `#load-the-context-in-your-harness` resolve.
- Every backticked token in each cluster's `AGENTS.md` grepped against that cluster's built guide;
  absences are prohibitions, generic Lmod/Slurm syntax, or facts from the GOAL Amendment.
- Vendor docs fetched for the opt-in steps (Claude Code memory imports, Codex global
  `AGENTS.md`, Gemini CLI `context.fileName`, opencode `instructions`, Warp Global Rules).
- Public-repo sweep of changed files and commit messages for configuration-management or
  deployment terms → no hits.

## Requirement → evidence matrix

| R-ID | Implemented by | Verified how | Status |
|------|----------------|--------------|--------|
| R1 | `clusters/{anvil,scholar}.yml`, generated `agents.d/` | facts vs. cluster guides and Amendment | ✅ |
| R2 | generator `DEFAULTS`, template switches, cluster overrides | greps; Anvil/Scholar read-through | ✅ |
| R3 | five chapters, nav, guide `index.md` entries | built-HTML sentinels | ✅ |
| R4 | settings outputs removed; page rewrites | greps over `docs/` and `site/` | ✅ |
| R5 | `shared_context/settings.md` stub | render; link check | ✅ |
| R6 | `shared_context/index.md` opt-in tabs; `rcac://context` wording | vendor docs; rcac-mcp source | ✅ |
| R7 | generator emits `agents.d/` only | scratch regeneration diff | ✅ |
| R8 | prose rewrites across the section | read-through | ✅ |
| R9 | — | strict gate | ✅ |

Unmapped changes (possible scope creep): none.

## Findings

All PLAUSIBLE, LOW. Each was fixed after the review in one commit
(`[fix] Address agents-d-all-clusters review findings`).

### [LOW/PLAUSIBLE] Claude Code opt-in can glue onto a last line without a newline
- **Where:** `docs/agentic-ai/shared_context/index.md` (Claude Code tab)
- **Fix:** `printf '\n@/etc/agents.d/AGENTS.md\n' >> ~/.claude/CLAUDE.md`.

### [LOW/PLAUSIBLE] Gemini CLI rationale stated more broadly than the vendor docs
- **Where:** `shared_context/index.md` (Gemini CLI tab)
- **Fix:** narrowed to "`@` imports in `~/.gemini/GEMINI.md` do not reach `/etc`" (source-verified
  during planning); the instruction itself was already correct.

### [LOW/PLAUSIBLE] "Each harness skips a missing file" not supported by vendor docs
- **Where:** `shared_context/index.md`
- **Fix:** sentence removed.

### [LOW/PLAUSIBLE] Anvil `~/.bashrc` prohibition has no source in the Anvil guide
- **Where:** `tools/agent_context/clusters/anvil.yml` (notes.lmod)
- **Fix:** removed (R1).

### [LOW/PLAUSIBLE] Anvil AI-node SU charging not stated in the guide
- **Where:** `anvil.yml` (notes.slurm)
- **Fix:** limited to CPU and GPU nodes.

### [LOW/PLAUSIBLE] "quota and balance commands" overstated for Scholar
- **Where:** `shared_context/context_files.md`
- **Fix:** "quota and account commands".

### [LOW/PLAUSIBLE] Two slogan-like lines in Best Practices
- **Where:** `best_practices.md`
- **Fix:** "Ask why, not just what" → "Ask for the reasoning"; the "new kinds of risk" framing
  shortened to "Agents make ordinary mistakes happen faster."

Observation, out of scope: `rcac-mcp`'s `rcac://context` returns the topic files and the assembled
`AGENTS.md`, so a reader gets each rule twice. The docs describe the resource accurately.

## Human-gate triggers

- High-impact paths are touched (`mkdocs.yml`, `docs/snippets/**`, `tools/**`), but no CONFIRMED
  finding, so the mandatory gate does not trigger. The opt-in instructions users will copy were
  the reviewer's suggested human look before publishing.
