# LAMMPS

[**Back to the Anvil Software section**](../anvil-software.md)

Large-scale Atomic/Molecular Massively Parallel Simulator (LAMMPS) is a molecular dynamics program from Sandia National Laboratories. LAMMPS makes use of Message Passing Interface for parallel communication and is a free and open-source software, distributed under the terms of the GNU General Public License.

## Provided LAMMPS module

LAMMPS modules
--------------

The Anvil team provides LAMMPS module with our default module environment `gcc/11.2.0` and `openmpi/4.0.6` to all users. It can be accessed by:

```bash
$ module load gcc/11.2.0 openmpi/4.0.6
$ module load lammps/20210310
```

The LAMMPS executable is `lmp` and the LAMMPS potential files are installed at `$LAMMPS_HOME/share/lammps/potentials`, where the value of `$LAMMPS_HOME`is the path to LAMMPS build folder. Use this variable in any scripts. Your actual LAMMPS folder path may change without warning, but this variable will remain current. The current path is:

```bash
$ echo $LAMMPS_HOME
$ /apps/spack/anvil/apps/lammps/20210310-gcc-11.2.0-jzfe7x3
```

## LAMMPS Job Submit Script

This is an example of a job submission file for running parallel LAMMPS jobs using the LAMMPS module installed on Anvil.

```bash
#!/bin/bash
# FILENAME:  myjobsubmissionfile

#SBATCH -A myallocation # Allocation name
#SBATCH --nodes=1       # Total # of nodes 
#SBATCH --ntasks=128    # Total # of MPI tasks
#SBATCH --time=1:30:00  # Total run time limit (hh:mm:ss)
#SBATCH -J lammps_tt    # Job name
#SBATCH -o myjob.o%j    # Name of stdout output file
#SBATCH -e myjob.e%j    # Name of stderr error file
#SBATCH -p wholenode    # Queue (partition) name

# Manage processing environment, load compilers and applications.
module --force purge
module load gcc/11.2.0 openmpi/4.0.6
module load lammps/20210310
module list

# Launch MPI code
srun -n $SLURM_NTASKS lmp
```

## Build your own LAMMPS

Build your own LAMMPS
---------------------

