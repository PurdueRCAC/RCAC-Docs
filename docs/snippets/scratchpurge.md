<!-- Template snippet: {cluster} = lowercase cluster name (e.g. "{cluster}"). Replaced at build time by `scratch_purge` in main.py. -->
All users of research computing systems are provided a scratch directory. Research scratch directories are available for short-term storage of files. There is no backup service for scratch directories, and files not accessed or modified in the last **60 days** will be removed. In the event of a disk crash or file removal, files in scratch directories are not recoverable. Please be sure to save copies of all important files elsewhere on a regular basis for long-term storage on the [Fortress HPSS Archive](https://www.rcac.purdue.edu/storage/fortress).

**Purge Policy**

Scratch directories are purged on the basis of last **access time** and content **modification time** of an individual file. **Any file not accessed or had content modified in 60 days will be subject to purge.** Changing file metadata, such as file name or permissions, does not protect a file from purging.

All scratch directories are scanned weekly to identify files subject to purging one week in advance. The owners of those files will receive an email notification that their files in a scratch directory will be removed the following week. Be sure to regularly check your Purdue email account or [set up mail forwarding](https://www.purdue.edu/apps/account/ChangeMailbox) to an email account you do regularly check.

You can use the purgelist command to see a list of all your files which are currently scheduled for removal:

```bash
$ purgelist

The next purge run for scratch file systems is scheduled for Tue Apr 15, 2014.
The following files owned by myusername will be removed from /scratch/{cluster}:

/scratch/{cluster}/myusername/foo
/scratch/{cluster}/myusername/bar
```

Files listed by purgelist will be permanently removed on the date shown. Deletion of files begins on the morning of the date shown by purgelist shortly after midnight. If you need to keep any of these files, please copy them elsewhere. Remember to account for transfer time of your files and do not wait until the last minute to copy files off scratch space.

**Scratch Space Considerations**

It is important to keep in mind that cluster scratch space is for limited-duration, high-performance storage of data for running jobs or workflows. Old data in scratch filesystems is occasionally purged to keep the filesystem from being fragmented or filling up. Scratch is intended to be a space in which to run your jobs, and not used as long-term storage of data, applications, or other files.

Please keep in mind that any scratch filesystem is engineered for capacity and high performance, and are not protected from any kind of data loss by any backup technology. While research computing scratch filesystems are engineered to be fault-tolerant and reliable, some types of failures can result in data loss.

**Recommendations**

RCAC recommends that important data, research results, and other important files be permanently stored in the [Fortress HPSS Archive](https://www.rcac.purdue.edu/storage/fortress), and copied to scratch spaces while being actively worked on. The hsi and htar commands provide easy-to-use interfaces into the archive and can be used to copy files into the archive interactively or even automatically at the end of your regular job submission scripts. Making frequent copies of your files will minimize work required when these files eventually become subject to purge, as well as protect your work in the unlikely event of a scratch system failure.

Please [contact us](https://www.rcac.purdue.edu/help) if you have questions or need assistance in copying your files to a more permanent location such as the [Fortress HPSS Archive](https://www.rcac.purdue.edu/storage/fortress).

**Acceptable Use**

The scratch filesystems are for limited-duration, high-performance storage of data for running jobs or workflows and are explicitly not intended to be used as a long-term storage. Doing so, or engaging in measures to circumvent purging, is adversely affecting all users of the system and is considered a violation of [Acceptable Research Resource Use](#acceptable-purdue-it-research-resource-use).
