# Documentation invariants — the footgun checklist

A curated, explicitly-enumerated subset of the load-bearing rules from `AGENTS.md`, kept
**in lockstep with it**. `AGENTS.md` is ground truth; if this file drifts, fix it. Two
consumers:

- **`docs-plan` (gate):** before research and again after the design is drafted, walk the
  sections this change touches and confirm the design honors each; record any deliberate
  bend in PLAN's deviation-justification table.
- **`docs-review` (footgun list):** any violation here is **auto-CRITICAL**; if it touches
  a high-impact file (below), it forces a **human sign-off gate** before publish.

Rule: only invoke the sections relevant to the change. Do not manufacture findings against
untouched parts of the site.

**High-impact files** (any CONFIRMED review finding touching these → mandatory human gate):
`mkdocs.yml` · `main.py` · `docs/snippets/**` · `overrides/**` · `docs/stylesheets/**` ·
`docs/assets/js/**` · `requirements.txt` · `Dockerfile.geddes-prod` · `k8s/**` ·
`.github/workflows/**` · `tools/**` + `modulefiles/**` · any hand-edit of a generated
output file · any dev-only accessibility-layer path edited on `main` (see §2).

---

## §1 — Branch & deploy model

`main` is the trunk **and the only production branch**. A merge to `main` auto-deploys to
the Geddes Kubernetes cluster within ~5 minutes; **there is no staging environment**, so
review is the last line of defense before users see it. Do all work on a short-lived
`feature/`, `fix/`, or `refactor/` branch and open a PR into `main`.

`dev` is a **long-lived WCAG 2.1 accessibility-remediation branch**, not a staging or
integration branch. Data flows **main → dev** (via `sync_main_to_dev.yml`); **`dev → main`
PRs are hard-blocked by CI** (`block_dev_to_main.yml`). Never cherry-pick, rebase, or PR
from `dev` into `main` without an explicit human request tied to the a11y rollout.

## §2 — The dev-only accessibility layer is untouchable on `main`

The `sync_main_to_dev.yml` workflow force-preserves a hardcoded set of dev-only files;
edits made to them on `main` can be **clobbered** on the next sync. Never modify these on
`main`: `docs/stylesheets/extra.css`, `overrides/partials/{toc,header,logo,nav,nav-item,palette,search}.html`,
`overrides/base.html`, `docs/assets/js/a11y.js`, `dev.md`, `Dockerfile.geddes`,
`k8s/geddes-dev/`, `deploy_to_geddes_dev.yml`, `wcag_audit/`. Theme-level accessibility is
a `dev` concern; on `main` you own **content-level** a11y only (§9).

## §3 — Generated-content firewall

Never hand-edit generated files — your changes are lost on the next regeneration. They
carry a `<!-- generated … do not edit -->` marker. This includes:
`docs/software/apps_md/**`, `docs/software/*_catalog.md`, `docs/software/index.md`,
`docs/software/ngc_md/**`, `docs/software/rocm_md/**`, `docs/datasets/dataset_catalog.md`,
and `docs/assets/data/breadcrumbs.json`. To change them, edit the source
(`modulefiles/`, `tools/*.json`, or the generator scripts) and regenerate:
`cd tools && make` for the software/dataset catalogs, `python tools/generate_breadcrumbs.py`
for breadcrumbs.

## §4 — Navigation is manual

Every new page **must** be added to `nav:` in `mkdocs.yml`, or it is orphaned (unreachable
except by search/direct URL) and `mkdocs build --strict` warns "not included in nav".
Section hubs use an `index.md` (the `navigation.indexes` feature). After a `nav:` change,
breadcrumbs regenerate (`python tools/generate_breadcrumbs.py`; CI also does this on
`mkdocs.yml` change). Preserve per-cluster nav parallelism (§10).

## §5 — Links relative, assets absolute

Page-to-page markdown links are **relative** to the current file
(`[Overview](overview.md)`, `[Back](../index.md)`) so `mkdocs build --strict` can validate
them and they survive moves. Static assets (images, PDFs, JS/CSS) use **absolute**
site-root paths (`/assets/images/userguides/foo.png`). Getting `../` depth wrong is the
single most common broken-link bug here (see `strict-baseline.txt` for live examples).

