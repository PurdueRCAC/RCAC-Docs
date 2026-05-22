---
tags:
  - Scholar
authors:
  - jin456
  - remender
resource: scholar
host: scholar.rcac.purdue.edu
search:
  boost: 2
---

{% set host = "scholar.rcac.purdue.edu" %}
{% set resource = "scholar" %}

# Accounts on Scholar

## Obtaining an Account

All Purdue faculty may request access to Scholar for use in the classroom. Please use the [Accounts for Classes](https://www.rcac.purdue.edu/account/class/) tool to create accounts for your class. You will need to select the semester and CRN of the class. All students registered in that class will be added once the request is fulfilled. You may add additional instructors or TAs from the same tool.

## Logging In

There are several ways to login to Scholar:

## Thinlinc Web Client

One can login to the Gautschi front-end with a full desktop environment via the [Thinlinc web client](https://desktop.{{host}})

## Gateway / OnDemand

One can login to Gautschi's [Gateway](https://gateway.{{host}}) to manage files in your home/scratch/depot directories and start Slurm jobs for supported OnDemand applications.

## SSH Keys
{{ ssh_keys_snippet(resource) }}

## SSH X11 Forwarding
{{ ssh_x11_snippet(resource) }}

## Thinlinc
{{ thinlinc_snippet(resource) }}