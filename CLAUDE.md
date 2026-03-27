# Project Rules

## Zensical Conda Environment

**Never modify any files inside the `zensical` conda environment** (e.g., `/home/jin456/.conda/envs/zensical/`).

This includes package source files such as `zensical/markdown.py` or any other installed library. If a bug in Zensical requires a workaround, find a solution within the project files (docs, overrides, zensical.toml, CSS, JS) instead.

## Prefer Zensical Native Features

**Always check Zensical's native capabilities first** before adding custom JS, CSS overrides, or other workarounds. For example, use frontmatter options like `hide: [toc]`, `hide: [navigation]`, or other built-in config before reaching for JavaScript solutions. Only add custom code when Zensical has no native equivalent.
