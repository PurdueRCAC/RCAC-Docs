---
tags:
  - Scholar
authors:
  - jin456
  - remender
resource: Scholar
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

## SSH
*Secure Shell* or *SSH* is a way of establishing a secure connection between two computers. It uses public-key cryptography to authenticate the user with the remote computer and to establish a secure connection. Its usual function involves logging in to a remote machine and executing commands. There are many SSH clients available for all operating systems.

!!! note
    Scholar supports either Purdue's MFA two-factor authentication or SSH keys.

### SSH Client Software
Linux / Solaris / AIX / HP-UX / Unix:

- The `ssh` command is pre-installed. Log in using `ssh username@scholar.rcac.purdue.edu` from a terminal.

Microsoft Windows:

- [MobaXterm](https://mobaxterm.mobatek.net/download.html) is a small, easy to use, full-featured SSH client. It includes X11 support for remote displays, SFTP capabilities, and limited SSH authentication forwarding for keys.

Mac OS X:

- The `ssh` command is pre-installed. You may start a local terminal window from "Applications->Utilities". Log in by typing the command `ssh username@scholar.rcac.purdue.edu`.

!!! important
    When prompted to enter a password, enter your Purdue career account password. Your MFA app will then receive a notification to approve the login.

## SSH Keys
{{ ssh_keys_snippet(resource) }}

## SSH X11 Forwarding
{{ ssh_x11_snippet(resource) }}

## Thinlinc
{{ thinlinc_snippet(resource) }}