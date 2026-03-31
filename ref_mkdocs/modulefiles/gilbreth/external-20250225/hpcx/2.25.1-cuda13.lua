-- -*- lua -*-
-- HPC-X modulefile (Lua/Lmod)
-- Translated from the vendor Tcl modulefile

help([[
NVIDIA HPC-X toolkit (UCX/UCC/HCOLL/SHARP + Open MPI).

This module sets up PATH/LD_LIBRARY_PATH/CPATH/etc to use the bundled
HPC-X stack under the installation prefix.
]])

-- Figure out install prefix:
local hpcx_version = "2.25.1-cuda13"
local hpcx_dir = "/apps/external/hpcx/" .. hpcx_version
local hpcx_mpi_dir = pathJoin(hpcx_dir, "ompi")

family("mpi")


whatis("Name: NVIDIA HPC-X")
whatis("Description: NVIDIA HPC-X toolkit (Open MPI, UCX, UCC, HCOLL, SHARP)")
whatis("Version: " .. hpcx_version)


-- Base env
setenv("HPCX_DIR",  hpcx_dir)
setenv("HPCX_HOME", hpcx_dir)

setenv("HPCX_UCX_DIR",    pathJoin(hpcx_dir, "ucx"))
setenv("HPCX_UCC_DIR",    pathJoin(hpcx_dir, "ucc"))
setenv("HPCX_SHARP_DIR",  pathJoin(hpcx_dir, "sharp"))
setenv("HPCX_HCOLL_DIR",  pathJoin(hpcx_dir, "hcoll"))
setenv("HPCX_CLUSTERKIT_DIR", pathJoin(hpcx_dir, "clusterkit"))

-- NCCL net plugin selection
local ncclnet_plugin_dir = pathJoin(hpcx_dir, "nccl_spectrum-x_plugin")
if os.getenv("HPCX_ENABLE_NCCL_MRC_PLUGIN") == "1" then
  ncclnet_plugin_dir = pathJoin(hpcx_dir, "nccl_mrc_plugin")
end
setenv("HPCX_NCCLNET_PLUGIN_DIR", ncclnet_plugin_dir)
setenv("HPCX_NCCL_RDMA_SHARP_PLUGIN_DIR", pathJoin(hpcx_dir, "nccl_rdma_sharp_plugin"))

-- MPI dirs
setenv("HPCX_MPI_DIR",        hpcx_mpi_dir)
setenv("HPCX_OSHMEM_DIR",     hpcx_mpi_dir)
setenv("HPCX_MPI_TESTS_DIR",  pathJoin(hpcx_mpi_dir, "tests"))
setenv("HPCX_OSU_DIR",        pathJoin(hpcx_mpi_dir, "tests", "osu-micro-benchmarks"))
setenv("HPCX_OSU_CUDA_DIR",   pathJoin(hpcx_mpi_dir, "tests", "osu-micro-benchmarks-cuda"))

-- PATH
prepend_path("PATH", pathJoin(hpcx_dir, "ucx", "bin"))
prepend_path("PATH", pathJoin(hpcx_dir, "ucc", "bin"))
prepend_path("PATH", pathJoin(hpcx_dir, "hcoll", "bin"))
prepend_path("PATH", pathJoin(hpcx_dir, "sharp", "bin"))
prepend_path("PATH", pathJoin(hpcx_mpi_dir, "tests", "imb"))
prepend_path("PATH", pathJoin(hpcx_dir, "clusterkit", "bin"))
prepend_path("PATH", pathJoin(hpcx_mpi_dir, "bin"))

-- LD_LIBRARY_PATH
prepend_path("LD_LIBRARY_PATH", pathJoin(hpcx_dir, "ucx", "lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(hpcx_dir, "ucx", "lib", "ucx"))
prepend_path("LD_LIBRARY_PATH", pathJoin(hpcx_dir, "ucc", "lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(hpcx_dir, "ucc", "lib", "ucc"))
prepend_path("LD_LIBRARY_PATH", pathJoin(hpcx_dir, "hcoll", "lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(hpcx_dir, "sharp", "lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(hpcx_mpi_dir, "lib"))

local enable_spcx = (os.getenv("HPCX_ENABLE_NCCL_SPCX_PLUGIN") == "1")
local enable_mrc  = (os.getenv("HPCX_ENABLE_NCCL_MRC_PLUGIN") == "1")

if enable_spcx or enable_mrc then
  prepend_path("LD_LIBRARY_PATH", pathJoin(hpcx_dir, "nccl_rdma_sharp_plugin", "lib"))
  prepend_path("LD_LIBRARY_PATH", pathJoin(ncclnet_plugin_dir, "lib"))
else
  prepend_path("LD_LIBRARY_PATH", pathJoin(ncclnet_plugin_dir, "lib"))
  prepend_path("LD_LIBRARY_PATH", pathJoin(hpcx_dir, "nccl_rdma_sharp_plugin", "lib"))
end

-- LIBRARY_PATH
prepend_path("LIBRARY_PATH", pathJoin(hpcx_dir, "ucx", "lib"))
prepend_path("LIBRARY_PATH", pathJoin(hpcx_dir, "ucc", "lib"))
prepend_path("LIBRARY_PATH", pathJoin(hpcx_dir, "hcoll", "lib"))
prepend_path("LIBRARY_PATH", pathJoin(hpcx_dir, "sharp", "lib"))
prepend_path("LIBRARY_PATH", pathJoin(hpcx_mpi_dir, "lib"))

if enable_spcx or enable_mrc then
  prepend_path("LIBRARY_PATH", pathJoin(hpcx_dir, "nccl_rdma_sharp_plugin", "lib"))
  prepend_path("LIBRARY_PATH", pathJoin(ncclnet_plugin_dir, "lib"))
else
  prepend_path("LIBRARY_PATH", pathJoin(ncclnet_plugin_dir, "lib"))
  prepend_path("LIBRARY_PATH", pathJoin(hpcx_dir, "nccl_rdma_sharp_plugin", "lib"))
end

-- CPATH
prepend_path("CPATH", pathJoin(hpcx_dir, "hcoll", "include"))
prepend_path("CPATH", pathJoin(hpcx_dir, "sharp", "include"))
prepend_path("CPATH", pathJoin(hpcx_dir, "ucx", "include"))
prepend_path("CPATH", pathJoin(hpcx_dir, "ucc", "include"))
prepend_path("CPATH", pathJoin(hpcx_mpi_dir, "include"))

-- PKG_CONFIG_PATH
prepend_path("PKG_CONFIG_PATH", pathJoin(hpcx_dir, "hcoll", "lib", "pkgconfig"))
prepend_path("PKG_CONFIG_PATH", pathJoin(hpcx_dir, "sharp", "lib", "pkgconfig"))
prepend_path("PKG_CONFIG_PATH", pathJoin(hpcx_dir, "ucx", "lib", "pkgconfig"))
prepend_path("PKG_CONFIG_PATH", pathJoin(hpcx_dir, "ompi", "lib", "pkgconfig"))

-- MANPATH
prepend_path("MANPATH", pathJoin(hpcx_mpi_dir, "share", "man"))

-- MPI runtime environment
setenv("OPAL_PREFIX",         hpcx_mpi_dir)
setenv("PMIX_INSTALL_PREFIX", hpcx_mpi_dir)
setenv("OMPI_HOME",           hpcx_mpi_dir)
setenv("MPI_HOME",            hpcx_mpi_dir)
setenv("OSHMEM_HOME",         hpcx_mpi_dir)
setenv("SHMEM_HOME",          hpcx_mpi_dir)
