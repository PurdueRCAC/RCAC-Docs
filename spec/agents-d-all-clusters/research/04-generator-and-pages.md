# Research 04 — generator, settings-referencing pages, per-cluster chapters, strict baseline

Scope: R3, R4, R5, R6 (page inventory), R7 (generator), R9 (baseline). Investigated on
branch `feature/agents-d-all-clusters` at `d2ef0189` (= `main` `f013840e` + the GOAL commit).
Line numbers are against that commit.

## 1. Generator (R7)

### 1.1 Reproducibility today

Copied `tools/` and `docs/` to a scratch dir, ran `.venv/bin/python <scratch>/tools/generate_agent_context.py`
(paths resolve from `__file__`, so it wrote only into the scratch copy), then
`diff -r docs/snippets/agentic-ai <scratch>/docs/snippets/agentic-ai` → **identical**.
The same scratch run of `tools/generate_breadcrumbs.py` also reproduces
`docs/assets/data/breadcrumbs.json` byte-for-byte (276 entries).

So R7's "reproduce exactly" holds today; it only has to keep holding after the settings
outputs are removed.

Mechanics relevant to R7:

- The generator `rmtree`s each `docs/snippets/agentic-ai/<cluster>/` it has a YAML for, then
  re-renders it (l.117–120). Dropping the config loop therefore makes a regen produce a tree
  *without* `claude/ codex/ gemini/ opencode/`; the committed tree matches only if those
  dirs are `git rm`'d in the same change.
- `GENERATED.md` is hand-written, not emitted (the generator never touches it). It is not
  under a cluster dir, so the rmtree leaves it alone.
- A cluster dir with no YAML is never pruned (stale dirs would survive). Not an issue for
  this job (clusters only get added).
- CI `.github/workflows/rebuild_agent_context.yml` regenerates on pushes touching
  `tools/agent_context/**` or the script and `git add docs/snippets/agentic-ai` (stages
  deletions too). Installs only `jinja2 pyyaml`. No change needed if the parameterization
  below stays pure Python.

### 1.2 What must change to emit only agents.d

| File:line | Today | Change |
|---|---|---|
| `tools/generate_agent_context.py:2` | "Generate the per-cluster agentic-AI context and settings files" | drop "and settings files" |
| `…:6–8` | "…the same files RCAC ships to `/etc/agents.d` and the per-harness settings paths" | drop the settings-paths clause |
| `…:35–41` | `CONFIG_TEMPLATES` list (claude/codex/gemini/opencode) | delete |
| `…:53–54` | `_toml_marker()` (only used for codex TOML) | delete |
| `…:137–145` | loop rendering `CONFIG_TEMPLATES` + JSON-marker comment | delete |
| `tools/agent_context/templates/{claude,codex,gemini,opencode}/` | 4 templates | delete (git rm) |
| `docs/snippets/agentic-ai/{gautschi,gilbreth,negishi}/{claude,codex,gemini,opencode}/` | 12 generated files | delete (git rm) |
| `docs/snippets/agentic-ai/GENERATED.md:9–10` | lists "the `claude/`, `codex/`, `gemini/`, `opencode/` settings" | drop |
| `…GENERATED.md:18–20` | TOML marker + "this file is the marker for the `*.json` settings" | reduce to "Markdown files carry an inline `<!-- … -->` marker" |
| `…GENERATED.md:22–25` | "To add a cluster" steps | add: list the chapter in the cluster's `index.md`, regenerate breadcrumbs |

Nothing else in `tools/` or `main.py` references the settings outputs. The only `--8<--`
consumers of the settings files are listed in §2 (settings.md ×4, the three chapters ×1 each).

R7 verify gate (cheap, deterministic): run the generator in place, then
`git status --porcelain docs/snippets/agentic-ai` must be empty.

### 1.3 Template schema (YAML keys read)

All templates render with `StrictUndefined`, so every key accessed on the taken branch must
exist (a `{% if x %}` on an undefined `x` raises too).

| Template | Keys read |
|---|---|
| `agents.d/unix.md.j2` | `title`, `os`, `login_host` |
| `agents.d/filesystems.md.j2` | `title`, `scratch_path`, `filesystems.home.tech`, `filesystems.home.snapshots`, `filesystems.scratch.tech` (nullable), `filesystems.scratch.purge_days`, `filesystems.depot`, `filesystems.fortress` |
| `agents.d/lmod.md.j2` | `title`, `toolchain` (nullable; must be present), `toolchain.compiler`, `toolchain.mpi` |
| `agents.d/slurm.md.j2` | `title`, `partitions[].{name,use,notes}`, `qos` (list of strings; only `normal`/`standby`/`preemptible`/`training` render — any other name is silently dropped), `scheduler.standby_max_hours` (only when `standby` in `qos`), `anti_patterns` (list; must be present) |
| `agents.d/policies.md.j2` | `title`, `filesystems.depot` |
| generator | `cluster`, `title` |

