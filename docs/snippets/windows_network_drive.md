<!-- Template snippet: {CLUSTER} = title-case cluster name (e.g. "{CLUSTER}"), {cluster} = lowercase (e.g. "{cluster}"). Replaced at build time by `windows_network_drive` in main.py. -->
# Windows Network Drive / SMB

SMB (Server Message Block), also known as CIFS, is an easy-to-use file transfer protocol that is useful for transferring files between RCAC systems and a desktop or laptop. You may use SMB to connect to your home, scratch, and Fortress storage directories. The SMB protocol is available on Windows, Linux, and Mac OS X. It is primarily used as a graphical means of transfer, but it can also be used over the command line.

!!!note
    To access {CLUSTER} through SMB file sharing, you must be on a Purdue campus network or connected through [VPN](https://it.purdue.edu/services/vpn.php).

## Windows

- **Windows 10**: Tap the Windows key, type ```computer```, select This PC, click Computer > Map Network Drive in the top bar
- **Windows 11**: Windows 11: Tap the Windows key, type ```File Explorer```, select This PC, click Computer > Map Network Drive in the top bar

    - In the folder location, enter the following information and click Finish:
    - To access your {CLUSTER} home directory, enter ```\\home.{cluster}.rcac.purdue.edu\{cluster}-home```
    - To access your scratch space on {CLUSTER}, enter ```\\scratch.{cluster}.rcac.purdue.edu\{cluster}-scratch```
    - Use your career account login name and password when prompted. (You will not need to add ```",push"``` nor use your Purdue MFA client.)
    - Your home or scratch directory should now be mounted as a drive in the Computer window

!!!important
    If you get a credential error and have already restarted your PC, follow these steps to create a manual credential in the Windows Credential Manager:

    - In the Start Menu search bar, type ```Credential Manager```
    
    - In the Credential Manager window, click ```Windows Credentials``` and ```Add New Credential```
    
    - Servername: ```\\home.{cluster}.rcac.purdue.edu``` or ```\\scratch.{cluster}.rcac.purdue.edu```
    
    - Username: ```boilerad\PurdueLogin```
    
    - Save the credential and try mapping again

## Mac OS

- In the Finder, click Go > Connect to Server
- In the Server Address enter the following information and click Connect:

- To access your {CLUSTER} home directory, enter ```smb://home.{cluster}.rcac.purdue.edu/{cluster}-home```
- To access your scratch space on {CLUSTER}, enter ```smb://scratch.{cluster}.rcac.purdue.edu/{cluster}-scratch```

!!!note
    Use your career account login name and password when prompted. (You will not need to add ```",push"``` nor use your Purdue MFA client.)

- Your home or scratch directory should now be mounted as a drive in the Computer window.

## Linux

There are several graphical methods to connect in Linux depending on your desktop environment. Once you find out how to connect to a network server on your desktop environment, choose the Samba/SMB protocol and adapt the information from the Mac OS X section to connect.


If you would like access via samba on the command line you may install ```smbclient``` which will give you FTP-like access and can be used as shown below. For all the possible ways to connect look at the Mac OS X instructions.

```smbclient //home.{cluster}.rcac.purdue.edu/{cluster}-home -U boilerad\myusername```

```smbclient //scratch.{cluster}.rcac.purdue.edu/{cluster}-scratch -U boilerad/myusername```

!!!note
    Use your career account login name and password when prompted. (You will not need to add ```",push"``` nor use your Purdue MFA client.)
