---
tags:
  - Agentic AI
authors:
  - glentner
---

# On the Cluster (Login Nodes)

In this mode you SSH into a Gautschi login node and run a command-line harness right
there. The four CLI harnesses — **Claude Code**, **Codex**, **Gemini CLI**, and
**opencode** — install and run headlessly on Linux, so they work over SSH. **Warp**
does not run here; it is a desktop application (see [Warp](#warp) below).

## The login-node rule applies to your agent

A login (front-end) node is a shared, multi-tenant machine meant for editing,
compiling, submitting jobs, and light pre- and post-processing — not for running
computation. Launching a harness there is fine: the agent process itself is
lightweight (mostly network calls). But **anything heavy the agent then wants to do
must go through Slurm**, exactly as if you were doing it by hand.

!!! important

    Do NOT run large, long, multi-threaded, parallel, or CPU-intensive jobs on a
    front-end login host. All users share the front-end hosts, and running anything
    but the smallest test job will negatively impact everyone's ability to use
    Gautschi. Always use SLURM to submit your work as a job.

In practice: instruct your agent to compile modestly, test on tiny inputs, and submit
real runs with `sbatch` or `sinteractive` — with a correct account (`-A`, discovered
via `slist`), partition (`-p`), QOS (`-q`), and an explicit `--time` limit. The shared
[context files](../shared_context/context_files.md) RCAC publishes already tell an agent
this, and the [per-harness settings](../shared_context/settings.md) deny the most
dangerous operations, but the responsibility is ultimately yours.

## Where agents may write

Point an agent's working files at your **scratch** space, not your home directory.
Scratch is the large, high-performance filesystem intended for job I/O; find it with
`findscratch` or the `$RCAC_SCRATCH` environment variable
(`/scratch/gautschi/$USER`). Keep in mind scratch is **not backed up and is purged
after 60 days of inactivity**, so move anything you want to keep to durable storage.

!!! warning "Sandboxes are weak on shared nodes — don't rely on them"

    The harnesses ship OS-level sandboxes (Codex uses `bubblewrap`, Gemini uses
    Docker/Podman, Claude Code uses Linux namespaces). These are frequently
    **unavailable or disabled on shared login nodes**, so do not count on them.
    Containers are not a safety net either: RCAC uses **Apptainer** (not Docker), and
    its configuration **auto bind-mounts `/home`, `/depot`, and `/scratch`** into the
    container — those mounts stay writable, so an agent in a container can still edit
    your real files. Treat the harness's **permission/approval rules as your primary
    control**: keep destructive operations (`rm -rf`, `sudo`) denied and set writable
    roots to `$RCAC_SCRATCH`.

## Install and run each harness

Each CLI installs into your user space (home directory) — no elevated privileges
needed. Run these on a Gautschi login node after you SSH in.

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

To connect these harnesses to the RCAC [MCP servers](../mcp_servers.md) and wire in the
shared context and permission policy, see
[Shared Context & Settings](../shared_context/index.md).

## Warp

Warp is **RCAC's recommended harness for most users** — but it is a **desktop
application**, not a headless CLI, and **cannot be installed on a login node**. There
is no login-node path for Warp, and you should not try to fabricate one.

Instead, run Warp on your own workstation and SSH into Gautschi from there; its Agent
Mode then rides your live SSH session — reading output and issuing commands in the
session you opened — while the app stays local. That is the recommended setup for Warp;
see [Local, Targeting the Cluster](local.md).

---

Back to [Running Agents](index.md).
