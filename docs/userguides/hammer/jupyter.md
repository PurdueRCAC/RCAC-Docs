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

Jupyter is an acronym meaning Julia, Python and R. Jupyter supports many programming languages and allows you to organize projects in notebooks that contain code, explanations, and results, with various export formatting options.

## Getting Started

Navigate to [https://notebook.hammer.rcac.purdue.edu](https://notebook.hammer.rcac.purdue.edu) and log in with your Purdue career account credentials. After logging in, you will see your home directory in the file browser. To create a new notebook, click the **New** dropdown menu and select from the available kernels: Bash, R, or Python.

## Create Your Own Environment

You can create custom conda environments and register them as Jupyter kernels so that your notebooks use the packages you need.

1. Load the anaconda module:

    ```bash
    $ module load anaconda
    ```

2. Create a conda environment with your required packages:

    ```bash
    $ conda create -n MyEnvName python=3.10 numpy scipy
    ```

3. Activate the environment:

    ```bash
    $ conda activate MyEnvName
    ```

4. Install the environment as a Jupyter kernel:

    ```bash
    $ ipython kernel install --user --name MyEnvName --display-name "descriptive name"
    ```

5. Reload the Jupyter dashboard. Your new environment will appear in the kernel selector when creating or switching kernels in a notebook. You can also switch kernels at any time from the **Kernel** menu.

[**Back to Hammer User Guide**](index.md)
