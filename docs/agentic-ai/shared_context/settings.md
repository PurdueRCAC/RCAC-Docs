---
tags:
  - Agentic AI
authors:
  - glentner
---

# Harness Settings & Permissions

Alongside the shared [context files](context_files.md), RCAC publishes a starting-point
**settings file for each of the five harnesses**. Every one does two
things: it **allow-lists the read-only sanity commands** (`myquota`, `slist`,
`sfeatures`, `module list`, `module avail`) so the agent runs them eagerly without
stopping to ask, and it **denies the most dangerous operations** (`rm -rf`, `sudo`).

!!! note "A v0 starting point — please push back"

    These are a **deliberate first draft**, not a finished policy. Permissions do not
    port across harnesses — each format is different — so these are five parallel
    translations of one intent. If a rule is too strict, too loose, or wrong for your
    work, tell us (see [how to contribute](index.md)).

!!! warning "Where enforcement actually lives"

    A file in your home directory is a *default*, not a guarantee — you can override
    your own settings. Cluster-wide enforcement lives in the **managed/system**
    locations: `/etc/claude-code/managed-settings.json` for Claude Code and
    `/etc/gemini-cli/settings.json` for Gemini CLI (a deny at the managed scope cannot
    be overridden). Note too that the harnesses' OS-level sandboxes are frequently
    **unavailable on shared login nodes**, so treat the permission/approval rules — not
    the sandbox — as the real control, and point writable roots at `$RCAC_SCRATCH`.

## Claude Code — `settings.json`

Claude Code evaluates `permissions` in the order **deny → ask → allow**, so the denied
operations win. Deploy this as the managed `/etc/claude-code/managed-settings.json` for
cluster-wide enforcement, or as `~/.claude/settings.json` per user. Register
`rcac-mcp` separately in `.mcp.json` (see the
[Local page](../running_agents/local.md)), and bridge the shared
context by importing `@AGENTS.md` from `CLAUDE.md` (or symlinking `CLAUDE.md` →
`AGENTS.md`), since Claude Code does not read `AGENTS.md` natively.

```json title="~/.claude/settings.json"
--8<-- "docs/snippets/agentic-ai/claude/settings.json"
```

## Codex — `config.toml`

Codex has **no per-command allow/deny list**; its safety comes from the
`approval_policy` and `sandbox_mode`. The config below asks for approval on request and
confines writes to scratch. On nodes without `bubblewrap`, the OS sandbox will not
engage — fall back to `approval_policy = "untrusted"` and `sandbox_mode = "read-only"`.
Codex reads `AGENTS.md` natively for the shared context.

```toml title="~/.codex/config.toml"
--8<-- "docs/snippets/agentic-ai/codex/config.toml"
```

## Gemini CLI — `settings.json`

Gemini controls the shell tool with prefix-matched allow (`tools.core`) and deny
(`tools.exclude`) lists; the exclude list wins, and chained commands are split so any
disallowed part blocks the whole line. `context.fileName` is set to read `AGENTS.md`.
For cluster-wide enforcement deploy this to the system path
`/etc/gemini-cli/settings.json`.

```json title="~/.gemini/settings.json"
--8<-- "docs/snippets/agentic-ai/gemini/settings.json"
```

## opencode — `opencode.json`

opencode matches bash patterns with **last-match-wins**, so the catch-all `"*": "ask"`
must come **first**, followed by the specific allow and deny rules. opencode reads
`AGENTS.md` natively.

```json title="~/.config/opencode/opencode.json"
--8<-- "docs/snippets/agentic-ai/opencode/opencode.json"
```

## Warp — Agent Profile + `AGENTS.md`

Warp has **no server-side settings file**. Its configuration is a repository
`AGENTS.md` (read automatically) plus an Agent Profile with a regex allow/deny list set
in the app. Note that Warp's *Run-until-completion* mode bypasses the denylist — avoid
it on shared systems.

```markdown title="Warp — AGENTS.md + Agent-Profile guidance"
--8<-- "docs/snippets/agentic-ai/warp/AGENTS.md"
```

---

Back to [Shared Context & Settings](index.md).
