---
tags:
  - Negishi
  - Python
authors:
  - hkashgar
resource: Negishi
search:
  boost: 2
---

# Managing Environments with Conda

Conda is a package manager in Anaconda that allows you to create and manage multiple environments where you can pick and choose which packages you want to use. To use Conda you must load an Anaconda module:

```
$ module load conda
```

Many packages are pre-installed in the global environment. To see these packages:

```
$ conda list
```

To create your own custom environment:

```
$ conda create --name MyEnvName python=3.8 FirstPackageName SecondPackageName -y
```

The `--name` option specifies that the environment created will be named MyEnvName. You can include as many packages as you require separated by a space. Including the `-y` option lets you skip the prompt to install the package. By default environments are created and stored in the $HOME/.conda directory.

To create an environment at a custom location:

```
$ conda create --prefix=$HOME/MyEnvName python=3.8 PackageName -y
```

To see a list of your environments:

```
$ conda env list
```

To remove unwanted environments:

```
$ conda remove --name MyEnvName --all
```

To remove a package from an environment:

```
$ conda remove --name MyEnvName PackageName
```

Installing packages when creating your environment, instead of one at a time, will help you avoid dependency issues.

To activate or deactivate an environment you have created:

```
$ source activate MyEnvName
$ source deactivate MyEnvName
```

If you created your conda environment at a custom location using `--prefix` option, then you can activate or deactivate it using the full path.

```
$ source activate $HOME/MyEnvName
$ source deactivate $HOME/MyEnvName
```

To use a custom environment inside a job you must load the module and activate the environment inside your job submission script. Add the following lines to your submission script:

```
$ module load conda
$ source activate MyEnvName
```

For more information about Python:

* [The Python Programming Language - Official Website](http://www.python.org/)
* [Anaconda Python Distribution - Official Website](https://store.continuum.io/cshop/anaconda/)
* [Conda User Guide](https://conda.io/projects/conda/en/latest/user-guide/)

[**Back to the Python section**](../python.md)