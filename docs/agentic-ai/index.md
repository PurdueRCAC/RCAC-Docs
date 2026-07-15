---
title: Agentic AI
tags:
  - Agentic AI
---

# Agentic AI at RCAC

Researchers on RCAC's clusters are already using agentic coding tools — Claude
Code, OpenAI Codex, Gemini CLI, opencode, and Warp — to write Slurm scripts,
debug failing jobs, move data, and explore software. RCAC's stance is
**proactive engagement, not prohibition**. Rather than forbidding these tools,
we shape the context in which you use them so their output is more likely to be
correct for *our* systems, and we give you what you need to **verify** that
output rather than simply trust it.

These agents are, in the framing of our PEARC'26 paper *Hello Computer: HPC in
the Agentic Era*, **"mostly harmless"** — genuinely useful, but perfectly
capable of producing confident, plausible, and wrong answers: a Slurm script for
a scheduler we don't run, a module name that doesn't exist, a path on the wrong
filesystem. The aim of this section is to make the tools work *well* on RCAC by
giving them accurate, cluster-specific context, and to give you the judgment to
check what they produce. Treat an agent as **augmenting your expertise, not
outsourcing it** — ask *why*, not just *what*.

!!! note "Early and evolving"

    This is new, actively-developed work. The MCP servers, the shared context
    files, and the per-harness settings documented here are prototypes that will
    change over time. We publish them openly and invite your feedback — see the
    shared-context pages for how to send corrections.

## In this section

<div class="grid cards" markdown>

-   :material-scale-balance:{ .lg .middle } __Acceptable Use & Etiquette__

    ---

    The rules for running agents on RCAC systems, consistent with Purdue's
    Acceptable Use Policy.

    [:octicons-arrow-right-24: Acceptable Use & Etiquette](acceptable_use.md)

-   :material-lightbulb-on:{ .lg .middle } __Best Practices & Limitations__

    ---

    Using an agent *for research* versus *for operations*; context engineering;
    verifying output; and the caution/blast-radius risks.

    [:octicons-arrow-right-24: Best Practices & Limitations](best_practices.md)

-   :material-connection:{ .lg .middle } __MCP Servers__

    ---

    RCAC's MCP servers (`rcac-mcp`, `globus-mcp`, `rcac-docs-mcp`) and how they give
    an agent context that knows our clusters.

    [:octicons-arrow-right-24: MCP Servers](mcp_servers.md)

-   :material-robot:{ .lg .middle } __Running Agents__

    ---

    Set up your harness on the cluster (login nodes) or locally, targeting the
    cluster over MCP + SSH — for all five harnesses.

    [:octicons-arrow-right-24: Running Agents](running_agents/index.md)

-   :material-file-cog:{ .lg .middle } __Shared Context & Settings__

    ---

    The actual Gautschi context files and per-harness settings, published verbatim
    as the canonical source of truth — plus how to send feedback.

    [:octicons-arrow-right-24: Shared Context & Settings](shared_context/index.md)

</div>

For Gautschi-specific setup pointers, see the
[Using AI Agents](../userguides/gautschi/using_ai_agents.md) chapter in the Gautschi
user guide.
