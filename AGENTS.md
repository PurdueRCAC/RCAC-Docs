# AGENTS.md

Guidance for agents (Claude Code and others) working in this repository. `CLAUDE.md` is a
symlink to this file — edit `AGENTS.md`, never a separate copy. (`.claude` is likewise a
symlink to `.agents`, so Claude Code discovers the documentation-factory skills and settings
through it.)

This document is the operating manual and **constitution**: the architecture, the
load-bearing invariants, and the process rules an agent needs to make correct, safe changes
to this documentation site without rediscovering them each session. **When something here
disagrees with the rendered site or the source tree, the site is ground truth — fix this
file.** The curated `.agents/factory/invariants.md` is a strict subset of this file, kept in
lockstep; if it drifts, this file wins.

---

## Project

This is the MkDocs Material documentation website for the **Rosen Center for Advanced
Computing (RCAC)** at Purdue University — user guides, references, software/dataset catalogs,
blog articles, and workshop/training material for RCAC's HPC clusters and storage services.

- **Production URL:** <https://docs.rcac.purdue.edu> (served from the Geddes Kubernetes cluster).
- **Source repo:** <https://github.com/PurdueRCAC/RCAC-Docs>.
- **Design/content reference sites** (same MkDocs-Material lineage): docs.tacc.utexas.edu,
  docs.alcf.anl.gov, docs.ncsa.illinois.edu, docs.jetstream-cloud.org, docs.hpc.ucdavis.edu.

## Environment & working rules

- **Setup — one supported way: a `uv`-managed virtualenv synced from `requirements.txt`.** Do
  **not** run `mkdocs` or the factory scripts against the system Python (it lacks the pinned deps).
  This bootstrap is idempotent — safe to re-run to resync:
  ```bash
  # uv-first (recommended):
  [ -x .venv/bin/python ] || uv venv                       # create ./.venv if missing
  uv pip install -r requirements.txt --python .venv/bin/python   # sync pinned deps into it
  # fallback if uv is unavailable:
  #   [ -x .venv/bin/python ] || python3 -m venv .venv
  #   .venv/bin/python -m pip install -r requirements.txt
  ```
  Then **invoke every tool through `.venv/bin/…` — no `activate` needed** (this explicit form is
  unambiguous and is what the factory scripts and `verify:` gates assume): `.venv/bin/mkdocs …`,
  `.venv/bin/python …`. The project is `requirements.txt`-managed — there is no `pyproject.toml`
  and no `uv.lock`.
- **Always run tooling from the repo root** (and via `.venv/bin/`). The macros module (`main.py`)
  and the factory scripts resolve paths relative to the current directory.
- **Commit only when explicitly asked.** When you do: branch off **`main`** (never commit
  straight to `main`; never touch `dev` outside an a11y rollout — see Branch & deploy model).
  Commit subjects follow `[category] Imperative summary` — categories include `feature`, `fix`,
  `refactor`, `docs`, `content`, `catalog`, `ci`, `harness` (the `.agents/` factory); the set is
  not closed.
- **No `Co-Authored-By` trailer** on commits — a deliberate clean-log convention. End PR
  **bodies** with the generation line instead. (Automated commits are authored as the GitHub
  App bot `purduercac-docs-bot`.)
- **Use `Closes #NN`** to auto-close an issue — it works here because `main` is the default branch.

## Commands

```bash
# All tooling runs through the uv-synced .venv (see Setup) — no activation needed.
.venv/bin/mkdocs serve                     # local preview at http://localhost:8000
.venv/bin/mkdocs serve -a localhost:8080   # custom port
.venv/bin/mkdocs build                     # build the static site into ./site (gitignored)
.venv/bin/mkdocs build --strict            # promote link/nav warnings to errors — USE THIS to verify (CI does not)

cd tools && make                           # regenerate the software & dataset catalogs (see Automation)
.venv/bin/python tools/generate_breadcrumbs.py   # regenerate docs/assets/data/breadcrumbs.json after a nav change

# Optional: build the production image locally
docker build -f Dockerfile.geddes-prod -t rcac-docs-prod:local . && docker run --rm -p 8080:80 rcac-docs-prod:local
```

**Stack:** MkDocs 1.6.1 · Material for MkDocs 9.6.16 (custom_dir `overrides`) · Python 3.11 in
the prod image · pinned in `requirements.txt`. Plugins: `search`, `blog`, `tags`,
`git-revision-date-localized`, `rss`, `macros` (see `main.py`). Markdown extensions: `toc`
(permalink), `tables`, `attr_list`, `md_in_html`, `admonition`, and `pymdownx.*` (`details`,
`blocks.caption`, `emoji`, `snippets`, `highlight`, `inlinehilite`, `superfences`, `tabbed`).

## Repository map

