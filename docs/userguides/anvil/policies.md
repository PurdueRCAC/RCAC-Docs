---
tags:
  - Anvil
authors:
  - dane
draft: true
---

{% set resource = "anvil" %}

## Software Installation Request Policy

The Anvil team will go to every reasonable effort to provide a broadly useful set of popular software packages for research cluster users. However, many domain-specific packages that may only be of use to single users or small groups of users are beyond the capacity of staff to fully maintain and support. Please consider the following if you require software that is not available via the module command:

If your lab is the only user of a software package, Anvil staff may recommend that you install your software privately, either in your home directory or in your allocation project space. If you need help installing software, the Anvil support team may be able to provide limited help.
As more users request a particular piece of software, Anvil may decide to provide the software centrally. Matlab, Python (Anaconda), NAMD, GROMACS, and R are all examples of frequently requested and used centrally-installed software.
Python modules that are available through the Anaconda distribution will be installed through it. Anvil staff may recommend you install other Python modules privately.
If you're not sure how your software request should be handled or need help installing software please contact us at [Help Desk.](https://support.access-ci.org/open-a-ticket).

## Helpful Tips

- We will strive to ensure that Anvil serves as a valuable resource to the national research community. We hope that you the user will assist us by making note of the following:
- You share Anvil with thousands of other users, and what you do on the system affects others. Exercise good citizenship to ensure that your activity does not adversely impact the system and the research community with whom you share it. For instance: do not run jobs on the login nodes and do not stress the filesystem.
- Help us serve you better by filing informative help desk tickets. Before submitting a help desk ticket do check what the user guide and other documentation say. Search the internet for key phrases in your error logs; that's probably what the consultants answering your ticket are going to do. What have you changed since the last time your job succeeded?
- **Describe your issue as precisely and completely as you can:** what you did, what happened, verbatim error messages, other meaningful output. When appropriate, include the information a consultant would need to find your artifacts and understand your workflow: e.g. the directory containing your build and/or job script; the modules you were using; relevant job numbers; and recent changes in your workflow that could affect or explain the behavior you're observing.
- **Have realistic expectations.** Consultants can address system issues and answer questions about Anvil. But they can't teach parallel programming in a ticket and may know nothing about the package you downloaded. They may offer general advice that will help you build, debug, optimize, or modify your code, but you shouldn't expect them to do these things for you.
- **Be patient.** It may take a business day for a consultant to get back to you, especially if your issue is complex. It might take an exchange or two before you and the consultant are on the same page. If the admins disable your account, it's not punitive. When the file system is in danger of crashing, or a login node hangs, they don't have time to notify you before taking action.

## Acceptable Purdue IT Research Resource Use

{{ resource_use(resource) }}

## Scratch File Purging

{{ scratch_purge(resource) }}