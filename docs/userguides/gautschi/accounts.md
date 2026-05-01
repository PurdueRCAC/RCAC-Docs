---
tags:
  - Gautschi
authors:
  - jin456
  - remender
resource: gautschi
search:
  boost: 2
---

{% set host = "gautschi.rcac.purdue.edu" %}
{% set cluster = "Gautschi" %}
{% set resource = "gautschi" %}

{{ accounts_md_snippet(host,cluster) }}

## SSH Keys
{{ ssh_keys_snippet(resource) }}

## SSH X11 Forwarding
{{ ssh_x11_snippet(resource) }}

## Thinlinc
{{ thinlinc_snippet(resource) }}