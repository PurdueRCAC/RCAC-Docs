---
tags:
  - Agentic AI
authors:
  - glentner
---

# On the Cluster (Login Nodes)

In this mode you SSH into a cluster login node and run a command-line harness right
there. The four CLI harnesses (Claude Code, Codex, Gemini CLI and opencode) install and
run headlessly on Linux, so they work over SSH. Warp does not run here; it is a desktop
application (see [Warp](#warp) below).

## The login-node rule applies to your agent

A login (front-end) node is a shared, multi-tenant machine meant for editing,
compiling, submitting jobs, and light pre- and post-processing — not for running
computation. Launching a harness there is fine: the agent process itself is
lightweight (mostly network calls). But anything heavy the agent then wants to do must
go through Slurm, as if you were doing it by hand.

!!! important

    Do NOT run large, long, multi-threaded, parallel, or CPU-intensive jobs on a
    front-end login host. All users share the front-end hosts, and running anything
    but the smallest test job will negatively impact everyone's ability to use
    the cluster. Always use SLURM to submit your work as a job.

In practice: instruct your agent to compile modestly, test on tiny inputs, and submit
real runs with `sbatch` or `sinteractive`, with a correct account (`-A`), partition
(`-p`), QOS where the cluster uses one (`-q`), and an explicit `--time` limit. The cluster's
[context files](../shared_context/context_files.md) tell an agent this once you connect your
harness to them. You are responsible for what the agent runs.

## Where agents may write

Point an agent's working files at your scratch space, not your home directory. Scratch is
the large, high-performance filesystem intended for job I/O. On most clusters it is
`$RCAC_SCRATCH` (`findscratch` prints it); on Anvil it is `$SCRATCH`. Scratch is not backed up
and is purged after a period of inactivity (the window varies by cluster), so move anything
you want to keep to durable storage.

!!! warning "Sandboxes are often unavailable on shared nodes"

    The harnesses ship OS-level sandboxes (Codex uses `bubblewrap`, Gemini uses Docker or
    Podman, Claude Code uses Linux namespaces). These are often unavailable or disabled on
    shared login nodes, so do not count on them. Containers do not protect you either: RCAC
    uses Apptainer, not Docker, and its configuration bind-mounts your home, scratch and
    (where present) Depot or project space into the container. Those mounts are writable, so
    an agent in a container can still change your real files. Treat your harness's
    permission and approval settings as the main control: block destructive operations
    (`rm -rf`, `sudo`) and point writable work at scratch.

## Install and run each harness

Each CLI installs into your user space (home directory) — no elevated privileges
needed. Run these on a cluster login node after you SSH in.

=== "Claude Code"

    ```bash
    # native installer (or: npm install -g @anthropic-ai/claude-code)
    curl -fsSL https://claude.ai/install.sh | bash

    claude                 # interactive
    claude -p "…"          # headless / non-interactive
    ```

=== "Codex"

    ```bash
    # shell installer (or: npm install -g @openai/codex)
    curl -fsSL https://chatgpt.com/codex/install.sh | sh

    codex                  # interactive
    codex exec "…"         # headless / non-interactive
    ```

=== "Gemini CLI"

    ```bash
    npm install -g @google/gemini-cli

    gemini                 # interactive
    gemini -p "…"          # headless (avoid --yolo on shared nodes)
    ```

=== "opencode"

    ```bash
    # install script (or: npm install -g opencode-ai)
    curl -fsSL https://opencode.ai/install | bash

    opencode               # interactive TUI
    opencode run "…"       # non-interactive
    ```

To load the cluster's context in every session, see
[Shared Context](../shared_context/index.md). To add the documentation search server, see
[MCP Servers](../mcp_servers.md).

## Warp

Warp is a desktop application. It does not run on a login node.

Run Warp on your own workstation and SSH into the cluster from there. Its agent reads output
and runs commands in the SSH session you opened, while the app stays local. See
[Local, Targeting the Cluster](local.md).

---

Back to [Running Agents](index.md).
