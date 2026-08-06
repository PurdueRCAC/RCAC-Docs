-- -*- lua -*---
-- cuda@12.6.1%gcc@13.3.0~allow-unsupported-compilers~dev build_system=generic arch=linux-rocky8-zen3/qmri43f
--

whatis([[Name : cuda]])
whatis([[Version : 12.6.1]])
whatis([[Short description : CUDA is a parallel computing platform and programming model invented by NVIDIA. It enables dramatic increases in computing performance by harnessing the power of the graphics processing unit (GPU).]])
whatis([[Configure options : unknown, software installed outside of Spack]])

help([[CUDA is a parallel computing platform and programming model invented by
NVIDIA. It enables dramatic increases in computing performance by
harnessing the power of the graphics processing unit (GPU). Note: This
package does not currently install the drivers necessary to run CUDA.
These will need to be installed manually. See:
https://docs.nvidia.com/cuda/ for details.]])



local modroot="/apps/anvilgpu/external/apps/cuda-toolkit/12.6.1"
prepend_path("PATH", modroot.."/bin", ":")
prepend_path("LIBRARY_PATH", modroot.."/lib64", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/lib64", ":")
prepend_path("CPATH", modroot.."/include", ":")
prepend_path("PKG_CONFIG_PATH", modroot.."/pkgconfig", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/.", ":")
setenv("CUDA_HOME", modroot)
setenv("NVHPC_CUDA_HOME", modroot)
setenv("CUDA_HOME", modroot)
setenv("RCAC_CUDA_ROOT", modroot)
setenv("RCAC_CUDA_VERSION", modroot)

