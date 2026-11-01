# 02 — Getting `uv` into the software catalog (R1)

- **Source of truth:** `modulefiles/<cluster>/…` seed Lua files, mirrored from the clusters by a
  staff member in periodic "Update modules." commits (last 2026-10-29). Seeds keep each cluster's
  own layout: `anvil/{cpu,gpu}/Core/`, `gautschi/{cpu,gpu}/Core/`, `gilbreth/external-20250225/`,
  `negishi/cpu/Core/`, `scholar/cpu/Core/` (where `conda` sits today).
- **Pipeline** (`cd tools && make`): `update_apps_inventory.sh` reads every seed `.lua` and each
  `default` symlink (marks `(D)`) → `rcac_apps_inventory.json`; `generate_apps_topics.py` fills
  `apps_topics.json` by heuristics plus explicit overrides; `update_apps_descriptions_from_inventory.sh`
  → `gen_apps_descriptions.py`, which takes `apps_desc_curated.json` first, then Spack, then PyPI;
  `generate_md.sh` writes `docs/software/apps_md/<app>.md`; `update_apps_catalog.sh` updates the
  catalog pages.
- **`Core/*.lua` skip:** the inventory skips `…/Core/<file>.lua`, not `…/Core/uv/<file>.lua`, so
  the uv seeds are read.
- **CI:** `rebuild_on_module_tools_change.yml` runs `make` on any push to `main` touching
  `modulefiles/**` or `tools/**` and commits the generated output as the docs bot.
- **Where to run it:** the scripts need GNU `mktemp --suffix`, `jq`, Python with `requests`, and
  bash 4 or newer (`mapfile`, `declare -A`). macOS ships bash 3.2, so `generate_md.sh` fails there.
  Run `make` on a Linux host (a cluster login node works) from a copy without macOS `._*` files,
  and bring back only the output.
- **What CI commits:** the workflow stages only `docs/software/apps_md`, `app_catalog.md`,
  `index.md`, `apps_descriptions.json` and the NGC/ROCm outputs. The topic catalog pages
  (`*_catalog.md`), `apps_topics.json` and `rcac_apps_inventory.json` are regenerated but never
  committed, so on `main` they lag the seeds. This job commits the same set CI does.
- **Why run it locally too:** the blog post and the cluster pages link `software/apps_md/uv.md`,
  which does not exist until the generator runs. Committing the generator's own output keeps the
  branch's `--strict` build honest (§3 forbids hand edits, not regeneration). CI's later run on
  `main` then reproduces the same files.
- **Description:** add a curated `uv` entry (homepage `https://docs.astral.sh/uv/`); without it the
  PyPI fallback would describe the upstream `uv` package, not the RCAC module.
