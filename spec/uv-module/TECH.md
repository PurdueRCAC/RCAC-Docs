---
slug: uv-module
title: uv on RCAC clusters, and current Python guidance
kind: feature
appetite: big
status: in_progress
branch: feature/uv-module
base: main
current_phase: P5
last_updated: '2026-11-01'
phases:
- id: P1
  name: 'Catalog entry: uv seeds, curated description, generated page'
  status: done
  satisfies:
  - R1
  depends_on: []
  parallel: false
  hammerable: false
  hill: uphill
  verify: .venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py
    && test $(grep -c '0.7.0 (D)' docs/software/apps_md/uv.md) -eq 5
- id: P2
  name: Shared uv snippet + the Gautschi page (gold standard)
  status: done
  satisfies:
  - R2
  - R3
  - R4
  - R5
  depends_on:
  - P1
  parallel: false
  hammerable: false
  hill: uphill
  verify: .venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py
    && grep -q 'python_uv.md' docs/userguides/gautschi/run_jobs/python_example.md
    && grep -rq 'UVM_REPAIR' site/userguides/gautschi/run_jobs/examples/python_uv/
    && grep -rq 'only-managed' site/userguides/gautschi/run_jobs/examples/python_uv/
- id: P3
  name: Gilbreth, Negishi and Scholar pages, linked from their hubs
  status: done
  satisfies:
  - R2
  - R3
  - R4
  - R5
  depends_on:
  - P2
  parallel: false
  hammerable: false
  hill: uphill
  verify: .venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py
    && grep -rq 'UVM_REPAIR' site/userguides/gilbreth/run_jobs/examples/python_uv/
    && grep -rq 'UVM_REPAIR' site/userguides/negishi/run_jobs/python/uv/ && grep -rq
    'UVM_REPAIR' site/userguides/scholar/run_jobs/python_uv/
- id: P4
  name: Anvil page with the 30-day purge note, in nav
  status: done
  satisfies:
  - R2
  - R3
  - R4
  - R5
  - R6
  - R9
  depends_on:
  - P2
  parallel: false
  hammerable: false
  hill: uphill
  verify: .venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py
    && grep -q 'userguides/anvil/python_uv.md' mkdocs.yml && grep -rq 'UVM_REPAIR'
    site/userguides/anvil/python_uv/ && grep -rq 'purged after 30 days' site/userguides/anvil/python_uv/
- id: P5
  name: 'Python guidance audit: Miniforge wording, no anaconda, no Python 3.8'
  status: pending
  satisfies:
  - R8
  depends_on:
  - P2
  parallel: false
  hammerable: false
  hill: uphill
  verify: .venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py
    && ! grep -rq 'module load anaconda' docs/userguides/anvil docs/userguides/gautschi
    docs/userguides/gilbreth docs/userguides/negishi docs/userguides/scholar docs/snippets/apps
    docs/snippets/examples/apps/python docs/snippets/examples/apps/python.md && !
    grep -rq 'python=3.8' docs/userguides/anvil docs/userguides/gautschi docs/userguides/gilbreth
    docs/userguides/negishi docs/userguides/scholar docs/snippets/apps docs/snippets/examples/apps/python
    docs/snippets/examples/apps/python.md
- id: P6
  name: Blog post and the author title
  status: pending
  satisfies:
  - R7
  - R10
  depends_on:
  - P1
  - P3
  - P4
  parallel: false
  hammerable: false
  hill: uphill
  verify: .venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py
    && grep -q 'Principal AI Scientist' docs/blog/.authors.yml && grep -q '<!-- more
    -->' docs/blog/posts/uv_manager.md && grep -q 'apps_md/uv.md' docs/blog/posts/uv_manager.md
    && grep -q 'conda_anaconda.md' docs/blog/posts/uv_manager.md
