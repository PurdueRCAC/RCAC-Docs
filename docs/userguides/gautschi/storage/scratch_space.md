---
tags:
  - Gautschi
authors:
  - jin456
resource: Gautschi
search:
  boost: 2
---

Scratch directories are provided for short-term file storage only. The quota of your scratch directory is much greater than the quota of your home directory. You should use your scratch directory for storing temporary input files which your job reads or for writing temporary output files which you may examine after execution of your job. You should use your home directory and Fortress for longer-term storage or for holding critical results. The ```hsi``` and ```htar``` commands provide easy-to-use interfaces into the archive and can be used to copy files into the archive interactively or even automatically at the end of your regular job submission scripts.

!!!warning
    Files in scratch directories are **not recoverable**. Files in scratch directories are **not backed up**. If you accidentally delete a file, a disk crashes, or old files are purged, they **cannot be restored**.

!!!warning
    Files that have not been accessed or had content modified in 60 days **are purged**. For more information, please refer to our [Scratch File Purging Policy PLACEHOLDER]().

All users may access scratch directories on Gautschi. To find the path to your scratch directory:

```bash
$ findscratch
/scratch/gautschi/myusername
```

The value of variable ```$RCAC_SCRATCH``` is your scratch directory path. Use this variable in any scripts. Your actual scratch directory path may change without warning, but this variable will remain current.

```bash
$ echo $RCAC_SCRATCH
/scratch/gautschi/myusername
```

!!!note
    Scratch directories are specific per cluster. I.e. only the /scratch/gautschi directory is available on Gautschi front-end and compute nodes. No other scratch directories are available on Gautschi.

**Your scratch directory has a quota capping the total size and number of files you may store in it.** For more information, refer to the section [Storage Quotas / Limits](storage_quota.md).

## Performance

Your scratch directory is located on a high-performance, large-capacity parallel filesystem engineered to provide work-area storage optimized for a wide variety of job types. It is designed to perform well with data-intensive computations, while scaling well to large numbers of simultaneous connections.

[**Back to the Storage section**](../storage.md)
