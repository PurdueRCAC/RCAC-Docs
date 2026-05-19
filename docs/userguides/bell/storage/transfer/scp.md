---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# SCP

*SCP* (Secure CoPy) is a simple way of transferring files between two machines that use the SSH protocol. SCP is available as a protocol choice in some graphical file transfer programs and also as a command line program on most Linux, Unix, and Mac OS X systems. SCP can copy single files, but will also recursively copy directory contents if given a directory name.

!!! Note
      After Aug 17, 2020, the community clusters will not support password-based authentication for login. Methods that can be used include two-factor authentication ([Purdue Login](/userguides/bell/accounts/#logging-in-to-bell)) or [SSH keys](/userguides/bell/accounts/#ssh-keys). If you do not have SSH keys installed, you would need to type your Purdue Login response into the SFTP's "Password" prompt.


### Command-line usage:

You can transfer files both to and from Bell while initiating an SCP session on either some other computer or on Bell (in other words, directionality of connection and directionality of data flow are independent from each other). The `scp` command appears somewhat similar to the familiar `cp` command, with an extra `user@host:file` syntax to denote files and directories on a remote host. Either Bell or another computer can be a remote.

* **Example:** Initiating SCP session on some other computer (i.e. you are on some other computer, connecting to Bell):

      ```
            (transfer TO Bell)
            (Individual files) 
      $ scp  sourcefile  myusername@bell.rcac.purdue.edu:somedir/destinationfile
      $ scp  sourcefile  myusername@bell.rcac.purdue.edu:somedir/
            (Recursive directory copy)
      $ scp -pr sourcedirectory/  myusername@bell.rcac.purdue.edu:somedir/

            (transfer FROM Bell)
            (Individual files)
      $ scp  myusername@bell.rcac.purdue.edu:somedir/sourcefile  destinationfile
      $ scp  myusername@bell.rcac.purdue.edu:somedir/sourcefile  somedir/
            (Recursive directory copy)
      $ scp -pr myusername@bell.rcac.purdue.edu:sourcedirectory  somedir/
      ```

      The **-p** flag is optional. When used, it will cause the transfer to preserve file attributes and permissions. The **-r** flag is required for recursive transfers of entire directories.
      
* **Example:** Initiating SCP session on Bell (i.e. you are on Bell, connecting to some other computer):

      ```
            (transfer TO Bell)
            (Individual files) 
      $ scp  myusername@$another.computer.example.com:sourcefile  somedir/destinationfile
      $ scp  myusername@$another.computer.example.com:sourcefile  somedir/
            (Recursive directory copy)
      $ scp -pr myusername@$another.computer.example.com:sourcedirectory/  somedir/

            (transfer FROM Bell)
            (Individual files)
      $ scp  somedir/sourcefile  myusername@$another.computer.example.com:destinationfile
      $ scp  somedir/sourcefile  myusername@$another.computer.example.com:somedir/
            (Recursive directory copy)
      $ scp -pr sourcedirectory  myusername@$another.computer.example.com:somedir/
      ```

      The **-p** flag is optional. When used, it will cause the transfer to preserve file attributes and permissions. The **-r** flag is required for recursive transfers of entire directories.

### Software (SCP clients)

Linux and other Unix-like systems:

* The `scp` command-line program should already be installed.

Microsoft Windows:

* [MobaXterm](https://mobaxterm.mobatek.net/download.html)  
  Free, full-featured, graphical Windows SSH, SCP, and SFTP client.
* Command-line `scp` program can be installed as part of Windows Subsystem for Linux (WSL), or Git-Bash.

Mac OS X:

* The `scp` command-line program should already be installed. You may start a local terminal window from "Applications->Utilities".
* [Cyberduck](https://cyberduck.io/) is a full-featured and free graphical SFTP and SCP client.
