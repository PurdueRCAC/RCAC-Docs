---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/configuration/components/developer.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: core/components/com_developer/config/config.xml
---

# Developer (com_developer)

Extension and API developer utility

Parameters from [`core/components/com_developer/config/config.xml`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_developer/config/config.xml), as shown on the component's **Options** screen in the administrator interface.

## Documentation

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `doc_expiration` | Documentation Cache Expiration. | text | `14400` | How long the cache lasts for documentation before being regenerated. In seconds. Default is 4 hours = 14400 seconds |
