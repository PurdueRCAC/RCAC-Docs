---
tags:
  - Agentic AI
authors:
  - glentner
---

# Context Files (`/etc/agents.d`)

Each RCAC cluster has a set of context files in `/etc/agents.d/`. Each is written for the
agent, in the shape fact, correct command or path, "do not…", reason. They are generated per
cluster from a single data model, so the partitions, GPUs, filesystems and toolchain are
correct for the machine the agent is on.

The files below are Gautschi's, shown as an example. Each cluster's *Using AI Agents* chapter
shows its own assembled file: [Anvil](../../userguides/anvil/using_ai_agents.md),
[Gautschi](../../userguides/gautschi/using_ai_agents.md),
[Gilbreth](../../userguides/gilbreth/using_ai_agents.md),
[Negishi](../../userguides/negishi/using_ai_agents.md) and
[Scholar](../../userguides/scholar/using_ai_agents.md).

Numbers that change (quotas, balances) are not in the files. The files tell the agent to
run the cluster's quota and account commands and read the real values.

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

The topic files are also combined into `/etc/agents.d/AGENTS.md`. This is the file the
[per-harness setup](index.md#load-the-context-in-your-harness) loads:

??? note "Show the concatenated `AGENTS.md`"

    ```markdown title="/etc/agents.d/AGENTS.md"
    --8<-- "docs/snippets/agentic-ai/gautschi/agents.d/AGENTS.md"
    ```

---

Back to [Shared Context](index.md).