| Path | Responsibility |
|------|----------------|
| `docs/` | All published content (the only directory MkDocs builds). |
| `docs/userguides/<cluster>/` | Per-cluster/storage guides (anvil, bell, gautschi, gilbreth, negishi, scholar, geddes, hammer; storage: depot, fortress, boxfolder, reedfolder). Consistent chapter set across clusters. |
| `docs/blog/posts/` | Blog posts (Material blog plugin); authors in `docs/blog/.authors.yml`. |
| `docs/software/`, `docs/datasets/` | **Auto-generated** catalog pages (see Automation) — do not hand-edit. |
| `docs/workshops/`, `docs/lifesciences/` | Training material, organized as series with an `index.md` hub. |
| `docs/snippets/` | Reusable includes (`--8<--`); `exclude_docs` — not pages. |
| `docs/assets/` | Images, JS, CSS, data (`assets/data/breadcrumbs.json` is generated), PDFs, fonts. |
| `mkdocs.yml` | Config, theme, plugins, markdown extensions, and the **manually curated `nav:`**. |
| `main.py` | `mkdocs-macros` module — the `{{ … }}` macros/snippets (SSH, accounts, Slurm, storage, containers, …). |
| `overrides/`, `docs/stylesheets/` | Material theme overrides + custom CSS (much of it dev-only a11y layer — see below). |
| `tools/` | Catalog generators (`Makefile`, `generate_*`/`update_*`) and `generate_breadcrumbs.py`. |
| `modulefiles/` | HPC module files that seed the software-catalog generator. |
| `hooks/` | MkDocs hooks (`socialmedia.py`, currently disabled in `mkdocs.yml`). |
| `Dockerfile.geddes-prod`, `k8s/geddes-prod/` | Production image (builder → nginx) and Kubernetes manifests. |
| `.github/workflows/` | CI/CD (deploy, catalog rebuild, breadcrumbs, branch sync/guard). |
| **`.agents/`** | The spec-driven **documentation factory** (`docs-*` skills + `factory/` methodology, invariants, style guide, EARS, review rubric, templates, and `bin/` FSM scripts). `.claude` symlinks here. |
| **`spec/{slug}/`** | The committed, dated per-job design records (`GOAL/PLAN/TECH/REVIEW.md`) the factory produces and retains on merge. Outside `docs/`, so not published. |

## Content conventions & archetypes

Full detail in `.agents/factory/style-guide.md`; `docs/templates.md` is the live extension
reference. In brief:

- **Archetypes:** cluster user-guide article · catalog entry (mostly generated) · blog post ·
  tutorial/workshop lesson · reference/hub/landing. Each has a distinct front-matter contract.
- **Front-matter:** user guides carry `tags`/`authors`/`resource`/`search.boost:2`; blog posts
  carry `date.created`/`categories` (from the allowed set)/`slug`/`authors` + a `<!-- more -->`
  excerpt marker; landing/catalog pages use `hide: [footer(, toc)]`.
- **Links relative, assets absolute:** page-to-page markdown links are relative
  (`[Overview](overview.md)`); images/PDFs/JS/CSS use absolute site-root paths (`/assets/…`).
- **Reuse over duplication:** cluster-variable content comes from `main.py` macros
  (`{{ ssh_keys_snippet(resource) }}`, inline `{{ resource }}`) and `--8<--` snippet includes —
  don't hardcode what a macro supplies. Escape literal `{{`/`{%` in prose with `{% raw %}`.
- **Voice:** professional, instructional, second person; imperative for steps; admonitions for
  notes/warnings; one `#` H1 per page; cross-link and end subpages with a back-link.

## Invariants (load-bearing)

The curated footgun checklist is `.agents/factory/invariants.md` (used by the plan gate and the
review). The headlines:

1. **Branch & deploy model** — `main` is trunk *and* production; merging auto-deploys. `dev` is
   the a11y branch; `dev → main` is CI-blocked.
2. **The dev-only a11y layer is untouchable on `main`** (the sync workflow clobbers it).
3. **Generated-content firewall** — never hand-edit catalogs or `breadcrumbs.json`; regenerate.
4. **Nav is manual** — add every new page to `mkdocs.yml` `nav:` or it is orphaned.
5. **Links relative, assets absolute.**
6. **Front-matter per archetype** (blog `categories` from the allowed set; `<!-- more -->`).
7. **Macros/snippets + Jinja escaping.**
8. **Build integrity** — `mkdocs build --strict` introduces no new warnings **and no build
   errors** vs the baseline (`hammerable: false`).
9. **Content-level WCAG 2.1 accessibility** (`hammerable: false`).
10. **Per-cluster parallelism** — keep the shared chapter set/order.
11. **HPC technical accuracy** — commands, flags, partitions, paths, specs must be correct
    (`hammerable: false`).
