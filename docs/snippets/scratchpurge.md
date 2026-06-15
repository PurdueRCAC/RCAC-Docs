<!-- Template snippet: {cluster} = lowercase cluster name (e.g. "{cluster}"). Replaced at build time by `scratch_purge` in main.py. -->
Following good data practices makes scratch more performant and more useful for everyone. By keeping master copies of important data in backed-up storage, staging only the inputs and outputs you need for active jobs into scratch, and promptly moving valuable results back to a persistent location when your work completes, you help keep scratch fast, responsive, and available for high-throughput workloads across the system.

All users of research computing systems are provided with a scratch directory for short-term, high-performance storage of data used by running jobs and workflows. Scratch is temporary space and is not intended for long-term or irreplaceable data. There is no backup service for scratch directories, and files not accessed or modified within the configured age threshold will be removed automatically. In the event of a disk crash or file removal, files in scratch directories are not recoverable.

Important data should always be copied to a backed-up or archival storage system for long-term retention, such as Data Depot or Fortress. Data Depot is storage suitable for active research data, while Fortress is a large, long-term archival system optimized for data that must be saved but is not accessed or used frequently.

**Purge Policy**

Scratch directories are purged on the basis of last **access time** and content **modification time** of an individual file. **Any file not accessed or had content modified in 60 days will be subject to purge.** Changing file metadata, such as file name or permissions, does not protect a file from purging.

!!!warning
    Bulk operations that update metadata or otherwise “touch” large numbers of files without genuine use are discouraged and may result in removal of access.

Purge processes run regularly and may remove any file that is older than the relevant purge age at the time of the run. Files may occasionally remain slightly longer than the nominal age, but they can be deleted at any time once they are eligible. The only safe assumption is that any file older than the purge age may be removed without notice.

**Removal of purge warning emails**

RCAC previously sent warning emails shortly before eligible files were purged from scratch. This notification mechanism is no longer supported and should not be considered an operational safeguard. Users are solely responsible for monitoring and managing their own data in scratch, and data may be deleted due to age at any time, without prior notice.

You can use the `purgelist` command to see a list of all your files which are currently scheduled for removal:

```bash
$ purgelist

The next purge run for scratch file systems is scheduled for Tue Apr 15, 2014.
The following files owned by myusername will be removed from /scratch/{cluster}:

/scratch/{cluster}/myusername/foo
/scratch/{cluster}/myusername/bar
```

Files listed by `purgelist` will be permanently removed on the date shown. Deletion of files begins on the morning of the date shown by `purgelist` shortly after midnight. If you need to keep any of these files, please copy them elsewhere. Remember to account for transfer time of your files and do not wait until the last minute to copy files off scratch space.

**Scratch Space Considerations**

Cluster scratch space is for limited-duration, high-performance storage of data for running jobs or workflows and is not intended for long-term storage of data, applications, or other files. Old data in scratch filesystems is periodically purged to keep the filesystem performant and to ensure space remains available for active work. Scratch filesystems are engineered for capacity and performance and are not protected by backup technology; some types of failures can result in permanent data loss.

If losing a file in scratch would significantly impact your research, that file should have a current copy in a more durable storage location such as Data Depot or Fortress.

**Recommendations**

To use scratch safely and effectively:

* Keep a primary copy in long-term storage.

* Store important data, research results, and software in backed-up or archival storage (e.g., home directory, Data Depot, or Fortress) and only copy working sets into scratch while they are actively in use.

* Stage data into scratch for jobs.

    At the start of a job or workflow, copy required inputs from Data Depot, project space, or Fortress into scratch to take advantage of local performance, rather than running directly from archival locations.

* Automatically copy results back out.

    Add steps to your job scripts or workflows that copy important outputs from scratch back to Data Depot, project space, or Fortress before the job completes (for example, using hsi, htar, or other transfer tools).

* Clean up regularly.

    Remove temporary and intermediate files as part of your job scripts or periodic housekeeping so that only active, necessary data remains on scratch.

* Monitor your usage and file ages.

    Periodically check your scratch usage and, where available, use tools such as `purgelist` to see which files are currently candidates for removal and proactively move or delete them.

* Design workflows assuming purge.

    Assume that scratch can be purged or lost, and that files older than 60 days (or 30 days on Bell) may disappear at any time. Workflows should be able to recreate or re-stage data from Data Depot or Fortress and should not depend on scratch as the only copy of important files.

Please [contact us](https://www.rcac.purdue.edu/help) if you have questions or need assistance in copying your files to a more permanent location such as the [Fortress HPSS Archive](https://www.rcac.purdue.edu/storage/fortress).

**Acceptable Use**

The scratch filesystems are for limited-duration, high-performance storage of data for running jobs or workflows and are explicitly not intended to be used as a long-term storage. Doing so, or engaging in measures to circumvent purging, is adversely affecting all users of the system and is considered a violation of [Acceptable Research Resource Use](#acceptable-purdue-it-research-resource-use).
