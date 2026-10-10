# PLAN — `/etc/agents.d` context for every cluster; retire per-harness settings

> **Status:** Draft for review · **Last updated:** 2026-10-09
> **Authoritative design.** The *how*. Vision/contract is [`GOAL.md`](GOAL.md); the phased
> executable roadmap is [`TECH.md`](TECH.md). Backing detail is in [`research/`](research/).
> Every design element traces to a GOAL R-ID.

## 1. Summary

Four moves, in order. Retire the per-harness settings from the pages first, so nothing includes
a file that is about to disappear. Then cut the settings outputs from the generator and make
its templates data-driven, so a cluster can name its own commands or switch a line off.
Add Anvil and Scholar as data models with their own user-guide chapters. Last, rewrite how the
context reaches an agent (user opt-in, `rcac-mcp` on demand) and run a plain-language pass
over the section. Seven phases, each a publishable unit that builds clean.

## 2. Design

### 2.1 Generator and templates (R1, R2, R7)

- **Archetype:** none; `tools/` code and generated snippets (generated-content firewall:
  edit the YAML and templates, regenerate, never hand-edit the output).
- **Remove settings outputs.** Delete `CONFIG_TEMPLATES`, `_toml_marker` and the config render
  loop in `tools/generate_agent_context.py`; fix its docstring. `git rm` the four template
  dirs (`templates/{claude,codex,gemini,opencode}/`) and the twelve generated files under
  `docs/snippets/agentic-ai/<cluster>/{claude,codex,gemini,opencode}/` in the same commit.
  Update `GENERATED.md` (drop the settings and TOML/JSON marker text; add "list the chapter in
  the cluster `index.md`" and "regenerate breadcrumbs" to the add-a-cluster steps).
- **Defaults, deep-merged under each cluster YAML.** A `DEFAULTS` dict in the generator holds
  today's literals; a cluster YAML overrides any leaf, and `null` switches a line off:

  ```yaml
  commands:
    quota: myquota
    accounts: slist
    accounts_desc: "the accounts you can charge and their balances"
    features: sfeatures
    findscratch: findscratch
    interactive: sinteractive
  env:
    scratch: RCAC_SCRATCH
  scheduler:
    require_qos: true        # false: the "four things" line names account + partition only
  charging: true             # false: drop allocation/balance wording (Scholar)
  support:
    contact: "**rcac-help@purdue.edu**"
    aup: "Purdue IT's Acceptable Use Policy and RCAC's resource policies"
  containers:
    runtime: Apptainer
    mounts: null             # null: today's depot-derived list
  notes: {unix: [], filesystems: [], lmod: [], slurm: [], policies: []}
  ```

  Also optional: `filesystems.project` (`{path, env, text}`) rendered after scratch (Anvil
  `$PROJECT`), `filesystems.scratch.purge_text` (overrides the purge sentence), `os: null`
  (renders "Check `/etc/os-release`"), and `qos` items as either a known string or a mapping
  `{name, text}` rendered generically.
- **Template rules that keep the existing three byte-identical.** `trim_blocks` and
  `lstrip_blocks` are on, so `{% if %}`/`{% endif %}` on their own lines emit nothing; wrap
  whole bullet lines only. Inline `{{ commands.accounts }}` renders the same literal.
  `scheduler.standby_max_hours` is read only inside the `standby` branch. The `-A standby`
  prohibition is wrapped in `{% if 'standby' in qos %}`.
- **`purgelist`** is removed from `filesystems.md.j2` (GOAL amendment). This is the one
  intended diff to the Gautschi, Gilbreth and Negishi output in this phase.
- **`notes.<topic>`** lists render as extra bullets at the end of each topic's prohibitions or
  guidance section, so cluster facts that are not Slurm (Anvil usernames, Scholar's
  separate home) have a home. `anti_patterns` keeps rendering in `slurm.md` as today.

### 2.2 Cluster data models (R1, R2)

- **`anvil.yml`** from [`research/01`](research/01-anvil-facts.md) and the GOAL amendment:
  login `anvil.rcac.purdue.edu`; Rocky Linux 8.10 (`architecture.md`; the overview's "CentOS 8"
  is a docs defect); `commands.accounts: mybalance`, `findscratch: null`;
  `env.scratch: SCRATCH`; scratch `/anvil/scratch`, GPFS, 30 days, purge text "purged after 30
  days, with no grace period and no warning"; `filesystems.project` = `$PROJECT` (`$WORK`) under
  `/anvil/projects`; `depot: false`, `fortress: false` plus a filesystems note that Fortress is
  reachable only by SFTP or Globus; `qos: []`, `scheduler.require_qos: false`; partitions
  `debug`, `gpu-debug`, `wholenode`, `wide`, `shared`, `highmem`, `gpu`, `ai` (the
  unlisted `standard`/`benchmarking`/`profiling`/`azure` stay out); toolchain GCC 11.2.0 +
  OpenMPI; lmod note on `modtree/gpu`; containers `runtime: Apptainer` (note: `singularity`
  still works), `mounts: [/anvil, /home, /tmp]`; support "the ACCESS Help Desk
  (<https://support.access-ci.org/help-ticket>)"; AUP line naming Purdue's policy and ACCESS
  allocation policies; anti-patterns from `01` (no standby/partner/owner queue; mandatory
  `-A`/`-p`; node-exclusive partitions; `highmem` cost; GPU/AI credits; `--mem-per-cpu`;
  no Depot or `hsi`/`htar`; `$HOME` 25 GB; `mykeys`).
- **`scholar.yml`** from [`research/03`](research/03-scholar-facts.md): login
  `scholar.rcac.purdue.edu`; `os: null`; scratch `/scratch/scholar`, 60 days, tech null;
  GPFS home with the standard snapshot text; Depot and Fortress true; toolchain null;
  `qos`: `normal` (default, 4 h), `long` (3 days), `debug` (30 min, one job, 2 nodes) as
  mappings; `charging: false`, `commands.accounts_desc: "the accounts you can submit to"`;
  partitions `cpu`, `gpu`, `spark-batch`, `spark-interactive`; anti-patterns from `03`;
  a filesystems note that Scholar's home is separate from other RCAC clusters'. `/class` and
  `/apps` are not mentioned (undocumented).
- Existing three YAMLs are untouched.

### 2.3 Pages

| Page | Change | R |
|---|---|---|
| `docs/agentic-ai/shared_context/settings.md` | Replace with a stub: title "Harness Settings (Retired)"; two short paragraphs: RCAC published and planned to enforce per-harness settings, and after review and testing no longer does, because a harness's own permission controls stay in the user's hands; RCAC ships context only. Links: Best Practices, the four harnesses' permission docs, Shared Context. Stays in nav, relabelled. | R4, R5 |
| `docs/agentic-ai/mcp_servers.md` | Add a four-tab block (Claude Code `.mcp.json`, Codex `config.toml`, Gemini CLI `settings.json`, opencode `opencode.json`) registering `https://docs.rcac.purdue.edu/mcp`, moved from the settings templates. Correct the `rcac://context` text: on-demand resource the agent or user reads, fixed path. | R4, R6 |
| `docs/agentic-ai/shared_context/index.md` | Retitle "Shared Context". Sections: what `/etc/agents.d` is; where it is (RCAC places the files on each cluster's login and compute nodes); **Load it in your harness** (one-time, per cluster, tabs for Claude Code, Codex, Gemini CLI, opencode, Warp, with caveats from `05` A.1–A.5); local agents (`rcac://context`); source of truth; feedback. Remove the deployment-tooling name and the symlink claim. | R4, R6, R8 |
| `docs/agentic-ai/shared_context/context_files.md` | Fix the "injected by `rcac-mcp`" and "symlinked" sentences; list all five clusters' chapters. | R6, R8 |
| `docs/agentic-ai/index.md`, `acceptable_use.md`, `best_practices.md`, `running_agents/{index,on_cluster,local}.md` | Replace every sentence that says RCAC's settings deny or allow anything with advice to configure the harness's own approval mode; point context wiring at Shared Context → Load it in your harness. | R4, R6 |
| `docs/userguides/{gautschi,gilbreth,negishi}/using_ai_agents.md` | Delete the `managed-settings.json` paragraph and include; fix the delivery paragraph; plain-language pass. | R3, R4, R6, R8 |
| `docs/userguides/{anvil,scholar}/using_ai_agents.md` (new) | Same shape as the Gautschi chapter after its edits; `resource:` front matter; includes its own `AGENTS.md`. Anvil: notes ACCESS support. | R1, R3 |
| `mkdocs.yml` | Add the two chapters before FAQs (after `anvil-software.md`, after Scholar `compile.md`); rename "Shared Context & Settings" → "Shared Context" and the settings entry → "Harness Settings (Retired)". | R3, R5 |
| `docs/userguides/{anvil,scholar}/index.md` | Add `- [**Using AI Agents**](using_ai_agents.md)` before FAQs. | R3 |
| `docs/assets/data/breadcrumbs.json` | Regenerate. | — |

- **Front matter:** user-guide chapters follow the existing three (`tags: [<Cluster>]`,
  `authors: [glentner]`, `resource: <Cluster>`, `search: {boost: 2}`); section pages keep
  `tags: [Agentic AI]`, `authors: [glentner]`.
- **Accessibility:** tab labels name the harness; code blocks carry a `title` naming the file;
  no new images; headings descend one level at a time.
- **Prose (R8):** apply the rewrites in [`research/05`](research/05-optin-mcp-prose.md) C.1
  that fall on lines this job keeps; bold only for a term being defined or a warning keyword.

### Requirement → design map

| R-ID | Design element(s) |
|------|-------------------|
| R1 | §2.2 `anvil.yml`, `scholar.yml`; regenerated `docs/snippets/agentic-ai/{anvil,scholar}/agents.d/` |
| R2 | §2.1 defaults + null switches; §2.2 cluster overrides; built-site greps in verify |
| R3 | new chapters, nav entries, guide `index.md` entries; per-cluster sentinel greps |
| R4 | settings outputs removed (§2.1); §2.3 page rows; `managed-settings` absent from `site/` |
| R5 | `settings.md` stub at its existing URL |
| R6 | `shared_context/index.md` Load-it section; `mcp_servers.md` and `local.md` `rcac://context` wording |
| R7 | §2.1; verify: regenerate, then `git status --porcelain docs/snippets/agentic-ai` is empty |
| R8 | §2.3 prose row, applied in every phase that touches a page; final sweep in P7 |
| R9 | `strict_check.py` gate in every phase |

## 3. Invariant gate (constitution check)

Checked before research and again after this design.

- **Branch & deploy** — work on `feature/agents-d-all-clusters` off `main`; PR only.
- **Dev-only a11y layer** — no file in the preserved list is touched.
- **Generated-content firewall** — snippets and `breadcrumbs.json` are regenerated, never edited.
- **Nav is manual** — both new chapters added to `nav:`; stub kept in nav.
- **Links relative, assets absolute** — relative page links only; no assets.
- **Front matter per archetype** — §2.3.
- **Macros/Jinja** — chapters use `{{ resource }}` as today; JSON/TOML samples carry no `{{`.
- **Build integrity** — strict gate each phase; include sentinels guard the silent-empty case.
- **WCAG** — §2.3 accessibility line.
- **Per-cluster parallelism** — five chapters share one shape and the before-FAQs slot.
- **HPC accuracy** — every new fact cites the cluster guide or the dated GOAL amendment.
- **Public repository** — artifacts, pages and commit text name no internal configuration or
  deployment detail; they say only where the files are and what users do.

### Deviation justifications

| Deviation | Why needed | Simpler alternative rejected because |
|-----------|-----------|--------------------------------------|
| Generator gains a defaults deep-merge | Anvil and Scholar need different commands and QOS text | Copying templates per cluster forks the shared prose |

## 4. Rabbit holes (resolved)

- Does each harness have a user-level way to load an absolute path? → Yes, with a symlink for
  Codex and Gemini ([`05`](research/05-optin-mcp-prose.md) A).
- Does `rcac-mcp` inject the context? → No; it offers `rcac://context` ([`05`](research/05-optin-mcp-prose.md) B).
- Will template edits disturb the published three? → Not with whole-line block tags and
  defaults equal to today's literals ([`04`](research/04-generator-and-pages.md) §1.5).
- Anvil's open facts → confirmed by RCAC staff (GOAL amendment).

## 5. Risks & open questions

- Harness hookups drift with vendor releases; the Load-it section names the version checked
  and links each vendor page.
- Gemini CLI's setting must keep `GEMINI.md` first or its memory tool writes into the read-only
  symlink; the tab says so.
- `rcac-mcp` returns duplicated rules; a docs sentence should not paper over it, so the page
  describes the resource neutrally and the fix belongs to `rcac-mcp`.
- Scholar's x86 OS is not documented; the context tells the agent to check `/etc/os-release`.

## 6. Verification strategy

- **Build:** `.venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py`.
- **R7:** `.venv/bin/python tools/generate_agent_context.py && git status --porcelain docs/snippets/agentic-ai` prints nothing.
- **Byte identity:** P2 diffs the existing three clusters' `agents.d/` and allows only the `purgelist` lines.
- **Sentinels:** `grep -q 'anvil.yml' site/userguides/anvil/using_ai_agents/index.html` (and scholar,
  gautschi, gilbreth, negishi).
- **R4:** `! grep -rlq 'managed-settings' site/` and no `claude/settings.json` include under `docs/`.
- **R2 spot checks:** no line outside a "Do NOT" prohibition mentions a missing command or QOS:
  `! grep -h 'slist\|findscratch\|RCAC_SCRATCH\|hsi\|htar\|standby' docs/snippets/agentic-ai/anvil/agents.d/*.md | grep -v 'Do NOT' | grep -q .`;
  the same with `standby\|preemptible` for Scholar.
- **Render:** `mkdocs serve`; check the tab blocks, the stub, and each chapter's collapsed `AGENTS.md`.

---

*Backing research: [`research/00-digest.md`](research/00-digest.md).*
