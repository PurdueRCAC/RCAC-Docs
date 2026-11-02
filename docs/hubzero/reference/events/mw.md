---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/mw.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('mw.*') call sites and core/plugins/mw/
---

# Mw events

Events in the `mw` group. A plugin in `core/plugins/mw/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `mw.onAfterSessionInvoke` { #mw-onaftersessioninvoke }

Fired from:

- [`core/components/com_tools/api/controllers/sessionsv1_0.php:750`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_tools/api/controllers/sessionsv1_0.php#L750) with `[$app->toolname, $app->version]`
- [`core/components/com_tools/site/controllers/sessions.php:674`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_tools/site/controllers/sessions.php#L674) with `[$app->toolname, $app->version]`

No plugin in the source tree listens for this event.

## `mw.onAfterSessionStart` { #mw-onaftersessionstart }

Fired from:

- [`core/components/com_tools/api/controllers/sessionsv1_0.php:1288`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_tools/api/controllers/sessionsv1_0.php#L1288) with `[$toolname, $tv->revision]`
- [`core/components/com_tools/site/controllers/sessions.php:1391`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_tools/site/controllers/sessions.php#L1391) with `[$toolname, $tv->revision]`

No plugin in the source tree listens for this event.

## `mw.onAfterSessionStop` { #mw-onaftersessionstop }

Fired from:

- [`core/components/com_tools/admin/controllers/sessions.php:176`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_tools/admin/controllers/sessions.php#L176) with `[$row->appname]`
- [`core/components/com_tools/api/controllers/sessionsv1_0.php:1355`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_tools/api/controllers/sessionsv1_0.php#L1355) with `[$ms->get('appname')]`
- [`core/components/com_tools/site/controllers/sessions.php:1532`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_tools/site/controllers/sessions.php#L1532) with `[$ms->appname]`

No plugin in the source tree listens for this event.

## `mw.onBeforeSessionInvoke` { #mw-onbeforesessioninvoke }

Fired from:

- [`core/components/com_tools/api/controllers/sessionsv1_0.php:729`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_tools/api/controllers/sessionsv1_0.php#L729) with `[$app->toolname, $app->version]`
- [`core/components/com_tools/site/controllers/sessions.php:625`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_tools/site/controllers/sessions.php#L625) with `[$app->toolname, $app->version]`

No plugin in the source tree listens for this event.

## `mw.onBeforeSessionStart` { #mw-onbeforesessionstart }

Fired from:

- [`core/components/com_tools/api/controllers/sessionsv1_0.php:1274`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_tools/api/controllers/sessionsv1_0.php#L1274) with `[$toolname, $tv->revision]`
- [`core/components/com_tools/site/controllers/sessions.php:1193`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_tools/site/controllers/sessions.php#L1193) with `[$toolname, $tv->revision]`

No plugin in the source tree listens for this event.

## `mw.onBeforeSessionStop` { #mw-onbeforesessionstop }

Fired from:

- [`core/components/com_tools/admin/controllers/sessions.php:159`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_tools/admin/controllers/sessions.php#L159) with `[$row->appname]`
- [`core/components/com_tools/api/controllers/sessionsv1_0.php:1349`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_tools/api/controllers/sessionsv1_0.php#L1349) with `[$ms->get('appname')]`
- [`core/components/com_tools/site/controllers/sessions.php:1517`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_tools/site/controllers/sessions.php#L1517) with `[$ms->appname]`

No plugin in the source tree listens for this event.

## `mw.onSessionView` { #mw-onsessionview }

Fired from:

- [`core/components/com_tools/site/views/sessions/tmpl/session.php:381`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_tools/site/views/sessions/tmpl/session.php#L381) with `[ $this->option, $this->toolname, $this->app->sess ]`

No plugin in the source tree listens for this event.
