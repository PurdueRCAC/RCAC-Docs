---
hide:
  - footer
  - toc
#   - navigation
---

<div class="home-page" markdown>

# Welcome to RCAC Documentation

<!-- !!! Warning "Announcement"
    **This is a demo site.** You are visiting a demo site designed for testing purposes only. Contents on this website may not reflect production RCAC resources. Check [rcac.purdue.edu](https://www.rcac.purdue.edu) for official information. -->

## :material-rocket-launch: New to RCAC?

Follow these steps to get up and running on RCAC clusters.

<div class="grid cards" markdown>

-   :material-account-plus:{ .lg .middle } __Get an Account__

    ---

    Request access to RCAC computing resources through your Purdue career account or an ACCESS account.

    [:octicons-arrow-right-24: Purdue account](https://www.rcac.purdue.edu/account/request) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [:octicons-arrow-right-24: ACCESS account](userguides/anvil/access/)

-   :material-connection:{ .lg .middle } __Connect to a RCAC Cluster__

    ---

    Learn how to log in via SSH, set up your environment, and access the cluster for the first time.

    [:octicons-arrow-right-24: Connection guide](faq/#how-do-i-connect-to-a-rcac-cluster)

-   :material-folder-upload:{ .lg .middle } __Transfer Your Data__

    ---

    Move files to and from the cluster using SCP, SFTP, Globus, or the research data depot.

    [:octicons-arrow-right-24: Data transfer](faq/#how-can-i-transfer-my-data-from-local-devices-to-rcac-resources)

-   :material-play-circle:{ .lg .middle } __Submit Your First Job__

    ---

    Write a Slurm batch script, submit it to the scheduler, and monitor your job's progress.

    [:octicons-arrow-right-24: Job submission guide](faq/#how-do-i-submit-jobs-on-a-rcac-cluster)

-   :material-package-variant:{ .lg .middle } __Install Software__

    ---

    Find pre-installed modules via the LMOD system or request software from the RCAC help desk.

    [:octicons-arrow-right-24: Software installation guide](faq/#how-do-i-install-software-on-a-rcac-cluster)

</div>

## :material-server-network: HPC User Guides

<div class="grid cards" markdown>

-   :material-server:{ .lg .middle } __Anvil__

    ---

    NSF-funded capacity cluster for the national research community. Features AMD EPYC Milan CPUs, NVIDIA A100 GPUs, and large-memory nodes. Available through ACCESS allocations.

    **128 cores/node | 256GB-1TB RAM | A100/H100 GPUs**

    [:octicons-arrow-right-24: Anvil User Guide](userguides/anvil/index.md)

-   :material-server:{ .lg .middle } __Gautschi__

    ---

    Purdue's community cluster for faculty and research groups. Powered by AMD EPYC Genoa CPUs and NVIDIA H100 GPUs. Access through the community cluster purchase program.

    **192 cores/node | 384GB-1.5TB RAM | H100 GPUs**

    [:octicons-arrow-right-24: Gautschi User Guide](userguides/gautschi/index.md)

-   :material-server:{ .lg .middle } __Bell__

    ---

    Community Cluster optimized for communities running traditional, tightly-coupled science and engineering applications. Built through a partnership with Dell and AMD, Bell consists of compute nodes with two 64-core AMD EPYC "Rome" processors and 256 GB of memory.

    **128 cores/node | 256 GB RAM | 100 Gbps HDR Infiniband**

    [:octicons-arrow-right-24: Bell User Guide](https://www.rcac.purdue.edu/knowledge/bell)

-   :material-server:{ .lg .middle } __Negishi__

    ---

    Community Cluster optimized for communities running traditional, tightly-coupled science and engineering applications. Built through a partnership with Dell and AMD, Negishi consists of compute nodes with two 64-core AMD EPYC "Milan" processors and 256 GB of memory.

    **128 cores/node | 256 GB RAM | 100 Gbps HDR Infiniband**

    [:octicons-arrow-right-24: Negishi User Guide](https://www.rcac.purdue.edu/knowledge/negishi)

-   :material-server:{ .lg .middle } __Gilbreth__

    ---

    Community Cluster optimized for communities running GPU intensive applications such as machine learning. Consists of Dell compute nodes with Intel Xeon processors and Nvidia Tesla GPUs.

    [:octicons-arrow-right-24: Gilbreth User Guide](https://www.rcac.purdue.edu/knowledge/gilbreth)

-   :material-server:{ .lg .middle } __Scholar__

    ---

    A small cluster suitable for classroom learning about high performance computing. Consists of 6 interactive login servers and 16 batch worker nodes, accessible as a typical cluster with a job scheduler or as an interactive resource with a desktop-like environment.

    [:octicons-arrow-right-24: Scholar User Guide](https://www.rcac.purdue.edu/knowledge/scholar)

</div>

<!-- ## :material-lightning-bolt: Common Tasks

<div class="grid cards" markdown>

-   :material-key:{ .lg .middle } __Manage SSH Keys__

    ---

    [:octicons-arrow-right-24: SSH key setup](blog/posts/ssh_key_creation.md)

-   :material-monitor-dashboard:{ .lg .middle } __Open OnDemand__

    ---

    [:octicons-arrow-right-24: Web portal access](userguides/gautschi/gateway.md)

-   :material-package-variant:{ .lg .middle } __Load Software Modules__

    ---

    [:octicons-arrow-right-24: Module system](userguides/gautschi/software.md)

-   :material-script-text:{ .lg .middle } __Slurm Job Scripts__

    ---

    [:octicons-arrow-right-24: Job scripting](userguides/gautschi/run_jobs/index.md)

-   :material-remote-desktop:{ .lg .middle } __ThinLinc Remote Desktop__

    ---

    [:octicons-arrow-right-24: ThinLinc guide](blog/posts/thinlinc-login.md)

-   :material-harddisk:{ .lg .middle } __Storage & Scratch__

    ---

    [:octicons-arrow-right-24: Storage overview](userguides/gautschi/storage.md)

-   :material-code-braces:{ .lg .middle } __Compile Source Code__

    ---

    [:octicons-arrow-right-24: Compilation guide](userguides/gautschi/compile.md)

-   :material-frequently-asked-questions:{ .lg .middle } __FAQ__

    ---

    [:octicons-arrow-right-24: Frequently asked questions](userguides/gautschi/faq.md)

</div> -->

## :material-bookshelf: RCAC Resources

<div class="grid cards" markdown>

-   :fontawesome-solid-blog:{ .lg .middle } __RCAC Blogs__

    ---

    Dive into insights from RCAC staff covering best practices, new features, and tips for getting the most out of our computing resources.

    [:octicons-arrow-right-24: RCAC Blogs](blog/index.md)

-   :material-format-font:{ .lg .middle } __Workshops & Tutorials__

    ---

    Hands-on training materials from RCAC workshops, covering topics from introductory Linux to advanced parallel computing and GPU programming.

    [:octicons-arrow-right-24: Browse materials](workshops/index.md)

-   :material-application:{ .lg .middle } __Software Catalog__

    ---

    Browse the complete catalog of software installed across RCAC clusters, including versions, module names, and usage instructions.

    [:octicons-arrow-right-24: Software catalog](software/index.md)

-   :material-database-settings:{ .lg .middle } __Datasets__

    ---

    Access curated research datasets hosted on RCAC systems, including genomics references, machine learning benchmarks, and domain-specific collections.

    [:octicons-arrow-right-24: Dataset catalog](datasets/index.md)

</div>

## :material-lifebuoy: Need Help?

<div class="grid cards" markdown>

-   :material-email-fast:{ .lg .middle } __Email Support__

    ---

    Reach the RCAC help desk for account issues, software requests, and technical questions.

    [:octicons-arrow-right-24: rcac-help@purdue.edu](mailto:rcac-help@purdue.edu)

-   :fontawesome-brands-discord:{ .lg .middle } __Community Discord__

    ---

    A community Discord for Purdue researchers, RCAC staff, and other organizations to discuss research computing in real time.

    [:octicons-arrow-right-24: Join Discord](https://discord.gg/RmtKZmaQW9)

-   :fontawesome-brands-github:{ .lg .middle } __GitHub__

    ---

    Report documentation issues, suggest improvements, or contribute to RCAC open-source projects.

    [:octicons-arrow-right-24: RCAC on GitHub](https://github.com/PurdueRCAC)

-   :material-card-account-details:{ .lg .middle } __Contact Details__

    ---

    Find office hours, phone numbers, and other ways to connect with the RCAC support team.

    [:octicons-arrow-right-24: Full contact info](https://www.rcac.purdue.edu/about/contact)

</div>

</div>
