---
tags:
  - Negishi
authors:
  - hkashgar
resource: negishi
search:
  boost: 2
---


{% set resource = "negishi" %}

{{ accounts_md_snippet(resource) }}

## SSH Keys
{{ ssh_keys_snippet(resource) }}

## SSH X11 Forwarding
{{ ssh_x11_snippet(resource) }}

## Thinlinc
{{ thinlinc_snippet(resource) }}

## Purchasing Nodes

--8<-- "docs/snippets/purchase_nodes.md"

[**Back to Negishi User Guide**](index.md)
