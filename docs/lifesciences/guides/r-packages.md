---
title: Installing R packages
tags:
  - Life Sciences
  - R
  - Guides
---

On RCAC clusters, you can load any R modules (`r-bioconductor`, `r-rnaseq`, etc.) and install packages using `BiocManager` or `install.packages`. However, since you don't have write access to the system library, you will need to install the packages in your custom location. Here is how you can do it:

1.  **Create the required directory in your desired location. For home directory.**

    ```bash
    cd ~
    mkdir -p local/r_packages
    ```

    This is just an example, but you can use a project specific package directory if you prefer.

    !!! warning
        Create separate packages directory for major versions of R. For example, `local/r_packages/4.4.1` for `R 4.4.1`.

2.  **Install the packages in your custom library:**

    ```bash
    ml purge
    ml biocontainers
    ml r-scrnaseq/4.4.1-rstudio
    Rscript -e 'BiocManager::install("DESeq2", lib="~/local/r_packages")'
    Rscript -e 'install.packages("data.table", lib="~/local/r_packages")'
    ```

    _You can also run this within an R session, if you prefer:_

    ```r
    BiocManager::install("DESeq2", lib="~/local/r_packages")
    install.packages("data.table", lib="~/local/r_packages")
    ```

3.  **Modify library path to ensure R knows about your custom library (modify `~/.Renviron` file):**

    ```bash
    echo 'R_LIBS_USER=${R_LIBS_USER}:'~/local/r_packages'' >> ~/.Renviron
    ```

4.  **Test the installation:**

    ```bash
    ml purge
    ml biocontainers
    ml r-scrnaseq/4.4.1-rstudio
    ```

    and in R session:

    ```r
    library(DESeq2)
    library(data.table)
    .libPaths()
    ```

    This should load your libraries and should show the path to your custom library.

## Using RStudio

Alternatively, if using RStudio, you can also set the environment variable in the RStudio configuration file. Add the following line to your ~/.Renviron file:

```r
usethis::edit_r_environ()
```

When the file opens, add the following line:

```r
R_LIBS_USER=~/local/r_packages
```

save and restart RStudio. You can test `.libPaths()` in RStudio to see if the path is set correctly.
