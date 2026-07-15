---
tags:
  - Agentic AI
authors:
  - glentner
---

# RCAC MCP Servers

The [Model Context Protocol](https://modelcontextprotocol.io/) (MCP) is an open
standard that lets an agent call external tools and read external context through a
uniform interface. RCAC builds and maintains MCP servers so that an agent working on
your behalf has **context that knows our clusters** — it can check your real quota,
list your actual Slurm accounts, submit and monitor jobs, search the authoritative
documentation, and move data, instead of guessing from general knowledge.

This is the fix for the failure mode at the heart of agentic HPC: an agent that
confidently writes a submission script for a scheduler we don't run. Connected to
these servers, the agent grounds its answers in the live state of the system.

!!! note "Prototypes under active development"

    All three servers below are **working prototypes under active development**. They
    are open source and usable today, but their tool sets, names, and interfaces
    **will change over time**. Treat what follows as the current state, not a frozen
    contract, and see the feedback note at the end of this page.

RCAC currently publishes three servers:

| Server | What it does | Transport |
|--------|--------------|-----------|
| `rcac-mcp` | HPC cluster & storage operations | local stdio, over your SSH |
| `globus-mcp` | Data transfers and remote compute (Globus) | local stdio, your Globus login |
| `rcac-docs-mcp` | Full-text search of this documentation site | hosted HTTP, or local stdio |

## `rcac-mcp` — HPC operations

**Repository:** <https://github.com/PurdueRCAC/rcac-mcp>

`rcac-mcp` enables agentic development with RCAC's HPC clusters and storage services.
It gives an agent tools to run shell commands, read and write files, inspect storage
quota, and drive Slurm — all executed **on the cluster over your existing SSH
connection**.

The default mode is **local-first**: the server runs as a `stdio` subprocess on your
own machine and executes everything on the cluster over your existing `~/.ssh/config`
and keys. It introduces **no new service and no new credential** — the security
boundary is the SSH connection you already have. If you can SSH to the cluster, your
agent can too, and only with the access you already hold.

The agent works entirely through **tool calls** — it asks the server to run a command,
submit a job, or read a file, and the server carries that out over the SSH connection,
which stays a background transport. The agent is not driving an interactive terminal.
(This differs from a terminal-based harness like Warp, where you open the SSH session
yourself and the agent rides along in it — see [Running Agents](running_agents/local.md).)

Add it to an MCP-capable harness with the server's canonical configuration block,
pointing `--ssh-host` at your cluster login node:

```json
{
  "mcpServers": {
    "rcac": {
      "command": "uvx",
      "args": ["git+https://github.com/purduercac/rcac-mcp", "--ssh-host", "gautschi.rcac.purdue.edu"]
    }
  }
}
```

`uvx` fetches, builds, and runs the server in one step, so there is no separate
install. (You may instead set `RCAC_SSH_HOST` in the environment and omit
`--ssh-host`.) Per-harness registration details are on the
[Running Agents](running_agents/local.md) pages.

### Tools it exposes

The server groups its tools by area (names may evolve):

- **Shell & files:** `run_command`, `list_directory`, `read_file`, `write_file`,
  `upload_file`, `download_file`.
- **Cluster & storage:** `myquota`, `storage_paths`, `jobinfo`, `jobscript`,
  `showpartitions`, `average_wait`.
- **Slurm:** `sbatch`, `squeue`, `scancel`, `sacct`, `sinfo`, `scontrol_show_job`,
  `scontrol_show_node`, plus RCAC-specific `slist` (your accounts and balances) and
  `sfeatures` (node hardware features).

### It injects the cluster's shared context

`rcac-mcp` also reads the cluster's **shared context files** and hands them to the
agent. Over the same SSH connection, it collects the markdown files in
`/etc/agents.d/` on the host (a configurable location), concatenates them, and
exposes the result to the agent as a read-only resource named `rcac://context`.

This is how the [context files](shared_context/context_files.md) RCAC publishes reach a
locally-run agent without you installing anything: the cluster maintains them, and the
server injects them at connect time. See
[Shared Context & Settings](shared_context/index.md) for what those files contain.

!!! info "A planned direction, not a shipped fact"

    RCAC intends to **refocus `rcac-mcp` on HPC operations only** and re-architect it
    around a **generalized plugin model** — for example
    `cluster-mcp[slurm,lmod,…]`, where scheduler, module-system, and other
    capabilities become installable extensions. This is a **stated direction for the
    project, not something that has shipped**: today's public `rcac-mcp` is the
    single prototype described above (it still bundles the documentation-search tools
    that now also live in `rcac-docs-mcp`). Expect the name and structure to change;
    follow the repository for the current state.

## `globus-mcp` — data transfers

**Repository:** <https://github.com/PurdueRCAC/globus-mcp>

`globus-mcp` gives an agent federated data transfer and remote code execution across
research storage systems, by wrapping the Globus CLI and the Globus Compute SDK. An
agent can search endpoints, browse remote filesystems, run asynchronous transfers,
and submit Python functions to Compute endpoints.

!!! warning "Beta software"

    `globus-mcp` is **beta**: its APIs, tool signatures, and behavior may change
    without notice. Use it with caution in production workflows.

Like `rcac-mcp`, it runs as a local `stdio` subprocess and uses **your own Globus
identity** — on first use its `globus_login()` and `compute_login()` tools walk you
through browser-based OAuth. No new RCAC-hosted credential is introduced.

```json
{
  "mcpServers": {
    "globus": {
      "command": "uvx",
      "args": ["git+https://github.com/purduercac/globus-mcp"]
    }
  }
}
```

Its tools cover identity (`whoami`, `globus_login`), endpoints (`endpoint_search`,
`endpoint_show`), filesystem operations (`ls`, `stat`, `mkdir`, `rename`, `rm`,
`delete`), transfers (`transfer`, `transfer_batch`, `task_*`), and remote Compute
(`compute_submit`, `compute_status`, `compute_result`).

## `rcac-docs-mcp` — documentation search

**Repository:** <https://github.com/PurdueRCAC/rcac-docs-mcp>

`rcac-docs-mcp` is a single-purpose server that exposes **this documentation site**
to an agent through full-text search, so the agent grounds its advice in current,
authoritative RCAC docs rather than general knowledge. It indexes the user guides,
software catalog, datasets, blog posts, and workshops and exposes exactly two tools:

- `doc_search(query, category=None)` — full-text search returning ranked results with
  path, title, heading, and a matching snippet. `category` filters by section
  (`userguides`, `software`, `datasets`, `blog`, `workshops`).
- `doc_load(path)` — return the full markdown of one document by its path.

The easiest way to use it is the **hosted instance at
`https://docs.rcac.purdue.edu/mcp`** — a shared, no-authentication HTTP endpoint.
Point any HTTP-capable MCP client at that URL; no token or credentials are required.
Unlike the other two servers, this one does not SSH anywhere and needs no user
credentials — it only reads a search index — which is why it can be safely public.

You can also run it locally as a `stdio` subprocess (it builds a local index first):

```json
{
  "mcpServers": {
    "rcac-docs": {
      "command": "uvx",
      "args": ["git+https://github.com/PurdueRCAC/rcac-docs-mcp"]
    }
  }
}
```

## Status and feedback

These servers are early, evolving work, and we publish them openly precisely so the
community can shape them. All three are MIT-licensed; issues and pull requests are
welcome on their repositories, and you can reach the team at
[rcac-help@purdue.edu](mailto:rcac-help@purdue.edu) or on
[Discord](https://discord.gg/RmtKZmaQW9).

---

Back to [Agentic AI](index.md).
