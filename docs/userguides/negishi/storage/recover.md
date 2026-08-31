---
tags:
  - Negishi
authors:
  - jin456
  - hkashgar
resource: Negishi
search:
  boost: 2
---

# Lost File Recovery

Negishi is protected against accidental file deletion through a series of snapshots taken every night just after midnight. Each snapshot provides the state of your files at the time the snapshot was taken. It does so by storing only the files which have changed between snapshots. A file that has not changed between snapshots is only stored once but will appear in every snapshot. This is an efficient method of providing snapshots because the snapshot system does not have to store multiple copies of every file.

These snapshots are kept for a limited time at various intervals. RCAC keeps nightly snapshots for 7 days, weekly snapshots for 4 weeks, and monthly snapshots for 3 months. This means you will find snapshots from the last 7 nights, the last 4 Sundays, and the last 3 first of the months. Files are available going back between two and three months, depending on how long ago the last first of the month was. Snapshots beyond this are not kept.

**Only files which have been saved during an overnight snapshot are recoverable.** If you lose a file the same day you created it, the file is **not** recoverable because the snapshot system has not had a chance to save the file.

**Snapshots are not a substitute for regular backups.** It is the responsibility of the researchers to back up any important data to the Fortress Archive. Negishi **does** protect against hardware failures or physical disasters through other means however these other means are also **not** substitutes for backups.

Files in scratch directories are not recoverable. Files in scratch directories are not backed up. If you accidentally delete a file, a disk crashes, or old files are purged, they cannot be restored.

Negishi offers several ways for researchers to access snapshots of their files.


* [flost](recover/flost.md)

* [Mac OS X](recover/mac.md)

* [Windows](recover/windows.md)

* [Manual Browsing](recover/manual.md)


[**Back to the Storage section**](../storage.md)
