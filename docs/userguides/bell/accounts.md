---
tags:
  - Bell
authors:
  - mahlawat
resource: bell
search:
  boost: 2
---

{% set host = "bell.rcac.purdue.edu" %}
{% set cluster = "Bell" %}
{% set resource = "bell" %}

{{ accounts_md_snippet(host,cluster) }}

## SSH Keys
{{ ssh_keys_snippet(resource) }}

## SSH X11 Forwarding
{{ ssh_x11_snippet(resource) }}

## Thinlinc
{{ thinlinc_snippet(resource) }}

## More In This Section

- [Purchasing Nodes](accounts/purchase.md)
