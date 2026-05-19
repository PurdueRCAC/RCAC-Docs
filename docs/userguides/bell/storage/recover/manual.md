---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Manual Browsing

You may also search through the snapshots by hand on the Bell filesystem if you are not sure what date you lost the file or would like to browse by hand. Snapshots can be browsed from any RCAC resource. If you do not have access to a compute cluster, any Bell user may use an SSH client to connect to `bell.rcac.purdue.edu` and browse from there. The snapshots are located at `/depot/.snapshots` on these resources.

You can also mount the snapshot directory over Samba (or SMB, CIFS) on Windows or Mac OS X. Mount (or map) the snapshot directory in the [same way](../transfer/cifs.md) as you did for your main Bell space substituting the server name and path for `\\datadepot.rcac.purdue.edu\depot\.winsnaps` (Windows) or `smb://datadepot.rcac.purdue.edu/depot/.winsnaps` (Mac OS X).

Once connected to the snapshot directory through SSH or Samba, you will see something similar to this:

Snapshots folders may look slightly differently when accessed via SSH on `bell.rcac.purdue.edu` or via Samba on `datadepot.rcac.purdue.edu`. Here are examples of both.

<table>
  <thead>
    <tr>
      <th style="text-align: center;">SSH to <code>bell.rcac.purdue.edu</code></th>
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
        <img src="/assets/images/userguides/bell/recover-depot_smb_snapshots.png" alt="Bell snapshots via Samba" width="90%">
      </td>
    </tr>
  </tbody>
</table>

Each of these directories is a snapshot of the entire Bell filesystem at the timestamp encoded into the directory name. The format for this timestamp is year, two digits for month, two digits for day, followed by the time of the day.

You may `cd` into any of these directories where you will find the entire Bell filesystem. Use `cd` to continue into your lab's Bell space and then you may browse the snapshot as normal.

If you are browsing these directories over a Samba network drive you can simply drag and drop the files over into your live Data Depot folder.

Once you find the file you are looking for, use `cp` to copy the file back into your lab's live Bell space. **Do not attempt to modify files directly in the snapshot directories.**
