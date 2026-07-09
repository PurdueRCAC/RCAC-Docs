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
# Managing Packages with Pip

Pip is a Python package manager. Many Python package documentation provide `pip` instructions that result in permission errors because by default `pip` will install in a system-wide location and fail.

```

Exception:
Traceback (most recent call last):
... ... stack trace ... ...
OSError: [Errno 13] Permission denied: '/apps/cent7/anaconda/2020.07-py38/lib/python3.8/site-packages/mkl_random-1.1.1.dist-info'
```

If you encounter this error, it means that you cannot modify the global Python installation. We recommend installing Python packages in a conda environment. Detailed instructions for installing packages with `pip` can be found in our [Python package installation page](../packages).

Below we list some other useful `pip` commands.

* Search for a package in PyPI channels:

  ```
  $ pip search packageName
  ```
* Check which packages are installed globally:

  ```
  $ pip list
  ```
* Check which packages you have personally installed:

  ```
  $ pip list --user
  ```
* Snapshot installed packages:

  ```
  $ pip freeze > requirements.txt
  ```
* You can install packages from a snapshot inside a new conda environment. Make sure to load the appropriate conda environment first.

  ```
  $ pip install -r requirements.txt
  ```

For more information about Python:

* [The Python Programming Language - Official Website](http://www.python.org/)
* [Anaconda Python Distribution - Official Website](https://store.continuum.io/cshop/anaconda/)
* [Conda User Guide](https://conda.io/projects/conda/en/latest/user-guide/)

[**Return to the Python**](../python.md)
