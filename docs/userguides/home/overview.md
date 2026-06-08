---
tags:
  - Home Directory
authors:
  - jin456
search:
  boost: 2
draft: false
---

# Home Overview

Your Home Directory for all RCAC resources is provided by a DDN GS7KX filesystem appliance.

`/home`, the primary space used to permanently hold files for a given user, has a 25 GB quota which can be monitored at any time by using a `myquota` command.

Home Directory spaces currently reside on a self-contained ZFS storage system that provides redundant, high-availability disk space and is a central component of RCAC's research systems infrastructure.

RCAC uses network attached storage (NAS) appliances from DDN to provide scale-out Home Directory space to cluster systems. This storage is reliable, backed-up (via snapshots), and is globally available on all RCAC systems. Your Home Directory is medium-performance, non-purged space suitable for tasks like sharing data, editing files, developing and building software, and many other uses.

!!!note
    Your Home Directory is not designed or intended for use as high-performance working space for running jobs.
