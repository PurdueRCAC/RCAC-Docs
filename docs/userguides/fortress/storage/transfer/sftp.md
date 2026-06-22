---
tags:
  - Fortress
authors:
  - jin456
  - ramonw
search:
  boost: 2
draft: false
---

# FTP / SFTP

!!!info
    FTP is not supported on Fortress because it does not allow for secure transmission of data. Use SFTP instead, as described below.

*SFTP* (Secure File Transfer Protocol) is a reliable way of transferring files between two machines. SFTP is available as a protocol choice in some graphical file transfer programs and also as a command-line program on most Linux, Unix, and Mac OS X systems. SFTP has more features than SCP and allows for other operations on remote files, remote directory listing, and resuming interrupted transfers. Command-line SFTP cannot recursively copy directory contents; to do so, try using a graphical SFTP client.

!!!note
    **Note:** to access Fortress through SFTP, you must be on a Purdue campus network or connected through [VPN](http://www.itap.purdue.edu/connections/vpn/).

To transfer files to or from Fortress, your client should connect to the server name `sftp.fortress.rcac.purdue.edu`.

Command-line usage:

```
$ sftp username@sftp.fortress.rcac.purdue.edu

      (to the Fortress system from a local computer)
sftp> put sourcefile somedir/destinationfile
sftp> put -P sourcefile somedir/

      (from the Fortress system to a local computer)
sftp> get sourcefile somedir/destinationfile
sftp> get -P sourcefile somedir/

sftp> exit
```

The `-P` flag is optional. When used, it will cause the transfer to preserve file attributes and permissions.

Linux / Solaris / AIX / HP-UX / Unix:

- The `sftp` command-line program should already be installed.

Microsoft Windows:

- [MobaXterm](https://mobaxterm.mobatek.net/download.html) — Free, full-featured, graphical Windows SSH, SCP, and SFTP client.

Mac OS X:

- The `sftp` command-line program should already be installed. You may start a local terminal window from "Applications->Utilities".
- [Cyberduck](https://cyberduck.io/) is a full-featured and free graphical SFTP and SCP client.
