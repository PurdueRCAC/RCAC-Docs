<!-- Template snippet: {CLUSTER} = title-case cluster name, {cluster} = lowercase. Replaced at build time by `recover_manual_snippet` in main.py. -->
# Manual Browsing

You may also search through the snapshots by hand on the {CLUSTER} filesystem if you are not sure what date you lost the file or would like to browse by hand. Snapshots for `/home` and `/depot` (`/scratch` does **NOT** have snapshots) can be browsed from any RCAC resource with the following methods.

=== "Manual browsing lost files in `/home`"
    If you do not have access to a compute cluster, any {CLUSTER} user may use an SSH client to connect to `{cluster}.rcac.purdue.edu` and browse from there. The snapshots are located at `/home/.zfs/snapshot` on these resources.

    Once connected to the snapshot directory through SSH, you will see something similar to this:

    ```bash
    $ cd /home/.zfs/snapshot
    $ ls -l
    total 7072
    drwxr-xr-x 2499 root root 2500 Jun  1 18:20 zfs-auto-snap_daily-2026-06-02-0000
    drwxr-xr-x 2500 root root 2501 Jun  2 18:20 zfs-auto-snap_daily-2026-06-03-0000
    drwxr-xr-x 2501 root root 2502 Jun  3 15:40 zfs-auto-snap_daily-2026-06-04-0000
    drwxr-xr-x 2503 root root 2504 Jun  4 16:40 zfs-auto-snap_daily-2026-06-05-0000
    drwxr-xr-x 2505 root root 2506 Jun  5 11:00 zfs-auto-snap_daily-2026-06-06-0000
    drwxr-xr-x 2505 root root 2506 Jun  5 11:00 zfs-auto-snap_daily-2026-06-07-0000
    drwxr-xr-x 2505 root root 2506 Jun  5 11:00 zfs-auto-snap_daily-2026-06-08-0000
    drwxr-xr-x 2107 root root 2108 Mar 31 21:40 zfs-auto-snap_monthly-2026-04-01-0010
    drwxr-xr-x 2424 root root 2425 Apr 30 09:20 zfs-auto-snap_monthly-2026-05-01-0010
    drwxr-xr-x 2454 root root 2455 May 15 09:00 zfs-auto-snap_weekly-2026-05-18-0005
    drwxr-xr-x 2468 root root 2469 May 23 20:40 zfs-auto-snap_weekly-2026-05-25-0005
    drwxr-xr-x 2496 root root 2497 May 28 15:20 zfs-auto-snap_weekly-2026-06-01-0005
    drwxr-xr-x 2505 root root 2506 Jun  5 11:00 zfs-auto-snap_weekly-2026-06-08-0005
    ```

    Each of these directories is a snapshot of the entire {CLUSTER} `/home` at the timestamp encoded into the directory name. The format for this timestamp is year, two digits for month, two digits for day, followed by the time of the day.

    You may `cd` into any of these directories where you will find the entire {CLUSTER} filesystem. Use `cd` to continue into your home directory on {CLUSTER} and then you may browse the snapshot as normal.

    Once you find the file you are looking for, use `cp` to copy the file back into your live {CLUSTER} home directory. **Do not attempt to modify files directly in the snapshot directories.**

=== "Manual browsing lost files in `/depot`"
    If you do not have access to a compute cluster, any {CLUSTER} user may use an SSH client to connect to `data.rcac.purdue.edu` and browse from there. The snapshots are located at `/depot/.snapshots` on these resources.

    You can also mount the snapshot directory over Samba (or SMB, CIFS) on Windows or Mac OS X. Mount (or map) the snapshot directory in the [same way](../windows_network_drive.md) as you did for your main {CLUSTER} space substituting the server name and path for `\\datadepot.rcac.purdue.edu\depot\.winsnaps` (Windows) or `smb://datadepot.rcac.purdue.edu/depot/.winsnaps` (Mac OS X).

    Once connected to the snapshot directory through SSH or Samba, you will see something similar to this:

    Snapshots folders may look slightly differently when accessed via SSH on `{cluster}.rcac.purdue.edu` or via Samba on `datadepot.rcac.purdue.edu`. Here are examples of both.

    <table>
    <thead>
        <tr>
        <th style="text-align: center;">SSH to <code>{cluster}.rcac.purdue.edu</code></th>
        <th style="text-align: center;">Samba mount on <code>datadepot.rcac.purdue.edu</code></th>
        </tr>
    </thead>
    <tbody>
        <tr>
        <td style="text-align: center;">

    ```text
    $ cd /depot/.snapshots
    $ ls -1
    daily_20190129000501
    daily_20190130000501
    daily_20190131000502
    daily_20190201000501
    daily_20190202000501
    daily_20190203000501
    daily_20190204000501
    monthly_20181101001501
    monthly_20181201001501
    monthly_20190101001501
    monthly_20190201001501
    weekly_20190113002501
    weekly_20190120002501
    weekly_20190127002501
    weekly_20190203002501
    ```

    </td>
        <td style="text-align: center;">
            <img src="/assets/images/userguides/storage_recover_manual.png" alt="{CLUSTER} snapshots via Samba" width="90%">
        </td>
        </tr>
    </tbody>
    </table>

    Each of these directories is a snapshot of the entire {CLUSTER} filesystem at the timestamp encoded into the directory name. The format for this timestamp is year, two digits for month, two digits for day, followed by the time of the day.

    You may `cd` into any of these directories where you will find the entire {CLUSTER} filesystem. Use `cd` to continue into your lab's {CLUSTER} space and then you may browse the snapshot as normal.

    If you are browsing these directories over a Samba network drive you can simply drag and drop the files over into your live Data Depot folder.

    Once you find the file you are looking for, use `cp` to copy the file back into your lab's live {CLUSTER} space. **Do not attempt to modify files directly in the snapshot directories.**

[**Back to the Lost File Recovery section**](../recover.md)
