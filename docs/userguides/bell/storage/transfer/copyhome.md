---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Copying files from Purdue IT research computing home directory to Bell

The Bell home directory and its contents are specific to the Bell cluster, and are not available on other RCAC machines. For people having access to other Community Clusters and Bell, *there is no automatic copying or synchronization between main and Bell home directories*. At your discretion, you can manually copy all or parts of your main research computing home to Bell using one of the methods described below.

Please note that copying may fail if the size of your research computing home directory is larger than the Bell one's quota. Please [check](../quota.md) usage and limits before proceeding!

## Complete copy

For your convenience, a custom tool `copy-rcac-home` is provided to simplify at-will duplication of your main research computing home directory into Bell. The tool performs a complete 1-to-1 copy using `rsync -auH` (with exception of a narrow subset of system-specific service files).

To use the tool, simply type `copy-rcac-home` in a terminal window on a Bell front-end or compute node:

```

$ copy-rcac-home

   This script will copy entire contents of your main RCAC
   home directory into your Bell cluster's $HOME.

   Note: copying may fail if the size of your RCAC home directory
   is larger than your quota on the Bell one (25GB).
   BEFORE PROCEEDING, please run 'myquota' command on another
   cluster to see your usage there and judge whether it would fit!

Would you like to proceed? [Y/n]:
```

At this stage answering `yes` will proceed with copying, or you can respond with a `no` (or `Ctrl-C`) to cancel. See `copy-rcac-home --help` for more details on the tool.

## Partial copy

Desired parts (or whole) of your research computing home directories can be copied to Bell via any of the home directories' supported [transfer methods](../transfer.md), such as SCP, SFTP, rsync, or Globus.

* **Example:** recursive copying of a subdirectory from RCAC home directory into Bell home using `scp`.

    ```
    
      (if you are on Bell, use other cluster name for the remote part)
    $ scp -pr myothercluster.rcac.purdue.edu:somedirectory/  ~/
    
      (if you are on another cluster, use Bell for the remote part)
    $ scp -pr somedirectory/ myusername@bell.rcac.purdue.edu:~/
    ```

* **Example:** copying using Globus.

    Search collections for *"Purdue Research Computing - Home Directories"* and * "Purdue Bell Cluster - Home" * endpoints, respectively, then transfer desired files and/or directories as usual.

[**Back to the File Transfer section**](../transfer.md)
