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