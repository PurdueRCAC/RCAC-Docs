---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/tools/developers/README.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: rewritten
  reviewed-against: 2.4-main @ e097e0236d
  reviewed: '2026-09-10'
  screenshots: none
  source: https://help.hubzero.org/documentation/platform_2_4/tooldevs
  source-id: '3534'
  modified: '2025-01-31'
  imported: '2026-09-09'
---

# Tool developers

How to write a program that runs on a hub's execution hosts and appears in a
member's browser, and how to get it from a registration form to a published
resource page.

!!! important
    Two pieces of software are involved and only one of them is
    in this repository. The CMS here holds the contribution pipeline, the tool
    pages, and the session screens. The execution hosts, the middleware that
    starts sessions, the container images, the shared file system, the
    `invoke_app` and `submit` clients and the Rappture toolkit are the tool
    platform, which is installed alongside a hub and is separate software. Most
    of what these pages describe happens on the platform and could not be
    checked here. Every page says at the top which of its material was verified
    against the CMS and which was carried over from help.hubzero.org unchecked.

## Where to start

| Page | What it covers |
|---|---|
| [Prerequisites](prerequisites.md) | What a tool session is and the environment your tool runs in |
| [The contribution process](process.md) | The nine states a tool passes through, from the developer's side |
| [What you can publish as a tool](overview.md) | The kinds of program a hub can run: Linux GUI, Jupyter, Sim2L, R/Shiny, Dash, web application |
| [Tool repository structure](toolrepostructure.md) | The directory layout the hub expects, and starter invoke scripts |
| [Launching tools with invoke scripts](invoke.md) | The invoke script, its options, and what the CMS hands it |
| [Combining tools in one session](nanowhim.md) | Running several applications on one session desktop |
| [Accessing outside computing resources](grid/index.md) | Sending work from a session to a cluster with `submit` |
| [Accessing your home directory](accesshomedir.md) | `sftp`, WebDAV, and `filexfer` |
| [Tool paths](toolpaths/index.md) | Environment variables and where a tool reads and writes files |
| [Importing and exporting user files](fileinout.md) | `importfile` and `exportfile` |
| [Large data paths](largedatapaths.md) | Storage for data too big for a home directory |
| [Jupyter notebooks](jupyter-notebooks/index.md) | Publishing a notebook as a tool |

## The other two sides

- Hub managers run the pipeline: [Tools](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/docs/managers/03-maintenance/02-tools.md)
    walks the states from the administrator's side and lists every field on the
    registration form.
- Hub members run the result: [Tools](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/docs/users/22-tools.md) describes a
    tool session as the user sees it.
- Hub administrators configure the platform:
    [Tool administrators](../administrators.md).

## Background material

These recorded seminars are hosted on nanoHUB. They are the original source
for much of this book and are still online, though they predate the Git and
Jupyter options in the current registration form.

- [Bootcamp course for new developers](https://nanohub.org/resources/14671)
- [Overview of the tool development process](https://nanohub.org/resources/14668)
- [Using workspaces](https://nanohub.org/resources/3081)
- [Using Subversion for source code control](https://nanohub.org/resources/14669)
