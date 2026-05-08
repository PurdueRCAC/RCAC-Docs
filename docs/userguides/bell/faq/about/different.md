---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# How is ${resource.name} different than other Community Clusters?

{::if resource.name == Gautschi}

${resource.name} differs from the previous Community Clusters in many significant aspects:

* ${resource.name} has a unique sales protocol. While previous clusters were available for sale based on compute resources, ${resource.name} is sold based on compute resource hours.
* ${resource.name} has eight NVIDIA H100 GPUs, each with 80 GB of GPU memory.

{::elseif resource.name == Rice }

* ${resource.name} is optimized for high-performance multi-node parallel computations. The scheduler is configured to favor starting jobs quickly and ensure maximum job independence with emphasis on larger multi-node jobs.

{::elseif resource.name == Snyder }

* ${resource.name} is optimized for large-memory, single-node life science computation. The scheduler is configured to favor starting jobs quickly and ensure maximum utilization.

{::elseif resource.name == Hammer }

* Hammer is optimized for loosely-coupled, high-throughput computation. The scheduler is configured to favor starting jobs quickly and ensure maximum utilization.
* The maximum job size is 8 processor cores. If you require resources with a greater degree of parallelism, please consider an alternate community cluster system optimized for high-performance, parallel computing.

{::elseif resource.name == Brown }

* Each Brown node contains the latest generation of Intel Xeon processor, codenamed Skylake.

{::elseif resource.name == Brown-GPU }

* Each ${resource.name} node contains ${resource.nodegpus} ${resource.gpuname} accelerator cards which can significantly improve performance of compute-intensive workloads.

{::elseif resource.name == Gilbreth }

${resource.name} differs from the previous Community Clusters in many significant aspects:

* Each ${resource.name} compute nodes are equipped with a variety of Nvidia Tesla GPU accelerator cards which can significantly improve performance of compute-intensive workloads.
* Each ${resource.name} front-end contains one Nvidia Tesla A30 accelerator card. This makes GPU code development and testing much simpler.
* GPU-enabled applications have both non-gpu and gpu-enabled versions installed. Typically, gpu-enabled versions are tagged with `gpu` in their module name, e.g., `lammps/31Mar17_gpu` is the GPU-enabled version of LAMMPS, while `lammps/31Mar17` is the non-gpu version of LAMMPS.
* An exception to the above rule is that for licensed softwares like Abaqus, Ansys, and Matlab, a single module contains both non-gpu and gpu-enabled versions.
* A selection of GPU-enabled application containers from the Nvidia GPU Cloud (NGC) collection is installed.

{::elseif resource.name == Bell}

${resource.name} differs from the previous Community Clusters in several significant aspects:

* ${resource.name} home directories are entirely separate from other Community Clusters home directories. There is no automatic copying or synchronization between the two. At their discretion, users can copy parts or all of the Community Clusters home directory into ${resource.name} - [instructions are provided](/knowledge/${resource.dir}/storage/transfer/copyhome).
* Users of `hsi` and `htar` commands may encounter Fortress keytab- and authentication-related error messages due to the dedicated nature of ${resource.name} home directories. A [temporary workaround is provided](/knowledge/${resource.dir}/faq/data/transferkeytab) while a permanent solution is being developed.
* ${resource.name} contains the latest generation of AMD EPYC processors, codenamed "Rome". These CPUs support AVX2 vector instructions set. When compiling your code, use of `-march=znver2` flag (for latest GCC, Clang and AOCC compilers) or `-march=core-avx2` (for Intel compilers and GCC prior to 9.3) is recommended.
* If your application heavily uses Intel MKL routines, setting the following environment variable is beneficial:

  ```
  export MKL_DEBUG_CPU_TYPE=5
  ```

  When using FFTW interface from MKL, please also set:

  ```
  export MKL_CBWR=AUTO
  ```
