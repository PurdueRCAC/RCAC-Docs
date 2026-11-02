---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/cron.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('cron.*') call sites and core/plugins/cron/
---

# Cron events

Events in the `cron` group. A plugin in `core/plugins/cron/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `cron.onClosePending` { #cron-onclosepending }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_cron_support` — [`onClosePending(\Components\Cron\Models\Job $job)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/cron/support/support.php)

## `cron.onCronEvents` { #cron-oncronevents }

Fired from:

- [`core/components/com_cron/admin/controllers/jobs.php:145`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_cron/admin/controllers/jobs.php#L145)

Listeners:

- `plg_cron_activity` — [`onCronEvents()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/cron/activity/activity.php)
- `plg_cron_cache` — [`onCronEvents()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/cron/cache/cache.php)
- `plg_cron_courses` — [`onCronEvents()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/cron/courses/courses.php)
- `plg_cron_forum` — [`onCronEvents()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/cron/forum/forum.php)
- `plg_cron_groups` — [`onCronEvents()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/cron/groups/groups.php)
- `plg_cron_members` — [`onCronEvents()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/cron/members/members.php)
- `plg_cron_newsletter` — [`onCronEvents()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/cron/newsletter/newsletter.php)
- `plg_cron_projects` — [`onCronEvents()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/cron/projects/projects.php)
- `plg_cron_publications` — [`onCronEvents()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/cron/publications/publications.php)
- `plg_cron_resources` — [`onCronEvents()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/cron/resources/resources.php)
- `plg_cron_search` — [`onCronEvents()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/cron/search/search.php)
- `plg_cron_storefront` — [`onCronEvents()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/cron/storefront/storefront.php)
- `plg_cron_support` — [`onCronEvents()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/cron/support/support.php)
- `plg_cron_users` — [`onCronEvents()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/cron/users/users.php)

## `cron.onPointRoyalties` { #cron-onpointroyalties }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_cron_members` — [`onPointRoyalties(\Components\Cron\Models\Job $job)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/cron/members/members.php)
