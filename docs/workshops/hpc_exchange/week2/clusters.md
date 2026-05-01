# Purdue Clusters


[Back to Week 2](./index.md)


The Rosen Center for Advanced Computing (Purdue's
supercomputing center) maintains a few clusters
that serve different purposes.

The first four are what are considered "Purdue Community Clusters", and are open to be purchased by Purdue staff and faculty. The clusters listed after the first four are specialty clusters and have atypical methods of getting access to them.

## Bell

**Best for:** Traditional CPU-based scientific computing, MPI workloads  

Bell is a community cluster designed for tightly-coupled science and engineering applications using CPU-only workflows. It features high-core-count AMD processors and fast InfiniBand networking, making it well-suited for parallel simulations and MPI-based codes.

Bell will be retired in **Fall 2026**.

## Negishi

**Best for:** General-purpose HPC, parallel CPU workloads, MPI jobs  

Negishi is the successor to Bell and serves as a general-purpose community cluster for traditional scientific and engineering applications. It provides large core counts, fast networking, and modern CPUs, making it ideal for multi-process and MPI-based workloads.

Negishi will remain in service through **Fall 2028**.


## Gautschi

**Best for:** AI, machine learning, GPU computing, mixed CPU+GPU workloads  

Gautschi is a next-generation community cluster featuring both high-core-count CPU nodes and GPU nodes. It is optimized for:

* AI and deep learning workloads  
* Large-scale GPU computing  
* Hybrid CPU + GPU applications  

The AI partition contains NVIDIA H100 GPUs and high-speed networking, Gautschi is the primary platform for advanced AI research and accelerator-based computing.

## Gilbreth 

**Best for:** GPU-intensive computing, machine learning, data science  

Gilbreth is a GPU-focused community cluster supporting a wide range of NVIDIA GPUs. It is ideal for:

* Machine learning and deep learning  
* GPU-accelerated simulation  
* Data analytics and visualization  

Gilbreth supports a diverse set of GPU node types, enabling flexibility for different performance and memory requirements. Importantly, jobs submitted to Gautschi **MUST** request and use GPUs. 


## Scholar (Teaching Resource)

**Best for:** Teaching, training, interactive learning  

Scholar is a small instructional cluster designed specifically for education. It supports classroom learning, workshops, and hands-on HPC training. Scholar is **not intended for production research workloads**.


## Anvil (ACCESS Resource)

**Best for:** Large-scale CPU computing, NSF-funded research  

Anvil is a national-scale supercomputer operated as part of the NSF ACCESS program. It provides:

* Massive CPU computing capacity  
* Large-memory nodes  
* GPU resources for machine learning  

Access to Anvil is granted through **NSF ACCESS allocations**, not directly by RCAC.


## Clusters for Controlled Research

Purdue also operates two clusters for controlled research: Rossmann and Weber. Rossmann is built to handle health data with higher levels of access restrictions, such as patient data. Weber is designed to deal with export controlled data.

Access to these two clusters is on a case-by-case basis and usually requires a review of what and why they are needed.


Next Section: [Cluster Access](./access.md)

<!-- 
| Cluster | GPU Resources | CPU Resources | Best For | Notes|
|---------|---------------|---------------|----------|------|
|Bell     | Limited (AMD) | Yes           |          | Reties Fall 2026|
|Negishi  | Limited (AMD) | Yes           |          |                 |
|Gilbreth | Nvidia A10, A30, A100, H100 | **No** | GPU Heavy computations | Not for CPU workloads |
|Gautschi | Nvidia H100, L40S | Yes | Machine Learning, CPU/GPU workloads | 
|Scholar  | NVidia V100 | Yes | Instructional use | Not for research | 
 -->
