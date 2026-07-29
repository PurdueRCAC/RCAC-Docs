---
tags:
  - Negishi
authors:
  - glentner
resource: Negishi
search:
  boost: 2
---

# Using AI Agents on {{ resource }}

Agentic coding tools — Claude Code, Codex, Gemini CLI, opencode, and Warp — work well
on {{ resource }} when they are set up with accurate, cluster-specific context. This
chapter is the {{ resource }}-specific quick-start; the concepts, policy, MCP servers,
and shared-context model live in the top-level
[Agentic AI](../../agentic-ai/index.md) section, and everything there applies here.

RCAC's stance is **proactive engagement, not prohibition**: we shape the context so an
agent's output is more likely to be correct for {{ resource }}, and we help you
**verify** it rather than forbidding the tools. Start with
[Acceptable Use & Etiquette](../../agentic-ai/acceptable_use.md) and
[Best Practices & Limitations](../../agentic-ai/best_practices.md).

## Choose how you run the agent

The [Running Agents](../../agentic-ai/running_agents/index.md) pages cover both
deployment modes for all five harnesses:

- **[On the cluster](../../agentic-ai/running_agents/on_cluster.md)** — install a CLI
  harness (Claude Code, Codex, Gemini CLI, or opencode) on a {{ resource }} login node
  and run it there.
- **[Locally, targeting the cluster](../../agentic-ai/running_agents/local.md)** — run
  the harness on your own machine and reach {{ resource }} over SSH (host
  `{{ resource | lower }}.rcac.purdue.edu`) through the RCAC MCP servers. This is the
  recommended path, and the only way to use **Warp** (a desktop app that cannot run on a
  login node).

## {{ resource }}'s shared context

RCAC deploys a set of context files to `/etc/agents.d/` on {{ resource }} — the
partitions, GPUs, filesystems, and toolchain that general-purpose models most often get
wrong — and `rcac-mcp` injects them into an agent. They are **generated from
{{ resource }}'s verified facts** (its `cpu`/`highmem`/`gpu` partitions, AMD MI210 GPUs,
and GPFS home), so an agent that reads them targets the right partitions and writes to
the right filesystems. See
[Context Files](../../agentic-ai/shared_context/context_files.md) for how the files are
structured and [Harness Settings & Permissions](../../agentic-ai/shared_context/settings.md)
for the per-harness permission policy.

This is the exact assembled context an on-cluster agent reads on {{ resource }}:

??? note "Show {{ resource }}'s assembled `AGENTS.md`"

    ```markdown title="AGENTS.md ({{ resource }})"
    --8<-- "docs/snippets/agentic-ai/negishi/agents.d/AGENTS.md"
    ```

The cluster-side permission policy for Claude Code allow-lists `slist`/`myquota`, denies
`rm -rf`/`sudo`, and points writable scope at {{ resource }}'s scratch:

```json title="/etc/claude-code/managed-settings.json"
--8<-- "docs/snippets/agentic-ai/negishi/claude/settings.json"
```

!!! important

    Do NOT run large, long, multi-threaded, parallel, or CPU-intensive jobs on a
    front-end login host. Always use Slurm to submit your work as a job — this applies
    to anything heavy an agent does on your behalf, exactly as it does to you.

---

Back to the [Negishi User Guide](index.md).
