---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# How is Bell different than other Community Clusters?

Bell differs from the previous Community Clusters in several significant aspects:

* Bell home directories are entirely separate from other Community Clusters home directories. There is no automatic copying or synchronization between the two. At their discretion, users can copy parts or all of the Community Clusters home directory into Bell. [Instructions are provided](../../storage/transfer/copyhome.md).
* Users of `hsi` and `htar` commands may encounter Fortress keytab- and authentication-related error messages due to the dedicated nature of Bell home directories. A [temporary workaround is provided](../data/transferkeytab.md) while a permanent solution is being developed.
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

[**Back to the About Bell section**](../about.md)
