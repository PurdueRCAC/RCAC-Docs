---
tags:
  - Hammer
authors:
  - jin456
resource: Hammer
search:
  boost: 2
---

# Using Jupyter Hub

Hammer provides a JupyterHub instance at [https://notebook.hammer.rcac.purdue.edu](https://notebook.hammer.rcac.purdue.edu).

## What is Jupyter Hub

Jupyter (an acronym meaning Julia, Python and R) is a web-based interactive environment. Notebooks organize code, documentation, and results into a single document. JupyterHub provides a multi-user server that manages and proxies multiple instances of the single-user Jupyter notebook server.

## Getting Started

Navigate to [https://notebook.hammer.rcac.purdue.edu](https://notebook.hammer.rcac.purdue.edu) and log in with your Purdue career account credentials. After logging in, you will see your home directory in the file browser on the left side. You can create new notebooks using the "New" dropdown, which supports Bash, R, and Python kernels.

## Create Your Own Environment

You can create custom conda environments and register them as Jupyter kernels so that your notebooks use the packages you need.

### Step 1: Create a conda environment

```bash
$ module load anaconda
$ conda create -n myenv python=3.10
$ conda activate myenv
```

### Step 2: Install ipykernel in your environment

```bash
$ conda install ipykernel
$ python -m ipykernel install --user --name myenv --display-name "Python (myenv)"
```

### Step 3: Install your desired packages

```bash
$ conda install numpy scipy matplotlib
# or use pip
$ pip install <packagename>
```

### Step 4: Reload JupyterHub

After installing the kernel, reload the JupyterHub page. Your new environment will appear in the kernel selector when creating or switching kernels in a notebook.

## Running Notebooks

Once logged in, you can:

* Create new notebooks from the Launcher or File menu
* Upload existing notebooks using the upload button in the file browser
* Run cells interactively using `Shift+Enter` or the Run menu
* Open a terminal from the Launcher to run shell commands

## Accessing Scratch Space

Your scratch directory is available at `/scratch/hammer/$USER`. You can access it from within a notebook using Python:

```python
import os
scratch = os.environ.get('RCAC_SCRATCH', f'/scratch/hammer/{os.environ["USER"]}')
print(scratch)
```

## Limitations

* JupyterHub on Hammer runs on the front-end login nodes. Do not run long, memory-intensive, or CPU-heavy computations directly in notebooks on the front-end. Use the notebook interface to submit jobs to the scheduler instead.
* For heavy computational workloads, consider submitting batch jobs via the [Running Jobs](run_jobs/index.md) section.

[**Back to Hammer User Guide**](index.md)
