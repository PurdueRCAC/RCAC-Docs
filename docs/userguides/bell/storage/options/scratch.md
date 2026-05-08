---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Scratch Space

{::if resource.name != Weber}

*Scratch directories* are provided for short-term file storage only. The quota of your scratch directory is much greater than the quota of your home directory. You should use your scratch directory for storing temporary input files which your job reads or for writing temporary output files which you may examine after execution of your job. You should use your home directory and Fortress for longer-term storage or for holding critical results. The `hsi` and `htar` commands provide easy-to-use interfaces into the archive and can be used to copy files into the archive interactively or even automatically at the end of your regular job submission scripts.

Files in scratch directories are not recoverable. Files in scratch directories are not backed up. If you accidentally delete a file, a disk crashes, or old files are purged, they cannot be restored.

**Files are purged from scratch directories not accessed or had content modified in {::if resource.name != Bell} 60 {::else} 30 {::/} days.** Owners of these files receive a notice one week before removal via email. Be sure to regularly check your Purdue email account or [set up mail forwarding](https://www.purdue.edu/apps/account/ChangeMailbox) to an email account you do regularly check. For more information, please refer to our [Scratch File Purging Policy](/policies/scratchpurge).

{::else}

*Scratch directories* are provided for short-term file storage only. The quota of your scratch directory is much greater than the quota of your home directory. You should use your scratch directory for storing temporary input files which your job reads or for writing temporary output files which you may examine after execution of your job. You should use your home directory and ${resource.name} long-term storage for holding critical results.

Files in scratch directories are not recoverable. Files in scratch directories are not backed up. If you accidentally delete a file, a disk crashes, or old files are purged, they cannot be restored. Unique among our cluster resources, data are not purged from Weber scratch directories at this time.

{::/}

All users may access scratch directories on ${resource.name}. To find the path to your scratch directory:

```
$ findscratch
{::if resource.letteredscratch == true}${resource.scratch}/${user.usernameletter}/${user.username}{::else}${resource.scratch}/${user.username}{::/}
```

The value of variable $RCAC\_SCRATCH is your scratch directory path. Use this variable in any scripts. Your actual scratch directory path may change without warning, but this variable will remain current.

```
$ echo $RCAC_SCRATCH
{::if resource.letteredscratch == true}${resource.scratch}/${user.usernameletter}/${user.username}{::else}${resource.scratch}/${user.username}{::/}
```

{::if resource.name!= Weber}

Scratch directories are specific per cluster. I.e. only the ${resource.scratch} directory is available on ${resource.name} front-end and compute nodes. No other scratch directories are available on ${resource.name}.

{::/}

**Your scratch directory has a quota capping the total size and number of files you may store in it.** For more information, refer to the section [Storage Quotas / Limits](/knowledge/${resource.dir}/storage/quota).

### Performance

Your scratch directory is located on a high-performance, large-capacity parallel filesystem engineered to provide work-area storage optimized for a wide variety of job types. It is designed to perform well with data-intensive computations, while scaling well to large numbers of simultaneous connections.