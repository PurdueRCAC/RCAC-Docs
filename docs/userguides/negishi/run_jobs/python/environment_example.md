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


# Example: Create and Use Biopython Environment with Conda

## Using conda to create an environment that uses the biopython package

To use Conda you must first load the anaconda module:

```
module load conda
```

Create an empty conda environment to install biopython:

```
conda-env-mod create -n biopython
```

Now activate the biopython environment:

```
module load use.own
module load conda-env/biopython-py3.12.5
```

Install the biopython packages in your environment:

```
conda install --channel anaconda biopython -y
Fetching package metadata ..........
Solving package specifications .........
.......
Linking packages ...
[    COMPLETE    ]|################################################################
```

The `--channel` option specifies that it searches the anaconda channel for the biopython package. The `-y` argument is optional and allows you to skip the installation prompt. A list of packages will be displayed as they are installed.

Remember to add the following lines to your job submission script to use the custom environment in your jobs:

```
module load conda
module load use.own
module load conda-env/biopython-py3.12.5
```

If you need further help or run into any issues with creating environments, contact us.

For more information about Python:

* [The Python Programming Language - Official Website](http://www.python.org/)
* [Anaconda Python Distribution - Official Website](https://store.continuum.io/cshop/anaconda/)
* [Conda User Guide](https://conda.io/projects/conda/en/latest/user-guide/)

[**Back to the Python section**](../python.md)