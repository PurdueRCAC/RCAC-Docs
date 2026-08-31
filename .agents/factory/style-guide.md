# RCAC-Docs authoring style guide

The house style and per-archetype conventions for authoring pages. `docs-plan` chooses the
archetype and cites this file; `docs-draft` follows it; `docs-review` checks against it.
This is descriptive of the *current* site — when it disagrees with a gold-standard page
(`docs/userguides/gautschi/`, `docs/blog/posts/`, `docs/templates.md`), the rendered site
wins; fix this file. `docs/templates.md` is the live "kitchen-sink" of every extension.

## Content archetypes

Pick one; each has a distinct front-matter contract and skeleton.

### A. Cluster user-guide article — `docs/userguides/<cluster>/**`

Front-matter:
```yaml
---
tags:
  - Gautschi            # the cluster name
authors:
  - jin456              # RCAC staff handle(s)
resource: Gautschi      # title-case; ONLY if the body uses {{ resource }}
search:
  boost: 2              # user guides rank higher in search
---
```
Skeleton: one `#` H1 tied to the cluster ("Gautschi User Guide", "Running Jobs"), then
`##`/`###` sections mixing prose, spec tables, `bash` blocks, `!!!` admonitions, macro/
snippet includes, and a closing back-link. Many pages are thin wrappers that just set the
`resource` var and `--8<--`/macro-include shared content. Keep the chapter set consistent
across clusters (see invariants §10).

### B. Catalog entry — `docs/software/apps_md/<app>.md`, `docs/datasets/<cat>/<name>.md`

**Usually generated — do not hand-author** (invariants §3). If you must add one manually,
match the fixed skeleton: software app = `# <app>` → back-link → `## Description` →
`## Homepage` → `## Available Versions on RCAC Clusters` (per-cluster table, `(D)` =
default) → `## Module` (`module load` block) → closing `!!! note` about `module spider`.
Dataset entry = `# <Name>` → back-link → a single vertical Field/Value table.

### C. Blog post — `docs/blog/posts/*.md`

Front-matter:
```yaml
---
date:
  created: 2026-04-20
categories:
  - Announcements       # MUST be from the allowed set (below)
title: Introducing the New RCAC Docs
slug: rcac-docs-intro   # controls the URL
authors:
  - jin456              # must exist in docs/blog/.authors.yml
tags: [Documentation, Search]
pin: true               # optional
---
```
Allowed `categories`: **Announcements, Anvil, Gautschi, Software, Slurm, Workflows,
Life Sciences**. Body: intro paragraph, then a `<!-- more -->` marker (required — it
delimits the index excerpt), then the post. Warmer, announcement-style voice is fine here.

### D. Tutorial / workshop lesson — `docs/workshops/**`, `docs/lifesciences/{guides,tutorials}/**`

Organized as a **series** with an `index.md` hub linking ordered lessons. Lesson
front-matter is light (`title`, optional `tags`/`authors`/`search.boost:1`). Pedagogical,
progressive voice ("Let's start by…"); Introduction → Setup → step sections; copious
screenshots with detailed alt text; `[Back to index](index.md){ .md-button }` /
prev-next nav buttons.

### E. Reference / hub / landing — `docs/index.md`, section `index.md`s, `faqs.md`, `contact.md`

Front-matter uses `hide: [footer]` (and often `toc`); minimal prose; grid-card or bulleted
navigation. FAQ pages use `??? question` collapsibles with anchor deep-links.

## Markdown patterns (extensions enabled in `mkdocs.yml`)

**Admonitions** (`admonition` + `pymdownx.details`):
```markdown
!!! important
    Do NOT run heavy jobs on a login node.

!!! note "Custom title"
    ...

??? info "Collapsible (starts closed)"
    ...
```
Types: `note, abstract, tip, info, success, failure, danger, warning, question, quote,
example, important`.

**Content tabs** (`pymdownx.tabbed`) — the standard for OS/method/cluster variants:
```markdown
=== "macOS / Linux"
    ```bash
    ssh you@gautschi.rcac.purdue.edu
    ```
=== "Windows (PuTTY)"
    ...
```
Tabs nest inside admonitions (common for the dataset-request block).

