---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Frequently Asked Questions

Some common questions, errors, and problems are categorized below. You can also use the search box above to search the user guide for any issues you are seeing.

## About Bell

### Can you remove me from the Bell mailing list?

Your subscription in the Bell mailing list is tied to your account on Bell. If you are no longer using your account on Bell, your account can be deleted from the [My Accounts](https://www.rcac.purdue.edu/account/myinfo) page. Hover over the resource you wish to remove yourself from and click the red 'X' button. Your account and mailing list subscription will be removed overnight. Be sure to make a copy of any data you wish to keep first.

### How is Bell different than other Community Clusters?

Bell differs from the previous Community Clusters in several significant aspects:

* Bell home directories are entirely separate from other Community Clusters home directories. There is no automatic copying or synchronization between the two. At their discretion, users can copy parts or all of the Community Clusters home directory into Bell. [Instructions are provided](storage.md#file-transfer).
* Users of `hsi` and `htar` commands may encounter Fortress keytab- and authentication-related error messages due to the dedicated nature of Bell home directories. A [temporary workaround is provided](#hsihtar-unable-to-authenticate-user-with-remote-gateway-error-2-or-9) while a permanent solution is being developed.
* Bell contains the latest generation of AMD EPYC processors, codenamed "Rome". These CPUs support AVX2 vector instructions set. When compiling your code, use of `-march=znver2` flag (for latest GCC, Clang and AOCC compilers) or `-march=core-avx2` (for Intel compilers and GCC prior to 9.3) is recommended.
* If your application heavily uses Intel MKL routines, setting the following environment variable is beneficial:

  ```
  export MKL_DEBUG_CPU_TYPE=5
  ```

  When using FFTW interface from MKL, please also set:

  ```
  export MKL_CBWR=AUTO
  ```

* If you use Jupyter notebooks, JupyterHub on Bell will only be available via the [OnDemand Gateway](https://gateway.bell.rcac.purdue.edu) rather than the freestanding version as on previous systems. Other RCAC systems will transition to OnDemand as well, following Bell.
* A subset of Bell compute nodes contain AMD Instinct MI50 accelerator cards which can significantly improve performance of compute-intensive workloads. These can be utilized by submitting jobs to the `gpu` partition.
* A selection of GPU-enabled ROCm application containers from the AMD InfinityHub collection is installed.

### Do I need to do anything to my firewall to access Bell?

No firewall changes are needed to access Bell. However, to access data through Network Drives (i.e., CIFS, "Z: Drive"), you must be on a Purdue campus network or connected through [VPN](http://www.itap.purdue.edu/connections/vpn/).

### Does Bell have the same home directory as other clusters?

The Bell home directory and its contents are exclusive to Bell cluster front-end hosts and compute nodes. This home directory is not available on other RCAC machines but Bell. There is no automatic copying or synchronization between home directories.

At your discretion you can manually copy all or parts of your main research computing home to Bell using one of the [suggested methods](storage.md#file-transfer).

If you plan to use `hsi` or `htar` commands to access Fortress tape archive from Bell, please see also the [keytab generation question](#hsihtar-unable-to-authenticate-user-with-remote-gateway-error-2-or-9) for a temporary workaround to a potential caveat, while a permanent mitigation is being developed.

## Logging In & Accounts

### /usr/bin/xauth: error in locking authority file

#### Problem

I receive this message when logging in:

`/usr/bin/xauth: error in locking authority file`

#### Solution

Your home directory disk quota is full. You may check your quota with `myquota`.

You will need to free up space in your home directory.

`ncdu` command is a convenient interactive tool to examine disk usage. Consider running `ncdu $HOME` to analyze where the bulk of the usage is. With this knowledge, you could then archive your data elsewhere (e.g. your research group's Data Depot space, or Fortress tape archive), or delete files you no longer need.

There are several common locations that tend to grow large over time and are merely cached downloads. The following are safe to delete if you see them in the output of `ncdu $HOME`:

```
/home/myusername/.local/share/Trash
/home/myusername/.cache/pip
/home/myusername/.conda/pkgs
/home/myusername/.apptainer/cache
```

### My SSH connection hangs

#### Problem

Your console hangs while trying to connect to a RCAC Server.

#### Solution

This can happen due to various reasons. Most common reasons for hanging SSH terminals are:

* **Network:** If you are connected over wifi, make sure that your Internet connection is fine.
* **Busy front-end server:** When you connect to a cluster, you SSH to one of the front-end login nodes. Due to transient user loads, one or more of the front-ends may become unresponsive for a short while. To avoid this, try reconnecting to the cluster or wait until the login node you have connected to has reduced load.
* **File system issue:** If a server has issues with one or more of the file systems (`home`, `scratch`, or `depot`) it may freeze your terminal. To avoid this you can connect to another front-end.

If neither of the suggestions above work, please [contact support](https://www.rcac.purdue.edu/help) specifying the name of the server where your console is hung.

### ThinLinc session frozen

#### Problem

Your ThinLinc session is frozen and you can not launch any commands or close the session.

#### Solution

This can happen due to various reasons. The most common reason is that you ran something memory-intensive inside that ThinLinc session on a front-end, so parts of the ThinLinc session got killed by Cgroups, and the entire session got stuck.

* **If you are using a web-version ThinLinc remote desktop (inside the browser):**

  The web version does not have the capability to kill the existing session, only the standalone client does. Please install the standalone client and follow the steps below:

  [ThinLinc](accounts.md#thinlinc)

* **If you are using a ThinLinc client:**

  Close the ThinLinc client, reopen the client login popup, and select `End existing session`.

  <p style="text-align: center;">
    <img src="/assets/images/userguides/thinlinc4.png" alt="ThinLinc Login Popup" width="80%">
  </p>

  Select "End existing session" and try "Connect" again.

### ThinLinc session unreachable

#### Problem

When trying to login to ThinLinc and re-connect to your existing session, you receive an error *"Your ThinLinc session is currently unreachable"*.

#### Solution

This can happen if the specific login node your existing remote desktop session was residing on is currently offline or down, so ThinLinc can not reconnect to your existing session. Most often the session is non-recoverable at this point, so the solution is to terminate your existing ThinLinc desktop session and start a new one.

* **If you are using a web-version ThinLinc remote desktop (inside the browser):**

  The web version does not have the capability to kill the existing session, only the standalone client does. Please install the standalone client and follow the steps below:

  [ThinLinc](accounts.md#thinlinc)

* **If you are using a ThinLinc client:**

  Close the ThinLinc client, reopen the client login popup, and select `End existing session`.

  <p style="text-align: center;">
    <img src="/assets/images/userguides/thinlinc4.png" alt="ThinLinc Login Popup" width="80%">
  </p>

  Select "End existing session" and try "Connect" again.

### How to disable ThinLinc screensaver

#### Problem

Your ThinLinc desktop is locked after being idle for a while, and it asks for a password to refresh it. It means the "screensaver" and "lock screen" functions are turned on, but you want to disable these functions.

#### Solution

If your screen is locked, close the ThinLinc client, reopen the client login popup, and select `End existing session`.

<p style="text-align: center;">
  <img src="/assets/images/userguides/thinlinc4.png" alt="ThinLinc Login Popup" width="80%">
</p>

Select "End existing session" and try "Connect" again.

To permanently avoid screen lock issue, right click desktop and select `Applications`, then `settings`, and select `Screensaver`.

<p style="text-align: center;">
  <img src="/assets/images/userguides/thinlinc5.png" alt="ThinLinc Screensaver" width="80%">
</p>

Select "Applications", then "settings", and select "Screensaver".

Under **Screensaver**, turn off the `Enable Screensaver`, then under **Lock Screen**, turn off the `Enable Lock Screen`, and close the window.

<p style="text-align: center;">
  <img src="/assets/images/userguides/thinlinc6.png" alt="ThinLinc Disable Screensaver" width="80%">
</p>

Under "Screensaver" tab, turn off the "Enable Screensaver" option.

<p style="text-align: center;">
  <img src="/assets/images/userguides/thinlinc7.png" alt="ThinLinc Disable Lock Screen" width="80%">
</p>

Under "Lock Screen" tab, turn off the "Enable Lock Screen" option.

### I worked on Bell after I graduated/left Purdue, but can not access it anymore

#### Problem

You have graduated or left Purdue but continue collaboration with your Purdue colleagues. You find that your access to Purdue resources has suddenly stopped and your password is no longer accepted.

#### Solution

Access to all resources depends on having a valid Purdue Career Account. Expired Career Accounts are removed twice a year, during Spring and October breaks (more details at the [official page](https://www.purdue.edu/apps/account/IAMO/Purdue_CareerAccount_Expiration.jsp)). If your Career Account was purged due to expiration, you will not be be able to access the resources.

To provide remote collaborators with valid Purdue credentials, the University provides a special procedure called [Request for Privileges (R4P)](https://www.purdue.edu/apps/account/r4p). If you need to continue your collaboration with your Purdue PI, the PI will have to submit or renew an R4P request on your behalf.

After your R4P is completed and Career Account is restored, please note two additional necessary steps:

* **Access:** Restored Career Accounts by default do **not** have any RCAC resources enabled for them. **Your PI will have to login to the [Manage Users](https://www.rcac.purdue.edu/account/groups) tool and explicitly re-enable your access by un-checking and then ticking back checkboxes for desired queues/Unix groups resources.**
* **Email:** Restored Career Accounts by default do **not** have their *@purdue.edu* email service enabled. While this does not preclude you from using RCAC resources, any email messages (be that generated on the clusters, or any service announcements) would not be delivered - which may cause inconvenience or loss of compute jobs. To avoid this, we recommend setting your restored *@purdue.edu* email service to "Forward" (to an actual address you read). The easiest way to ensure it is to go through the [Account Setup process](https://www.purdue.edu/apps/account/AccountSetup).

## Jobs

### cannot connect to X server / cannot open display

#### Problem

You receive the following message after entering a command to bring up a graphical window

`cannot connect to X server` `cannot open display`

#### Solution

This can happen due to multiple reasons:

1. Reason: Your SSH client software does not support graphical display by itself (e.g. SecureCRT or PuTTY).
   * Solution: Try using a client software like ThinLinc or MobaXterm as described in the [SSH X11 Forwarding guide](accounts.md#ssh-x11-forwarding).
2. Reason: You did not enable X11 forwarding in your SSH connection.

   * Solution: If you are in a Windows environment, make sure that X11 forwarding is enabled in your connection settings (e.g. in MobaXterm or PuTTY). If you are in a Linux environment, try

     `ssh -Y -l username hostname`

3. Reason: If you are trying to open a graphical window within an interactive PBS job, make sure you are using the `-X` option with `qsub` after following the previous step(s) for connecting to the front-end. Please see the example in the [Interactive Jobs guide](run/examples/slurm/interactive.md).
4. Reason: If none of the above apply, make sure that you are [within quota of your home directory](#usrbinxauth-error-in-locking-authority-file).

### bash: command not found

#### Problem

You receive the following message after typing a command

`bash: command not found`

#### Solution

This means the system doesn't know how to find your command. Typically, you need to load a module to do it.

### bash: module command not found

#### Problem

You receive the following message after typing a command, e.g. module load intel

`bash: module command not found`

#### Solution

The system cannot find the module command. You need to source the modules.sh file as below

`source /etc/profile.d/modules.sh`

or

`#!/bin/bash -i`

### Close Firefox / Firefox is already running but not responding

--8<-- "docs/snippets/firefox_lock.md"

### Jupyter: database is locked / can not load notebook format

--8<-- "docs/snippets/jupyter_lock.md"

### How do I know Non-uniform Memory Access (NUMA) layout on Bell?

* You can learn about processor layout on Bell nodes using the following command:

  ```
  bell-a003:~$ lstopo-no-graphics
  ```

* For detailed IO connectivity:

  ```
  bell-a003:~$ lstopo-no-graphics --physical --whole-io
  ```

* Please note that NUMA information is useful for advanced MPI/OpenMP/GPU optimizations. For most users, using default NUMA settings in MPI or OpenMP would give you the best performance.

### Why cannot I use --mem=0 when submitting jobs?

#### Question

Why can't I specify `--mem=0` for my job?

#### Answer

We no longer support requesting unlimited memory (`--mem=0`) as it has an adverse effect on the way scheduler allocates job, and could lead to large amount of nodes being blocked from usage.

!!! note
    Most often we suggest relying on default memory allocation (cluster-specific). But if you have to request custom amounts of memory, you can do it explicitly. For example `--mem=20G`.

If you want to use the entire node's memory, you can submit the job with the `--exclusive` option.

### Can I extend the walltime on a job?

In some circumstances, yes. Walltime extensions must be requested of and completed by staff. Walltime extension requests will be considered on named (your advisor or research lab) queues. **Standby or debug queue jobs cannot be extended**.

Extension requests are at the discretion of staff based on factors such as any upcoming maintenance or resource availability. Extensions can be made past the normal maximum walltime on named queues but these jobs are subject to early termination should a conflicting maintenance downtime be scheduled.

Please be mindful of time remaining on your job when making requests and make requests at least 24 hours before the end of your job AND during business hours. We cannot guarantee jobs will be extended in time with less than 24 hours notice, after-hours, during weekends, or on a holiday.

We ask that you make accurate walltime requests during job submissions. Accurate walltimes will allow the job scheduler to efficiently and quickly schedule jobs on the cluster. Please consider that extensions can impact scheduling efficiency for all users of the cluster.

Requests can be made by [contacting support](https://www.rcac.purdue.edu/help). We ask that you:

* Provide numerical job IDs, cluster name, and your desired extension amount.
* Provide at least 24 hours notice before job will end (more if request is made on a weekend or holiday).
* Consider making requests during business hours. We may not be able to respond in time to requests made after-hours, on a weekend, or on a holiday.

## Data

### How is my Data Secured on Bell?

Bell is operated in line with policies, standards, and best practices as described within [Secure Purdue](https://www.purdue.edu/securepurdue), and specific to [RCAC Resources](https://www.rcac.purdue.edu/policies).

Security controls for Bell are based on ones defined in NIST cybersecurity standards.

Bell supports research at the L1 fundamental and L2 sensitive levels.
Bell is not approved for storing data at the L3 restricted (covered by HIPAA) or L4 Export Controlled (ITAR), or any Controlled Unclassified Information (CUI).

For resources designed to support research with heightened security requirements, please look for resources within the [REED+ Ecosystem](https://www.rcac.purdue.edu/services/reedplus).

### Can I share data with outside collaborators?

Yes! Globus allows convenient sharing of data with outside collaborators. Data can be shared with collaborators' personal computers or directly with many other computing resources at other institutions. See the Globus documentation on how to share data:

* <https://docs.globus.org/how-to/share-files/>

### HSI/HTAR: Unable to authenticate user with remote gateway (error 2 or 9)

There could be a variety of such errors, with wordings along the lines of

```
Could not initialize keytab on remote server.
result = -2, errno = 2rver connection
*** hpssex_OpenConnection: Unable to authenticate user with remote gateway at 128.211.138.40.1217result = -2, errno = 9
Unable to setup communication to HPSS...
ERROR (main) unable to open remote gateway server connection
HTAR: HTAR FAILED
```

and

```
*** hpssex_OpenConnection: Unable to authenticate user with remote gateway at 128.211.138.40.1217result = -11000, errno = 9
Unable to setup communication to HPSS...
*** HSI: error opening logging
Error - authentication/initialization failed
```

The root cause for these errors is an expired or non-existent keytab file (a special authentication token stored in your home directory). These keytabs are valid for 90 days and on most RCAC resources they are usually automatically checked and regenerated when you execute `hsi` or `htar` commands. However, if the keytab is invalid, or fails to generate, Fortress may be unable to authenticate you and you would see the above errors. This is especially common on those RCAC clusters that have their own dedicated home directories (such as Bell), or on standalone installations (such as if you downloaded and installed HSI and HTAR on your non-RCAC computer).

*This is a temporary problem and a permanent system-wide solution is being developed.* In the interim, the recommended workaround is to generate a new valid keytab file in your main research computing home directory, and then copy it to your home directory on Bell. The `fortresskey` command is used to generate the keytab and can be executed on another cluster or a dedicated data management host `data.rcac.purdue.edu`:

```
$ ssh myusername@data.rcac.purdue.edu fortresskey
$ scp -pr myusername@data.rcac.purdue.edu:~/.private $HOME
```

With a valid keytab in place, you should then be able to use `hsi` and `htar` commands to access Fortress from Bell. Note that only one keytab can be valid at any given time (i.e. if you regenerated it, you may have to copy the new keytab to all systems that you intend to use `hsi` or `htar` from if they do not share the main research computing home directory).

### HSI/HTAR: put: Error -5 on transfer

First, check your firewall settings, and ensure that there are no firewall rules interfering with connecting to Fortress. For firewall configuration, please see "[Do I need to do anything to my firewall to access Bell?](#do-i-need-to-do-anything-to-my-firewall-to-access-bell)" **If firewalls are not responsible:**

Open the file named `/etc/hosts` on your workstation, especially if you run a Debian or Ubuntu Linux distribution. Look for a line like:

```
127.0.1.1  hostname.dept.purdue.edu hostname
```

Replace the IP address 127.0.1.1 with the real IP address for your system. If you don't know your IP address, you can find it with the command:

```
host `hostname --fqdn`
```

### Can I access Fortress from Bell?

Yes. While Fortress directories are not directly mounted on Bell for performance and archival protection reasons, they can be accessed from Bell front-ends and nodes using any of the recommended methods of [HSI, HTAR or Globus](https://www.rcac.purdue.edu/knowledge/fortress/storage/transfer).

## Software

### Cannot use pip after loading ml-toolkit modules

#### Question

Pip throws an error after loading the machine learning modules. How can I fix it?

#### Answer

Machine learning modules (tensorflow, pytorch, opencv etc.) include a version of `pip` that is newer than the one installed with Anaconda. As a result it will throw an error when you try to use it.

```
$ pip --version
Traceback (most recent call last):
  File "/apps/cent7/anaconda/5.1.0-py36/bin/pip", line 7, in <module>
    from pip import main
ImportError: cannot import name 'main'
```

The preferred way to use `pip` with the machine learning modules is to invoke it via Python as shown below.

```
$ python -m pip --version
```

### How can I get access to Sentaurus software?

#### Question

How can I get access to Sentaurus tools for micro- and nano-electronics design?

#### Answer

Sentaurus software license requires a signed NDA. Please contact [Dr. Mark Johnson, Director of ECE Instructional Laboratories](https://engineering.purdue.edu/Mark-Johnson) to complete the process.

Once the licensing process is complete and you have been added into a `cae2` Unix group, you could use Sentaurus on RCAC community clusters by loading the corresponding environment module:

```
module load sentaurus
```

### Julia package installation

Users do not have write permission to the default julia package installation destination. However, users can install packages into home directory under `~/.julia`.

Users can side step this by explicitly defining where to put julia packages:

```
$ export JULIA_DEPOT_PATH=$HOME/.julia
$ julia -e 'using Pkg; Pkg.add("PackageName")'
```

## About Research Computing

### Can I get a private server from RCAC?

#### Question

Can I get a private (virtual or physical) server from RCAC?

#### Answer

Often, researchers may want a private server to run databases, web servers, or other software. RCAC currently has [Geddes](https://www.rcac.purdue.edu/compute/geddes), a Community Composable Platform optimized for composable, cloud-like workflows that are complementary to the batch applications run on Community Clusters. Funded by the National Science Foundation under grant OAC-2018926, Geddes consists of Dell Compute nodes with two 64-core AMD Epyc 'Rome' processors (128 cores per node).

To purchase access to Geddes today, go to the [Cluster Access Purchase](https://www.rcac.purdue.edu/purchase) page. Please subscribe to our Community Cluster Program Mailing List to stay informed on the latest purchasing developments or contact us (rcac-cluster-purchase@lists.purdue.edu) if you have any questions.

[**Back to Bell User Guide**](index.md)