`cluster` is also the output dir name. `partitions[].notes` lands in a Markdown table cell,
so it must not contain `|`.

### 1.4 Hard-coded conventions the templates assume (R2 hazards)

| Template:line | Hard-coded | Note |
|---|---|---|
| `unix.md.j2:30` | `myquota` | |
| `unix.md.j2:31` | `slist` | Anvil's guide documents `mybalance`, not `slist` |
| `unix.md.j2:32` | `sfeatures` | |
| `filesystems.md.j2:15` | heading `(` `$RCAC_SCRATCH` `)` | Anvil's guide uses `$SCRATCH` / `$PROJECT`, no `$RCAC_SCRATCH` |
| `filesystems.md.j2:18–19` | `$RCAC_SCRATCH`, `findscratch` | Anvil: no `findscratch` |
| `filesystems.md.j2:20–22` | `purge_days`, `purgelist` | see note below |
| `filesystems.md.j2:24–28, 35–47` | Depot/Fortress, `hsi`/`htar` | already gated by `filesystems.depot`/`fortress`; the no-longterm fallback text ("durable project or archive storage") is generic |
| `filesystems.md.j2:51–55` | `myquota`, `$RCAC_SCRATCH` | |
| `lmod.md.j2:24` | `module load rcac` ("where provided") | hedged already |
| `lmod.md.j2:35` | `anaconda` modules | |
| `slurm.md.j2:8–11` | "four things … account, QOS, partition … MUST set both `-A` and `-p`; also set the QOS" | needs a knob for clusters where QOS is not part of the normal request |
| `slurm.md.j2:13–14` | `slist` | |
| `slurm.md.j2:27–41` | only four known QOS names render | a new cluster's QOS (if any) would vanish silently |
| `slurm.md.j2:46` | `sinteractive` | |
| `slurm.md.j2:54–55` | unconditional "Do NOT write `-A standby` …" | mentions a QOS a cluster may not have; wrap in `{% if 'standby' in qos %}` (no change for the existing three — all have `standby`) |
| `policies.md.j2:8` | "Purdue IT's Acceptable Use Policy and RCAC's resource policies" | Anvil is an ACCESS resource; its policy text differs |
| `policies.md.j2:27` | `slist` | |
| `policies.md.j2:37–38` | Apptainer; auto-mounts `/home`, `/depot`, `/scratch` (or `/home`, `/scratch`) | mount set must be cluster-confirmed |
| `policies.md.j2:45` | `rcac-help@purdue.edu` | Anvil support goes through ACCESS, not this address — confirm from the Anvil guide |