- id: P7
  name: 'Integration: cross-links, breadcrumbs, reachability, HPC accuracy pass'
  status: pending
  satisfies:
  - R1
  - R2
  - R3
  - R4
  - R5
  - R6
  - R7
  - R8
  - R9
  - R10
  depends_on:
  - P1
  - P2
  - P3
  - P4
  - P5
  - P6
  parallel: false
  hammerable: false
  hill: uphill
  verify: .venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py
    && grep -q 'python_uv.md' docs/userguides/anvil/anvil-software.md && grep -q 'python_uv.md'
    docs/userguides/gilbreth/run_jobs/python_example.md && grep -q 'uv.md' docs/userguides/negishi/run_jobs/python.md
    && grep -q 'python_uv.md' docs/userguides/scholar/run_jobs/python_example.md
review:
  last_reviewed_commit: ''
  verdict: none
  blocked_reason: ''
---
# TECH.md — uv on RCAC clusters, and current Python guidance

The finite-state machine for this job. The frontmatter is the resume ground truth
(`.venv/bin/python .agents/factory/bin/next_phase.py spec/uv-module/TECH.md`); the checklists below
are the work. Design: [`PLAN.md`](PLAN.md). Facts: [`research/05`](research/05-uv-manager-behaviour.md).

## Conventions (every phase)

- Constitution: [`../../AGENTS.md`](../../AGENTS.md), [`style-guide.md`](../../.agents/factory/style-guide.md),
  [`invariants.md`](../../.agents/factory/invariants.md).
- One phase per `docs-draft` run; one commit with content and state; subjects
  `[content] Draft uv-module P<n>: …` (`[catalog]` for P1). No `Co-Authored-By`.
- The shared snippet carries no `{{ }}` and no cluster names; cluster-specific text lives on the page.
- Every factual claim traces to research/05; anything not there is `[NEEDS CLARIFICATION]`, never guessed.
- Never hand-edit generated files.

---

## Phase P1 — Catalog entry
**Satisfies:** R1 · **Depends on:** —

- [x] Copy the deployed `uv/0.7.0.lua` for each cluster, plus `default -> 0.7.0.lua`, into
  `modulefiles/anvil/cpu/Core/uv/`, `modulefiles/anvil/gpu/Core/uv/`, `modulefiles/gautschi/cpu/Core/uv/`,
  `modulefiles/gautschi/gpu/Core/uv/`, `modulefiles/gilbreth/external-20250225/uv/`,
  `modulefiles/negishi/cpu/Core/uv/`, `modulefiles/scholar/cpu/Core/uv/`.
- [x] Add a curated `uv` entry to `tools/apps_desc_curated.json` (description of the RCAC module:
  uv through the uv-manager wrapper, state on scratch, per architecture; homepage
  `https://docs.astral.sh/uv/`; `"source": "curated"`).
- [x] `cd tools && make` (run on a Linux login node; see research/02). Commit only the files CI
  commits (`apps_md/uv.md`, `app_catalog.md`, `index.md`, `apps_descriptions.json`); their diff must
  be limited to the uv additions and the date/count line. Anything else: stop and report.
- [x] If the topic heuristic did not give `Programming`, add an explicit override in
  `tools/generate_apps_topics.py` and re-run `make`.
- **Touches:** `modulefiles/*/…/uv/`, `tools/apps_desc_curated.json`, generated catalog files.

## Phase P2 — Shared snippet + Gautschi page
**Satisfies:** R2, R3, R4, R5 · **Depends on:** P1

- [x] Write `docs/snippets/examples/apps/python/uv.md` per PLAN §2 (eight `##` sections). The batch
  example uses a generic `#SBATCH` header (`-A <account>`, `-p <partition>`), `module load uv`,
  `srun uv run --no-project analyse.py`, with `UVM_REPAIR` explained in prose.
- [x] Create `docs/userguides/gautschi/run_jobs/examples/python_uv.md`: front-matter (`tags:
  [Gautschi]`, `authors: [glentner]`, `resource: Gautschi`, `search: {boost: 2}`), H1, intro, include,
  back-link to `../python_example.md`.
- [x] Add `- [**Python Packages with uv**](examples/python_uv.md)` to `run_jobs/python_example.md`.
- [x] `mkdocs serve`; eyeball headings, the table, the code blocks.
- **Touches:** `docs/snippets/examples/apps/python/uv.md`, two Gautschi pages.

