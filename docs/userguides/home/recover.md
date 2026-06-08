---
tags:
  - Home Directory
authors:
  - jin456
search:
  boost: 2
draft: false
---

# Lost File Recovery

Home Directory is protected against accidental file deletion through a series of snapshots taken every night just after midnight. Each snapshot provides the state of your files at the time the snapshot was taken. It does so by storing only the files which have changed between snapshots. A file that has not changed between snapshots is only stored once but will appear in every snapshot. This is an efficient method of providing snapshots because the snapshot system does not have to store multiple copies of every file.

These snapshots are kept for a limited time at various intervals. RCAC keeps nightly snapshots for 7 days, weekly snapshots for 4 weeks, and monthly snapshots for 3 months. This means you will find snapshots from the last 7 nights, the last 4 Sundays, and the last 3 first of the months. Files are available going back between two and three months, depending on how long ago the last first of the month was. Snapshots beyond this are not kept.

**Only files which have been saved during an overnight snapshot are recoverable.** If you lose a file the same day you created it, the file is **not** recoverable because the snapshot system has not had a chance to save the file.

**Snapshots are not a substitute for regular backups.** It is the responsibility of the researchers to back up any important data to the [Fortress Archive](../fortress/index.md). Home Directory **does** protect against hardware failures or physical disasters through other means however these other means are also **not** substitutes for backups.

Home Directory offers several ways for researchers to access snapshots of their files.

## flost

If you know when you lost the file, the easiest way is to use the `flost` command. This tool is available from any RCAC resource. If you do not have access to a compute cluster, any RCAC user may use an SSH client to connect to `data.rcac.purdue.edu` and run this command.

To run the tool you will need to specify the location where the lost file was with the `-w` argument:

```
$ flost -w $HOME
```

If you know more specifically where the lost file was you may provide the full path to that directory.

This tool will prompt you for the date on which you lost the file or would like to recover the file from. If the tool finds an appropriate snapshot it will provide instructions on how to search for and recover the file.

If you are not sure what date you lost the file you may try entering different dates into the `flost` to try to find the file or you may also [manually browse](#manual-browsing) the snapshots as described below.

## Manual Browsing

You may also search through the snapshots by hand on the Home Directory filesystem if you are not sure what date you lost the file or would like to browse by hand. Snapshots can be browsed from any RCAC resource. If you do not have access to a compute cluster, any Home Directory user may use an SSH client to connect to `data.rcac.purdue.edu` and browse from there. The snapshots are located at `/home/.zfs/snapshot` on these resources.

Once connected to the snapshot directory through SSH, you will see something similar to this.

```bash
$ cd /home/.zfs/snapshot
$ ls -l
total 0
drwxrwxrwx 1 root root 0 Jun  8 11:06 zfs-auto-snap_daily-2026-06-02-0000
drwxrwxrwx 1 root root 0 Jun  8 11:06 zfs-auto-snap_daily-2026-06-03-0000
drwxrwxrwx 1 root root 0 Jun  8 11:06 zfs-auto-snap_daily-2026-06-04-0000
drwxrwxrwx 1 root root 0 Jun  8 11:06 zfs-auto-snap_daily-2026-06-05-0000
drwxrwxrwx 1 root root 0 Jun  8 11:06 zfs-auto-snap_daily-2026-06-06-0000
drwxrwxrwx 1 root root 0 Jun  8 11:06 zfs-auto-snap_daily-2026-06-07-0000
drwxrwxrwx 1 root root 0 Jun  8 11:06 zfs-auto-snap_daily-2026-06-08-0000
drwxrwxrwx 1 root root 0 Jun  8 11:06 zfs-auto-snap_monthly-2026-04-01-0010
drwxrwxrwx 1 root root 0 Jun  8 11:06 zfs-auto-snap_monthly-2026-05-01-0010
drwxrwxrwx 1 root root 0 Jun  8 11:06 zfs-auto-snap_monthly-2026-06-01-0010
drwxrwxrwx 1 root root 0 Jun  8 11:06 zfs-auto-snap_weekly-2026-05-18-0005
drwxrwxrwx 1 root root 0 Jun  8 11:06 zfs-auto-snap_weekly-2026-05-25-0005
drwxrwxrwx 1 root root 0 Jun  8 11:06 zfs-auto-snap_weekly-2026-06-01-0005
drwxrwxrwx 1 root root 0 Jun  8 11:06 zfs-auto-snap_weekly-2026-06-08-0005
```

Each of these directories is a snapshot of the entire Home Directory filesystem at the timestamp encoded into the directory name. The format for this timestamp is year, two digits for month, two digits for day, followed by the time of the day.

You may `cd` into any of these directories where you will find the entire Home Directory filesystem. Use `cd` to continue into your home directory and then you may browse the snapshot as normal.

If you are browsing these directories over a Samba network drive you can simply drag and drop the files over into your live home directory folder.

Once you find the file you are looking for, use `cp` to copy the file back into your live home directory. **Do not attempt to modify files directly in the snapshot directories.**