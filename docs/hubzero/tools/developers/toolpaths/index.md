---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/tools/developers/07-toolpaths/README.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: reviewed
  reviewed-against: 2.4-main @ e097e0236d
  reviewed: '2026-09-10'
  screenshots: none
  source: https://help.hubzero.org/documentation/platform_2_4/tooldevs/toolpaths
  source-id: '3548'
  modified: '2015-02-18'
  imported: '2026-09-09'
---

# Tool paths

A tool has to know where to find its example files, where to put the files it
generates while it runs, and where to leave results the user will want later.
This section answers those questions.

!!! note
    The directories and environment variables described here are set up
    by the tool platform, which is separate software and is not in this
    repository, so they could not be checked against code. The one part that is
    CMS-side — the whitelist that decides which directories a launch URL may name
    — is covered in
    [Directory parameter whitelist](../../administrators.md#directory-parameter-whitelist)
    and was checked.

- [Environment variables](toolenvvars.md) — what a session tells the tool
    about itself.
- [Passing path variables with the invoke script](toolpathsinvoke.md) — how
    the tool learns where its own repository is.
- [Example files](toolpathexamples.md) — where to keep the inputs you ship.
- [Tool generated files](toolpathsresults.md) — where temporary files and
    results belong.

For datasets too large to live near the tool, see
[Large data paths](../largedatapaths.md).
