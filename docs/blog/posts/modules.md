---
date:
  created: 2026-09-16
  #Sometimes, bloggers need to update a post. This might happen when you make a mistake or when something changes that you need to reflect in the post. To indicate you have edited a post, you can include an updated date in the page header.
  #updated: 2025-09-03

categories:
  - Software

#Title will change how it's displayed on website
title: 'The "It Works on My Laptop" Dilemma: Managing Software with Modules'

#Slug will change how it's shown in the domain url
slug: modules

tags:
  - Software
authors:
  - carls113
---

A supercomputer without software is like an engine without a car. It can be powerful, with nothing to do. Software is what gives supercomputers purpose and direction, without it they would be useless. Sometimes this software is already installed on the supercomputer and sometimes it is something that you install yourself. Regardless of how it got there, we need a way to manage it, especially if there are multiple versions of the same software.

<!-- more -->

##What are Modules?

Supercomputers have many users. Each of these users has their own set of software that they want to use that may have conflicting versions. For example, one person may want to use python 3.9 and another one wants to use python 3.12. If they were both available all the time to everyone, it would be confusing which python you would be using. To combat this problem, many HPC centers introduce modules, which load different software into each shell session, creating an independent, standalone solution.

There are a couple of different module systems available to HPC centers, but the one that Purdue uses is called `lmod`. Modules are named such that you can specify just the software name and load in the default version (usually the most recent). Or you can specify a version with the software name to get that version specifically. There are a few commands that are useful to know to navigate the modules on each system:

`module avail` will print out all the software modules that are available to be loaded into your shell.

`module spider SOFTWARE/VERSION` where `SOFTWARE` is replaced with the name of the software you are interested in and `/VERSION` is optionally added to get more information about a specific version of the software. This command gives information about what the module is and if the version is specified, will tell you whether there are additional dependency modules that need to be loaded before you can load the software you want.

`module load SOFTWARE/VERSION` will load the software (with the optional specified version) into your shell to be used. More discussion about what this does under the hood in a later section.

`module show SOFTWARE` will print out what the module does to your shell to load the software. This can be useful for debugging or learning purposes.

`module use PATH` will start to look for module files in the specified `PATH`. This is useful/necessary when you write your own modules.

A typical workflow could be as follows: `module avail` to see what software is currently available. Once you choose what you want to load (e.g. Abaqus), you could run `module spider abaqus` to get version information about Abaqus. Once you have selected the version you want (e.g. 2026) you can run `module spider abaqus/2026` to see if there are any modules you need to load before you can load the module you want. For `abaqus/2026`, it appears that we need to load `intel/19.1.3.304`before we can load Abaqus. If we try to load Abaqus before we load Intel, it will throw an error and say, “you cannot do that”. So, we dutifully load Intel first: `module load intel/19.1.3.304`. Next, we can load the Abaqus module we want to use: `module load abaqus/2026`. Now we can run Abaqus in that shell: `abaqus` and it will start.

Another typical workflow could look like the previous one but start with a `module use` command (e.g. `module use /depot/labname/etc/modulefiles`) and then follow with all the other commands. This would allow you to use all the modulefiles that have been created by your group in your depot space.

##What do Modules do?

Modules at their heart modify environmental variables. This is not a blog post about environmental variables, so I will not go into detail about them, but there are a few that are necessary to understand to fully unlock the power of modules:

`PATH`: This is where the shell will look for executables. It is comprised of a list of paths separated by colons (:). Whenever you type a command in the shell, the computer looks in each of the directories specified in the `PATH` variable in order until it finds a match to what was entered.

`LD_LIBRARY_PATH`: This is a list of directories that contain special libraries that certain software programs need to function.

Most module files simply modify those two variables, by appending or prepending new directories to them so the computer knows where to look for the different executables you are trying to run. Some module files have additional environmental variables that they modify, such as specifying license servers, or temporary directories. But these two variables are the most important.

