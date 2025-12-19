---
tags:
  - Gautschi
authors:
  - jin456
resource: gautschi
search:
  boost: 2
---

## Accounts on Gautschi
### Obtaining an Account

To obtain an account, you must be part of a research group which has purchased access to Gautschi. Refer to the [Accounts / Access](https://www.rcac.purdue.edu/account/request) page for more details on how to request access.

### Outside Collaborators
A valid Purdue Career Account is required for access to any resource. If you do not currently have a valid Purdue Career Account you must have a current Purdue faculty or staff member file a [Request for Privileges (R4P)](https://www.purdue.edu/apps/account/r4p) before you can proceed.

## Logging In
To submit jobs on {{ resource }}, log in to the submission host `{{ resource }}.rcac.purdue.edu` via SSH. This submission host is actually {{ resource }} front-end hosts: `login00.{{ resource }}` through `login07.{{ resource }}`. The login process randomly assigns one of these front-ends to each login to `{{ resource }}.rcac.purdue.edu`.

## Purdue Login
--8<-- "docs/snippets/purdue_login.md"

## Passwords
Gautschi supports either Purdue two-factor authentication ([Purdue Login](#purdue-login)) or SSH keys.

## SSH Client Software

*Secure Shell* or *SSH* is a way of establishing a secure connection between two computers. It uses public-key cryptography to authenticate the user with the remote computer and to establish a secure connection. Its usual function involves logging in to a remote machine and executing commands. There are many SSH clients available for all operating systems:

Linux / Solaris / AIX / HP-UX / Unix:

- The `ssh` command is pre-installed. Log in using `ssh username@gautschi.rcac.purdue.edu` from a terminal.

Microsoft Windows:

- [MobaXterm](https://mobaxterm.mobatek.net/download.html) is a small, easy to use, full-featured SSH client. It includes X11 support for remote displays, SFTP capabilities, and limited SSH authentication forwarding for keys.

Mac OS X:

- The `ssh` command is pre-installed. You may start a local terminal window from "Applications->Utilities". Log in by typing the command `ssh username@gautschi.rcac.purdue.edu`.

!!! note
    When prompted for password, enter your Purdue career account password **followed by "**`,push` **"**. Your Purdue Duo client will then receive a notification to approve the login.

## SSH Keys
{% set resource = "gautschi" %}
{{ ssh_keys_snippet(resource) }} 

## SSH X11 Forwarding
{% set resource = "gautschi" %}
{{ ssh_x11_snippet(resource) }}

## ThinLinc
{% set resource = "gautschi" %}
{{ thinlinc_snippet(resource) }}
