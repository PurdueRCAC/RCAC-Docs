# 04 — Blog post archetype

- Location `docs/blog/posts/<name>.md`; picked up by the blog plugin, no `nav:` entry.
- Front-matter: `date: {created: YYYY-MM-DD}`, `categories:` from `Announcements, Anvil, Gautschi,
  Software, Slurm, Workflows, Life Sciences`, `title`, `slug`, `tags`, `authors: [glentner]`, and a
  `<!-- more -->` marker after the excerpt.
- Model: `conda_anaconda.md` (2025-09-24, authors verburgt + glentner): H1, short intro, `<!-- more -->`,
  H2 sections, an HTML table with `scope` headers, a closing recommendation. Its "Which One Should
  You Use?" recommends the `conda` module; the new post links to it rather than repeating it.
- Author entry `glentner` in `docs/blog/.authors.yml` has `description: Lead Research Data
  Scientist`; R10 changes it to "Principal AI Scientist".
- Links from a post to guides are relative to `docs/blog/posts/` (`../../userguides/…`).
