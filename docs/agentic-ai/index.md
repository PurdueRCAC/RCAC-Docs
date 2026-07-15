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

- **Acceptable Use & Etiquette** — the rules for running agents on RCAC systems,
  consistent with Purdue's Acceptable Use Policy.
- **Best Practices & Limitations** — using an agent *for research* versus *for
  operations*; context engineering; verifying output ("augmented, not
  outsourced"); and the caution/blast-radius risks to keep in mind.
- **MCP Servers** — RCAC's Model Context Protocol servers (`rcac-mcp`,
  `globus-mcp`, `rcac-docs-mcp`), why they matter, and how they give an agent
  context that knows our clusters.
- **Running Agents** — how to set up your chosen harness in whichever mode you
  work: running the agent *on the cluster* (login nodes), or *locally, targeting
  the cluster* over MCP + SSH.
- **Shared Context & Settings** — the actual Gautschi `/etc/agents.d` context
  files and per-harness settings we give agents, published verbatim as the
  canonical source of truth, plus how to contribute feedback and corrections.

For Gautschi-specific setup pointers, see the **Using AI Agents** chapter in the
Gautschi user guide.
