---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/oaipmh.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('oaipmh.*') call sites and core/plugins/oaipmh/
---

# Oaipmh events

Events in the `oaipmh` group. A plugin in `core/plugins/oaipmh/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `oaipmh.onOaipmhProvider` { #oaipmh-onoaipmhprovider }

Fired from:

- [`core/components/com_oaipmh/models/service.php:246`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_oaipmh/models/service.php#L246) with `[&$this]`

Listeners:

- `plg_oaipmh_publications` — [`onOaipmhProvider(&$service)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/oaipmh/publications/publications.php)
- `plg_oaipmh_resources` — [`onOaipmhProvider(&$service)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/oaipmh/resources/resources.php)
