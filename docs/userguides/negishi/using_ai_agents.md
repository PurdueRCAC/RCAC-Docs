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

Agentic coding tools (Claude Code, Codex, Gemini CLI, opencode and Warp) work better on
{{ resource }} when they have accurate, cluster-specific context. This chapter covers what
is specific to {{ resource }}. The concepts, policy, MCP servers and shared context are in
the [Agentic AI](../../agentic-ai/index.md) section, and everything there applies here.

Read [Acceptable Use & Etiquette](../../agentic-ai/acceptable_use.md) and
[Best Practices & Limitations](../../agentic-ai/best_practices.md) before you start.

## Choose how you run the agent

The [Running Agents](../../agentic-ai/running_agents/index.md) pages cover both ways for all
five harnesses:

- **[On the cluster](../../agentic-ai/running_agents/on_cluster.md):** install a CLI harness
  (Claude Code, Codex, Gemini CLI or opencode) on a {{ resource }} login node and run it
  there.
- **[Locally, targeting the cluster](../../agentic-ai/running_agents/local.md):** run the
  harness on your own machine and reach {{ resource }} over SSH (host
  `{{ resource | lower }}.rcac.purdue.edu`) through the RCAC MCP servers. This is the
  recommended setup, and the only way to use Warp, a desktop app that does not run on a
  login node.

## {{ resource }}'s context files

RCAC places a set of context files in `/etc/agents.d/` on {{ resource }}'s login and
compute nodes. They cover the partitions, GPUs, filesystems and toolchain that
general-purpose models most often get wrong, and they are generated from the facts in this
user guide (for example its `cpu`, `highmem` and `gpu` partitions and its AMD MI210 GPUs). To have your harness load them in every session, see
[Load the context in your harness](../../agentic-ai/shared_context/index.md#load-the-context-in-your-harness).
[Context Files](../../agentic-ai/shared_context/context_files.md) explains how the files are
structured.

This is {{ resource }}'s assembled `/etc/agents.d/AGENTS.md`:

??? note "Show {{ resource }}'s assembled `AGENTS.md`"

    ```markdown title="/etc/agents.d/AGENTS.md ({{ resource }})"
    --8<-- "docs/snippets/agentic-ai/negishi/agents.d/AGENTS.md"
    ```

!!! important

    Do NOT run large, long, multi-threaded, parallel, or CPU-intensive jobs on a front-end
    login host. Always use Slurm to submit your work as a job. This applies to anything heavy
    an agent does on your behalf, as it does to you.

---

Back to the [Negishi User Guide](index.md).
