# Research 01 — Site Architecture & Navigation Mechanics

Scope: how to add (a) a new top-level **Agentic AI** nav section and (b) a **Using AI Agents**
chapter inside the Gautschi user guide. All citations are to files under the repo root
`/Users/geoffrey/Software/github.com/purduercac/RCAC-Docs`. Read-only investigation; no site
files were modified.

---

## 1. `mkdocs.yml` nav — top-level sections and exact insertion points

The `nav:` block is `mkdocs.yml:96-364`. The **top-level sections, in order**, are:

1. `HPC User Guides:` — `mkdocs.yml:97`
2. `Storage User Guides:` — `mkdocs.yml:206`
3. `RCAC Resources:` — `mkdocs.yml:245`
4. `Life Sciences:` — `mkdocs.yml:332`
5. `# - Tags: tags.md` (commented out) — `mkdocs.yml:362`
6. `- Contact us: contact.md` — `mkdocs.yml:363`
7. `- FAQs: faqs.md` — `mkdocs.yml:364`

`Life Sciences` is the closest structural precedent for `Agentic AI`: it is a top-level
*domain hub* (its own `index.md` + `Getting Started` / `Guides` / `Tutorials` subsections),
not a cluster or storage guide. See `mkdocs.yml:332-361`:

```yaml
  - Life Sciences:
    - lifesciences/index.md
    - Getting Started:
      - HPC Orientation for Biologists: lifesciences/guides/hpc-orientation.md
      ...
    - Tutorials:
      - Gene Prediction:
        - BRAKER3: lifesciences/tutorials/braker.md
        ...
        - Juicer: lifesciences/tutorials/juicer.md
  # - Tags: tags.md
  - Contact us: contact.md
  - FAQs: faqs.md
```

### RECOMMENDED insertion point for top-level "Agentic AI"

**Insert immediately after the `Life Sciences` section ends (after `mkdocs.yml:361`) and
before the commented `# - Tags` line (`mkdocs.yml:362`).** This groups the two domain hubs
(Life Sciences, Agentic AI) together and keeps the utility items (`Contact us`, `FAQs`) last —
consistent with the current layout. (Alternative acceptable slot: after `Storage User Guides`
ends at `mkdocs.yml:244`, before `RCAC Resources`. The Life-Sciences-adjacent slot is
preferred for domain-hub parallelism.)

The last two lines of the Life Sciences block to anchor against are `mkdocs.yml:360-361`:

```yaml
      - Hi-C Analysis:
        - Juicer: lifesciences/tutorials/juicer.md
```

**PASTE-READY snippet** (new lines to add directly below `mkdocs.yml:361`, at the same
2-space indent as `- Life Sciences:`). A section that owns a direct `index.md` child gets a
breadcrumb parent (see §4), so include one:

```yaml
  - Agentic AI:
    - agentic-ai/index.md
    - Overview: agentic-ai/overview.md
    - Using AI Agents on RCAC: agentic-ai/using-ai-agents.md
    # ...additional pages, each also created under docs/agentic-ai/ + linked from the hub
```

Notes for the drafter:
- The exact content dir/filenames above are a proposal; whatever paths you use must exist
  under `docs/` and each must appear here or the page is orphaned (invariant §4;
  `.agents/factory/style-guide.md:153`).
- `docs_dir` is unset, so it defaults to `docs/` (see §5) — paths are relative to `docs/`.
- `Agentic AI` is **not** in `BREADCRUMB_TITLE_OVERRIDES`
  (`tools/generate_breadcrumbs.py:39-55`), so it renders verbatim as "Agentic AI" in
  breadcrumbs. Add an override there only if you want a longer label.

### Gautschi sub-tree block

The Gautschi cluster block is `mkdocs.yml:135-145` (nested under `HPC User Guides` →
2nd-level, 4-space indent for the `- Gautschi:` key, 6-space for its children):

