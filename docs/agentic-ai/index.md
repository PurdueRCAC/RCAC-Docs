---
title: Agentic AI
tags:
  - Agentic AI
authors:
  - glentner
---

# Agentic AI at RCAC

Researchers on RCAC's clusters use agentic coding tools (Claude Code, OpenAI Codex, Gemini
CLI, opencode and Warp) to write Slurm scripts, debug failing jobs, move data and explore
software. RCAC does not prohibit these tools. It publishes cluster-specific context that makes
their output more likely to be correct on RCAC systems, and guidance on checking that output.

These tools can produce answers that look correct and are wrong: a Slurm script for a
scheduler RCAC does not run, a module name that doesn't exist, a path on the wrong
filesystem. This section describes the context RCAC provides and how to check what an agent
produces. Review what the agent proposes, and ask it to explain its choices.

!!! note "New and changing"

    The MCP servers and the shared context files are new and will change. See the
    shared-context pages for how to send corrections.

## In this section

<div class="grid cards" markdown>

-   :material-scale-balance:{ .lg .middle } __Acceptable Use & Etiquette__

    ---

    The rules for running agents on RCAC systems, consistent with Purdue's Acceptable Use
    Policy.

    [:octicons-arrow-right-24: Acceptable Use & Etiquette](acceptable_use.md)

-   :material-lightbulb-on:{ .lg .middle } __Best Practices & Limitations__

    ---

    Using an agent for research versus operations; giving it context; checking output; and
    the risks of letting an agent run commands.

    [:octicons-arrow-right-24: Best Practices & Limitations](best_practices.md)

-   :material-connection:{ .lg .middle } __MCP Servers__

    ---

    RCAC's MCP servers (`rcac-mcp`, `globus-mcp`, `rcac-docs-mcp`) and what they let an
    agent do.

    [:octicons-arrow-right-24: MCP Servers](mcp_servers.md)

-   :material-robot:{ .lg .middle } __Running Agents__

    ---

    Set up your harness on the cluster (login nodes) or on your own machine, reaching the
    cluster over SSH, for all five harnesses.

    [:octicons-arrow-right-24: Running Agents](running_agents/index.md)

-   :material-file-cog:{ .lg .middle } __Shared Context__

    ---

    The context files RCAC places on each cluster, and how to connect your harness to them.

    [:octicons-arrow-right-24: Shared Context](shared_context/index.md)

</div>

For cluster-specific setup, see the *Using AI Agents* chapter in each cluster's user guide:
[Gautschi](../userguides/gautschi/using_ai_agents.md),
[Gilbreth](../userguides/gilbreth/using_ai_agents.md) and
[Negishi](../userguides/negishi/using_ai_agents.md).

---

Reference: Lentner and Ashish, "Hello Computer: HPC in the Agentic Era", PEARC'26 (2026);
[replication package](https://github.com/glentner/pearc26-hello-computer).
