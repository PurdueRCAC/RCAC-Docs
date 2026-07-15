---
tags:
  - Agentic AI
authors:
  - glentner
---

# Context Files (`/etc/agents.d`)

These are the actual Gautschi shared-context files, published **verbatim** — the same
Markdown that is deployed to `/etc/agents.d/` on the cluster and injected into agents
by `rcac-mcp`. Each is written to the agent, in the shape *fact → correct
command/path → "do not…" → rationale*.

Volatile numbers (quotas, balances) are deliberately **not hardcoded**: the files tell
the agent to run `myquota` and `slist` and read the real values instead.

## `unix.md`

```markdown title="/etc/agents.d/unix.md"
--8<-- "docs/snippets/agentic-ai/agents.d/unix.md"
```

## `filesystems.md`

```markdown title="/etc/agents.d/filesystems.md"
--8<-- "docs/snippets/agentic-ai/agents.d/filesystems.md"
```

## `lmod.md`

```markdown title="/etc/agents.d/lmod.md"
--8<-- "docs/snippets/agentic-ai/agents.d/lmod.md"
```

## `slurm.md`

```markdown title="/etc/agents.d/slurm.md"
--8<-- "docs/snippets/agentic-ai/agents.d/slurm.md"
```

## `policies.md`

```markdown title="/etc/agents.d/policies.md"
--8<-- "docs/snippets/agentic-ai/agents.d/policies.md"
```

## The assembled `AGENTS.md`

On the cluster, the files above are concatenated into a single `AGENTS.md` and
symlinked to each harness's context filename. This is the exact assembled file an
on-cluster agent reads:

??? note "Show the concatenated `AGENTS.md`"

    ```markdown title="AGENTS.md (assembled)"
    --8<-- "docs/snippets/agentic-ai/agents.d/AGENTS.md"
    ```

---

Back to [Shared Context & Settings](index.md).
