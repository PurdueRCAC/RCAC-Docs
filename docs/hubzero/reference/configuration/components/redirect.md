---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/configuration/components/redirect.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: core/components/com_redirect/config/config.xml
---

# Redirect (com_redirect)

This component implements link redirection

Parameters from [`core/components/com_redirect/config/config.xml`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_redirect/config/config.xml), as shown on the component's **Options** screen in the administrator interface.

## Delay

Delay

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `delay_enabled` | Delay is enabled | list | `DISABLED` | Delay is enabled. Options: `ENABLED`, `DISABLED`. |
| `delay_seconds` | Delay in seconds | text | `10` | Delay in seconds |
| `delay_whitelist` | Whitelisted hosts | text | — | Whitelisted hosts |
| `delay_blacklist` | Blacklisted hosts | text | — | Blacklisted hosts |
