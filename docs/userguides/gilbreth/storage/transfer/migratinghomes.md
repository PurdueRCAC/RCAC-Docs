---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

# Migrating Your Current Purdue IT Research Computing Home Directory to the New Gilbreth Home Directory

In an upcoming maintenance, the Gilbreth home directory and its contents will become specific to the Gilbreth and will no longer be available on other RCAC machines. New Gilbreth home directories will be given to all Gilbreth users, and these home directories will be empty. *The new home directories on Gilbreth are already available and are located at `/home-new/$USER`. There will be no automatic copying or synchronization between your current Gilbreth home (also referred to as your main RCAC home directory) and your new Gilbreth home directories*. At your discretion, you can manually copy all or parts of your current Gilbreth home directory to your new Gilbreth home directory using one of the methods described below.

Please note that copying may fail if the size of your main research computing home directory is larger than the new Gilbreth one's quota of 25 GB. Please [check](/knowledge/${resource.hostname}/storage/quota) usage and limits before proceeding!

### Complete copy

For your convenience, a custom tool `copy-rcac-home` is provided to simplify at-will duplication of your main research computing home directory into Gilbreth. The tool performs a complete 1-to-1 copy using `rsync -auH` (with exception of a narrow subset of system-specific service files).

To use the tool, simply type `copy-rcac-home` in a terminal window on a Gilbreth front-end or compute node:

```

$ copy-rcac-home

   This script will copy entire contents of your main RCAC
   home directory into your Gilbreth cluster's $HOME.

   Note: copying may fail if the size of your RCAC home directory
   is larger than your quota on the Gilbreth one (25GB).
   BEFORE PROCEEDING, please run 'myquota' command on another
   cluster to see your usage there and judge whether it would fit!

Would you like to proceed? [Y/n]:
```

At this stage answering `yes` will proceed with copying, or you can respond with a `no` (or `Ctrl-C`) to cancel. See `copy-rcac-home --help` for more details on the tool.

### Partial copy

Desired parts (or whole) of your research computing home directories can be copied to Gilbreth via any of the home directories' supported [transfer methods](/knowledge/${resource.hostname}/storage/transfer), such as SCP, SFTP, rsync, or Globus.

* Example: recursive copying of a subdirectory from your current home directory on Gilbreth into the new Gilbreth home using `scp` and `cp`.

  ```
  
     (if you are on Gilbreth)
  $ cp -pr somedirectory/  /home-new/$USER/
  
     (if you are on another cluster)
  $ scp -pr somedirectory/ $USER@${resource.hostname}.rcac.purdue.edu:/home-new/$USER
  ```
* Example: copying using Globus.

  Search collections for *"Purdue Research Computing - Home Directories"* and *"Purdue Gilbreth Cluster - Home Directories"* endpoints, respectively, then transfer desired files and/or directories as usual. For hidden files such as a `.bashrc` file, you will need to make sure to toggle the "Show Hidden Items" button shown below.

  {::if resource.name == Gilbreth } ![Globus interface](/files/knowledge/globus/Globus_Gilby_Migration_2.png){::/} {::if resource.name == Brown} ![Globus interface](/files/knowledge/globus/Brown-Home-Globus.png){::/}