---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/filesystem.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('filesystem.*') call sites and core/plugins/filesystem/
---

# Filesystem events

Events in the `filesystem` group. A plugin in `core/plugins/filesystem/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `filesystem.onAfterSaveFileAttachments` { #filesystem-onaftersavefileattachments }

Fired from:

- [`core/components/com_publications/models/attachments/file.php:1373`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_publications/models/attachments/file.php#L1373) with `[$pub, $configs, $elementId, $element]`

No plugin in the source tree listens for this event.
