---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/activity.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('activity.*') call sites and core/plugins/activity/
---

# Activity events

Events in the `activity` group. A plugin in `core/plugins/activity/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `activity.onLogDelete` { #activity-onlogdelete }

Fired from:

- [`core/libraries/Hubzero/Activity/Log.php:180`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/Activity/Log.php#L180) with `[$this]`

No plugin in the source tree listens for this event.

## `activity.onLogSave` { #activity-onlogsave }

Fired from:

- [`core/libraries/Hubzero/Activity/Log.php:209`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/Activity/Log.php#L209) with `[$this, $isNew]`

No plugin in the source tree listens for this event.
