# Research 05 — user opt-in per harness, rcac-mcp context behavior, prose audit (R6, R8)

Date: 2026-10-09. Sources are cited inline. "Source" means the harness's own code on its
default branch, fetched today, where the official docs are silent or ambiguous.

## Key findings

1. Each CLI harness has a one-time, user-level hookup. Claude Code and opencode can point at the
   file directly. Codex has no include syntax, so it needs a symlink. **Gemini CLI's `@import`
   from `~/.gemini/GEMINI.md` does not work for `/etc/agents.d/AGENTS.md`.** It needs a
   symlink plus one setting.
2. Warp has no file-based hookup for a remote host. The best option is a Global Rule that
   tells the agent to read the file.
3. Home directories are per cluster, and shared between that cluster's front-end and compute
   nodes. So the hookup is done once per cluster, and then it works in batch and interactive
   jobs too.
4. `rcac-mcp` does **not** inject the context. It exposes `rcac://context` as an MCP
   resource, which is read on demand. The path is hard-coded, not configurable. Because the
   assembled `AGENTS.md` sits in the same directory, the resource returns every rule twice.
5. Five published pages and the three cluster chapters still say that per-harness settings
   are deployed, or that `rcac-mcp` injects context. Replacement sentences are in C.2 and C.3.

---

## A. Per-harness user opt-in (R6)

### A.0 Where the hookup lives

The home directory is per cluster. It is shared across that cluster's front-end (login) hosts
and compute nodes, and is not shared between clusters:

- Bell, Gautschi, Gilbreth, Negishi, Scholar: each `faqs.md` says *"The {Cluster} home
  directory and its contents are exclusive to {Cluster} cluster front-end hosts and compute
  nodes … not available on other RCAC machines"*. See `docs/userguides/gautschi/faqs.md:32`,
  `gilbreth/faqs.md:60`, `negishi/faqs.md:44`, `bell/faqs.md:50` and `scholar/faqs.md:26`.
- Anvil: `docs/userguides/anvil/file_management.md:17` says *"Each file system is available
  from all Anvil nodes"*, and `architecture.md:45` says *"mounted across all Anvil nodes"*.

What this means for the docs:

- Tell users to do the hookup **once on each cluster they use**. It is not a one-time step
  across RCAC.
- Once it is done, it also applies inside Slurm jobs, provided `/etc/agents.d/` is present on
  compute nodes as R6 states.
- When the file is missing, every harness below skips it without failing:
  - Codex: a dangling symlink gives `NotFound`, which is skipped.
  - opencode: a glob with no match is skipped.
  - Gemini CLI: a failed `fs.access` is skipped.
  - Claude Code: the docs do not say what happens to an import whose target is missing.

The assembled file is 9.8–10.3 KB and 231–235 lines (`docs/snippets/agentic-ai/*/agents.d/AGENTS.md`).
That is well under every size limit below.

### A.1 Ranked by reliability

| Rank | Harness | One-time hookup | Additive to the user's own global file? | Verified against |
|---|---|---|---|---|
| 1 | opencode | add `"instructions": ["/etc/agents.d/AGENTS.md"]` to `~/.config/opencode/opencode.json` | yes | docs + source |
| 2 | Claude Code | append `@/etc/agents.d/AGENTS.md` to `~/.claude/CLAUDE.md` | yes | docs |
| 3 | Codex CLI | `ln -s /etc/agents.d/AGENTS.md ~/.codex/AGENTS.md` | **no**: it replaces the global file | docs + source |
| 4 | Gemini CLI | `ln -s /etc/agents.d/AGENTS.md ~/.gemini/AGENTS.md`, then `context.fileName: ["GEMINI.md","AGENTS.md"]` in `~/.gemini/settings.json` | yes | source (the docs are misleading) |
| 5 | Warp | a Global Rule telling the agent to read the file (it is not loaded as a file) | n/a | docs |

### A.2 opencode

