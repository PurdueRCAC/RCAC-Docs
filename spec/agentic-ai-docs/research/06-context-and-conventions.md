---
title: "Context files, harness conventions, and peer prior art"
slug: agentic-ai-docs
research_task: "06 — /etc/agents.d intent, AGENTS.md convention mapping, peer-center prior art"
date: 2026-07-14
sources:
  - glentner/pearc26-hello-computer (outline/03-approach.md, outline/04-discussion.md, rules/*, tips/*)
  - Gautschi user guide (overview, storage, software, run_jobs/queues) + main.py macros / snippets
  - NERSC, TACC, ALCF, NCSA docs (web)
  - agents.md open standard
---

# Research 06 — Shared context, harness conventions, and prior art

## 1. Paper intent for `/etc/agents.d` + per-file content outlines

### 1.1 What the authors intend `/etc/agents.d` to be

From `outline/03-approach.md` ("System-Wide Configurations"), the `/etc/agents.d`
directory hierarchy is RCAC's mechanism to **inject HPC-specific context into the
well-known rules-file locations agentic tools already look for**, so "the agent absorbs
the cluster's policies before the user asks their first question." The paper names two
kinds of content that belong there:

1. **Facts / "which command for what"** — quota checks (`myquota`), batch submission
   (`sbatch`), loading software via environment modules, which filesystems serve which
   purpose.
2. **Prohibitions** — "don't run computationally intensive work on login nodes, don't
   store sensitive data in world-readable locations, don't submit jobs without time
   limits."

So each file is a **cluster-context brief**, not a tutorial: declarative facts + explicit
prohibitions, written *to the agent*. It is the local-knowledge layer that fixes the
paper's central failure mode — the agent that confidently emits "a Slurm script that
would work perfectly… on a cluster we don't operate" (`04-discussion.md` §4.1/§4.4).

### 1.2 Framing / voice to carry into the files (from `04-discussion.md`)

- **Proactive engagement, not prohibition / "mostly harmless"** — "We don't pretend they
  don't exist or discourage their use" (03); confinement already exists (cgroups, health
  checks, root-squash, quotas) so agents "accelerate the pace of potential errors, which
  means existing hardening must be strengthened, not invented" (§4.5).
- **Context engineering ("Tea, Earl Grey, Hot")** — structure information so the agent
  produces reliable output *from the outset*; specificity beats generality. `/etc/agents.d`
  is that engineered specificity supplied by the center rather than the user.
- **Verify, don't forbid / augmented not outsourced ("I Know Kung Fu", "The Answer is 42")**
  — "use AI to accelerate your learning, not to bypass it… ask *why*, not just *what*";
  "Verification isn't optional; it's the core competency." Files should tell the agent to
  prefer center-verified facts and flag uncertainty over inventing flags.
- **Don't cross the streams (§4.5)** — the concrete blast-radius risks the prohibitions
  target: `rm -rf` of a project dir, allocation exhaustion in hours, secrets logged into a
  persistent context window.

### 1.3 What the authors' own `rules/` + `tips/` teach about good rules content

These are the authors' *battle-tested* agent files; the patterns are the template for tone
and structure:

- **`rules/file_deletion.md`** — a hard prohibition + the safe alternative (use `del`/
  `/bin/rm` deliberately, never bare `rm`), with a rationale and a scoped exception. Pattern:
  *state the danger, give the safe path, name the exception.*
- **`rules/session_logs.md` / `planning_docs.md` / `structural_docs.md`** — "capture what
  was requested + done + why"; keep index/structural docs in sync. Maps to RCAC's
  reproducibility interest (§4.5 "capturing agent interactions that contribute to
  scientific outcomes").
- **`rules/wip_commits.md`** — branch discipline, commit-often, "force-push OK here but
  **never on `main`**." Pattern: *explicit allow + explicit hard prohibition in the same
  breath.*
- **`tips/agent-text-editing-pitfalls.md`** — agents silently truncate trailing content in
  diffs → "review diffs, request minimal edits, verify after." Reinforces *verify output*.
- **`tips/long-horizon-tasks.md`** — structured memory files (YAML front-matter, session
  prompt templates) beat one long context. This is the same "context engineering" the paper
  sells; RCAC's `/etc/agents.d/*.md` are exactly these persistent "memory anchors."
- **`tips/warp-conversation-history.md`** — recovering verbatim inputs; the caveat "don't
  rely on it, log promptly" mirrors "verification is the whole game."

Common shape to reuse in every RCAC file: **short declarative facts → the correct
command/path → an explicit "do not …" list → a rationale line.** Each file self-contained
and skimmable, front-matter optional.

### 1.4 Proposed content outlines (section headings + one-line intent)

Cluster-context oriented (facts + prohibitions), **not tutorials**. Grounded in verified
Gautschi facts: Rocky Linux 9, Lmod, 8 AMD EPYC "Genoa" front-ends; partitions
`cpu`/`ai`/`highmem` (+ `profiling`/`smallgpu`); QOS `normal`/`standby` (cpu) &
`normal`/`preemptible` (ai); `-A` (see `slist`), `-p`, `-q` all required; home 25 GB w/
daily snapshots, `$RCAC_SCRATCH`=`/scratch/gautschi/$USER` (huge, **not** backed up, purged
~60 days), `/tmp` node-local, Depot + Fortress (hsi/htar) for long-term; `myquota`,
`findscratch`.

#### `unix.md` — the login-node OS/shell environment
- **Operating system & shell** — Rocky Linux 9, `bash` default, standard GNU coreutils;
  what an agent can assume is present.
- **Front-end nodes are shared** — 8 multi-tenant login nodes; intended for editing,
  compiling, job submission, light pre/post-processing only.
- **Do NOT run real compute on login nodes** *(prohibition)* — no heavy/parallel/
  long-running work on front-ends; move it to Slurm (CPU/memory limits enforced).
- **No elevated privileges** *(prohibition)* — no `sudo`/root; can't install system
  packages; use environment modules and user space instead.
- **Access & session model** — SSH-key access, ThinLinc for GUI; the agent inherits the
  user's existing SSH access, nothing more.
- **Process hygiene** *(prohibition)* — no unbounded background processes / runaway loops;
  clean up temp processes; watch for agent retry storms.

#### `filesystems.md` — where data lives and what is safe
- **Home directory** — path + 25 GB quota + daily snapshots (recoverable); for code/config,
  not large data.
- **Scratch (`$RCAC_SCRATCH`)** — `/scratch/gautschi/$USER`, large high-performance parallel
  FS for job I/O; **not backed up, purged ~60 days** — never treat as durable *(prohibition)*.
- **`/tmp` / node-local** — ephemeral, per-node, cleared after the job.
- **Long-term storage (Depot, Fortress)** — group/archive space; move keepers off scratch via
  `hsi`/`htar`.
- **Check before you write** — use `myquota`, `findscratch`, `du -h --max-depth=1`; respect
  quotas (file-count and size).
- **Prohibitions** — no big data in home; no secrets/sensitive data in world-readable paths;
  no bulk/`rm -rf` deletes without user confirmation.

#### `lmod.md` — the software environment
- **Software comes from modules, not the package manager** *(prohibition on apt/yum/system
  installs)* — RCAC uses Lmod.
- **Discovering software** — `module avail`, `module spider <name>` for versions/prereqs.
- **Loading & managing** — `module load/list/purge`; the `(D)` default marker; pin versions
  and load the same modules inside job scripts.
- **Recommended toolchain** — GCC 14.1.0 + OpenMPI; hierarchical modules.
- **Python/Conda** — use the `anaconda` modules and user environments; don't pollute base.
- **Prohibitions / pitfalls** — never invent a module name or version; verify with
  `module spider` before claiming a package exists.

#### `slurm.md` — the scheduler
- **Scheduler basics** — Slurm; batch (`sbatch`) vs interactive (`salloc`/`sinteractive`);
  `squeue`/`scancel`/`sacct`; `jobinfo`.
- **Every Gautschi job needs four parts** *(the key gotcha)* — resources + account (`-A`,
  discover via `slist`) + QOS (`-q`) + **partition (`-p`, mandatory)**.
- **Partitions** — `cpu`, `ai`, `highmem` (+ `profiling`, `smallgpu`): what each is for and
  node type.
- **QOS & charging** — `normal`/`standby` on `cpu`; `normal`/`preemptible` on `ai`; time
  limits per QOS; checkpoint `preemptible` jobs.
- **Always set a time limit and realistic resources** *(prohibition on no-`--time` jobs)* —
  memory is allocated proportional to cores.
- **Prohibitions** — don't emit PBS/LSF/other-scheduler flags; don't invent partitions/QOS;
  don't run compute on login nodes; confirm before bulk/`scancel` of others' jobs; don't
  exhaust the allocation.

#### `policies.md` — rules, data handling, and cautions
- **Acceptable use** — bound by Purdue IT / RCAC AUP; link the policy of record.
- **Data handling & sensitivity** *(prohibition)* — no regulated/sensitive/export-controlled
  data without prior approval.
- **Secrets & credentials** *(prohibition)* — never store API keys/tokens/private keys in
  world-readable or shared paths; never paste them into prompts/agent context.
- **Resource stewardship** — recap: no heavy compute on login nodes; Slurm jobs carry time
  limits; steward the allocation.
- **Destructive operations require confirmation** *(prohibition)* — `rm -rf`, mass moves,
  bulk `scancel`; the agent must confirm with the user.
- **Account integrity & getting help** — no account/credential sharing (the agent acts *as
  you*); verify AI output before running; report bad AI commands to `rcac-help@purdue.edu`.

---

## 2. The context-file convention and how one canonical set maps onto every harness

### 2.1 The `AGENTS.md` open standard (the anchor to cite)

`AGENTS.md` (<https://agents.md/>) is an **open, tool-agnostic format** — "a README for
agents": plain Markdown with flexible headings, placed at the **repo root** (or system/home
root for a global config), with nested files allowed and "the closest `AGENTS.md` to the
edited file wins." Its philosophy is *separation of concerns* — `README.md` is for humans,
`AGENTS.md` is the detailed context agents need. The site reports **60k+ projects** and
**~25–30+ tools** consuming it, explicitly including **OpenAI Codex, Gemini CLI, Cursor,
Aider, VS Code, GitHub Copilot, Zed, Warp, JetBrains Junie, opencode/Windsurf**, etc. Its
migration FAQ is the load-bearing quote for our strategy: **"Rename existing files to
`AGENTS.md` and create symbolic links for backward compatibility."**

### 2.2 The well-known per-harness filenames (the fan-out targets)

Each harness historically reads its *own* context filename and its own settings/permissions
format. For our five:

| Harness | Context file it reads | Settings / permissions file |
|---|---|---|
| **Claude Code** | `CLAUDE.md` (and `@path` imports); also reads `AGENTS.md` in recent versions | `.claude/settings.json` (`permissions.allow`/`deny`/`ask`) |
| **OpenAI Codex** | `AGENTS.md` natively | `~/.codex/config.toml` |
| **Gemini CLI** | `GEMINI.md` (context filename is configurable → can point at `AGENTS.md`) | `.gemini/settings.json` |
| **opencode** | `AGENTS.md` natively | `opencode.json` |
| **Warp** | `WARP.md` / Warp Rules (Warp also added `AGENTS.md` support) | Warp Rules / drive config |

The key fact: **`AGENTS.md` is already the common denominator** — Codex and opencode read it
natively, Gemini can be pointed at it, Warp supports it, and Claude Code reads `CLAUDE.md`
which the standard tells you to *symlink to `AGENTS.md`* (this repo does exactly that:
`CLAUDE.md -> AGENTS.md`, `.claude -> .agents`).

### 2.3 Recommended mapping strategy (one canonical source → every harness)

RCAC's canonical source of truth is **five separate topic files** in `/etc/agents.d/`
(`unix.md`, `filesystems.md`, `lmod.md`, `slurm.md`, `policies.md`). Surface them two ways
depending on deployment mode (per GOAL R8/R12):

1. **On-cluster mode (harness runs on a Gautschi login node).** Concatenate the five files,
   in a stable order, into a single canonical **`AGENTS.md`** placed at a system/global
   context location, then **symlink the other well-known names to it**:
   `CLAUDE.md → AGENTS.md`, `GEMINI.md → AGENTS.md`, `WARP.md → AGENTS.md`. This is the
   standard's own prescribed pattern and exactly the trick used in the paper repo and this
   RCAC-Docs repo. Concatenation (not five separate files) is preferred because most
   harnesses load a *single* root context file; the `/etc/agents.d/*.md` split is a
   *maintenance/source* convenience, collapsed at deploy time. Puppet performs the copy +
   concat + symlink onto the hosts (out of scope for the docs feature, but the mechanism to
   describe).
2. **Local mode (harness on the user's laptop, targeting the cluster over MCP + SSH).** The
   HPC MCP server (`rcac-mcp`) **reads `/etc/agents.d/` over SSH and injects the markdown as
   agent context** at connect time (GOAL R8) — no local file placement needed. The path is
   configurable.

**Permissions** are *not* portable across harnesses — each settings format is different — so
R11's per-harness settings files must be authored natively (`.claude/settings.json`,
`config.toml`, `.gemini/settings.json`, `opencode.json`, Warp Rules), each (a) wiring in the
shared context (via `AGENTS.md`/symlink or an import directive) and (b) encoding the same
starting-point deny/allow policy (deny destructive ops + login-node heavy compute; require
Slurm time limits; no secrets in world-readable paths; confirm destructive actions). The
*context* is DRY via `AGENTS.md`; the *permissions* are parallel translations of one policy.

**Net recommendation:** treat `/etc/agents.d/*.md` as the DRY source, concatenate to a single
canonical `AGENTS.md`, symlink every other harness's context filename to it (cite the
agents.md FAQ), inject the same files over SSH via MCP for local mode, and hand-translate the
one permission policy into each harness's native settings file.

---

## 3. Prior-art survey — what peer HPC centers publish about agentic AI

Verdict up front: **the space is early but no longer empty.** Two centers (NERSC, TACC) now
publish explicit agentic-AI guidance; the tone at both is *permit-with-guardrails +
verify*, matching RCAC's stance almost exactly. Others (ALCF, NCSA) had nothing agent-facing
visible at survey time. RCAC would be an early mover but not a first mover — and can credibly
cite NERSC/TACC as convergent practice.

### 3.1 NERSC — a full, dedicated page (strongest prior art)
**URL:** <https://docs.nersc.gov/development/coding-agents/>

A complete, RCAC-shaped guide titled around **AI Coding Tools / coding agents**. Tone is
**cautiously permissive**: *"The goal is not to let a model operate unsupervised. The goal is
to use these tools to reduce repetitive work while keeping humans in control."* Notable
because it independently arrives at nearly every RCAC pillar:

- **Login-node rule** — small interactive debugging OK; no long-running/resource-intensive
  work on login nodes.
- **Sandboxing / write scope** — recommends **workspace-write mode**, confining agent writes
  to `$HOME`/`$SCRATCH`; sensitive `$CFS` data read-only or copied out.
- **Secrets** — *"Do not paste credentials, tokens, or private keys into prompts."*
- **Verification mandate** — *"Users are responsible for validating generated code, commands,
  configurations, and scientific results"*; a whole section **"Slurm and Module Advice Needs
  Verification"** and **"Verification Is the Whole Game."**
- **AUP boundary** — agents "must not be given prohibited data, must not bypass access
  controls," must stay in approved project scope.
- Rich section set incl. **Context Engineering**, **Sandboxing and Approval Boundaries**,
  **Common AI Mistakes on HPC Systems**, **Prompt Template for NERSC Tasks**, and *"If You
  Only Remember Four Things."* References Claude Code by name. (No MCP-server section
  observed — an opening for RCAC to differentiate.)

This page is the closest analog to RCAC's planned content and a strong structural model /
tone reference; RCAC's differentiators are the **published `/etc/agents.d` context**,
**per-harness settings**, and **MCP servers** — which NERSC does not appear to cover.

### 3.2 TACC — a concise policy block in the Good Conduct Guide
**URL:** <https://docs.tacc.utexas.edu/basics/conduct/#ai> ("AI Tools on TACC Resources")

Short, blunt, policy-flavored — folded into the login-node conduct rules. Verbatim rules:
- *"All AI-assisted workloads must be executed on compute nodes only."*
- *"YOU are responsible for all your processes initiated on TACC resources, including those
  launched via AI tools or agents."*
- *"All Service Units (SUs) consumed by AI-related workloads will be charged against your
  allocation."*
- Suggested workflow: grab a compute node via **`idev`**, then point the AI tool at the
  allocated node. Warning: violations → *"degraded access… or administrative action."*

Tone is firmer/more enforcement-y than NERSC, but the substance is identical to RCAC's
(no login-node compute; user is accountable; allocation is charged). Good source for the
acceptable-use/etiquette page (R2) — note TACC pushes *all* AI work to compute nodes, a
stricter line than RCAC's "light work on login nodes OK."

### 3.3 ALCF — nothing agent-facing found
**URL:** <https://docs.alcf.anl.gov/> (returned HTTP 403 to the fetcher). ALCF publishes
extensive *AI-for-science* (training/inference) material but no agentic coding-assistant /
AI-agent acceptable-use guidance was locatable. Treat as "no prior art at survey time."

### 3.4 NCSA — nothing agent-facing found
**URLs:** <https://docs.ncsa.illinois.edu/> and the Delta guide
<https://docs.ncsa.illinois.edu/systems/delta/en/latest/>. No mention of AI coding agents,
LLM assistants, or MCP servers surfaced. Treat as "no prior art at survey time."

### 3.5 MCP-for-HPC prior art
WebSearch was blocked in this environment (org policy on the search feature), so a broad
sweep for third-party "MCP + Slurm" projects couldn't be completed here. From the material
available: **no peer center documents an MCP server for cluster/Slurm operations** — NERSC,
TACC, ALCF, NCSA pages contain no MCP references. This makes RCAC's `rcac-mcp` /
`rcac-docs-mcp` / `globus-mcp` documentation a genuine **differentiator / white space** and
supports the paper's "local-first MCP" framing as novel published practice. (Recommend a
follow-up unrestricted web search to confirm no community "slurm-mcp" prior art before
claiming first-mover status in the docs.)

### 3.6 Takeaways for the RCAC docs
- **Not first, but early.** Cite NERSC + TACC as convergent peer practice; it de-risks the
  stance and lends authority ("centers including NERSC and TACC…").
- **Tone converges on RCAC's:** permit + guardrails + *verification is the whole game* +
  login-node discipline + secrets prohibition + user-accountability. RCAC can adopt this
  register confidently.
- **RCAC's white space:** published `/etc/agents.d` context files, per-harness settings, and
  documented MCP servers — none of the four peers publish these. Lead with them.
- **One caution to mirror TACC/NERSC precisely:** the login-node line. TACC = compute nodes
  only; NERSC = light interactive OK. RCAC should state its own line explicitly (GOAL R5:
  light on front-ends, real work via Slurm) rather than leave it implied.
