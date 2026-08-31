# Agentic Coding Harness Configuration on HPC — Per-Harness Reference

Research date: 2026-07-14. External/current-docs research. Config keys verified against the
cited official docs; anything not confirmed there is marked `[UNVERIFIED]`.

Scope: for each of the five harnesses — config file paths + format, permissions/sandbox
(including a DENY of destructive ops and login-node lockdown), MCP wiring (stdio + remote),
context-file convention (and AGENTS.md support), and install/run on a Linux login node.

---

## Comparison table

| harness | config path | format | permission mechanism | MCP config | context-file name |
|---|---|---|---|---|---|
| **Claude Code** | `~/.claude/settings.json` (user), `.claude/settings.json` + `.claude/settings.local.json` (project), `/etc/claude-code/managed-settings.json` (managed, Linux) | JSON | `permissions.allow` / `permissions.deny` / `permissions.ask` arrays; `defaultMode`; OS sandbox (`sandbox.*`) | `claude mcp add …` / `.mcp.json` (project) / `~/.claude.json` (user/local); stdio + http/sse/ws | `CLAUDE.md` (does **not** read AGENTS.md natively) |
| **Codex CLI** | `~/.codex/config.toml` (user), `.codex/config.toml` (project), profile files `~/.codex/<name>.config.toml` | TOML | `approval_policy` + `sandbox_mode` (read-only / workspace-write / danger-full-access); OS sandbox | `[mcp_servers.NAME]` in config.toml, or `codex mcp add`; stdio + streamable HTTP | `AGENTS.md` (native standard) |
| **Gemini CLI** | `/etc/gemini-cli/settings.json` (system), `~/.gemini/settings.json` (user), `.gemini/settings.json` (project) | JSON | `tools.core` (allow) / `tools.exclude` (deny) with `run_shell_command(<prefix>)`; `approvalMode`; sandbox (`tools.sandbox`) | `mcpServers` in settings.json; stdio + SSE (`url`) + streamable HTTP (`httpUrl`) | `GEMINI.md`; configurable via `context.fileName` (can include `AGENTS.md`) |
| **opencode** | `~/.config/opencode/opencode.json` (global), `opencode.json[c]` (project), `/etc/opencode/` (system) | JSON / JSONC | `permission` object; per-tool + per-bash-pattern map `{ "rm *": "deny" }` (allow/ask/deny) | `mcp` object; `type:"local"` (stdio) + `type:"remote"` (http) | `AGENTS.md` (native; `CLAUDE.md` fallback) + `instructions` array |
| **Warp** | Desktop-app UI: Settings > Agents > Profiles / MCP servers; rules in Warp Drive (cloud) | UI + JSON (MCP) | Agent Profiles: autonomy (Agent Decides / Always Ask / Always Allow) + regex allowlist/**denylist** | Settings > Agents > MCP servers, JSON (`mcpServers`); stdio (`command`) + remote (`url`) | `AGENTS.md` (ALL-CAPS required; `WARP.md` legacy) + Global Rules in Warp Drive |

**Biggest HPC caveat up front:** Warp is a *locally-installed desktop terminal app* (macOS/
Linux/Windows) — you cannot install it on a headless login node. You run Warp on your
workstation and SSH into the cluster. The other four are true CLIs that run headless over SSH.

---

## 1. Claude Code (Anthropic CLI)

Docs: <https://code.claude.com/docs/en/settings> · <https://code.claude.com/docs/en/permissions>
· <https://code.claude.com/docs/en/mcp> · <https://code.claude.com/docs/en/memory> ·
<https://code.claude.com/docs/en/sandboxing>

### Config files (JSON)
| Scope | Path |
|---|---|
| User | `~/.claude/settings.json` |
| Project (shared, committed) | `.claude/settings.json` |
| Project local (gitignored) | `.claude/settings.local.json` |
| Managed (Linux/WSL) | `/etc/claude-code/managed-settings.json` (+ drop-in dir `/etc/claude-code/managed-settings.d/*.json`) |
| Managed CLAUDE.md (Linux) | `/etc/claude-code/CLAUDE.md` |

Precedence (high→low): managed → CLI args → local → project → user. **Permission rules merge
across scopes; a deny at any scope wins.** Schema: `"$schema": "https://json.schemastore.org/claude-code-settings.json"`.

### Permissions / sandbox
`permissions.allow` / `permissions.deny` / `permissions.ask` arrays. Evaluation order is
**deny → ask → allow** (first match wins; a broad deny cannot carry allowlist exceptions).
Rule syntax: `Tool` or `Tool(specifier)`.
- Bash: `Bash(rm -rf:*)` or `Bash(rm -rf *)` (the `:*` suffix == trailing ` *`). Claude Code
  is shell-operator-aware, so `Bash(safe *)` does **not** authorize `safe && evil`; each
  subcommand must match. A bare `Bash` deny removes the tool entirely.
- Files: `Read(...)` / `Edit(...)` use gitignore semantics; `//abs`, `~/home`, `/settings-relative`, `path`.
- Web: `WebFetch(domain:example.com)`. MCP: `mcp__server__tool`.

`defaultMode` (in settings) selects a permission mode: `default` (prompt), `acceptEdits`,
`plan` (read-only exploration), `auto`, `dontAsk` (auto-deny unless pre-allowed),
`bypassPermissions`. Lock down bypass with `permissions.disableBypassPermissionsMode: "disable"`
and `permissions.disableAutoMode: "disable"` (best in managed settings). `rm -rf /` / `rm -rf ~`
prompt even in bypass mode as a circuit breaker.

OS-level **sandbox** (Bash-only, defense-in-depth): `sandbox.enabled`, `sandbox.network`
(`allowedDomains` / `deniedDomains`), `sandbox.filesystem` (`allowRead` / `denyRead`),
`autoAllowBashIfSandboxed` (default true). On Linux it uses namespace-based isolation
(bubblewrap-style) — may be restricted on hardened login nodes; deny rules still apply without it.

**Minimal login-node config** (`~/.claude/settings.json` or a managed file):
```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "defaultMode": "default",
    "deny": [
      "Bash(rm -rf:*)",
      "Bash(sudo:*)",
      "Bash(srun:*)", "Bash(sbatch:*)",
      "Read(./.env)", "Read(~/.ssh/**)"
    ],
    "ask": ["Bash(git push:*)"],
    "additionalDirectories": ["/scratch/$USER"]
  },
  "disableBypassPermissionsMode": "disable"
}
```
(Note: `defaultMode` also exists as a top-level key; it is documented under `permissions` in the
managed examples. `disableBypassPermissionsMode` sits under `permissions` — shown flat here per docs.)

### MCP
`claude mcp add` (scopes: `local` default → `~/.claude.json`; `project` → `.mcp.json`; `user`).
```bash
# local stdio server
claude mcp add --transport stdio myserver -- npx -y some-mcp-server
# remote streamable HTTP
claude mcp add --transport http notion https://mcp.notion.com/mcp \
  --header "Authorization: Bearer TOKEN"
```
`.mcp.json` (project, committed) block:
```json
{
  "mcpServers": {
    "local-tool": { "command": "/path/to/server", "args": [], "env": {} },
    "remote-api": { "type": "http", "url": "https://mcp.example.com/mcp",
                    "headers": { "Authorization": "Bearer ${API_KEY}" } }
  }
}
```
An entry with `url` but no `type` is an error (defaults to stdio). `type: "streamable-http"` is
an accepted alias for `http`. Env expansion `${VAR:-default}` supported. SSE (`--transport sse`)
is deprecated. `claude mcp login <name> --no-browser` works over SSH (prints URL to paste).

### Context files
`CLAUDE.md` load order (broad→specific): managed `/etc/claude-code/CLAUDE.md` → user
`~/.claude/CLAUDE.md` → project `./CLAUDE.md` or `./.claude/CLAUDE.md` → `./CLAUDE.local.md`;
plus ancestor dirs walked up from cwd. Import more files with `@path/to/file` (relative/absolute,
max 4 hops). `.claude/rules/*.md` (optionally `paths:` frontmatter-scoped).
**Claude Code does NOT read `AGENTS.md` natively** — bridge it with `@AGENTS.md` at the top of
`CLAUDE.md`, or `ln -s AGENTS.md CLAUDE.md`. To wire in `/etc/agents.d/*.md`, deploy the managed
`/etc/claude-code/CLAUDE.md` and import each: `@/etc/agents.d/rcac.md`. Load CLAUDE.md from
`--add-dir` dirs with `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1`.

### Install & run
`npm install -g @anthropic-ai/claude-code`, or native installer
`curl -fsSL https://claude.ai/install.sh | bash`. Runs headless over SSH; non-interactive with
`claude -p "…"`. Fully supported on Linux login nodes.

---

## 2. OpenAI Codex CLI

Docs: <https://learn.chatgpt.com/docs/config-file/config-basic> ·
<https://learn.chatgpt.com/docs/config-file/config-reference> ·
<https://learn.chatgpt.com/docs/sandboxing> · <https://developers.openai.com/codex/> (redirects
to learn.chatgpt.com). AGENTS.md: <https://developers.openai.com/codex/agent-configuration/agents-md>.

### Config file (TOML)
- User: `~/.codex/config.toml` (override home with `CODEX_HOME`).
- Project: `.codex/config.toml`.
- Profiles: separate files `~/.codex/<profile-name>.config.toml`, selected with `codex --profile <name>`.
  (As of Codex 0.134.0+ the legacy inline `[profiles.name]` block is removed — use profile files.)

### Permissions / sandbox
Two orthogonal knobs (no per-command allow/deny list like the others — control is via sandbox +
approvals):
```toml
approval_policy = "on-request"   # untrusted | on-request | never  (granular table also supported)
sandbox_mode    = "workspace-write"   # read-only | workspace-write | danger-full-access

[sandbox_workspace_write]
writable_roots         = ["/scratch/USER"]
network_access         = false        # network OFF by default in workspace-write
exclude_tmpdir_env_var = false
exclude_slash_tmp      = false
```
`model = "gpt-5.6"`. CLI flags: `--sandbox <mode>`, `--ask-for-approval <policy>`.
Enforcement: macOS = Seatbelt; **Linux/WSL2 = requires `bubblewrap` (`bwrap`) on PATH** — a key
HPC gotcha, since bwrap/user-namespaces are often absent or disabled on login nodes. Windows in
PowerShell uses a native sandbox. `[UNVERIFIED]` whether an older `on-failure` approval value is
still accepted (current reference lists `untrusted`/`on-request`/`never`).

**Login-node lockdown** (`~/.codex/config.toml`): read-only, never auto-run:
```toml
approval_policy = "untrusted"
sandbox_mode    = "read-only"
```
If `bwrap` is unavailable, keep `sandbox_mode="read-only"` + `approval_policy="untrusted"` so
nothing runs without an explicit approval; do **not** use `danger-full-access` on shared nodes.

### MCP
`[mcp_servers.NAME]` blocks in `config.toml`, or `codex mcp add` / `codex mcp list`.
```toml
# local stdio
[mcp_servers.example_stdio]
command = "python -m example_server"
args    = ["--flag", "value"]
env     = { API_KEY = "secret" }
enabled = true
startup_timeout_sec = 10
tool_timeout_sec    = 60

# remote streamable HTTP
[mcp_servers.example_http]
url = "https://api.example.com/mcp"
bearer_token_env_var = "MCP_TOKEN"
http_headers = { Authorization = "Bearer token" }
enabled = true
```

### Context files
`AGENTS.md` (native — Codex is a first-class member of the agents.md standard). Discovered and
merged from `~/.codex/AGENTS.md` (user) → repo root → current working directory. Config keys:
`project_doc_max_bytes` (per-file cap), `project_doc_fallback_filenames` (extra names to try),
and `experimental_instructions_file` (point at an arbitrary instructions file — a route to wire
in `/etc/agents.d/*.md`). `project_doc_fallback_filenames` can also add cluster-standard names.

### Install & run
`npm install -g @openai/codex` · `brew install --cask codex` · shell installer
`curl -fsSL https://chatgpt.com/codex/install.sh | sh`. Prebuilt binaries for macOS
(arm64/x86_64) and Linux (x86_64/arm64). Headless/non-interactive: `codex exec "…"`. Runs on
Linux login nodes (Ubuntu 20.04+/Debian 10+; Windows only via WSL2).

---

## 3. Gemini CLI (Google)

Docs: <https://github.com/google-gemini/gemini-cli/blob/main/docs/cli/settings.md> ·
`docs/tools/mcp-server.md` · `docs/tools/shell.md` · `docs/cli/gemini-md.md` ·
`docs/cli/enterprise.md` (all under the repo).

### Config files (JSON) — precedence low→high
1. System defaults `system-defaults.json`
2. User `~/.gemini/settings.json`
3. Workspace `<project>/.gemini/settings.json`
4. **System overrides** (final say): Linux `/etc/gemini-cli/settings.json`, macOS
   `/Library/Application Support/GeminiCli/settings.json`, Windows
   `C:\ProgramData\gemini-cli\settings.json`. Override path via `GEMINI_CLI_SYSTEM_SETTINGS_PATH`.

Newer builds use a nested structure (`tools.*`, `security.*`, `context.*`, `mcpServers`, `mcp`);
older flat keys (`coreTools`, `excludeTools`, `contextFileName`) still appear in the wild.

### Permissions / sandbox
Command control is via the shell tool allow/deny lists with **prefix matching** on
`run_shell_command(<prefix>)`:
```json
{
  "tools": {
    "core":    ["run_shell_command(git)", "run_shell_command(npm)"],
    "exclude": ["run_shell_command(rm)", "run_shell_command(sudo)", "run_shell_command(curl)"]
  }
}
```
`tools.exclude` beats `tools.core`; chained commands (`&&`, `||`, `;`) are split and each part
validated — any disallowed part blocks the whole line. `approvalMode` governs prompting;
`security.disableYoloMode` prevents auto-approve-everything mode. Sandbox: `tools.sandbox`
(bool/`"docker"`/`"podman"`/`"sandbox-exec"`), `tools.sandboxAllowedPaths`,
`tools.sandboxNetworkAccess`, `security.toolSandboxing`. **HPC gotcha:** Gemini's `--sandbox`
relies on Docker/Podman (or macOS Seatbelt) — container runtimes are usually unavailable on HPC
login nodes, so rely on `tools.exclude` + default `approvalMode` instead of the sandbox.

Minimal login-node config (`~/.gemini/settings.json`):
```json
{
  "tools": { "exclude": ["run_shell_command(rm)", "run_shell_command(sudo)"] },
  "security": { "disableYoloMode": true }
}
```

### MCP
`mcpServers` in settings.json. stdio uses `command`; remote SSE uses `url`; streamable HTTP uses
`httpUrl`. Per-server tool filtering with `includeTools`/`excludeTools`; `trust: true` skips
confirmations. Global gate: `mcp.allowed` / `mcp.excluded`.
```json
{
  "mcpServers": {
    "pythonTools": { "command": "python", "args": ["-m", "my_mcp_server"],
                     "cwd": "./mcp", "env": { "DB": "$DB_CONNECTION_STRING" }, "timeout": 15000 },
    "httpServer":  { "httpUrl": "http://localhost:3000/mcp",
                     "headers": { "Authorization": "Bearer TOKEN" } },
    "sseServer":   { "url": "https://api.example.com/sse",
                     "headers": { "Authorization": "Bearer TOKEN" } }
  }
}
```

### Context files
`GEMINI.md` — global `~/.gemini/GEMINI.md`, plus project + ancestor dirs (and just-in-time when a
tool touches a subtree). **Configurable filename**, which is how Gemini adopts the shared
standard: `{"context": {"fileName": ["AGENTS.md", "CONTEXT.md", "GEMINI.md"]}}` (older key:
`contextFileName`). `context.loadMemoryFromIncludeDirectories` and `context.discoveryMaxDirs`
tune discovery. To wire in `/etc/agents.d/*.md`, either symlink into the search path or add its
filename to `context.fileName` and place a copy at a discovered location `[UNVERIFIED]` whether an
absolute path list is accepted directly.

### Install & run
`npm install -g @google/gemini-cli` (or `npx https://github.com/google-gemini/gemini-cli`).
Headless: `gemini -p "…"` / `--yolo` (avoid on shared nodes). Runs on Linux login nodes over SSH.

---

## 4. opencode

Docs: <https://opencode.ai/docs/config/> · <https://opencode.ai/docs/permissions/> ·
<https://opencode.ai/docs/mcp-servers/> · <https://opencode.ai/docs/rules/> · <https://opencode.ai/docs/>

### Config files (JSON / JSONC)
- Global: `~/.config/opencode/opencode.json` (or `.jsonc`); TUI: `~/.config/opencode/tui.json`.
- Project: `opencode.json` / `opencode.jsonc` in repo root.
- System-managed: Linux `/etc/opencode/`, macOS `/Library/Application Support/opencode/`.
- Overrides: `OPENCODE_CONFIG` (file), `OPENCODE_CONFIG_DIR` (dir). Schema: `"$schema": "https://opencode.ai/config.json"`.

### Permissions
`permission` key: a string applied to all, or an object keyed by tool
(`read, edit, glob, grep, bash, task, skill, lsp, question, webfetch, websearch,
external_directory, doom_loop`). Values `allow` / `ask` / `deny`. `bash` accepts a **pattern map**
(glob `*`, `?`); **last matching pattern wins**, so put the catch-all first:
```json
{
  "permission": {
    "bash": {
      "*": "ask",
      "ls *": "allow", "cat *": "allow", "git status": "allow",
      "git push *": "ask",
      "rm -rf *": "deny", "sudo *": "deny", "srun *": "deny", "sbatch *": "deny"
    },
    "edit": "ask",
    "webfetch": "ask"
  }
}
```
Most tools default to `allow`; `doom_loop` and `external_directory` default to `ask`; reading
`.env*` is denied by default. No OS sandbox — permission rules are the enforcement layer.

### MCP
`mcp` object. Local (stdio) uses `type:"local"` + `command` **array**; remote uses `type:"remote"`
+ `url`.
```json
{
  "mcp": {
    "local-tool":  { "type": "local", "command": ["npx", "-y", "my-mcp"],
                     "environment": { "MY_ENV": "val" }, "enabled": true },
    "remote-api":  { "type": "remote", "url": "https://mcp.example.com",
                     "headers": { "Authorization": "Bearer KEY" }, "enabled": true }
  }
}
```
Local extras: `cwd`, `timeout` (ms, default 5000). Remote extras: `oauth`, `timeout`.

### Context files
Reads `AGENTS.md` (project root) and `~/.config/opencode/AGENTS.md` (global); falls back to
`CLAUDE.md` / `~/.claude/CLAUDE.md`. **Native agents.md support.** Additional files via the
`instructions` array (local globs + remote URLs), which is the clean way to wire in shared docs:
```json
{ "instructions": ["docs/standards.md", "packages/*/AGENTS.md", "/etc/agents.d/rcac.md"] }
```

### Install & run
`curl -fsSL https://opencode.ai/install | bash` · `npm install -g opencode-ai` ·
`brew install anomalyco/tap/opencode` (also AUR/pacman). It is a terminal TUI, but the process
runs on the host you launch it on, so it works over SSH on a login node; non-interactive
`opencode run "…"` and a headless `opencode serve` are available. `[UNVERIFIED]` in docs that SSH
is explicitly blessed, but it is a standard terminal program (needs a real terminal emulator on
your side).

