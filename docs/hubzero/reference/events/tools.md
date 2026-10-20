---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/tools.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('tools.*') call sites and core/plugins/tools/
---

# Tools events

Events in the `tools` group. A plugin in `core/plugins/tools/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `tools.onToolSessionIdentify` { #tools-ontoolsessionidentify }

Fired from:

- [`core/components/com_tools/site/views/sessions/tmpl/session.php:49`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_tools/site/views/sessions/tmpl/session.php#L49)

Listeners:

- `plg_tools_novnc` — [`onToolSessionIdentify()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/tools/novnc/novnc.php)

## `tools.onToolSessionView` { #tools-ontoolsessionview }

Fired from:

- [`core/components/com_tools/site/views/sessions/tmpl/session.php:48`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_tools/site/views/sessions/tmpl/session.php#L48) with `[$this->app, $this->output, $readOnly]`

Listeners:

- `plg_tools_novnc` — [`onToolSessionView($tool, $session, $readOnly=false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/tools/novnc/novnc.php)

## `tools.onToolSessionViewAfter` { #tools-ontoolsessionviewafter }

Fired from:

- [`core/components/com_tools/site/views/sessions/tmpl/session.php:227`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_tools/site/views/sessions/tmpl/session.php#L227) with `[$this->app, $this->output, $readOnly)]`

No plugin in the source tree listens for this event.

## `tools.onToolSessionViewBefore` { #tools-ontoolsessionviewbefore }

Fired from:

- [`core/components/com_tools/site/views/sessions/tmpl/session.php:67`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_tools/site/views/sessions/tmpl/session.php#L67) with `[$this->app, $this->output, $readOnly)]`

No plugin in the source tree listens for this event.
