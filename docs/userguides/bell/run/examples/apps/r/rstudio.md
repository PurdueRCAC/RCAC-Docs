---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# RStudio

{::if resource.name != Weber}

RStudio is a graphical integrated development environment (IDE) for R. RStudio is the most popular environment for developing both R scripts and packages. RStudio is provided on most Research systems.

There are two methods to launch RStudio on the cluster: **command-line** and **application menu icon**.

### Launch RStudio by the command-line:

```
module load gcc
module load r
module load rstudio
rstudio
```

Note that RStudio is a graphical program and in order to run it you must have a local X11 server running or use [Thinlinc](/knowledge/${resource.hostname}/accounts/login/thinlinc) Remote Desktop environment. See the [ssh X11 forwarding section](/knowledge/${resource.hostname}/accounts/login/x11) for more details.

### Launch Rstudio by the application menu icon:

* Log into desktop.${resource.hostname}.rcac.purdue.edu with web browser or [ThinLinc](/knowledge/${resource.hostname}/accounts/login/thinlinc) client
* Click on the `Applications` drop down menu on the top left corner
* Choose `Cluster Software` and then `RStudio`

![This shows where to find Rstudio under the 'Cluster Software' option in the list of Applications.](/knowledge/run/examples/apps/r/rstudio_icon.png)

R and RStudio are free to download and run on your local machine. For more information about RStudio:

* [RStudio the Official Website](https://www.rstudio.com/)
* [RStudio Essentials: Tutorial](https://www.rstudio.com/resources/webinars/#rstudioessentials)
* [DataCamp: Working with the RStudio IDE](https://www.datacamp.com/courses/working-with-the-rstudio-ide-part-1)

{::/}