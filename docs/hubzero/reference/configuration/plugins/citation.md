---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/configuration/plugins/citation.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: core/plugins/citation/*/*.xml
---

# Citation plugins

Parameters of every plugin in the `citation` group, from each plugin's manifest. Set them under **Extensions > Plugins** in the administrator interface.

## Citation - BibTex (`plg_citation_bibtex`) { #citation-bibtex-plg-citation-bibtex }

Imports BibTex data

### Basic

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `title_match_percent` | % Title Match (Import) | text | `90%` | % Title Match (Import) |

## Citation - Default (`plg_citation_default`) { #citation-default-plg-citation-default }

Imports Text File data - sends off to other plugins

This plugin has no parameters.

## Citation - DOI (`plg_citation_doi`) { #citation-doi-plg-citation-doi }

Include citation in the DOI metadata record

This plugin has no parameters.

## Citation - Endnote (`plg_citation_endnote`) { #citation-endnote-plg-citation-endnote }

Imports Endnote data

### Basic { #basic-2 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `custom_tags` | Custom Tags | textarea | — | Custom tags in key => value pair format that are extra beyond standard Endnote tags. |
| `title_match_percent` | % Title Match (Import) | text | `90` | % Title Match (Import) |
