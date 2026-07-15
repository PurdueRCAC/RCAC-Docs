# Research: The three public RCAC MCP servers

Source of truth: the GitHub repos themselves (README, SECURITY.md, ROADMAP.md,
`pyproject.toml`, and selected source files), fetched via `gh` on 2026-07-14.
Anything not stated by the source is marked `[UNVERIFIED]`. Commands/config in
fenced blocks are copied verbatim from the repos.

Common facts across all three:

- All three are **Python** projects built with `fastmcp` (FastMCP `>=2.0.0,<3`)
  and `cmdkit`, packaged with `hatchling`, version `0.1.0`, source under
  `src/<pkg>/`, console entry point `<pkg> = "<pkg>:main"`.
- All three are **installed/run with `uvx` straight from Git** (no PyPI release,
  no npm, no required Docker for the desktop path). `uvx git+https://…` clones,
  builds, and runs in one step.
- **License: MIT** — declared in each README and in SPDX source headers
  (`SPDX-License-Identifier: MIT`). Note: `rcac-mcp` and `rcac-docs-mcp` have **no
  standalone `LICENSE` file** at repo root (GitHub's license API returns 404);
  `globus-mcp` is detected as MIT by GitHub.
- None are archived. Only `globus-mcp` has a tagged release (`v0.1.0`).

---

## 1. `rcac-mcp` — PurdueRCAC/rcac-mcp

Repo: <https://github.com/PurdueRCAC/rcac-mcp>
Description: "Prototype MCP server implementation enabling agentic workflows to
connect with RCAC systems." Default branch `main`; also a `wip` branch.
Last pushed 2026-02-12.

### 1. Purpose
The RCAC MCP Server "enables agentic development with HPC clusters and storage
services." It gives an AI agent/harness a set of tools to operate on an RCAC HPC
cluster — run shell commands, move/read/write files, inspect storage quota and
paths, and drive Slurm (submit/monitor/cancel jobs) — plus a local full-text
documentation search. In the default desktop mode it runs **locally as a stdio
subprocess** and executes everything **on the cluster over the user's existing
SSH**, so no new service or credential is introduced.

### 2. Language / package / install
- Language: Python (`requires-python >=3.14`), package name `rcac-mcp`, entry
  point `rcac-mcp`.
- Deps: `fastmcp`, `cmdkit`, `pyjwt`, `fabric` (SSH), `pyyaml`, `jinja2`.
- Install/run (desktop, via `uvx` from Git — no separate install step needed):
  the MCP client launches `uvx git+https://github.com/purduercac/rcac-mcp`.
- License: MIT (README + SPDX headers; no root `LICENSE` file).

### 3. How to connect it to a harness
**stdio subprocess** (default) for Claude Desktop / Cursor / Warp. Exact
`mcpServers` block from the README:

```json
{
  "mcpServers": {
    "rcac": {
      "command": "uvx",
      "args": ["git+https://github.com/purduercac/rcac-mcp", "--ssh-host", "cluster.rcac.purdue.edu"]
    }
  }
}
```

"This runs the server locally in `stdio` mode, executing commands on the cluster
over SSH using your existing `~/.ssh/config` and keys." You may instead set
`RCAC_SSH_HOST` in the environment and omit `--ssh-host`.

Optional **hosted HTTP** mode (for a shared, authenticated instance):

```bash
rcac-mcp -t http --ssh-host cluster.rcac.purdue.edu
```

With JWT auth + delegate execution, and client-token generation:

```bash
export JWT_SECRET="your-secret-key-at-least-32-characters"
rcac-mcp -t http -a jwt -e delegate

# Generate a token for clients
rcac-mcp --generate-token --lifetime 86400
```

Docker Compose + TLS is documented for production-like deploys (`docker compose
up`, served at `https://mcp.rcac.dev:8443`).
`[UNVERIFIED]` the README does not give a `claude mcp add …` or `codex mcp …`
one-liner — only the `mcpServers` JSON block and the HTTP CLI invocations above.

### 4. Tools exposed (verbatim from README "Available Tools")
Shell & Filesystem:
- `run_command(command, cwd, timeout)`, `list_directory(path, show_hidden)`,
  `read_file(path, encoding, max_size)`, `write_file(path, content, append,
  create_dirs)`, `upload_file(local_path, remote_path)`,
  `download_file(remote_path, local_path)`

RCAC Cluster:
- `myquota()`, `storage_paths()`, `jobinfo(job_id)`, `jobcmd(job_id)`,
  `jobenv(job_id)`, `jobscript(job_id)`, `showpartitions()`,
  `average_wait(partition, account)`

Slurm:
- `sbatch(...)`, `squeue(...)`, `scancel(...)`, `sacct(...)`, `sinfo(...)`,
  `scontrol_show_job(job_id)`, `scontrol_show_node(node)`, `slist()` (accounts &
  usage, RCAC-specific), `sfeatures()` (node hardware features, RCAC-specific)

Documentation:
- `doc_search(query, category)` — full-text search over RCAC docs
- `doc_load(path)` — load a full documentation page

Build the local docs index first (FTS5, from a local RCAC-Docs clone):

```bash
rcac-mcp --index-docs --docs-path /path/to/RCAC-Docs
```

DB defaults to `~/.config/rcac-mcp/docs.db` (override with `--docs-output` or
`RCAC_DOCS_DB`); re-running is incremental.

### 5. Architecture — local-first, confirmed
SECURITY.md defines three execution modes:

| Mode | Transport | Auth | Use |
|------|-----------|------|-----|
| `ssh` | stdio | none (single-user) | local MCP client → remote HPC cluster (default) |
| `local` | http/sse | none | dev/testing only, runs on the server's own `$SHELL` |
| `delegate` | http/sse | JWT/OIDC | multi-user prod; server runs as root, `sudo -u <user>` per request |

Local-first model **confirmed**: in the default `ssh`/stdio mode the server runs
on the user's machine, uses the user's existing `~/.ssh/config` + keys, adds **no
MCP-layer auth and no new credential**, and all commands run as the SSH user on
the cluster ("Security boundary is the SSH connection itself"). Delegate mode
isolates concurrent users with `contextvars.ContextVar` and maps token identity
to a local Unix user via `RCAC_USER_MAP` (`/etc/rcac-mcp/users.map`), wrapping
commands as `sudo -n -H -u <user>`.

**`/etc/agents.d` context injection — confirmed.** `src/rcac_mcp/resources.py`
implements a `cluster_context` MCP resource that, over the same SSH executor,
runs `find /etc/agents.d -maxdepth 1 -name "*.md" -type f | sort`, `cat`s each
file, concatenates them (with `<!-- Source: <file> -->` headers), and caches the
result per hostname. `server.py` exposes it as the resource
`rcac://context` ("Cluster-specific context loaded from /etc/agents.d/*.md").
So the cluster can drop admin-authored markdown into `/etc/agents.d/` and the
server surfaces it to the agent as read-only context.

**Plugin / `cluster-mcp[slurm,lmod,…]` direction — `[UNVERIFIED]`.** No public
artifact in this repo (README, ROADMAP.md, source on `main` or `wip`) mentions
`cluster-mcp`, a plugin/extras architecture, or an "HPC-only" refocus. An
org-wide `gh search code --owner PurdueRCAC "cluster-mcp"` returned **zero
hits**. As of the last push (2026-02-12) the repo still bundles the docs-search
tools (`doc_search`/`doc_load`), i.e. it has **not** yet been split into
HPC-only + a plugin catalog. Treat the plugin/`cluster-mcp` framing as roadmap
intent not yet reflected in the public code. (Note the docs-search capability was
subsequently extracted into the separate `rcac-docs-mcp` repo, pushed
2026-06-26 — see §3 below.)

### 6. Status / caveats
Repo description and README both call it a **prototype**. Version `0.1.0`, **no
tagged release**. ROADMAP.md is actually the completed plan for the docs-search
feature (status `complete`, `local-to-mcp-process`), not a product roadmap.
`local` mode is explicitly "dev/testing only, NEVER expose to a network without
auth." A live `wip` branch exists.

---

## 2. `globus-mcp` — PurdueRCAC/globus-mcp

Repo: <https://github.com/PurdueRCAC/globus-mcp>. Last pushed 2026-04-12;
tagged release `v0.1.0` "Auth, Consent, and Globus Compute."

### 1. Purpose
"Globus MCP Server gives AI agents federated data transfer and remote code
execution across research storage systems at institutions worldwide." It wraps
the **Globus CLI** (data transfer) and the **Globus Compute SDK** (remote Python
execution on HPC endpoints), so an agent can search endpoints, browse remote
filesystems, run async transfers, and submit Python functions to Compute
endpoints.

### 2. Language / package / install
- Language: Python (`requires-python >=3.11,<3.14`), package name `globus-mcp`,
  entry point `globus-mcp`.
- Deps: `fastmcp`, `cmdkit`, `globus-compute-sdk>=4.0.0,<5` (Globus CLI wrapped
  at runtime).
- Optional prerequisite: **Globus Connect Personal** for transfers to/from the
  local machine.
- Install/run: `uvx` from Git (handled automatically by the MCP client).
- License: MIT.

### 3. How to connect it to a harness
**stdio subprocess** for Claude Desktop / Cursor / Warp. Exact `mcpServers` block
from the README:

```json
{
  "mcpServers": {
    "globus": {
      "command": "uvx",
      "args": ["git+https://github.com/purduercac/globus-mcp"]
    }
  }
}
```

"The `uvx` invocation handles installation automatically. On first use, the
server's `globus_login()` and `compute_login()` tools will walk users through
authentication via the browser." Auth is **interactive Globus OAuth**, done
through tool calls at runtime (not config). `[UNVERIFIED]` no `claude mcp add`,
`codex mcp`, or hosted-HTTP endpoint is documented — this server is
stdio/local-only in the README, plus `globus-mcp` for dev.

### 4. Tools exposed (verbatim from README "Available Tools")
Identity & Auth: `whoami()`, `globus_login()`, `session_consent(scopes)`
Endpoints: `endpoint_search(query)`, `endpoint_show(endpoint_id)`,
`endpoint_local_id()`
Filesystem: `ls(endpoint_id, path)`, `stat(endpoint_id, path)`,
`mkdir(endpoint_id, path)`, `rename(endpoint_id, source_path, dest_path)`,
`rm(endpoint_id, path)` (sync), `delete(endpoint_id, path)` (async)
Transfers: `transfer(...)`, `transfer_batch(...)`, `task_list()`,
`task_show(task_id)`, `task_wait(task_id)`, `task_cancel(task_id)`,
`task_event_list(task_id)`
Compute (remote code execution): `compute_login()`, `compute_endpoint_list()`,
`compute_endpoint_status(endpoint_id)`, `compute_submit(...)`,
`compute_batch_submit(...)`, `compute_status(task_ids)`, `compute_result(task_id)`

### 5. Architecture — local-first, confirmed
Runs as a **local stdio subprocess** of the harness. It uses the **user's own
Globus identity**: auth is obtained interactively via browser OAuth through
`globus_login()`/`compute_login()`, and endpoint-specific access is unlocked via
`session_consent(scopes)` (the server returns a structured `ConsentRequired`
error carrying the needed scopes, the agent grants consent, then retries). For
Compute with a `requirements` list, the server auto-provisions a cached `uv`
virtualenv on the remote endpoint. No new RCAC-hosted service or credential store
is introduced — it rides on the user's Globus auth and local Globus tooling.

### 6. Status / caveats
Prominent README banner: **"⚠️ Beta Software … has not reached a stable v1.0.0
release. APIs, tool signatures, and behavior may change without notice. Use with
caution in production workflows."** Version `0.1.0`; the one tagged release is
`v0.1.0`.

---

## 3. `rcac-docs-mcp` — PurdueRCAC/rcac-docs-mcp

Repo: <https://github.com/PurdueRCAC/rcac-docs-mcp>. Last pushed 2026-06-26.
Description: "MCP service for RCAC Documentation site with full-text search and
load tools."

### 1. Purpose
"A single-purpose FastMCP server that exposes Purdue RCAC's documentation to AI
agents via full-text search." It indexes the RCAC-Docs content (user guides,
software catalog, datasets, blog posts, workshops) into an FTS5/BM25 SQLite index
and exposes exactly two tools so agents ground their advice in current
authoritative docs rather than general knowledge. It runs **unauthenticated** and
is **hosted at `docs.rcac.purdue.edu/mcp`**.

