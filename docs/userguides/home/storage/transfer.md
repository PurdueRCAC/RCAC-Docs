---
tags:
  - Home Directory
authors:
  - jin456
search:
  boost: 2
---

# File Transfer

Home Directory supports several methods for file transfer. Use the links below to learn more about these methods.

## SCP

*SCP* (Secure CoPy) is a simple way of transferring files between two machines that use the SSH protocol. SCP is available as a protocol choice in some graphical file transfer programs and also as a command line program on most Linux, Unix, and Mac OS X systems. SCP can copy single files, but will also recursively copy directory contents if given a directory name.

!!!note
    After Aug 17, 2020, the community clusters will not support password-based authentication for login. Methods that can be used include two-factor authentication (Purdue Login) or SSH keys. If you do not have SSH keys installed, you would need to type your Purdue Login response into the SFTP's "Password" prompt.

### Command-line Usage

You can transfer files both to and from Home Directory while initiating an SCP session on either some other computer or on Home Directory (in other words, directionality of connection and directionality of data flow are independent from each other). The `scp` command appears somewhat similar to the familiar `cp` command, with an extra `user@host:file` syntax to denote files and directories on a remote host. Either Home Directory or another computer can be a remote.

- **Example:** Initiating SCP session on some other computer (i.e. you are on some other computer, connecting to Home Directory):

    ```
          (transfer TO Home Directory)
          (Individual files)
    $ scp  sourcefile  username@data.rcac.purdue.edu:somedir/destinationfile
    $ scp  sourcefile  username@data.rcac.purdue.edu:somedir/
          (Recursive directory copy)
    $ scp -pr sourcedirectory/  username@data.rcac.purdue.edu:somedir/

          (transfer FROM Home Directory)
          (Individual files)
    $ scp  username@data.rcac.purdue.edu:somedir/sourcefile  destinationfile
    $ scp  username@data.rcac.purdue.edu:somedir/sourcefile  somedir/
          (Recursive directory copy)
    $ scp -pr username@data.rcac.purdue.edu:sourcedirectory  somedir/
    ```

    The **-p** flag is optional. When used, it will cause the transfer to preserve file attributes and permissions. The **-r** flag is required for recursive transfers of entire directories.

- **Example:** Initiating SCP session on Home Directory (i.e. you are on Home Directory, connecting to some other computer):

    ```
          (transfer TO Home Directory)
          (Individual files)
    $ scp  username@$another.computer.example.com:sourcefile  somedir/destinationfile
    $ scp  username@$another.computer.example.com:sourcefile  somedir/
          (Recursive directory copy)
    $ scp -pr username@$another.computer.example.com:sourcedirectory/  somedir/

          (transfer FROM Home Directory)
          (Individual files)
    $ scp  somedir/sourcefile  username@$another.computer.example.com:destinationfile
    $ scp  somedir/sourcefile  username@$another.computer.example.com:somedir/
          (Recursive directory copy)
    $ scp -pr sourcedirectory  username@$another.computer.example.com:somedir/
    ```

    The **-p** flag is optional. When used, it will cause the transfer to preserve file attributes and permissions. The **-r** flag is required for recursive transfers of entire directories.

### Software (SCP Clients)

Linux and other Unix-like systems:

- The `scp` command-line program should already be installed.

Microsoft Windows:

