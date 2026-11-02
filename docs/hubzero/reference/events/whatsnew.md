---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/whatsnew.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('whatsnew.*') call sites and core/plugins/whatsnew/
---

# Whatsnew events

Events in the `whatsnew` group. A plugin in `core/plugins/whatsnew/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `whatsnew.onWhatsNewAreas` { #whatsnew-onwhatsnewareas }

Fired from:

- [`core/components/com_whatsnew/api/controllers/entriesv1_0.php:79`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_whatsnew/api/controllers/entriesv1_0.php#L79)
- [`core/components/com_whatsnew/helpers/finder.php:32`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_whatsnew/helpers/finder.php#L32)

No plugin in the source tree listens for this event.

## `whatsnew.onWhatsnew` { #whatsnew-onwhatsnew }

Fired from:

- [`core/components/com_whatsnew/api/controllers/entriesv1_0.php:105`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_whatsnew/api/controllers/entriesv1_0.php#L105) with `[ $p, 999, 0, $areas ]`
- [`core/components/com_whatsnew/site/controllers/results.php:121`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_whatsnew/site/controllers/results.php#L121) with `[ $p, 0, 0, $activeareas ]`
- [`core/components/com_whatsnew/site/controllers/results.php:134`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_whatsnew/site/controllers/results.php#L134) with `[ $p, $limit, $start, $activeareas ]`
- [`core/components/com_whatsnew/site/controllers/results.php:333`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_whatsnew/site/controllers/results.php#L333) with `[ $p, $limit, $start, $activeareas ]`
- [`core/modules/mod_whatsnew/helper.php:179`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/modules/mod_whatsnew/helper.php#L179) with `[ $p, $count, 0, $activeareas, array() ]`

Listeners:

- `plg_whatsnew_content` — [`onWhatsnew($period, $limit=0, $limitstart=0, $areas=null, $tagids=array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/whatsnew/content/content.php)
- `plg_whatsnew_events` — [`onWhatsnew($period, $limit=0, $limitstart=0, $areas=null, $tagids=array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/whatsnew/events/events.php)
- `plg_whatsnew_kb` — [`onWhatsnew($period, $limit=0, $limitstart=0, $areas=null, $tagids=array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/whatsnew/kb/kb.php)
- `plg_whatsnew_publications` — [`onWhatsnew($period, $limit=0, $limitstart=0, $areas=null, $tagids=array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/whatsnew/publications/publications.php)
- `plg_whatsnew_resources` — [`onWhatsnew($period, $limit=0, $limitstart=0, $areas=null, $tagids=array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/whatsnew/resources/resources.php)
- `plg_whatsnew_wiki` — [`onWhatsnew($period, $limit=0, $limitstart=0, $areas=null, $tagids=array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/whatsnew/wiki/wiki.php)

## `whatsnew.onWhatsnewAreas` { #whatsnew-onwhatsnewareas-2 }

Fired from:

- [`core/components/com_whatsnew/site/controllers/results.php:480`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_whatsnew/site/controllers/results.php#L480)
- [`core/modules/mod_whatsnew/helper.php:38`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/modules/mod_whatsnew/helper.php#L38)

Listeners:

- `plg_whatsnew_content` — [`onWhatsnewAreas()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/whatsnew/content/content.php)
- `plg_whatsnew_events` — [`onWhatsnewAreas()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/whatsnew/events/events.php)
- `plg_whatsnew_kb` — [`onWhatsnewAreas()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/whatsnew/kb/kb.php)
- `plg_whatsnew_publications` — [`onWhatsnewAreas()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/whatsnew/publications/publications.php)
- `plg_whatsnew_resources` — [`onWhatsnewAreas()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/whatsnew/resources/resources.php)
- `plg_whatsnew_wiki` — [`onWhatsnewAreas()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/whatsnew/wiki/wiki.php)
