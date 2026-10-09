---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/extension.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('extension.*') call sites and core/plugins/extension/
---

# Extension events

Events in the `extension` group. A plugin in `core/plugins/extension/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `extension.onExtensionAfterDelete` { #extension-onextensionafterdelete }

Fired from:

- [`core/components/com_modules/admin/controllers/modules.php:814`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_modules/admin/controllers/modules.php#L814) with `['com_modules.module', $model->getTableName()]`

No plugin in the source tree listens for this event.

## `extension.onExtensionAfterSave` { #extension-onextensionaftersave }

Fired from:

- [`core/components/com_modules/admin/controllers/modules.php:452`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_modules/admin/controllers/modules.php#L452) with `[$this->_option . '.module', &$model, $model->isNew()]`
- [`core/components/com_templates/admin/controllers/styles.php:344`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_templates/admin/controllers/styles.php#L344) with `['com_templates.style', $style, ($fields['id'] ? false : true)]`
- [`core/components/com_templates/models/file.php:161`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_templates/models/file.php#L161) with `['com_templates.source', &$table, false]`
- [`core/components/com_templates/models/source.php:166`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_templates/models/source.php#L166) with `['com_templates.source', &$table, false]`

No plugin in the source tree listens for this event.

## `extension.onExtensionBeforeDelete` { #extension-onextensionbeforedelete }

Fired from:

- [`core/components/com_modules/admin/controllers/modules.php:804`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_modules/admin/controllers/modules.php#L804) with `['com_modules.module', $model->getTableName()]`

No plugin in the source tree listens for this event.

## `extension.onExtensionBeforeSave` { #extension-onextensionbeforesave }

Fired from:

- [`core/components/com_modules/admin/controllers/modules.php:425`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_modules/admin/controllers/modules.php#L425) with `[$this->_option . '.module', &$model, $model->isNew()]`
- [`core/components/com_templates/admin/controllers/styles.php:276`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_templates/admin/controllers/styles.php#L276) with `['com_templates.style', $style, ($fields['id'] ? false : true)]`
- [`core/components/com_templates/models/file.php:135`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_templates/models/file.php#L135) with `['com_templates.source', &$data, false]`
- [`core/components/com_templates/models/source.php:140`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_templates/models/source.php#L140) with `['com_templates.source', &$data, false]`

No plugin in the source tree listens for this event.