```yaml
    - Gautschi:
      - userguides/gautschi/index.md
      - Gautschi Overview: userguides/gautschi/overview.md
      - Biography of Gautschi: userguides/gautschi/biography.md
      - Accounts: userguides/gautschi/accounts.md
      - Software: userguides/gautschi/software.md
      - Running Jobs: userguides/gautschi/run_jobs/index.md
      - File Storage and Transfer: userguides/gautschi/storage.md
      - Gateway (Open OnDemand): userguides/gautschi/gateway.md
      - Compiling Source Code: userguides/gautschi/compile.md
      - Frequently Asked Questions: userguides/gautschi/faqs.md
```

### RECOMMENDED insertion point for the Gautschi "Using AI Agents" chapter

**Insert between `Compiling Source Code` (`mkdocs.yml:144`) and `Frequently Asked Questions`
(`mkdocs.yml:145`).** Across every cluster, `Frequently Asked Questions` is the last chapter;
keeping FAQs last preserves that convention. So the new line becomes the second-to-last child.

PASTE-READY — the Gautschi block after the edit (new line marked; single flat page):

```yaml
    - Gautschi:
      - userguides/gautschi/index.md
      - Gautschi Overview: userguides/gautschi/overview.md
      - Biography of Gautschi: userguides/gautschi/biography.md
      - Accounts: userguides/gautschi/accounts.md
      - Software: userguides/gautschi/software.md
      - Running Jobs: userguides/gautschi/run_jobs/index.md
      - File Storage and Transfer: userguides/gautschi/storage.md
      - Gateway (Open OnDemand): userguides/gautschi/gateway.md
      - Compiling Source Code: userguides/gautschi/compile.md
      - Using AI Agents: userguides/gautschi/using_ai_agents.md      # <-- NEW
      - Frequently Asked Questions: userguides/gautschi/faqs.md
```

If the chapter needs sub-pages, use a nested section with its own `index.md` (this also earns
a breadcrumb parent):

```yaml
      - Using AI Agents:
        - userguides/gautschi/using_ai_agents/index.md
        - Getting Started: userguides/gautschi/using_ai_agents/getting-started.md
      - Frequently Asked Questions: userguides/gautschi/faqs.md
```

Also add a matching bullet to the Gautschi hub list in
`docs/userguides/gautschi/index.md` (the hub ends at the "Frequently Asked Questions"
bullet) so the hub page and the nav stay in sync — the hub currently lists each chapter as a
markdown bullet (`docs/userguides/gautschi/index.md`, the `- [**...**](...)` list).

> Caveat — invariant §10 (per-cluster parallelism, `.agents/factory/invariants.md`; AGENTS.md
> "Invariants" §10): the cluster chapter set is deliberately identical across clusters. A
> Gautschi-only "Using AI Agents" chapter intentionally breaks that symmetry. It is what the
> task asks for; just flag it in REVIEW so it is a conscious exception, not an accident.

Naming: use lowercase `snake_case` (`using_ai_agents.md`), per
`.agents/factory/style-guide.md:149`.

---

## 2. Hub / landing archetype (grid cards, front-matter, section headers)

### `docs/lifesciences/index.md` (a clean section-hub example)

Front-matter (`docs/lifesciences/index.md:1-5`):

```yaml
---
title: Life Sciences
tags:
  - Life Sciences
---
```

Then a single `#` H1, a one-paragraph intro, and one `grid cards` block. The card grid
(`docs/lifesciences/index.md:11-45`) is the canonical pattern:

```markdown
<div class="grid cards" markdown>

-   :material-rocket-launch:{ .lg .middle } __Start Here__

    ---

    New to HPC for bioinformatics? Begin with the orientation guide.

    [:octicons-arrow-right-24: HPC Orientation for Biologists](guides/hpc-orientation.md)

-   :material-file-document:{ .lg .middle } __Guides__

    ---

    Step-by-step guides for common bioinformatics tasks: Nextflow, R, SRA downloads, QC, and more.

    [:octicons-arrow-right-24: Running Bioinformatics on RCAC](guides/running-bioinformatics.md)

</div>
```

Anatomy of one card: `-   :material-ICON:{ .lg .middle } __Bold title__` → blank line →
`    ---` (horizontal rule = card header divider) → blank line → description prose → blank
line → an arrow link `[:octicons-arrow-right-24: label](relative/path.md)`. Indentation
inside a card is 4 spaces. Links are **relative** page-to-page (invariant §5).