```json title="~/.config/opencode/opencode.json"
{
  "$schema": "https://opencode.ai/config.json",
  "instructions": ["/etc/agents.d/AGENTS.md"]
}
```

- **Docs** (<https://opencode.ai/docs/rules/>):
  - The `instructions` array can be set in the global `~/.config/opencode/opencode.json`.
  - *"All instruction files are combined with your `AGENTS.md` files."*
  - The docs show only relative paths, globs and URLs.
- **Source** (`packages/opencode/src/session/instruction.ts`, `systemPaths()`, `dev` branch):
  - A path beginning `~/` is expanded to `$HOME`.
  - An absolute path is globbed with `cwd = dirname(path)`, so an absolute file path works.
- **Caveats:**
  - If the file already exists, merge in the `instructions` key. Do not overwrite the file.
  - **Do not rely on opencode's fallback to `~/.claude/CLAUDE.md`.** opencode reads that file
    only when `~/.config/opencode/AGENTS.md` is absent. It reads the file raw, so an
    `@/etc/agents.d/AGENTS.md` line in it stays a literal string and is not expanded.
  - The `instructions` key works whether or not the user has their own global `AGENTS.md`.

### A.3 Claude Code

```bash
mkdir -p ~/.claude && echo '@/etc/agents.d/AGENTS.md' >> ~/.claude/CLAUDE.md
```

- **Docs** (<https://code.claude.com/docs/en/memory>, "Import additional files"):
  - *"Both relative and absolute paths are allowed."*
  - Imports can be nested up to *"a maximum depth of four hops"*.
  - `~` paths work too, for example `@~/.claude/my-project-instructions.md`.
  - *"User-scope memory files, such as `~/.claude/CLAUDE.md` … Claude Code loads their imports
    without the dialog."* So there is no approval prompt, unlike external imports in a project
    `CLAUDE.md`. The exception is Cowork desktop sessions, which skip out-of-tree imports. That
    exception does not apply on a cluster.
- **Caveats:**
  - Claude Code's native `AGENTS.md` reading covers the working directory and the directories
    above it only (same page, "AGENTS.md"), so it never finds `/etc/agents.d/`. The import line
    is required.
  - `>>` appends, so a user's existing `~/.claude/CLAUDE.md` is kept.
  - The docs suggest *"target under 200 lines per CLAUDE.md file"*, and the assembled file is
    about 235 lines. This is a guideline, not a limit. Mention it only if the plan wants to.
  - Users can check what loaded with `/memory`.
- **Do not suggest:**
  - The managed path `/etc/claude-code/CLAUDE.md`. It is a non-goal in GOAL.md.
  - Symlinking into `~/.claude/rules/`. It is not needed.

### A.4 OpenAI Codex CLI

```bash
mkdir -p ~/.codex && ln -s /etc/agents.d/AGENTS.md ~/.codex/AGENTS.md
```

- **Docs** (<https://developers.openai.com/codex/guides/agents-md>, which now redirects to
  <https://learn.chatgpt.com/docs/agent-configuration/agents-md>):
  - Global scope is `$CODEX_HOME` (default `~/.codex`). Codex reads `AGENTS.override.md` if it
    exists, and otherwise `AGENTS.md`, and uses *"only the first non-empty file at this level"*.
  - There is **no include or import syntax**. The page says nothing about includes or
    symlinks.
  - `project_doc_max_bytes` (default 32 KiB) caps the *combined* size of the project chain.
- **Source:**
  - `codex-rs/codex-home/src/instructions/mod.rs` reads the global file with
    `tokio::fs::metadata` and `tokio::fs::read`, both of which follow symlinks. A missing file
    is skipped.
  - In `codex-rs/core/src/agents_md.rs`, the global file is passed in as `user_instructions`,
    and the `remaining = project_doc_max_bytes` budget is spent only on project files. So the
    global file does not count against the 32 KiB budget. At about 10 KB it would fit anyway.
- **Caveats:**
  1. **Existing `~/.codex/AGENTS.md`:** `ln -s` fails with "File exists". There is no additive
     route, so the user has to choose. They can either replace their file with the link, or
     copy both into one file (`cat their.md /etc/agents.d/AGENTS.md > ~/.codex/AGENTS.md`).
     A copy goes stale when RCAC updates the file. Do not tell users to use `ln -sf`, which
     silently discards their own file.
  2. A `~/.codex/AGENTS.override.md` hides `AGENTS.md`.
  3. Users who set `CODEX_HOME` must link inside that directory instead.
  4. Do not suggest `model_instructions_file`. It replaces Codex's built-in base
     instructions, so it is not a way to add context.
  5. To check: `codex --ask-for-approval never "Summarize the current instructions."`
     (from the docs page).

### A.5 Gemini CLI

```bash
mkdir -p ~/.gemini && ln -s /etc/agents.d/AGENTS.md ~/.gemini/AGENTS.md
```

```json title="~/.gemini/settings.json (merge into the existing file)"
{
  "context": { "fileName": ["GEMINI.md", "AGENTS.md"] }
}
```

- **The obvious hookup does not work.** That hookup is `@/etc/agents.d/AGENTS.md` inside
  `~/.gemini/GEMINI.md`.
  - The docs (<https://geminicli.com/docs/reference/memport/>,
    <https://geminicli.com/docs/cli/gemini-md/>) say imports support *"both relative and
    absolute paths"*. Memport also says *"`validateImportPath` … ensures that imports are only
    allowed from specified directories."*
  - In source (`packages/core/src/utils/memoryImportProcessor.ts` and `memoryDiscovery.ts`,
    `main` at 0.65.0-nightly.20261006), `readGeminiMdFiles()` calls `processImports()` with no
    `projectRoot`.
  - So `projectRoot = findProjectRoot(dirname(file), ['.git'])`. For `~/.gemini/GEMINI.md`
    that is `~/.gemini`, or `$HOME` if the home directory is itself a git repository.
  - `validateImportPath()` rejects any target outside that root, after resolving symlinks with
    realpath. The fix for symlink escapes landed 2026-07-01 (#28233).
  - An import of `/etc/agents.d/AGENTS.md` is therefore replaced with
    `<!-- Import failed: … - Path traversal attempt -->`.
- **Why the symlink works:** `getGlobalMemoryPaths()` checks every name in `context.fileName`
  under `~/.gemini/`, and file identity uses `stat()`, which follows symlinks. The top-level
  global file is never passed through `validateImportPath`.
- **Keep `GEMINI.md` first in the list.** Gemini's `save_memory` tool writes to
  `~/.gemini/<first fileName>` (`tools/memoryTool.ts`, `getCurrentGeminiMdFilename()` returns
  `[0]`). If `AGENTS.md` came first, `save_memory` would try to write through the symlink to a
  root-owned file and fail.
- **Side effect:** adding `AGENTS.md` to `context.fileName` also makes Gemini load project
  `AGENTS.md` files. Most users will want that.
- **Simpler variant** for a user with no `~/.gemini/GEMINI.md` who never uses `save_memory`:
  `ln -s /etc/agents.d/AGENTS.md ~/.gemini/GEMINI.md`, with no settings change. It is not
  recommended, because `save_memory` then fails.
- **To check:** `/memory show`. Use `/memory reload` after changing anything.
- **Aside:** the Gemini docs banner says the CLI is being replaced by "Antigravity CLI" for
  unpaid-tier users. Nothing for us to act on, but the plan may want to note it.

### A.6 Warp

**No file-based hookup exists for a host you SSH into.**

- Per <https://docs.warp.dev/agents/capabilities/rules.md>:
  - Global Rules live in Warp Drive (Personal > Rules > Global). They are free text, with no
    import or file reference.
  - Project Rules are an all-caps `AGENTS.md` or `WARP.md` in the repository root or the
    current directory. `/init` can link only `CLAUDE.md`, `GEMINI.md` and similar files.
  - The page does not say whether Project Rules are read from a remote SSH host.
- **The most reliable user step** is a Global Rule (one-time, per Warp account) that tells the
  agent to read the file:

  > When the terminal session is on an RCAC cluster (hostname ending in `.rcac.purdue.edu`),
  > run `cat /etc/agents.d/AGENTS.md` before running other commands, and follow it.

- **Caveats:**
  - This is an instruction, not a load. The agent reads the file by running a command.
  - Do not tell users to copy the file into their working directory, as `local.md:117-121`
    does now. The copy goes stale and gets mixed into the project's own `AGENTS.md`.

---

## B. rcac-mcp current behavior (R6, last sentence)

**Versions read** in `~/Software/github.com/purduercac/rcac-mcp`:

- The checked-out branch is `feature/strip-docs-subsystem` @ `7fbf122` (2026-08-26).
- `main` = `origin/main` @ `c285704` (2026-08-26), `pyproject` version `0.1.0`.
- `src/rcac_mcp/resources.py` is identical on both branches.

**What it actually does.** Code is at `resources.py`, registered at `server.py:154-160`.

- It registers two MCP **resources**, not tools:
  - `rcac://context` (name `cluster_context`)
  - `rcac://storage` (name `storage_paths`)
- On a resource read (lazily, not at connect), the `rcac://context` handler runs this over the
  SSH executor:

  ```
  find /etc/agents.d -maxdepth 1 -name "*.md" -type f | sort
  ```

  It then `cat`s each file and joins them with `<!-- Source: {filename} -->` headers.
- The path is **hard-coded**. There is no flag or environment variable to change it.
- A missing directory returns `''`.
- The result is cached per hostname for the life of the process. In delegate (HTTP) mode this
  cache leaks one user's context to other users (rcac-mcp `ROADMAP.md`,
  `issues/context-cache-cross-user.md`). That does not matter for local stdio use.
- The server's `instructions` string lists `rcac://context`, so the model is told the
  resource exists.
- **No client injects an MCP resource automatically.**
  - Claude Code attaches a resource when the user @-mentions it, here
    `@rcac:rcac://context`. Claude also gets list/read-resource tools
    (<https://code.claude.com/docs/en/mcp>, "Use MCP resources").
  - Gemini CLI (`list_mcp_resources` / `read_mcp_resource`,
    <https://geminicli.com/docs/tools/mcp-resources/>) and recent Codex releases also expose
    read tools that the model chooses whether to call.
- **Duplication.** R1/R6 place the assembled `AGENTS.md` in `/etc/agents.d/` next to the five
  topic files. The glob then returns `AGENTS.md` (which sorts first) plus all five topic files,
  so every rule appears twice (about 20 KB). Changing the code is a non-goal. The docs should
  describe the resource as "every `.md` file in `/etc/agents.d/`" and must not claim it is
  deduplicated. The plan should note this.

**Mismatches on the site.** Plain wording for all of them:

> If you run a harness on your own machine with `rcac-mcp`, the server offers the cluster's
> `/etc/agents.d/*.md` files as a read-only MCP resource, `rcac://context`. The agent sees it
> only when it reads that resource or you attach it (in Claude Code, type
> `@rcac:rcac://context` in a prompt).

| File:line | Claim | Problem |
|---|---|---|
| `mcp_servers.md:89` | heading "It injects the cluster's shared context" | does not inject; exposes a resource |
| `mcp_servers.md:91-94` | "`/etc/agents.d/` on the host (a configurable location)" | the path is hard-coded |
| `mcp_servers.md:96-98` | "reach a locally-run agent without you installing anything … the server injects them at connect time" | loaded on read, not at connect; not pushed into the agent |
| `mcp_servers.md:108-109` | "it still bundles the documentation-search tools" | true on `main`; false on the unmerged `feature/strip-docs-subsystem`. Soften to "the current release also includes…" or drop |
| `mcp_servers.md:81-87` | tool list | omits `jobcmd` and `jobenv`, which the server instructions list. Minor; "names may evolve" covers it |
| `running_agents/local.md:38-40` | "The agent also gets cluster-aware context automatically: `rcac-mcp` … injects them" | not automatic |
| `shared_context/index.md:38-40` | "injects the concatenated context to your agent as a read-only resource — so a locally-run agent gets the same guidance without you installing anything" | "read-only resource" is right; "injects" and "gets the same guidance" overstate it |
| `shared_context/context_files.md:10-11` | "deployed to the cluster and injected into agents by `rcac-mcp`" | same |
| `best_practices.md:44-48` | "RCAC injects cluster-specific context into agents automatically … an agent connected to our tooling already knows…" | same, and on the cluster it is opt-in |
| `userguides/{gautschi,gilbreth,negishi}/using_ai_agents.md:41-43` | "and `rcac-mcp` injects them into an agent" | same |

---

## C. Prose audit (R8)

### C.1 Flowery, promotional, slogan and rhetorical lines

Plain instructional sentences are left alone. "Bold" means bold used for emphasis rather than
as a label. Cluster chapters: Gautschi line numbers are shown. Gilbreth is +2 after line 44,
and Negishi is +1 after line 44.

| File:line | Quote | Plain rewrite |
|---|---|---|
| index.md:13-17 | "RCAC's stance is **proactive engagement, not prohibition**. Rather than forbidding these tools, we shape the context … correct for *our* systems … **verify** that output rather than simply trust it." | "RCAC does not prohibit these tools. It publishes cluster-specific context that makes their output more likely to be correct on RCAC systems, and guidance on checking that output." |
| index.md:19 | "These tools are genuinely useful, but…" | "These tools can produce answers that look correct and are wrong: …" |
| index.md:21-23 | "The aim of this section is to make the tools work *well* on RCAC…" | "This section describes the context RCAC provides and how to check what an agent produces." |
| index.md:24-25 | "Treat an agent as **augmenting your expertise, not outsourcing it** — ask *why*, not just *what*." | "Review what the agent proposes, and ask it to explain its choices." |
| index.md:29 | "This is new, actively-developed work." | "This material is new and will change." |
| index.md:51-52 | "…verifying output; and the caution/blast-radius risks." | "…checking output; and the risks of letting an agent run commands." |
| index.md:60-61 | "context that knows our clusters" | "cluster-specific context" |
| index.md:93-95 | italic footer citing "Hello Computer: HPC in the Agentic Era" | Keep the citation; the title is the paper's real title. Drop the italics, or move it to a plain "Reference:" line. |
| acceptable_use.md:12-13 | "does not change the rules — it raises the stakes." | "The rules for using RCAC systems apply to agents too. An agent can run commands faster than you can read them." |
| acceptable_use.md:15-16 | "**You are accountable for everything your agent does under your account**, exactly as if you had typed it yourself." | Same sentence without the bold. |
| acceptable_use.md:39 | "SHALL go through the Slurm scheduler" | "must go through Slurm" (RFC keyword in user docs) |
| acceptable_use.md:52-53 | "before an agent ever touches it" | "before you give an agent access to it" |
| acceptable_use.md:74-75 | "The same courtesy you extend as a human user extends to your agent:" | "The same expectations apply to your agent:" |
| best_practices.md:10-14 | "genuinely useful … less about the model than about *how you use it* … separate a productive session from a frustrating — or costly — one." | "Agents can draft submission scripts, fix build errors, and automate routine workflow steps. They also make mistakes that look correct. This page lists practices that reduce those mistakes." |
| best_practices.md:23 | "This is where agents shine, and where you can let them iterate freely." | "Agents work well here, and you can let them iterate." |
| best_practices.md:30 | "trustworthy for the first and needs a short leash for the second." | "Give the agent more freedom for research tasks and review every command for operations tasks." |
| best_practices.md:37-40 | "An agent is only as good as the context it operates in … The canonical illustration is Picard ordering from the replicator: not 'a drink,' but 'Tea, Earl Grey, hot.'" | "Specific requests get better results than vague ones:" (delete the Picard line) |
| best_practices.md:51-52 | "prevents the single most common failure mode on HPC" | "prevents a common failure:" (unsupported superlative) |
| best_practices.md:54, 56-57 | heading "Verify: augmented, not outsourced"; "The goal is to be **augmented, not outsourced**." | heading "Check the output"; delete the sentence |
| best_practices.md:62 | "**Verification isn't optional — it's the core competency.**" | "**Check before you run.**" |
| best_practices.md:66-68 | "**Mind the expertise paradox.** These tools are most dangerous precisely where you know the least…" | "**Be careful outside your expertise.** You are least able to catch an error where you know the least." |
| best_practices.md:64-65 | "with total confidence" | "without any sign of doubt" or drop |
| best_practices.md:73 | "Counterintuitively, the safest agents are the ones that look before they leap." | "Let the agent check the cluster's state before it acts." |
| best_practices.md:74 | "Encourage — and permit — your agent to run **read-only sanity checks** eagerly" | "Allow your agent to run these read-only checks without asking:" |
| best_practices.md:92-96 | "don't introduce new *kinds* of risk … so much as they **accelerate the pace** … has to be *respected*, not bypassed." | "Agents do not add new kinds of risk, but they make ordinary mistakes happen faster. Cgroups, quotas, health checks, root-squash and per-user permissions still apply to an agent acting as you." |
| best_practices.md:98-99 | "in the time it takes to read the confirmation prompt" | "An agent can run `rm -rf` on a project directory." |
| best_practices.md:109 | heading "Containers offer limited protection — this is not Docker" | "Containers do not isolate an agent" |
| best_practices.md:116-121 | bold on "**Apptainer**", "**automatically bind-mounts…**", "**writable**"; "quietly *modifying files*" | remove the bold and italics; "an agent changing files on a mounted filesystem" |
| best_practices.md:128-130 | "**unavailable on shared login nodes** … **permission and approval layer as your primary control**" | same text, no bold |
| mcp_servers.md:13 | "**context that knows our clusters**" | "cluster-specific context" |
| mcp_servers.md:17-19 | "This is the fix for the failure mode at the heart of agentic HPC…" | "With these servers, an agent can check the cluster's actual state instead of guessing." |
| mcp_servers.md:23-25 | "**working prototypes under active development** … **will change over time**" | no bold |
| mcp_servers.md:42-49 | bold "**on the cluster over your existing SSH connection**", "**local-first**", "**no new service and no new credential**" | no bold |
| mcp_servers.md:103-109 | bold "**refocus…**", "**generalized plugin model**", "**stated direction … not something that has shipped**" | no bold; keep the facts |
| mcp_servers.md:123, 150, 160 | "**beta**", "**this documentation site**", "**hosted instance at…**" | no bold |
| mcp_servers.md:181-182 | "we publish them openly precisely so the community can shape them" | "The servers are MIT-licensed. Issues and pull requests are welcome." |
| running_agents/index.md:24-26 | "**Warp** … its Agent Mode rides your live session" | "Warp runs on your machine; you SSH to the cluster in it, and its agent works in that session." |
| running_agents/local.md:16-20 | bold "**tool calls**", "**not**" | no bold |
| running_agents/local.md:28 | "three consequences worth stating plainly" | "This means:" |
| running_agents/local.md:30-36 | bold labels plus "**If you can SSH to the cluster, your agent can too**, within the same permissions." | keep the bold labels; drop the bold on the last sentence: "The agent has the same access you have over SSH." |
| running_agents/local.md:107-109, 113 | "Agent Mode then rides your live SSH session" | "the agent reads output and runs commands in the SSH session you opened" |
| running_agents/local.md:126-130 | "**ignores the denylist entirely** — a real hazard" | "Run-until-completion mode ignores the denylist. Do not use it on cluster sessions." |
| running_agents/local.md:134 | "a well-worn path at RCAC" | "RCAC already documents this pattern for VS Code:" |
| running_agents/on_cluster.md:11-13 | bold harness names "**Claude Code**, **Codex**…" | no bold |
| running_agents/on_cluster.md:41-43 | "**not backed up and is purged after a period of inactivity**" | no bold |
| running_agents/on_cluster.md:47-55 | bold "**unavailable or disabled…**", "**Apptainer**", "**auto bind-mounts…**", "**permission/approval rules as your primary control**" | no bold |
| running_agents/on_cluster.md:107-109 | "**RCAC's recommended harness for most users** — but it is a **desktop application** … **cannot be installed on a login node**. There is no login-node path for Warp, and you should not try to fabricate one." | "Warp is a desktop application. It does not run on a login node." |
| running_agents/on_cluster.md:112 | "rides your live SSH session" | as for local.md |
| shared_context/index.md:11-15 | "gives them two things up front … verbatim, as the canonical source of truth — so you can see exactly what your agent is told and how it is constrained" | (also false, see C.2) "RCAC publishes the context files it places on each cluster, so you can read exactly what an agent is told." |
| shared_context/index.md:22-24 | 'so the agent "absorbs the cluster's rules before you ask your first question."' | "Once you connect your harness to these files, the agent reads them at the start of every session." |
| shared_context/index.md:26 | "**a fact → the correct command or path → an explicit "do not…" → the rationale.**" | no bold |
| shared_context/index.md:47-48 | "improve fastest with input from the people using them" | "To report an error or a missing rule:" |
| shared_context/context_files.md:10-14 | bold "**shared-context files**", "**generated per cluster**" | no bold |
| shared_context/context_files.md:22 | "deliberately **not hardcoded**" | "are not in the files" |
| shared_context/settings.md:44-49 | "A v0 starting point — please push back … **deliberate first draft**" | Removed by the R5 stub. Do not carry it into the stub. |
| using_ai_agents.md:19-21 (all three) | "RCAC's stance is **proactive engagement, not prohibition**: … help you **verify** it rather than forbidding the tools." | "Read [Acceptable Use & Etiquette] and [Best Practices & Limitations] before you start." |
| using_ai_agents.md:43-44 (all three) | "**generated from {{ resource }}'s verified facts**" | "generated from facts in this user guide" |

Em-dash chains: most pages use one or two em-dashes per paragraph as asides. The worst are
`index.md:11-12`, `index.md:24`, `best_practices.md:14, 37-38, 74`, `mcp_servers.md:13-15`
and `on_cluster.md:107-113`. Replacing them with full stops is enough. No rhetorical
questions were found.

### C.2 Sentences made false by retiring per-harness settings (outside settings.md)

| File:line | Current text | Proposed replacement |
|---|---|---|
| index.md:29-31 | "The MCP servers, the shared context files, and the per-harness settings documented here are prototypes…" | "The MCP servers and the shared context files are new and will change." |
| index.md:74-81 | card "Shared Context & Settings … The actual context files and per-harness settings each cluster deploys" | card "Shared Context: the context files RCAC places on each cluster, and how to connect your harness to them." The nav title may change; the old URL is handled by R5. |
| acceptable_use.md:67-70 | "Configure your harness so these actions prompt…; the [per-harness settings] we publish deny the most dangerous operations outright as a starting point." | "Configure your harness so these actions ask for approval before they run. Each harness documents its own permission settings." Link to each vendor's permissions page, and/or to the settings stub. |
| best_practices.md:31-33 | "Configure your harness accordingly — the [per-harness settings] we publish deny the most dangerous operations by default…" | "Configure your harness's permission settings to match." |
| best_practices.md:44-48 | "RCAC injects cluster-specific context into agents automatically … already knows the cluster runs Slurm…" | "Connect your agent to the cluster's context files (see [Shared Context]). They tell it the scheduler, module system and partitions, so it does not have to guess." |
| best_practices.md:84-85 | "The per-harness [settings we publish] allow-list these commands so the agent runs them without stopping to ask." | "You can allow these commands in your harness's permission settings so the agent runs them without asking." |
| best_practices.md:124 | "still keep the permission guardrails in place" | "keep your harness's approval settings on" |
| running_agents/on_cluster.md:32-35 | "The shared [context files] RCAC publishes already tell an agent this, and the [per-harness settings] deny the most dangerous operations, but the responsibility is ultimately yours." | "The [context files] tell an agent this once you connect your harness to them. You are responsible for what the agent runs." |
| running_agents/on_cluster.md:101-103 | "…wire in the shared context and permission policy, see [Shared Context & Settings]." | Put the per-harness opt-in (section A) here, or link to it: "To load the cluster's context in every session, see [Connect your harness]." |
| running_agents/local.md:90-93 | "The full [settings and permission files] for each harness — including the shared context and starting-point deny/allow policy — are published in…" | Delete it. |
| running_agents/local.md:117-121 | step 3, "You can give it to Warp's agent by having the agent read those files … or by keeping the assembled `AGENTS.md` in the directory you work from." | Use the Warp Global Rule from A.6. Drop the copy-into-cwd option. |
| running_agents/local.md:122-124 | step 4, "RCAC's recommended profile is on the [settings page]." | "Keep Warp's denylist on. Its default list already requires approval for `rm`, `curl`, `wget` and `eval`." |
| shared_context/index.md:9-15 | "two things up front: **shared context** … and **per-harness settings** that encode a sensible permission policy … how it is constrained" | Describe the context only. |
| shared_context/index.md:31-40 | "two ways": the on-cluster bullet (names a config-management tool, line 34, and says "symlinked to the other well-known context filenames") and the local bullet ("injects") | On the cluster: "RCAC places these files in `/etc/agents.d/` on the cluster's login and compute nodes. Your harness reads them once you connect it (one line per harness, below)." Locally: the B wording. |
| shared_context/index.md:42-43 | "Because this repository is canonical, editing the files here is how the deployed context changes." | "These pages show the files RCAC places on each cluster." Avoid describing the delivery process. |
| shared_context/index.md:48-49 | "or a setting is too strict or too loose" | delete the clause |
| shared_context/index.md:67-74 | settings card, "A starting-point settings file for each of the five harnesses…" | Replace it with a "Connect your harness" card, or point it at the stub with neutral text. |
| shared_context/context_files.md:10-11 | "Every RCAC cluster ships … injected into agents by `rcac-mcp`" | "Each RCAC cluster has a set of context files in `/etc/agents.d/`." |
| shared_context/context_files.md:57-59 | "concatenated into a single `AGENTS.md` and symlinked to each harness's context filename. This is the exact assembled file an on-cluster agent reads" | "The topic files are also combined into `/etc/agents.d/AGENTS.md`. This is the file the per-harness hookups load." |
| using_ai_agents.md:41-50 (all three) | "RCAC deploys … and `rcac-mcp` injects them … [Harness Settings & Permissions] for the per-harness permission policy." "This is the exact assembled context an on-cluster agent reads" | "RCAC places a set of context files in `/etc/agents.d/` on {{ resource }}. To have your harness load them, see [Connect your harness]. This is {{ resource }}'s assembled `AGENTS.md`:" |
| using_ai_agents.md:58-63 (G:60-65, N:59-64) | the `managed-settings.json` paragraph and its `--8<--` include of `claude/settings.json` | Delete both (R4). |

Related R2 note, outside R8: `on_cluster.md:41, 54-55` and `best_practices.md:129` say
`$RCAC_SCRATCH` and `findscratch` without qualification. Once Anvil and others are covered,
these may not hold on every cluster. Check them against research on the new clusters.

### C.3 Configuration-management tool named on a published page

- `docs/agentic-ai/shared_context/index.md:34` is the only occurrence under `docs/` (excluding
  snippets, where there are none). It reads: "Cluster configuration management (<tool name>)
  copies these files out to `/etc/agents.d/`…"
- Replace it with: "RCAC places these files in `/etc/agents.d/` on the cluster's login and
  compute nodes."
