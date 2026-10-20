---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/newsletter.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('newsletter.*') call sites and core/plugins/newsletter/
---

# Newsletter events

Events in the `newsletter` group. A plugin in `core/plugins/newsletter/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `newsletter.onGetEnabledDigests` { #newsletter-ongetenableddigests }

Fired from:

- [`core/components/com_newsletter/admin/controllers/stories.php:148`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_newsletter/admin/controllers/stories.php#L148)
- [`core/components/com_newsletter/models/newsletter.php:451`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_newsletter/models/newsletter.php#L451)

Listeners:

- `plg_newsletter_event` — [`onGetEnabledDigests()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/newsletter/event/event.php)
- `plg_newsletter_jobs` — [`onGetEnabledDigests()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/newsletter/jobs/jobs.php)
- `plg_newsletter_resource` — [`onGetEnabledDigests()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/newsletter/resource/resource.php)

## `newsletter.onGetLatest` { #newsletter-ongetlatest }

Fired from:

- [`core/components/com_newsletter/admin/controllers/stories.php:156`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_newsletter/admin/controllers/stories.php#L156) with `[$itemCount]`
- [`core/components/com_newsletter/models/newsletter.php:457`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_newsletter/models/newsletter.php#L457) with `[$parts[2]))[$key]; // Apply the view template $view = new \Hubzero\Component\View(array(]`

Listeners:

- `plg_newsletter_event` — [`onGetLatest($num = 5, $dateField = 'created', $sort = 'DESC')`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/newsletter/event/event.php)
- `plg_newsletter_jobs` — [`onGetLatest($num = 5, $dateField = 'created', $sort = 'DESC')`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/newsletter/jobs/jobs.php)
- `plg_newsletter_resource` — [`onGetLatest($num = 5, $dateField = 'created', $sort = 'DESC')`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/newsletter/resource/resource.php)
