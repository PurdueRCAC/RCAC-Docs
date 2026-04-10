---
tags:
  - Gautschi
authors:
  - jin456
resource: Gautschi
search:
  boost: 2
---

Some limits are imposed on your disk usage on research systems. A quota is implemented on each filesystem. Each filesystem (home directory, scratch directory, etc.) may have a different limit. If you exceed the quota, you will not be able to save new files or new data to the filesystem until you delete or move data to long-term storage.

## Checking Quota

To check the current quotas of your home and scratch directories use the ```myquota``` command:

```bash
$ myquota
Type        Filesystem          Size    Limit  Use         Files    Limit  Use
==============================================================================
home        myusername         5.0GB   25.0GB  20%             -        -   -
scratch     gautschi        220.7GB  100.0TB  0.22%            8k   2,000k  0.43%
```

The columns are as follows:

- Type: indicates home or scratch directory or your depot space.
- Filesystem: name of storage option.
- Size: sum of file sizes in bytes.
- Limit: allowed maximum on sum of file sizes in bytes.
- Use: percentage of file-size limit currently in use.
- Files: number of files and directories (not the size).
- Limit: allowed maximum on number of files and directories. It is possible, though unlikely, to reach this limit and not the file-size limit if you create a large number of very small files.
- Use: percentage of file-number limit currently in use.

If you find that you reached your quota in either your home directory or your scratch file directory, obtain estimates of your disk usage. Find the top-level directories which have a high disk usage, then study the subdirectories to discover where the heaviest usage lies.

To see in a human-readable format an estimate of the disk usage of your top-level directories in your home directory:

```bash
$ du -h --max-depth=1 $HOME >myfile
32K     /home/myusername/mysubdirectory_1
529M    /home/myusername/mysubdirectory_2
608K    /home/myusername/mysubdirectory_3
```

The second directory is the largest of the three, so apply command ```du``` to it.

To see in a human-readable format an estimate of the disk usage of your top-level directories in your scratch file directory:

```bash
$ du -h --max-depth=1 $RCAC_SCRATCH >myfile
160K    /scratch/gautschi/myusername
```

This strategy can be very helpful in figuring out the location of your largest usage. Move unneeded files and directories to long-term storage to free space in your home and scratch directories.

## Increasing Quota
### Home Directory

If you find you need additional disk space in your home directory, please consider archiving and compressing old files and moving them to long-term storage on the Fortress HPSS Archive, or purchase the Depot space for long-term storage. Unfortunately, it is not possible to increase your home directory quota beyond it's current level.

### Scratch Space

If you find you need additional disk space in your scratch space, please first consider archiving and compressing old files and moving them to long-term storage on the Fortress HPSS Archive. If you are unable to do so, you may ask for a quota increase by contacting support.

[**Back to the Storage section**](../storage.md)