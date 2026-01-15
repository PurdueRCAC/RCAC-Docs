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

To obtain an account, you must be part of a research group which has purchased access to {{ resource }}. Refer to the [Accounts / Access](https://www.rcac.purdue.edu/account/request) page for more details on how to request access.

!!! note
    External (non-Purdue) collaborators can be granted access to {{ resource }}, provided the collaborator has a valid Purdue career account. If the collaborator does not have a Purdue career account, a current Purdue faculty or staff member must file a [Request for Privileges (R4P)](https://www.purdue.edu/apps/account/r4p) to have the career account created.

## Logging In To {{ resource }}
There are several ways to login to {{ resource }}:

### Thinlinc web client
One can login to the {{ resource }} front-end with a full desktop environment via the [Thinlinc web client](https://desktop.gautschi.rcac.purdue.edu).

!!! important
    Your full password,push Duo passphrase is needed to trigger the Duo notification that is sent to your phone for approval.

### Gateway / OnDemand
One can login to {{ resource }}'s [Gateway](https://gateway.gautschi.rcac.purdue.edu) to manage files in your home/scratch/depot directories and start Slurm jobs for supported OnDemand applications.

### SSH
*Secure Shell* or *SSH* is a way of establishing a secure connection between two computers. It uses public-key cryptography to authenticate the user with the remote computer and to establish a secure connection. Its usual function involves logging in to a remote machine and executing commands. There are many SSH clients available for all operating systems.

!!! note
    {{ resource }} supports either Purdue's Duo two-factor authentication or SSH keys.

#### SSH Client Software
Linux / Solaris / AIX / HP-UX / Unix:

- The `ssh` command is pre-installed. Log in using `ssh username@gautschi.rcac.purdue.edu` from a terminal.

Microsoft Windows:

- [MobaXterm](https://mobaxterm.mobatek.net/download.html) is a small, easy to use, full-featured SSH client. It includes X11 support for remote displays, SFTP capabilities, and limited SSH authentication forwarding for keys.

Mac OS X:

- The `ssh` command is pre-installed. You may start a local terminal window from "Applications->Utilities". Log in by typing the command `ssh username@gautschi.rcac.purdue.edu`.

!!! important
    When prompted to enter a password, enter your Purdue career account password **followed by "**`,push` **"**. Your Duo app will then receive a notification to approve the login.

### SSH Keys
SSH keys can be used in lieu of the Duo passphrase "password,push" for password-less logins. Refer to the blog post at [PLACEHOLDER URL](http://localhost:8080/blog/2026/01/15/creating-an-ssh-key-pair-for-password-less-logins) for more information.


### ThinLinc
It's possible to login to {{ resource }} using the ThinLinc desktop app. Refer to the blog post at [PLACEHOLDER URL](http://localhost:8080/blog/2026/01/14/logging-in-to-the-community-clusters-via-thinlinc) URL for more information on the installation and login steps.