### 2. Language / package / install
- Language: Python (`requires-python >=3.14`), package name `rcac-docs-mcp`,
  entry point `rcac-docs-mcp`.
- Deps: `fastmcp`, `cmdkit`, `pyyaml`, `jinja2`.
- Install/run (local): `uvx` from Git.
- License: MIT (README + no root `LICENSE` file, so GitHub license API 404s).

### 3. How to connect it to a harness
Two supported paths.

**(a) Hosted remote HTTP endpoint (recommended for most users).** A shared,
no-auth instance is hosted at **`docs.rcac.purdue.edu/mcp`**. Per the README:
"Point an HTTP-capable MCP client at that URL — no token or credentials are
required." `[UNVERIFIED]` the README gives the URL but **no** literal client
config JSON or `claude mcp add --transport http …` line for the hosted endpoint;
use your harness's standard "add remote/HTTP MCP server" flow pointed at
`https://docs.rcac.purdue.edu/mcp`.

**(b) Local stdio subprocess.** Exact `mcpServers` block from the README:

```json
{
  "mcpServers": {
    "rcac-docs": {
      "command": "uvx",
      "args": ["git+https://github.com/PurdueRCAC/rcac-docs-mcp"]
    }
  }
}
```

The local server needs a search index before it can answer; build it first (see
§5). Transports and serve commands (verbatim):

