---
tags:
  - Hammer
authors:
  - jin456
resource: Hammer
search:
  boost: 2
---

# Software

## Software Catalog

A comprehensive list of centrally installed software applications can be found here:

[Software Catalog](../../software/app_catalog.md)

Software can also be explored by popular domains and categories on the main [Software](../../software/index.md) page.

## Module system

{% set resource = "hammer" %}

{{ module_system(resource) }}

## Running the Apps
### Find available apps in the terminal
In addition to searching the software catalog for available applications, one can generate a list via the terminal:

``` bash
$ module avail
```
### View module prequisites and license information
After finding the module that you want to load, use 'module spider' to find any prerequisites or license information, if applicable:

``` bash
$ module spider <modulename>
```
### Load the module
Use the command specified in the 'module spider' output to load your software module:

``` bash
module load <modulename>
```

### Running GUI versions of apps
If the app you want to use has a GUI, you can also login to {{ resource }} via Thinlinc. More information on this process can be found [here](accounts.md#thinlinc).

[**Back to Hammer User Guide**](index.md)
