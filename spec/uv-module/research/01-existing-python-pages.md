# 01 — How the five clusters' guides hold Python material today

Surveyed 2026-10-31 on `main` at `708cc88d`.

| Cluster | Python hub | Sub-pages | In `nav:`? |
|---|---|---|---|
| Anvil | `userguides/anvil/jobs.md` § "Extended Examples → Python on {{ cluster }} cluster" includes `snippets/apps/python.md`; `anvil-software.md` has one paragraph on Python distributions | none | Anvil's nav is flat and explicit; `jobs.md` and `anvil-software.md` are listed |
| Gautschi | `run_jobs/python_example.md` (links list) | `run_jobs/examples/example_python_job.md`, `example_distributed.md` | only `run_jobs/index.md` |
| Gilbreth | `run_jobs/python_example.md` (links list) | `run_jobs/examples/python_{conda,packages,env_example,numpy,pip,source}.md`, `example_python_job.md` | only `run_jobs/index.md` |
| Negishi | `run_jobs/python.md` (links list) | `run_jobs/python/{example_python_job,conda,pip,packages,source,environment_example,numpy}.md` | only `run_jobs/index.md` |
| Scholar | `run_jobs/python_example.md` includes `snippets/apps/python.md` whole | none | only `run_jobs/index.md` |

Findings:

- **Sub-pages under `run_jobs/` are not in `nav:`.** They are reached from their chapter's hub
  page. MkDocs 1.6 reports a page missing from nav at INFO level, so `--strict` does not fail on
  them, and they are not in `strict-baseline.txt`. A new uv page placed beside its siblings follows
  the same pattern; listing only it in nav would break per-cluster parallelism (§10).
- **The Gilbreth and Negishi sub-pages are copies, not includes** of `snippets/examples/apps/python/*`.
  A fix to one copy must be made in each.
- `snippets/apps/python.md` is included by Anvil `jobs.md` and Scholar `python_example.md` only.
  `snippets/examples/apps/python.md` and `snippets/examples/apps/python/*` are included by the Bell
  and Hammer guides.
- Front-matter on these pages: `tags: [<Cluster>]`, `authors`, `resource: <Cluster>`,
  `search: {boost: 2}`. Hub pages end with a bold back-link to `index.md`.
- The hub prose on every cluster still says "We suggest using Anaconda … to use the default
  Anaconda distribution:" above `module load conda`, which now loads Miniforge.
- **Snippets and macros:** no Python snippet uses `{{ }}`. A shared uv snippet stays macro-free so
  it renders the same wherever it is included; cluster-specific text lives on the including page.
