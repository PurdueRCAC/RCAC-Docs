---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/antispam.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('antispam.*') call sites and core/plugins/antispam/
---

# Antispam events

Events in the `antispam` group. A plugin in `core/plugins/antispam/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `antispam.onAntispamDetector` { #antispam-onantispamdetector }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_antispam_akismet` — [`onAntispamDetector()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/antispam/akismet/akismet.php)
- `plg_antispam_babajispam` — [`onAntispamDetector()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/antispam/babajispam/babajispam.php)
- `plg_antispam_bayesian` — [`onAntispamDetector()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/antispam/bayesian/bayesian.php)
- `plg_antispam_blacklist` — [`onAntispamDetector()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/antispam/blacklist/blacklist.php)
- `plg_antispam_linkrife` — [`onAntispamDetector()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/antispam/linkrife/linkrife.php)
- `plg_antispam_spamassassin` — [`onAntispamDetector()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/antispam/spamassassin/spamassassin.php)

## `antispam.onAntispamTrain` { #antispam-onantispamtrain }

Fired from:

- [`core/components/com_support/admin/controllers/abusereports.php:293`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_support/admin/controllers/abusereports.php#L293) with `[ $reported->text, $isSpam ]`
- [`core/plugins/content/antispam/antispam.php:124`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/content/antispam/antispam.php#L124) with `[ $content, true ]`
- [`core/plugins/content/antispam/antispam.php:151`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/content/antispam/antispam.php#L151) with `[ $content, false ]`

Listeners:

- `plg_antispam_akismet` — [`onAntispamTrain($content, $isSpam)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/antispam/akismet/akismet.php)
- `plg_antispam_bayesian` — [`onAntispamTrain($content, $isSpam)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/antispam/bayesian/bayesian.php)
- `plg_antispam_spamassassin` — [`onAntispamTrain($content, $isSpam)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/antispam/spamassassin/spamassassin.php)
