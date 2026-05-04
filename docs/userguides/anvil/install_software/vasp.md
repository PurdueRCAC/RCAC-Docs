# VASP

[**Back to the Anvil Software section**](../anvil-software.md)

The Vienna Ab initio Simulation Package (VASP) is a computer program for atomic scale materials modelling, e.g. electronic structure calculations and quantum-mechanical molecular dynamics, from first principles.

VASP License
------------

The VASP team allows only registered users who have purchased their own license to use the software and access is only given to the VASP release which is covered by the license of the respective research group. For those who are interested to use VASP on Anvil, please send a ticket to [ACCESS Help Desk](https://support.access-ci.org/open-a-ticket) to request access and provide your license for our verification. Once confirmed, the approved users will be given access to the `vasp5` or `vasp6` unix groups.

Please note, the license from Materials Design Inc is not accepted at this moment since we cannot verify the license information. If you hold a VASP license from Materials Design Inc, please check our user guide about build your own VASP below.

Prospective users can use the command below to check their unix groups on the system.

```bash
$ id $USER
```

If you are interested to purchase and get a VASP license, please visit [VASP](http://vasp.at) website for more information.

VASP 5 and VASP 6 Installations
-------------------------------

The Anvil team provides **VASP 5.4.4** and **VASP 6.3.0** installations and modulefiles with our default environment compiler `gcc/11.2.0` and mpi library `openmpi/4.1.6`. Note that only license-approved users can load the VASP modulefile as below.

You can use the VASP 5.4.4 module by:

```bash
$ module load gcc/11.2.0  openmpi/4.1.6
$ module load vasp/5.4.4.pl2
```

You can use the VASP 6.3.0 module by:

```bash
$ module load gcc/11.2.0  openmpi/4.1.6
$ module load vasp/6.3.0
```

Once a VASP module is loaded, you can choose one of the VASP executables to run your code: `vasp_std`, `vasp_gam`, and `vasp_ncl`.

!!! note
    The VASP pseudopotential files are not provided on Anvil, you may need to bring your own POTCAR files.

Here is an [example](../jobs.md/#running-vasp-on-anvil) of submit script for VASP simulations on Anvil.

Build your own VASP 5 and VASP 6
--------------------------------

If you would like to use your own VASP on Anvil, please follow the instructions for [Installing VASP.6.X.X](https://www.vasp.at/wiki/index.php/Installing_VASP.6.X.X) and [Installing VASP.5.X.X](https://www.vasp.at/wiki/index.php/Installing_VASP.5.X.X).

In the following sections, we provide some instructions about how to install VASP 5 and VASP 6 on Anvil and also the installation scripts:

## Build your own VASP 5

For VASP 5.X.X version, VASP provide several templates of `makefile.include` in the `/arch` folder, which contain information such as precompiler options, compiler options, and how to link libraries. You can pick up one based on your system and preferred features . Here we provide some examples about how to install the `vasp.5.4.4.pl2.tgz` version on Anvil with different module environments. We also prepared two versions of **VASP5 installation scripts** at the end of this page.

### Step 1: Download

As a license holder, you can download the source code of VASP from the [VASP Portal](https://www.vasp.at/sign_in/portal/), we will not check your license in this case.

Copy the VASP resource file `vasp.5.4.4.pl2.tgz` to the desired location, and unzip the file `tar zxvf vasp.5.4.4.pl2.tgz` to obtain the folder `/path/to/vasp-build-folder/vasp.5.4.4.pl2`and reveal its content.

### Step 2: Prepare makefile.include

* **For GNU compilers parallelized using OpenMPI, combined with MKL**

    We modified the [`makefile.include.linux_gnu`](/assets/scripts/userguides/anvil/makefile.include.linux_gnu) file to adapt the Anvil system. Download it to your VASP build folder `/path/to/vasp-build-folder/vasp.5.4.4.pl2`:

    ```bash
    $ cd /path/to/vasp-build-folder/vasp.5.4.4.pl2
    $ wget https://www.rcac.purdue.edu/files/knowledge/compile/src/makefile.include.linux_gnu
    $ cp makefile.include.linux_gnu makefile.include
    ```

    If you would like to include the Wannier90 interface, you may also need to include the following lines to the end of your `makefile.include` file:

    ```bash
    # For the interface to Wannier90 (optional)
    LLIBS += $(WANNIER90_HOME)/libwannier.a
    ```

    Load the required modules:

    ```bash
    $ module purge 
    $ module load gcc/11.2.0 openmpi/4.1.6
    $ module load intel-mkl
    # If you would like to include the Wannier90 interface, also load the following module:
    # $ module load wannier90/3.1.0
    ```
* **For Intel compilers parallelized using IMPI, combined with MKL**

    Copy the `makefile.include.linux_intel` templet from the `/arch` folder to your VASP build folder `/path/to/vasp-build-folder/vasp.5.4.4.pl2`:

    ```bash
    $ cd /path/to/vasp-build-folder/vasp.5.4.4.pl2
    $ cp arch/makefile.include.linux_intel makefile.include
    ```

    For better performance, you may add the following line to the end of your `makefile.include` file (above the GPU section):

    ```bash
    FFLAGS += -march=core-avx2
    ```

    If you would like to include the Wannier90 interface, you may also need to include the following lines to the end of your `makefile.include` file (above the GPU section):

    ```bash
    # For the interface to Wannier90 (optional)
    LLIBS += $(WANNIER90_HOME)/libwannier.a
    ```

    Load the required modules:

    ```bash
    $ module purge 
    $ module load intel/19.0.5.281  impi/2019.5.281
    $ module load intel-mkl
    # If you would like to include the Wannier90 interface, also load this module:
    # $ module load wannier90/3.1.0
    ```

### Step 3: Make

Build VASP with command `make all` to install all three executables `vasp_std`, `vasp_gam`, and `vasp_ncl` or use `make std` to install only the `vasp_std` executable. Use `make veryclean` to remove the build folder if you would like to start over the installation process.

### Step 4: Test

You can open an [Interactive session](https://www.rcac.purdue.edu/knowledge/anvil/run/interactive) to test the installed VASP, you may bring your own VASP test files:

```bash
$ cd /path/to/vasp-test-folder/
$ module purge 
$ module load gcc/11.2.0 openmpi/4.1.6 intel-mkl
# If you included the Wannier90 interface, also load this module:
# $ module load wannier90/3.1.0
$ mpirun /path/to/vasp-build-folder/vasp.5.4.4.pl2/bin/vasp_std
```

## Build your own VASP 6

For VASP 6.X.X version, VASP provide several templates of [`makefile.include`](https://www.vasp.at/wiki/index.php/Makefile.include), which contain information such as precompiler options, compiler options, and how to link libraries. You can pick up one based on your system and preferred features . Here we provide some examples about how to install `vasp 6.3.0` on Anvil with different module environments. We also prepared two versions of **VASP6 installation scripts** at the end of this page.

### Step 1: Download

As a license holder, you can download the source code of VASP from the [VASP Portal](https://www.vasp.at/sign_in/portal/), we will not check your license in this case.

Copy the VASP resource file `vasp.6.3.0.tgz` to the desired location, and unzip the file `tar zxvf vasp.6.3.0.tgz` to obtain the folder `/path/to/vasp-build-folder/vasp.6.3.0` and reveal its content.

### Step 2: Prepare makefile.include

* **For GNU compilers parallelized using OpenMPI + OpenMP, combined with MKL**

    We modified the [`makefile.include.gnu_ompi_mkl_omp`](/assets/scripts/userguides/anvil/makefile.include.gnu_ompi_mkl_omp) file to adapt the Anvil system. Download it to your VASP build folder `/path/to/vasp-build-folder/vasp.6.3.0`:

    ```bash
    $ cd /path/to/vasp-build-folder/vasp.6.3.0
    $ wget https://www.rcac.purdue.edu/files/knowledge/compile/src/makefile.include.gnu_ompi_mkl_omp
    $ cp makefile.include.gnu_ompi_mkl_omp makefile.include
    ```

    If you would like to include the Wannier90 interface, you may also need to include the following lines to the end of your `makefile.include` file:

    ```bash
    # For the VASP-2-Wannier90 interface (optional)
    CPP_OPTIONS    += -DVASP2WANNIER90
    WANNIER90_ROOT ?=$(WANNIER90_HOME)
    LLIBS          += -L$(WANNIER90_ROOT) -lwannier
    ```

    Then, load the required modules:

    ```bash
    $ module purge 
    $ module load gcc/11.2.0    openmpi/4.1.6
    $ module load intel-mkl hdf5 
    # If you would like to include the Wannier90 interface, also load the following module:
    # $ module load wannier90/3.1.0
    ```
* **For Intel compilers parallelized using IMPI + OpenMP, combined with MKL**

    We modified the [`makefile.include.intel_omp`](/assets/scripts/userguides/anvil/makefile.include.intel_omp) file to adapt the Anvil system. Download it to your VASP build folder `/path/to/vasp-build-folder/vasp.6.3.0`:

    ```bash
    $ cd /path/to/vasp-build-folder/vasp.6.3.0
    $ wget https://www.rcac.purdue.edu/files/knowledge/compile/src/makefile.include.intel_omp
    $ cp makefile.include.intel_omp makefile.include
    ```

    If you would like to include the Wannier90 interface, you may also need to include the following lines to the end of your `makefile.include` file:

    ```bash
    # For the VASP-2-Wannier90 interface (optional)
    CPP_OPTIONS    += -DVASP2WANNIER90
    WANNIER90_ROOT ?=$(WANNIER90_HOME)
    LLIBS          += -L$(WANNIER90_ROOT) -lwannier
    ```

    Then, load the required modules:

    ```bash
    $ module purge 
    $ module load intel/19.0.5.281  impi/2019.5.281
    $ module load intel-mkl hdf5 
    # If you would like to include the Wannier90 interface, also load the following module:
    # $ module load wannier90/3.1.0
    ```

### Step 3: Make

Open `makefile`, make sure the first line is `VERSIONS = std gam ncl`.

Build VASP with command `make all` to install all three executables `vasp_std`, `vasp_gam`, and `vasp_ncl` or use `make std` to install only the `vasp_std` executable. Use `make veryclean` to remove the build folder if you would like to start over the installation process.

### Step 4: Test

You can open an [Interactive session](../jobs.md/#interactive-jobs) to test the installed VASP 6. Here is an example of testing above installed VASP 6.3.0 with GNU compilers and OpenMPI:

```bash
$ cd /path/to/vasp-build-folder/vasp.6.3.0/testsuite
$ module purge 
$ module load gcc/11.2.0 openmpi/4.1.6 intel-mkl hdf5
# If you included the Wannier90 interface, also load the following module:
# $ module load wannier90/3.1.0
$ ./runtest
```

[**Back to the Anvil Software section**](../anvil-software.md)