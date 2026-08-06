-- -*- lua -*---
-- py-matplotlib@3.9.0%gcc@13.3.0~animation~fonts~latex~movies backend=agg build_system=python_pip arch=linux-rocky8-zen3/6uulw4b
--

whatis([[Name : py-matplotlib]])
whatis([[Version : 3.9.0]])
whatis([[Short description : Matplotlib is a comprehensive library for creating static, animated, and interactive visualizations in Python.]])

help([[Matplotlib is a comprehensive library for creating static, animated, and
interactive visualizations in Python.]])


depends_on("py-numpy/1.26.4")
depends_on("python/3.11.9")

local modroot="/apps/spack/anvilgpu-2025/apps/py-matplotlib/3.9.0-gcc-13.3.0-6uulw4b"
prepend_path("LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/.", ":")
prepend_path("PYTHONPATH", modroot.."/lib/python3.11/site-packages", ":")
setenv("PY_MATPLOTLIB_HOME", modroot)
setenv("RCAC_PY_MATPLOTLIB_ROOT", modroot)
setenv("RCAC_PY_MATPLOTLIB_VERSION", modroot)

