---
tags:
  - Agentic AI
authors:
  - glentner
---

# Local, Targeting the Cluster

In this mode the agent runs where *you* are — on your laptop or workstation — and
reaches the cluster over the SSH access you already have. It is the recommended setup for
most users. Two mechanisms fit here, and they work differently:

- **Through the MCP servers** (Claude Code, Codex, Gemini CLI, opencode). The RCAC
  [`rcac-mcp`](../mcp_servers.md) server runs alongside your harness and bridges to the
  cluster over SSH. The agent works purely through **tool calls** — it never drives a
  terminal itself.
- **Through the Warp terminal** (Warp). Warp is a desktop terminal in which *you* SSH
  into the cluster, and its Agent Mode observes and acts within that live session. Warp
  does **not** use the cluster MCP server.

Either way, nothing new is installed on the cluster and no new credentials are created.

## The MCP-bridge architecture

For the four CLI harnesses, the `rcac-mcp` server runs as a subprocess of your harness
on your own machine and executes commands on the cluster over your existing
`~/.ssh/config` and keys. That design has three consequences worth stating plainly:

- **No new credentials.** The server adds no authentication layer of its own. It acts
  as you, over your SSH connection — the security boundary is the SSH session itself.
- **No hosted infrastructure.** Nothing is installed or left running on the cluster.
  The tooling lives on your machine; the cluster sees ordinary SSH commands.
- **Only the access you already have.** An agent connected this way can do exactly
  what you can do over SSH — no more. **If you can SSH to the cluster, your agent
  can too**, within the same permissions.

The agent also gets cluster-aware context automatically: `rcac-mcp` reads the host's
`/etc/agents.d/` files over SSH and injects them, so the agent knows the cluster's
partitions, filesystems, and policies without you installing anything.

### Connect `rcac-mcp` to your harness

The canonical `rcac-mcp` configuration points `--ssh-host` at your login node (the
examples below use `gautschi.rcac.purdue.edu` — substitute your cluster's host). Add it
to your harness in that harness's native format:

=== "Claude Code / Gemini CLI"

    These read an `mcpServers` JSON block (Claude Code in `.mcp.json`, Gemini CLI in
    `~/.gemini/settings.json`):

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

=== "Codex"

    Add a block to `~/.codex/config.toml`:

    ```toml
    [mcp_servers.rcac]
    command = "uvx"
    args = ["git+https://github.com/purduercac/rcac-mcp", "--ssh-host", "gautschi.rcac.purdue.edu"]
    ```

=== "opencode"

    Add a local server to `~/.config/opencode/opencode.json`:

    ```json
    {
      "mcp": {
        "rcac": {
          "type": "local",
          "command": ["uvx", "git+https://github.com/purduercac/rcac-mcp", "--ssh-host", "gautschi.rcac.purdue.edu"],
          "enabled": true
        }
      }
    }
    ```

`uvx` fetches and runs the server on demand, so there is no separate install step. The
full [settings and permission files](../shared_context/settings.md) for each harness —
including the shared context and starting-point deny/allow policy — are published in the
Shared Context & Settings pages of this section.

### The other two servers

- **`globus-mcp`** (data transfers) registers the same way, with
  `uvx git+https://github.com/purduercac/globus-mcp` as the command and no
  `--ssh-host` (it uses your browser-based Globus login on first use).
- **`rcac-docs-mcp`** (documentation search) is easiest as the hosted endpoint: point
  an HTTP-capable MCP client at `https://docs.rcac.purdue.edu/mcp` — no credentials
  required.

## Warp: the recommended workflow

Warp is RCAC's recommended harness for most users. It is a desktop terminal
application, so you run it on your workstation and SSH into the cluster *inside it*; its
Agent Mode then rides your live SSH session — reading `stdout`/`stderr` and issuing
commands in the session you opened. Because you are already SSH'd into the cluster,
Warp does **not** use the `rcac-mcp` bridge; the two are alternative ways to reach the
same cluster, not layers you combine.

Recommended workflow:

1. **Install Warp** on your workstation (macOS, Windows, or Linux) and sign in.
2. **SSH into the cluster** in a Warp terminal.
3. **Wire in the shared context.** Once you are on the cluster, RCAC's context lives at
   `/etc/agents.d/` (concatenated into an `AGENTS.md`). You can give it to Warp's agent
   by having the agent read those files at the start of a session, or by keeping the
   assembled `AGENTS.md` in the directory you work from. See
   [Shared Context & Settings](../shared_context/index.md).
4. **Keep the guardrails on.** Warp's built-in Agent Profile denylist already requires
   approval for `rm`, `curl`, `wget`, and `eval`; RCAC's recommended profile is on the
   [settings page](../shared_context/settings.md).

!!! warning "Run-until-completion bypasses the denylist"

    Warp's *Run-until-completion* mode **ignores the denylist entirely** — a real hazard
    on a cluster session. Avoid it on shared systems, and review commands before they
    run.

## Prior art: external tools over SSH

Reaching into the cluster from a locally-run tool is a well-worn path at RCAC. The
[VS Code on RCAC](../../lifesciences/guides/vscode.md) guide documents the same shape
for a different tool — Remote-SSH and ProxyJump from a local editor into a login or
compute node — and is a useful companion for setting up your SSH config cleanly before
you point an agent at it.

---

Back to [Running Agents](index.md).
