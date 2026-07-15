# GOAL — Agentic AI on RCAC: guidance, MCP tooling, and shared context

> **Origin spec.** The *what* and *why* — the locked contract `docs-review` grades against.
> The *how* lives in [`PLAN.md`](PLAN.md) and [`TECH.md`](TECH.md) (written by `docs-plan`).

- **slug:** agentic-ai-docs
- **kind:** feature
- **appetite:** big  ·  *multi-pillar new section; expect `docs-plan` to split into several phases and
  to scope-hammer nice-to-haves against this contract.*

## Problem

Researchers on RCAC's clusters are already using agentic coding tools — Claude Code, OpenAI
Codex, Gemini CLI, opencode, Warp — with or without our endorsement, both directly on login
nodes and from their laptops targeting the cluster over SSH. Today the RCAC documentation site
has **zero** public guidance on this: no acceptable-use rules, no setup instructions, no mention
of our MCP servers, and no published account of the shared context we inject into agents. The
result is the failure mode described in our PEARC'26 paper *Hello Computer: HPC in the Agentic
Era* — users arrive at the help desk with confident, plausible, and wrong AI output (a Slurm
script for a scheduler we don't run), and the cluster is exposed to preventable mistakes because
nobody shaped the context in which the interaction happened.

RCAC's chosen strategy is **proactive engagement, not prohibition**: system-wide `/etc/agents.d`
context files, purpose-built MCP servers, and honest documentation that helps users *verify*
rather than *forbidding* the tools. Two of those three pillars exist in prototype (the MCP
servers); the documentation pillar does not exist at all, and the shared context/settings
artifacts the other pillars are meant to consume have not yet been authored. This feature builds
the documentation pillar **and**, as a shared exercise, constructs the first real version of the
shared context and per-harness settings — starting with the Gautschi cluster.

## Outcome / vision

A new top-level **Agentic AI** section on `docs.rcac.purdue.edu`, plus a cross-linked **Using AI
Agents** chapter in the Gautschi user guide. After reading, a researcher can:

- Understand RCAC's stance and what is expected of them: acceptable use, etiquette, the real
  limitations, and best practices (using an agent *for research* vs *for operations*; verifying
  output; augmenting rather than outsourcing their own expertise; the safety "don't cross the
  streams" cautions).
- **Set up their chosen harness** (any of the five) correctly for Gautschi, in whichever mode
  they work — running the agent *on the cluster* (login nodes) or *locally, targeting the
  cluster* over MCP + SSH.
- Learn what our **MCP servers** are, why they matter, and how to connect them: the HPC
  operations server (`rcac-mcp`, generalizing toward a plugin architecture), the docs-search
  server (`rcac-docs-mcp`, hosted at `docs.rcac.purdue.edu/mcp`), and `globus-mcp` for transfers.
- **See exactly what context and permissions RCAC gives their agents** — the actual Gautschi
  `/etc/agents.d` context files (`unix.md`, `filesystems.md`, `lmod.md`, `slurm.md`,
  `policies.md`) and the per-harness settings files, published verbatim — and know how to send
  feedback and corrections.

The published context/settings files are the **canonical single source of truth**: cluster
config management (Puppet) copies them out to `/etc/agents.d` on the hosts, and the HPC MCP
server reads them over SSH and injects them as agent context. This is early, evolving work; the
docs say so.

## Acceptance criteria (the contract)

Reader-facing, observable outcomes. Stable IDs survive squash-merge.

**Section & stance**

- **R1** — A top-level **Agentic AI** section SHALL appear in `mkdocs.yml` `nav:` with an
  `index.md` hub that states RCAC's stance (proactive engagement, not prohibition; verify, don't
  forbid) and links to every subpage; it SHALL resolve without a `--strict` nav/link warning.

**Acceptable use, etiquette, limitations, best practices**

- **R2** — WHEN a reader opens the acceptable-use/etiquette page, it SHALL state the rules for
  running agents on RCAC systems (no heavy compute on login nodes; jobs go through Slurm with
  time limits; no sensitive data in world-readable locations; destructive actions require
  confirmation) consistently with RCAC's existing Acceptable Use policy, and link to the Purdue
  IT policy of record.
- **R3** — A best-practices/limitations page SHALL distinguish using an agent *for research* from
  using one *for operations*, and SHALL cover context engineering, verification of output
  ("augmented, not outsourced"; ask *why*, not just *what*), and the caution/blast-radius risks
  (destructive commands, allocation exhaustion, credential/secret leakage).

**Running agents (organized by deployment mode; all five harnesses)**

- **R4** — The "Running agents" material SHALL be organized primarily by deployment mode —
  (a) *on the cluster* (login nodes) and (b) *locally, targeting the cluster* via MCP + SSH — and
  each mode SHALL cover Claude Code, Codex, Gemini CLI, opencode, and Warp.
- **R5** — The on-cluster guidance SHALL state the login-node constraints that apply to agents
  (no heavy/parallel/long compute on front-ends; submit work via Slurm), consistent with the
  Gautschi Running Jobs guidance.
- **R6** — The local (MCP + SSH) guidance SHALL explain the local-first architecture: the agent
  runs in the user's own environment and executes remotely through their existing SSH access — no
  new credentials and no hosted infrastructure required.

**MCP servers**

- **R7** — An MCP page SHALL document RCAC's MCP servers with their current focus and link each to
  its public GitHub repository: the HPC operations server (`rcac-mcp`, generalizing toward a
  plugin architecture, e.g. `cluster-mcp[slurm,lmod,…]`); the docs-search server
  (`rcac-docs-mcp`, hosted at `docs.rcac.purdue.edu/mcp`); and `globus-mcp` (data transfers). It
  SHALL explain *why* MCP matters (context that knows our clusters), present all three as **working
  prototypes under active development**, and explicitly **call out the planned rename /
  re-architecture of `rcac-mcp`** toward the HPC-only plugin model.
- **R8** — The MCP page SHALL explain that the HPC MCP server reads the host's `/etc/agents.d`
  markdown context (a configurable location) over SSH and injects it into the agent's context.
- **R9** — Any install/connection commands or tool names shown for the MCP servers SHALL be
  verified against the live public repositories at draft time — never invented.

**Shared context & settings (build + publish the canonical source of truth)**

- **R10** — The section SHALL publish the actual Gautschi shared-context files verbatim
  (`unix.md`, `filesystems.md`, `lmod.md`, `slurm.md`, `policies.md`); their content SHALL be
  HPC-accurate for Gautschi (Rocky Linux 9; Lmod; partitions `cpu`/`ai`/`highmem`/`smallgpu`/
  `profiling`; QOS `normal`/`standby`/`preemptible`; correct filesystem paths and technologies —
  `/home` ZFS, `/depot` GPFS, `/scratch` Lustre — deferring volatile quota numbers to
  `myquota`/`slist` rather than hardcoding them).
- **R11** — The section SHALL publish per-harness settings/permission files for all five harnesses
  (Claude Code, Codex, Gemini CLI, opencode, Warp), each in that harness's native settings
  format, wiring in the shared context and encoding a starting-point permission policy that both
  (a) **denies** destructive/dangerous operations (e.g. `rm -rf`, `sudo`) and login-node heavy
  compute, and (b) **allow-lists common read-only sanity commands** (`myquota`, `slist`,
  `sfeatures`, `module list`, `module avail`, …) so the agent runs them eagerly without prompting.
- **R12** — A page SHALL explain how `/etc/agents.d` context and the harness settings fit together
  (context injected; permissions enforced), state that these files are the canonical source of
  truth copied into cluster config management, and tell readers how to contribute feedback and
  corrections.

**Gautschi integration**

- **R13** — A **Using AI Agents** chapter SHALL be added to the Gautschi user guide (in the
  Gautschi `nav:` sub-tree) and be cross-linked with the top-level Agentic AI section, giving
  Gautschi-specific setup pointers.

**Build, accessibility, accuracy (hammerable: false — never trimmed to fit appetite)**

- **R14** — Every new page SHALL be included in `mkdocs.yml` `nav:`, and `mkdocs build --strict`
  SHALL introduce no new warnings versus `strict-baseline.txt`.
- **R15** — Page-to-page links SHALL be relative and static assets absolute; every content image
  SHALL carry meaningful `alt` text; headings SHALL descend without skipping; tables SHALL use
  header rows (content-level WCAG 2.1).
- **R16** — All HPC specifics on the new pages (partitions, QOS, modules, filesystem paths, SSH
  hostnames, commands) SHALL be correct for Gautschi, verified against gold-standard Gautschi
  pages or authoritative sources; no invented flags or paths.

## Non-goals (no-gos)

- **Other clusters.** Gautschi only. Anvil, Bell, Gilbreth, Negishi, Scholar, Geddes, Hammer, and
  the storage services are an explicit follow-up feature (per-cluster parallelism handled then).
- **Building the MCP servers.** We document and link `rcac-mcp` / `globus-mcp` / `rcac-docs-mcp`;
  their source code lives in their own repos and is not shipped or vendored here.
- **The config-management (Puppet) deployment pipeline.** We author the canonical `/etc/agents.d`
  and settings files; wiring them into Puppet and onto the hosts is out of scope for this feature.
- **A security audit / formal threat model** of MCP or agentic tooling — practical caution only,
  mirroring the paper's non-goal (confinement discussed, not proven).
- **Model or vendor benchmarking / endorsement.** Guidance is vendor-neutral across the five
  harnesses; no performance claims.
- **Theme / CSS / JS or accessibility-*theme*-layer changes.** Content-level a11y only; the theme
  a11y layer is a `dev`-branch concern (invariants §2).
- **Generated content.** No hand-edits to catalogs, the software/dataset generators, or
  breadcrumbs (breadcrumbs regenerate from the nav change via the normal workflow).
- **A companion announcement blog post** — deferred to a possible follow-up so it doesn't expand
  this already-large feature.

## Clarifications

Resolved with the human during shaping on 2026-07-14.

- **Q:** Where should the material live, and how prominent? — **A:** Hybrid: a new **top-level
  "Agentic AI" section** for the general/conceptual/MCP/context material, **plus** a cross-linked
  **"Using AI Agents"** chapter in the Gautschi user guide.
- **Q:** How should the built context files and harness settings be surfaced? — **A:** Publish
  them **verbatim** in this repo as the **canonical single source of truth**. Puppet copies them
  out to `/etc/agents.d` on the cluster hosts, and the HPC MCP server injects them over SSH; users
  do **not** hand-install them. (A downloadable copy is a nice-to-have, not required.)
- **Q:** Which harnesses get authored settings/permission files? — **A:** **All five** (Claude
  Code, Codex, Gemini CLI, opencode, Warp). All five also get usage guidance.
- **Q:** Primary organizing axis for the run-agents guidance? — **A:** **By deployment mode**
  (on-cluster login nodes vs. local via MCP + SSH), with harnesses covered within each.
- **Q (architecture, from the human):** MCP servers are being re-architected — record the current
  intent. — **A:** `rcac-mcp` is refocusing on **HPC-only operations** with a **generalized
  plugin architecture** (e.g. `cluster-mcp[slurm,lmod,…]`); `rcac-docs-mcp` is a **standalone**
  service hosted at **`docs.rcac.purdue.edu/mcp`** (full-text search/load over this site);
  `globus-mcp` handles data transfers. The HPC server, over SSH, reads `/etc/agents.d` (a
  configurable path) on the host and injects those markdown files as MCP context. Docs present all
  of this as **prototype/evolving** ("likely to change over time").
- **Q:** What enforced-permission policy do the settings encode? — **A:** This is a deliberate
  **shared construction exercise**; author a reasonable **starting-point** deny/allow policy
  derived from the paper (no login-node heavy compute; require Slurm time limits; no secrets in
  world-readable paths; confirm destructive operations) and iterate later. Not a blocker.
- **Voice/stance (adopted from the paper, recorded):** proactive engagement not prohibition;
  "mostly harmless"; verify don't forbid; augmented not outsourced; "don't cross the streams"
  caution. Professional, instructional, second person (house style).

### Resolved during planning review (2026-07-15)

Refinements from the human after reviewing `PLAN.md`/`TECH.md`:

- **MCP framing (confirmed).** All three servers (`rcac-mcp`, `globus-mcp`, `rcac-docs-mcp`) are
  **working prototypes under active development**. Docs SHALL explicitly **call out the planned
  rename / re-architecture of `rcac-mcp`** toward the HPC-only plugin model (`cluster-mcp[slurm,
  lmod,…]`) — as a stated direction, not a shipped fact. (Refines R7.)
- **Warp is first-class and recommended.** Warp is the **recommended harness for most users**; the
  docs SHALL tell the story of using it *well* — run locally on the user's workstation, targeting the
  cluster over SSH (Warp is a desktop app and does not run on login nodes). Give it prominent,
  first-class treatment in the local (MCP + SSH) guidance, not a footnote.
- **Container model is Apptainer, not Docker.** These clusters use **Apptainer**. RCAC's Apptainer
  configuration **auto bind-mounts `/home`, `/depot`, and `/scratch`** into containers for
  convenience, so containers offer **limited protection** — the most likely failure mode is an agent
  *editing files* on those (still-writable) mounts; users can disable the bind-mounts by invoking
  Apptainer explicitly. Best-practices/caution and the context files SHALL reflect this (do not imply
  Docker or strong container sandboxing on the nodes).
- **Filesystem technologies (authoritative, human-corrected).** `/home` is **ZFS**, `/depot` is
  **GPFS**, `/scratch` is **Lustre** — this corrects the generic snippet that implied `/home` on
  GPFS. `filesystems.md` SHALL state these correctly. (Refines R10.)
- **Eager read-only sanity checks + allow-list.** Guidance and context SHALL instruct agents to
  **eagerly run read-only sanity commands** — `myquota`, `slist`, `sfeatures`, `module list`,
  `module avail`, and similar — and the per-harness settings SHALL **allow-list** them so the agent
  does not stop to ask. (Refines R11.)

*No unresolved `[NEEDS CLARIFICATION]` markers remain; the GOAL is ready for `docs-plan`.*

### Resolved during human review (2026-07-15)

Refinements from the human after reading the fully-drafted section on a local build.
These **refine the recorded voice/interpretation**; the acceptance criteria (R-IDs) are
unchanged.

- **Paper reference, not front-and-center (refines the voice note & R3).** The PEARC'26
  paper *Hello Computer: HPC in the Agentic Era* SHALL be cited as a **reference (a
  footer note)** linking its GitHub replication package
  (<https://github.com/glentner/pearc26-hello-computer>), **not** as the lead content of
  the hub. (A DOI will be added once the paper is on the ACM Digital Library — deferred.)
- **Measured tone; drop the pop-culture framing (supersedes the earlier voice note).**
  The published docs SHALL use a **direct, measured, professional tone**. The literal
  phrase **"mostly harmless" SHALL NOT appear**, and other pop-culture references
  (e.g. "don't cross the streams", "I Know Kung Fu") SHALL be dropped. **One exception:**
  the **"Tea, Earl Grey, hot"** illustration may appear **once** — it is conceptually
  load-bearing for the point about prompt specificity. (The stance itself — proactive
  engagement, verify-don't-forbid, augmented-not-outsourced — is unchanged and correct.)
- **Warp is distinct from the MCP bridge (refines R4/R6).** Two different local
  mechanisms SHALL be distinguished: (a) the cluster MCP (`rcac-mcp`) uses SSH as a
  **background bridge** so the agent works through **pure tool calls** — this is the model
  for the CLI harnesses (Claude Code, Codex, Gemini CLI, opencode); (b) **Warp** is a
  desktop terminal in which the **user SSHs into the cluster directly** and the agent
  **rides that live SSH session**. Warp SHALL NOT be documented as using the cluster MCP;
  instead the docs SHALL explain how a user can **wire in the `/etc/agents.d` shared
  context once they have SSH'd to the cluster**.
- **Settings are RCAC-deployed & enforced, not user-installed (refines R11/R12).** The
  per-harness settings SHALL be presented as **what RCAC deploys to the system-managed
  location and enforces** (published for transparency), not as files the user must copy
  in. Where a harness has a system-managed path (Claude Code
  `/etc/claude-code/managed-settings.json`, Gemini `/etc/gemini-cli/settings.json`,
  opencode `/etc/opencode/`) this SHALL be stated as the enforced location; **Codex** has
  no managed path (a recommended user default — stated honestly); **Warp** has no settings
  file (a team-managed **Agent Profile**, documented inline — no `AGENTS.md`-style file).

## Related materials

- **PEARC'26 paper** (the motivating source, three pillars, and Discussion framing to mirror for
  voice): <https://github.com/glentner/pearc26-hello-computer> — *Hello Computer: HPC in the
  Agentic Era* (Lentner & Ashish, 2026).
- **MCP repositories:** <https://github.com/PurdueRCAC/rcac-mcp> ·
  <https://github.com/PurdueRCAC/globus-mcp> · <https://github.com/PurdueRCAC/rcac-docs-mcp>
  (hosted at `docs.rcac.purdue.edu/mcp`).
- **Gold-standard pages to mirror / reuse:**
  - Hub archetype: `docs/lifesciences/index.md` (tagged hub + grid cards).
  - Policy archetype: `docs/userguides/anvil/policies.md` + `docs/snippets/resourceuse.md`
    (`resource_use` macro) — Gautschi currently has **no** `policies.md`.
  - External-tool → cluster prior art: `docs/lifesciences/guides/vscode.md` (Remote-SSH /
    ProxyJump into a compute node).
  - Gautschi facts: `docs/userguides/gautschi/{overview,software,storage}.md`,
    `run_jobs/{index,queues,directives}.md`.
  - Reusable macros (`main.py`): `ssh_keys_snippet`, `module_system`, `slurm_general_jobs`,
    `storage_quota`, `scratch_space`, `resource_use`.
- **Reference sites** (same MkDocs-Material lineage): docs.tacc.utexas.edu, docs.alcf.anl.gov,
  docs.ncsa.illinois.edu.
- Issue: *(none yet — create and back-link if desired).*
