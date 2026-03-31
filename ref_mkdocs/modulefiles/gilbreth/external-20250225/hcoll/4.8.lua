-- -*- lua -*-
help([[
HCOLL libraries from NVIDIA HPC-X (collectives offload).
This module does NOT provide an MPI implementation.
]])

whatis("Name: HCOLL")
whatis("Description: HCOLL libraries (from NVIDIA HPC-X)")
whatis("Version: 4.8 (bundled with HPC-X 2.25.1-cuda13)")

local hpcx_version = "2.25.1-cuda13"
local hpcx_dir = "/apps/external/hpcx/" .. hpcx_version
local hcoll_dir = pathJoin(hpcx_dir, "hcoll")

setenv("HCOLL_DIR", hcoll_dir)
setenv("HPCX_HCOLL_DIR", hcoll_dir)

prepend_path("PATH", pathJoin(hcoll_dir, "bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(hcoll_dir, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(hcoll_dir, "lib"))
prepend_path("CPATH", pathJoin(hcoll_dir, "include"))
prepend_path("PKG_CONFIG_PATH", pathJoin(hcoll_dir, "lib", "pkgconfig"))
