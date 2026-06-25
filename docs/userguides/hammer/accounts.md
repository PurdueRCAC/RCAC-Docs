---
tags:
  - Hammer
authors:
  - jin456
resource: Hammer
search:
  boost: 2
---

# Accounts on Hammer

### Obtaining an Account

To obtain an account, you must be part of a research group which has purchased access to Hammer. Refer to the [Accounts / Access](https://www.rcac.purdue.edu/account/request) page for more details on how to request access.

!!! note
    External (non-Purdue) collaborators can be granted access to Hammer, provided the collaborator has a valid Purdue career account. If the collaborator does not have a Purdue career account, a current Purdue faculty or staff member must file a [Request for Privileges (R4P)](https://www.purdue.edu/apps/account/r4p) to have the career account created.

## Logging In To Hammer

### Thinlinc

One can login to the Hammer front-end with a full desktop environment via the [ThinLinc web client](https://desktop.hammer.rcac.purdue.edu).

!!! important
    Your full password is needed to trigger the MFA notification that is sent to your phone for approval.

{{ thinlinc_snippet("hammer") }}

### SSH

*Secure Shell* or *SSH* is a way of establishing a secure connection between two computers. It uses public-key cryptography to authenticate the user with the remote computer and to establish a secure connection. Its usual function involves logging in to a remote machine and executing commands. There are many SSH clients available for all operating systems.

!!! note
    Hammer supports either Purdue's MFA two-factor authentication or SSH keys.

#### SSH Client Software

Linux / Solaris / AIX / HP-UX / Unix:

- The `ssh` command is pre-installed. Log in using `ssh username@hammer.rcac.purdue.edu` from a terminal.

Microsoft Windows:

- [MobaXterm](https://mobaxterm.mobatek.net/download.html) is a small, easy to use, full-featured SSH client. It includes X11 support for remote displays, SFTP capabilities, and limited SSH authentication forwarding for keys.

Mac OS X:

- The `ssh` command is pre-installed. You may start a local terminal window from "Applications->Utilities". Log in by typing the command `ssh username@hammer.rcac.purdue.edu`.

!!! important
    When prompted to enter a password, enter your Purdue career account password. Your MFA app will then receive a notification to approve the login.

## SSH Keys
{{ ssh_keys_snippet("hammer") }}

## SSH X11 Forwarding
{{ ssh_x11_snippet("hammer") }}

## Purchasing Nodes

--8<-- "docs/snippets/purchase_nodes.md"

[**Back to Hammer User Guide**](index.md)
