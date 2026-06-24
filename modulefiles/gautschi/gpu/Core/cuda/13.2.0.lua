-- -*- lua -*-
-- Module file created by spack (https://github.com/spack/spack) on 2024-10-30 15:14:19.943855
--
-- cuda@12.6.1%gcc@11.4.1+allow-unsupported-compilers+dev build_system=generic arch=linux-rocky9-sapphirerapids/jtjtgkd
--

whatis([[Name : cuda]])
whatis([[Version : 13.2.0]])
whatis([[Target : sapphirerapids]])
whatis([[Short description : CUDA is a parallel computing platform and programming model invented by NVIDIA. It enables dramatic increases in computing performance by harnessing the power of the graphics processing unit (GPU).]])

help([[Name   : cuda]])
help([[Version: 13.2.0]])
help([[Target : sapphirerapids]])
help()
help([[CUDA is a parallel computing platform and programming model invented by
NVIDIA. It enables dramatic increases in computing performance by
harnessing the power of the graphics processing unit (GPU). Note: This
package does not currently install the drivers necessary to run CUDA.
These will need to be installed manually. See:
https://docs.nvidia.com/cuda/ for details.]])


local modroot="/apps/gautschi/cuda/13.2"
prepend_path("PATH", modroot.."/bin", ":")
prepend_path("LIBRARY_PATH", modroot.."/lib64", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/lib64", ":")
prepend_path("CPATH", modroot.."/include", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/", ":")
prepend_path("PKG_CONFIG_PATH", modroot.."/pkgconfig", ":")
setenv("CUDA_HOME", modroot)
setenv("CUDA_PATH", modroot)
setenv("RCAC_CUDA_ROOT", modroot)
setenv("RCAC_CUDA_VERSION", "13.2.0")