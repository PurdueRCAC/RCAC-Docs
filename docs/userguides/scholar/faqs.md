---
tags:
  - Scholar
authors:
  - jin456
  - remender
resource: Scholar
host: scholar.rcac.purdue.edu
search:
  boost: 2
---

# Frequently Asked Questions on Scholar

Some common questions, errors, and problems are categorized below. You can also use the search box above to search the user guide for any issues you are seeing. 

## About Scholar

### Can you remove me from the Scholar mailing list?
Your subscription to the Scholar mailing list is tied to your access on Scholar. The only way to remove you from the Scholar mailing list is to remove your Scholar access.

### Do I need to do anything to my firewall to access Scholar?
No firewall changes are needed to access Scholar. However, to access data through Network Drives (i.e., CIFS, "Z: Drive"), you must be on a Purdue campus network or connected through [VPN](https://it.purdue.edu/services/vpn.php).

### Does Scholar have the same home directory as other clusters?
The Scholar `home` directory and its contents are exclusive to Scholar cluster front-end hosts and compute nodes. This `home` directory is not available on other RCAC machines but Scholar. There is no automatic copying or synchronization between `home` directories.

At your discretion you can manually copy all or parts of your main research computing home to Scholar using one of the [suggested transfer methods in this section](./storage.md).

## Applications

### How should I launch common GUI applications on Scholar?
Users who have access to **Scholar** can use **ThinLinc** to launch an interactive jobs. Refer to [this user guide section](./accounts.md/#thinlinc) to learn how to setup Thinlinc for Scholar.

* In the upper left corner, the user can click on **Applications**, then **Cluster Software**, where multiple software options are listed with interactive SLURM jobs.

    <figure style="text-align: center;">
        ![Thinlinc Application](../../assets/images/userguides/gautschi/thinlinc-application1.png)
        <figcaption>Thinlinc application menu</figcaption>
    </figure>

* The **GUI launcher** starts with a window that prompts the user to select the desired version of the software to launch and guides them through the job submission process.

    <figure style="text-align: center;">
        ![Thinlinc Application2](../../assets/images/userguides/gautschi/thinlinc-application2.png)
        <figcaption>Thinlinc application selector</figcaption>
    </figure>

* The **GUI launcher** also makes it easy for users to view available accounts, the maximum wall times for each account, and the available computing resources with multiple help options at the bottom.

    <figure style="text-align: center;">
        ![Thinlinc Partition](../../assets/images/userguides/gautschi/thinlinc-partition.png)
        <figcaption>Partition selection</figcaption>
    </figure>

* After choosing the partition, the user is prompted to provide the computing resource they need for their job to run while adjusting the memory for them automatically.

    <figure style="text-align: center;">
        ![Thinlinc Resource](../../assets/images/userguides/gautschi/thinlinc-resource_options.png)
        <figcaption>Resource options for your job</figcaption>
    </figure>

* After requesting the resources the job will be submitted and waiting for slurm to allocate the computing resources.

    <figure style="text-align: center;">
        ![Thinlinc Application](../../assets/images/userguides/gautschi/thinlinc-jobsubmitted.png)
        <figcaption>Interactive job has been submitted</figcaption>
    </figure>

### Close Firefox / Firefox is already running but not responding

--8<-- "docs/snippets/firefox_lock.md"

### Jupyter:  database is locked / can not load notebook format

--8<-- "docs/snippets/jupyter_lock.md"