---
title: Running Agents
tags:
  - Agentic AI
authors:
  - glentner
---

# Running Agents

There are two ways to run an agentic coding tool against an RCAC cluster. Which one fits
depends on your harness and how you work.

- **On the cluster (login nodes).** You SSH into a cluster login node and run a
  command-line harness (Claude Code, Codex, Gemini CLI, or opencode) there. The agent
  runs on the front end alongside your shell, so it sees the real filesystem, modules and
  scheduler directly, and it is bound by the same login-node rules you are.
- **Locally, targeting the cluster.** The harness runs on your laptop or workstation and
  reaches the cluster over your existing SSH access. Claude Code, Codex, Gemini CLI and
  opencode connect through the RCAC [MCP servers](../mcp_servers.md), which reach the
  cluster over SSH so the agent works through tool calls. Warp is a desktop terminal in
  which you SSH into the cluster yourself, and its agent works in that session. Either way,
  nothing new is installed on the cluster and no new credentials are created.

<div class="grid cards" markdown>

-   :material-console:{ .lg .middle } __On the Cluster (Login Nodes)__

    ---

    Run a CLI harness directly on a cluster front end. Covers install, the
    login-node compute rules, and where agents may write.

    [:octicons-arrow-right-24: On the Cluster](on_cluster.md)

-   :material-laptop:{ .lg .middle } __Local (over SSH)__

    ---

    Run the harness on your own machine and reach the cluster over SSH, with no new
    credentials and no hosted infrastructure. The recommended setup, and the only way to
    use Warp.

    [:octicons-arrow-right-24: Local, Targeting the Cluster](local.md)

</div>

---

Back to [Agentic AI](../index.md).
