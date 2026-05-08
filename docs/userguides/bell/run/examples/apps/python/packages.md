---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Installing Packages

Installing Python packages in an Anaconda environment is recommended. One key advantage of Anaconda is that it allows users to install unrelated packages in separate self-contained environments. Individual packages can later be reinstalled or updated without impacting others. If you are unfamiliar with Conda environments, please check our [Conda Guide](/knowledge/${resource.dir}/run/examples/apps/python/conda).

To facilitate the process of creating and using Conda environments, we support a script (`conda-env-mod`) that generates a module file for an environment, as well as an optional Jupyter kernel to use this environment in a JupyterHub notebook.

You must load one of the `anaconda` modules in order to use this script.

```
$ module load conda
```

Step-by-step instructions for installing custom Python packages are presented below.

Step 1: Create a conda environment
----------------------------------

Users can use the `conda-env-mod` script to create an empty conda environment. This script needs either a name or a path for the desired environment. After the environment is created, it generates a module file for using it in future. Please note that `conda-env-mod` is different from the official `conda-env` script and supports a limited set of subcommands. Detailed instructions for using `conda-env-mod` can be found with the command `conda-env-mod --help`.

* **Example 1:** Create a conda environment named `mypackages` in user's `$HOME` directory.

  ```
  $ conda-env-mod create -n mypackages
  ```
* **Example 2:** Create a conda environment named `mypackages` at a custom location.

  ```
  $ conda-env-mod create -p /depot/mylab/apps/mypackages
  ```

  Please follow the on-screen instructions while the environment is being created. After finishing, the script will print the instructions to use this environment.

  ```
  ... ... ...
  Preparing transaction: ...working... done
  Verifying transaction: ...working... done
  Executing transaction: ...working... done
  +------------------------------------------------------+
  | To use this environment, load the following modules: |
  |       module load use.own                            |
  |       module load conda-env/mypackages-py3.8.5      |
  +------------------------------------------------------+
  Your environment "mypackages" was created successfully.
  ```

Note down the module names, as you will need to load these modules every time you want to use this environment. You may also want to add the `module load` lines in your jobscript, if it depends on custom Python packages.

By default, module files are generated in your `$HOME/privatemodules` directory. The location of module files can be customized by specifying the `-m /path/to/modules` option to `conda-env-mod`.

**Note:** The main differences between `-p` and `-m` are: 1) `-p` will change the location of packages to be installed for the env and the module file will still be located at the `$HOME/privatemodules` directory as defined in use.own. 2) `-m` will only change the location of the module file. So the method to load modules created with `-m` and `-p` are different, see Example 3 for details.

* **Example 3:** Create a conda environment named `labpackages` in your group's Data Depot space and place the module file at a shared location for the group to use.

  ```
  $ conda-env-mod create -p /depot/mylab/apps/labpackages -m /depot/mylab/etc/modules
  ... ... ...
  Preparing transaction: ...working... done
  Verifying transaction: ...working... done
  Executing transaction: ...working... done
  +-------------------------------------------------------+
  | To use this environment, load the following modules:  |
  |       module use /depot/mylab/etc/modules             |
  |       module load conda-env/labpackages-py3.8.5      |
  +-------------------------------------------------------+
  Your environment "labpackages" was created successfully.
  ```

If you used a custom module file location, you need to run the `module use` command as printed by the command output above.

By default, only the environment and a module file are created (no Jupyter kernel). If you plan to use your environment in a JupyterHub notebook, you need to append a `--jupyter` flag to the above commands.

* **Example 4:** Create a Jupyter-enabled conda environment named `labpackages` in your group's Data Depot space and place the module file at a shared location for the group to use.

  ```
  $ conda-env-mod create -p /depot/mylab/apps/labpackages -m /depot/mylab/etc/modules --jupyter
  ... ... ...
  Jupyter kernel created: "Python (My labpackages Kernel)"
  ... ... ...
  Your environment "labpackages" was created successfully.
  ```

Step 2: Load the conda environment
----------------------------------

* The following instructions assume that you have used `conda-env-mod` script to create an environment named `mypackages` (Examples 1 or 2 above). If you used `conda create` instead, please use `conda activate mypackages`.

  ```
  $ module load use.own
  $ module load conda-env/mypackages-py3.8.5
  ```

  Note that the `conda-env` module name includes the Python version that it supports (Python 3.8.5 in this example). This is same as the Python version in the `conda` module.
* If you used a custom module file location (Example 3 above), please use `module use` to load the `conda-env` module.

  ```
  $ module use /depot/mylab/etc/modules
  $ module load conda-env/labpackages-py3.8.5
  ```

{::if resource.name != Weber}

Step 3: Install packages
------------------------

Now you can install custom packages in the environment using either `conda install` or `pip install`.

### Installing with conda

* **Example 1:** Install OpenCV (open-source computer vision library) using conda.

  ```
  $ conda install opencv
  ```
* **Example 2:** Install a specific version of OpenCV using conda.

  ```
  $ conda install opencv=4.5.5
  ```
* **Example 3:** Install OpenCV from a specific anaconda channel.

  ```
  $ conda install -c anaconda opencv
  ```

### Installing with pip

* **Example 4:** Install pandas using pip.

  ```
  $ pip install pandas
  ```
* **Example 5:** Install a specific version of pandas using pip.

  ```
  $ pip install pandas==1.4.3
  ```

  Follow the on-screen instructions while the packages are being installed. If installation is successful, please proceed to the next section to test the packages.

**Note:** Do **NOT** run Pip with the `--user` argument, as that will install packages in a different location and might mess up your account environment.

Step 4: Test the installed packages
-----------------------------------

{::else}

Step 3: Test the installed packages
-----------------------------------