### `docs/index.md` (the site home page — richer variant)

Front-matter (`docs/index.md:1-9`) uses `hide:` and a wrapping div:

```yaml
---
hide:
  - footer
  - toc
#   - navigation
meta:
  - name: google-site-verification
    content: HQsOhuVVa11DY0qIrxXPW6GUR9jk4EnFfQgUzCgKNbw
---
```

Body is wrapped in `<div class="home-page" markdown>` … `</div>`
(`docs/index.md:11` and `:291`). It uses **section headers with an inline icon**, e.g.
`docs/index.md:43`, `:99`, `:215`, `:253`:

```markdown
## :material-rocket-launch: New to RCAC?
## :material-server-network: HPC User Guides
## :material-bookshelf: RCAC Resources
## :material-lifebuoy: Need Help?
```

Each header is followed by its own `<div class="grid cards" markdown>` block. Cards can carry
a **bold spec line** (`docs/index.md:109`, `:129`) and **multiple arrow links separated by
`&nbsp;`** (`docs/index.md:55`):

```markdown
    **128 cores/node | 256GB-1TB RAM | A100/H100 GPUs**

    [:octicons-arrow-right-24: Purdue account](https://www.rcac.purdue.edu/account/request) &nbsp;&nbsp; [:octicons-arrow-right-24: ACCESS account](userguides/anvil/access/)
```

### `.md-button` / quick-launcher patterns

- `.md-button` is documented in `.agents/factory/style-guide.md:129` (`[text](url){ .md-button }`)
  and `:68` (`[Back to index](index.md){ .md-button }`) — used for back/prev-next nav on
  lessons, not seen on the two hub pages above.
- The Gautschi hub uses a bespoke **quick-launcher** widget instead of grid cards
  (`docs/userguides/gautschi/index.md`): a `<div class="quick-launcher">` containing
  `quick-launcher-card` blocks with `<a … class="launcher-btn">` — styled from
  `docs/stylesheets/extra.css`. This is the cluster-hub convention (index.md + a bullet list
  of chapters), distinct from the domain-hub grid-cards convention.

### Copyable skeleton for a new "Agentic AI" section hub (`docs/agentic-ai/index.md`)

```markdown
---
title: Agentic AI
tags:
  - Agentic AI
---

# Agentic AI

One or two sentences describing agentic AI on RCAC systems and who this section is for.

<div class="grid cards" markdown>

-   :material-robot:{ .lg .middle } __Start Here__

    ---

    New to running AI agents on RCAC? Begin with the overview.

    [:octicons-arrow-right-24: Overview](overview.md)

-   :material-cog:{ .lg .middle } __Using AI Agents__

    ---

    Configure and run agentic AI tools on RCAC clusters.

    [:octicons-arrow-right-24: Using AI Agents on RCAC](using-ai-agents.md)

</div>
```

Add each card's target page under `docs/agentic-ai/` and register it in `nav:` (§1). If you
want the home-page `## :material-...:` section-header style, that is only needed on
`docs/index.md`; a section hub typically leads with its `#` H1 + one grid.

---

## 3. `navigation.indexes` and the hub front-matter contract

`theme.features` (`mkdocs.yml:17-28`) enables, among others:

```yaml
  features:
    - navigation.indexes      # mkdocs.yml:18
    - navigation.sections     # mkdocs.yml:21
    - navigation.top
    - navigation.footer
    - toc.follow
```

`navigation.indexes` is what lets a section's `index.md` become the clickable landing page
for that section header (rather than a separate "Index" child). That is why every section in
`nav:` lists a **bare `index.md` string as its first child** (e.g. `mkdocs.yml:99`
`- userguides/anvil/index.md`; `mkdocs.yml:136` `- userguides/gautschi/index.md`;
`mkdocs.yml:333` `- lifesciences/index.md`). To make `Agentic AI` (or a nested `Using AI
Agents`) behave as a landing hub, its **first child must be the bare `…/index.md` string**.

The style guide confirms the convention: "Every section directory has an `index.md` hub
(`navigation.indexes`)" — `.agents/factory/style-guide.md:151`.

