-- -*- lua -*---
-- py-virtualenv@20.24.5%gcc@13.3.0 build_system=python_pip arch=linux-rocky8-zen3/6qnqdlv
--

whatis([[Name : py-virtualenv]])
whatis([[Version : 20.24.5]])
whatis([[Short description : virtualenv is a tool to create isolated Python environments.]])

help([[virtualenv is a tool to create isolated Python environments.]])


depends_on("python/3.11.9")

local modroot="/apps/spack/anvilgpu-2025/apps/py-virtualenv/20.24.5-gcc-13.3.0-6qnqdlv"
prepend_path("PATH", modroot.."/bin", ":")
prepend_path("LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/.", ":")
prepend_path("PYTHONPATH", modroot.."/lib/python3.11/site-packages", ":")
prepend_path("PATH", modroot.."/bin", ":")
setenv("PY_VIRTUALENV_HOME", modroot)
setenv("RCAC_PY_VIRTUALENV_ROOT", modroot)
setenv("RCAC_PY_VIRTUALENV_VERSION", modroot)

