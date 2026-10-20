---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/mail.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('mail.*') call sites and core/plugins/mail/
---

# Mail events

Events in the `mail` group. A plugin in `core/plugins/mail/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `mail.onMailersRegister` { #mail-onmailersregister }

Fired from:

- [`core/bootstrap/Administrator/Providers/MailerServiceProvider.php:40`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/bootstrap/Administrator/Providers/MailerServiceProvider.php#L40)
- [`core/bootstrap/Site/Providers/MailerServiceProvider.php:40`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/bootstrap/Site/Providers/MailerServiceProvider.php#L40)

No plugin in the source tree listens for this event.
