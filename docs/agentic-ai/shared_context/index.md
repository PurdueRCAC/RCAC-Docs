---
title: Shared Context & Settings
tags:
  - Agentic AI
authors:
  - glentner
---

# Shared Context & Settings

To make agents reliable on our systems, RCAC gives them two things up front: **shared
context** that describes the cluster, and **per-harness settings** that encode a
sensible permission policy. This section publishes both, verbatim, as the canonical
source of truth — so you can see exactly what your agent is told and how it is
constrained, and so you can help improve it.

## What `/etc/agents.d` is

`/etc/agents.d/` is a directory of Markdown files on the cluster that describe Gautschi
*to an agent*: the operating environment, the filesystems, the module system, the
scheduler, and the policies. Agentic tools already look for context files in
well-known locations; `/etc/agents.d` is how RCAC supplies cluster-specific facts and
prohibitions so the agent "absorbs the cluster's rules before you ask your first
question."

Each file follows the same shape: **a fact → the correct command or path → an explicit
"do not…" → the rationale.** They are written to the agent, not to you.

## Canonical source of truth

The files published here are the **single source of truth**. They reach a running agent
two ways, depending on how you work:

- **On the cluster.** Cluster configuration management (Puppet) copies these files out
  to `/etc/agents.d/` on the Gautschi hosts, where they are concatenated into a single
  `AGENTS.md` and symlinked to the other well-known context filenames (`CLAUDE.md`,
  `GEMINI.md`, …) that each harness reads.
- **Locally.** The `rcac-mcp` server reads `/etc/agents.d/` over your SSH connection
  and injects the concatenated context to your agent as a read-only resource — so a
  locally-run agent gets the same guidance without you installing anything.

Because this repository is canonical, editing the files here is how the deployed
context changes.

## How to contribute feedback

This is early, evolving work, and the context and settings improve fastest with input
from the people using them. If a fact is wrong, a prohibition is missing, or a setting
is too strict or too loose:

- Open an issue or pull request on the
  [RCAC-Docs repository](https://github.com/PurdueRCAC/RCAC-Docs).
- Email [rcac-help@purdue.edu](mailto:rcac-help@purdue.edu).
- Reach the team on [Discord](https://discord.gg/RmtKZmaQW9).

<div class="grid cards" markdown>

-   :material-file-document-multiple:{ .lg .middle } __Context Files (`/etc/agents.d`)__

    ---

    The five Gautschi context files — `unix`, `filesystems`, `lmod`, `slurm`, and
    `policies` — published verbatim.

    [:octicons-arrow-right-24: Context Files](context_files.md)

-   :material-cog:{ .lg .middle } __Harness Settings & Permissions__

    ---

    A starting-point settings file for each of the five harnesses: allow-list the
    sanity commands, deny destructive operations.

    [:octicons-arrow-right-24: Harness Settings & Permissions](settings.md)

</div>

---

Back to [Agentic AI](../index.md).
