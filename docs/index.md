---
hide:
  - footer
  - toc
#   - navigation
meta:
  - name: google-site-verification
    content: HQsOhuVVa11DY0qIrxXPW6GUR9jk4EnFfQgUzCgKNbw
---

<div class="home-page" markdown>

# Welcome to RCAC Documentation

<!-- The invisible anchor below will make sure the outage widget only anchors to homepage. -->
<div id="outage-widget-anchor"></div>

??? info "Important: Gautschi Scheduler Changes Coming November 2: Shorter Waits, New Burst QOS"
    As Gautschi's utilization has ramped up, the RCAC team reached out to researchers to understand their workflows and collect feedback to guide the evolution of this resource. While the AI partition's near 100% utilization is a success by many metrics, many of you have pointed out that jobs using the normal QOS have begun to experience longer-than-expected wait times and that preemptible jobs are unlikely to start due to the near 100% occupancy of normal QOS jobs. To make sure that the Gautschi AI cluster delivers a positive experience while providing the desired AI cycles, we're making a set of scheduler changes to shorten waits, make capacity more predictable, enable new ways to get whole-node access when you need it, and make checkpointing easier to perform when using the preemptible QOS. This blog post will provide some of the data driving the decisions that we are making.

    ## What's Changing

    The following changes will take effect on **Monday, November 2, 2026**.

    1. **Proportional GPU Limits:** The per-account limit of 24 GPUs is being reduced to **double the number of GPUs purchased or 2 GPUs, whichever is larger**.
    2. **Reduced Max Walltimes:** The current two-week max walltime for normal QOS jobs is being reduced to **4 days**.
    3. **New burst QOS:** A new quality of service will be created called burst with the following policies:
        - Jobs using the burst QOS can use up to **8 GPUs** at once for up to **8 hours** at a time.
        - Jobs with this QOS will have the highest priority on the cluster for more immediate start time, however they will only be able to preempt preemptible jobs. Normal QOS jobs will remain unaffected.
        - Only one job from each account on the cluster can use this QOS at a time.
        - Jobs using this QOS will be **charged at 2x the rate for the GPU hours** consumed by their job.
    4. **New Preemptible Features:**
        - Preemptible jobs will have a **GraceTime value of 10 minutes** which will allow preemptible jobs a guaranteed 10 minutes to clean-up and checkpoint their work before being interrupted.
    
    Please also feel free to contact us at [rcac-help@purdue.edu](mailto:rcac-help@purdue.edu) if you have any questions or need support and visit [our post at RCAC website](https://www.rcac.purdue.edu/news/7941) for additional details.

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

    [:octicons-arrow-right-24: Connection guide](faqs/#how-do-i-connect-to-a-rcac-cluster)

-   :material-folder-upload:{ .lg .middle } __Transfer Your Data__

    ---

    Move files to and from the cluster using SCP, SFTP, Globus, or the research data depot.

    [:octicons-arrow-right-24: Data transfer](faqs/#how-can-i-transfer-my-data-from-local-devices-to-rcac-resources)

-   :material-play-circle:{ .lg .middle } __Submit Your First Job__

    ---

    Write a Slurm batch script, submit it to the scheduler, and monitor your job's progress.

    [:octicons-arrow-right-24: Job submission guide](faqs/#how-do-i-submit-jobs-on-a-rcac-cluster)

-   :material-package-variant:{ .lg .middle } __Install Software__

    ---

    Find pre-installed modules via the LMOD system or request software from the RCAC help desk.

    [:octicons-arrow-right-24: Software installation guide](faqs/#how-do-i-install-software-on-a-rcac-cluster)

-   :material-home:{ .lg .middle } __RCAC Website__

    ---

    Need to learn more about RCAC? Visit our official website.

    [:octicons-arrow-right-24: RCAC Website](https://www.rcac.purdue.edu/)

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

-   :material-server:{ .lg .middle } __Gilbreth__

    ---

    Community Cluster optimized for communities running GPU intensive applications such as machine learning. Consists of Dell compute nodes with Intel Xeon processors and Nvidia Tesla GPUs.

    [:octicons-arrow-right-24: Gilbreth User Guide](userguides/gilbreth/index.md)

-   :material-server:{ .lg .middle } __Scholar__

    ---

    A small cluster suitable for classroom learning about high performance computing. Consists of 6 interactive login servers and 16 batch worker nodes, accessible as a typical cluster with a job scheduler or as an interactive resource with a desktop-like environment.

    [:octicons-arrow-right-24: Scholar User Guide](userguides/scholar/index.md)

-   :material-server:{ .lg .middle } __Negishi__

    ---

    Community Cluster optimized for communities running traditional, tightly-coupled science and engineering applications. Built through a partnership with Dell and AMD, Negishi consists of compute nodes with two 64-core AMD EPYC "Milan" processors and 256 GB of memory.

    **128 cores/node | 256 GB RAM | 100 Gbps HDR Infiniband**

    [:octicons-arrow-right-24: Negishi User Guide](userguides/negishi/index.md)

-   :material-server:{ .lg .middle } __Geddes__

    ---

    Community Composable Platform optimized for composable, cloud-like workflows that are complementary to the batch applications run on Community Clusters. Geddes consists of Dell Compute nodes with two 64-core AMD Epyc 'Rome' processors (128 cores per node).

    **128 cores/node | 1 TB RAM | Nvidia A100 GPU**

    [:octicons-arrow-right-24: Geddes User Guide](userguides/geddes/index.md)

-   :material-server:{ .lg .middle } __Hammer__

    ---

    Optimized for Purdue's communities utilizing loosely-coupled, high-throughput computing. Hammer will be expanded annually, with each year's purchase of nodes to remain in production for 5 years from their initial purchase.

    **256 cores/node | 512 GB RAM | Nvidia Tesla T4 GPU**

    [:octicons-arrow-right-24: Hammer User Guide](userguides/hammer/index.md)

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

-   :material-hub:{ .lg .middle } __HUBzero__

    ---

    Documentation for the HUBzero science gateway platform, with guides for hub users, hub managers, tool developers, and CMS developers, and the REST API reference.

    [:octicons-arrow-right-24: HUBzero documentation](hubzero/index.md)

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
