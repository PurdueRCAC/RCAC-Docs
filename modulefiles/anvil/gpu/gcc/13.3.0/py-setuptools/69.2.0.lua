-- -*- lua -*---
-- py-setuptools@69.2.0%gcc@13.3.0 build_system=generic arch=linux-rocky8-zen3/gbfmimh
--

whatis([[Name : py-setuptools]])
whatis([[Version : 69.2.0]])
whatis([[Short description : A Python utility that aids in the process of downloading, building, upgrading, installing, and uninstalling Python packages.]])

help([[A Python utility that aids in the process of downloading, building,
upgrading, installing, and uninstalling Python packages.]])


depends_on("python/3.11.9")

local modroot="/apps/spack/anvilgpu-2025/apps/py-setuptools/69.2.0-gcc-13.3.0-gbfmimh"
prepend_path("LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/.", ":")
prepend_path("PYTHONPATH", modroot.."/lib/python3.11/site-packages", ":")
setenv("PY_SETUPTOOLS_HOME", modroot)
setenv("RCAC_PY_SETUPTOOLS_ROOT", modroot)
setenv("RCAC_PY_SETUPTOOLS_VERSION", modroot)

