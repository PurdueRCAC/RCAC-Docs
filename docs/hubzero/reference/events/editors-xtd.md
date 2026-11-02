---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/editors-xtd.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('editors-xtd.*') call sites and core/plugins/editors-xtd/
---

# Editors-xtd events

Events in the `editors-xtd` group. A plugin in `core/plugins/editors-xtd/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `editors-xtd.onDisplay` { #editors-xtd-ondisplay }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_editors-xtd_article` — [`onDisplay($name)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors-xtd/article/article.php)
- `plg_editors-xtd_image` — [`onDisplay($name, $asset, $author)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors-xtd/image/image.php)
- `plg_editors-xtd_pagebreak` — [`onDisplay($name)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors-xtd/pagebreak/pagebreak.php)
- `plg_editors-xtd_readmore` — [`onDisplay($name)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors-xtd/readmore/readmore.php)
