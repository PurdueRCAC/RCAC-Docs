# GOAL — `/etc/agents.d` context for every cluster; retire per-harness settings

> **Origin spec.** The *what* and *why* — the locked contract `docs-review` grades against.
> The *how* lives in [`PLAN.md`](PLAN.md) and [`TECH.md`](TECH.md) (written by `docs-plan`).

- **slug:** agents-d-all-clusters
- **kind:** feature
- **appetite:** big  ·  *three new cluster data models need HPC fact research, plus a policy
  removal across the Agentic AI section.*

## Problem

The Agentic AI section (`spec/agentic-ai-docs`) publishes two things as the source of truth for
what RCAC deploys: the `/etc/agents.d/` context files and a per-harness settings and permission
policy for Claude Code, Codex, Gemini CLI, opencode and Warp. Only the context files hold up.
After more than a month of trying, the per-harness settings never reached a cluster. Hard
guardrails in first-party CLI harnesses leak: users can install their own copy, change the
config path, or switch modes. RCAC has dropped them as a goal. The site still says they are
deployed and enforced, which is wrong.

The context files exist for only three clusters: Gautschi, Gilbreth and Negishi. Anvil and
Scholar have no data model, so there is nothing to deploy there. The docs also
describe a delivery path that was never built: they say the assembled `AGENTS.md` is "symlinked
to the other well-known context filenames". With no managed settings, nothing on a cluster
points a harness at `/etc/agents.d/`. Users need to be told how to opt in.

## Outcome / vision

All five clusters (Anvil, Gautschi, Gilbreth, Negishi, Scholar) publish a correct,
generated set of `/etc/agents.d/` files, and the published files are what each cluster carries. Each
cluster's user guide has a *Using AI Agents* chapter that shows that cluster's context. The
Agentic AI section describes what RCAC actually ships: context, not control. It explains how a
user connects their harness to the context, and it carries a short note recording the policy
change. The prose is plain and instructional.

## Acceptance criteria (the contract)

**Context for every cluster**

- **R1** — For each of Anvil, Gautschi, Gilbreth, Negishi and Scholar, the site SHALL
  publish a generated `/etc/agents.d/` set: the five topic files and the assembled `AGENTS.md`.
  Its login host, OS, filesystems and scratch path, partitions, QOS and toolchain SHALL match
  that cluster's own user guide. A value the guide does not confirm SHALL be left out, and the
  file tells the agent to check it live.
- **R2** — IF a cluster lacks a command or convention the shared context assumes (for example
  `slist`, `sfeatures`, `findscratch`, `purgelist`, `$RCAC_SCRATCH`, a `standby` QOS, Data Depot
  or Fortress), THEN that cluster's context files SHALL name the cluster's own equivalent or omit
  the instruction. They SHALL never tell an agent to run a command, use a path, or request a
  QOS or partition that the cluster does not have.
- **R3** — WHEN a reader opens any of the five cluster user guides, its nav SHALL include a
  *Using AI Agents* chapter that shows that cluster's own assembled `AGENTS.md`, not another
  cluster's.

**Retire per-harness settings**

- **R4** — No page SHALL state or imply that RCAC deploys, manages, or enforces harness settings,
  permission policies, or managed configuration files for any harness. No settings JSON or TOML
  SHALL be published as an RCAC-deployed file.
- **R5** — WHEN a reader follows an existing link or bookmark to the *Harness Settings &
  Permissions* page, it SHALL resolve to a short stub. The stub says RCAC changed this policy
  after review and testing, that RCAC ships context only, and where to find the harness's own
  permission controls and RCAC's best practices.
- **R6** — The shared-context pages SHALL state how the context reaches an agent. RCAC places
  `/etc/agents.d/` on the cluster's login and compute nodes. An agent on the cluster loads it only after the
  user opts in, with a per-harness instruction shown for each CLI harness. Any statement about
  how a locally run agent receives it SHALL match the current behavior of the MCP server
  involved.
- **R7** — The generator SHALL emit only the context files. Running it on the committed inputs
  SHALL reproduce the committed `docs/snippets/agentic-ai/` tree exactly.

**Prose and build**

- **R8** — Pages in the Agentic AI section and the five *Using AI Agents* chapters SHALL state
  facts and instructions plainly. No slogans, rhetorical framing, or promotional phrasing
  (examples under Clarifications).
- **R9** — `mkdocs build --strict` SHALL report no new warnings and no build errors against the
  `main` baseline.

## Non-goals (no-gos)

- Any per-harness settings, permission policy, managed config, or managed MCP registration.
  This includes `/etc/claude-code/CLAUDE.md`. The policy has changed; it is not being reworked.
- The `xdu` / `xdu-find` rule in the context files. It lands with the system-wide `xdu` install
  so agents are never told to use a command that is missing.
- Deploying the files to the clusters. That is RCAC-internal work, tracked outside this repo.
- Code changes to `rcac-mcp` / `cluster-mcp` or `rcac-docs-mcp`.
- Bell, which retires in 2026 (see Clarifications).
- Geddes, Hammer and the storage guides (Depot, Fortress, Box, REED), which have no login nodes
  where agents run.
- A rewrite of the Agentic AI section beyond what R4–R8 require.
- The `dev` branch and its force-preserved files.

## Clarifications

- **Q:** With managed settings gone, how does context reach an agent on the cluster? — **A:**
  The user opts in, and the docs say how. RCAC deploys `/etc/agents.d/` and nothing else. The
  docs give each harness a one-line user-side hookup (resolved 2026-10-09).
- **Q:** Keep the old settings page? — **A:** Yes, as a stub that says the policy changed after
  review and testing (resolved 2026-10-09).
- **Q:** Include the `xdu` rule from the 2026-10-06 Agent-Ready HPC decision? — **A:** Not yet.
  It lands with the `xdu` install (resolved 2026-10-09).
- **Q:** Which clusters? — **A:** Anvil, Bell, Gautschi, Gilbreth, Negishi, Scholar
  (resolved 2026-10-09; amended below).
- **Q:** What counts as flowery (R8)? — **A:** For example: "absorbs the cluster's rules before
  you ask your first question"; "proactive engagement, not prohibition" used as a slogan; "a
  deliberate first draft — please push back"; bold or capitals used for emphasis instead of
  meaning. State the fact or the instruction instead (resolved 2026-10-09).

### Amendment 2026-10-09 (during `docs-plan`, directed by the human)

- **Bell is out of scope.** It retires in 2026. R1, R3 and R8 now cover five clusters: Anvil,
  Gautschi, Gilbreth, Negishi and Scholar. Re-confirmed R1, R3, R8.
- **`purgelist` is dropped from every cluster's context.** No cluster user guide documents it.
  This is an intended change to the three published sets. Re-confirmed R1, R2.
- **Anvil facts confirmed by RCAC staff** (where the Anvil guide is silent): scratch is
  `$SCRATCH`; the container runtime is Apptainer, with `singularity` kept as an alias; scratch
  files are purged at 30 days with no grace period or warning; containers mount `/anvil`,
  `/home` and `/tmp`. Re-confirmed R1, R2.

## Related materials

- Prior job: [`spec/agentic-ai-docs/`](../agentic-ai-docs/GOAL.md).
- Generator: `tools/generate_agent_context.py`; data models in `tools/agent_context/clusters/`;
  templates in `tools/agent_context/templates/`.
- Pages: `docs/agentic-ai/**`, `docs/userguides/{gautschi,gilbreth,negishi}/using_ai_agents.md`.
- Fact sources for the new clusters: `docs/userguides/{anvil,scholar}/`.