**`purgelist` is not confirmed by any cluster user guide, including the existing three.**
The text lives only in `docs/snippets/scratchpurge.md`, reached via the `scratch_purge()`
macro (`main.py:750ff`), which is used only by `userguides/anvil/policies.md` (and a
workshop page) — and for Anvil the macro *strips* the `purgelist` paragraph. In the built
site no page under `userguides/{anvil,bell,scholar,gautschi,gilbreth,negishi}/` other than
the agents chapters contains `purgelist`. Under R1 ("a value the guide does not confirm
SHALL be left out") the plan must decide whether `purgelist` stays for
Gautschi/Gilbreth/Negishi (an intended diff) or is justified from another source. The
same macro sets the purge window to 30 days for Bell and Anvil (60 elsewhere).

Indicative built-site grep of the new guides (counts of pages; site chrome inflates
Depot/Fortress/rcac-help, so those numbers are ignored): Anvil — `mybalance` 3, `$SCRATCH`
3, `$PROJECT` 4, `sfeatures` 1, `myquota` 3, `sinteractive` 2, `slist`/`findscratch`/
`RCAC_SCRATCH`/`hsi`/`htar` 0. Bell — `slist` 5, `findscratch` 1, `RCAC_SCRATCH` 5,
`sfeatures` 1, `hsi` 5. Scholar — `slist` 3, `findscratch` 1, `RCAC_SCRATCH` 4,
`sfeatures` 1, `hsi` 4. Facts research must confirm each; Bell and Scholar guides are
mostly macro-rendered, so grep `site/`, not `docs/`.

### 1.5 Proposed parameterization (minimal, backward-compatible)

Add a `DEFAULTS` dict in the generator and deep-merge each cluster YAML onto it before
rendering. Defaults equal today's literals, so the three existing YAMLs need no edits and
their output stays byte-identical. A YAML `null` turns an item off.

```yaml
# defaults (in generator); a cluster YAML overrides any leaf, null disables it
commands:
  quota: myquota          # unix:30, filesystems:51
  accounts: slist         # unix:31, slurm:13, policies:27   (Anvil: mybalance, if confirmed)
  features: sfeatures     # unix:32
  findscratch: findscratch  # filesystems:19
  purgelist: purgelist    # filesystems:21–22 (see purgelist note)
  interactive: sinteractive # slurm:46
env:
  scratch: RCAC_SCRATCH   # filesystems:15,19,54  (null → cite scratch_path only)
scheduler:
  require_qos: true       # slurm:8–11 wording; false → "account and partition" only
support:
  email: rcac-help@purdue.edu
  aup: "Purdue IT's Acceptable Use Policy and RCAC's resource policies"
containers:
  automounts: null        # null → today's depot-derived list; else explicit list
```

Template-edit rules that keep byte identity:

- `trim_blocks` + `lstrip_blocks` are on, so a `{% if commands.features %}` /
  `{% endif %}` pair on their own lines emits nothing; wrap whole bullet lines, never
  split a line.
- Inline substitutions (`` `{{ commands.accounts }}` ``) render the same literal.
- `filesystems.scratch.purge_days: null` → emit "may be purged; check the user guide" (the
  "verify live" convention `GENERATED.md` already promises for nulls).
- QOS: allow a `qos` item to be a mapping `{name, text}` in addition to the four known
  strings, rendered generically; keeps existing string entries unchanged.
- Optional `filesystems.project: {path, env}` for clusters with project space instead of
  Depot (Anvil), rendered only when present.
- Keep `scheduler.standby_max_hours` accessed only inside the `standby` branch, so a
  cluster without `standby` can omit it.
- Deep-merge (not `dict.update`) — `scheduler` already exists in the three YAMLs.

Gate for the existing clusters: after the template edits and before adding new YAMLs,
regenerate and require `git diff --exit-code docs/snippets/agentic-ai/{gautschi,gilbreth,negishi}/agents.d`
(apart from any intended change, such as `purgelist`, recorded in PLAN).

## 2. Pages that reference the settings (R4/R5/R6)

Inbound links to `shared_context/settings.md`: 10 (listed below). `--8<--` includes of
settings files: settings.md l.71/100/113/124 and the three chapters (l.62/64/63). No other
page, blog post, or `main.py` macro includes them. `mkdocs.yml` has no redirect plugin, so
R5's stub must stay at `docs/agentic-ai/shared_context/settings.md`.

| File:line | What it says | Change for R4/R5/R6 |
|---|---|---|
| `mkdocs.yml:413` | nav group "Shared Context & Settings" | rename (e.g. "Shared Context"); URL unchanged |
| `mkdocs.yml:416` | "Harness Settings & Permissions: …settings.md" | keep as stub (relabel) or drop from nav; dropping only adds an INFO "not in nav" line, not a strict WARNING (confirmed: the not-in-nav list prints at INFO) |
| `docs/agentic-ai/index.md:29–32` | "the per-harness settings documented here are prototypes" | drop settings |
| `…index.md:74–81` | card "Shared Context & Settings … per-harness settings each cluster deploys … canonical source of truth" | R4 rewrite; rename |
| `…index.md:85–89` | links three chapters as examples | optionally list all six |
| `…shared_context/index.md:2,9` | title "Shared Context & Settings" | rename |
| `…shared_context/index.md:11–15` | "two things up front: shared context … and per-harness settings that encode a … permission policy" | R4: context only |
| `…shared_context/index.md:22–24` | "absorbs the cluster's rules before you ask your first question" | R8 example slogan (out of my scope, flagged) |
| `…shared_context/index.md:31–40` | on cluster: names internal deployment tooling, says files are "concatenated into a single `AGENTS.md` and symlinked to … `CLAUDE.md`, `GEMINI.md`"; locally: `rcac-mcp` injects | R6: replace with "RCAC places `/etc/agents.d/` on login and compute nodes; the agent loads it after you opt in" + per-harness opt-in; remove the tooling name (public-repo rule) and the symlink claim; verify the `rcac-mcp` claim against current server behavior |
| `…shared_context/index.md:47–49` | "a setting is too strict or too loose" | drop settings |
| `…shared_context/index.md:67–74` | settings card | point to stub or remove |
| `…shared_context/context_files.md:10–12` | "deployed to the cluster and injected into agents by `rcac-mcp`" | R6 wording |
| `…context_files.md:57–59` | "concatenated … and symlinked to each harness's context filename … exact assembled file an on-cluster agent reads" | R6: remove symlink claim; say the agent reads it once the user opts in |
| `…context_files.md:69` | "Back to [Shared Context & Settings]" | relabel |
| `…shared_context/settings.md` (whole, 150 lines) | deployed + enforced policies, `/etc/claude-code/managed-settings.json`, `/etc/gemini-cli/settings.json`, `/etc/opencode/`, four `--8<--` includes, Warp profile | R5: replace with a short stub — policy changed after review and testing; RCAC ships context only; link to each harness's own permission docs and to `best_practices.md` |
| `settings.md:74–83` | `.mcp.json` docs-server block (`"type": "http"`) | **move** — see below |
| `…running_agents/on_cluster.md:33–35` | "the per-harness settings deny the most dangerous operations" | R4: user configures own harness |
| `…on_cluster.md:101–103` | "wire in the shared context and permission policy, see Shared Context & Settings" | R6: point at the opt-in instructions |
| `…running_agents/local.md:38–40` | `rcac-mcp` "reads the host's `/etc/agents.d/` files over SSH and injects them" | R6: verify against current `rcac-mcp` |
| `…local.md:90–93` | "full settings and permission files for each harness … starting-point deny/allow policy are published" | R4: remove |
| `…local.md:117–124` | Warp: wire in context; "RCAC's recommended profile is on the settings page" | R4: drop profile reference; keep the context step |
| `…acceptable_use.md:67–70` | "the per-harness settings we publish deny the most dangerous operations outright" | R4 |
| `…best_practices.md:31–33` | same | R4 |
| `…best_practices.md:84–85` | "settings we publish allow-list these commands" | R4 |
| `…best_practices.md:129–130` | "deny `rm -rf`/`sudo` outright" | user-side advice, OK as-is |
| `…mcp_servers.md:89–99` | `rcac-mcp` injects `/etc/agents.d/` as `rcac://context` | R6: confirm current behavior |
| `docs/userguides/{gautschi,gilbreth,negishi}/using_ai_agents.md:41–48(±2)` | "RCAC deploys … and `rcac-mcp` injects them … [Harness Settings & Permissions] for the per-harness permission policy" | R4/R6 |
| `…using_ai_agents.md:58–63(±2)` | "The cluster-side permission policy for Claude Code …" + `/etc/claude-code/managed-settings.json` include | delete (R4) |
| `…using_ai_agents.md:19–21` | "proactive engagement, not prohibition" | R8 example slogan (flagged) |
| `docs/assets/data/breadcrumbs.json:1431` | entry for `/agentic-ai/shared_context/settings/` | generated; regenerate after nav change, never hand-edit |

**Docs-server snippet.** `mcp_servers.md:160–164` covers the hosted endpoint only
generically ("point any HTTP-capable MCP client at that URL") and gives a local `uvx`
block (l.166–177). It has no per-harness registration of `https://docs.rcac.purdue.edu/mcp`.
The four settings templates being deleted are the only place those forms exist:
Claude Code `.mcp.json` `{"type": "http", "url": …}` (settings.md:77–83), Codex
`[mcp_servers.rcac_docs] url = …`, Gemini `"httpUrl": …`, opencode
`{"type": "remote", "url": …, "enabled": true}`. Recommend moving them into
`mcp_servers.md` § `rcac-docs-mcp` as a four-tab block, mirroring the tabbed `rcac-mcp`
registration on `local.md:48–88`. Harness-side syntax should be re-verified by whoever
researches the opt-in instructions.

## 3. Per-cluster chapters (R3)

**Own snippet:** yes. Each chapter embeds its own `agents.d/AGENTS.md`
(gautschi l.55, gilbreth l.57, negishi l.56) and its own `claude/settings.json` (to be
removed). Verified in the build: `site/userguides/gilbreth/using_ai_agents/index.html`
contains the `gilbreth.yml` marker and `a100-80gb`.

**Shape:** the three files are the same template; diffs are front matter (`tags`,
`resource`), one cluster-specific clause at l.44–47, the two include paths, and the back
link. Front matter: `tags: [<Cluster>]`, `authors: [glentner]`, `resource: <Cluster>`,
`search: {boost: 2}`. The body uses `{{ resource }}` and
`{{ resource | lower }}.rcac.purdue.edu` (gives `anvil`/`bell`/`scholar.rcac.purdue.edu`;
the Anvil guide confirms `anvil.rcac.purdue.edu`, with `x-` prefixed usernames).

**Front-matter conventions in the new guides:** Bell and Scholar pages carry
`resource: <Cluster>` (Scholar also `host: scholar.rcac.purdue.edu`). Anvil pages mostly
do not; they use `cluster: Anvil`/`host:`/`hostname:` or an in-body
`{% set resource = "anvil" %}` (`policies.md:10`, `jobs.md:10`). A new Anvil chapter with
`resource: Anvil` is allowed by the style guide, since the body uses `{{ resource }}`.

**Nav placement (chapter just before FAQs, as in the existing three).** Indentation is 6
spaces for chapter entries.

```yaml
# Anvil — insert after mkdocs.yml:109, before :110
      - Anvil Software: userguides/anvil/anvil-software.md
      - Using AI Agents: userguides/anvil/using_ai_agents.md      # new
      - Frequently Asked Questions: userguides/anvil/faqs.md
# Bell — insert after :143, before :144
      - Compiling Source Code: userguides/bell/compile.md
      - Using AI Agents: userguides/bell/using_ai_agents.md       # new
      - Frequently Asked Questions: userguides/bell/faqs.md
# Scholar — insert after :190, before :191
      - Compiling Source Code: userguides/scholar/compile.md
      - Using AI Agents: userguides/scholar/using_ai_agents.md    # new
      - Frequently Asked Questions: userguides/scholar/faqs.md
```

Anvil's guide does not follow the shared chapter set (About group, Job Submission, File
Management, Other Services, Key Policies), so "before FAQs" is the closest parallel. An
alternative is Anvil's "Other Services" block (beside AnvilGPT); I recommend the
before-FAQs slot for consistency with the other five.

