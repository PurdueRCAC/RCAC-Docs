<!-- Template snippet: {CLUSTER} = title-case cluster name, {cluster} = lowercase. Replaced at build time by `recover_flost_snippet` in main.py. -->
# flost

If you know when you lost the file, the easiest way is to use the `flost` command. This tool is available from any RCAC resource. If you do not have access to a compute cluster, any {CLUSTER} user may use an SSH client to connect to `{cluster}.rcac.purdue.edu` and run this command.

To run the tool you will need to specify the location where the lost file was with the `-w` argument:

```
$ flost -w /your/location
```

!!!note
    Only `/home` and `/depot/` folders have backups across RCAC resources. If you know more specifically where the lost file was you may provide the full path to that directory.

Here is an example to run `flost` for your `/home` or `/depot` space.

=== "Using `flost` on `/home`"
    ```bash
    $ flost -w $HOME

    This script will help you try to recover lost home or group directory contents.
    NB: Scratch directories are not backed up and cannot be recovered.

    Currently anchoring the search under:  $HOME
    If your lost files were on a different filesystem, exit now with Ctrl-C and
    rerun flost with a suitable '-w WHERE' argument (or see 'flost -h' for help).

    Please enter the date that you lost your files:  2026-05-01

    The closest recovery snapshot to your date of loss currently available is from
    May 1, 2026 12:10am.  First, change your directory to that location:
        $ cd /home/.zfs/snapshot/zfs-auto-snap_monthly-2026-05-01-0010/username
        $ ls

    Then copy files or directories from there back to where they belong:
        $ cp mylostfile $HOME
        $ cp -r mylostdirectory $HOME
    ```

=== "Using `flost` on `/depot`"
    ```bash
    $ flost -w /depot/yourlab

    This script will help you try to recover lost home or group directory contents.
    NB: Scratch directories are not backed up and cannot be recovered.

    Currently anchoring the search under:  /depot/yourlab
    If your lost files were on a different filesystem, exit now with Ctrl-C and
    rerun flost with a suitable '-w WHERE' argument (or see 'flost -h' for help).

    Please enter the date that you lost your files:  2026-05-01

    The closest recovery snapshot to your date of loss currently available is from
    May 1, 2026 1:15am.  First, change your directory to that location:
        $ cd /depot/.snapshots/@GMT-2026.05.01-05.15.00/yourlab
        $ ls

    Then copy files or directories from there back to where they belong:
        $ cp mylostfile /depot/yourlab
        $ cp -r mylostdirectory /depot/yourlab
    ```

This tool will prompt you for the date on which you lost the file or would like to recover the file from. If the tool finds an appropriate snapshot it will provide instructions on how to search for and recover the file.

!!!info "`flost` requires a date"
    This tool will prompt you for the date on which you lost the file or would like to recover the file from. If the tool finds an appropriate snapshot it will provide instructions on how to search for and recover the file.

If you are not sure what date you lost the file you may try entering different dates into the `flost` to try to find the file or you may also [manually browse](manual.md) the snapshots as described below.

