---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

# Setting Up R Preferences with .Rprofile

For your convenience, a sample [~/.Rprofile example file](../../../../assets/scripts/userguides/Rprofile_example) is provided that can be downloaded to your cluster account and renamed into `~/.Rprofile` (or appended to one). Follow these steps to download our recommended `~/.Rprofile` example and copy it into place:

```
curl -#LO https://docs.rcac.purdue.edu/assets/scripts/userguides/Rprofile_example
mv -ib Rprofile_example ~/.Rprofile
```

The above installation step needs to be done only once on Gilbreth. Now load the R module and run R:

```

module load r/4.4.1
R
```

```

.libPaths()
[1] "/home/username/R/hostname/4.1.2-gcc-6.3.0-ymdumss"
[2] "/apps/spack/hostname/apps/r/4.1.2-gcc-6.3.0-ymdumss/rlib/R/library"
```

`.libPaths()` should output something similar to above if it is set up correctly.

You are now ready to [install R packages](../examples/example_installing_r_packages.md) into the dedicated directory `/home/username/R/hostname/4.1.2-gcc-6.3.0-ymdumss`.