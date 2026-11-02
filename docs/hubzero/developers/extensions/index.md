---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/developers/07-extensions/README.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: rewritten
  reviewed-against: 2.4-main @ 348f0057c2
  reviewed: '2026-09-10'
  screenshots: none
  source: https://help.hubzero.org/documentation/240/webdevs/extensions
  source-id: '3466'
  modified: '2017-04-17'
  imported: '2026-09-09'
---

# Extensions

Everything a hub does beyond serving a request is an extension. The CMS
itself is a thin application that boots a container, works out which
component owns the URL, and asks a template to draw the result; the features
— resources, groups, projects, publications, the wiki — are components,
plugins, modules and templates sitting on top of it.

This section covers what all four kinds have in common: what a package must
contain, how parameters are declared, how strings are translated, and how
code gets onto a running hub. Each kind then has its own chapter set —
[Components](../components/index.md), [Plugins](../plugins/index.md),
[Modules](../modules/index.md), [Templates](../templates/index.md) — for
the parts that differ.

Read this section once before you start, and the four rules it establishes
will save you the four days they otherwise cost: an extension is a row in a
table, that row comes from a migration, every facade must be imported, and
every visible string comes from a language file whose client you have to get
right.

## Which kind do you want

Decide by asking what owns the page.

| The thing you are adding | Kind | Because |
|---|---|---|
| A screen with records behind it — booking a lab's instruments | Component | it owns the URL and the request |
| A reaction to something happening — mirroring a publication to an external service when it is saved | Plugin | it owns no page and answers events |
| A block that appears beside other people's pages — the instruments free right now | Module | it renders into a template position |
| A different look for a partner institution | Template | it is the page around everything else |

Pick wrong and you fight the framework. A component that only ever renders a
sidebar box competes for a URL it never uses; a plugin that wants a settings
screen of its own is a component with the wrong base class.

The worked example carried through the component chapters — `com_bookings`,
which books a lab's instruments — is referred to here too, along with the
`bookings` plugin group it triggers.

## The four kinds

| Kind | Lives in | Owns | Registered as |
|---|---|---|---|
| Component | `components/com_{name}` | The page's main content, one per request | `type = 'component'` |
| Plugin | `plugins/{group}/{name}` | A response to an event | `type = 'plugin'`, `folder = '{group}'` |
| Module | `modules/mod_{name}` | A block in a template position | `type = 'module'` |
| Template | `templates/{name}` | The page around the component | `type = 'template'` |

### Components

A component is an application in its own right: its own controllers, models,
database tables, routes, views and administrative interface. Exactly one
component handles each request — the one named by `option` in the URL, which
the router derives from the menu item — and it renders into the template's
main content area. A menu is, in effect, a switch between components.

A component is the only kind with three faces: `site/` for hub visitors,
`admin/` for the administrator interface, and `api/` for the REST API. See
[Components](../components/index.md).

### Plugins

A plugin answers events. It declares no routes and owns no page; instead its
public methods are named after events — `onAfterRoute`, `onContentPrepare`,
`onGroupView` — and the dispatcher calls them when something triggers one.
Plugins are grouped by the kind of thing they extend, and the group is the
directory: `plugins/authentication/`, `plugins/content/`,
`plugins/members/`. Most of the CMS's pluggable behaviour — the tabs on a
group page, the login methods, the cron jobs — is a plugin group. The
[events reference](../../reference/events/index.md) lists what the tree
triggers. See [Plugins](../plugins/index.md).

### Modules

A module renders a small block of HTML into a named position in the
template: a login form, a breadcrumb trail, a list of recent entries. It
never owns the request. The same module can be published in different
positions on different templates and appear several times with different
parameters. See [Modules](../modules/index.md).

### Templates

A template is the page around whatever the component produced — the markup,
the CSS, the positions modules render into, and the error and offline pages.
The templates that ship are in `core/templates`: `kimera` for the site,
`kameleon` for the administrator interface, plus `system`, `lucent` and
`welcome`. See [Templates](../templates/index.md).

!!! note
    The old version of this page listed languages as a fifth
    extension type. A language pack is a set of INI files and an XML metadata
    file, not code, and Hubzero ships only `en-GB`. Translating is covered in
    [Languages](languages.md).

## Where extensions live

Two trees hold the same shapes:

| Tree | What is in it |
|---|---|
| `core/` | The extensions the release ships. Updated wholesale by an upgrade. |
| `app/` | This hub's own extensions, and its overrides of core ones. Not in the repository. |

The loaders check `app/` before `core/` and use the first directory they
find, so a hub replaces a core extension by putting a directory of the same
name under `app/`. That is an all-or-nothing replacement: once
`app/components/com_blog` exists, nothing under `core/components/com_blog`
is used. To change a few files rather than a component, use a
[template override](../templates/overrides.md) instead.

The class loader,
[`Hubzero\Base\ClassLoader`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/Base/ClassLoader.php),
follows the same rule for classes: `Components\Blog\Models\Entry` is looked
for under `app/components/com_blog` first, then `core/components/com_blog`.
Composer's PSR-4 map covers only the `Hubzero\` and `Bootstrap\` namespaces;
every extension class comes through this loader.

## How an extension is found

Nothing scans the filesystem. Every extension has a row in the
`#__extensions` table, and that row — not the directory — is what the
loaders read. The row also holds the extension's parameters, in its `params`
column.

What a missing row costs depends on the kind, and only one of the four fails
loudly:

| Kind | With the directory but no row |
|---|---|
| Component | **still runs.** `Hubzero\Component\Loader::load()` manufactures a default record with `enabled` set to 1 when the query finds nothing. What is lost is everything stored against the row: the administrator's Components menu, the parameters, the permissions asset. |
| Plugin | never loads. The plugin loader selects rows `WHERE type = 'plugin' AND enabled >= 1`; no row, no listener, and the event fires into nothing. |
| Module | cannot be published. The row registers the module *type*; an administrator creates instances from it. |
| Template | cannot be assigned to the site or the administrator. |

A component that exists on disk and is invisible in the administrator
interface is the single most common symptom of a missed migration, and it is
confusing precisely because the component's own pages work.

An extension creates its own row from a
[migration](../database.md#migrations), by calling `addComponentEntry()`,
`addPluginEntry()`, `addModuleEntry()` or `addTemplateEntry()`. Nothing else
creates it: there is no package installer that reads a manifest and does it
for you. See [Deploying extensions](deployext.md).

[Extensions](../foundation/extensions.md) in the Foundation section covers
each loader in detail; [Requirements](extreqs.md) covers what else a
package must carry.

## In this section

- [Requirements](extreqs.md) — what an extension package has to contain
    before the platform will load it.
- [Parameters](parameters.md) — declaring the settings an administrator
    edits, and the field types available.
- [Languages](languages.md) — where an extension's strings go, and how
    they are named.
- [Deploying extensions](deployext.md) — installing code on a running
    hub.
