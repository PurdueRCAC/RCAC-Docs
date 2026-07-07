---
tags:
  - Negishi
authors:
  - hkashgar
resource: Negishi
search:
  boost: 2
---

# Build your own VASP 6

For VASP 6.X.X version, VASP provide several templates of [`makefile.include`](https://www.vasp.at/wiki/index.php/Makefile.include), which contain information such as precompiler options, compiler options, and how to link libraries. You can pick up one based on your system and preferred features . Here we provide some examples about how to install `vasp 6.4.1` on Negishi with different module environments.

### Step 1: Download

As a license holder, you can download the source code of VASP from the [VASP Portal](https://www.vasp.at/sign_in/portal/), we will not check your license in this case.

Copy the VASP resource file `vasp.6.4.1.tgz` to the desired location, and unzip the file `tar zxvf vasp.6.4.1.tgz` to obtain the folder `/path/to/vasp-build-folder/vasp.6.4.1` and reveal its content.

### Step 2: Prepare makefile.include

We recommend to use GNU compilers parallelized using OpenMPI + OpenMP, combined with MKL for VASP build on Negishi.

We are using MKL library, which include BLAS, LAPACK, ScaLAPACK, and FFTW as suggested at [VASP wiki](https://www.vasp.at/wiki/index.php/Installing_VASP.6.X.X#Requirements). We can modify `makefile.include.gnu_ompi_mkl_omp` from `/arch` folder to fit for system setup:

```
$ cd /path/to/vasp-build-folder/vasp.6.4.1
$ cp makefile.include.gnu_ompi_mkl_omp makefile.include
```

Here are the suggested changes for `makefile.include`:

* change `VASP_TARGET_CPU ?= -march=native` to

  ```
  VASP_TARGET_CPU ?= -march=znver3
  ```
* remove `MKLROOT ?= /path/to/your/mkl/installation`
* change `LLIBS_MKL =`  to

  ```
  LLIBS  +=
  ```
* comment out or remove all the lines after `INCS = -I$(MKLROOT)/include/fftw`

Then, load the required modules:

```
$ module purge 
$ module load gcc/12.2.0  openmpi/4.1.4
$ module load intel-mkl/2019.9.304
```

### Step 3: Make

Open `makefile`, make sure the first line is `VERSIONS = std gam ncl`.

Build VASP with command `make all` to install all three executables `vasp_std`, `vasp_gam`, and `vasp_ncl` or use `make std` to install only the `vasp_std` executable. Use `make veryclean` to remove the build folder if you would like to start over the installation process.

### Step 4: Test

You can open an [Interactive session](../../run_jobs/interactive_jobs.md) to test the installed VASP 6. Here is an example of testing above installed VASP 6.4.1 with GNU compilers and OpenMPI:

```
$ cd /path/to/vasp-build-folder/vasp.6.4.1/testsuite
$ module purge 
$ module load gcc/12.2.0 openmpi/4.1.4 intel-mkl/2019.9.304
$ ./runtest
```

### Step 5: Submit a bash job

To submit a bash job with your own compiled VASP on Negishi, here is an example about how to set up your environment and launch MPI code.

```
#!/bin/bash

#SBATCH -A myqueuename  # Queue name(use 'slist' command to find queues' name)
#SBATCH --nodes=1       # Total # of nodes 
#SBATCH --ntasks=64     # Total # of MPI tasks
#SBATCH --time=1:00:00  # Total run time limit (hh:mm:ss)
#SBATCH -J myjobname    # Job name
#SBATCH -o myjob.o%j    # Name of stdout output file
#SBATCH -e myjob.e%j    # Name of stderr error file

# Manage processing environment,load compilers and applications.
module purge
module load gcc/12.2.0 openmpi/4.1.4 intel-mkl/2019.9.304
module list
export PATH=/path/to/vasp-build-folder/vasp.x.x.x/bin:$PATH

# Launch MPI code
mpirun -np $SLURM_NTASKS vasp_std
```

[**Back to the VASP section**](../vasp.md)
