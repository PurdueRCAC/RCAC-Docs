-- -*- lua -*---
-- py-pip@23.1.2%gcc@13.3.0 build_system=generic arch=linux-rocky8-zen3/irgeiov
--

whatis([[Name : py-pip]])
whatis([[Version : 23.1.2]])
whatis([[Short description : The PyPA recommended tool for installing Python packages.]])

help([[The PyPA recommended tool for installing Python packages.]])


depends_on("python/3.11.9")

local modroot="/apps/spack/anvilgpu-2025/apps/py-pip/23.1.2-gcc-13.3.0-irgeiov"
prepend_path("PATH", modroot.."/bin", ":")
prepend_path("LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/.", ":")
prepend_path("PYTHONPATH", modroot.."/lib/python3.11/site-packages", ":")
prepend_path("PATH", modroot.."/bin", ":")
setenv("PY_PIP_HOME", modroot)
setenv("RCAC_PY_PIP_ROOT", modroot)
setenv("RCAC_PY_PIP_VERSION", modroot)