---

## 5. Warp

Docs: <https://docs.warp.dev/agent-platform/capabilities/agent-profiles-permissions> ·
<https://docs.warp.dev/agent-platform/capabilities/mcp> ·
<https://docs.warp.dev/agent-platform/capabilities/rules> ·
<https://docs.warp.dev/getting-started/getting-started-with-warp>

### Config model
Warp is a **desktop terminal application** (macOS 10.14+, Windows 10 1903+, Linux glibc≥2.31),
configured through its GUI (Settings) and cloud "Warp Drive" — not a dotfile-first CLI. There is
no `~/.warp/config.*` you edit for agent behavior; MCP is the one place you paste JSON.

### Permissions (Agent Profiles)
Settings > Agents > Profiles. Per-permission-type autonomy: **Agent Decides** / **Always Ask** /
**Always Allow**, applied to: apply diffs, read files, create plans, execute commands, full
terminal use, ask questions. Command control uses **regex**:
- **Allowlist** — auto-run without confirmation, e.g. `ls(\s.*)?`, `grep(\s.*)?`.
- **Denylist** — always require approval; default denylist already blocks `rm(\s.*)?`,
  `curl(\s.*)?`, `wget(\s.*)?`, `eval(\s.*)?`.
- **Denylist beats both the allowlist and "Agent decides."**
Gotcha: **Run-until-completion** (`Cmd/Ctrl+Shift+I`) *ignores the denylist entirely* — dangerous
on a login node. Profiles can be team-managed for shared policy.

