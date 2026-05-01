---
tags:
  - Gautschi
authors:
  - jin456
resource: Gautschi
search:
  boost: 2
---

# Windows Network Drive / SMB

SMB (Server Message Block), also known as CIFS, is an easy-to-use file transfer protocol that is useful for transferring files between RCAC systems and a desktop or laptop. You may use SMB to connect to your home, scratch, and Fortress storage directories. The SMB protocol is available on Windows, Linux, and Mac OS X. It is primarily used as a graphical means of transfer, but it can also be used over the command line.

!!!note
    To access Gautschi through SMB file sharing, you must be on a Purdue campus network or connected through [VPN](https://it.purdue.edu/services/vpn.php).

## Windows

- **Windows 10**: Tap the Windows key, type ```computer```, select This PC, click Computer > Map Network Drive in the top bar
- **Windows 11**: Windows 11: Tap the Windows key, type ```File Explorer```, select This PC, click Computer > Map Network Drive in the top bar

    - In the folder location, enter the following information and click Finish:
    - To access your Gautschi home directory, enter ```\\home.gautschi.rcac.purdue.edu\gautschi-home```
    - To access your scratch space on Gautschi, enter ```\\scratch.gautschi.rcac.purdue.edu\gautschi-scratch```
    - Use your career account login name and password when prompted. (You will not need to add ```",push"``` nor use your Purdue Duo client.)
    - Your home or scratch directory should now be mounted as a drive in the Computer window

!!!important
    If you get a credential error and have already restarted your PC, follow these steps to create a manual credential in the Windows Credential Manager:

    - In the Start Menu search bar, type ```Credential Manager```
    
    - In the Credential Manager window, click ```Windows Credentials``` and ```Add New Credential```
    
    - Servername: ```\\home.gautschi.rcac.purdue.edu``` or ```\\scratch.gautschi.rcac.purdue.edu```
    
    - Username: ```boilerad\PurdueLogin```
    
    - Save the credential and try mapping again

## Mac OS

- In the Finder, click Go > Connect to Server
- In the Server Address enter the following information and click Connect:

- To access your Gautschi home directory, enter ```smb://home.gautschi.rcac.purdue.edu/gautschi-home```
- To access your scratch space on Gautschi, enter ```smb://scratch.gautschi.rcac.purdue.edu/gautschi-scratch```

!!!note
    Use your career account login name and password when prompted. (You will not need to add ```",push"``` nor use your Purdue Duo client.)

- Your home or scratch directory should now be mounted as a drive in the Computer window.

## Linux

There are several graphical methods to connect in Linux depending on your desktop environment. Once you find out how to connect to a network server on your desktop environment, choose the Samba/SMB protocol and adapt the information from the Mac OS X section to connect.


If you would like access via samba on the command line you may install ```smbclient``` which will give you FTP-like access and can be used as shown below. For all the possible ways to connect look at the Mac OS X instructions.

```smbclient //home.gautschi.rcac.purdue.edu/gautschi-home -U boilerad\myusername```

```smbclient //scratch.gautschi.rcac.purdue.edu/gautschi-scratch -U boilerad/myusername```

!!!note
    Use your career account login name and password when prompted. (You will not need to add ```",push"``` nor use your Purdue Duo client.)

[**Back to the Storage section**](../storage.md)
