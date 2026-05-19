---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# bash: module command not found

## Problem

You receive the following message after typing a command, e.g. module load intel

`bash: module command not found`

## Solution

The system cannot find the module command. You need to source the modules.sh file as below

`source /etc/profile.d/modules.sh`

or

`#!/bin/bash -i`

[**Back to the Errors section**](../errors.md)