### MCP
Settings > Agents > MCP servers (also Warp Drive / Command Palette "Open MCP Servers"). JSON under
an `mcpServers` key; local CLI/stdio uses `command`+`args`(+`env`,`working_directory`); remote
uses `url`(+`headers`).
```json
{
  "filesystem":  { "command": "npx", "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path"] },
  "externalDocs":{ "url": "http://localhost:4000/mcp/stream", "headers": { "my-header": "val" } }
}
```

### Rules / context
Global Rules live in Warp Drive (Personal > Rules). Project Rules are `AGENTS.md` files in the repo
(root or subdirectories); `WARP.md` is the legacy name. **The filename must be ALL CAPS**
(`AGENTS.md`, not `agents.md`). Precedence: subdirectory AGENTS.md → root AGENTS.md → Global Rules.
Native agents.md support, so a cluster-provided `AGENTS.md` is read automatically.

### Install & run — the HPC caveat
Install locally: direct download, `brew install --cask warp` (macOS), WinGet (Windows), or Linux
packages (`.deb`/`.rpm`/`.AppImage`/pacman). **You cannot run Warp headless on a login node** — it
is a GUI app that needs a display and (on first launch) internet + account login. HPC usage: run
Warp on your workstation, then SSH into the RCAC cluster; Warp advertises "Feature support over
SSH," so Agent Mode operates within the remote session while the app stays local. This makes the
per-cluster settings-file story different from the four CLIs: publish an `AGENTS.md` in the repo
(read automatically) and document the recommended Profile denylist; there is no server-side Warp
config file to ship.

