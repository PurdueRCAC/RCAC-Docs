---
tags:
  - Data Depot
authors:
  - jin456
search:
  boost: 2
draft: false
---

# File Transfer

Data Depot supports several methods for file transfer.

## Globus

*Globus*, previously known as Globus Online, is a powerful and easy to use file transfer service for transferring files virtually anywhere. It works within RCAC's various research storage systems; it connects between RCAC and remote research sites running Globus; and it connects research systems to personal systems. You may use Globus to connect to your home, scratch, and Fortress storage directories. Since Globus is web-based, it works on any operating system that is connected to the internet. The Globus Personal client is available on Windows, Linux, and Mac OS X. It is primarily used as a graphical means of transfer but it can also be used over the command line.

### Globus Web

- Navigate to <https://transfer.rcac.purdue.edu>
- Click "Proceed" to log in with your Purdue Career Account.
- On your first login it will ask to make a connection to a Globus account. Accept the conditions.
- Now you are at the main screen. Click "File Transfer" which will bring you to a two-panel interface (if you only see one panel, you can use the selector in the top-right corner to switch the view).
- You will need to select one collection and file path on one side as the source, and the second collection on the other as the destination. This can be one of several Purdue endpoints, or another University, or even your personal computer (see [Personal Client section](#globus-personal-client-setup) below).

The RCAC collections are as follows. A search for "Purdue" will give you several suggested results you can choose from, or you can give a more specific search.

For **Bell** and **Gilbreth**, home and scratch directories have different collections:

- **Home Directory storage:** *"Purdue {Name} Cluster - Home Directories"*
- **Scratch Directory storage:** *"Purdue {Name} Cluster - Scratch"* 

For **Anvil**, **Negishi**, and **Gautschi**, home and scratch are combined in one collection and users can navigate using the path: 

- **Collection Home and Scratch:** *"Purdue {Name} Cluster"*

To access group storage space and archival storage: 

- **Research Data Depot:** *"Purdue Research Computing - Data Depot"* — a search for "Depot" should provide appropriate matches to choose from.
- **Fortress:** *"Purdue Fortress HPSS Archive"* — a search for "Fortress" should provide appropriate matches to choose from.

From here, select a file or folder in either side of the two-pane window, and then use the arrows in the top-middle of the interface to instruct Globus to move files from one side to the other. You can transfer files in either direction. You will receive an email once the transfer is completed.

### Globus Personal Client Setup

Globus Connect Personal is a small software tool you can install to make your own computer a Globus endpoint on its own. It is useful if you need to transfer files via Globus to and from your computer directly.

- On the "Collections" page from earlier, click *"Get Globus Connect Personal"* or download a version for your operating system from here: [Globus Connect Personal](https://www.globus.org/globus-connect-personal)
- Name this particular personal system and follow the setup prompts to create your Globus Connect Personal endpoint.
- Your personal system is now available as a collection within the Globus transfer interface.

### Globus Command Line

Globus supports a command line interface, allowing advanced automation of your transfers.

To use the recommended standalone Globus CLI application (the `globus` command):

- First time use: issue the `globus login` command and follow instructions for initial login.
- Commands for interfacing with the CLI can be found via [Using the Command Line Interface](https://docs.globus.org/cli/), as well as the [Globus CLI Examples](https://docs.globus.org/cli/examples/) pages.

### Sharing Data with Outside Collaborators

Globus allows convenient sharing of data with outside collaborators. Data can be shared with collaborators' personal computers or directly with many other computing resources at other institutions. See the Globus documentation on how to share data:

- <https://docs.globus.org/how-to/share-files/>

For links to more information, please see [Globus Support](https://support.globus.org/home) page and [RCAC Globus presentation](https://www.rcac.purdue.edu/training/globus).

## Windows Network Drive / SMB

*SMB* (Server Message Block), also known as CIFS, is an easy-to-use file transfer protocol that is useful for transferring files between RCAC systems and a desktop or laptop. You may use SMB to connect to your home, scratch, and Fortress storage directories. The SMB protocol is available on Windows, Linux, and Mac OS X. It is primarily used as a graphical means of transfer, but it can also be used over the command line.

Note: to access Data Depot through SMB file sharing, you must be on a Purdue campus network or connected through [VPN](http://www.itap.purdue.edu/connections/vpn/).

### Windows

- Windows 7: Click Windows menu > Computer, then click Map Network Drive in the top bar
- Windows 8 & 10: Tap the Windows key, type `computer`, select This PC, click Computer > Map Network Drive in the top bar
- Windows 11: Tap the Windows key, type `File Explorer`, select This PC, click Computer > Map Network Drive in the top bar
- In the folder location, enter the following information and click Finish:
    - To access your Data Depot directory, enter `\\datadepot.rcac.purdue.edu\depot\mylab` where `mylab` is your research group name.
    - Use your career account login name and password when prompted. (You will **not** need to add "`,push`" nor use your Purdue Duo client.)

- Your Data Depot directory should now be mounted as a drive in the Computer window.
- If you have issues mapping the drive, check Credential Manager:
    - In the Search bar, type "Credential Manager"
    - Inside Credential Manager, click "Windows Credentials" and "Add New Credential"
    - Servername: `\\datadepot.rcac.purdue.edu`
    - Username: `boilerad\PurdueLogin`
    - Then save it and try mapping again. If there is already an entry for the server you are trying to map, delete it first.

### Mac OS X

- In the Finder, click Go > Connect to Server
- In the Server Address enter the following information and click Connect:
    - To access your Data Depot directory, enter `smb://datadepot.rcac.purdue.edu/depot/mylab` where `mylab` is your research group name.
    - Use your career account login name and password when prompted. (You will **not** need to add "`,push`" nor use your Purdue Duo client.)
- Your Data Depot directory should now be mounted as a drive in the Computer window.

### Linux

- There are several graphical methods to connect in Linux depending on your desktop environment. Once you find out how to connect to a network server on your desktop environment, choose the Samba/SMB protocol and adapt the information from the Mac OS X section to connect.
- If you would like access via samba on the command line you may install `smbclient` which will give you FTP-like access and can be used as shown below.

    ```
    smbclient //datadepot.rcac.purdue.edu/depot/ -U boilerad/username
    cd mylab
    ```

- Note: Use your career account login name and password when prompted. (You will **not** need to add "`,push`" nor use your Purdue Duo client.)
