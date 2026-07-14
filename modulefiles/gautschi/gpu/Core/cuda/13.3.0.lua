whatis([[Name : cuda]])
whatis([[Version : 13.3.0]])
whatis([[Target : sapphirerapids]])
whatis([[Short description : CUDA is a parallel computing platform and programming model invented by NVIDIA. It enables dramatic increases in computing performance by harnessing the power of the graphics processing unit (GPU).]])

help([[Name   : cuda]])
help([[Version: 13.3.0]])
help([[Target : sapphirerapids]])
help()
help([[CUDA is a parallel computing platform and programming model invented by
NVIDIA. It enables dramatic increases in computing performance by
harnessing the power of the graphics processing unit (GPU). Note: This
package does not currently install the drivers necessary to run CUDA.
These will need to be installed manually. See:
https://docs.nvidia.com/cuda/ for details.]])


local modroot="/apps/gautschi/cuda/13.3"
prepend_path("PATH", modroot.."/bin", ":")
prepend_path("LIBRARY_PATH", modroot.."/lib64", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/lib64", ":")
prepend_path("CPATH", modroot.."/include", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/", ":")
prepend_path("PKG_CONFIG_PATH", modroot.."/pkgconfig", ":")
setenv("CUDA_HOME", modroot)
setenv("CUDA_PATH", modroot)
setenv("RCAC_CUDA_ROOT", modroot)
setenv("RCAC_CUDA_VERSION", "13.3.0")