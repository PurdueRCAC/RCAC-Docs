-- -*- lua -*---
-- rstudio@2024.09%gcc@13.3.0 build_system=generic arch=linux-rocky8-zen3/2svcwvu
--

whatis([[Name : rstudio]])
whatis([[Version : 2024.09]])
whatis([[Short description : This package installs Rstudio desktop from pre-compiled binaries available in the Rstudio website. The installer assumes that you are running on CentOS7/Redhat7/Fedora19. Please fix the download URL for other systems.]])

help([[This package installs Rstudio desktop from pre-compiled binaries
available in the Rstudio website. The installer assumes that you are
running on CentOS7/Redhat7/Fedora19. Please fix the download URL for
other systems.]])


depends_on("r/4.4.1")

local modroot="/apps/spack/anvilgpu-2025/apps/rstudio/2024.09-gcc-13.3.0-2svcwvu"
prepend_path("CMAKE_PREFIX_PATH", modroot.."/.", ":")
prepend_path("PERL5LIB", "/apps/spack/anvilgpu-2025/apps/postgresql/16.3-gcc-13.3.0-5ea7hcj/lib", ":")
prepend_path("TCLLIBPATH", "/apps/spack/anvilgpu-2025/apps/postgresql/16.3-gcc-13.3.0-5ea7hcj/lib", ":")
prepend_path("PYTHONPATH", "/apps/spack/anvilgpu-2025/apps/postgresql/16.3-gcc-13.3.0-5ea7hcj/lib", ":")
setenv("R_HOME", "/apps/spack/anvilgpu-2025/apps/r/4.4.1-gcc-13.3.0-636opzq/rlib/R")
prepend_path("LD_LIBRARY_PATH", "/apps/spack/anvilgpu-2025/apps/postgresql/16.3-gcc-13.3.0-5ea7hcj/lib", ":")
setenv("RSTUDIO_HOME", modroot)
setenv("RCAC_RSTUDIO_ROOT", modroot)
setenv("RCAC_RSTUDIO_VERSION", modroot)