```bash
rcac-docs-mcp                      # serve over stdio (local clients)
rcac-docs-mcp -t http -H 0.0.0.0   # serve over HTTP (hosted)
```

(`rcac-docs-mcp -t http` alone serves streamable HTTP on `localhost:8000` for
dev.)

### 4. Tools exposed (verbatim — "exactly two tools")
- `doc_search(query, category=None)` — FTS5 / BM25 full-text search over indexed
  RCAC documentation. Returns up to 20 BM25-ranked results with path, title,
  heading, and a matching snippet. Supports `OR`, quoted phrases, prefix
  wildcards (`contai*`); `category` is a path-prefix filter (`userguides`,
  `software`, `datasets`, `blog`, `workshops`).
- `doc_load(path)` — return the full rendered markdown of one document by its
  relative path (as shown in `doc_search` results).

### 5. Architecture — hosted HTTP + local-first, confirmed
Runs unauthenticated over two transports: **`stdio`** (default, local clients)
and **`http`** (streamable HTTP, for the hosted deployment). Unlike `rcac-mcp`
and `globus-mcp`, this server **does not SSH anywhere and needs no user
credentials** — it only reads a local SQLite index, so the hosted instance can be
fully public/no-auth.

A "**site**" is one directory holding both a clone of RCAC-Docs (`repo/`) and the
index (`index.db`); resolved from `--site` → `RCAC_DOCS_SITE` → default
`~/.local/share/rcac-docs-mcp`. Env vars: `RCAC_DOCS_SITE`, `RCAC_DOCS_URL`
(default `https://github.com/PurdueRCAC/RCAC-Docs`), `MCP_BASE_URL` (public URL
for absolute icon links). Build the index (two-step operator flow):

