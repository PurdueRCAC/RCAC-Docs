---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/configuration/components/templates.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: core/components/com_templates/config/config.xml
---

# Templates (com_templates)

This component manages templates

Parameters from [`core/components/com_templates/config/config.xml`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_templates/config/config.xml), as shown on the component's **Options** screen in the administrator interface.

## Templates

Global Configuration for Templates

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `template_positions_display` | Preview Module Positions | radio | `0 (Disabled)` | Enable the preview of the module positions in the template by appending tp=1 to the web address. Also enables the Preview button in the list of templates. Please refresh the page after changing this setting. Options: `0` Disabled, `1` Enabled. |
