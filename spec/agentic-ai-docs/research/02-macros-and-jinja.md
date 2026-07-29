# Research 02 — Macros, Jinja, and publishing verbatim config safely

Scope: how the `mkdocs-macros` Jinja pass interacts with published content, the SAFEST way to
publish verbatim harness config / `agents.d` context files (the #1 technical risk), the reusable
macros we should call instead of hardcoding, and the policy-page archetype to mirror.

All claims below are backed by file citations and by an isolated, empirical mkdocs build in
`/tmp/macrotest` reproducing the exact stack (`mkdocs 1.6.1`, `mkdocs-macros-plugin 1.3.9`,
`pymdown-extensions 10.16.1`) — versions from `requirements.txt:16-28`.

---

## 0. TL;DR — the recommended verbatim pattern

**Keep each harness config / context file as a REAL file on disk (exact bytes) under
`docs/snippets/agentic-ai/…`, and embed it in a docs page inside a fenced code block via
`--8<--`.** Proven immune to Jinja regardless of file content, single source of truth, syntax
highlighted, and the surrounding page can still use `{{ macros() }}` freely.

```markdown
```json title="settings.json"
--8<-- "docs/snippets/agentic-ai/claude/settings.json"
```
```

(That outer fence is just for display here; on the page it is a single ```` ```json ```` block
whose only body line is the `--8<--` directive.)

Why it is safe: **the macros/Jinja pass runs on a page's OWN source BEFORE Markdown parsing;
`pymdownx.snippets` splices `--8<--` files in DURING Markdown parsing, AFTER Jinja. Included
content is therefore never Jinja-evaluated** (proven in §3). Do NOT paste config bodies directly
into a page unless you wrap them in `{% raw %}…{% endraw %}` or set `render_macros: false` in the
page front matter.

---

## 1. `main.py` macros to REUSE (signatures + what each EMITS)

`main.py` registers macros via `@env.macro` inside `define_env(env)`. Two flavors: **inline
f-strings** (built from `resource`) and **snippet-file readers** (read a `docs/snippets/*.md`
file and string-substitute `{CLUSTER}`→`resource.title()`, `{cluster}`→`resource.lower()`).

The invocation idiom (used on every cluster page and documented in `docs/templates.md:70-89`):

```markdown
{% set resource = "gautschi" %}      <!-- Jinja var, set once at top of page -->
{{ module_system(resource) }}        <!-- each macro emits a block of markdown -->
```

`{% set resource = "anvil" %}` is real Jinja executed by the macros plugin (see
`docs/userguides/anvil/policies.md:10`). `resource.title()` → `Gautschi`, `resource.lower()` →
`gautschi` (naming convention noted at `main.py:1-4`).

| Macro (signature) | Kind | Emits | Citation |
|---|---|---|---|
| `resource_use(resource)` | snippet reader (special) | The standard **"Acceptable Purdue IT Research Resource Use"** block: queuing-system policy, links to Purdue IT Policy V.4.1 & Remote Access V.1.6, User Credential Standards, and the activity-logging notice. For `anvil` it deletes the credential-standards lines (`lines[4:6]`). | `main.py:742-748`; source text `docs/snippets/resourceuse.md` |
| `module_system(resource)` | inline f-string | Full **Lmod / `module`** walkthrough for `{resource.title()}`: `module spider/avail/load/unload/purge/show`, hierarchical modules, auto default compiler/MPI, `$RCAC_APPNAME_ROOT/_VERSION`. | `main.py:540-632` |
| `slurm_general_overview(resource)` | inline f-string | The **"## Overview / Slurm Basics"** section: what Slurm is, "SSH lands on a login node" note, "don't run jobs on login nodes" warning, the queue concept — for `{resource.title()}`. | `main.py:246-266` |
| `slurm_general_jobs(resource)` | inline f-string | The large Slurm job tutorial: **Job Submission Script** (sample `#SBATCH`), env-var table, **Submitting a Job** (`sbatch`), multi-node, **Interactive jobs** (`sinteractive`), redirecting output, holding jobs — for `{resource.title()}`. | `main.py:268-430` |
| `ssh_keys_snippet(resource)` | inline f-string | **"### SSH Keys general overview"** + Mac/Linux `ssh-keygen`/`ssh-copy-id` steps + Windows/PuTTY key-generation steps, all parameterized to `{resource}.rcac.purdue.edu`. | `main.py:27-129` |
| `storage_quota(resource)` | snippet reader | The **storage-quota** section (`{CLUSTER}`/`{cluster}` substituted). | `main.py:688-692`; `docs/snippets/storage_quota.md` |
| `scratch_space(resource)` | snippet reader | The **scratch-space** section. | `main.py:694-698`; `docs/snippets/scratch_space.md` |
| `scratch_purge(resource)` | snippet reader (special) | The **scratch-purge policy**; per-cluster edits: `anvil`/`bell` → 60→30 days; `anvil` also strips the purge-warning-email + `purgelist` section and rewrites Depot/Fortress → "project space". | `main.py:750-795`; `docs/snippets/scratchpurge.md` |
| `environment_variables(resource)` | snippet reader | The **environment-variables** section (only `{cluster}`→lower substituted). | `main.py:682-686`; `docs/snippets/environment_variables.md` |
| `accounts_md_snippet(resource)` | inline f-string | The full **"# Accounts on {resource.title()}"** page body: obtaining an account, R4P note, and login methods (ThinLinc web / Gateway-OnDemand / SSH). | `main.py:488-532` |

Other macros exist (SSH X11, ThinLinc, scp/sftp/globus/htar/hsi, apptainer/biocontainers/rocm,
compile, recover_*) — same two patterns; read `main.py` before hardcoding anything (per CLAUDE.md).

**Relevance to agentic-AI docs:** for HPC background sections (modules, Slurm, SSH, storage) prefer
these macros over rewriting prose, e.g. `{{ module_system(resource) }}`, `{{ slurm_general_overview(resource) }}`.

---

## 2. `mkdocs.yml` — plugin & extension config that governs the risk

**`macros` plugin** is registered with **NO options** (`mkdocs.yml:94`):

```yaml
plugins:
  - search
  - blog: …
  - tags: …
  - git-revision-date-localized: …
  - rss: …
  - macros            # <-- line 94, bare, so ALL defaults apply
```

Confirmed `mkdocs-macros-plugin 1.3.9` defaults (read from `MacrosPlugin.config_scheme`):

| Option | Default | Consequence |
|---|---|---|
| `module_name` | `'main'` | `main.py` at repo root is auto-loaded (no override needed). |
| `render_by_default` | `True` | **Every page is Jinja-rendered.** Opt out per page with `render_macros: false` in front matter. |
| `on_undefined` | `'keep'` | A **bare** undefined variable `{{ FOO }}` is kept literally, no error. |
| `on_error_fail` | `False` | A Jinja **error** does not fail a plain build — it logs and (in non-strict) deploys a broken page. |
| `j2_variable_start_string` / `j2_block_start_string` | `''` (Jinja defaults `{{` / `{%`) | Triggers are the standard `{{`, `{%`, `{#`. |

**`markdown_extensions`** (`mkdocs.yml:404-425`), relevant parts:

```yaml
markdown_extensions:
  - toc: { permalink: true }
  - tables
  - attr_list
  - md_in_html
  - admonition
  - pymdownx.details
  - pymdownx.blocks.caption
  - pymdownx.emoji: { … }
  - pymdownx.snippets            # <-- line 416, bare, ALL defaults apply
  - pymdownx.highlight:
      anchor_linenums: true
      line_spans: __span
      pygments_lang_class: true
      linenums: true
  - pymdownx.inlinehilite
  - pymdownx.superfences         # <-- line 423, bare
  - pymdownx.tabbed: { alternate_style: true }
```

**`pymdownx.snippets` is bare (`mkdocs.yml:416`)**, so its defaults apply (read from source):

| Option | Default | Consequence |
|---|---|---|
| `base_path` | `['.']` | Include paths resolve from the dir mkdocs runs from = **repo root**. So `--8<-- "docs/snippets/…"` is correct (matches all existing includes). Prod confirms it: `Dockerfile.geddes-prod` does `WORKDIR /docs` → `COPY . .` → `mkdocs build`, i.e. runs from the repo-root copy (`Dockerfile.geddes-prod:4,9,13`). |
| `restrict_base_path` | `True` | Cannot include files **outside** the repo tree → canonical files must live inside the repo. |
| `check_paths` | **`False`** | **Footgun:** a mistyped/missing include path silently yields an **empty** code block — no error, even under `--strict`. Mitigate by eyeballing the render (verify gate) or, optionally, enabling `check_paths: true`. |
| `url_download` | `False` | No remote includes; files must be local. |

`pymdownx.highlight` gives `linenums: true` globally, so every fenced block gets line numbers —
fine for showing config. `pymdownx.superfences` enables the fenced blocks / nesting we rely on.

Note `exclude_docs: | snippets/` (`mkdocs.yml:4-5`) — anything under `docs/snippets/` is **not
built as a standalone page**, so putting canonical files there does NOT create nav orphans
(satisfies invariant #4) while remaining `--8<--`-includable.

---

## 3. The escaping solution — processing order, proven empirically

### Processing order (the key fact)
1. **mkdocs-macros runs Jinja on a page's OWN markdown source** (pre-page phase), with `main.py`
   macros + `mkdocs.yml` `extra:` vars + front-matter `{% set %}` vars in scope.
2. **Then Markdown conversion runs**; `pymdownx.snippets` (`--8<--`) splices file contents in as
   raw text during the Markdown preprocessor phase — **after** Jinja.

⇒ **Content pulled in by `--8<--` is never seen by Jinja.** Literal `{{`/`{%`/`{#` in an included
file passes straight through.

### Empirical proof (isolated `/tmp/macrotest`, exact stack, `mkdocs build --strict`, exit 0)
- **Macros run on page source:** `{{ hello("A") }}` in a page → rendered `MACRO_EMITTED[A]`.
- **`--8<--` includes are NOT Jinja-processed:** an included file containing
  `"echo {{ THIS_WOULD_BREAK }}"` and `{% if x %}…{% endif %}` rendered **verbatim** (found in
  HTML, no error). Had Jinja seen it, the function/undefined-tag would have errored.
- **A raw `.json`/`.toml` file embedded INSIDE a fenced block works:** a real `settings.json`
  containing `{{ this_is_not_jinja }}`, `${{ github.token }}`, and `{% raw %}…{% endraw %}`,
  included via ```` ```json … --8<-- "…/settings.json" … ``` ````, rendered verbatim with syntax
  highlighting, `--strict` exit 0 — **and** a `{{ hello("still-works") }}` macro on the same page
  still evaluated. This is the recommended pattern.
- **`{% raw %}…{% endraw %}` around a fenced block in a page's own source works:** a block with
  `"{{ user }}"` and `"{% for f in files %}{{ f }}{% endfor %}"` rendered verbatim.
- **`render_macros: false` front matter disables Jinja for the whole page:** a page with
  `{{ BOOM }}` and `{% if x %}` in a code block rendered verbatim, `--strict` exit 0.

### The risk, quantified (why this matters)
- A **bare undefined variable** `{{ FOO }}` → kept (because `on_undefined: keep`), `--strict` exit 0.
- **BUT** a function call / attribute / filter / unknown tag — e.g. `{{ nope_fn("z") }}`,
  `{{ a.b }}`, `{% unknowntag %}` — raises `UndefinedError`/`TemplateSyntaxError`. Measured:
  under `mkdocs build --strict` this **aborts (exit 1, "Aborted with 1 warnings in strict mode")**;
  under plain `mkdocs build` (what CI/prod uses, per CLAUDE.md) it logs an ERROR but **exits 0 and
  deploys a garbled page**. Only the factory's `--strict` verify gate catches it.
- Harness config/context files WILL contain such triggers: Warp workflow YAML uses `{{arg}}`
  placeholders; GitHub-Actions / Go-template / Jinja examples use `${{ … }}` and `{{ .Var }}`;
  hooks and context markdown can contain `{%`. JSON single braces (`{ "a": 1 }`) are NOT triggers
  (Jinja needs doubled `{{`/`{%`), and a lone `}}` is harmless — but you cannot safely hand-audit
  every file. Make the mechanism immune instead.

### Existing precedent in the repo
- `docs/templates.md:70-83` documents the intended escape: to *show* macro syntax literally it
  wraps `{% set resource = "gautschi" %}` and `{{ ssh_keys_snippet(resource) }}` in
  `{% raw %} … {% endraw %}`.
- Live proof that snippets bypass Jinja: `docs/snippets/examples/apps/mathematica.md:66` contains
  a **lone `{% endraw %}`** (no opening `{% raw %}`). It is `--8<--`-included with **no** raw
  wrapper by `docs/userguides/hammer/run_jobs/examples/apps/mathematica.md:11` and the bell
  equivalent — and the site builds. A lone `{% endraw %}` would be a fatal `TemplateSyntaxError`
  if snippets were Jinja-processed; it is not, confirming the ordering. (It does render as stray
  literal text on those pages — a pre-existing cosmetic bug, not ours to fix here.)

### Ranking of the three safe options
1. **`--8<--` include of a real file inside a fenced block (RECOMMENDED)** — single source of
   truth (the on-disk file is the exact, copyable, operationally-usable config), zero escaping,
   syntax-highlighted, page keeps macro access. Only caveat: `check_paths:false` means a bad path
   fails silently → verify by rendering.
2. **`{% raw %}…{% endraw %}` around an inline fenced block** — good when the content is short and
   you want it literally in the page file, but it **duplicates** the config (two copies to keep in
   sync) — violates single-source-of-truth; use only for tiny snippets.
3. **`render_macros: false` front matter** — bulletproof but all-or-nothing: the whole page loses
   `{{ macro() }}` access. Use only for a page that is *entirely* verbatim config and needs no macros.

---

## 4. Policy-page archetype (`docs/userguides/anvil/policies.md`) + `resourceuse.md`

**Gautschi has NO `policies.md`** — confirmed: `find docs -name policies.md` returns only
`docs/userguides/anvil/policies.md`. The policy archetype currently exists for Anvil alone, so
there is no per-cluster policy parallelism to maintain (invariant #10 doesn't bind here).

**Structure to mirror** (`docs/userguides/anvil/policies.md`):
```markdown
---
tags:
  - Anvil            # cluster/topic tag(s)
authors:
  - dane             # from docs/blog/.authors.yml
---

# Anvil Policies      <!-- single H1 -->

{% set resource = "anvil" %}     <!-- sets Jinja var so macros can be called -->

## Software Installation Request Policy    <!-- prose section -->
…
## Helpful Tips                             <!-- bulleted etiquette / good-citizen -->
…
## Acceptable Purdue IT Research Resource Use
{{ resource_use(resource) }}               <!-- reused standard AUP block -->

## Scratch File Purging
{{ scratch_purge(resource) }}
```
Notes: this page carries only `tags` + `authors` (no `resource:`/`search.boost:` — lighter than a
cluster user-guide article). It opens with `{% set resource = … %}` then mixes hand-written
sections with macro-emitted standard blocks.

**`docs/snippets/resourceuse.md`** (rendered by `resource_use`) is the reusable acceptable-use
text: 4 short paragraphs — (1) use the queuing system / specify cores accurately; (2) comply with
**Purdue IT Acceptable Use Policy V.4.1** and **Remote Access Policy V.1.6** (linked); (3) refer
to **User Credential Standards**; (4) activity is logged/archived/analyzed (modules, apps, perf
counters, disk, job scripts). Line 1 is an HTML comment noting the `resource_use` macro mutates it
per resource (drops the credential-standards line for Anvil).

**For our agentic-AI acceptable-use page:** mirror this archetype — front matter (`tags` +
`authors`), one H1, hand-written policy/etiquette sections, and reuse `{{ resource_use(resource) }}`
if we want the canonical Purdue AUP block verbatim. Because agentic-AI policy is likely
cross-cluster, either pick a representative `resource` for the AUP block or link Purdue Policy
V.4.1 / V.1.6 directly rather than `{% set %}`-ing a single cluster.

---

## 5. Concrete recommendation (copyable)

### (a) Where canonical files live
Store the exact harness config + `agents.d` context files as **real files** under a new
`docs/snippets/agentic-ai/` tree (excluded from page build by `exclude_docs: snippets/`, still
`--8<--`-includable, resolves in prod). Suggested layout:

```
docs/snippets/agentic-ai/
  claude/settings.json
  codex/config.toml
  gemini/settings.json
  opencode/opencode.json
  warp/warp.yaml
  agents.d/unix.md
  agents.d/filesystems.md
  agents.d/lmod.md
  agents.d/slurm.md
  agents.d/policies.md
```
These files hold the byte-exact config/context (single source of truth). If they must also match
files deployed to `/etc/agents.d`, keep them here and treat this as canonical (or symlink/copy in
tooling) — but the files themselves stay inside the repo tree (`restrict_base_path: true`).

### (b) How to render them (builds clean under `--strict`, single source of truth)
On the published page (which lives under `docs/…` and IS in `nav:` per invariant #4), embed each
file inside a fenced code block. No `{% raw %}` needed — the include is post-Jinja:

````markdown
## Claude Code — `settings.json`

Drop this at `~/.claude/settings.json`:

```json title="~/.claude/settings.json"
--8<-- "docs/snippets/agentic-ai/claude/settings.json"
```

## `/etc/agents.d/slurm.md`

```markdown title="/etc/agents.d/slurm.md"
--8<-- "docs/snippets/agentic-ai/agents.d/slurm.md"
```
````

The surrounding page can still freely use macros in its prose, e.g.
`{% set resource = "gautschi" %}` … `{{ slurm_general_overview(resource) }}`.

Choose the ```` ```<lang> ```` fence to match each file: `json` (Claude/Gemini/opencode), `toml`
(Codex), `yaml` (Warp), `markdown` (agents.d/*). `title="…"` (an `attr_list`/superfences feature,
already enabled) labels the block with the on-disk path.

### Verification (per CLAUDE.md verify gate)
```bash
mkdocs build --strict 2>&1 | python3 .agents/factory/bin/strict_check.py   # no NEW warnings
mkdocs serve   # eyeball: config renders verbatim, no empty blocks (check_paths:false is silent)
```
Confirm every new published page is added to `mkdocs.yml` `nav:` (snippet files are correctly NOT
in nav). Because `check_paths` is off, a typo'd `--8<--` path fails silently — the visual render
check is the safety net.

---

## Appendix — files cited
- `main.py` (macros; lines cited per macro above)
- `mkdocs.yml:4-5` (exclude_docs), `:94` (macros bare), `:404-425` (extensions), `:416/423` (snippets/superfences)
- `docs/templates.md:32-89` (snippet + macro + `{% raw %}` precedent)
- `docs/userguides/anvil/policies.md` (policy archetype)
- `docs/snippets/resourceuse.md` (reusable AUP text)
- `docs/snippets/examples/apps/mathematica.md:66` + `docs/userguides/hammer/run_jobs/examples/apps/mathematica.md:11` (lone `{% endraw %}` in an unwrapped include — live proof snippets bypass Jinja)
- `Dockerfile.geddes-prod:4,9,13` (prod builds from repo root → snippet base_path resolves)
- Empirical harness: `/tmp/macrotest` (mkdocs 1.6.1 / macros 1.3.9 / pymdownx 10.16.1)
