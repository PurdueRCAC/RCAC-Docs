---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

{% set resource = "gilbreth" %}

{{ accounts_md_snippet(resource) }}

## SSH Keys
{{ ssh_keys_snippet(resource) }}

## SSH X11 Forwarding
{{ ssh_x11_snippet(resource) }}

## Thinlinc
{{ thinlinc_snippet(resource) }}

## Purchasing Nodes

--8<-- "docs/snippets/purchase_nodes.md"

[**Back to Gilbreth User Guide**](./index.md)
