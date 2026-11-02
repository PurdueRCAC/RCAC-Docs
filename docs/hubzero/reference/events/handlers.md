---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/handlers.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('handlers.*') call sites and core/plugins/handlers/
---

# Handlers events

Events in the `handlers` group. A plugin in `core/plugins/handlers/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `handlers.onHandleView` { #handlers-onhandleview }

Fired from:

- [`core/plugins/projects/files/connections.php:1640`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/files/connections.php#L1640) with `[$items]`

Listeners:

- `plg_handlers_audio` — [`onHandleView(Hubzero\Filesystem\Collection $collection)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/handlers/audio/audio.php)
- `plg_handlers_hubpresenter` — [`onHandleView(\Hubzero\Filesystem\Collection $collection, $entityId = null, $entityType = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/handlers/hubpresenter/hubpresenter.php)
- `plg_handlers_ipynb` — [`onHandleView(Hubzero\Filesystem\Collection $collection)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/handlers/ipynb/ipynb.php)
- `plg_handlers_latex` — [`onHandleView(\Hubzero\Filesystem\Collection $collection)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/handlers/latex/latex.php)
- `plg_handlers_markdown` — [`onHandleView(Hubzero\Filesystem\Collection $collection)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/handlers/markdown/markdown.php)
- `plg_handlers_pdf` — [`onHandleView(\Hubzero\Filesystem\Collection $collection)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/handlers/pdf/pdf.php)
- `plg_handlers_script` — [`onHandleView(Hubzero\Filesystem\Collection $collection)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/handlers/script/script.php)
- `plg_handlers_video` — [`onHandleView(Hubzero\Filesystem\Collection $collection)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/handlers/video/video.php)