In addition, module files can set shell functions, which intercept specific commands so they can be ran in a different way. This is most used when you want to launch software inside a container but also want to not need to type out the entire apptainer command every time you use the software.

##Writing Your Own Module File

Following is the definition of the `abaqus/2026` module file:

```
whatis("invoke Simulia Abaqus 2026")

prereq("intel/19.1.3.304")

local version = "2026"
local app = "abaqus"
local contact = "rcac-help"
local license_type = "proprietary"

local modroot = "/apps/external/apps/abaqus/2026"

setenv("ABAQUS_HOME",modroot)
if os.getenv("CLUSTER_SCRATCH") ~= nil then
	setenv("TMPDIR",os.getenv("CLUSTER_SCRATCH"))
end
prepend_path("PATH",modroot.."/Commands")
```

Let’s walk through what this module file is doing. First, it has a `whatis` command, which simply gives some information about what the software is. This is optional but can be helpful. Next it has a prerequisite module specified. Remember earlier when we needed to load the Intel module before this one was available to be loaded? This ensures that that happened. Next, we have some `local` variable lines. These are variables that can help in the module file definition process but are not used outside of the module file. The next line is a `setenv` line, which sets an environment variable for the shell that this module is loaded into. The next three lines are an if-then statement that checks to see if your scratch directory exists and if it does, it sets the temporary directory to be your scratch. Lastly, we have the most important line, the `prepend_path`. This will add the software to your `PATH` variable so the computer knows to look there for executables. Note that the double period `..` performs string concatenation.

If you have some software that you want to use on the cluster and it is not there already, you can install it into your home directory or your group’s depot space and then create a module file that points to it using the `abaqus/2026` module file as a template.

A word on directory structure and file naming conventions. You should have a `modulefiles` directory somewhere, either in your home directory or in your group’s `/depot/labname/etc` directory to hold all your modulefiles. Under that overarching module file directory, you need directories named after each of the software that you have installed. Lastly, in the software-named directories, you need files named `VERSION.lua` where `VERSION` is replaced by the specific version name of the software installed.

As an example, if I had installed Abaqus 2026 into my home directory and wanted to make a module file for it, I would have a file under this path: `~/modulefiles/abaqus/2026.lua` that contains the environmental variables needed to let my shell know where to look for `abaqus/2026`. To load this new software, I would do: `module use ~/modulefiles` then run `module load abaqus/2026`. This is a bad example because the software is already able to be used on the cluster and having two module files that have the same name/version is a recipe for disaster.

##Conda Environments

I would be remiss if I did not take a detour to talk about Conda environments, usually used for python packages. These are not strictly related to module files, but they are also useful to know about.
The first step to using Conda environments on Purdue HPC systems is to load the Conda module: `module load conda`. We have a special wrapper for Conda that will do some extra steps for you. It is called `conda-env-mod`. An example of creating a Conda environment with it is:

```
conda-env-mod create -n ENV_NAME -j
```

Here, we are using `conda-env-mod` to `create` an environment named `ENV_NAME` (the name of which you can change to whatever you want, it doesn’t have to be `ENV_NAME`). Lastly, we are specifying `-j` (which is optional). This automatically installs the packages necessary to use Jupyter notebooks with this Conda environment and creates the Jupyter kernel so that it is easy to load into your Jupyter notebook session.

After the `conda-env-mod` has finished running, if you look at the end of the output there will be some instructions. It varies what exactly it says from system to system, but most often it says to do:

```
module load use.own
module load conda-env/ENV_NAME-py3.12.11
```

The specifics, such as the environment name will be different depending on what you entered earlier and which supercomputer you are on, but it should look similar.

After running these two commands in your shell, you can do `conda/pip install` and it will be installed into your Conda environment. Note that if you open a new shell and want to install other packages, you will need to rerun those two module load commands specified earlier to reload the Conda environment into your shell.
