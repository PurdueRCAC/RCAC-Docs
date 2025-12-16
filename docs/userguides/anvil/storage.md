---
tags:
  - Anvil
authors:
  - jin456
search:
  boost: 2
---

## File Systems

Anvil provides users with separate home, scratch, and project areas for managing files. These will be accessible via the `$HOME`, `$SCRATCH`, `$PROJECT` and `$WORK` environment variables. Each file system is available from all Anvil nodes but has different purge policies and ideal use cases (see table below). Users in the same allocation will share read and write access to the data in the `$PROJECT` space. The project space will be created for each allocation. `$PROJECT` and `$WORK` variables refer to the same location and can be used interchangeably.

`$SCRATCH` is a high-performance, internally resilient GPFS parallel file system with 10 PB of usable capacity, configured to deliver up to 150 GB/s bandwidth. The scratch filesystems are for limited-duration, high-performance storage of data for running jobs or workflows and are explicitly not intended to be used as a long-term storage. Doing so, or engaging in measures to circumvent purging, is adversely affecting all users of the system and is prohibited.

Files in scratch directories are not recoverable. Files in scratch directories are not backed up. **If you accidentally delete a file, a disk crashes, or old files are purged, they cannot be restored.**

Anvil File Systems

| File System | Mount Point | Quota | Snapshots | Purpose | Purge policy |
| --- | --- | --- | --- | --- | --- |
| Anvil ZFS | /home | 25 GB | Full schedule\* | Home directories: area for storing personal software, scripts, compiling, editing, etc. | Not purged |
| Anvil ZFS | /apps | N/A | Weekly\* | Applications |  |
| Anvil GPFS | /anvil | N/A | No |  |  |
| Anvil GPFS | /anvil/scratch | 100 TB | No | User scratch: area for job I/O activity, temporary storage | Files older than 30-day (access time) will be purged |
| Anvil GPFS | /anvil/projects | 5 TB | Full schedule\* | Per allocation: area for shared data in a project, common datasets and software installation | Not purged while allocation is active. Removed 90 days after allocation expiration |
| Anvil GPFS | /anvil/datasets | N/A | Weekly\* | Common data sets (not allocated to users) |  |

\* Full schedule keeps nightly snapshots for 7 days, weekly snapshots for 3 weeks, and monthly snapshots for 2 months.

### Useful tool

To check the quota of different file systems, type `myquota` at the command line.

```
x-anvilusername@login03.anvil:[~] $myquota

Type     Location          Size       Limit      Use     Files    Limit    Use
==============================================================================
home     x-anvilusername   261.5MB    25.0GB     1%       -       -        - 
scratch  anvil             6.3GB      100.0TB    0.01%    3k      1,048k   0.36%
projects accountname1      37.2GB     5.0TB      0.73%    403k    1,048k   39%
projects accountname2      135.8GB    5.0TB      3%       20k     1,048k   2%
```

## Transferring Files

Anvil supports several methods for file transfer to and from the system. Users can transfer files between Anvil and Linux-based systems or Mac using either `scp` or `rsync`. Windows SSH clients typically include scp-based file transfer capabilities.

### SCP

**SCP (Secure CoPy)** is a simple way of transferring files between two machines that use the SSH protocol. SCP is available as a protocol choice in some graphical file transfer programs and also as a command line program on most Linux, Unix, and Mac OS X systems. SCP can copy single files, but will also recursively copy directory contents if given a directory name. [SSH Keys](/knowledge/anvil/access/login/sshkeys) is required for SCP. Following is an example of transferring `test.txt` file from Anvil home directory to your local machine, make sure to use your anvil username `x-anvilusername`:

```
localhost> scp x-anvilusername@anvil.rcac.purdue.edu:/home/x-anvilusername/test.txt .
Warning: Permanently added the xxxxxxx host key for IP address 'xxx.xxx.xxx.xxx' to the list of known hosts.
test.txt                                                                    100%    0     0.0KB/s   00:00
```

### Rsync

**Rsync, or Remote Sync**, is a free and efficient command-line tool that lets you transfer files and directories to local and remote destinations. It allows to copy only the changes from the source and offers customization, use for mirroring, performing backups, or migrating data between different filesystems. [SSH Keys](/knowledge/anvil/access/login/sshkeys) is required for Rsync. Similar to the above SCP example, make sure to use your anvil username `x-anvilusername` here.

### SFTP

*SFTP* (Secure File Transfer Protocol) is a reliable way of transferring files between two machines. SFTP is available as a protocol choice in some graphical file transfer programs and also as a command-line program on most Linux, Unix, and Mac OS X systems. SFTP has more features than SCP and allows for other operations on remote files, remote directory listing, and resuming interrupted transfers. Command-line SFTP cannot recursively copy directory contents; to do so, try using SCP or graphical SFTP client.