- [MobaXterm](https://mobaxterm.mobatek.net/download.html)
  Free, full-featured, graphical Windows SSH, SCP, and SFTP client.
- Command-line `scp` program can be installed as part of Windows Subsystem for Linux (WSL), or Git-Bash.

Mac OS X:

- The `scp` command-line program should already be installed. You may start a local terminal window from "Applications->Utilities".
- [Cyberduck](https://cyberduck.io/) is a full-featured and free graphical SFTP and SCP client.

## FTP / SFTP

!!!note
    FTP is **NOT** supported on any research systems because it does not allow for secure transmission of data. Use SFTP instead, as described below.

*SFTP* (Secure File Transfer Protocol) is a reliable way of transferring files between two machines. SFTP is available as a protocol choice in some graphical file transfer programs and also as a command-line program on most Linux, Unix, and Mac OS X systems. SFTP has more features than SCP and allows for other operations on remote files, remote directory listing, and resuming interrupted transfers. Command-line SFTP cannot recursively copy directory contents; to do so, try using SCP or graphical SFTP client.

!!!note
    After Aug 17, 2020, the community clusters will not support password-based authentication for login. Methods that can be used include two-factor authentication (Purdue Login) or SSH keys. If you do not have SSH keys installed, you would need to type your Purdue Login response into the SFTP's "Password" prompt.

### Command-line Usage

You can transfer files both to and from Home Directory while initiating an SFTP session on either some other computer or on Home Directory (in other words, directionality of connection and directionality of data flow are independent from each other). Once the connection is established, you use `put` or `get` subcommands between "local" and "remote" computers. Either Home Directory or another computer can be a remote.

- **Example:** Initiating SFTP session on some other computer (i.e. you are on another computer, connecting to Home Directory):

    ```
    $ sftp username@data.rcac.purdue.edu

          (transfer TO Home Directory)
    sftp> put sourcefile somedir/destinationfile
    sftp> put -P sourcefile somedir/

          (transfer FROM Home Directory)
    sftp> get sourcefile somedir/destinationfile
    sftp> get -P sourcefile somedir/

    sftp> exit
    ```

    The **-P** flag is optional. When used, it will cause the transfer to preserve file attributes and permissions.

- **Example:** Initiating SFTP session on Home Directory (i.e. you are on Home Directory, connecting to some other computer):

    ```
    $ sftp username@$another.computer.example.com

          (transfer TO Home Directory)
    sftp> get sourcefile somedir/destinationfile
    sftp> get -P sourcefile somedir/

          (transfer FROM Home Directory)
    sftp> put sourcefile somedir/destinationfile
    sftp> put -P sourcefile somedir/

    sftp> exit
    ```

    The **-P** flag is optional. When used, it will cause the transfer to preserve file attributes and permissions.

### Software (SFTP Clients)

Linux and other Unix-like systems:

- The `sftp` command-line program should already be installed.

Microsoft Windows:

- [MobaXterm](https://mobaxterm.mobatek.net/download.html)
  Free, full-featured, graphical Windows SSH, SCP, and SFTP client.
- Command-line `sftp` program can be installed as part of Windows Subsystem for Linux (WSL), or Git-Bash.

Mac OS X:

- The `sftp` command-line program should already be installed. You may start a local terminal window from "Applications->Utilities".
- [Cyberduck](https://cyberduck.io/) is a full-featured and free graphical SFTP and SCP client.


## Globus

*Globus*, previously known as Globus Online, is a powerful and easy to use file transfer service for transferring files virtually anywhere. It works within RCAC's various research storage systems; it connects between RCAC and remote research sites running Globus; and it connects research systems to personal systems. You may use Globus to connect to your home, scratch, and Fortress storage directories. Since Globus is web-based, it works on any operating system that is connected to the internet. The Globus Personal client is available on Windows, Linux, and Mac OS X. It is primarily used as a graphical means of transfer but it can also be used over the command line.

### Globus Web

- Navigate to <https://transfer.rcac.purdue.edu>
- Click "Proceed" to log in with your Purdue Career Account.
- On your first login it will ask to make a connection to a Globus account. Accept the conditions.
- Now you are at the main screen. Click "File Transfer" which will bring you to a two-panel interface (if you only see one panel, you can use selector in the top-right corner to switch the view).
- You will need to select one collection and file path on one side as the source, and the second collection on the other as the destination. This can be one of several Purdue endpoints, or another University, or even your personal computer (see [Personal Client section](#globus-personal-client-setup) below).

The RCAC collections are as follows. A search for "Purdue" will give you several suggested results you can choose from, or you can give a more specific search.

- **Home Directory storage:** *"Purdue Research Computing - Home Directories"*, however, you can start typing "Purdue" and "Home Directories" and it will suggest appropriate matches.
- **Research Data Depot:** *"Purdue Research Computing - Data Depot"*, a search for "Depot" should provide appropriate matches to choose from.
- **Fortress:** *"Purdue Fortress HPSS Archive"*, a search for "Fortress" should provide appropriate matches to choose from.

From here, select a file or folder in either side of the two-pane window, and then use the arrows in the top-middle of the interface to instruct Globus to move files from one side to the other. You can transfer files in either direction. You will receive an email once the transfer is completed.

### Globus Personal Client Setup

Globus Connect Personal is a small software tool you can install to make your own computer a Globus endpoint on its own. It is useful if you need to transfer files via Globus to and from your computer directly.

- On the "Collections" page from earlier, click *"Get Globus Connect Personal"* or download a version for your operating system from here: [Globus Connect Personal](https://www.globus.org/globus-connect-personal)
- Name this particular personal system and follow the setup prompts to create your Globus Connect Personal endpoint.
- Your personal system is now available as a collection within the Globus transfer interface.

### Globus Command Line

Globus supports command line interface, allowing advanced automation of your transfers.

To use the recommended standalone Globus CLI application (the `globus` command):

- First time use: issue the `globus login` command and follow instructions for initial login.
- Commands for interfacing with the CLI can be found via [Using the Command Line Interface](https://docs.globus.org/cli/), as well as the [Globus CLI Examples](https://docs.globus.org/cli/examples/) pages.

### Sharing Data with Outside Collaborators

Globus allows convenient sharing of data with outside collaborators. Data can be shared with collaborators' personal computers or directly with many other computing resources at other institutions. See the Globus documentation on how to share data:

- <https://docs.globus.org/how-to/share-files/>

For links to more information, please see [Globus Support](https://support.globus.org/home) page and [RCAC Globus presentation](https://www.rcac.purdue.edu/training/globus).
