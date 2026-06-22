---
tags:
  - Data Depot
authors:
  - jin456
search:
  boost: 2
draft: false
---

# Manual Browsing

You may also search through the snapshots by hand on the Data Depot filesystem if you are not sure what date you lost the file or would like to browse by hand. Snapshots can be browsed from any RCAC resource. If you do not have access to a compute cluster, any Data Depot user may use an SSH client to connect to `datadepot.rcac.purdue.edu` and browse from there. The snapshots are located at `/depot/.snapshots` on these resources.

You can also mount the snapshot directory over Samba (or SMB, CIFS) on Windows or Mac OS X. Mount (or map) the snapshot directory in the [same way](../storage/transfer.md#windows-network-drive--smb) as you did for your main Data Depot space substituting the server name and path for `\\datadepot.rcac.purdue.edu\depot\.winsnaps` (Windows) or `smb://datadepot.rcac.purdue.edu/depot/.winsnaps` (Mac OS X).

Once connected to the snapshot directory through SSH or Samba, you will see something similar to this. Snapshots folders may look slightly differently when accessed via SSH on `datadepot.rcac.purdue.edu` or via Samba on `datadepot.rcac.purdue.edu`. Here are examples of both.

| SSH to `datadepot.rcac.purdue.edu` | Samba mount on `datadepot.rcac.purdue.edu` |
|---|---|
| ![Listing Depot Snapshots](/assets/images/userguides/storage/depot_snapshots_ls.png) | ![Depot Snapshots in SMB](/assets/images/userguides/storage/depot_smb_snapshots.png) |

Each of these directories is a snapshot of the entire Data Depot filesystem at the timestamp encoded into the directory name. The format for this timestamp is year, two digits for month, two digits for day, followed by the time of the day.

You may `cd` into any of these directories where you will find the entire Data Depot filesystem. Use `cd` to continue into your lab's Data Depot space and then you may browse the snapshot as normal.

If you are browsing these directories over a Samba network drive you can simply drag and drop the files over into your live Data Depot folder.

Once you find the file you are looking for, use `cp` to copy the file back into your lab's live Data Depot space. **Do not attempt to modify files directly in the snapshot directories.**