```bash
rcac-docs-mcp --update-site   # clone or git-pull <site>/repo
rcac-docs-mcp --index         # build/refresh <site>/index.db from <site>/repo
```

`--update-site` does `git pull --rebase --autostash origin main`; `--index` is
incremental (SHA-256 hashing, stale-doc pruning). The indexing pipeline walks
`docs/`, parses YAML frontmatter, resolves `--8<--` snippet includes, renders
Jinja2 macros/templates from the docs repo's `main.py` + `mkdocs.yml extra:`,
strips the `<!-- more -->` blog marker, chunks on `##` (H2) boundaries, and
upserts into SQLite; search uses an FTS5 virtual table with BM25 + `snippet()`.
This is the same doc-search capability that lives inside `rcac-mcp`, factored out
into its own hostable service.

### 6. Status / caveats
Version `0.1.0`, no tagged release; single-purpose and intentionally minimal
("exactly two tools"). No explicit "beta" banner, but pre-1.0. When run locally
without a built index, the tools return a helpful message explaining how to build
one. Many integration tests depend on a git-submodule fixture
(`tests/fixtures/RCAC-Docs`) that skips cleanly when uninitialized.

---

## Org scan — other agentic/MCP-related PurdueRCAC repos
From `gh repo list PurdueRCAC --limit 200`:

- **`agentbase`** (private, updated 2026-05-19) — "Core framework for agentic
  content search over internal knowledge bases." The most relevant adjacent
  project; private, so contents `[UNVERIFIED]`. Likely the internal-KB analogue
  of the public docs-search MCP work.
- **`genai-studio`** (public) — "Reference configurations for Purdue GenAI
  Studio." AI-adjacent but not MCP.
- **`CANARI`** (public) — "CANARI framework developed at RCAC" — unclear scope,
  possibly AI-related; `[UNVERIFIED]`.
- No other repos reference MCP or `cluster-mcp`. The three servers above are the
  only public MCP servers in the org.