12. **Commit/PR conventions** (this file's "Environment & working rules").

## Branch & deploy model

- **`main`** — trunk and the **only production branch**. All content/feature/nav/infra work
  targets `main` via a PR from a short-lived `feature/`|`fix/`|`refactor/` branch. **A merge to
  `main` auto-deploys to production within ~5 minutes — there is no staging gate.**
- **`dev`** — a long-lived, permanently-divergent **WCAG 2.1 accessibility-remediation** branch
  carrying an experimental theme/override layer not yet ready for production. Served from its own
  Geddes environment for WAVE re-audits.
- **Data flow is main → dev.** `sync_main_to_dev.yml` forward-merges `main` into `dev` on every
  push, force-preserving a hardcoded list of dev-only files (`docs/stylesheets/`,
  `overrides/partials/toc.html`, the `a11y.js` nav entry, …). Editing those files on `main` risks
  being clobbered — do that work on `dev`.
- **`dev → main` PRs are hard-blocked** by `block_dev_to_main.yml`. When the a11y work is
  accepted, the endgame is a deliberate, curated PR of the theme layer — never an automatic merge.

**Deploy chain:** push/merge to `main` → `deploy_to_geddes_prod.yml` builds `Dockerfile.geddes-prod`
(`python:3.11-slim` → `mkdocs build --verbose` → `nginx:alpine`) and pushes
`ghcr.io/purduercac/rcac-docs-prod:latest` → the in-cluster `rcac-docs-prod-restart` CronJob
(every 5 min) rolls the deployment (`imagePullPolicy: Always`). Manifests live in `k8s/geddes-prod/`
(`deployment/service/ingress/cronjob/nginx.conf`).

## Automation & generated content

- **Software/dataset catalogs** are generated from `modulefiles/` + `tools/*.json` by
  `tools/Makefile` (`make` runs `update_apps_inventory.sh` → `generate_apps_topics.py` →
  `update_apps_descriptions_from_inventory.sh` → `generate_md.sh` → `update_apps_catalog.sh`, plus
  the NGC/ROCm steps). Output lands in `docs/software/**` and `docs/datasets/dataset_catalog.md`
  with a `<!-- generated … do not edit -->` marker. `rebuild_on_module_tools_change.yml`
  regenerates and bot-commits these when `modulefiles/**` or `tools/**` change.
- **Breadcrumbs** — `python tools/generate_breadcrumbs.py` writes `docs/assets/data/breadcrumbs.json`
  from the nav; `update_breadcrumbs.yml` regenerates and bot-commits it when `mkdocs.yml` changes.
- **CI is not `--strict`.** The prod build uses `mkdocs build --verbose`, so broken internal links
  and nav orphans deploy silently. The factory's verify gate runs `--strict` to catch them; see
  `.agents/factory/strict-baseline.txt` for the known pre-existing warnings.

## Special features

- **Macros (`main.py`):** `mkdocs-macros` functions for reusable, cluster-variable content —
  SSH/keys/X11/ThinLinc, accounts, Slurm overviews, storage/scratch/quota, transfers
  (scp/sftp/globus/htar/hsi), containers (apptainer/biocontainers/rocm), compile, recovery, etc.
  Read `main.py` for the current list and signatures before hardcoding anything.
- **Theme:** Purdue branding, light/dark/auto palette, custom CSS in `docs/stylesheets/extra.css`,
  custom JS in `docs/assets/js/` (tablefilter, breadcrumbs, external-links, outage-widget).
- **Analytics & feedback:** Google Analytics; a thumbs up/down page-feedback widget.

## Working on this repo as an agent — the documentation factory

- **Use the factory for non-trivial work.** A documentation job (`feature`/`fix`/`refactor`) flows
  through the `.agents/` spec-driven lifecycle — `/docs-feature` (shape `GOAL.md`) → `/docs-plan`
  (research + `PLAN.md`/`TECH.md`) → `/docs-draft` (execute phases) → `/docs-review` (blind,
  externally-verified QA) → `/docs-publish` (squash PR to `main`), each on a
  `feature/`|`fix/`|`refactor/` branch with artifacts committed under `spec/{slug}/`.
  `.agents/factory/methodology.md` is the *why*; `getting-started.html` is the onboarding.
  **Ceremony scales to appetite** — a one-sentence fix may skip the lifecycle entirely.
- **Verify by rendering, not asserting.** After a change, run
  `.venv/bin/mkdocs build --strict 2>&1 | python3 .agents/factory/bin/strict_check.py` (no new
  warnings **and no build errors**), confirm the page is in `nav:`, and `.venv/bin/mkdocs serve` to
  eyeball the render — the concurrency and link/nav behavior are where documentation bugs hide.
- **Put content where it belongs:** new pages under `docs/…` + a `nav:` entry; cluster-variable
  content via `main.py` macros (extend the macro, don't fork the prose); generated catalogs via
  `tools/`, never by hand.
- **Never guess HPC specifics.** A wrong `#SBATCH` flag, partition, module, or path misdirects real
  users. Verify against a gold-standard page or an authoritative source, or emit
  `[NEEDS CLARIFICATION]`.
- **This file is the map, but it drifts.** For a deep change, re-verify the specific invariant
  against the site/source before relying on it, and update this file when things move.

## Contact

- **Org:** Rosen Center for Advanced Computing · **Email:** rcac-help@purdue.edu
- **GitHub:** <https://github.com/PurdueRCAC> · **Discord:** <https://discord.gg/RmtKZmaQW9>
