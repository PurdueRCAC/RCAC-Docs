---
tags:
  - Gautschi
authors:
  - jin456
resource: Gautschi
search:
  boost: 2
---

!!! note
    Note: Apptainer was formerly known as Singularity and is now a part of the [Linux Foundation](https://apptainer.org/news/community-announcement-20211130). When migrating from Singularity see the [user compatibility documentation](https://apptainer.org/docs/user/main/singularity_compatibility.html).

## What is Apptainer?
Apptainer is an open-source container platform designed to be simple, fast, and secure. It allows the portability and reproducibility of operating systems and application environments through the use of Linux containers. It gives users complete control over their environment.

Apptainer is like Docker but tuned explicitly for HPC clusters. More information is available on the [project’s website](https://apptainer.org/).

## Features

- Run the latest applications on an Ubuntu or Centos userland
- Gain access to the latest developer tools
- Launch MPI programs easily
- Much more

Apptainer’s user guide is available at: [https://apptainer.org/docs/user/main/introduction.html](https://apptainer.org/docs/user/main/introduction.html)

## Example
Here is an example using an Ubuntu 16.04 image on Gautschi:

```bash
apptainer exec /depot/itap/singularity/ubuntu1604.img cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=16.04
DISTRIB_CODENAME=xenial
DISTRIB_DESCRIPTION="Ubuntu 16.04 LTS"
```

Here is another example using a Centos 7 image:

```bash
apptainer exec /depot/itap/singularity/centos7.img cat /etc/redhat-release
CentOS Linux release 7.3.1611 (Core)
```

## Purdue Cluster Specific Notes

All service providers will integrate Apptainer slightly differently depending on site. The largest customization will be which default files are inserted into your images so that routine services will work.

Services we configure for your images include DNS settings and account information. File systems we overlay into your images are your home directory, scratch, Data Depot, and application file systems.

Here is a list of paths:

- /etc/resolv.conf
- /etc/hosts
- /home/$USER
- /apps
- /scratch
- /depot

This means that within the container environment these paths will be present and the same as outside the container. The ```/apps```, ```/scratch```, and ```/depot``` directories will need to exist _inside_ your container to work properly.

## Creating Apptainer Images
You can build on your system or straight on the cluster (you do not need root privileges to build or run the container).

You can find information and documentation for how to install and use Apptainer on your system:

- [Install Apptainer on Windows or MacOS](https://apptainer.org/docs/admin/main/installation.html#installation-on-windows-or-mac)
- [Install Apptainer on Linux](https://apptainer.org/docs/admin/main/installation.html#installation-on-linux)

We have version ```1.1.6``` (or newer) on the cluster. Please note that installed versions may change throughout cluster life time, so when in doubt, please check exact version with a ```--version``` command line flag:

```bash
apptainer --version
apptainer version 1.3.3-1.el9
```

Everything you need on how to [build a container](https://apptainer.org/docs/user/main/build_a_container.html) is available from their user guide. Below are merely some quick tips for getting your own containers built for Gautschi.

You can use a [Definition File](https://apptainer.org/docs/user/main/definition_files.html) to both build your container and share its specification with collaborators (for the sake of reproducibility). Here is a simplistic example of such a file:

```bash
# FILENAME: Buildfile

Bootstrap: docker
From: ubuntu:18.04

%post
    apt-get update && apt-get upgrade -y
    mkdir /apps /depot /scratch
```

To build the image itself:

```bash
apptainer build ubuntu-18.04.sif Buildfile
```

The challenge with this approach however is that it must start from scratch if you decide to change something. In order to create a container image iteratively and interactively, you can use the ```--sandbox``` option.

```bash
apptainer build --sandbox ubuntu-18.04 docker://ubuntu:18.04
```

This will not create a flat image file but a directory tree (i.e., a folder), the contents of which are the container's filesystem. In order to get a shell inside the container that allows you to modify it, user the ```--writable``` option.

```bash
apptainer shell --writable ubuntu-18.04
Apptainer>
```

You can then proceed to install any libraries, software, etc. within the container. Then to create the final image file, ```exit``` the shell and call the ```build``` command once more on the sandbox.

```bash
apptainer build ubuntu-18.04.sif ubuntu-18.04
```

Finally, copy the new image to Gautschi and run it.

[**Back to the Running Jobs section**](../run_jobs/index.md)
