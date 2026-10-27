---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/developers/03-foundation/README.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: rewritten
  reviewed-against: 2.4-main @ 348f0057c2
  reviewed: '2026-09-10'
  source: https://help.hubzero.org/documentation/240/webdevs/foundation
---

# Foundation

How the framework underneath every extension is put together: what is on
disk, what a request runs through, how your classes are found, how
extensions reach each other, and the handful of names an extension uses
constantly.

Read this section once before you write an extension. Most of what goes
wrong early — a class that will not load, a facade that fatals, a plugin
nothing calls, a directory that is not an extension because no database row
says so — is in here, and none of it is discoverable by reading a component.

## In this section

- [Structure](structure.md) — the directory layout, what belongs in
    `core/` against `app/`, and the request lifecycle end to end.
- [Constants](constants.md) — the paths, the version, and the entry guard.
- [Autoloading](autoloading.md) — how a class name becomes a file, and
    what to check when it does not.
- [Events](events.md) — how extensions reach each other, and why an event
    sometimes reaches nobody.
- [Extensions](extensions.md) — what a component, plugin, module, and
    template are, and how the platform finds them.
- [Facades](facades.md) — the short names for the container's services,
    and the import rule that makes them work. **The one to read.**
- [Service providers](providers.md) — how those services are registered
    and resolved, and how to add one.