Front-matter contract, cross-checked against `.agents/factory/style-guide.md`:

- **Hub / landing page** (archetype E, `.agents/factory/style-guide.md:70-73`): "Front-matter
  uses `hide: [footer]` (and often `toc`); minimal prose; grid-card or bulleted navigation."
  The site home does exactly this (`docs/index.md:1-9`). A lighter domain hub may instead use
  just `title` + `tags` (`docs/lifesciences/index.md:1-5`) — both are in use; pick per how
  much chrome you want to hide.
- **Normal cluster user-guide page** (archetype A, `.agents/factory/style-guide.md:13-26`):
  `tags:` (cluster name) + `authors:` (RCAC handle) + `search: boost: 2`, plus `resource:`
  only if the body uses `{{ resource }}`. The Gautschi index/overview confirm this exact set
  (`docs/userguides/gautschi/index.md:1-8`, `docs/userguides/gautschi/overview.md:1-8`).

So a **Gautschi "Using AI Agents"** page (living under `docs/userguides/gautschi/`) should
carry the archetype-A front-matter (`tags: [Gautschi]`, `authors:`, `search: boost: 2`),
**not** the hub front-matter — unless it becomes a nested section with its own index.md, in
which case that index.md is the hub.

---

## 4. Breadcrumbs — trigger, output, whether the drafter must regenerate

### Generator header (`tools/generate_breadcrumbs.py:1-13`)

```
Generate breadcrumbs.json from mkdocs.yml nav.
 - Only include parent titles if that parent section contains an actual index.md
 - Do NOT emit an entry for the root "/" (no breadcrumb for Home page)
 - Writes output to docs/assets/data/breadcrumbs.json so MkDocs will serve it
```

Key mechanics for planning:
- **Output path:** `docs/assets/data/breadcrumbs.json`
  (`tools/generate_breadcrumbs.py:62`, `OUTPUT_JSON`). It is a **generated file** (invariant
  §3 — do not hand-edit; regenerate).
- **Parent inclusion rule:** a nav section contributes its title to a child's breadcrumb chain
  **only if that section contains a direct `index.md` string child**
  (`tools/generate_breadcrumbs.py:110-113`). This is the concrete reason the `Agentic AI`
  section (and any nested `Using AI Agents` section) must include a bare `…/index.md` first
  child if you want it to appear as a breadcrumb ancestor.
- **Title overrides:** `BREADCRUMB_TITLE_OVERRIDES` (`tools/generate_breadcrumbs.py:39-55`)
  maps e.g. `Gautschi` → `Gautschi User Guide`. So a Gautschi child page's breadcrumb will
  read `Home / Gautschi User Guide / Using AI Agents`. `Agentic AI` has **no** override, so it
  appears verbatim; add an entry there only if a different breadcrumb label is desired.

### CI trigger (`.github/workflows/update_breadcrumbs.yml`)

```yaml
on:
  push:
    branches: [ main, dev ]        # lines 4-7
    paths:
      - 'mkdocs.yml'               # lines 8-9
```

The workflow runs only when **`mkdocs.yml` changes** on `main` or `dev`. It runs
`python tools/generate_breadcrumbs.py` (`.yml:50`) and **bot-commits** the regenerated
`docs/assets/data/breadcrumbs.json` as `purduercac-docs-bot` (`.yml:43-46, 52-69`).

### Does the drafter need to run it manually?

**Optional but recommended.** CI will regenerate and bot-commit it after the nav change lands
on `main`/`dev`. However:
- For local `mkdocs serve` / `mkdocs build --strict` verification of the new pages'
  breadcrumbs, run it manually: `python tools/generate_breadcrumbs.py` (from repo root — it
  resolves `mkdocs.yml` relative to its own location, `tools/generate_breadcrumbs.py:60-61`).
- If you commit the regenerated JSON in the same PR, expect the bot to produce a no-op (or a
  redundant) follow-up commit; committing it yourself keeps the PR self-consistent. Either
  way it is a generated artifact — never hand-edit it.

---

## 5. `mkdocs.yml` — `docs_dir`, `exclude_docs`, `not_in_nav`, macros/snippets config

