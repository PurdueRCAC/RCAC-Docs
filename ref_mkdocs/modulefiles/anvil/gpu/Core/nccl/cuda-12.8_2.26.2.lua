
whatis([[Name : nccl]])
whatis([[Version : cuda-12.8_2.26.2]])
whatis([[Short description : Optimized primitives for collective multi-GPU communication.]])
whatis([[Configure options : unknown, software installed outside of Spack]])

help([[Optimized primitives for collective multi-GPU communication.]])

depends_on("cuda/12.8.0")

local modroot="/apps/anvilgpu/external/apps/nccl/cuda12.8/2.26.2"
prepend_path("LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("CPATH", modroot.."/include", ":")
prepend_path("PKG_CONFIG_PATH", modroot.."/lib/pkgconfig", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/", ":")
setenv("NCCL_HOME", modroot)
setenv("RCAC_NCCL_ROOT", modroot)
setenv("RCAC_NCCL_VERSION", "cuda-12.8_2.26.2")