* If you use Jupyter notebooks, JupyterHub on ${resource.name} will only be available via the [OnDemand Gateway](https://${resource.oodname}.${resource.hostname}.rcac.purdue.edu) rather than the freestanding version as on previous systems. Other RCAC systems will transition to OnDemand as well, following ${resource.name}.
* A subset of ${resource.name} compute nodes contain ${resource.gpuname} accelerator cards which can significantly improve performance of compute-intensive workloads. These can be utilized by submitting jobs to the `${resource.gpuqueue}` queue (add `-A ${resource.gpuqueue}` to your job submission command).
* A selection of GPU-enabled ROCm application containers from the AMD InfinityHub collection is installed.

{::elseif resource.name == Negishi}

${resource.name} differs from the previous Community Clusters in several significant aspects:

* Host naming convention in the ${resource.name} cluster is different from earlier Community Clusters. Everything ${resource.name}-related is contained within a `${resource.hostname}.rcac.purdue.edu` subdomain. Front-end login nodes are now named `loginNN` (as opposed to earlier `<cluster>-feNN`), and compute nodes of each type `X` are named `xNNN` (as opposed to `<cluster>-xNNN`).
* ${resource.name} OnDemand Gateway is at the {::if resource.active != false}[${resource.oodname}.${resource.hostname}.rcac.purdue.edu](https://${resource.oodname}.${resource.hostname}.rcac.purdue.edu){::else}${resource.oodname}.${resource.hostname}.rcac.purdue.edu{::/} (as opposed to earlier `gateway.${resource.hostname}.rcac.purdue.edu` convention).
* ${resource.name} home directories are entirely separate from other Community Clusters home directories. There is no automatic copying or synchronization between the two. At their discretion, users can copy parts or all of the Community Clusters home directory into ${resource.name} - [instructions are provided](/knowledge/${resource.dir}/storage/transfer/copyhome).
* ${resource.name} contains the 3rd generation of AMD EPYC processors, codenamed "Milan". These CPUs support AVX2 vector instructions set. When compiling your code, use of `-march=znver3` flag (for latest GCC, Clang and AOCC compilers) or `-march=core-avx2` (for Intel compilers and GCC prior to 11.0) is recommended.
* GCC compiler with OpenMPI or MVAPICH2 MPI libraries are recommended for software development on ${resource.name}. You can enable this software with `module load gcc openmpi` (default) or `module load gcc mvapich2`.
* If you use Jupyter notebooks, JupyterHub on ${resource.name} will be available only via the [OnDemand Gateway](https://${resource.oodname}.${resource.hostname}.rcac.purdue.edu) rather than the freestanding version as on some previous systems. Other RCAC systems will transition to OnDemand as well, following ${resource.name}.

Upcoming 2023
-------------

* A subset of ${resource.name} compute nodes contain ${resource.gpuname} accelerator cards which can significantly improve performance of compute-intensive workloads. These can be utilized by submitting jobs to the `${resource.gpuqueue}` queue (add `-A ${resource.gpuqueue}` to your job submission command).
* A selection of GPU-enabled ROCm application containers from the AMD InfinityHub collection is installed.

{::elseif resource.name == Scholar }

${resource.name} differs from other Community Clusters in many significant aspects:

* ${resource.name} is a hybrid cluster for teaching courses that require high-performance computing.
* A subset of ${resource.name} front-ends contain ${resource.gpuname} accelerator cards. You can access these front ends by logging in to `${resource.gpu}.rcac.purdue.edu`.
* A subset of ${resource.name} compute nodes contain ${resource.gpuname} accelerator cards which can significantly improve performance of compute-intensive workloads. These can be utilized by submitting jobs to the `${resource.gpuqueue}` queue (add `-A ${resource.gpuqueue}` to your job submission command).
* A selection of GPU-enabled application containers from the Nvidia GPU Cloud (NGC) collection is installed.

{::/} {::if resource.naccesspolicy == singlejob }

* Jobs are scheduled on a whole-node basis and will not share nodes with other jobs by default. You may submit jobs that use less than one node, however, you will be allocated a whole node from your queue unless node sharing is enabled. Node sharing is enabled by adding `‑l naccesspolicy=singleuser` to your job's requirements.

{::/}