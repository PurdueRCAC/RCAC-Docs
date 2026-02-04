---
tags:
  - Gautschi
authors:
  - remender
resource: gautschi
search:
  boost: 2
---

## Software Catalog

A comprehensive list of centrally installed software applications can be found here:

[PLACEHOLDER URL](http://localhost:8080/software/app_catalog/)

## Running the Apps
### Find available apps in the terminal
In addition to searching the software catalog for available applications, one can generate a list via the terminal:

``` bash
$ module avail
---------------------- Core Applications ---------------------
   amduprof/5.1.701                hypershell/2.5.2              ngc/default
   anaconda/2024.10-py312          hypershell/2.6.5              oclfpga/2024.1.0
   anaconda/2025.06-py313 (D)      hypershell/2.7.0     (D)      openblas/0.3.27
[MORE...]
```
### View module prequisites and license information
After finding the module that you want to load, use 'module spider' to find any prerequisites or license information, if applicable:

``` bash
$ module spider hypershell

-------------------------------------------------------------
  hypershell:
-------------------------------------------------------------
    Description:
      A cross-platform, high-throughput computing utility for processing shell commands over a
      distributed, asynchronous queue.

     Versions:
        hypershell/2.5.2
        hypershell/2.6.5
        hypershell/2.7.0


```
### Load the module
Use the command specified in the 'module spider' output to load your software module:

``` bash
module load hypershell/2.7.0
```

### Running GUI versions of apps
If the app you want to use has a GUI, you can also login to {{ resource }} via Thinlinc. More information on this process can be found here:
[PLACEHOLDER URL](http://localhost:8080/blog/2026/01/14/logging-in-to-the-community-clusters-via-thinlinc)
