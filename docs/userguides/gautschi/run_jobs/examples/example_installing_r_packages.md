---
tags:
  - Gautschi
authors:
  - jin456
resource: Gautschi
search:
  boost: 2
---

!!!warning
    There are links on this page that 404 and will need fixed before this page goes live

## Challenges of Managing R Packages in the Cluster Environment

- Different clusters have different hardware and softwares. So, if you have access to multiple clusters, you must install your R packages separately for each cluster.
- Each cluster has multiple versions of R and packages installed with one version of R may not work with another version of R. So, libraries for each R version must be installed in a separate directory.
- You can define the directory where your R packages will be installed using the environment variable ```R_LIBS_USER```.
- For your convenience, a sample [~/.Rprofile example file](https://rcac.purdue.edu/files/knowledge/run/examples/apps/r/Rprofile_example) is provided that can be downloaded to your cluster account and renamed into ```~/.Rprofile``` (or appended to one) to customize your installation preferences. [Detailed instructions here PLACEHOLDER]().

## Installing Packages
- ### Step 0: Setup Installation Preferences
Follow the [steps for setting up your](https://rcac.purdue.edu/knowledge/gautschi/run/examples/apps/r/rprofile) ```~/.Rprofile``` preferences. This step needs to be done only once. If you have created a ```~/.Rprofile``` file previously on Gautschi, ignore this step.

- ### Step 1: Check if the package is already installed
As part of the R installations on community clusters, a lot of R libraries are pre-installed. You can check if your package is already installed by opening an R terminal and entering the command ```installed.packages()```. For example,

```r
module load r/4.4.1
R

installed.packages()["units",c("Package","Version")]
Package Version 
"units" "0.8-1"
quit()
```

If the package you are trying to use is already installed, simply load the library, e.g., ```library('units')```. Otherwise, move to the next step to install the package.

- ### Step 2: Load required dependencies (if needed)
For simple packages you may not need this step. However, some R packages depend on other libraries. For example, the ```sf``` package depends on ```gdal``` and ```geos``` libraries. So, you will need to load the corresponding modules before installing ```sf```. Read the documentation for the package to identify which modules should be loaded.

```r
module load gdal
module load geos
```

- ### Step 3: Install the package
Now install the desired package using the command ```install.packages('package_name')```. R will automatically download the package and all its dependencies from [CRAN](https://cran.r-project.org/mirrors.html) and install each one. Your terminal will show the build progress and eventually show whether the package was installed successfully or not.

```r
R

install.packages('sf', repos="https://cran.case.edu/")
Installing package into ‘/home/myusername/R/x86_64-pc-linux-gnu-library/4.4.1’
(as ‘lib’ is unspecified)
trying URL 'https://cran.case.edu/src/contrib/sf_0.9-7.tar.gz'
Content type 'application/x-gzip' length 4203095 bytes (4.0 MB)
==================================================
downloaded 4.0 MB
...
...
more progress messages
...
...
** testing if installed package can be loaded from final location
** testing if installed package keeps a record of temporary installation path
* DONE (sf)

The downloaded source packages are in
    ‘/tmp/RtmpSVAGio/downloaded_packages’
```

- ### Step 4: Troubleshooting (if needed)
If Step 3 ended with an error, you need to investigate why the build failed. Most common reason for build failure is not loading the necessary modules.

## Loading Libraries
Once you have packages installed you can load them with the ```library()``` function as shown below:

```r
library('packagename')
```
The package is now installed and loaded and ready to be used in R.

## Example: Installing ```dplyr```

```r
module load r
R

install.packages('dplyr', repos="http://ftp.ussg.iu.edu/CRAN/")
Installing package into ‘/home/myusername/R/gautschi/4.4.1’
(as ‘lib’ is unspecified)
 ...
also installing the dependencies 'crayon', 'utf8', 'bindr', 'cli', 'pillar', 'assertthat', 'bindrcpp', 'glue', 'pkgconfig', 'rlang', 'Rcpp', 'tibble', 'BH', 'plogr'
 ...
 ...
 ...
The downloaded source packages are in 
    '/tmp/RtmpHMzm9z/downloaded_packages'

library(dplyr)

Attaching package: 'dplyr'
```

For more information about installing R packages:

- [Installing additional R packages on Linux](http://cran.r-project.org/doc/manuals/r-release/R-admin.html#Installing-packages)
- [List of Packages](https://cran.r-project.org/web/packages/)

[**Back to the R Examples section**](../r_example.md)