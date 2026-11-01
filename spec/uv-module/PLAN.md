# PLAN — uv on RCAC clusters, and current Python guidance

> **Status:** Draft for review · **Last updated:** 2026-10-31
> **Authoritative design.** The *how*. Vision/contract is [`GOAL.md`](GOAL.md); the phased
> executable roadmap is [`TECH.md`](TECH.md). Backing detail is in [`research/`](research/).

## 1. Summary

One shared, macro-free snippet carries everything a user needs to know about the `uv` module. Each
of the five clusters gets one new page that includes it, placed beside that cluster's existing
Python pages and linked from its Python hub; Anvil's page adds the 30-day purge note. The catalog
entry comes from seed modulefiles plus a curated description, run through the generator. A blog
post explains the why, an audit pass brings the Python hubs and snippets in line with the Miniforge
`conda` module, and one line in `.authors.yml` fixes Geoffrey Lentner's title.

## 2. Design

### Archetypes

- **Cluster user-guide article** (five new pages): `tags: [<Cluster>]`, `authors: [glentner]`,
  `resource: <Cluster>`, `search: {boost: 2}`.
- **Catalog entry**: generated `docs/software/apps_md/uv.md`; we edit only its sources.
- **Blog post**: `docs/blog/posts/uv_manager.md`, categories `Software` and `Announcements`,
  author `glentner`, `slug: uv-manager`.

### The shared snippet — `docs/snippets/examples/apps/python/uv.md` (new)

Starts at `##`, so every including page supplies the `#` H1. No `{{ }}` anywhere. Outline:

1. `## Loading uv`: `module load uv`; `uv` and `uvx` are the real uv, run through the uv-manager
   wrapper; first use per architecture installs your own uv (needs a few seconds and HTTPS);
   `uv-manager status`. (R2)
2. `## Running scripts and tools`: `uv run --no-project script.py`, inline script dependencies
   (`uv run --with numpy`), `uvx ruff check .`. (R2)
3. `## Projects and virtual environments`: `uv init` / `uv add` / `uv sync`; `uv venv` +
   `uv pip install -r requirements.txt`; where to keep a `.venv` for long-lived work (not scratch).
   (R2)
4. `## Choosing a Python version`: the module sets `UV_PYTHON_PREFERENCE=only-managed`; uv picks the
   newest managed CPython; pin with `--python 3.12`, `uv python pin 3.12` (`.python-version`) or
   `requires-python`; `--python "$(command -v python3)"` after `module load conda` to use conda's
   Python; why the module avoids the OS Python. (R5)
5. `## Where uv keeps its files`: `$UVM_ROOT` (default `$SCRATCH/.uv`), per architecture; nothing
   in home; set `UVM_ROOT` before loading to move it; inode advice and `uv cache prune`. (R2)
6. `## Scratch purges and repair in batch jobs`: what a purge does to uv state; `UVM_REPAIR=1` from
   the module, once per job, every other rank waits; a batch-script example with `srun`; opt out
   with `export UVM_REPAIR=0`; outside a job, `uv-manager doctor` and `uvm clean lock --yes`; the
   hosts repair needs. (R4)
7. `## conda or uv?`: a table with header row — when `conda` (non-Python or compiled stacks from
   conda-forge, `conda-env-mod` modules and Jupyter kernels, existing environments) and when `uv`
   (PyPI packages, `pyproject.toml` projects, one-off tools with `uvx`); both can be loaded at once.
   (R3)
8. `## More information`: the uv docs, the uv-manager README (public GitHub), the catalog entry.

### Per-cluster pages (new), each `# Python packages with uv on <Cluster>` + include

