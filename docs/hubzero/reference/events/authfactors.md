---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/authfactors.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('authfactors.*') call sites and core/plugins/authfactors/
---

# Authfactors events

Events in the `authfactors` group. A plugin in `core/plugins/authfactors/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `authfactors.onRenderChallenge` { #authfactors-onrenderchallenge }

Fired from:

- [`core/components/com_login/admin/controllers/login.php:180`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_login/admin/controllers/login.php#L180)
- [`core/components/com_login/site/controllers/auth.php:568`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_login/site/controllers/auth.php#L568)
- [`core/components/com_users/site/controllers/auth.php:556`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_users/site/controllers/auth.php#L556)

Listeners:

- `plg_authfactors_certificate` — [`onRenderChallenge()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/authfactors/certificate/certificate.php)
- `plg_authfactors_google` — [`onRenderChallenge()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/authfactors/google/google.php)
