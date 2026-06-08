---
tags:
  - Scratch
authors:
  - jin456
search:
  boost: 2
hide: toc
---

# Scratch User Guide

For Scratch, each cluster is assigned a default [Lustre](https://en.wikipedia.org/wiki/Lustre_(file_system)) or [GPFS](https://en.wikipedia.org/wiki/IBM_General_Parallel_File_System) parallel filesystem. The parallel filesystems provide work-area storage optimized for a wide variety of job types, and are designed to perform well with data-intensive computations, while scaling well to large numbers of simultaneous connections.

## Scratch Overview

Scratch currently consists of several redundant, high-availability disk spaces and is a central component of the research system's infrastructure. All scratch tier resources are high-performance, large capacity, and subject to scheduled purging of old files.

Please refer to the user guide section below for using scratch space on specific RCAC cluster:

=== "Anvil"
    [Using scratch space on Anvil](/userguides/anvil/file_management)

=== "Bell"
    [Using scratch space on Bell](/userguides/bell/storage/scratch_space)

=== "Gautschi"
    [Using scratch space on Gautschi](/userguides/gautschi/storage/scratch_space)

=== "Gilbreth"
    [Using scratch space on Gilbreth](/userguides/gilbreth/storage/scratch_space)

=== "Negishi"
    [Using scratch space on Negishi](/userguides/negishi/storage/scratch_space)

=== "Scholar"
    [Using scratch space on Scholar](/userguides/scholar/storage/scratch_space)


!!!danger "Important Tip about Scratch"
    **Files in scratch directories are not backed up or recoverable.** If you accidentally delete a file, old files are purged, or the filesystem crashes, they cannot be restored. All important files should be backed up to the [Fortress HPSS Archive](../fortress/index.md) on a regular basis.

If you need more space in your scratch directories, please submit a ticket via [rcac-help@purdue.edu](mailto:rcac-help@purdue.edu).