**Snippets & macros** (see invariants §7): `--8<-- "docs/snippets/home_directory.md"` for
static includes (named sections via `--8<-- "docs/snippets/app.md:python"`);
`{% set resource = "gautschi" %}` + `{{ ssh_keys_snippet(resource) }}` for cluster-variable
content. Available macros live in `main.py` (`ssh_keys_snippet`, `ssh_x11_snippet`,
`thinlinc_snippet`, `accounts_md_snippet`, `scp_snippet`, `globus_snippet`,
`scratch_space`, `compile_gpu_snippet`, `htar_snippet`, `hsi_snippet`, … — read `main.py`
for the current list and signatures).

**Publishing a file verbatim (config, rules, `agents.d/*`) — the Jinja-safe pattern.** To show a
real file byte-exact (a `settings.json`, a `config.toml`, a context `*.md`), keep it as an actual
file under `docs/snippets/…` and `--8<--` it **inside a fenced code block** — do *not* paste the body
into the page:

````markdown
```json title="~/.claude/settings.json"
--8<-- "docs/snippets/agentic-ai/claude/settings.json"
```
````

The macros/Jinja pass runs on the page's own source **before** Markdown parsing; `--8<--` splices the
file in **after** — so literal `{{ … }}` / `{% … %}` in the included file is **never** evaluated and
cannot break the build (pasting the same body directly would need `{% raw %}…{% endraw %}` and
duplicates the content). One on-disk file = one source of truth, syntax-highlighted, copyable.
**Footgun:** `pymdownx.snippets` runs with `check_paths: false`, so a **mistyped include path fails
silently** — an empty code block, and `--strict` does *not* warn. Always eyeball the render (or grep
the built `site/` for a known token) after adding one.

**Code blocks** — always tag the language; show interactive prompts with `$`. Extras:
` ```python title="test.py" `, line highlight ` ```py hl_lines="2 3" `, `linenums="1"`,
inline `` `#!python range()` ``. Job scripts conventionally open with `# FILENAME: myjob.sub`.

**Grid cards** (Material) — the landing-page layout:
```markdown
<div class="grid cards" markdown>

-   :material-server:{ .lg .middle } __Gautschi__

    ---

    Purdue's community cluster — **192 cores/node · H100 GPUs**

    [:octicons-arrow-right-24: Gautschi User Guide](userguides/gautschi/index.md)

</div>
```

**attr_list** — buttons `[text](url){ .md-button }`, icon sizing
`:material-account-plus:{ .lg .middle }`, image alignment
`{ align=right width="260" }`, arrow links `[:octicons-arrow-right-24: label](...)`.

**Icons/emoji** — Material (`:material-*:`), FontAwesome (`:fontawesome-brands-github:`),
Simple Icons (`:simple-nvidia:`), octicons for arrows.

## Links & assets

- **Page-to-page links: relative** (`[Overview](overview.md)`, `[Back](../index.md)`) so
  `--strict` validates them. Getting `../` depth wrong is the #1 broken-link bug — count
  directory levels carefully.
- **Static assets: absolute** site-root (`![Cluster](/assets/images/userguides/gautschi/rack.png)`).
  Add a title where useful: `![alt](/assets/…/plot.png "Sine and Cosine")`.
- Images live under `docs/assets/images/` mirroring the content tree
  (`images/blog/`, `images/userguides/<cluster>/`, `images/workshops/<workshop>/`).
- Every content image needs meaningful `alt` text (invariants §9).

## Naming & file layout

- Lowercase `snake_case` filenames (`run_jobs/`, `gpu_jobs.md`, `home_directory.md`).
  Dataset/generated entries may mirror the source's own casing (`COCO.md`, `climateModel.md`).
- Every section directory has an `index.md` hub (`navigation.indexes`).
- Blog URLs come from `slug:`, not the filename.
- `nav:` in `mkdocs.yml` is manual — add every new page (invariants §4).

## Voice & tone

Professional, instructional, second person ("you"); imperative for steps ("Submit the
job:", "Prepare a submission file…"). Safety/policy via `!!! important`/`!!! danger`.
First-time-user friendly where the audience is new (home page, HPC Exchange week 1, life
sciences), deeper for advanced topics (MPI/GPU tuning). Cross-link related pages and end
subpages with a back-link to their hub.
