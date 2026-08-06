-- -*- lua -*---
-- py-numba@0.58.1%gcc@13.3.0~tbb build_system=python_pip arch=linux-rocky8-zen3/erbwqty
--

whatis([[Name : py-numba]])
whatis([[Version : 0.58.1]])
whatis([[Short description : NumPy aware dynamic Python compiler using LLVM]])

help([[NumPy aware dynamic Python compiler using LLVM]])


depends_on("py-numpy/1.26.4")
depends_on("py-setuptools/69.2.0")
depends_on("python/3.11.9")

local modroot="/apps/spack/anvilgpu-2025/apps/py-numba/0.58.1-gcc-13.3.0-erbwqty"
prepend_path("PATH", modroot.."/bin", ":")
prepend_path("LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/.", ":")
prepend_path("PYTHONPATH", modroot.."/lib/python3.11/site-packages", ":")
prepend_path("PATH", modroot.."/bin", ":")
setenv("PY_NUMBA_HOME", modroot)
setenv("RCAC_PY_NUMBA_ROOT", modroot)
setenv("RCAC_PY_NUMBA_VERSION", modroot)