## §6 — Front-matter per archetype

Match the archetype's front-matter contract (full detail in `style-guide.md`):

- **Userguide page:** `tags: [<Cluster>]`, `authors: [<handle>]`, `resource: <Cluster>`
  (only if the body uses `{{ resource }}`), `search: { boost: 2 }`.
- **Blog post:** `date: { created: YYYY-MM-DD }`, `categories:` from the allowed set
  (`Announcements, Anvil, Gautschi, Software, Slurm, Workflows, Life Sciences`), `title`,
  `slug`, `authors:` (∈ `docs/blog/.authors.yml`), and a `<!-- more -->` excerpt marker.
- **Catalog / landing:** `hide: [footer]` (and often `toc`); generated catalogs also carry
  `search: { exclude: true }`.

## §7 — Macros, snippets, and Jinja escaping

Cluster-variable content is produced by macros in `main.py` (`{{ ssh_keys_snippet(resource) }}`,
inline `{{ resource }}`) — don't hardcode what a macro supplies. File includes use
`--8<-- "docs/snippets/…"` (repo-root-relative); `snippets/` is `exclude_docs` — snippets
are includes, not linkable pages. The macros plugin evaluates Jinja: any **literal**
`{{` or `{%` in prose or a code block (e.g. a Slurm array `${SLURM_...}` is fine, but
`{{ … }}` templating shown as an example) must be wrapped in `{% raw %}…{% endraw %}` or
the build breaks.

## §8 — Build integrity (hammerable: false)

`mkdocs build --strict` must introduce **no new warnings** versus `strict-baseline.txt`.
CI builds with `--verbose`, not `--strict`, so broken links and nav orphans would
otherwise ship silently. Gate with:
`.venv/bin/mkdocs build --strict 2>&1 | python3 .agents/factory/bin/strict_check.py`.
This is a correctness gate, not a nicety — do not scope-hammer it.

## §9 — Content-level accessibility, WCAG 2.1 (hammerable: false)

Every image needs meaningful `alt` text (empty `alt=""` only for decorative images);
headings descend without skipping levels (one `#` H1 per page); link text is descriptive
(not "click here"); tables use header rows; meaning is never conveyed by color alone.
This is *content* a11y, which you own on `main`; *theme* a11y lives on `dev` (§2) — the
reviewer must not demand theme fixes on `main`.

## §10 — Per-cluster parallelism

Cluster user guides share a consistent chapter set and order (Overview, Biography,
Accounts, Software, Running Jobs, File Storage and Transfer, Gateway/Open OnDemand,
Compiling Source Code, FAQs). A new cluster guide mirrors this structure; a new chapter
type is either added across clusters or intentionally scoped in `GOAL.md` non-goals.

## §11 — HPC technical accuracy (hammerable: false)

Slurm directives, partition and sub-cluster names, `module load` commands, filesystem
paths and quotas, node/GPU specs, and gateway URLs must be **correct and
cluster-appropriate**. Verify against authoritative sources or existing gold-standard
pages (e.g. `docs/userguides/gautschi/`) — never invent a flag or a path. When unsure,
emit `[NEEDS CLARIFICATION]` rather than guess. Note: technical accuracy is often not
machine-checkable, so review classifies it PLAUSIBLE (human triage), not
CONFIRMED-by-command (see `review-rubric.md`).

## §12 — Commit & PR conventions

Target `main`; open a squash PR. Commit subjects are `[category] Imperative summary`
(category ∈ `feature`, `fix`, `refactor`, `docs`, `content`, `catalog`, `ci`, `harness` —
not closed). **No `Co-Authored-By` trailer** (a deliberate clean-log convention; end PR
*bodies* with the generation line instead). Use `Closes #NN` to auto-close an issue —
here it works, because `main` is the default branch. Commit only when asked; never commit
straight to `main` (always via a branch + PR) and never to `dev` outside an a11y rollout.
