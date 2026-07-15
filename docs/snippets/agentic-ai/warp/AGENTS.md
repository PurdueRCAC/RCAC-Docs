# Warp Agent Configuration (Gautschi)

Warp is a desktop application with no server-side settings file to ship, so its
configuration has two parts: the **context file** it reads automatically, and an
**Agent Profile** you set in the app.

## Context

Warp reads a repository `AGENTS.md` automatically (the filename must be ALL-CAPS).
Place the assembled Gautschi context (the concatenated `AGENTS.md` shown on the Context
Files page) at your repository root, and Warp will load it as project rules.

## Permissions (Agent Profile)

Under *Settings -> Agents -> Profiles*, set a regex allowlist and denylist:

- **Allowlist** (auto-run without confirmation):
  `myquota`, `slist`, `sfeatures`, `module\s+(list|avail).*`
- **Denylist** (always require approval):
  `rm\s+-rf.*`, `sudo.*`
  (Warp's built-in denylist already requires approval for `rm`, `curl`, `wget`, and
  `eval`.)

The denylist beats both the allowlist and "Agent decides."

## Warning: Run-until-completion bypasses the denylist

Warp's *Run-until-completion* mode ignores the denylist entirely. Do not use it on a
shared cluster session — review commands before they run.

## MCP

Register `rcac-mcp` under *Settings -> Agents -> MCP servers* using the `mcpServers`
JSON block shown on the Local (MCP + SSH) page.