---

## HPC deployment notes (cross-cutting)

- **Login-node safety:** deny `rm -rf`, `sudo`, and (arguably) scheduler-launch commands
  (`srun`/`sbatch`) so agents don't spawn jobs unattended. Claude Code and opencode express this
  as per-command deny rules; Gemini as `tools.exclude`; Codex has no per-command list — use
  `sandbox_mode="read-only"` + `approval_policy="untrusted"`; Warp ships a default regex denylist.
- **OS sandboxes are the weak spot on HPC:** Codex needs `bubblewrap` on Linux; Gemini needs
  Docker/Podman; Claude Code uses Linux namespaces — all of which are frequently disabled on
  shared login nodes. Treat the permission/approval layer (not the sandbox) as the primary control
  there, and point writable roots at `/scratch/$USER`.
- **Shared `AGENTS.md`:** Codex, opencode, and Warp read `AGENTS.md` natively; Gemini reads it if
  added to `context.fileName`; Claude Code needs `@AGENTS.md` import or a symlink. A single repo
  `AGENTS.md` therefore covers 4/5 with a one-line Claude bridge.
- **Wiring `/etc/agents.d/*.md`:** Claude Code → managed `/etc/claude-code/CLAUDE.md` with
  `@/etc/agents.d/*.md` imports; opencode → `instructions` array (accepts absolute paths/globs);
  Codex → `experimental_instructions_file` / `project_doc_fallback_filenames`; Gemini →
  `context.fileName`; Warp → repo `AGENTS.md` only (no arbitrary include path).
</content>
</invoke>
