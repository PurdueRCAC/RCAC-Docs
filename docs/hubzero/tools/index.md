---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/tools/README.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: draft
---

# Tools

A **tool** is a simulation or analysis program that runs in a session on
the hub's execution hosts and is displayed in the member's browser, so a
member runs it without installing anything. Tools are developed in a
repository, built and tested through the contribution pipeline, and
published as resources alongside datasets and presentations.

This book covers the three sides of that platform.

- [Tool developers](developers/index.md) — structuring a tool repository,
    invoke scripts, tool paths and environment variables, file transfer,
    the submit command for remote jobs, and Jupyter notebooks as tools.
- [Tool administrators](administrators.md) — installing tool
    dependencies, whitelisting directories, and administering Jupyter.
- [Tool users](users/index.md) — running tools, what the usage figures
    mean, and the simulation usage definitions.

!!! note
    The tool execution platform is separate software from the
    Hubzero CMS in this repository, so most of what these pages describe
    cannot be checked against the code here. Each page says at the top which
    of its material was verified against the CMS and which is platform
    material carried over from help.hubzero.org unchecked. The administrator
    pages have been through that pass; the developer and user pages carry
    their import banner until they have.