- **`docs_dir`:** not set anywhere in `mkdocs.yml` → defaults to `docs/`. All nav paths and
  content live under `docs/`.
- **`exclude_docs`** (`mkdocs.yml:4-5`):

  ```yaml
  exclude_docs: |
    snippets/
  ```

  Only `docs/snippets/` is excluded from the build (they are `--8<--` includes, not pages).
- **`not_in_nav`:** **not present** in `mkdocs.yml`. There is no allow-list of intentionally
  un-navigated pages, so any page under `docs/` that is not in `nav:` (and not excluded) is a
  `--strict` orphan warning. → **Every new Agentic AI / Using AI Agents page must be added to
  `nav:`** (invariant §4).
- **`macros` plugin** (`mkdocs.yml:94`): declared as a bare `- macros` with **no config
  block** (no `module_name`, no `include_dir`). The macros module is `main.py` at repo root
  (the mkdocs-macros default `main`). Extend macros there, don't fork prose (invariant §7).
- **Snippets:** there is **no `snippets` plugin**; snippet includes come from the markdown
  extension `- pymdownx.snippets` (`mkdocs.yml:416`), also declared with **no config block**
  (default base path = project root, so includes are written `--8<-- "docs/snippets/…"`).

**Implication for "published verbatim config files":** if the Agentic AI docs need to show
literal config files verbatim (e.g. an MCP/agent config), the clean options are (a) keep them
as pages under `docs/agentic-ai/…` with fenced code blocks, or (b) store a canonical copy
under `docs/snippets/` and pull it in with `--8<--` (snippets are build-excluded, so they
won't orphan). A file placed under `docs/` that is neither in `nav:` nor under `snippets/`
will trip the `--strict` orphan check. Also mind Jinja escaping: literal `{{`/`{%` in prose
must be wrapped in `{% raw %}` because the `macros` plugin processes every page
(invariant §7; `.agents/factory/style-guide.md:102-108`).

---

## 6. `--strict` baseline (known pre-existing warnings)

Source: `.agents/factory/strict-baseline.txt`. Verify gate command
(`.agents/factory/strict-baseline.txt:13`):

```
.venv/bin/mkdocs build --strict 2>&1 | python3 .agents/factory/bin/strict_check.py
```

Exit 0 = no *new* warnings vs baseline (PASS); exit 1 = a regression your change introduced.
CI itself builds with `--verbose`, **not** `--strict`, so these ship silently today
(`.agents/factory/strict-baseline.txt:5-9`). The **7 known pre-existing warnings**
(`.agents/factory/strict-baseline.txt:25-31`), summarized:

1. `software/ngc_catalog.md` — bad image link `../../assets/images/nvidia_logo.png` (should be
   `../assets/...`). **Generated file — fix at `tools/`, not by hand.**
2. `software/rocm_catalog.md` — bad image link `../../assets/images/rocm_logo.png`.
   **Generated — fix at `tools/`.**
3. `userguides/gilbreth/run_jobs/learning/customml.md` — broken `index.md` link (missing
   `learning/index.md`).
4. `userguides/gilbreth/run_jobs/learning/ml_batch.md` — same missing `learning/index.md`.
5. `userguides/negishi/run_jobs/biocontainers.md` — wrong `../` depth on a biocontainers image.
6. `userguides/negishi/run_jobs/windows/launcher.md` — wrong `../` depth on a windows image.
7. `userguides/scholar/run_jobs/r_example.md` — broken cross-cluster link to a Gautschi
   `example_r_profile_setup.md` (doubled `userguides/`).

None touch `docs/index.md`, `docs/lifesciences/`, `docs/agentic-ai/`, or the Gautschi files
being edited — so the drafter starts from a clean slate for the new work. The bar: introduce
**zero** new `--strict` warnings. The #1 way to add one is getting relative-link `../` depth
wrong (`.agents/factory/style-guide.md:138-140`), so count directory levels carefully on the
new pages and hub links, and add every new page to `nav:` to avoid orphan warnings.
Last baseline capture: 2026-07-14, mkdocs 1.6.1 / mkdocs-material 9.6.16
(`.agents/factory/strict-baseline.txt:23`).
