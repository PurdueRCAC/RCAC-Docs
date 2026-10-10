---
tags:
  - Agentic AI
authors:
  - glentner
---

# RCAC MCP Servers

The [Model Context Protocol](https://modelcontextprotocol.io/) (MCP) is an open standard that
lets an agent call external tools and read external context through a uniform interface. RCAC
builds MCP servers that let an agent check your quota, list your Slurm accounts, submit and
monitor jobs, search this documentation, and move data. With them, an agent can check the
cluster's actual state instead of guessing.

!!! note "Prototypes"

    All three servers are working prototypes. They are open source and usable today, but
    their tools, names and interfaces will change. This page describes their current state.

RCAC publishes three servers:

| Server | What it does | Transport |
|--------|--------------|-----------|
| `rcac-mcp` | HPC cluster and storage operations | local stdio, over your SSH |
| `globus-mcp` | Data transfers and remote compute (Globus) | local stdio, your Globus login |
| `rcac-docs-mcp` | Full-text search of this documentation site | hosted HTTP, or local stdio |

## `rcac-mcp` — HPC operations

**Repository:** <https://github.com/PurdueRCAC/rcac-mcp>

`rcac-mcp` gives an agent tools to run shell commands, read and write files, inspect storage
quota, and drive Slurm. Everything runs on the cluster over your existing SSH connection.

The server runs as a `stdio` subprocess on your own machine and uses your existing
`~/.ssh/config` and keys. It adds no new service and no new credential: the agent has the
same access you have over SSH, and nothing more.

The agent works through tool calls. It asks the server to run a command, submit a job or read
a file, and the server does so over the SSH connection. The agent does not drive an
interactive terminal. (Warp is different: you open the SSH session yourself and its agent
works in that session. See [Running Agents](running_agents/local.md).)

Add it to an MCP-capable harness with the server's configuration block, pointing
`--ssh-host` at your cluster's login host (the example uses `gautschi.rcac.purdue.edu`):

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

`uvx` fetches, builds and runs the server in one step, so there is no separate install. You
can set `RCAC_SSH_HOST` in the environment instead of passing `--ssh-host`. Per-harness
registration is on the [Running Agents](running_agents/local.md) pages.

### Tools it exposes

The server groups its tools by area (names may change):

- **Shell and files:** `run_command`, `list_directory`, `read_file`, `write_file`,
  `upload_file`, `download_file`.
- **Cluster and storage:** `myquota`, `storage_paths`, `jobinfo`, `jobscript`,
  `showpartitions`, `average_wait`.
- **Slurm:** `sbatch`, `squeue`, `scancel`, `sacct`, `sinfo`, `scontrol_show_job`,
  `scontrol_show_node`, plus RCAC's `slist` (your accounts and balances) and `sfeatures`
  (node hardware features).

### The cluster's context, on request

`rcac-mcp` also offers the cluster's [context files](shared_context/context_files.md) as a
read-only MCP resource, `rcac://context`. When the resource is read, the server collects the
Markdown files in `/etc/agents.d/` on the cluster over the same SSH connection and returns
them joined together.

The agent sees this context only when it reads the resource or you attach it. In Claude Code,
type `@rcac:rcac://context` in a prompt. Other harnesses give the agent a tool to list and read
MCP resources, and the agent decides whether to call it. See
[Shared Context](shared_context/index.md) for what the files contain and how to load them in
every session.

!!! info "Planned direction"

    RCAC plans to limit `rcac-mcp` to HPC operations and rebuild it around plugins, for
    example `cluster-mcp[slurm,lmod,…]`, where scheduler, module-system and other support
    become installable extensions. This has not shipped. The current release also includes
    the documentation-search tools that now live in `rcac-docs-mcp`. Follow the repository for
    the current state.

## `globus-mcp` — data transfers

**Repository:** <https://github.com/PurdueRCAC/globus-mcp>

`globus-mcp` gives an agent data transfer and remote code execution across research storage
systems by wrapping the Globus CLI and the Globus Compute SDK. An agent can search endpoints,
browse remote filesystems, run asynchronous transfers, and submit Python functions to Compute
endpoints.

!!! warning "Beta software"

    `globus-mcp` is beta. Its APIs, tool signatures and behavior may change without notice.

Like `rcac-mcp`, it runs as a local `stdio` subprocess and uses your own Globus identity. On
first use its `globus_login()` and `compute_login()` tools walk you through browser-based
OAuth. It adds no RCAC-hosted credential.

```json
{
  "mcpServers": {
    "globus": {
      "command": "uvx",
      "args": ["git+https://github.com/purduercac/globus-mcp"]
    }
  }
}
```

Its tools cover identity (`whoami`, `globus_login`), endpoints (`endpoint_search`,
`endpoint_show`), filesystem operations (`ls`, `stat`, `mkdir`, `rename`, `rm`, `delete`),
transfers (`transfer`, `transfer_batch`, `task_*`), and remote Compute (`compute_submit`,
`compute_status`, `compute_result`).

## `rcac-docs-mcp` — documentation search

**Repository:** <https://github.com/PurdueRCAC/rcac-docs-mcp>

`rcac-docs-mcp` gives an agent full-text search over this documentation site, so it can base
its advice on current RCAC documentation. It indexes the user guides, software catalog,
datasets, blog posts and workshops, and exposes two tools:

- `doc_search(query, category=None)` — full-text search returning ranked results with path,
  title, heading and a matching snippet. `category` filters by section (`userguides`,
  `software`, `datasets`, `blog`, `workshops`).
- `doc_load(path)` — return the full Markdown of one document by its path.

The simplest way to use it is the hosted instance at `https://docs.rcac.purdue.edu/mcp`, a
shared HTTP endpoint with no authentication. It does not SSH anywhere and only reads a search
index, which is why it can be public. It works the same on your own machine and on a cluster
login node. Register it in your harness:

=== "Claude Code"

    ```json title=".mcp.json"
    {
      "mcpServers": {
        "rcac-docs": { "type": "http", "url": "https://docs.rcac.purdue.edu/mcp" }
      }
    }
    ```

=== "Codex"

    ```toml title="~/.codex/config.toml"
    [mcp_servers.rcac_docs]
    url = "https://docs.rcac.purdue.edu/mcp"
    ```

=== "Gemini CLI"

    ```json title="~/.gemini/settings.json"
    {
      "mcpServers": {
        "rcac-docs": { "httpUrl": "https://docs.rcac.purdue.edu/mcp" }
      }
    }
    ```

=== "opencode"

    ```json title="~/.config/opencode/opencode.json"
    {
      "$schema": "https://opencode.ai/config.json",
      "mcp": {
        "rcac-docs": {
          "type": "remote",
          "url": "https://docs.rcac.purdue.edu/mcp",
          "enabled": true
        }
      }
    }
    ```

If a settings file already exists, merge these keys into it rather than replacing the file.

You can also run the server locally as a `stdio` subprocess. It builds a local index first:

```json
{
  "mcpServers": {
    "rcac-docs": {
      "command": "uvx",
      "args": ["git+https://github.com/PurdueRCAC/rcac-docs-mcp"]
    }
  }
}
```

## Status and feedback

All three servers are MIT-licensed. Issues and pull requests are welcome on their
repositories, and you can reach the team at
[rcac-help@purdue.edu](mailto:rcac-help@purdue.edu) or on
[Discord](https://discord.gg/RmtKZmaQW9).

---

Back to [Agentic AI](index.md).
