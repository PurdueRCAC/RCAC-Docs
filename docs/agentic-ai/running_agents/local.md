---
tags:
  - Agentic AI
authors:
  - glentner
---

# Local, Targeting the Cluster

In this mode the agent runs on your laptop or workstation and reaches the cluster over the
SSH access you already have. It is the recommended setup for most users. There are two ways
to do it:

- **Through the MCP servers** (Claude Code, Codex, Gemini CLI, opencode). The RCAC
  [`rcac-mcp`](../mcp_servers.md) server runs alongside your harness and bridges to the
  cluster over SSH. The agent works through tool calls; it never drives a terminal itself.
- **Through the Warp terminal** (Warp). Warp is a desktop terminal in which you SSH into the
  cluster, and its agent works in that session. Warp does not use the cluster MCP server.

Either way, nothing new is installed on the cluster and no new credentials are created.

## The MCP-bridge architecture

For the four CLI harnesses, the `rcac-mcp` server runs as a subprocess of your harness
on your own machine and executes commands on the cluster over your existing
`~/.ssh/config` and keys. This means:

- **No new credentials.** The server adds no authentication layer of its own. It acts
  as you, over your SSH connection; the security boundary is the SSH session itself.
- **No hosted infrastructure.** Nothing is installed or left running on the cluster.
  The tooling lives on your machine; the cluster sees ordinary SSH commands.
- **Only the access you already have.** An agent connected this way can do exactly
  what you can do over SSH, and no more.

`rcac-mcp` also offers the cluster's `/etc/agents.d/*.md` context files as a read-only MCP
resource, `rcac://context`. The agent sees it only when it reads that resource or you attach
it (in Claude Code, type `@rcac:rcac://context` in a prompt). See
[MCP Servers](../mcp_servers.md).

### Connect `rcac-mcp` to your harness

The canonical `rcac-mcp` configuration points `--ssh-host` at your login node (the
examples below use `gautschi.rcac.purdue.edu`; substitute your cluster's host). Add it
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

`uvx` fetches and runs the server on demand, so there is no separate install step.

### The other two servers

- **`globus-mcp`** (data transfers) registers the same way, with
  `uvx git+https://github.com/purduercac/globus-mcp` as the command and no
  `--ssh-host` (it uses your browser-based Globus login on first use).
- **`rcac-docs-mcp`** (documentation search) is easiest as the hosted endpoint
  `https://docs.rcac.purdue.edu/mcp`, with no credentials. The registration block for each
  harness is on [MCP Servers](../mcp_servers.md).

## Warp: the recommended workflow

Warp is a desktop terminal application. You run it on your workstation and SSH into the
cluster inside it; its agent reads output and runs commands in the session you opened.
Because you are already connected to the cluster, Warp does not use `rcac-mcp`. The two are
alternative ways to reach the same cluster, not layers you combine.

Recommended workflow:

1. **Install Warp** on your workstation (macOS, Windows, or Linux) and sign in.
2. **SSH into the cluster** in a Warp terminal.
3. **Point the agent at the cluster's context.** Add a Global Rule in Warp that tells the
   agent to read `/etc/agents.d/AGENTS.md` when the session is on an RCAC cluster. See
   [Shared Context](../shared_context/index.md).
4. **Keep the denylist on.** Warp's default Agent Profile denylist requires approval for
   `rm`, `curl`, `wget` and `eval`.

!!! warning "Run-until-completion bypasses the denylist"

    Warp's Run-until-completion mode ignores the denylist. Do not use it on cluster
    sessions, and review commands before they run.

## Prior art: external tools over SSH

RCAC already documents this pattern for VS Code. The
[VS Code on RCAC](../../lifesciences/guides/vscode.md) guide covers Remote-SSH and ProxyJump
from a local editor into a login or compute node, which is a good way to set up your SSH
config before you point an agent at it.

---

Back to [Running Agents](index.md).
