---
tags:
  - Gautschi
authors:
  - glentner
resource: Gautschi
search:
  boost: 2
---

# Using AI Agents on {{ resource }}

Agentic coding tools — Claude Code, Codex, Gemini CLI, opencode, and Warp — work well
on {{ resource }} when they are set up with accurate, cluster-specific context. This
chapter is the {{ resource }}-specific quick-start; the concepts, policy, MCP servers,
and shared context live in the top-level
[Agentic AI](../../agentic-ai/index.md) section, and everything there applies here.

RCAC's stance is **proactive engagement, not prohibition**: we shape the context so an
agent's output is more likely to be correct for {{ resource }}, and we help you
**verify** it rather than forbidding the tools. Start with
[Acceptable Use & Etiquette](../../agentic-ai/acceptable_use.md) and
[Best Practices & Limitations](../../agentic-ai/best_practices.md).

## {{ resource }} facts your agent needs

Give (or let the agent discover) these {{ resource }}-specific facts — they are what
general-purpose models most often get wrong:

- **Login host:** `gautschi.rcac.purdue.edu` (SSH keys or Purdue Login MFA). See
  [Accounts](accounts.md) for access setup.
- **Check accounts and quota first.** Run `slist` to see the accounts you can charge
  and their balances, and `myquota` for home and scratch usage. Don't hardcode an
  account name or quota number — read them at runtime.
- **Every job needs four parts.** Resources, an account (`-A`, from `slist`), a QOS
  (`-q`), and a **partition (`-p`)** — on {{ resource }} you must set **both `-A` and
  `-p`** explicitly. Always add a `--time` limit.
- **Partitions:** `cpu`, `ai` (H100 GPUs), `smallgpu` (L40S GPUs), `highmem`, and
  `profiling`. **QOS:** `normal` (default, charged), `standby` (free, idle, 4 h max —
  request with `-q standby`, it is *not* an account), and `preemptible` (the `ai`
  partition only). See [Running Jobs](run_jobs/index.md) and the
  [queues guide](run_jobs/queues.md) for the details.
- **Filesystems:** `$HOME` (ZFS, snapshotted) for code; `$RCAC_SCRATCH`
  (`/scratch/gautschi/$USER`, Lustre, **not backed up, 60-day purge**) for job I/O —
  point an agent's working files here. See
  [File Storage and Transfer](storage.md).
- **Software** comes from environment modules (`module avail`, `module spider`,
  `module load`), not the system package manager. See [Software](software.md).

!!! important

    Do NOT run large, long, multi-threaded, parallel, or CPU-intensive jobs on a
    front-end login host. Always use Slurm to submit your work as a job — this applies
    to anything heavy an agent does on your behalf, exactly as it does to you.

## Choose how you run the agent

The [Running Agents](../../agentic-ai/running_agents/index.md) pages cover both
deployment modes for all five harnesses:

- **[On the cluster](../../agentic-ai/running_agents/on_cluster.md)** — install a CLI
  harness (Claude Code, Codex, Gemini CLI, or opencode) on a {{ resource }} login node
  and run it there.
- **[Locally, targeting the cluster](../../agentic-ai/running_agents/local.md)** — run
  the harness on your own machine and reach {{ resource }} over SSH through the RCAC
  MCP servers. This is the recommended path, and the only way to use **Warp** (a
  desktop app that cannot run on a login node).

## Connect the MCP servers and shared context

The [RCAC MCP servers](../../agentic-ai/mcp_servers.md) give an agent tools that know
{{ resource }} — `rcac-mcp` runs Slurm and storage commands over your SSH connection
and injects the cluster's shared context; `rcac-docs-mcp` searches this documentation.

The exact context files and per-harness permission settings RCAC deploys are published
verbatim under [Shared Context & Settings](../../agentic-ai/shared_context/index.md) —
including the [Gautschi context files](../../agentic-ai/shared_context/context_files.md)
and the [starting-point settings](../../agentic-ai/shared_context/settings.md) that
allow-list `slist`/`myquota` and deny `rm -rf`/`sudo`.

---

Back to the [Gautschi User Guide](index.md).
