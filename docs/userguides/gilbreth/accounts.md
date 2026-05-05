---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

{% set host = "gilbreth.rcac.purdue.edu" %}
{% set cluster = "Gilbreth" %}
{% set resource = "gilbreth" %}

{{ accounts_md_snippet(host,cluster) }}

## SSH Keys
{{ ssh_keys_snippet(resource) }}

## SSH X11 Forwarding
{{ ssh_x11_snippet(resource) }}

## Thinlinc
{{ thinlinc_snippet(resource) }}

## Purchasing Nodes

--8<-- "docs/snippets/purchase_nodes.md"
