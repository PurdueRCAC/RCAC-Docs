---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

# Windows

Windows virtual machines (VMs) are supported as batch jobs on HPC systems. This section illustrates how to submit a job and run a Windows instance in order to run Windows applications on the high-performance computing systems.

{::if resource.name == Gautschi}

The following images are pre-configured and made available by staff:

* Windows 2022 Server Basic (minimal software pre-loaded)

{::elif resource.name == Weber}

Gilbreth provides a basic Windows 10 image to execute Microsoft Office applications within the cluster's boundaries.

* The Windows image is not persistent, and will default to a baseline state each time Windows is launched.
* Only the provided Windows image is to be launched on Gilbreth.

{::else}

The following images are pre-configured and made available by staff:

* Windows 2016 Server Basic (minimal software pre-loaded)
* Windows 2016 Server GIS (GIS Software Stack pre-loaded)

{::/}

The Windows VMs can be launched in two fashions:

* [Menu Launcher](/knowledge/${resource.hostname}/run/examples/apps/windows/launcher) - Point and click to start
* [Command Line](/knowledge/${resource.hostname}/run/examples/apps/windows/cmd) - Advanced and customized usage

Click each of the above links for detailed instructions on using them.

{::if resource.name != Weber}

### Software Provided in Pre-configured Virtual Machines

The Windows 2016 Base server image available on Gilbreth has the following software packages preloaded:

* Anaconda Python 2 and Python 3
* JMP 13
* Matlab R2017b
* Microsoft Office 2016
* Notepad++
* NVivo 12
* Rstudio
* Stata SE 15
* VLC Media Player

{::/}