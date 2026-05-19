# Setting Up R Preferences with .Rprofile

For your convenience, a sample [~/.Rprofile example file](https://www.rcac.purdue.edu/files/knowledge/run/examples/apps/r/Rprofile_example) is provided that can be downloaded to your cluster account and renamed into `~/.Rprofile` (or appended to one). Follow these steps to download our recommended `~/.Rprofile` example and copy it into place:

```

curl -#LO https://www.rcac.purdue.edu/files/knowledge/run/examples/apps/r/Rprofile_example
mv -ib Rprofile_example ~/.Rprofile
```

The above installation step needs to be done only once on Bell. Now load the R module and run R:

```

module load r/4.4.1
R
```

```

.libPaths()
[1] "/home/myusername/R/bell/4.1.2-gcc-6.3.0-ymdumss"
[2] "/apps/spack/bell/apps/r/4.1.2-gcc-6.3.0-ymdumss/rlib/R/library"
```

`.libPaths()` should output something similar to above if it is set up correctly.

You are now ready to [install R packages](package.md) into the dedicated directory `/home/myusername/R/bell/4.1.2-gcc-6.3.0-ymdumss`.