## Phase P3 — Gilbreth, Negishi, Scholar pages
**Satisfies:** R2, R3, R4, R5 · **Depends on:** P2

- [x] `docs/userguides/gilbreth/run_jobs/examples/python_uv.md` + link in its `python_example.md`.
- [x] `docs/userguides/negishi/run_jobs/python/uv.md` + link in `run_jobs/python.md`.
- [x] `docs/userguides/scholar/run_jobs/python_uv.md` + a link line after the include in
  `run_jobs/python_example.md`.
- **Touches:** three new pages, three hubs.

## Phase P4 — Anvil page
**Satisfies:** R2–R6, R9 · **Depends on:** P2

- [x] `docs/userguides/anvil/python_uv.md` with the `!!! warning` 30-day purge admonition
  (`mkdir -p $PROJECT/$USER`, `export UVM_ROOT=$PROJECT/$USER/.uv`, before `module load uv`; not
  the shared top of `$PROJECT`), then the include.
- [x] Nav: `- Python with uv: userguides/anvil/python_uv.md` after `Anvil Software`.
- [x] Link from the Python paragraph of `anvil-software.md` and from `jobs.md` § Python.
- [x] `.venv/bin/python tools/generate_breadcrumbs.py`.
- **Touches:** `docs/userguides/anvil/{python_uv,anvil-software,jobs}.md`, `mkdocs.yml`, breadcrumbs.

## Phase P5 — Python guidance audit
**Satisfies:** R8 · **Depends on:** P2

- [ ] Hub intros (Gautschi, Gilbreth `python_example.md`; Negishi `python.md`) and
  `snippets/apps/python.md`, `snippets/examples/apps/python.md`: Miniforge `conda` wording, plus a
  pointer to uv (hubs link the page; snippets name `module load uv`).
- [ ] `python=3.8` → `python=3.12` in `snippets/examples/apps/python/conda.md`,
  Gilbreth `examples/python_conda.md`, Negishi `python/conda.md`.
- [ ] Gilbreth `learning/customml.md`, `learning/ml_batch.md`: `module load anaconda` →
  `module load conda`; env names `…-py3.8.5` → `…-py3.12`; the step text "Load the anaconda module"
  → "Load the conda module".
- [x] Anvil `anvil-software.md` Python sentence names the `conda` (Miniforge) and `uv` modules (done in P4, where the link to the uv page went).
- **Touches:** the files above (shared snippets are high-impact: human gate at review).

## Phase P6 — Blog post and author title
**Satisfies:** R7, R10 · **Depends on:** P1, P3, P4

- [ ] `docs/blog/posts/uv_manager.md` per PLAN §2: front-matter (`date.created` = drafting date,
  updated at publish; `categories: [Software, Announcements]`; `slug: uv-manager`; `authors:
  [glentner]`; tags `uv`, `Python`, `Conda`), excerpt + `<!-- more -->`, four `##` sections, links to
  `conda_anaconda.md`, the catalog entry and the five cluster pages.
- [ ] `docs/blog/.authors.yml`: `glentner.description: Principal AI Scientist`.
- **Touches:** the post, `.authors.yml`.

## Phase P7 — Integration and HPC accuracy
**Satisfies:** all · **Depends on:** P1–P6

- [ ] Every new page is reachable from its hub (and Anvil's from nav); the blog links resolve.
- [ ] Regenerate breadcrumbs if nav moved since P4.
- [ ] On each cluster's login node, with the deployed module, run every command the snippet shows
  (`uv --version`, `uv-manager status`, `uv run --no-project`, `uvx`, `uv venv` + `uv pip install`,
  `uv python pin 3.12`, `--python "$(command -v python3)"` after `module load conda`,
  `uv-manager doctor`) in a throwaway directory under the user's scratch; fix any mismatch.
- [ ] Final render pass of one cluster page, the Anvil page and the post.
- **Touches:** small fixes only.
