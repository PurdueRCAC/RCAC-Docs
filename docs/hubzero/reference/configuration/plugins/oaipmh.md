---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/configuration/plugins/oaipmh.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: core/plugins/oaipmh/*/*.xml
---

# Oaipmh plugins

Parameters of every plugin in the `oaipmh` group, from each plugin's manifest. Set them under **Extensions > Plugins** in the administrator interface.

## OAIPMH - Publications (`plg_oaipmh_publications`) { #oaipmh-publications-plg-oaipmh-publications }

OAIPMH data provider for publications

### Basic

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `type` | Publication Category | publicationcategory | `0` | Filter the publications provided by a specific category. |

## OAIPMH - Resources (`plg_oaipmh_resources`) { #oaipmh-resources-plg-oaipmh-resources }

OAIPMH data provider for resources

### Basic { #basic-2 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `type` | Resource Type | resourcetype | `0` | Filter the resources provided by a specific type. |
| `citations` | Include Citations | list | `1 (Yes)` | Include citations as references on records?. Options: `0` No, `1` Yes. |
