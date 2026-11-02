---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/update.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('update.*') call sites and core/plugins/update/
---

# Update events

Events in the `update` group. A plugin in `core/plugins/update/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `update.onAfterRepositoryUpdate` { #update-onafterrepositoryupdate }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_update_cache` — [`onAfterRepositoryUpdate()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/update/cache/cache.php)
- `plg_update_support` — [`onAfterRepositoryUpdate()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/update/support/support.php)
