---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# ML-Toolkit

A set of pre-installed popular machine learning (ML) libraries, called ML-Toolkit is maintained on ${resource.name}. These are Anaconda/Python-based distributions of the respective libraries. Currently, applications are supported for Python 2 and 3. Detailed instructions for searching and using the installed ML applications are presented below.

Instructions for using ML-Toolkit Modules
=========================================

Find and Use Installed ML Packages
----------------------------------

To search or load a machine learning application, you must first load one of the `learning` modules. The `learning` module loads the prerequisites (such as anaconda{::if resource.nodegpus !=0} and cudnn{::/}) and makes ML applications visible to the user.

**Step 1.** Find and load a preferred `learning` module. Several `learning` modules may be available, corresponding to a specific Python version and whether the ML applications have GPU support or not. Running `module load learning` without specifying a version will load the version with the most recent python version. To see all available modules, run `module spider learning` then load the desired module.

**Step 2.** Find and load the desired machine learning libraries

{::if resource.name == Gilbreth}ML packages are installed under the common application name `ml-toolkit-X`, where `X` can be `cpu` or `gpu`.{::elseif resource.name == Scholar}ML packages are installed under the common application name `ml-toolkit-X`, where `X` can be `cpu` or `gpu`.{::else}ML packages are installed under the common application name `ml-toolkit-cpu`{::/}

You can use the `module spider ml-toolkit` command to see all options and versions of each library.

Load the desired modules using the `module load` command. Note that both CPU and GPU options may exist for many libraries, so be sure to load the correct version. For example, if you wanted to load the most recent version of PyTorch for CPU, you would run `module load ml-toolkit-cpu/pytorch`

```
caffe          cntk          gym          keras          mxnet 
opencv         pytorch       tensorflow   tflearn        theano
```

**Step 3.** You can list which ML applications are loaded in your environment using the command `module list`

Verify application import
-------------------------

**Step 4.** The next step is to check that you can actually use the desired ML application. You can do this by running the `import` command in Python. The example below tests if PyTorch has been loaded correctly.

```
python -c "import torch; print(torch.__version__)"
```

If the import operation succeeded, then you can run your own ML code. Some ML applications (such as tensorflow) print diagnostic warnings while loading -- this is the expected behavior.

If the import fails with an error, please see the troubleshooting information below.

**Step 5.** To load a different set of applications, unload the previously loaded applications and load the new desired applications. The example below loads Tensorflow and Keras instead of PyTorch and OpenCV.

```
module unload ml-toolkit-cpu/opencv
module unload ml-toolkit-cpu/pytorch
module load ml-toolkit-cpu/tensorflow
module load ml-toolkit-cpu/keras
```

Troubleshooting
---------------

ML applications depend on a wide range of Python packages and mixing multiple versions of these packages can lead to error. The following guidelines will assist you in identifying the cause of the problem.

* Check that you are using the correct version of Python with the command `python --version`. This should match the Python version in the loaded anaconda module.
* Start from a clean environment. Either start a new terminal session or unload all the modules using `module purge`. Then load the desired modules following Steps 1-2.
* Verify that PYTHONPATH does not point to undesired packages. Run the following command to print PYTHONPATH: `echo $PYTHONPATH`. Make sure that your Python environment is clean. Watch out for any locally installed packages that might conflict.
* {::if resource.nodegpus !=0}If you don't see GPU devices in your code, make sure that you are using the `ml-toolkit-gpu/` modules and not using their cpu versions.
* ML applications often have dependency on specific versions of Cuda and CuDNN libraries. Make sure that you have loaded the required versions using the command: `module list`{::/}
* Note that Caffe has a conflicting version of PyQt5. So, if you want to use Spyder (or any GUI application that uses PyQt), then you should unload the caffe module.
* Use Google search to your advantage. Copy the error message in Google and check probable causes.

More examples showing how to use `ml-toolkit` modules in a batch job are presented in [ML Batch Jobs](/knowledge/${resource.dir}/run/examples/apps/learning/ml_batch) guide.