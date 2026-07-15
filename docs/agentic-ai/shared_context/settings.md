---
tags:
  - Agentic AI
authors:
  - glentner
---

# Harness Settings & Permissions

Alongside the shared [context files](context_files.md), RCAC configures a
starting-point permission policy for each of the five harnesses. **These are the
cluster-side settings** — what RCAC applies for an agent running **on the Gautschi
nodes**. Wherever a harness supports it, RCAC deploys them to the system-managed
location and **enforces** them; they are already in effect, and you do not install them
yourself. We publish them here for **transparency**: so you can see exactly what your
agent is and is not allowed to do.

Every policy does two things: it **allow-lists the read-only sanity commands**
(`myquota`, `slist`, `sfeatures`, `module list`, `module avail`) so the agent runs them
eagerly without stopping to ask, and it **denies the most dangerous operations**
(`rm -rf`, `sudo`).

!!! info "Cluster-side vs. local-side — which MCP server goes where"

    These settings are for an agent running **on the cluster**, so they do **not**
    register the `rcac-mcp` server. `rcac-mcp` is a **local-side** tool: it bridges an
    agent running on *your own machine* to the cluster over SSH, and it launches via
    `uvx`, which is not on the nodes' default `PATH`. An agent already on the cluster
    has direct shell and Slurm access and does not need that bridge. If you instead run
    a CLI harness on your laptop, register `rcac-mcp` as shown on the
    [Local page](../running_agents/local.md).

    What the cluster-side settings *do* wire in is the **documentation MCP server** —
    the hosted, no-authentication endpoint `https://docs.rcac.purdue.edu/mcp`
    (`doc_search` / `doc_load`), reached over plain HTTP with **no local tooling**. That
    lets an on-cluster agent consult the authoritative docs on top of the
    `/etc/agents.d` context it already has.

!!! note "A v0 starting point — please push back"

    This is a **deliberate first draft**, not a finished policy. Permissions do not
    port across harnesses — each format is different — so these are parallel
    translations of one intent. If a rule is too strict, too loose, or wrong for your
    work, tell us (see [how to contribute](index.md)).

!!! warning "Where enforcement lives — and where it can't"

    Cluster-wide enforcement requires a system-managed configuration path. **Claude
    Code, Gemini CLI, and opencode have one**, so RCAC deploys the policy there and a
    user cannot override it. **Codex has no system-managed path**, so its settings are a
    recommended default you adopt yourself. **Warp has no settings file at all** — its
    policy is a team-managed Agent Profile (below). Note also that the harnesses'
    OS-level sandboxes are frequently **unavailable on shared login nodes**, so the
    permission/approval rules — not the sandbox — are the real control, with writable
    roots pointed at `$RCAC_SCRATCH`.

## Claude Code

RCAC deploys this to the managed **`/etc/claude-code/managed-settings.json`**, where it
is enforced: Claude Code evaluates `permissions` in the order **deny → ask → allow**,
and a deny at the managed scope cannot be overridden. The shared context is bridged by
importing `@AGENTS.md` from a managed `CLAUDE.md` (Claude Code does not read `AGENTS.md`
natively).

```json title="/etc/claude-code/managed-settings.json"
--8<-- "docs/snippets/agentic-ai/claude/settings.json"
```

Claude Code keeps MCP servers in `.mcp.json` rather than `settings.json`. The cluster-
side docs server is the hosted HTTP endpoint — no local command needed:

```json title=".mcp.json (documentation server)"
{
  "mcpServers": {
    "rcac-docs": { "type": "http", "url": "https://docs.rcac.purdue.edu/mcp" }
  }
}
```

(To run a harness *locally* and reach the cluster, register `rcac-mcp` instead — see
the [Local page](../running_agents/local.md).)

## Codex

Codex has **no system-managed configuration path**, so RCAC cannot enforce this
centrally the way it can for Claude Code and Gemini. Instead this is the **recommended
user config** — adopt it as `~/.codex/config.toml`. Codex also has no per-command
allow/deny list; its safety comes from the `approval_policy` and `sandbox_mode`. On
nodes without `bubblewrap`, the OS sandbox will not engage — fall back to
`approval_policy = "untrusted"` and `sandbox_mode = "read-only"`. Codex reads
`AGENTS.md` natively for the shared context, and the only MCP server is the hosted docs
endpoint over HTTP.

```toml title="~/.codex/config.toml (recommended)"
--8<-- "docs/snippets/agentic-ai/codex/config.toml"
```

## Gemini CLI

RCAC deploys this to the system path **`/etc/gemini-cli/settings.json`**, which has the
final say over user and project settings. Gemini controls the shell tool with
prefix-matched allow (`tools.core`) and deny (`tools.exclude`) lists; the exclude list
wins, and chained commands are split so any disallowed part blocks the whole line.
`context.fileName` is set to read `AGENTS.md`, and `mcpServers` registers the docs
endpoint over HTTP (`httpUrl`).

```json title="/etc/gemini-cli/settings.json"
--8<-- "docs/snippets/agentic-ai/gemini/settings.json"
```

## opencode

RCAC deploys this to the system location **`/etc/opencode/`**. opencode matches bash
patterns with **last-match-wins**, so the catch-all `"*": "ask"` must come **first**,
followed by the specific allow and deny rules. opencode reads `AGENTS.md` natively, and
its `mcp` block registers the docs endpoint as a remote HTTP server.

```json title="/etc/opencode/opencode.json"
--8<-- "docs/snippets/agentic-ai/opencode/opencode.json"
```

## Warp

Warp has **no server-side settings file** to deploy. Its permission policy is an
**Agent Profile**, configured in the app and shareable as a team-managed profile; RCAC's
recommended profile mirrors the same intent as the files above:

- **Allow** (auto-run, no confirmation): `myquota`, `slist`, `sfeatures`, and
  `module\s+(list|avail).*`.
- **Deny** (always require approval): `rm\s+-rf.*` and `sudo.*`. Warp's built-in
  denylist already covers `rm`, `curl`, `wget`, and `eval`; the denylist beats both the
  allowlist and "Agent decides."

Because you SSH into the cluster yourself in Warp (see the
[Local page](../running_agents/local.md)), Warp does not use `rcac-mcp`. To give it the
shared context, wire in the cluster's `/etc/agents.d` files once you are on the host.

!!! warning "Run-until-completion bypasses the denylist"

    Warp's *Run-until-completion* mode ignores the denylist entirely — avoid it on
    shared cluster sessions.

---

Back to [Shared Context & Settings](index.md).