{::/}

To use the installed Python packages, you must load the module for your conda environment. If you have not loaded the `conda-env` module, please do so following the instructions at the end of Step 1.

```
$ module load use.own
$ module load conda-env/mypackages-py3.8.5
```

* **Example 1:** Test that OpenCV is available.

  ```
  $ python -c "import cv2; print(cv2.__version__)"
  ```
* **Example 2:** Test that pandas is available.

  ```
  $ python -c "import pandas; print(pandas.__version__)"
  ```

If the commands finished without errors, then the installed packages can be used in your program.

Additional capabilities of conda-env-mod script
-----------------------------------------------

The `conda-env-mod` tool is intended to facilitate creation of a minimal Anaconda environment, matching module file and optionally a Jupyter kernel. Once created, the environment can then be accessed via familiar `module load` command, tuned and expanded as necessary. Additionally, the script provides several auxiliary functions to help manage environments, module files and Jupyter kernels.

General usage for the tool adheres to the following pattern:

```
$ conda-env-mod help
$ conda-env-mod <subcommand> <required argument> [optional arguments]
```

where required arguments are one of

* `-n|--name ENV_NAME` (name of the environment)
* `-p|--prefix ENV_PATH` (location of the environment)

and optional arguments further modify behavior for specific actions (e.g. `-m` to specify alternative location for generated module files).

Given a required name or prefix for an environment, the `conda-env-mod` script supports the following subcommands:

* `create` - to create a new environment, its corresponding module file and optional Jupyter kernel.
* `delete` - to delete existing environment along with its module file and Jupyter kernel.
* `module` - to generate just the module file for a given existing environment.
* `kernel` - to generate just the Jupyter kernel for a given existing environment (note that the environment has to be created with a `--jupyter` option).
* `help` - to display script usage help.

Using these subcommands, you can iteratively fine-tune your environments, module files and Jupyter kernels, as well as delete and re-create them with ease. Below we cover several commonly occurring scenarios.

**Note:** When you try to use `conda-env-mod delete`, remember to include the arguments as you create the environment (i.e. `-p package_location` and/or `-m module_location`).

### Generating module file for an existing environment

If you already have an existing configured Anaconda environment and want to generate a module file for it, follow appropriate examples from **Step 1** above, but use the `module` subcommand instead of the `create` one. E.g.

```
$ conda-env-mod module -n mypackages
```

and follow printed instructions on how to load this module. With an optional `--jupyter` flag, a Jupyter kernel will also be generated.

**Note that** the module name `mypackages` should be exactly the same with the older conda environment name. **Note also that** if you intend to proceed with a Jupyter kernel generation (via the `--jupyter` flag or a `kernel` subcommand later), you will have to ensure that your environment has `ipython` and `ipykernel` packages installed into it. To avoid this and other related complications, we highly recommend making a fresh environment using a suitable `conda-env-mod create .... --jupyter` command instead.

### Generating Jupyter kernel for an existing environment

If you already have an existing configured Anaconda environment and want to generate a Jupyter kernel file for it, you can use the `kernel` subcommand. E.g.

```
$ conda-env-mod kernel -n mypackages
```

This will add a `"Python (My mypackages Kernel)"` item to the dropdown list of available kernels upon your next login to the {::if resource.notebook == true}[JupyterHub](https://notebook.${resource.hostname}.rcac.purdue.edu/){::else}JupyterHub{::/}.

Note that generated Jupiter kernels are always personal (i.e. each user has to make their own, even for shared environments). Note also that you (or the creator of the shared environment) will have to ensure that your environment has `ipython` and `ipykernel` packages installed into it.

### Managing and using shared Python environments

Here is a suggested workflow for a common group-shared Anaconda environment with Jupyter capabilities:

**The PI or lab software manager:**

* Creates the environment and module file (once):

  ```
  $ module purge
  $ module load conda
  $ conda-env-mod create -p /depot/mylab/apps/labpackages -m /depot/mylab/etc/modules --jupyter
  ```
* Installs required Python packages into the environment (as many times as needed):

  ```
  $ module use /depot/mylab/etc/modules
  $ module load conda-env/labpackages-py3.8.5
  $ conda install  .......                       # all the necessary packages
  ```

**Lab members:**

* Lab members can start using the environment in their command line scripts or batch jobs simply by loading the corresponding module:

  ```
  $ module use /depot/mylab/etc/modules
  $ module load conda-env/labpackages-py3.8.5
  $ python my_data_processing_script.py .....
  ```
* To use the environment in Jupyter notebooks, each lab member will need to create his/her own Jupyter kernel (once). This is because Jupyter kernels are private to individuals, even for shared environments.

  ```
  $ module use /depot/mylab/etc/modules
  $ module load conda-env/labpackages-py3.8.5
  $ conda-env-mod kernel -p /depot/mylab/apps/labpackages
  ```

A similar process can be devised for instructor-provided or individually-managed class software, etc.

Troubleshooting
---------------

* Python packages often fail to install or run due to dependency incompatibility with other packages. More specifically, if you previously installed packages in your home directory it is safer to clean those installations.

  ```
  $ mv ~/.local ~/.local.bak
  $ mv ~/.cache ~/.cache.bak
  ```
* Unload all the modules.

  ```
  $ module purge
  ```
* Clean up PYTHONPATH.

  ```
  $ unset PYTHONPATH
  ```
* Next load the modules (e.g. anaconda) that you need.

  ```
  $ module load conda/2024.02-py311
  $ module load use.own
  $ module load conda-env/2024.02-py311
  ```
* Now try running your code again.
* Few applications only run on specific versions of Python (e.g. Python 3.6). Please check the documentation of your application if that is the case.