**Cluster `index.md` chapter lists also need the entry** (the existing three have it at
l.33/33/34):

- `docs/userguides/anvil/index.md` — under `## User Guide`, between l.30 `Anvil Software`
  and l.31 `Frequently Asked Questions`.
- `docs/userguides/bell/index.md` — between l.33 `Compiling Source Code` and l.34 FAQs.
- `docs/userguides/scholar/index.md` — between l.33 `Compiling Source Code` and l.34 FAQs.

Line: `- [**Using AI Agents**](using_ai_agents.md)`.

**Breadcrumbs:** after the nav edit run `.venv/bin/python tools/generate_breadcrumbs.py`;
expect three new entries such as `/userguides/anvil/using_ai_agents/` →
`["Home", "Anvil User Guide", "Using AI Agents"]` (the `Anvil`/`Bell`/`Scholar` title
overrides already exist in `generate_breadcrumbs.py:39–54`), plus relabelled
Shared Context/settings entries if those nav labels change.

## 4. Strict baseline (R9)

`.venv/bin/mkdocs build --strict` at `d2ef0189`: **exit 0, 0 WARNING lines, 0 ERROR lines,
no traceback**, built in 8.67 s. `strict_check.py` on the captured log:
`PASS: no new --strict warnings (0 present, all in baseline of 0).`
`.agents/factory/strict-baseline.txt` is empty (comments only), so any new WARNING fails the
gate. The checker takes `--baseline PATH` and a log path or stdin; it fails on any
`ERROR`/traceback regardless of baseline.

There are 470 INFO lines (missing anchors, the not-in-nav page list); INFO is not gated.

Silent-failure guard (invariants §8): a mistyped `--8<--` path renders empty with no
warning. After the change, grep the built pages for a per-cluster token, e.g. `anvil.yml`
in `site/userguides/anvil/using_ai_agents/index.html` (and likewise for bell and scholar),
and confirm no `managed-settings` string remains anywhere under `site/`.

## Open items for PLAN

1. `purgelist` is unconfirmed by every cluster guide (§1.4). Keep it for the three
   existing clusters, or drop it there as an intended diff.
2. Stub nav: keep `settings.md` in nav (relabelled) or drop it to INFO-only orphan. Either
   way the URL resolves.
3. R6: the `rcac-mcp` "injects `/etc/agents.d/` as `rcac://context`" statement appears on
   five pages; it has to be checked against the current server (not in this repo).
