-- -*- lua -*---
-- py-numpy@1.26.4%gcc@13.3.0 build_system=python_pip patches=873745d arch=linux-rocky8-zen3/j7rbd2n
--

whatis([[Name : py-numpy]])
whatis([[Version : 1.26.4]])
whatis([[Short description : Fundamental package for array computing in Python.]])

help([[Fundamental package for array computing in Python.]])


depends_on("openblas/0.3.27")
depends_on("python/3.11.9")

local modroot="/apps/spack/anvilgpu-2025/apps/py-numpy/1.26.4-gcc-13.3.0-j7rbd2n"
prepend_path("PATH", modroot.."/bin", ":")
prepend_path("LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/.", ":")
prepend_path("PYTHONPATH", modroot.."/lib/python3.11/site-packages", ":")
prepend_path("PATH", modroot.."/bin", ":")
setenv("PY_NUMPY_HOME", modroot)
setenv("RCAC_PY_NUMPY_ROOT", modroot)
setenv("RCAC_PY_NUMPY_VERSION", modroot)