Command-line usage:

```

$ sftp -B buffersize x-anvilusername@anvil.rcac.purdue.edu

      (to a remote system from local)
sftp> put sourcefile somedir/destinationfile
sftp> put -P sourcefile somedir/

      (from a remote system to local)
sftp> get sourcefile somedir/destinationfile
sftp> get -P sourcefile somedir/

sftp> exit
```

* **-B**: optional, specify buffer size for transfer; larger may increase speed, but costs memory
* **-P**: optional, preserve file attributes and permissions

Linux / Solaris / AIX / HP-UX / Unix:

* The "sftp" command-line program should already be installed.

Microsoft Windows:

* [MobaXterm](https://mobaxterm.mobatek.net/download.html)  
  Free, full-featured, graphical Windows SSH, SCP, and SFTP client.

Mac OS X:

* The "sftp" command-line program should already be installed. You may start a local terminal window from "Applications->Utilities".
* [Cyberduck](https://cyberduck.io/) is a full-featured and free graphical SFTP and SCP client.

### Globus

**Globus** is a powerful and easy to use file transfer and sharing service for transferring files virtually anywhere. It works between any ACCESS and non-ACCESS sites running Globus, and it connects any of these research systems to personal systems. You may use Globus to connect to your home, scratch, and project storage directories on Anvil. Since Globus is web-based, it works on any operating system that is connected to the internet. The Globus Personal client is available on Windows, Linux, and Mac OS X. It is primarily used as a graphical means of transfer but it can also be used over the command line. More details can be found at  [ACCESS Using Globus](https://access-ci.atlassian.net/wiki/spaces/ACCESSdocumentation/pages/552861697/Using+Globus).

## Lost File Recovery

Your **HOME** and **PROJECTS** directories on Anvil are protected against accidental file deletion through a series of snapshots taken every night just after midnight. Each snapshot provides the state of your files at the time the snapshot was taken. It does so by storing only the files which have changed between snapshots. A file that has not changed between snapshots is only stored once but will appear in every snapshot. This is an efficient method of providing snapshots because the snapshot system does not have to store multiple copies of every file.

These snapshots are kept for a limited time at various intervals. Please refer to [Anvil File Systems](#file-systems) to see the frequency of generating snapshots on different mount points. Anvil keeps nightly snapshots for 7 days, weekly snapshots for 3 weeks, and monthly snapshots for 2 months. This means you will find snapshots from the last 7 nights, the last 3 Sundays, and the last 2 first of the months. Files are available going back between two and three months, depending on how long ago the last first of the month was. Snapshots beyond this are not kept.

**Only files which have been saved during an overnight snapshot are recoverable.** If you lose a file the same day you created it, the file is **not** recoverable because the snapshot system has not had a chance to save the file.

**Snapshots are not a substitute for regular backups.** It is the responsibility of the researchers to back up any important data to long-term storage space. Anvil **does** protect against hardware failures or physical disasters through other means however these other means are also **not** substitutes for backups.

Anvil offers several ways for researchers to access snapshots of their files.

### flost

If you know when you lost the file, the easiest way is to use the `flost` command.

To run the tool you will need to specify the location where the lost file was with the `-w` argument:

```
$ flost -w /home

This script will help you try to recover lost home or group directory contents.
NB: Scratch directories are not backed up and cannot be recovered.

Currently anchoring the search under:  /home
If your lost files were on a different filesystem, exit now with Ctrl-C and
rerun flost with a suitable '-w WHERE' argument (or see 'flost -h' for help).

Please enter the date that you lost your files:  MM/DD/YYYY

The closest recovery snapshot to your date of loss currently available is from
MM/DD/YYYY 12:00am.  First, you will need to SSH to a dedicated
service host zfs.anvil.rcac.purdue.edu, then change your directory
to the snapshot location:
    $ ssh zfs.anvil.rcac.purdue.edu
    $ cd /home/.zfs/snapshot/zfs-auto-snap_daily-YYYY-MM-DD-0000
    $ ls

Then copy files or directories from there back to where they belong:
    $ cp mylostfile /home
    $ cp -r mylostdirectory /home
```

Here is an example of `/home` directory. If you know more specifically where the lost file was you may provide the full path to that directory.

This tool will prompt you for the date on which you lost the file or would like to recover the file from. If the tool finds an appropriate snapshot it will provide instructions on how to search for and recover the file.

If you are not sure what date you lost the file you may try entering different dates into the `flost` to try to find the file or you may also **manually browse** the snapshots in `/home/.zfs/snapshot` folder for **Home** directory and `/anvil/projects/.snapshots` folder for **Projects** directory.