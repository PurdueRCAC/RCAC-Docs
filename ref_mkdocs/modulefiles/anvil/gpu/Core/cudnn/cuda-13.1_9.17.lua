whatis([[Name : cudnn]])
whatis([[Version : 9.17.0-x86_64]])
whatis([[Short description : NVIDIA cuDNN is a GPU-accelerated library of primitives for deep neural networks]])

help([[NVIDIA cuDNN is a GPU-accelerated library of primitives for deep neural
networks]])

depends_on("cuda/13.1.0")

local version="9.17.0"
local modroot="/apps/anvilgpu/external/apps/cudnn/cuda13.1/"..version
prepend_path("LD_LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("CPATH", modroot.."/include", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/", ":")
prepend_path("CUDA_INCLUDE_PATH",modroot.."/include")
prepend_path("C_INCLUDE_PATH",modroot.."/include")
setenv("CUDNN_HOME", modroot)
setenv("RCAC_CUDNN_ROOT", modroot)
setenv("RCAC_CUDNN_VERSION", version)

