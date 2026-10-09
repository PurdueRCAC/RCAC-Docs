---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/configuration/components/cron.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: core/components/com_cron/config/config.xml
---

# Cron (com_cron)

Launch CRON jobs

Parameters from [`core/components/com_cron/config/config.xml`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_cron/config/config.xml), as shown on the component's **Options** screen in the administrator interface.

## Basic

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `whitelist` | IP Whitelist | textarea | `127.0.0.1` | A comma-separated list of white-listed IP addresses |
