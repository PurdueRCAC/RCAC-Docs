# Research digest — agentic-ai-docs

Synthesis of the six research briefs in this directory. Cited detail lives in each brief; this is
the decision-ready summary that `PLAN.md`/`TECH.md` build on.

- [`01-site-architecture.md`](01-site-architecture.md) — IA, nav insertion, hub archetype, breadcrumbs.
- [`02-macros-and-jinja.md`](02-macros-and-jinja.md) — the verbatim-publishing pattern (the #1 risk), macros to reuse, policy archetype.
- [`03-gautschi-facts.md`](03-gautschi-facts.md) — citable Gautschi facts + `[UNCONFIRMED]` list + two doc-errors to avoid.
- [`04-mcp-servers.md`](04-mcp-servers.md) — the three public MCP servers, verified connect commands, tool lists.
- [`05-harness-configs.md`](05-harness-configs.md) — per-harness config/permission/MCP/context-file reference.
- [`06-context-and-conventions.md`](06-context-and-conventions.md) — `/etc/agents.d` content design, context→harness mapping, peer prior art.

## 1. Information architecture (settled)

- New **top-level `Agentic AI`** nav section, inserted **after Life Sciences** (`mkdocs.yml:361`),
  before the commented Tags line. Life Sciences is the exact structural precedent (a domain hub
  with its own `index.md`). Contact/FAQs stay last.
- New **Gautschi chapter** `Using AI Agents`, inserted **between Compiling Source Code
  (`mkdocs.yml:144`) and FAQs (`:145`)** so FAQs stays last per cluster convention.
- Hub archetype = `docs/lifesciences/index.md`: `title`+`tags` front-matter, `<div class="grid
  cards" markdown>` blocks, `## :material-…:` headers. A section subdir needs a bare `index.md`
  first child (`navigation.indexes` enabled, `mkdocs.yml:18`).
- Breadcrumbs regenerate from nav (`python tools/generate_breadcrumbs.py`; CI also runs on
  `mkdocs.yml` change). Only 7 pre-existing `--strict` warnings in `strict-baseline.txt`, none in
  our files → the bar is **zero new warnings**.
- **No existing agentic-AI docs** — net-new. Closest analogs: `docs/userguides/anvil/anvilgpt.md`
  (a hosted chatbot, not a coding agent) and `docs/lifesciences/guides/vscode.md` (external
  tool → login → compute via ProxyJump; useful structural precedent for the local mode).

## 2. The verbatim-config pattern (the #1 technical risk — SOLVED)

The `mkdocs-macros` plugin evaluates Jinja on every page's own source **before** Markdown parsing;
`pymdownx.snippets` (`--8<--`) splices files in **during** parsing, **after** Jinja. **Therefore
`--8<--`-included content is never Jinja-evaluated** — literal `{{`/`{%` passes through untouched
(proven empirically, `mkdocs build --strict` exit 0).

**Pattern:** keep each context/settings artifact as a real byte-exact file under
`docs/snippets/agentic-ai/…` (excluded from nav by `exclude_docs: snippets/`, still `--8<--`-includable
and present in the prod build) and embed it in a fenced code block:

````markdown
```json title="~/.claude/settings.json"
--8<-- "docs/snippets/agentic-ai/claude/settings.json"
```
````

Single source of truth, syntax-highlighted, zero escaping, page keeps `{{ macro() }}` access.
**Footgun:** `check_paths:false` — a mistyped include path yields a silent **empty** block (no
`--strict` error). Mitigate by grepping the built `site/` for a sentinel token in each phase's
`verify:` and eyeballing the render.

**Macros to reuse** (call, don't hardcode; `{% set resource = "gautschi" %}` then `{{ macro(resource) }}`):
`resource_use` (Purdue AUP block), `module_system`, `slurm_general_overview`, `slurm_general_jobs`,
`ssh_keys_snippet`, `storage_quota`, `scratch_space`, `scratch_purge`, `environment_variables`,
`accounts_md_snippet`. **Caveat:** Gautschi's own pages do *not* invoke `module_system`/
`slurm_general_jobs` (they emit generic RCAC text) — fine for background prose, but the **context
files must be authored from the verified Gautschi facts (§4), not from these generic macros.**

**Policy archetype** = `docs/userguides/anvil/policies.md` (Gautschi has none): `tags`+`authors`
front-matter, one H1, `{% set resource %}`, hand-written sections + `{{ resource_use(resource) }}` /
`{{ scratch_purge(resource) }}`.

## 3. MCP servers (verified against the public repos)

All three are public, MIT, Python/FastMCP, installed for the desktop path via `uvx git+https://…`.

- **`rcac-mcp`** (PurdueRCAC/rcac-mcp, **prototype**) — HPC cluster+storage tools. Local **stdio**
  subprocess; runs commands on the cluster over the user's **existing SSH** (`~/.ssh/config`), no
  new credential. Verified config:
  ```json
  {"mcpServers":{"rcac":{"command":"uvx","args":["git+https://github.com/purduercac/rcac-mcp","--ssh-host","cluster.rcac.purdue.edu"]}}}
  ```
  Tools: `run_command`, `list_directory`, `read_file`/`write_file`, `upload_file`/`download_file`,
  `myquota`, `storage_paths`, `jobinfo`/`jobcmd`/`jobenv`/`jobscript`, `showpartitions`,
  `average_wait`, `sbatch`/`squeue`/`scancel`/`sacct`/`sinfo`, `scontrol_show_job`/`_node`, `slist`,
  `sfeatures`, `doc_search`, `doc_load`. **Confirmed:** reads `/etc/agents.d/*.md` over SSH and
  exposes it as resource `rcac://context`. Optional hosted HTTP with JWT/OIDC delegation.
- **`globus-mcp`** (**BETA**, banner-warned) — wraps Globus CLI + Compute SDK; user's own Globus
  OAuth (browser login). stdio via `uvx git+…`. Tools: `whoami`, `endpoint_search/show`, `ls/stat/
  mkdir/rename/rm/delete`, `transfer/transfer_batch`, `task_*`, `compute_*`.
- **`rcac-docs-mcp`** — hosted **no-auth HTTP at `docs.rcac.purdue.edu/mcp`** (add as a remote HTTP
  MCP server; exact client JSON `[UNVERIFIED]`), or local stdio via `uvx git+…`. Two tools:
  `doc_search(query, category=None)`, `doc_load(path)` over an FTS5/BM25 index.

**⚠ [UNVERIFIED]:** the "HPC-only refocus / `cluster-mcp[slurm,lmod,…]` plugin architecture" (from
GOAL R7) has **zero public mentions** — the public `rcac-mcp` still bundles docs tools. **Docs must
present `rcac-mcp` as the current prototype and frame the plugin direction as planned/evolving,
clearly labeled — not as shipped fact. Confirm with the human before publish.** Also noted: private
`agentbase` (internal-KB agentic search) — out of scope.

## 4. Gautschi facts (safety-critical — see brief 03 for citations)

- **System:** Rocky Linux 9; login `gautschi.rcac.purdue.edu`; 8 front-ends (192-core EPYC 9654,
  768 GB); auth = SSH keys or Purdue Login MFA (**not** "BoilerKey" — that term is absent).
- **Slurm:** every job needs 4 parts and must pass **both `-A/--account=` and `-p/--partition=`**
  (+ optional `-q/--qos=`). Partitions: `cpu` (192c, ~2 GB/core, normal+standby, 2wk/4h),
  `ai` (112c, 8× H100 80 GB, normal+preemptible, 2wk), `highmem` (192c, 1.5 TB, 24h, >48-core rule),
  `profiling` (whole-node, 24h), `smallgpu` (128c, 2× L40S, 24h). QOS: `normal` (default, charged),
  `standby` (idle, free, 4h max), `preemptible` (ai only, 0.25 GPU-hr, killable). List accounts with
  **`slist`**. Verified commands: `sbatch`, `squeue -u`, `scontrol show/hold/release`, `scancel`,
  `sinteractive`, `srun`, `slist`, `sfeatures`, `myquota`, `findscratch`, `purgelist`.
- **Filesystems:** home `/home/$USER` (`$HOME`, GPFS, snapshots); scratch `/scratch/gautschi/$USER`
  via **`$RCAC_SCRATCH`** (NOT `$CLUSTER_SCRATCH`), **60-day** purge, not backed up; Depot/Fortress
  for long-term; check with **`myquota`** / `findscratch`. **Quotas (25 GB home / 100 TB scratch)
  are illustrative `myquota` output, not official — context files should tell the agent to RUN
  `myquota`, not hardcode numbers.**
- **Modules:** environment modules (Lmod — implied by `module spider`); `module avail/spider/load`;
  recommended GCC 14.1.0 + OpenMPI (exact OpenMPI version unstated).
- **Login-node rule (quote):** "Do NOT run large, long, multi-threaded, parallel, or CPU-intensive
  jobs on a front-end login host… Always use SLURM to submit your work as a job."
  (`run_jobs/index.md:16-17`).
- **🚫 Two doc-errors to NOT propagate:** `--partition=a10` (invalid — use `ai`/`smallgpu`) and
  `#SBATCH -A standby` (standby is a QOS `-q standby`, not an account).
- **`[UNCONFIRMED]`** (do not invent; run-command or omit): exact quotas, Depot mount path, OpenMPI
  version, default login shell, `sinfo`/`sacct`/`jobinfo` on Gautschi, a Purdue AUP direct URL,
  data-classification policy.

## 5. The five harnesses (see brief 05 for the full table)

| harness | config path(s) | format | permission mechanism | MCP | context file |
|---|---|---|---|---|---|
| **Claude Code** | `~/.claude/settings.json`; project `.claude/settings.json`; **managed `/etc/claude-code/managed-settings.json`** | JSON | `permissions.allow/deny/ask` + `defaultMode` + OS sandbox | `claude mcp add` / `.mcp.json` (stdio+http/sse) | `CLAUDE.md` (no native AGENTS.md — bridge via `@import`/symlink) |
| **Codex CLI** | `~/.codex/config.toml`; `.codex/config.toml` | TOML | `approval_policy` + `sandbox_mode` (no per-cmd list; Linux sandbox needs **bubblewrap**) | `[mcp_servers.NAME]` / `codex mcp add` (stdio+HTTP) | `AGENTS.md` (native) |
| **Gemini CLI** | **`/etc/gemini-cli/settings.json` (system, final say)**; `~/.gemini/settings.json`; `.gemini/settings.json` | JSON | `tools.core` (allow) / `tools.exclude` (deny) `run_shell_command(<prefix>)`; blocklist wins; chains split | `mcpServers` (stdio+SSE+HTTP) | `GEMINI.md`; configurable `context.fileName` (can add AGENTS.md) |
| **opencode** | `~/.config/opencode/opencode.json`; project `opencode.json`; `/etc/opencode/` | JSON | `permission` per-bash-pattern map (**last-match-wins → catch-all first**); no OS sandbox | `mcp` `type:"local"`/`"remote"` | `AGENTS.md` (native) + `instructions` |
| **Warp** | **Desktop-app UI** (Settings > Agents); MCP JSON; Warp Drive rules | UI/JSON | Agent-Profile autonomy + regex allow/deny (Run-until-completion **ignores denylist**) | Settings > Agents > MCP (stdio+remote) | `AGENTS.md` (ALL-CAPS; `WARP.md` legacy) |

**Cross-cutting HPC realities:** OS sandboxes (bwrap/Docker/namespaces) are frequently **disabled on
shared login nodes** → treat the **permission/approval layer as primary**, point writable roots at
`/scratch/$USER`, deny `rm -rf`/`sudo`. The **enforcement points** for config management are the
*system/managed* files: Claude `/etc/claude-code/managed-settings.json`, Gemini
`/etc/gemini-cli/settings.json`. **Warp is the outlier — a local desktop GUI, cannot be installed on
a login node**; on-cluster coverage for Warp = "run it on your workstation and SSH in" (document
honestly, don't fabricate a login-node path).

## 6. Context-file design + mapping + prior art

- **`/etc/agents.d/*.md` = the DRY source of truth.** Shape per file: *fact → correct command/path
  → "do not…" list → rationale* (mirrors the paper's own `rules/`+`tips/`). Per-file outlines:
  - **unix.md** — Rocky 9 / bash; shared front-ends for edit/compile/submit only; no heavy compute
    on login nodes; no sudo; SSH-inherited access; process hygiene.
  - **filesystems.md** — home vs `$RCAC_SCRATCH` (not backed up, ~60-day purge) vs `/tmp` vs
    Depot/Fortress; `myquota`/`findscratch`; no secrets in world-readable paths; confirm bulk deletes.
  - **lmod.md** — software via environment modules, not apt/yum; `module avail/spider/load`; GCC
    14.1.0+OpenMPI; never invent module names.
  - **slurm.md** — job needs resources + `-A` (via `slist`) + `-q` + `-p` (mandatory); partitions
    cpu/ai/highmem/smallgpu/profiling; QOS normal/standby/preemptible; always set `--time`; no
    PBS/LSF flags; **never** `--partition=a10` or `-A standby`.
  - **policies.md** — Purdue AUP; sensitive-data & credential bans; resource stewardship;
    destructive-op confirmation; report to rcac-help@purdue.edu.
- **Mapping context → harnesses:** concatenate `/etc/agents.d/*.md` into one canonical **`AGENTS.md`**;
  symlink/bridge `CLAUDE.md` (Claude has no native AGENTS.md); Codex/opencode/Warp/Gemini read
  `AGENTS.md` (Gemini via `context.fileName`). **Local mode:** `rcac-mcp` injects the files over SSH
  (`rcac://context`). **Permissions are NOT portable** — hand-translate one policy into each harness's
  native settings format.
- **Prior-art verdict — early but not empty:** NERSC has a full [AI Coding Tools page](https://docs.nersc.gov/development/coding-agents/)
  ("verification is the whole game"; login-node + secrets rules) — the closest analog; TACC has
  [AI Tools on TACC Resources](https://docs.tacc.utexas.edu/basics/conduct/#ai) (compute-nodes-only,
  user-accountable). ALCF/NCSA — nothing agent-facing found. **No peer publishes an MCP/Slurm server
  or `/etc/agents.d` context** → RCAC's genuine white space. (A broad community "slurm-mcp" sweep was
  org-policy-blocked mid-research; not required for this feature.)

## 7. Net implications for the plan

1. One top-level `docs/agentic-ai/` section (hub + guidance + MCP + running-agents + shared-context
   subdir) + one Gautschi chapter; canonical artifacts under `docs/snippets/agentic-ai/`.
2. Publish verbatim via `--8<--` fenced includes; verify by grepping built `site/` (check_paths
   footgun).
3. Author context files from verified Gautschi facts; instruct agents to run `myquota`/`slist`
   rather than hardcoding volatile numbers; never emit the two doc-errors.
4. Present MCP `rcac-mcp` as prototype; the `cluster-mcp` plugin direction is planned/evolving and
   needs human confirmation before publish.
5. Warp is local-only; be honest about the on-cluster gap. Enforcement lives in the system/managed
   settings files (Claude `/etc/claude-code/`, Gemini `/etc/gemini-cli/`).
