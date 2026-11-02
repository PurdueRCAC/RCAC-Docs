---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/configuration/components/dataviewer.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: core/components/com_dataviewer/config/config.xml
---

# Dataviewer (com_dataviewer)

Dataviewer for HUB Databases

Parameters from [`core/components/com_dataviewer/config/config.xml`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_dataviewer/config/config.xml), as shown on the component's **Options** screen in the administrator interface.

## Basic

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `record_display_limit` | Record Display Limit | list | `10` | Number of records to display. Options: `5`, `10`, `25`, `50`, `100`. |
| `processing_mode_switch` | Dynamic Processing mode | list | `0 (No)` | Dynamically switch between server-side and client-side processing modes. Options: `0` No, `1` Yes. |
| `proc_switch_threshold` | Client-side threshold | text | `25000` | Maximum number of cells to allow before switching to server-side processing |
| `mode_db` | DB Mode enabled | checkbox | `0` | Only enable this when com_databases is installed |
| `acl_users` | ACL Users | text | — |  |
| `acl_groups` | ACL Groups | text | — |  |
