---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/usage.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('usage.*') call sites and core/plugins/usage/
---

# Usage events

Events in the `usage` group. A plugin in `core/plugins/usage/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `usage.onUsageAreas` { #usage-onusageareas }

Fired from:

- [`core/components/com_usage/site/controllers/results.php:76`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_usage/site/controllers/results.php#L76)

Listeners:

- `plg_usage_domainclass` — [`onUsageAreas()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/usage/domainclass/domainclass.php)
- `plg_usage_domains` — [`onUsageAreas()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/usage/domains/domains.php)
- `plg_usage_maps` — [`onUsageAreas()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/usage/maps/maps.php)
- `plg_usage_overview` — [`onUsageAreas()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/usage/overview/overview.php)
- `plg_usage_partners` — [`onUsageAreas()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/usage/partners/partners.php)
- `plg_usage_region` — [`onUsageAreas()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/usage/region/region.php)
- `plg_usage_tools` — [`onUsageAreas()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/usage/tools/tools.php)

## `usage.onUsageDisplay` { #usage-onusagedisplay }

Fired from:

- [`core/components/com_usage/site/controllers/results.php:105`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_usage/site/controllers/results.php#L105) with `[ $this->_option, $this->_task, $udb, $months, $monthsReverse, $enddate ]`

Listeners:

- `plg_usage_domainclass` — [`onUsageDisplay($option, $task, $db, $months, $monthsReverse, $enddate)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/usage/domainclass/domainclass.php)
- `plg_usage_domains` — [`onUsageDisplay($option, $task, $db, $months, $monthsReverse, $enddate)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/usage/domains/domains.php)
- `plg_usage_maps` — [`onUsageDisplay($option, $task, $db, $months, $monthsReverse, $enddate)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/usage/maps/maps.php)
- `plg_usage_overview` — [`onUsageDisplay($option, $task, $db, $months, $monthsReverse, $enddate)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/usage/overview/overview.php)
- `plg_usage_partners` — [`onUsageDisplay($option, $task, $db, $months, $monthsReverse, $enddate)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/usage/partners/partners.php)
- `plg_usage_region` — [`onUsageDisplay($option, $task, $db, $months, $monthsReverse, $enddate)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/usage/region/region.php)
- `plg_usage_tools` — [`onUsageDisplay($option, $task, $db, $months, $monthsReverse, $enddate)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/usage/tools/tools.php)
