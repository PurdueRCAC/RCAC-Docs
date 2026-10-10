---
title: Harness Settings (Retired)
tags:
  - Agentic AI
authors:
  - glentner
---

# Harness Settings (Retired)

This page used to publish a settings and permission file for each agent harness (Claude
Code, Codex, Gemini CLI, opencode and Warp) and described them as deployed and enforced on
RCAC clusters.

RCAC changed this policy after review and testing. Each user installs and configures their
own harness, and a system-wide settings file does not reliably control it. RCAC no longer
publishes or deploys harness settings or permission policies. What RCAC provides is context:
the files in `/etc/agents.d/` that describe each cluster to an agent. See
[Shared Context](index.md).

You set your harness's permissions. Configure it so that destructive or irreversible
commands ask for your approval before they run. Each harness documents its own controls:

- Claude Code: [Configure permissions](https://code.claude.com/docs/en/permissions)
- Codex: [Agent approvals & security](https://learn.chatgpt.com/docs/agent-approvals-security)
- Gemini CLI: [Configuration](https://geminicli.com/docs/reference/configuration/)
  (`tools.exclude`, `general.defaultApprovalMode`)
- opencode: [Permissions](https://opencode.ai/docs/permissions/)
- Warp: the Agent Profile in Warp's settings (allowlist and denylist)

[Best Practices & Limitations](../best_practices.md) lists the commands worth allowing and
the operations worth blocking.

---

Back to [Shared Context](index.md).
