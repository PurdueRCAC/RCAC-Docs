---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/configuration/components/oaipmh.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: core/components/com_oaipmh/config/config.xml
---

# Oaipmh (com_oaipmh)

COM_OAIPMH_XML_DESCRIPTION

Parameters from [`core/components/com_oaipmh/config/config.xml`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_oaipmh/config/config.xml), as shown on the component's **Options** screen in the administrator interface.

## Basic

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `limit` | Result Limit | text | `50` | Max results per page |
| `allow_ore` | Allow ORE | radio | `0 (No)` | Allow metadataPrefix of OAI_ORE in addition to OAI_DC. Options: `0` No, `1` Yes. |
| `repository_name` | Repository Name | text | — | full name of the Repository |
| `base_url` | Base URL | text | — | base URL of the Repository |
| `email` | Admin E-Mail | text | — | Email address for Repository Admin |
| `edate` | Earliest Datestamp | text | `2012-02-12 00:00:00` | Earliest datestamp in Repository |
| `del` | Deleted Record | list | `No` | Deleted Record. Options: `no` No, `transient` Transient, `persistent` Persistent. |
| `gran` | Harvesting Granularity | list | `c (YYYY-MM-DDThh:mm:ssZ)` | Finest harvesting granularity. Options: `c` YYYY-MM-DDThh&#58;mm:ssZ, `Y-m-d` YYYY-MM-DD. |