| Cluster | New page | Linked from | `nav:` |
|---|---|---|---|
| Gautschi | `userguides/gautschi/run_jobs/examples/python_uv.md` | `run_jobs/python_example.md` list | no (siblings aren't) |
| Gilbreth | `userguides/gilbreth/run_jobs/examples/python_uv.md` | `run_jobs/python_example.md` list | no |
| Negishi | `userguides/negishi/run_jobs/python/uv.md` | `run_jobs/python.md` list | no |
| Scholar | `userguides/scholar/run_jobs/python_uv.md` | `run_jobs/python_example.md`, a line after the include | no |
| Anvil | `userguides/anvil/python_uv.md` | `anvil-software.md` Python paragraph; `jobs.md` Python example | yes: `Python with uv: userguides/anvil/python_uv.md`, after `Anvil Software` |

Each page: front-matter, H1, one intro sentence, the include, a bold back-link to its hub. Anvil's
page adds, between the intro and the include, a `!!! warning` admonition: Anvil scratch is purged
after 30 days; to keep uv state on project storage, `mkdir -p $PROJECT/$USER` and
`export UVM_ROOT=$PROJECT/$USER/.uv` before `module load uv`; never the shared top of `$PROJECT`.
(R6) Anvil's nav change triggers `tools/generate_breadcrumbs.py`.

### Catalog (R1)

Seeds: the deployed `uv/0.7.0.lua` and `default -> 0.7.0.lua` in `modulefiles/anvil/{cpu,gpu}/Core/uv/`,
`modulefiles/gautschi/{cpu,gpu}/Core/uv/`, `modulefiles/gilbreth/external-20250225/uv/`,
`modulefiles/negishi/cpu/Core/uv/`, `modulefiles/scholar/cpu/Core/uv/`. A curated `uv` entry in
`tools/apps_desc_curated.json`. Then `cd tools && make` with GNU coreutils first on `PATH`; commit
the generated diff only if it is limited to the uv additions (else stop and report). If the topic
heuristic misfiles uv, add an explicit override in `generate_apps_topics.py` (`Programming`, as
`conda`).

### Audit (R8) — see [research/03](research/03-python-guidance-audit.md)

- The five Python hubs and the two `snippets/…/python.md` intros: "Anaconda" wording → Miniforge
  (`conda` module), plus one line pointing to the uv page (the snippets point generically).
- `python=3.8` → `python=3.12` in `snippets/examples/apps/python/conda.md` and the Gilbreth and
  Negishi copies.
- Gilbreth `learning/customml.md` and `learning/ml_batch.md`: `module load anaconda` →
  `module load conda`; example env names `…-py3.8.5` → `…-py3.12`.
- Anvil `anvil-software.md` line 34: name the `conda` (Miniforge) and `uv` modules.

### Blog post (R7) and author title (R10)

`# uv on RCAC clusters: why we built uv-manager`. Intro and excerpt (`<!-- more -->`), then
`## Why a module for uv?` (home quota; login/compute architecture mismatch; one user's state
leaking to another; the purge damage uv doesn't notice; set against the 2025 move from Anaconda to
Miniforge, linking `conda_anaconda.md`), `## What uv-manager is`, `## Using it`
(`module load uv`, `uv`/`uvx` as normal, links to the five cluster pages and the catalog entry),
`## What to keep in mind` (purge and `UVM_REPAIR`, picking a Python, Anvil's `$PROJECT` option,
egress, inodes). `.authors.yml`: `glentner.description` → `Principal AI Scientist`.

### Accessibility

One H1 per page; the snippet starts at H2; the conda/uv table and any blog table have header rows
(`scope` on HTML headers, as the 2025 post); descriptive link text; no images.

### Requirement → design map

| R-ID | Design element(s) |
|------|-------------------|
| R1 | Seeds ×7 dirs + curated description + generated `apps_md/uv.md` (P1) |
| R2 | Snippet §§1–3, 5 via the five cluster pages (P2–P4) |
| R3 | Snippet §7 table (P2) |
| R4 | Snippet §6 (P2) |
| R5 | Snippet §4 (P2) |
| R6 | Anvil page admonition (P4) |
| R7 | `blog/posts/uv_manager.md` (P6) |
| R8 | Audit edits (P5) |
| R9 | Strict gate on every phase; Anvil nav entry; other pages linked from their hubs (P7 checks reachability) — see deviation |
| R10 | `.authors.yml` (P6) |

## 3. Invariant gate (constitution check)

Walked before research and again after this design.

- §1 Branch & deploy — `feature/uv-module` off `main`; PR merges only after the modulefile changes
  are live on all five clusters, since `main` deploys in ~5 minutes.
- §2 Dev-only layer — untouched.
- §3 Generated firewall — `apps_md/uv.md` and catalog pages only via `make`; sources edited instead.
- §4 Nav — Anvil page added to nav; others follow their siblings (see deviation); breadcrumbs
  regenerated after the nav edit.
- §5 Links relative — all page links relative; no assets.
- §6 Front-matter — per archetype above.
- §7 Macros — snippet macro-free; any literal `{{` avoided.
- §8 Build — strict gate in every phase `verify:`; include sentinels grepped in `site/`.
- §9 a11y — headings and tables as above.
- §10 Per-cluster parallelism — one equivalent page per supported cluster, same snippet.
- §11 HPC accuracy — every command checked on each cluster's login node (P7) against
  [research/05](research/05-uv-manager-behaviour.md).
- §12 Commits — `[catalog]`/`[content]`/`[feature]` subjects, no trailer.

### Deviation justifications

| Deviation | Why needed | Simpler alternative rejected because |
|-----------|-----------|--------------------------------------|
| Four new pages are not in `nav:` (R9 as written asks for every new page in nav) | Their sibling Python pages are not in nav; they are reached from the chapter hub (research/01) | Listing only the uv page in nav would make it the one Python sub-page in each cluster's nav, breaking §10 parallelism. **Needs a GOAL amendment with sign-off** (see §5). |

## 4. Rabbit holes (resolved)

- Where Python lives per cluster, and nav → hub-linked sub-pages ([01](research/01-existing-python-pages.md)).
- Catalog without hand edits, with links resolving in the branch → local `make` ([02](research/02-catalog-pipeline.md)).
- Does `conda-env-mod` work under the `conda` module? → yes, checked on Gilbreth ([03](research/03-python-guidance-audit.md)).
- What Python uv picks, and why `only-managed` → measured on the el8 clusters ([05](research/05-uv-manager-behaviour.md)).

## 5. Risks & open questions

- **R9 amendment (needs sign-off):** "Every new page SHALL be reachable from `nav:`, either listed
  in it or linked from its chapter's hub as its sibling pages are."
- **R8 scope (needs sign-off):** the Hammer-only `snippets/examples/apps/learning/{customml,ml_batch}.md`
  load `anaconda`. Either fix them too (unverified that Hammer has the `conda` module) or scope R8 to
  the five clusters' pages and the snippets they include.
- **Compute-node egress on Gilbreth, Negishi and Scholar is unverified.** First use and repair need
  HTTPS. Until a test job confirms it, the snippet tells users to run `uv` once on a login node to
  install it, and names the hosts repair needs.
- **Merge order:** the docs PR merges only after the five modulefile changes are merged and live;
  the seeds would otherwise list a module users can't load.
- **Moving facts:** "newest managed Python is 3.15" and "uv 0.13.6" date quickly; the text names
  the behaviour, not the version numbers.

## 6. Verification strategy

- **Build:** `.venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py` in every phase.
- **Includes:** each cluster page's built HTML must contain `UVM_REPAIR` and `only-managed`
  (silent empty-include guard).
- **Catalog:** generated `apps_md/uv.md` lists five clusters with `0.7.0 (D)`.
- **Audit:** no `module load anaconda` or `python=3.8` left in the in-scope paths.
- **Front-matter:** blog `<!-- more -->`, allowed categories, author `glentner`.
- **Render:** `mkdocs serve` eyeball of one cluster page, the Anvil admonition and the blog post.
- **HPC accuracy:** in P7, run each documented command on each cluster's login node with
  `module load uv` from the deployed module tree; record results in `REVIEW.md` at review.

---

*Backing research: [`research/00-digest.md`](research/00-digest.md).*
