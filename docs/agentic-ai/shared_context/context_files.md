---
tags:
  - Agentic AI
authors:
  - glentner
---

# Context Files (`/etc/agents.d`)

Every RCAC cluster ships a small set of **shared-context files** under `/etc/agents.d/` —
plain Markdown deployed to the cluster and injected into agents by `rcac-mcp`. Each is
written for the agent, in the shape *fact → correct command/path → "do not…" →
rationale*. They are **generated per cluster** from a single data model, so the
partitions, GPUs, filesystems, and toolchain are correct for the machine the agent is
on.

The files below are **Gautschi's**, shown as the worked example. Each cluster publishes
its own set under *Using AI Agents* in its user guide — for example
[Negishi](../../userguides/negishi/using_ai_agents.md) and
[Gilbreth](../../userguides/gilbreth/using_ai_agents.md).

Volatile numbers (quotas, balances) are deliberately **not hardcoded**: the files tell
the agent to run `myquota` and `slist` and read the real values instead.

## `unix.md`

```markdown title="/etc/agents.d/unix.md"
--8<-- "docs/snippets/agentic-ai/gautschi/agents.d/unix.md"
```

## `filesystems.md`

```markdown title="/etc/agents.d/filesystems.md"
--8<-- "docs/snippets/agentic-ai/gautschi/agents.d/filesystems.md"
```

## `lmod.md`

```markdown title="/etc/agents.d/lmod.md"
--8<-- "docs/snippets/agentic-ai/gautschi/agents.d/lmod.md"
```

## `slurm.md`

```markdown title="/etc/agents.d/slurm.md"
--8<-- "docs/snippets/agentic-ai/gautschi/agents.d/slurm.md"
```

## `policies.md`

```markdown title="/etc/agents.d/policies.md"
--8<-- "docs/snippets/agentic-ai/gautschi/agents.d/policies.md"
```

## The assembled `AGENTS.md`

On the cluster, the files above are concatenated into a single `AGENTS.md` and
symlinked to each harness's context filename. This is the exact assembled file an
on-cluster agent reads:

??? note "Show the concatenated `AGENTS.md`"

    ```markdown title="AGENTS.md (assembled)"
    --8<-- "docs/snippets/agentic-ai/gautschi/agents.d/AGENTS.md"
    ```

---

Back to [Shared Context & Settings](index.md).
