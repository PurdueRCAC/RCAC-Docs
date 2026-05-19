# Installing Packages from Source

We maintain several [Anaconda](https://www.anaconda.com/) installations. Anaconda maintains numerous popular scientific Python libraries in a single installation. If you need a Python library not included with normal Python we recommend first checking Anaconda. For a list of modules currently installed in the Anaconda Python distribution:

```
$ module load conda
$ conda list
# packages in environment at /apps/spack/bell/apps/anaconda/2020.02-py37-gcc-4.8.5-u747gsx:
#
# Name                    Version                   Build  Channel
_ipyw_jlab_nb_ext_conf    0.1.0                    py37_0  
_libgcc_mutex             0.1                        main  
alabaster                 0.7.12                   py37_0  
anaconda                  2020.02                  py37_0  
...
```

If you see the library in the list, you can simply import it into your Python code after loading the Anaconda module.

If you do not find the package you need, you should be able to install the library in your own Anaconda customization. First try to install it with [Conda or Pip](packages.md). If the package is not available from either Conda or Pip, you may be able to install it from source.

Use the following instructions as a guideline for installing packages from source. Make sure you have a download link to the software (usually it will be a `tar.gz` archive file). You will substitute it on the wget line below.

We also assume that you have already created an empty conda environment as described in our [Python package installation guide](packages.md).

```
$ mkdir ~/src
$ cd ~/src
$ wget http://path/to/source/tarball/app-1.0.tar.gz
$ tar xzvf app-1.0.tar.gz
$ cd app-1.0
$ module load conda
$ module load use.own
$ module load conda-env/mypackages-py3.8.5
$ python setup.py install
$ cd ~
$ python
>>> import app
>>> quit()
```

The "import app" line should return without any output if installed successfully. You can then import the package in your python scripts.

If you need further help or run into any issues installing a library, [contact us](https://www.rcac.purdue.edu/help) or drop by [Coffee Hour](https://www.rcac.purdue.edu/coffee) for in-person help.

For more information about Python:

* [The Python Programming Language - Official Website](http://www.python.org/)
* [Anaconda Python Distribution - Official Website](https://store.continuum.io/cshop/anaconda/)
* [Conda User Guide](https://conda.io/projects/conda/en/latest/user-guide/)
