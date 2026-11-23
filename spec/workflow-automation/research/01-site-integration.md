# Research 01: existing-site integration

Scope: how the new **Workflow Automation** section fits the current site (nav, archetypes,
cross-links, catalog links, tabs, Jinja, build baseline). Existing-site survey only; no web.
All line refs are against `feature/workflow-automation` as of 2026-11-22.

## 1. Nav neighborhood (`mkdocs.yml`)

Theme features (`mkdocs.yml:17-27`): `navigation.indexes`, `navigation.sections`,
`navigation.top`, `navigation.footer`, `toc.follow`, `content.code.copy`, **`content.tabs.link`**.

Indent style: two spaces per level; each item `- Label: path`; a section is `- Label:` whose
first child is a bare `- dir/index.md` (the hub, via `navigation.indexes`). One local
irregularity: HPC Exchange week entries are indented four extra spaces (`mkdocs.yml:298-330`);
valid YAML, not a pattern to copy.

**RCAC Resources** (`mkdocs.yml:256-367`), in order:

| Lines | Child | Shape |
|---|---|---|
| 257-258 | RCAC Blogs | hub only |
| 259-276 | Software | hub + 16 catalog pages (generated); `Workflow: software/workflow_catalog.md` at 276 |
| 277-286 | Datasets | hub + catalogs |
| 287-293 | Profilers | hub + 5 flat pages, no subsections |
| 294-367 | RCAC Workshops | hub + nested series (HPC Exchange 296-330: hub, Week N subsections each with own `index.md`) |

**RCAC Services** (`mkdocs.yml:368-425`) for comparison: Life Sciences 369-402 (hub, then
label-only groupings `Getting Started`/`Guides`/`Tutorials` with **no** `index.md`); Agentic AI
403-415 (hub + 3 flat pages + two subsections `Running Agents` 408-411 and `Shared Context`
412-415, each with its own `index.md`); Purdue GenAI Studio 416-425 (hub + flat pages).
The HUBzero block (426 on) is generated (`# >>> hubzero nav ... do not edit`).

Note: Agentic AI is under **RCAC Services**, not RCAC Resources. It was planned as a top-level
section (`spec/agentic-ai-docs/PLAN.md:71-95`) and later moved under Services by commit
65c5151b ("Include Life Sciences, Agentic AI and GenAI into RCAC Services", 2026-09-02).

**Insertion options under RCAC Resources:**

1. **After Profilers, before RCAC Workshops** (insert between `mkdocs.yml:293` and `:294`).
   Keeps the "tools for running your work" entries (Software, Datasets, Profilers) together,
   ahead of training material. **Recommended.**
2. After Software (between `:276` and `:277`): next to the Workflow catalog, but splits
   Software from Datasets, which are paired catalogs.
3. After RCAC Workshops (after `:367`): end of section, least visible.

