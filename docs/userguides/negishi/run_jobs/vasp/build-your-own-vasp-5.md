---
tags:
  - Negishi
authors:
  - hkashgar
resource: Negishi
search:
  boost: 2
---

# Build your own VASP 5

For VASP 5.X.X version, VASP provide several templates of `makefile.include` in the `/arch` folder, which contain information such as precompiler options, compiler options, and how to link libraries. You can pick up one based on your system and preferred features. Here we provide some examples about how to install the `vasp.5.4.4.pl2.tgz` version on Negishi with different module environments.

### Step 1: Download

As a license holder, you can download the source code of VASP from the [VASP Portal](https://www.vasp.at/sign_in/portal/), we will not check your license in this case.

Copy the VASP resource file `vasp.5.4.4.pl2.tgz` to the desired location, and unzip the file `tar zxvf vasp.5.4.4.pl2.tgz` to obtain the folder `/path/to/vasp-build-folder/vasp.5.4.4.pl2`and reveal its content.

### Step 2: Prepare makefile.include

We recommend to use GNU compilers parallelized using OpenMPI, combined with MKL for VASP compilation on Negishi.

We are using MKL library, which include BLAS, LAPACK, ScaLAPACK, and FFTW as suggested at [VASP wiki](https://www.vasp.at/wiki/index.php/Installing_VASP.5.X.X#Requirements), and we can modify `makefile.include.linux_gnu` from `/arch` folder:

```
$ cd /path/to/vasp-build-folder/vasp.5.4.4.pl2
cp arch/makefile.include.linux_gnu makefile.include
```

Here are the suggested changes for `makefile.include`, replace the lines between `DEBUG=-O0` and `OBJECTS= fftmpiw.o fftmpi_map.o fftw3d.o fft3dlib.o` with

```
# Intel MKL (FFTW, BLAS, LAPACK, and scaLAPACK)
LLIBS     += -L${MKLROOT}/lib/intel64 -Wl,--no-as-needed -lmkl_gf_lp64 -lmkl_gnu_thread -lmkl_core -lmkl_scalapack_lp64 -lmkl_blacs_openmpi_lp64 -lgomp -lpthread -lm -ldl
INCS       = -I$(MKLROOT)/include/fftw
FFLAGS     += -march=znver3

# For gcc-10 and higher (comment out for older versions)
FFLAGS     += -fallow-argument-mismatch
```

Remove all the `GPU stuff` at the end of `makefile.include` file

Load the required modules:

```
module --force purge 
module load gcc/12.2.0 openmpi/4.1.4
module load intel-mkl/2019.9.304
```

### Step 3: Make

Build VASP with command `make all` to install all three executables `vasp_std`, `vasp_gam`, and `vasp_ncl` or use `make std` to install only the `vasp_std` executable. Use `make veryclean` to remove the build folder if you would like to start over the installation process.

### Step 4: Test

You can open an [Interactive session](../../run_jobs/interactive_jobs.md) to test the installed VASP with GNU/openMPI compilation, you may bring your own VASP test files:

```
$ cd /path/to/vasp-test-folder/
module --force purge 
module load gcc/12.2.0 openmpi/4.1.4 intel-mkl/2019.9.304
module list
mpirun /path/to/vasp-build-folder/vasp.5.4.4.pl2/bin/vasp_std
```

### Step 5: submit a bash job

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
