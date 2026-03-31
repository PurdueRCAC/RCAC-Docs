-- -*- lua -*---
whatis([[Name : cuda]])
whatis([[Version : 13.1.0]])
whatis([[Short description : CUDA is a parallel computing platform and programming model invented by NVIDIA. It enables dramatic increases in computing performance by harnessing the power of the graphics processing unit (GPU).]])
whatis([[Configure options : unknown, software installed outside of Spack]])

help([[CUDA is a parallel computing platform and programming model invented by
NVIDIA. It enables dramatic increases in computing performance by
harnessing the power of the graphics processing unit (GPU). Note: This
package does not currently install the drivers necessary to run CUDA.
These will need to be installed manually. See:
https://docs.nvidia.com/cuda/ for details.]])


-- cuda-toolkit
local cudatk_version="13.1.0"
local cudatk_version_short="cuda13.1"

local cudaroot="/apps/external/cuda-toolkit/"..cudatk_version
prepend_path("PATH", cudaroot.."/bin", ":")
prepend_path("LIBRARY_PATH", cudaroot.."/lib64", ":")
prepend_path("LD_LIBRARY_PATH", cudaroot.."/lib64", ":")
prepend_path("CPATH", cudaroot.."/include", ":")
prepend_path("CMAKE_PREFIX_PATH", cudaroot.."/", ":")
prepend_path("PKG_CONFIG_PATH", cudaroot.."/pkgconfig", ":")
setenv("CUDA_HOME", cudaroot)
setenv("CUDA_PATH", cudaroot)
setenv("RCAC_CUDA_ROOT", cudaroot)
setenv("RCAC_CUDA_VERSION", cudatk_version)


-- cudnn
local cudnn_version="9.17.1"
local cudnnroot="/apps/external/cudnn/"..cudatk_version_short .."/"..cudnn_version

prepend_path("LD_LIBRARY_PATH", cudnnroot.."/lib", ":")
prepend_path("LIBRARY_PATH", cudnnroot.."/lib", ":")
prepend_path("CPATH", cudnnroot.."/include", ":")
prepend_path("CMAKE_PREFIX_PATH", cudnnroot.."/", ":")
prepend_path("CUDA_INCLUDE_PATH",cudnnroot.."/include")
prepend_path("C_INCLUDE_PATH",cudnnroot.."/include")
setenv("CUDNN_HOME", cudnnroot)
setenv("RCAC_CUDNN_ROOT", cudnnroot)
setenv("RCAC_CUDNN_VERSION", cudnn_version)

-- nccl
local nccl_version = "2.29.2"
local ncclroot="/apps/external/nccl/"..cudatk_version_short.."/"..nccl_version
prepend_path("LIBRARY_PATH", ncclroot.."/lib", ":")
prepend_path("LD_LIBRARY_PATH", ncclroot.."/lib", ":")
prepend_path("CPATH", ncclroot.."/include", ":")
prepend_path("PKG_CONFIG_PATH", ncclroot.."/lib/pkgconfig", ":")
prepend_path("CMAKE_PREFIX_PATH", ncclroot.."/", ":")
setenv("NCCL_HOME", ncclroot)
setenv("RCAC_NCCL_ROOT", ncclroot)
setenv("RCAC_NCCL_VERSION", nccl_version)
