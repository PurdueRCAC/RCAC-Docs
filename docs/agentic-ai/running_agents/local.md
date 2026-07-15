---
tags:
  - Agentic AI
authors:
  - glentner
---

# Local, Targeting the Cluster (MCP + SSH)

In this mode the agent runs where *you* are — on your laptop or workstation — and
reaches Gautschi through the RCAC MCP servers over the SSH access you already have.
It is the recommended setup for most users, and the only way to use **Warp**.

## The local-first architecture

The `rcac-mcp` server runs as a subprocess of your harness on your own machine and
executes commands on the cluster over your existing `~/.ssh/config` and keys. That
design has three consequences worth stating plainly:

- **No new credentials.** The server adds no authentication layer of its own. It acts
  as you, over your SSH connection — the security boundary is the SSH session itself.
- **No hosted infrastructure.** Nothing is installed or left running on the cluster.
  The tooling lives on your machine; the cluster sees ordinary SSH commands.
- **Only the access you already have.** An agent connected this way can do exactly
  what you can do over SSH — no more. **If you can SSH to the cluster, your agent
  can too**, within the same permissions.

The agent still gets cluster-aware context: `rcac-mcp` reads the host's
`/etc/agents.d/` files over SSH and injects them, so a locally-run agent knows
Gautschi's partitions, filesystems, and policies without you installing anything.

## Warp: the recommended local workflow

**Warp is RCAC's recommended harness for most users.** It is a desktop terminal
application, so it runs on your workstation, not on a login node — and that is exactly
the local-first pattern this page describes. The recommended workflow:

1. **Install Warp** on your workstation (macOS, Windows, or Linux) and sign in.
2. **SSH into Gautschi** from within Warp. Warp supports its Agent Mode over SSH, so
   the agent operates within your remote session while the app stays local.
3. **Connect `rcac-mcp`** under *Settings → Agents → MCP servers* (see the
   configuration below) so the agent can check quota, list accounts, and drive Slurm
   through verified tools rather than guesswork.
4. **Keep the guardrails on.** Warp ships a default regex denylist (it already
   requires approval for `rm`, `curl`, `wget`, `eval`); leave it in place.

!!! warning "Run-until-completion bypasses the denylist"

    Warp's *Run-until-completion* mode **ignores the denylist entirely** — a real
    hazard when the session is connected to a cluster. Avoid it on shared systems, and
    review commands before they run.

## Connect the MCP servers to your harness

The canonical `rcac-mcp` configuration points `--ssh-host` at your login node. Add it
to your harness in that harness's native format:

=== "Claude Code / Gemini CLI / Warp"

    These read an `mcpServers` JSON block (Claude Code in `.mcp.json`, Gemini CLI in
    `~/.gemini/settings.json`, Warp under *Settings → Agents → MCP servers*):

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
full settings and permission files for each harness — including the shared context and
starting-point deny/allow policy — are published in the Shared Context & Settings pages
of this section.

### The other two servers

- **`globus-mcp`** (data transfers) registers the same way, with
  `uvx git+https://github.com/purduercac/globus-mcp` as the command and no
  `--ssh-host` (it uses your browser-based Globus login on first use).
- **`rcac-docs-mcp`** (documentation search) is easiest as the hosted endpoint: point
  an HTTP-capable MCP client at `https://docs.rcac.purdue.edu/mcp` — no credentials
  required.

## Prior art: external tools over SSH

Reaching into the cluster from a locally-run tool is a well-worn path at RCAC. The
[VS Code on RCAC](../../lifesciences/guides/vscode.md) guide documents the same shape
for a different tool — Remote-SSH and ProxyJump from a local editor into a login or
compute node — and is a useful companion for setting up your SSH config cleanly before
you point an agent at it.

---

Back to [Running Agents](index.md).
