# 00 — Research digest

- [01](01-existing-python-pages.md): each cluster keeps Python sub-pages beside a hub page under
  `run_jobs/`, outside `nav:` (Anvil: inside `jobs.md`). A macro-free shared uv snippet included by
  one new page per cluster fits that pattern.
- [02](02-catalog-pipeline.md): add seeds (copies of the deployed `uv/0.7.0.lua` + `default`) and a
  curated description, then run `make` locally with GNU coreutils and commit its output, so links to
  `software/apps_md/uv.md` resolve in the branch build.
- [03](03-python-guidance-audit.md): R8 fixes are wording on five hubs and two snippets,
  `python=3.8` in three copies, and `anaconda` in two Gilbreth ML pages (`conda-env-mod` works
  under `conda`, checked). Hammer-only learning snippets need a scope call.
- [04](04-blog-archetype.md): blog front-matter and the 2025 post to link.
- [05](05-uv-manager-behaviour.md): the facts every uv paragraph rests on, with the measured
  Python-selection behaviour and the one unverified item (compute egress on three clusters).