Hub + subsection structure to mirror is **Agentic AI** (flat pages + a subsection with its own
`index.md`), not Life Sciences (whose label-only groups have no landing page). A sketch for
option 1 (directory name is the planner's call; `workflows/` shown):

```yaml
    - Workflow Automation:
      - workflows/index.md
      - Slurm Job Arrays: workflows/job_arrays.md
      - GNU Make: workflows/make.md
      - GNU Parallel: workflows/parallel.md
      - Snakemake: workflows/snakemake.md
      - Nextflow: workflows/nextflow.md
      - Pegasus: workflows/pegasus.md
      - Parsl: workflows/parsl.md
      - Other Tools: workflows/other_tools.md
      - HyperShell User Guide:
        - workflows/hypershell/index.md
        - "Tier 1: ...": workflows/hypershell/tier1.md
        - ...
```

Directory naming on the site is mixed: `agentic-ai/`, `lifesciences/guides/*-*.md` (kebab),
`run_jobs/`, `hpc_exchange/`, `profilers/*_*.md` (snake). The style guide asks for snake_case
filenames (`.agents/factory/style-guide.md`, "Naming & file layout"). No `docs/workflows/`
or `docs/workflow*` exists yet. Breadcrumbs (`docs/assets/data/breadcrumbs.json`) regenerate
from nav (`tools/generate_breadcrumbs.py`; CI does it on `mkdocs.yml` change); GOAL forbids
hand-editing them.

## 2. Hub archetype and front-matter

| Hub | Front-matter | Body |
|---|---|---|
| `docs/lifesciences/index.md:1-7` | `title`, `tags: [Life Sciences]`, `search.boost: 1` | H1, one intro paragraph, 4 grid cards (`:material-*:{ .lg .middle } __Title__` / `---` / blurb / `[:octicons-arrow-right-24: label](rel.md)`), no closing text |
| `docs/agentic-ai/index.md:1-7` | `title`, `tags: [Agentic AI]`, `authors: [glentner]` | H1, two stance paragraphs, `!!! note "New and changing"`, `## In this section`, 5 grid cards, a closing line linking each cluster's chapter, a reference footer |
| `docs/profilers/index.md:1-8` | `title`, `tags: [Profilers, Performance]`, `search.boost: 2` | H1, one intro paragraph, 5 grid cards using brand icons (`:simple-nvidia:`, `:simple-amd:`, `:simple-intel:`) |

None of the three uses `hide:` (the style guide's archetype E suggests `hide: [footer]`/`toc`,
but these section hubs do not). Agentic AI's PLAN chose "`title` + `tags: [Agentic AI]`
(mirror `docs/lifesciences/index.md`)" for hubs, "`hide: [toc]` if card-only"
(`spec/agentic-ai-docs/PLAN.md:24-26`), and `tags` + `authors` for content pages
(`:184-185`). As shipped, **every** Agentic AI page carries `tags: [Agentic AI]` +
`authors: [glentner]`; hubs add `title`; **no** Agentic AI page sets `search.boost` or `hide`
(`docs/agentic-ai/**`; `authors` was added to the three hubs afterwards by 7e320c7a,
"[content] Add missing authors key to pages"). Profilers content pages carry `title`, `tags`
(section + vendor), `search.boost: 2`.

Site-wide tallies (non-generated, non-blog, non-HUBzero pages): `search.boost` 2 on 487 pages,
1 on 55, unset on 58. Existing tags of note: `Nextflow` (9), `Guides` (19), `Python` (24),
`GPU` (3), `HPC` (9); no `Workflows`, `HyperShell` or `Slurm` page tag yet (the blog has a
`Workflows` *category*, `mkdocs.yml:72`).

Rendering facts (from `overrides/`): `page.meta.title` drives the header and `<title>`
(`overrides/partials/header.html:28-29`, `overrides/base.html:38-39`); `page.meta.description`
emits `<meta name="description">` (`overrides/base.html:11-12`), used by 3 pages today;
`authors` on non-blog pages is not rendered (metadata only).

## 3. Existing HyperShell mentions (exact text)

- **`docs/software/apps_md/hypershell.md`** (generated): description "A cross-platform,
  high-throughput computing utility for processing shell commands over a distributed,
  asynchronous queue." (`:7`); Homepage "N/A" (`:11`); versions (`:17-21`): ANVIL 2.0.2 to
  **2.7.0 (D)**; GAUTSCHI develop, 2.5.2, 2.6.5, **2.7.0 (D)**; GILBRETH **2.5.2 (D)**;
  NEGISHI 2.0.2 to **2.7.0 (D)**; SCHOLAR **2.7.0 (D)**; `module load hypershell` (`:30`).
  Source inventory `tools/rcac_apps_inventory.json` key `hypershell` agrees.
- **`docs/software/apps_md/hyper-shell.md`** (generated): legacy module name, ANVIL 2.0.2 (D)
  only (`:17`), `module load hyper-shell`. Worth one sentence (old name) or ignoring.
- **Cluster `software.md`** pages use HyperShell as the worked example for `module avail` /
  `module spider` / `module load`: `docs/userguides/gautschi/software.md:26-28,35-55`,
  `gilbreth/software.md:32-61`, `negishi/software.md:42-61`, `scholar/software.md:28-57`;
  each ends `module load hypershell/2.7.0`. These blocks are near-identical copies (Gilbreth's
  shows 2.5.2/2.6.5/2.7.0 although the catalog lists only 2.5.2), so they are illustrative,
  not an availability source. No Anvil or Hammer page mentions HyperShell.
- **`docs/workshops/hpc_exchange/week4/workload-management.md`** (no front-matter; H1 at `:1`).
  Covers separate jobs (`:15-120`), Slurm job arrays (`:122-152`), and the pilot-job paradigm
  (`:156-195`). The HyperShell paragraph, verbatim (`:195`):

  > There are many tools out there for automating computing of many tasks with the pilot job
  > paradigm. Two examples are: HTCondor and HyperShell. They both achieve the task of
  > computing many things using a single Slurm job and each have different features.

  Natural one-line cross-link: append a sentence to `:195` (or a new line right after it,
  before `## Conclusion` at `:197`), e.g. "See [Workflow Automation](../../../workflows/index.md)
  for a comparison of these tools and a HyperShell user guide." No rewrite needed.
- **`docs/lifesciences/guides/vscode.md:167`** links HyperShell as
  `https://hyper-shell.readthedocs.io/` (older docs host; GOAL cites
  `hypershell.readthedocs.io`), and `:248` uses `hs info <task_id> --stdout` (top-level form,
  compliant). Life Sciences is out of scope; leave it, note only.
- Catalog lists: `docs/software/workflow_catalog.md:9`, `docs/software/app_catalog.md:504`.

## 4. Cross-link targets

**`docs/lifesciences/guides/nextflow.md`** ("Nextflow and nf-core on Negishi", 479 lines;
front-matter `title`, `tags: [Life Sciences, Nextflow, Guides]`, `search.boost: 1`). Installs
Nextflow **by the launcher script** into `~/bin` (`curl -s https://get.nextflow.io | bash`,
`:28-35`, `:52-96`) on `module load openjdk` (Java 17+); nf-core tools via `module load conda`
(`:37-41`, `:98-166`). Config `my_negishi.config` (`:180-292`): `executor = 'slurm'`,
`queue = 'cpu'`, `clusterOptions = '-A YOUR_ACCOUNT'`, `executor.queueSize = 100`, `highmem`
label route. Head job script at `:306-331` (`-A <account-name>`, `-p <partition-name>`).
Claims "The same steps work on Bell, Gautschi, and Gilbreth" (`:21-22`; Bell is retired, see
§9). Ends with `[Back to Life Sciences](../index.md){ .md-button }` (`:479`).
Cross-link spot: one "See also" line after the intro paragraph (after `:22`) or just above the
back button (`:478`). Relative path from there: `../../workflows/index.md`.

**`docs/lifesciences/guides/nextflow-gautschi.md`** ("Reproducible Bioinformatics Using
Nextflow", 433 lines; Genomics Exchange Session 7). Uses the **module**:
`module load nextflow/25.10.04` (`:126`, `:413`), the `purdue_gautschi` nf-core institutional
profile (SLURM executor, default queue `cpu`, `--cluster_account` mapped to `-A`, Apptainer,
ceilings 192 cores / 384 GB / 14 days, iGenomes at `/depot/itap/datasets/igenomes`;
`:320-331`, merged in nf-core/configs PR #1085). Head process runs in `sinteractive -A
<your-account> -N 1 -n 2 -p cpu -t 2:00:00` (`:113`). Its `## Why workflow managers`
(`:43-55`) already names Make, Snakemake and Nextflow (`:51`) and ends with a `!!! note` that
Nextflow is overkill for one-off commands (`:54-55`). **Best cross-link spot on the site:** one
line after that note (after `:55`), pointing to the new landing page.

**Other mentions** (grep of `docs/`, excluding `docs/software/apps_md`, `docs/hubzero`,
`ngc_md`, `rocm_md`):

| Term | Hits |
|---|---|
| GNU Parallel | none outside the catalog (`docs/software/apps_md/parallel.md`) |
| Snakemake | `docs/lifesciences/tutorials/braker.md:166-168` (`ml biocontainers` then `ml snakemake`, so Snakemake is reachable through Biocontainers; confirm live); `lifesciences/guides/project-organization.md:268,337` (`.snakemake/` dir); `nextflow-gautschi.md:51` |
| GNU Make | only incidental `make -j` in build recipes (`userguides/anvil/software/vasp.md`, `lammps.md`, `negishi/run_jobs/vasp/build-your-own-vasp-*.md`); `nextflow-gautschi.md:51` |
| Job arrays | `workshops/hpc_exchange/week4/workload-management.md:118-152`; `lifesciences/guides/running-bioinformatics.md:407-433` (`### Array jobs`); `lifesciences/guides/productivity-tips.md:746-775` (`### 14. Job Arrays`, incl. `%20` throttle); `lifesciences/guides/sra-download.md:223-254` (`=== "Array Job"` tab); `lifesciences/guides/script-to-pipeline.md:83-90,213` (arrays + `--dependency`) |
| Pegasus | **`docs/userguides/anvil/notebook.md:63-66`**, `## Pegasus on Anvil`, a single link to ACCESS's "Pegasus Workflows" documentation (relevant to the hosted-route question in GOAL); HUBzero: `hubzero/tools/developers/grid/pegasuswf.md`, `jupyter-submit.md`, `submitcmd.md`, `grid/index.md` |
| Parsl, Dask, Ray | none |
| HTCondor | `workload-management.md:195` only |
| MIG / MPS | `userguides/scholar/overview.md:38-39` (H-MIG, I-MIG nodes: 6 GB MIG slices of NVIDIA A30); `snippets/agentic-ai/scholar/agents.d/slurm.md:23` ("A30 MIG slices", `--gres=gpu:N`); no MPS anywhere |
| Pilot job / many-task | `workload-management.md:156-195`; `workshops/hpc_exchange/week4/index.md` |

**Job-array "gold standard": none in the cluster user guides.** No `run_jobs/` page on any
cluster (nor `docs/userguides/anvil/jobs.md`) documents `--array` or `SLURM_ARRAY_TASK_ID`
(grep of `docs/userguides` and `docs/snippets`). The closest are the HPC Exchange workshop
section and Life Sciences `running-bioinformatics.md#array-jobs`. The job-arrays page must
therefore carry its own worked example; link to those two for further reading, and to each
cluster's `run_jobs/job_dependencies.md` (all `--8<-- "docs/snippets/job_dependencies.md"`)
for `--dependency`. Per-cluster partition/account/QOS truth lives in
`docs/userguides/{gautschi,gilbreth,negishi,scholar}/run_jobs/queues.md` and
`docs/userguides/anvil/jobs.md:43` (`## Anvil Queues (Partitions)`); Gautschi gained a `burst`
QOS (`gautschi/run_jobs/queues.md:43`; home-page banner `docs/index.md:18-28`).
Header style varies by cluster (`#!/bin/sh -l` + `-A`/`--account`, e.g.
`gilbreth/run_jobs/submit_script.md:72-79`; `anvil/jobs.md:189-197`).

## 5. Workflow catalog and availability links

`docs/software/workflow_catalog.md` (generated; no front-matter) lists: bowtie2, bwa, gatk,
htseq, **hypershell**, **nextflow**, nf-core, samtools, spark, sratoolkit, vcftools
(`:5-15`). Mostly bioinformatics tools; of the roster only HyperShell and Nextflow are in it.

| Rostered tool | Catalog page | Clusters (default) |
|---|---|---|
| HyperShell | `docs/software/apps_md/hypershell.md` | Anvil, Gautschi, Negishi, Scholar 2.7.0 (D); Gilbreth 2.5.2 (D) |
| (legacy) hyper-shell | `docs/software/apps_md/hyper-shell.md` | Anvil 2.0.2 |
| Nextflow | `docs/software/apps_md/nextflow.md` | Anvil 22.10.1; Gautschi 24.04.3, 25.10.04, 26.04.2; Negishi 22.10.1 to 26.04.2; **no (D) marked anywhere**; not on Gilbreth or Scholar |
| nf-core tools | `docs/software/apps_md/nf-core.md` | Anvil 2.7.2, 2.8; Negishi to 2.11.1 |
| GNU Parallel | `docs/software/apps_md/parallel.md` (listed under Engineering and Material Science catalogs, not Workflow) | Anvil 20200822; Gautschi 20241022 (D); Gilbreth 20241022; Negishi 20220522; not Scholar |
| Slurm job arrays, GNU Make | n/a (scheduler feature / system tool) | |
| Snakemake, Pegasus, Parsl, HTCondor, Dask, Ray | **no catalog page**; none in `tools/rcac_apps_inventory.json` | Snakemake via Biocontainers per `braker.md:166-168` (unverified) |

Relative paths from `docs/workflows/*.md`: `../software/apps_md/<tool>.md`; from
`docs/workflows/hypershell/*.md`: `../../software/apps_md/hypershell.md`.

The inventory covers exactly **anvil, gautschi, gilbreth, negishi, scholar**
(`tools/rcac_apps_inventory.json`); no Bell, Hammer or Geddes.

## 6. Content tabs and macros

Config: `pymdownx.tabbed` with **`alternate_style: true`** (`mkdocs.yml:940-941`);
`content.tabs.link` **enabled** (`mkdocs.yml:26`). Material 9.6.16 persists the linked choice
in browser storage (`__md_set("__tabs", ...)` in the bundled JS), so a reader's "Gautschi"
click switches every tab labelled `Gautschi` on the page and on later pages.

Existing cluster-labelled tabs: `docs/faqs.md:10-102` (five tab sets, labels exactly
`"Anvil"`, `"Gautschi"`, `"Gilbreth"`, `"Negishi"`, `"Scholar"`, alphabetical, prose bodies);
`docs/lifesciences/guides/vscode.md:187-225` (`"Gautschi"`, `"Anvil"`, each wrapping a
`bash title="~/.ssh/config"` block; the Anvil tab body still points at Gautschi hosts,
existing error, out of scope). Agentic AI uses harness-labelled tabs wrapping code blocks
across pages (`agentic-ai/running_agents/on_cluster.md:60-75`, `mcp_servers.md:147-160`,
`shared_context/index.md:35-46`): the precedent for one label syncing many blocks. HPC
Exchange uses topic tabs wrapping highlighted `#SBATCH` blocks
(`workshops/hpc_exchange/week2/slurm-basics.md:80-88`). Label convention: plain proper name,
title case, no qualifiers; matching `faqs.md` exactly makes the new tabs sync with it.

A tab cannot sit *inside* a code block, so "per-cluster header, shared body" cannot be one
fenced block with a tabbed header. Workable pattern, **verified in a scratch MkDocs build with
the repo's own venv** (macros + snippets + tabbed, `--strict` clean): each tab holds one
complete fenced script built from two indented includes,

````markdown
=== "Gautschi"

    ```bash title="tier1.sh"
    --8<-- "docs/snippets/workflows/headers/gautschi.sh"
    --8<-- "docs/snippets/workflows/tier1/body.sh"
    ```
````

giving a complete, copy-pasteable script per tab, one source file for the shared body, and
Jinja safety (§7). Precedent for an indented include inside a fenced block inside a container:
`docs/agentic-ai/shared_context/context_files.md:60-63`. Caveats: `docs/snippets/**` is a
high-impact path (invariants header), and includes fail silently on a typo (`check_paths`
default; style guide), so grep the built `site/` for a token per include.

Macros (`main.py`, `define_env` at `:77`): **none emits per-cluster `#SBATCH` headers,
partitions or accounts.** `slurm_general_overview(resource)` (`:317`) and
`slurm_general_jobs(resource)` (`:339`) emit generic prose with a placeholder header
(`#SBATCH -A <account>` / `-p <partition>`, hard-coded "128 processor cores", used only by
`docs/userguides/anvil/jobs.md`). `module_system(resource)` (`:611`), `scratch_space(resource)`
(`:765`), `scratch_purge(resource)` (`:821`), `resource_use(resource)` (`:813`),
`environment_variables(resource)` (`:753`) are snippet wrappers taking a cluster name.
Nothing here is reusable for the tabbed headers; hand-written per-cluster header files are
needed.

Other extension facts: `pymdownx.highlight` sets `linenums: true` globally (`:933-937`),
so every block is numbered unless `linenums="0"`; `pymdownx.superfences` has **no
`custom_fences`** (`:939`), so **Mermaid is unavailable** (diagrams must be tables or images
with alt text, or a `mkdocs.yml` change, which is high-impact); `def_list`, `footnotes`,
`abbr`, `tasklist` are not enabled; `pymdownx.blocks.caption`, `md_in_html`, `attr_list`,
`admonition`, `pymdownx.details` are.

## 7. Jinja hazards

The macros plugin (`mkdocs.yml:96`, defaults; mkdocs-macros-plugin 1.3.9) renders every page
whose front-matter lacks `render_macros: false`, **including code blocks**. Defaults:
`on_undefined: keep` (unknown `{{ name }}` is left verbatim) and `on_error_fail: false`.

Probe results (Jinja and a scratch `mkdocs build --strict` with the repo venv):

| Source text | Result |
|---|---|
| `${#arr[@]}` (bash array length), `${#var}` | **TemplateSyntaxError "Missing end of comment tag"** (`{#` opens a Jinja comment) |
| GNU Parallel `{#}` (job sequence number) | **same error** |
| `printf '{%s}'`-style `{%` | **TemplateSyntaxError** (unknown tag) |
| `{{ undefined_name }}` | left verbatim (`keep`); a *defined* name (`page`, `config`, `resource`) would render |
| HyperShell `{}`, `{/}`, `{.}`, awk `'{print $1}'`, `${SLURM_ARRAY_TASK_ID}` | safe |

On a syntax error the plugin logs `WARNING - [macros] - ERROR ... Macro Syntax Error` and
**replaces the whole page** with an error page; under `--strict` the build aborts
("Aborted with 1 warnings in strict mode!"), which `strict_check.py` catches as a new warning.
Hazards for this section: bash `${#...}`, GNU Parallel `{#}`, Snakemake doubled braces in
`shell:` strings (`awk '{{print $1}}'`), any Jinja-like templating shown as an example.

Escaping on the site: `{% raw %}...{% endraw %}` appears only in `docs/templates.md:71-82`
(2 blocks). `render_macros: false` is used by **416 pages, all under `docs/hubzero/`**
(generated import), none elsewhere. The style guide's preferred pattern is the
`--8<--`-in-a-fenced-block include, since snippets splice in after the macros pass. A content
page that never calls a macro could also set `render_macros: false`; that has no precedent
outside HUBzero.

## 8. Build baseline

`.venv` present (mkdocs 1.6.1, Python 3.15); no bootstrap needed.
`.venv/bin/mkdocs build --strict 2>&1 | .venv/bin/python .agents/factory/bin/strict_check.py`
gives **PASS: "no new --strict warnings (0 present, all in baseline of 0)"**; build exit 0, about 23 s.
`.agents/factory/strict-baseline.txt` is **empty** (comment header only; zero tolerated warnings).
Six pre-existing **INFO**-level "contains a link ... does not contain an anchor" messages
(depot, fortress, hammer pages): **broken `#anchor` links are INFO, not WARNING, so
`--strict` does not catch them.** New pages need a separate check, e.g. grep the build log for
`INFO .* 'workflows/` "contains a link".

## 9. Bell

**Bell is decommissioned and its docs are gone.** Banner "RCAC to decommission Bell on
October 31, 2026" (commit 9c6a67b8, 2026-07-10); "Remove all Bell related contents" (258ebfe6,
2026-11-04, PR #323) removed the Bell user guide, nav, breadcrumbs and catalog columns;
follow-ups 2e8292a1, 310a4235 removed more references. No `docs/userguides/bell/`, no Bell
in `mkdocs.yml` or in `tools/rcac_apps_inventory.json`. Remaining mentions are stale
(`lifesciences/guides/nextflow.md:21`, `hpc-orientation.md:35,81,143`,
`running-bioinformatics.md:20,48`, `snippets/monitoring_job.md:16-19` sample output,
`hammer/run_jobs/examples/slurm/specific.md` dead anchor `#bell-specifications`, a commented
table at `workshops/hpc_exchange/week2/clusters.md:80`, "Reties Fall 2026"). **A Bell tab
would point users at a retired cluster.** The GOAL-gate cluster list (Anvil, Bell, Gautschi,
Negishi, Gilbreth, Scholar) was explicitly subject to research confirmation.

## Recommendations for PLAN

1. **Placement:** insert `- Workflow Automation:` under RCAC Resources between
   `mkdocs.yml:293` (end of Profilers) and `:294` (RCAC Workshops), two-space indent, hub
   `index.md` first; HyperShell guide as the last child, a subsection with its own `index.md`
   (the Agentic AI shape). Add nav lines in the same phase as each page.
2. **Directory:** a single tree such as `docs/workflows/` with `docs/workflows/hypershell/`
   for Part B; snake_case filenames; assets under `docs/assets/images/workflows/`.
3. **Front-matter contract.** Hubs (`workflows/index.md`, `workflows/hypershell/index.md`):
   `title`, `tags: [Workflows]` (plus `HyperShell` on the guide hub), `authors: [<handle>]`,
   `search: {boost: 2}`; no `hide` (none of the three model hubs hides anything). Content
   pages: `title`, `tags` (section tag + tool tag, reusing `Nextflow`/`GPU` where they fit),
   `authors`, `search: {boost: 2}` (site norm; Profilers precedent). Optional `description:`
   (rendered as meta description). Settle the exact tag strings in PLAN.
4. **Hub body:** H1, a short intro, grid cards in the house syntax (one per tool page or
   group plus one for the HyperShell guide), and a closing line to the Workflow catalog and
   `apps_md` pages. Card icons: `:material-*:` (no brand icons exist for most tools).
5. **Cluster tabs:** **drop Bell** (retired, §9) and record the deviation from the GOAL-gate
   list; use exactly `Anvil`, `Gautschi`, `Gilbreth`, `Negishi`, `Scholar` (alphabetical,
   matching `docs/faqs.md`, so `content.tabs.link` syncs them site-wide). Gilbreth's default
   HyperShell is 2.5.2 (catalog); with unpinned `module load hypershell` that tab gets an old
   version, which the version admonition must cover. Scholar and Gilbreth lack Nextflow;
   Scholar lacks GNU Parallel.
6. **Script pattern:** one complete script per tab assembled from `--8<--` includes (a
   per-cluster header file + one shared body file) under `docs/snippets/workflows/`. Verified
   to build `--strict` clean and to keep bodies Jinja-safe. Budget for the high-impact
   `docs/snippets/**` review gate and a `site/` grep per include.
7. **Jinja:** keep any script containing `${#`, `{#}`, `{%` or Snakemake `{{ }}` in a snippet
   file, or wrap it in `{% raw %}`; add a draft-time grep for `\{#|\{%|\{\{` in new pages.
8. **Cross-links (one line each, no rewrites):** `nextflow-gautschi.md` after `:55`;
   `nextflow.md` after `:22` (or above `:479`); `workload-management.md:195` (append a sentence).
   From the new section, link `running-bioinformatics.md#array-jobs`, the workshop's
   job-array section, each cluster's `run_jobs/queues.md` / `anvil/jobs.md`, the
   `apps_md` pages in §5, and `docs/userguides/anvil/notebook.md` (Pegasus on Anvil) for the
   Pegasus hosted route.
9. **Job arrays:** the site has no cluster-guide job-array page to defer to, so the baseline
   page carries its own minimal worked example (with `%N` throttling) rather than linking out
   for the basics.
10. **Diagrams:** Mermaid is not configured; render the "dimensions" comparison as a table
    (header row) or an SVG/PNG with full alt text, not a `mermaid` fence.
11. **Verification extras** beyond `strict_check.py`: grep the build log for INFO
    anchor messages on new paths (anchors are not strict-checked); grep `site/` for include
    tokens. Optional and outside GOAL: a home-page card in `docs/index.md:219-263`
    ("RCAC Resources" grid). Leave it to a follow-up unless the planner adds it.
