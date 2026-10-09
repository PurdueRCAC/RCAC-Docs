---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/tools/developers/05-grid/README.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: reviewed
  reviewed-against: 2.4-main @ e097e0236d
  reviewed: '2026-09-10'
  screenshots: none
  source: https://help.hubzero.org/documentation/platform_2_4/tooldevs/grid
  source-id: '3539'
  modified: '2012-09-20'
  imported: '2026-09-09'
---

# Accessing outside computing resources

A tool runs in a tool session on the hub's execution hosts. The session
carries the interface the user works in. Light calculations run in the
session itself; heavier ones are sent to a cluster or a national resource
with the `submit` command, which keeps the session responsive and returns
the results when the job finishes.

!!! note
    `submit` is part of the tool execution platform, which is
    separate software and is **not in this repository**. Nothing on these
    pages could be checked against the code here, and the CMS holds no trace
    of the command — the only mention left in `com_tools` is
    [a migration that dropped an old `submit` sessions table](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_tools/migrations/Migration20180702134743ComToolsRemoveSubmitSessions.php).
    The material is kept as the written record, corrected where it
    contradicted itself, and `submit --help` on your own hub is the
    authority on what your client accepts.

## The pages here

Most tools reach `submit` from a Jupyter notebook now, so
[Submitting from a Jupyter notebook](jupyter-submit.md) is the page to
read if you are writing a new tool; the submit command reference below
explains what the options it sets actually do.

- [Submit command](submitcmd.md) — what `submit` does, its options, and
    the parameter sweep syntax. Start here whichever way you call it.
- [Submitting from a Jupyter notebook](jupyter-submit.md) — calling
    `submit` from a cell, and the `SubmitCommand` class from the
    `hubzero.submit` library.
- [Pegasus workflow submission](pegasuswf.md) — running a workflow you
    built yourself, rather than a sweep `submit` generates for you.
- [Submitting from a Rappture tool](rappture-submit.md) — kept for hubs
    that still run Rappture tools. Rappture is deprecated; do not start a new
    tool with it.

Related reading: [Jupyter notebooks as tools](../jupyter-notebooks/index.md)
for publishing a notebook in the first place, and
[registering a tool](../../../managers/maintenance/tools.md) for the
publishing option that marks a tool as a web application.
