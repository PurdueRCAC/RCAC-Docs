---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# FTP / SFTP

!!! Warning
    FTP is not supported on any research systems because it does not allow for secure transmission of data. Use SFTP instead, as described below.

*SFTP* (Secure File Transfer Protocol) is a reliable way of transferring files between two machines. SFTP is available as a protocol choice in some graphical file transfer programs and also as a command-line program on most Linux, Unix, and Mac OS X systems. SFTP has more features than SCP and allows for other operations on remote files, remote directory listing, and resuming interrupted transfers. Command-line SFTP cannot recursively copy directory contents; to do so, try using SCP or graphical SFTP client.

!!! Note
    After Aug 17, 2020, the community clusters will not support password-based authentication for login. Methods that can be used include two-factor authentication ([Purdue Login](/userguides/bell/accounts/#logging-in-to-bell)) or [SSH keys](/userguides/bell/accounts/#ssh-keys). If you do not have SSH keys installed, you would need to type your Purdue Login response into the SFTP's "Password" prompt.


## Command-line usage

You can transfer files both to and from Bell while initiating an SFTP session on either some other computer or on Bell (in other words, directionality of connection and directionality of data flow are independent from each other). Once the connection is established, you use `put` or `get` subcommands between "local" and "remote" computers. Either Bell or another computer can be a remote.

* **Example:** Initiating SFTP session on some other computer (i.e. you are on another computer, connecting to Bell):

    ```
    $ sftp myusername@bell.rcac.purdue.edu

          (transfer TO Bell)
    sftp> put sourcefile somedir/destinationfile
    sftp> put -P sourcefile somedir/

          (transfer FROM Bell)
    sftp> get sourcefile somedir/destinationfile
    sftp> get -P sourcefile somedir/

    sftp> exit
    ```

    The **-P** flag is optional. When used, it will cause the transfer to preserve file attributes and permissions.

* **Example:** Initiating SFTP session on Bell (i.e. you are on Bell, connecting to some other computer):

    ```
    $ sftp myusername@$another.computer.example.com

          (transfer TO Bell)
    sftp> get sourcefile somedir/destinationfile
    sftp> get -P sourcefile somedir/

          (transfer FROM Bell)
    sftp> put sourcefile somedir/destinationfile
    sftp> put -P sourcefile somedir/

    sftp> exit
    ```

    The **-P** flag is optional. When used, it will cause the transfer to preserve file attributes and permissions.

## Software (SFTP clients)

Linux and other Unix-like systems:

* The `sftp` command-line program should already be installed.

Microsoft Windows:

* [MobaXterm](https://mobaxterm.mobatek.net/download.html)  
  Free, full-featured, graphical Windows SSH, SCP, and SFTP client.
* Command-line `sftp` program can be installed as part of Windows Subsystem for Linux (WSL), or Git-Bash.

Mac OS X:

* The `sftp` command-line program should already be installed. You may start a local terminal window from "Applications->Utilities".
* [Cyberduck](https://cyberduck.io/) is a full-featured and free graphical SFTP and SCP client.

[**Back to the Storage section**](../storage.md)
