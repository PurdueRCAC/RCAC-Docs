---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/developers/README.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: rewritten
  reviewed-against: 2.4-main @ 348f0057c2
  reviewed: '2026-09-10'
---

# Developers

How to extend the Hubzero CMS: the framework it is built on, and how to
write the components, plugins, modules, and templates that add to a hub.

The CMS is PHP. Its framework lives under `core/libraries/Hubzero/` and
provides the service container, routing, the database layer, events,
sessions, language, and the view layer; extensions live under
`core/components/`, `core/plugins/`, `core/modules/`, and
`core/templates/`, and a hub can override any of them under `app/`.

## What are you building?

Most people arrive here to add one thing to one hub. Find it below and start
there; the chapters assume you will read one of them, not all of them.

| You want to | Write a | Start at |
|---|---|---|
| A section of the hub with its own pages, URLs, database tables and administration screens — a booking system, a catalogue, an instrument log | **component** | [Components](components/index.md) |
| Behaviour that hangs off something that already exists — react to a save, add a tab to a group, add a login method, push records to an external service | **plugin** | [Plugins](plugins/index.md) |
| A small block of content placed in a template position — a list, a counter, a search box | **module** | [Modules](modules/index.md) |
| A different look: an institution's brand, a redesigned page frame, a stylesheet override | **template** | [Templates](templates/index.md) |
| A command run from the shell or a timer — an import, a nightly job, a repair task | **muse command** | [Muse](muse.md#when-to-write-a-command) |
| A machine-readable endpoint for an external client | **API controller** | [The REST API](api.md) |

Whichever it is, three chapters apply to all of them:

- [Extensions](extensions/index.md) — what every extension shares: the
    manifest, parameters, language files, and how it gets deployed.
- [Database](database.md) — the query builder, the ORM, and the
    [migration](database.md#migrations) that creates your tables. Read the
    [table prefix](database.md#the-table-prefix) section before you write a
    query; it is the mistake that works on your hub and fails on everyone
    else's.
- [Conventions](conventions.md) — the style the tree is written in, and
    what a commit message looks like.

## Before you write anything

New to the codebase, read these in order:

1. [Getting started](getting-started/index.md) — getting a hub running to
    develop against.
2. [Foundation](foundation/index.md) — how a request is served, and how
    an extension is found and dispatched.
3. [Services](services/index.md) and [The basics](basics/index.md) —
    the facades you will use in every file: `Config`, `Request`, `Lang`,
    `User`, `Event`.

## In this book

- [Getting started](getting-started/index.md) — development
    environment, browser support, file and database access, release notes.
- [Foundation](foundation/index.md) — the tree, the path constants, how a
    class name becomes a file, the event system, the four extension kinds, the
    facades, and the service providers.
- [Services](services/index.md) — cache, events, filesystem, language,
    server, and session.
- [The basics](basics/index.md) — configuration, requests and
    responses, redirects, dates, users, tags, cron, debugging, search.
- [Database](database.md) — queries, the ORM, and migrations.
- [Extensions](extensions/index.md) — what every extension shares:
    requirements, parameters, languages, deployment.
- [Modules](modules/index.md), [Components](components/index.md),
    [Plugins](plugins/index.md), and [Templates](templates/index.md) —
    one chapter set per kind of extension: structure, controllers, models,
    views, assets, languages, migrations, packaging.
- [Muse](muse.md) — the command-line tool.
- [Super groups](supergroups/index.md) and
    [Super groups with GitLab](supergroups-gitlab.md).
- [Testing](testing.md) — the test suite, the linters, and what CI runs.
- [The REST API](api.md) — the API client, versioned controllers, and
    the docblock tags the endpoint reference is generated from.
- [Running on AWS](aws.md) — what in this repository is specific to it,
    which is very little.
- [Video tutorials](tutorials.md).
- [Contributing](contributing.md) — sending a change back, and working
    on these pages.
- [Conventions](conventions.md) — PHP style and naming, CSS, the
    database schema, and commit messages.

## Reference

The generated [configuration](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/docs/reference/configuration/README.md),
[REST API](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/docs/reference/api/README.md), [muse](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/docs/reference/muse.md),
and [events](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/docs/reference/events/README.md) references list what the code
declares today. They are produced from the source tree, so they say what the
code says rather than what anyone remembers writing.

!!! note
    The muse reference covers the framework's own commands only.
    Commands that ship inside a component are not in it — see
    [Component commands](muse.md#component-commands).
