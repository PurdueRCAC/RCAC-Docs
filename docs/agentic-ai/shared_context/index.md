---
title: Shared Context
tags:
  - Agentic AI
authors:
  - glentner
---

# Shared Context

RCAC publishes the context files it places on each cluster, so you can read exactly what an
agent is told and connect your own harness to them.

## What `/etc/agents.d` is

`/etc/agents.d/` is a directory of Markdown files on each cluster that describe the cluster to
an agent: the operating environment, the filesystems, the module system, the scheduler and the
policies. Five topic files (`unix.md`, `filesystems.md`, `lmod.md`, `slurm.md`,
`policies.md`) are combined into one file, `/etc/agents.d/AGENTS.md`, which is the file to load.
Once you connect your harness to it, the agent reads it at the start of every session.

Each rule follows the same shape: a fact, the correct command or path, an explicit "do
not…", and the reason. The files are written to the agent, not to you.

RCAC places these files on the cluster's login and compute nodes. Your home directory is
shared between a cluster's login and compute nodes, so the one-time setup below also works
inside jobs. Home directories are not shared between clusters, so repeat the setup on each
cluster you use.

## Load the context in your harness

None of the harnesses reads `/etc/agents.d/` on its own. Do this once on each cluster, after
you install the harness:

=== "Claude Code"

    Import the file from your user-level memory file:

    ```bash
    mkdir -p ~/.claude && echo '@/etc/agents.d/AGENTS.md' >> ~/.claude/CLAUDE.md
    ```

    `>>` appends, so an existing `~/.claude/CLAUDE.md` is kept. Run `/memory` in a session to
    confirm the file loaded.

=== "Codex"

    Link the file as your global instructions:

    ```bash
    mkdir -p ~/.codex && ln -s /etc/agents.d/AGENTS.md ~/.codex/AGENTS.md
    ```

    Codex reads one global file and has no import syntax. If you already have a
    `~/.codex/AGENTS.md`, `ln -s` fails with "File exists": decide whether to replace your
    file with the link. Do not use `ln -sf`, which discards your file. An
    `AGENTS.override.md` in the same directory hides `AGENTS.md`. If you set `CODEX_HOME`,
    create the link there instead.

=== "Gemini CLI"

    Gemini CLI does not import files from outside `~/.gemini`, so link the file there and add
    its name to the files Gemini reads:

    ```bash
    mkdir -p ~/.gemini && ln -s /etc/agents.d/AGENTS.md ~/.gemini/AGENTS.md
    ```

    ```json title="~/.gemini/settings.json (merge into the existing file)"
    {
      "context": { "fileName": ["GEMINI.md", "AGENTS.md"] }
    }
    ```

    Keep `GEMINI.md` first. Gemini saves memories to the first name in the list, and it
    cannot write through the link to `/etc`. This setting also makes Gemini read `AGENTS.md`
    files in your projects. Run `/memory show` to confirm.

=== "opencode"

    Add the file to `instructions` in your global config:

    ```json title="~/.config/opencode/opencode.json (merge into the existing file)"
    {
      "$schema": "https://opencode.ai/config.json",
      "instructions": ["/etc/agents.d/AGENTS.md"]
    }
    ```

    opencode combines this with your own `AGENTS.md` files.

=== "Warp"

    Warp cannot load a file from a host you SSH into. Add a Global Rule in Warp Drive
    (Personal > Rules > Global) that tells the agent to read it:

    ```text
    When the terminal session is on an RCAC cluster (hostname ending in
    .rcac.purdue.edu), run `cat /etc/agents.d/AGENTS.md` before running other
    commands, and follow it.
    ```

    Do not copy the file into your working directory; the copy goes out of date.

These steps were checked against each harness's documentation in October 2026. If the file
is missing on a host, each harness skips it without an error.

## Agents running on your own machine

If you run a harness on your own machine with [`rcac-mcp`](../mcp_servers.md), the server
offers the cluster's `/etc/agents.d/*.md` files as a read-only MCP resource,
`rcac://context`. The agent sees it only when it reads that resource or you attach it (in
Claude Code, type `@rcac:rcac://context` in a prompt).

## Source of truth

These pages show the files RCAC places on each cluster. They are generated per cluster from
the facts in that cluster's user guide, so the partitions, GPUs, filesystems and toolchain
are the ones for that machine. See [Context Files](context_files.md).

## How to send feedback

To report a wrong fact or a missing rule:

- Open an issue or pull request on the
  [RCAC-Docs repository](https://github.com/PurdueRCAC/RCAC-Docs).
- Email [rcac-help@purdue.edu](mailto:rcac-help@purdue.edu) (Anvil users: the
  [ACCESS Help Desk](https://support.access-ci.org/help-ticket)).
- Reach the team on [Discord](https://discord.gg/RmtKZmaQW9).

<div class="grid cards" markdown>

-   :material-file-document-multiple:{ .lg .middle } __Context Files (`/etc/agents.d`)__

    ---

    The five topic files and the assembled `AGENTS.md`, shown for Gautschi, with links to
    each cluster's set.

    [:octicons-arrow-right-24: Context Files](context_files.md)

-   :material-cog-off:{ .lg .middle } __Harness Settings (Retired)__

    ---

    RCAC no longer publishes or deploys harness settings. Links to each harness's own
    permission controls.

    [:octicons-arrow-right-24: Harness Settings](settings.md)

</div>

---

Back to [Agentic AI](../index.md).
