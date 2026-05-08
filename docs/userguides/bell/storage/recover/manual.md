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

You may also search through the snapshots by hand on the ${resource.name} filesystem if you are not sure what date you lost the file or would like to browse by hand. Snapshots can be browsed from any RCAC resource. If you do not have access to a compute cluster, any ${resource.name} user may use an SSH client to connect to `${resource.hostname}.rcac.purdue.edu` and browse from there. The snapshots are located at `/depot/.snapshots` on these resources.

You can also mount the snapshot directory over Samba (or SMB, CIFS) on Windows or Mac OS X. Mount (or map) the snapshot directory in the [same way](/knowledge/${resource.dir}/storage/transfer/cifs) as you did for your main ${resource.name} space substituting the server name and path for `\\datadepot.rcac.purdue.edu\depot\.winsnaps` (Windows) or `smb://datadepot.rcac.purdue.edu/depot/.winsnaps` (Mac OS X).

Once connected to the snapshot directory through SSH or Samba, you will see something similar to this:

Snapshots folders may look slightly differently when accessed via SSH on `${resource.hostname}.rcac.purdue.edu` or via Samba on `datadepot.rcac.purdue.edu`. Here are examples of both.

| SSH to `${resource.hostname}.rcac.purdue.edu` | Samba mount on `datadepot.rcac.purdue.edu` |
| --- | --- |
| ```  $ cd /depot/.snapshots $ ls -1 daily_20190129000501 daily_20190130000501 daily_20190131000502 daily_20190201000501 daily_20190202000501 daily_20190203000501 daily_20190204000501 monthly_20181101001501 monthly_20181201001501 monthly_20190101001501 monthly_20190201001501 weekly_20190113002501 weekly_20190120002501 weekly_20190127002501 weekly_20190203002501 ``` | ${resource.name} snapshots via Samba |

Each of these directories is a snapshot of the entire ${resource.name} filesystem at the timestamp encoded into the directory name. The format for this timestamp is year, two digits for month, two digits for day, followed by the time of the day.

You may `cd` into any of these directories where you will find the entire ${resource.name} filesystem. Use `cd` to continue into your lab's ${resource.name} space and then you may browse the snapshot as normal.

If you are browsing these directories over a Samba network drive you can simply drag and drop the files over into your live Data Depot folder.

Once you find the file you are looking for, use `cp` to copy the file back into your lab's live ${resource.name} space. **Do not attempt to modify files directly in the snapshot directories.**