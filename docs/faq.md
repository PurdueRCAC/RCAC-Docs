# Frequently Asked Questions about using RCAC resources

## How do I connect to a RCAC cluster?

RCAC clusters support the SSH (Secure Shell), Thinlinc and Open OnDemand mechanisms for logging in. [This section of our HPC Exchange workshop](/workshops/hpc_exchange/week1/access/) introduced how you can connect to RCAC clusters with different methods step by step. Please also refer to the user guide section on the cluster you want to connect below:

### SSH

=== "Anvil"
    Please refer to [SSH section on Anvil User Guide](/userguides/anvil/getting-started/#ssh) to learn how to SSH to Anvil.

=== "Gautschi"
    Please refer to [SSH section on Gautschi User Guide](/userguides/gautschi/accounts/#ssh) to learn how to SSH to Gautschi.

### Thinlinc

=== "Anvil"
    Please refer to [Thinlinc section on Anvil User Guide](/userguides/anvil/getting-started/#thinlinc) to learn how to configure and use Thinlinc to get connected to Anvil.

=== "Gautschi"
    Please refer to [Thinlinc section on Gautschi User Guide](/userguides/gautschi/accounts/#thinlinc) to learn how to configure and use Thinlinc to get connected to Gautschi.

### Open OnDemand (Gateway)

=== "Anvil"
    One can visit Open OnDemand on Anvil via [https://ondemand.anvil.rcac.purdue.edu/ :octicons-link-external-16:](https://ondemand.anvil.rcac.purdue.edu/).

=== "Gautschi"
    One can visit Open OnDemand (Gateway) on Gautschi via [https://gateway.gautschi.rcac.purdue.edu/ :octicons-link-external-16:](https://gateway.gautschi.rcac.purdue.edu/).

## How can I transfer my data from local devices to RCAC resources?

We support several methods for file transfer to and from RCAC systems. Users can transfer files between RCAC systems and Linux-based systems or Mac using either `scp`, `sftp` or `rsync`. One can also use our Globus service for easy data transfer. [This section of our HPC Exchange workshop](/workshops/hpc_exchange/week4/storage-transfer/) introduced in detail about different types RCAC storage systems and how you can transfer data from/to these systems.Also refer to the specific user guide section below to learn how to transfer your data to/from different RCAC resources.

=== "Anvil"
    [Data transfer on Anvil cluster](/userguides/anvil/file_management/#transferring-files)

=== "Gautschi"
    [Data transfer on Gautschi cluster](/userguides/gautschi/storage/)

## How do I submit jobs on a RCAC cluster?

All RCAC clusters use the [Slurm Workload Manager :octicons-link-external-16:](https://slurm.schedmd.com/) for job scheduling and management. With Slurm, a user requests resources and submits a job to a queue. The system takes jobs from queues, allocates the necessary compute nodes, and executes them. We support various job submission methods including `sbatch`, interactive jobs and interactive apps on Open OnDemand (Gateway). You may learn how to submit jobs to RCAC clusters in general through [this section of our HPC Exchange workshop](/workshops/hpc_exchange/week2/slurm-basics/) or learn how to submit jobs to specific RCAC clusters from user guide sections listed below.

!!! warning "Running jobs on login node is against RCAC policy"
    All users share the login nodes, and running anything but the smallest test job will negatively impact everyone's ability to use the cluster.

!!! note "Check user guide before submitting your jobs"
    Because different RCAC clusters have different hardware and system architectures, and they have been configured differently for users. Please refer to the specific section in the user guide about how to submit jobs.

=== "Anvil"
    Learn how to submit your jobs to Anvil through [this section](/userguides/anvil/jobs/) on Anvil User Guide.

=== "Gautschi"
    Learn how to submit your jobs to Gautschi through [this section](/userguides/gautschi/run_jobs/) on Gautschi User Guide.

## How do I install software on a RCAC cluster?

RCAC clusters provide a number of software packages to users with [LMOD :octicons-link-external-16:](https://lmod.readthedocs.io/en/latest/) software management system via the `module` command. Please check our [software page](/software/) first to see if your software has been installed on the system. If your software/version is not on the list, please reach the [RCAC help desk](mailto:rcac-help@purdue.edu) to discuss with our staff.

!!! note "Using Biocontainers on RCAC clusters"
    We also provide more than 600 biocontainers across multiple RCAC clusters. Check our [Biocontainers documentation :octicons-link-external-16:](https://biocontainer-doc.readthedocs.io) to learn more.