LAMMPS provides a very detailed instruction of [Build LAMMPS](https://docs.lammps.org/Build.html) with a lot of customization options. In the following sections, we provide basic installation instructions of how to install LAMMPS on Anvil, as well as a LAMMPS Installation Script in [current user guide section](#build-lammps-with-cmake) for users who would like to build their own LAMMPS on Anvil:

### Step 1: Download

LAMMPS is an open-source code, you can download LAMMPS as a tarball from [LAMMPS download page](https://www.lammps.org/download.html). There are several versions available on the LAMMPS webpage, we strongly recommend downloading the latest released `stable` version and unzip and untar it. It will create a LAMMPS directory:

```
$ wget https://download.lammps.org/tars/lammps-stable.tar.gz
$ tar -xzvf lammps-stable.tar.gz
$ ls 
lammps-23Jun2022 lammps-stable.tar.gz
```

### Step 2: Build source code

LAMMPS provides two ways to build the source code: traditional `configure && make` method and the `cmake` method. These are two independent approaches and users should not mix them together. You can choose the one you are more familiar with.

#### Build LAMMPS with Make

Traditional `make` method requires a `Makefile` file appropriate for your system in either the `src/MAKE`, `src/MAKE/MACHINES`, `src/MAKE/OPTIONS`, or `src/MAKE/MINE directory`. It provides various options to customize your LAMMPS. If you would like to build your own LAMMPS on Anvil with `make`, please follow the instructions for [Build LAMMPS with make](https://docs.lammps.org/Build_make.html). In the following sections, we will provide some instructions on how to install LAMMPS on Anvil with `make`.

**Include LAMMPS Packages**

In LAMMPS, a package is a group of files that enable a specific set of features. For example, force fields for molecular systems or rigid-body constraints are in packages. Usually, you can include only the packages you plan to use, but it doesn't hurt to run LAMMPS with additional packages.

To use `make` command to see the make options and package status, you need to first jump to `src` subdirectory. Here we will continue use `lammps-23Jun2022` as an example:

```
$ cd lammps-23Jun2022/src     # change to main LAMMPS source folder
$ make                        # see a variety of make options
$ make ps                     # check which packages are currently installed
```

For most LAMMPS packages, you can include them by:

```
$ make yes-PGK_NAME      # install a package with its name, default value is "no", which means exclude the package
# For example:
$ make yes-MOLECULE
```

A few packages require additional steps to include libraries or set variables, as explained on [Packages with extra build options](https://docs.lammps.org/Build_extras.html). If a package requires external libraries, you must configure and build those libraries before building LAMMPS and especially before enabling such a package.

If you have issues with installing external libraries, please contact us at [Help Desk](https://support.access-ci.org).

Instead of specifying all the package options via the command line, LAMMPS provides some [Make shortcuts for installing many packages](https://docs.lammps.org/Build_package.html#make-shortcuts-for-installing-many-packages), such as `make yes-most`, which will install most LAMMPS packages w/o libs. You can pick up one of the shortcuts based on your needs.

**Compilation**

Once the desired packages are included, you can compile lammps with our default environment: compiler `gcc/11.2.0` and MPI library `openmpi/4.0.6` , you can load them all at once by `module load modtree/cpu`. Then corresponding `make` option will be  `make g++_openmpi` for OpenMPI with compiler set to GNU g++.

Then the LAMMPS executable `lmp_g++_openmpi` will be generated in the `build` folder.

LAMMPS support parallel compiling, so you may submit an [Interactive job](../jobs.md/#interactive-jobs) to do parallel compiling.

If you get some error messages and would like to start over the installation process, you can delete compiled objects, libraries and executables with `make clean-all`.

**Examples**

Here is an example of how to install the `lammps-23Jun2022` version on Anvil with most packages enabled:

```
# Setup module environments
$ module purge
$ module load modtree/cpu
$ module load hdf5 fftw gsl netlib-lapack
$ module list

$ cd lammps-23Jun2022/src  # change to main LAMMPS source folder
$ make yes-most            # install most LAMMPS packages w/o libs
$ make ps                  # check which packages are currently installed

# compilation
$ make g++_openmpi        # or "make -j 12 g++_openmpi" to do parallel compiling if you open an interactive session with 12 cores.
```

**Tips**

When you run LAMMPS and get an error like "command or style is unknown", it is likely due to the fact you did not include the required packages for that command or style. If the command or style is available in a package included in the LAMMPS distribution, the error message will indicate which package would be needed.

For more information about LAMMPS build options, please refer to these sections of LAMMPS documentation:

* [Serial vs parallel build](https://docs.lammps.org/Build_make.html#customized-builds-and-alternate-makefiles)
* [Choice of compiler and compile/link options](https://docs.lammps.org/Build_basics.html#compile)
* [Build the LAMMPS executable and library](https://docs.lammps.org/Build_basics.html#exe)
* [Including and removing debug support](https://docs.lammps.org/Build_basics.html#debug)
* [Build LAMMPS tools](https://docs.lammps.org/Build_basics.html#build-lammps-tools)
* [Install LAMMPS after a build](https://docs.lammps.org/Build_basics.html#install)
* [Optional build settings](https://docs.lammps.org/Build_settings.html)

#### Build LAMMPS with Cmake

CMake is an alternative to compiling LAMMPS in addition to the traditional [Make](#build-lammps-with-make) method. CMake has several advantages, and might be helpful for people with limited experience in compiling software or for those who want to modify or extend LAMMPS. If you prefer using `cmake`, please follow the instructions for [Build LAMMPS with CMake](https://docs.lammps.org/Build_cmake.html). In the following sections, we will provide some instructions on how to install LAMMPS on Anvil with `cmake` and the LAMMPS Installation Script in [current user guide section](#build-lammps-with-cmake):

**Use CMake to generate a build environment**

1. First go to your LAMMPS directory and generate a new folder `build` for build environment. Here we will continue use `lammps-23Jun2022` as an example:

   ```
   $ cd lammps-23Jun2022
   $ mkdir build; cd build    # create and change to a build directory
   ```
2. To use `cmake`features, you need to `module load cmake` first.
3. For basic LAMMPS installation with no add-on packages enabled and no customization, you can generate a build environment by:

   ```
   $ cmake ../cmake         # configuration reading CMake scripts from ../cmake
   ```
4. You can also choose to include or exclude [packages](https://docs.lammps.org/Packages.html) to or from build.

   In LAMMPS, a package is a group of files that enable a specific set of features. For example, force fields for molecular systems or rigid-body constraints are in packages. Usually, you can include only the packages you plan to use, but it doesn't hurt to run LAMMPS with additional packages.

   For most LAMMPS packages, you can include it by adding the following flag to `cmake` command:

   ```
   -D PKG_NAME=yes   # degualt value is "no", which means exclude the package
   ```

   For example:

   ```
   $ cmake -D PKG_MOLECULE=yes -D PKG_RIGID=yes -D PKG_MISC=yes ../cmake
   ```

   A few packages require additional steps to include libraries or set variables, as explained on [Packages with extra build options](https://docs.lammps.org/Build_extras.html). If you have issue with installing external libraries, please contact us at [Help Desk](https://support.access-ci.org).
5. Instead of specifying all the package options via the command line, LAMMPS provides some CMake setting scripts in `/cmake/presets` folder. You can pick up one of them or customize it based on your needs.
6. If you get some error messages after the `cmake ../cmake` step and would like to start over, you can delete the whole `build` folder and create new one:

   ```
   $ cd lammps-23Jun2022
   $ rm -rf build
   $ mkdir build && cd build
   ```

**Compilation**

1. Once the build files are generated by `cmake` command, you can compile lammps with our default environments: compiler `gcc/11.2.0` and MPI library `openmpi/4.0.6` , you can load them all at once by `module load modtree/cpu`.
2. Then, the next step is to compile LAMMPS with `make` or `cmake --build`,  upon completion, the LAMMPS executable `lmp` will be generated in the `build` folder.
3. LAMMPS supports parallel compiling, so you may submit an [Interactive job](../jobs.md/#interactive-jobs) to do parallel compilation.
4. If you get some error with compiling, you can delete compiled objects, libraries and executables with `make clean` or `cmake --build . --target clean`.

**Examples**

Here is an example of how to install the `lammps-23Jun2022` version on Anvil with most packages enabled:

```
# Setup module environments
$ module purge
$ module load modtree/cpu
$ module load hdf5 fftw gsl netlib-lapack
$ module load cmake anaconda
$ module list

$ cd lammps-23Jun2022      # change to the LAMMPS distribution directory
$ mkdir build; cd build;   # create and change to a build directory

# enable most packages and setup Python package library path
$ cmake -C ../cmake/presets/most.cmake -D PYTHON_EXECUTABLE=$CONDA_PYTHON_EXE ../cmake
# If everything works well, you will see
# -- Build files have been written to: /path-to-lammps/lammps-23Jun2022/build

# compilation
$ make      # or "make -j 12" to do parallel compiling if you open an interactive session with 12 cores.
# If everything works well, you will see
# [100%] Built target lmp
```

The CMake setting script `/cmake/presets/most.cmake` we used in the example here will includes 57 most common packages:

```
$ ASPHERE BOCS BODY BROWNIAN CG-DNA CG-SDK CLASS2 COLLOID COLVARS COMPRESS CORESHELL DIELECTRIC DIFFRACTION DIPOLE DPD-BASIC DPD-MESO DPD-REACT DPD-SMOOTH DRUDE EFF EXTRA-COMPUTE EXTRA-DUMP EXTRA-FIX EXTRA-MOLECULE EXTRA-PAIR FEP GRANULAR INTERLAYER KSPACE MACHDYN MANYBODY MC MEAM MISC ML-IAP ML-SNAP MOFFF MOLECULE OPENMP OPT ORIENT PERI PLUGIN POEMS QEQ REACTION REAXFF REPLICA RIGID SHOCK SPH SPIN SRD TALLY UEF VORONOI YAFF
```

**Tips**

When you run LAMMPS and get an error like "command or style is unknown", it is likely due to you did not include the required packages for that command or style. If the command or style is available in a package included in the LAMMPS distribution, the error message will indicate which package would be needed.

After the initial build, whenever you edit LAMMPS source files, enable or disable packages, change compiler flags or build options, you must recompile LAMMPS with `make`.

For more information about LAMMPS build options, please following these links from LAMMPS website:

* [Serial vs parallel build](https://docs.lammps.org/Build_basics.html#serial)
* [Choice of compiler and compile/link options](https://docs.lammps.org/Build_basics.html#compile)
* [Build the LAMMPS executable and library](https://docs.lammps.org/Build_basics.html#exe)
* [Including and removing debug support](https://docs.lammps.org/Build_basics.html#debug)
* [Build LAMMPS tools](https://docs.lammps.org/Build_basics.html#build-lammps-tools)
* [Install LAMMPS after a build](https://docs.lammps.org/Build_basics.html#install)
* [Optional build settings](https://docs.lammps.org/Build_settings.html)

**LAMMPS Installation Script**

Here we provide a `lammps-23Jun2022` installation script with `cmake`. It contains the procedures from downloading the source code to what we mentioned in [Build LAMMPS with Cmake](#build-lammps-with-cmake) `Example` section. You will start with making an empty folder. Then, download the installation script[`install-lammps.sh`](/assets/scripts/userguides/anvil/install-lammps.sh) to this folder. Since parallel compiling with 12 cores is used in the script, you may submit an [Interactive job](../jobs.md/#interactive-jobs) to ask for 12 cores:

```bash
$ mkdir lammps; cd lammps;   # create and change to a lammps directory
$ wget https://www.rcac.purdue.edu/files/knowledge/compile/src/install-lammps.sh
$ ls
install-lammps.sh
$ sinteractive -N 1 -n 12 -A oneofyourallocations -p shared -t 1:00:00
$ bash install-lammps.sh
```

[**Back to the Anvil Software section**](../anvil-software.md)