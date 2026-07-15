---
title: Running Agents
tags:
  - Agentic AI
---

# Running Agents

There are two ways to run an agentic coding tool against an RCAC cluster, and this
section is organized around that choice. Both are legitimate; which one fits depends
on your harness and how you like to work.

- **On the cluster (login nodes).** You SSH into a Gautschi login node and run a
  command-line harness (Claude Code, Codex, Gemini CLI, or opencode) *there*. The
  agent lives on the front end alongside your shell, so it sees the real filesystem,
  modules, and scheduler directly — but it is bound by the same login-node etiquette
  you are.
- **Locally, targeting the cluster (MCP + SSH).** The harness runs in your own
  environment — your laptop or workstation — and reaches the cluster through the RCAC
  MCP servers over your existing SSH access. Nothing new is installed on the cluster,
  and no new credentials are created. This is the mode that works with **Warp**, which
  is a desktop application and cannot run on a login node.

<div class="grid cards" markdown>

-   :material-console:{ .lg .middle } __On the Cluster (Login Nodes)__

    ---

    Run a CLI harness directly on a Gautschi front end. Covers install, the
    login-node compute rules, and where agents may write.

    [:octicons-arrow-right-24: On the Cluster](on_cluster.md)

-   :material-laptop:{ .lg .middle } __Local (MCP + SSH)__

    ---

    Run the harness on your own machine and reach the cluster over SSH — no new
    credentials, no hosted infrastructure. The recommended setup, and the only way to
    use Warp.

    [:octicons-arrow-right-24: Local (MCP + SSH)](local.md)

</div>

---

Back to [Agentic AI](../index.md).
