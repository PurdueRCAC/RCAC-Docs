---
tags:
  - HPC Exchange
  - Onboarding
---

# HPC Crash Course

[Back to HPC Exchange](./index.md)

This page condenses the essentials of High Performance Computing (HPC) into a single quick orientation for new users of RCAC clusters. It covers:

1. [What a cluster is](#what-is-a-cluster)
2. [Getting access and logging in](#logging-in)
3. [Where to store your files](#file-storage)
4. [Loading software with modules](#software-modules)
5. [Running jobs with Slurm](#job-submission)

Throughout this page, replace `USERNAME` with your Purdue career account username and `CLUSTER` with the name of the cluster you are using (for example, `negishi` or `gautschi`).

---

## What is a cluster?

A cluster is a collection of many interconnected computers, called **nodes**, that share one or more storage systems. Clusters typically run a UNIX-like operating system (Linux) and are managed by a batch **scheduler**.

Each node is a computer with one or more CPU sockets, each made of many cores, plus memory. Some nodes also have GPUs or extra memory.

![An image showing on the left the makeup of a node, that has cores as a part of a socket and memory alongside that socket. On the right, it shows an image of an actual node, an HPE Cray XD2000.](/assets/images/workshops/hpc_exchange/node.png)

A cluster is split into two kinds of nodes:

- **Login (front-end) nodes**: where you land when you log in. Use them to edit files, transfer data, and submit jobs.
- **Compute (back-end) nodes**: where your research actually runs. You reach them by asking the scheduler for resources.

![Overview of cluster](/assets/images/workshops/hpc_exchange/cluster_overview.png)

!!! warning "Don't compute on the login nodes"
    Login nodes are shared by everyone on the cluster and have limited resources. Run anything computationally expensive as a [job](#job-submission) on the compute nodes.

You can tell which kind of node you are on from your command prompt, or with the `hostname` command:

```bash linenums="0"
USERNAME@login03.negishi:[~] $ hostname
login03.negishi.rcac.purdue.edu
```

### Which cluster should I use?

| Cluster | Best for | Notes |
|---------|----------|-------|
| [Negishi](../../userguides/negishi/index.md) | General-purpose CPU and MPI workloads | Community cluster |
| [Gautschi](../../userguides/gautschi/index.md) | AI and mixed CPU + GPU workloads | Community cluster with NVIDIA H100 and L40S GPUs |
| [Gilbreth](../../userguides/gilbreth/index.md) | GPU-intensive computing and machine learning | Community cluster; jobs **must** request GPUs |
| [Scholar](../../userguides/scholar/index.md) | Teaching and training | Not for production research |
| [Anvil](../../userguides/anvil/index.md) | Large-scale national research | Access through NSF ACCESS allocations |

See [Purdue Clusters](./week2/clusters.md) for more detail.

---

## Logging in

### Checking your access

You can only log in to a cluster if you belong to a group (usually purchased by a lab's PI) that has access to it. Your lab's group managers (typically the PI or a delegate) add you to these groups.

To see which groups you belong to, sign in to your [RCAC account page](https://www.rcac.purdue.edu/account/groups) and open the **Groups** tab. Group managers can add and remove members from this page.

![The Groups tab of the RCAC account page, listing each group, its Unix group name, and whether you are a group member or group manager.](/assets/images/workshops/hpc_exchange/rcac_account.png)

### Connecting

There are three ways to connect to a cluster:

=== "SSH"

    SSH gives you a command-line shell on a login node. Linux, macOS, and Windows all include `ssh`; open a terminal and run:

    ```bash linenums="0"
    $ ssh USERNAME@CLUSTER.rcac.purdue.edu
    ```

    Enter your Purdue password when prompted (nothing appears as you type, which is normal), then approve the 2FA push on your phone. Once logged in, your prompt changes to something like:

    ``` linenums="0"
    USERNAME@login03.CLUSTER:[~] $
    ```

=== "ThinLinc"

    ThinLinc gives you a full Linux desktop on a login node, which is useful for graphical applications such as MATLAB. Sessions are persistent, so your windows stay open if you disconnect.

    - **Browser:** go to `https://desktop.CLUSTER.rcac.purdue.edu`.
    - **Desktop client:** download it from [Cendio](https://www.cendio.com/thinlinc/download/) and use `desktop.CLUSTER.rcac.purdue.edu` as the server. The desktop client also supports SSH keys and restarting your session.

    ![Image showing the ThinLinc login portal, with text boxes to enter in the Server, the Username, and the path to the ssh key.](/assets/images/workshops/hpc_exchange/TL_login.png)

=== "Open OnDemand"

    Open OnDemand (also called the Gateway) is a web portal to the cluster. From it you can browse and edit files, open a shell, and launch interactive apps such as Jupyter, RStudio, or a remote desktop.

    Go to `https://gateway.CLUSTER.rcac.purdue.edu` and sign in with Purdue single sign-on. To open a shell, choose **Clusters → >_CLUSTER Shell Access** from the top menu.

    ![Image showing what the Open on Demand (Gateway) entrance page, or dashboard, looks like.](/assets/images/workshops/hpc_exchange/OoD_page.png)

See [Cluster Access](./week2/access.md) for more detail.

---

## File storage

Most filesystems are **shared across all nodes** in a cluster, so a file you create on a login node is also available to your jobs on the compute nodes.

![An image showing all nodes on a cluster mounting the same filesystems](/assets/images/workshops/hpc_exchange/cluster_filemount.png)

### Where to put your files

=== "Home"

    **Path:** `/home/USERNAME` (also `$HOME` or `~`)

    - Small (25 GB), private to you, and backed up with snapshots.
    - Specific to each cluster (not shared between clusters).
    - Good for configuration files, scripts, small software installs, and small data.
    - Not suitable for heavy I/O.

=== "Scratch"

    **Path:** `/scratch/CLUSTER/USERNAME` (also `$CLUSTER_SCRATCH`)

    - Very large (100+ TB) and fast, but limited in number of files (about 2 million).
    - **Not backed up**, and **regularly purged**. Files not accessed for 60 days are staged for deletion.
    - Good for job input and output and other data-intensive work.
    - Not for the only copy of anything important.

    Run `purgelist` to see which of your scratch files are staged to be purged.

=== "Depot"

    **Path:** `/depot/LABNAME`

    - Group storage owned by your PI and shared with your lab, backed up with snapshots.
    - Mounted on **all** community clusters, so you see the same files everywhere.
    - Good for shared software, scripts, and important research data.
    - Not suitable for intensive I/O. Stage heavy job I/O through scratch instead.

=== "/tmp"

    **Path:** `/tmp`

    - Local to each node, not shared, and cleared when your job ends.
    - Rarely needed. Use scratch unless you know you need node-local storage.

Check your usage and limits on each space with `myquota`:

```bash linenums="0"
$ myquota
Type       Location             Size    Limit    Use   Files   Limit    Use
===========================================================================
home       USERNAME           18.0GB   25.0GB  72.0%      -       -      -
scratch    USERNAME          670.8MB  200.0TB   0.0%  170.4K    2.0M   8.5%
depot      LABNAME             4.0MB  100.0GB   0.0%      -       -      -
```

### Transferring files

=== "Open OnDemand"

    Use the **Files** tab in Open OnDemand to upload and download files in your browser. This works well for small files, but large uploads or unreliable connections can fail.

    ![The Open OnDemand Files tab, showing upload and download buttons.](/assets/images/workshops/hpc_exchange/ood_transfer.png)

=== "Globus"

    For large transfers, use the [Globus transfer service](https://transfer.rcac.purdue.edu). Globus manages the transfer for you and resumes automatically if the connection drops. To transfer to or from your own computer, install [Globus Connect Personal](https://www.globus.org/globus-connect-personal).

    ![The Globus transfer interface, showing a source and destination collection side by side.](/assets/images/workshops/hpc_exchange/globus_transfer.png)

=== "scp"

    `scp` is a command line tool useful for copying files between computers through an SSH connection. Run these from a terminal on your own computer:

    ```bash linenums="0"
    # Copy to the cluster
    $ scp ./myfile USERNAME@CLUSTER.rcac.purdue.edu:~/some_dir/

    # Copy from the cluster
    $ scp USERNAME@CLUSTER.rcac.purdue.edu:~/some_dir/myfile ./
    ```

=== "rsync"

    `rsync` is best for whole directories and for resuming interrupted transfers. Run these from a terminal on your own computer:

    ```bash linenums="0"
    # Copy a directory to the cluster
    $ rsync -av --progress ./my_directory/ USERNAME@CLUSTER.rcac.purdue.edu:~/my_directory/

    # Copy a directory from the cluster
    $ rsync -av --progress USERNAME@CLUSTER.rcac.purdue.edu:~/my_directory/ ./my_directory/
    ```

See [File Storage and Transfer](./week2/storage-transfer.md) and [Week 4: Storage & Transfers](./week4/storage-transfer.md) for more detail.

---

## Software modules

Clusters have many applications (often several versions of each application) preinstalled for users. However, it's not possible to have all applications available by default, as many applicactions and packages would conflict if installed together. To get around this, RCAC uses the **Lmod** module system so you can load only the software you need into your shell.

![Image showing three module load commands making additional commands available](/assets/images/workshops/hpc_exchange/module_system.png)

| Command | Description |
|---------|-------------|
| `module avail` | List modules available to load |
| `module spider NAME` | Search all modules, including ones that need other modules loaded first |
| `module load NAME` | Load a module (optionally a specific version, `NAME/VERSION`) |
| `module list` | Show currently loaded modules |
| `module unload NAME` | Unload a module |
| `module purge` | Unload all modules |

For example, Python is provided by the `conda` module:

```bash linenums="0"
$ python --version
-bash: python: command not found

$ module load conda
$ which python
/apps/external/apps/conda/2024.09/bin/python
```

!!! tip "Installing your own Python packages"
    To install packages without `sudo` (admin) privileges, create your own conda environment:

    ```bash linenums="0"
    $ module load conda
    $ conda create -y -n my_env numpy
    $ conda activate my_env
    ```

See [Cluster Applications](./week2/applications.md) and the [software catalog](../../software/index.md) for more detail.

---

## Job submission

Compute nodes are shared by many users, so you don't log in to them directly. Instead, you ask the **Slurm** scheduler for resources, and Slurm runs your work when they become available.

![slurm_submission](/assets/images/workshops/hpc_exchange/slurm_submission.png)

### Telling Slurm what you need

Every job tells Slurm which account to charge, where to run, and what resources it needs:

=== "Account"

    ```bash linenums="1" hl_lines="2"
    #!/bin/bash
    #SBATCH --account=mylab
    #SBATCH --partition=cpu
    #SBATCH --qos=normal
    #SBATCH --time=0-01:00:00
    #SBATCH --nodes=1
    #SBATCH --ntasks-per-node=1
    ```

    The **account** is the group allocation your job is charged to, usually your lab's. Run `slist` to see the accounts you can use and how many of their cores are free:

    ``` linenums="0"
    $ slist
                         Current Negishi Accounts
    ==============================================================================
                   |              CPU Partition              |     Standby QOS
    Accounts       |   Total     Queue      Run      Free    |   Queue      Run
    ============== | ========= ========= ========= ========= | ========= =========
    mylab          |        64         0        10        54 |         0         0
    ```

=== "Partition"

    ```bash linenums="1" hl_lines="3"
    #!/bin/bash
    #SBATCH --account=mylab
    #SBATCH --partition=cpu
    #SBATCH --qos=normal
    #SBATCH --time=0-01:00:00
    #SBATCH --nodes=1
    #SBATCH --ntasks-per-node=1
    ```

    A **partition** is a set of nodes with similar hardware, such as CPU-only, high-memory, or GPU nodes. Run `showpartitions` to list them:

    ``` linenums="0"
    $ showpartitions
    Partition       #Nodes     #CPU_cores  Cores_pending   Job_Nodes MaxJobTime Cores Mem/Node
    Name  State   Total  Idle  Total   Idle Resorc  Other   Min   Max  Day-hr:mn /node     (GB)
    cpu      up     446     0  57088   2078      0  15973     1 infin   infinite   128     257
    highmem  up       6     0    768    236      0   2114     1 infin   infinite   128    1031
    gpu      up       5     3    160    132      0      0     1 infin   infinite    32     515
    ```

=== "QoS"

    ```bash linenums="1" hl_lines="4"
    #!/bin/bash
    #SBATCH --account=mylab
    #SBATCH --partition=cpu
    #SBATCH --qos=normal
    #SBATCH --time=0-01:00:00
    #SBATCH --nodes=1
    #SBATCH --ntasks-per-node=1
    ```

    The **quality of service** (QoS) sets your job's priority:

    - `normal`: high priority and up to 2 weeks of run time, but uses your account's allocation.
    - `standby`: doesn't use your allocation, but has low priority and a 4-hour limit.

    ![An Image showing a long queue under a standby sign, and an empty line under a sign labeled normal](/assets/images/workshops/hpc_exchange/standby_vs_normal.png)

=== "Resources"

    ```bash linenums="1" hl_lines="5-7"
    #!/bin/bash
    #SBATCH --account=mylab
    #SBATCH --partition=cpu
    #SBATCH --qos=normal
    #SBATCH --time=0-01:00:00
    #SBATCH --nodes=1
    #SBATCH --ntasks-per-node=1
    ```

    Request the time, nodes, and cores your job needs:

    - `--time`: maximum run time (`D-HH:MM:SS`). Your job is stopped when it runs out.
    - `--nodes`: number of nodes.
    - `--ntasks-per-node`: number of tasks (cores) on each node.

    Some clusters and partitions also require `--mem` for memory or `--gpus-per-node` for GPUs. Check your cluster's user guide.

!!! note "Partitions and QoS vary by cluster"
    The examples on this page use Negishi. Partition names, QoS options, and required options differ between clusters, so check the user guide for your cluster.

### Running jobs

=== "Batch job"

    A batch job runs a script without you watching it, so it keeps running after you log out. Write a job script with `#SBATCH` lines that describe what you need, followed by the commands to run:

    ```bash title="myjob.sh" linenums="1"
    #!/bin/bash
    #SBATCH --account=mylab
    #SBATCH --partition=cpu
    #SBATCH --qos=normal
    #SBATCH --time=0-01:00:00
    #SBATCH --nodes=1
    #SBATCH --ntasks-per-node=1

    module load conda
    python --version
    hostname
    ```

    Submit it with `sbatch`:

    ```bash linenums="0"
    $ sbatch myjob.sh
    Submitted batch job 32209880
    ```

    When it finishes, the output is in `slurm-JOBID.out` in the directory you submitted from:

    ```bash linenums="0"
    $ cat slurm-32209880.out
    ```

=== "Interactive job"

    An interactive job gives you a shell on a compute node, which is useful for testing and debugging. Use `sinteractive` with the same options as `sbatch`:

    ``` linenums="0" hl_lines="1 4"
    USERNAME@login03.negishi:[~] $ sinteractive -A mylab -p cpu -q normal -n 1 -t 00:30:00
    salloc: Granted job allocation 19809515
    salloc: Nodes a195 are ready for job
    USERNAME@a195.negishi:[~] $
    ```

    Your prompt changes from the login node (`login03`) to a compute node (`a195`). Type `exit` to end the job and return to the login node.

=== "Open OnDemand apps"

    Open OnDemand interactive apps, such as Jupyter, RStudio, and the remote desktop, submit a job for you from a web form. From the Open OnDemand home page, choose the app from the **Interactive Apps** menu, fill in the account, partition, and time, and launch it.

    ![The Open OnDemand Desktop app running a remote desktop on a compute node in the browser.](/assets/images/workshops/hpc_exchange/ood_desktop.png)

### Monitoring and cancelling jobs

| Command | Description |
|---------|-------------|
| `squeue --me` | List your pending (`PD`) and running (`R`) jobs |
| `jobinfo JOBID` | Show details about a job |
| `scancel JOBID` | Cancel a job |

```bash linenums="0"
$ squeue --me
JOBID      USER     ACCOUNT      PART QOS     NAME       NODES TRES_PER_NODE   CPUS  TIME_LIMIT ST TIME
32209880   USERNAME mylab        cpu  normal  myjob.sh       1 N/A                1     1:00:00  R 0:09
```

See [Cluster Job Submission](./week2/slurm-basics.md) for more detail.

---

## Being a good cluster citizen

- Request only the resources you need.
- Don't run heavy computations on the login nodes.
- Use scratch, not home or depot, for I/O-heavy jobs.
- Don't submit thousands of tiny jobs; see [Workload Management](./week4/workload-management.md) for better approaches.
- Cancel interactive sessions and apps you are no longer using.

## Getting help

- Cluster user guides: [Negishi](../../userguides/negishi/index.md), [Gautschi](../../userguides/gautschi/index.md), [Gilbreth](../../userguides/gilbreth/index.md), [Anvil](../../userguides/anvil/index.md)
- Email: [rcac-help@purdue.edu](mailto:rcac-help@purdue.edu)

[Back to HPC Exchange](./index.md)
