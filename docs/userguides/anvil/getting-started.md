---
tags:
  - Anvil
authors:
  - dane
search:
  boost: 2
---

## Start here

Before you can log in to Anvil, ensure you have:

1. Created your [ACCESS account](https://access-ci.org)
2. Applied for a project
3. Received credits in ACCESS
4. [Transferred your credits to Anvil](https://allocations.access-ci.org/how-to#manage-an-explore-discover-or-accelerate-project)

!!! warning "Anvil account creation"
    Unless you have **transferred** credits onto Anvil, you will not have a valid Anvil username. This will result in errors that may look like: `failed to map user <username@access-cli.com>`. If you are not the PI of the project, ensure the PI has added you to the project and exchanged credits to Anvil.

## Logging in

To Access Anvil, you can login through a variety of ways:

- [ssh](#ssh)
- [ondemand](#ondemand)
- [thinclinc](#thinlinc)

!!! note "Other ways to access Anvil"
    Many other ways exist to access Anvil that piggyback on SSH or other technology. If you use a method not listed here, please note we may be limited in the support we can give for accessing Anvil in such a way.

## SSH

{% set resource = "anvil" %}

{{ ssh_keys_snippet(resource) }}

## OnDemand

Navigate to [Anvil OnDemand](https://ondemand.anvil.rcac.purdue.edu/) and use your ACCESS credentials to login.

## ThinLinc

{% set resource = "anvil" %}

{{ thinlinc_snippet(resource) }}

## Checking Your Balance

Anvil uses Service Units (SUs) as a way to meter our users use of the compute resources. Below is a table to view your current service unit availability, as well as monitory how those service units have been used.

|Tool|Use|
|---|---|
|`mybalance`|Check the allocation usage of your project team.|
|`seff <jobid>`| Show the resource usage of a completed job|
|`jobsu <jobid>`| Show the total service units used for a completed job|

## My Data Locations

By default, you will have access to three different storage locations:

- **/home/<username>:** 25GB of space
- **$PROJECT:** 5TB of space (can request more)
- **$SCRATCH:** 100TB of storage with a 1 million file limit.

See [File Management](file_management.md) for more information.

!!! tip "Storage etiquette"
    We advice not to add virtual environments or any big files to your $HOME directory. Virtual environments can exceed the disk quota limit of home quickly and are often better off stored at your $PROJECT space.

## Submitting your first job

To submit a job, you must use the `#SBATCH` header sections and at a minimum specify:

- `-p` or `--partition`
- `-A` or `--account`

!!! warning "--account"
    If you do not specify an account, you may get unwanted results due to a default `--account` being chosen for you.

```bash
#!/bin/bash
#SBATCH -A cda123456  # account
#SBATCH -p standard   # partition
#SBATCH --nodes=1     # total nodes
#SBATCH --ntasks=1    # total tasks
#SBATCH --cpus-per-task=2
## SBATCH --mem=1G
#SBATCH --job-name example-job-for-anvil
#SBATCH -t 00:05:00   # hh:mm:ss

echo $SLURM_CPUS_PER_TASK
echo 'hi mom! i am using Anvil!!!'
```

## Helpful Tips

We will strive to ensure that Anvil serves as a valuable resource to the national research community. We hope that you the user will assist us by making note of the following:

- You share Anvil with thousands of other users, and what you do on the system affects others. Exercise good citizenship to ensure that your activity does not adversely impact the system and the research community with whom you share it. For instance: do not run jobs on the login nodes and do not stress the filesystem.
- Help us serve you better by filing informative [help desk tickets](https://support.access-ci.org/help-ticket). Before submitting a help desk ticket do check what the user guide and other documentation say. Search the internet for key phrases in your error logs; that's probably what the consultants answering your ticket are going to do. What have you changed since the last time your job succeeded?
- **Describe your issue as precisely and completely as you can:** what you did, what happened, verbatim error messages, other meaningful output. When appropriate, include the information a consultant would need to find your artifacts and understand your workflow: e.g. the directory containing your build and/or job script; the modules you were using; relevant job numbers; and recent changes in your workflow that could affect or explain the behavior you're observing.
- **Have realistic expectations.** Consultants can address system issues and answer questions about Anvil. But they can't teach parallel programming in a ticket and may know nothing about the package you downloaded. They may offer general advice that will help you build, debug, optimize, or modify your code, but you shouldn't expect them to do these things for you.
- **Be patient.** It may take a couple of business days for a consultant to get back to you, especially if your issue is complex. It might take an exchange or two before you and the consultant are on the same page. If the admins disable your account, it's not punitive. When the file system is in danger of crashing, or a login node hangs, they don't have time to notify you before taking action.

## Helpful Tools

The Anvil cluster provides a list of useful auxiliary tools. The following table provides a list of auxiliary tools:

|Tool|Use|
|---|---|
|**`userinfo <username>`**| See all groups you are a part of, as well as storage locations and associated accounts|
|**`myquota`**|	Check the quota of different file systems.|
|**`flost`**|A utility to recover files from snapshots.|
|**`showpartitions`**|Display all Slurm partitions and their current usage.|
|**`mybalance`**|Check the allocation usage of your project team.|

## Next Steps

Please see the rest of our User Guide for more comprehensive information about Anvil.

!!! important "Read our full user guide"
    We **strongly suggest** you read, or at the very least skim through, our whole user guide so you can have answers to questions you may ask in the future.
