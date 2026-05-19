---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Windows Network Drive / SMB

*SMB* (Server Message Block), also known as CIFS, is an easy-to-use file transfer protocol that is useful for transferring files between RCAC systems and a desktop or laptop. You may use SMB to connect to your home, scratch, and Fortress storage directories. The SMB protocol is available on Windows, Linux, and Mac OS X. It is primarily used as a graphical means of transfer, but it can also be used over the command line.

!!! Note
    To access Bell through SMB file sharing, you must be on a Purdue campus network or connected through [VPN](http://www.itap.purdue.edu/connections/vpn/).

### Windows:

* Windows 7: Click Windows menu > Computer, then click Map Network Drive in the top bar
* Windows 8 & 10: Tap the Windows key, type `computer`, select This PC, click Computer > Map Network Drive in the top bar
* Windows 11: Tap the Windows key, type `File Explorer`, select This PC, click Computer > Map Network Drive in the top bar
* In the folder location, enter the following information and click Finish:
    + To access your Bell home directory, enter `\\home.bell.rcac.purdue.edu\bell-home`.
    + To access your scratch space on Bell, enter `\\scratch.bell.rcac.purdue.edu\bell-scratch`. Once mapped, you will be able to navigate to your scratch directory.

* Note: Use your career account login name and password when prompted. (You will **not** need to add "`,push`" nor use your Purdue Duo client.)
* Your home or scratch directory should now be mounted as a drive in the Computer window.
* If you have issues mapping the drive check Credential Manager.
    + In the Search bar, type "Credential Manager"
    + Inside Credential Manager, click "Windows Credentials" and "Add New Credential"
    + Servername: `\\home.bell.rcac.purdue.edu`
    + Username: `boilerad\PurdueLogin`
    + Then save it and try mapping again.
        - If there's already an entry for the server you are trying to map delete it.

### Mac OS X:

* In the Finder, click Go > Connect to Server
* In the Server Address enter the following information and click Connect:
    + To access your Bell home directory, enter `smb://home.bell.rcac.purdue.edu/bell-home`.
    + To access your scratch space on Bell, enter `smb://scratch.bell.rcac.purdue.edu/bell-scratch`. Once mapped, you will be able to navigate to your scratch directory.

* Note: Use your career account login name and password when prompted. (You will **not** need to add "`,push`" nor use your Purdue Duo client.)
* Your home or scratch directory should now be mounted as a drive in the Computer window.

### Linux:

* There are several graphical methods to connect in Linux depending on your desktop environment. Once you find out how to connect to a network server on your desktop environment, choose the Samba/SMB protocol and adapt the information from the Mac OS X section to connect.
* If you would like access via samba on the command line you may install `smbclient` which will give you FTP-like access and can be used as shown below. For all the possible ways to connect look at the Mac OS X instructions. 

    ```
    smbclient //home.bell.rcac.purdue.edu/bell-home -U boilerad/myusername
    ```
    ```
    smbclient //scratch.bell.rcac.purdue.edu/bell-scratch -U boilerad/myusername
    ```

!!! Note
    Use your career account login name and password when prompted. (You will **not** need to add "`,push`" nor use your Purdue Duo client.)
