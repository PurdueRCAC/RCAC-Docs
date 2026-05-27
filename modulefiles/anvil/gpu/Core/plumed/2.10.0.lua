-- -*- lua -*-
whatis("Name: PLUMED")
whatis("Version: 2.10.0")
whatis("Category: Molecular dynamics, enhanced sampling")
whatis("Description: PLUMED plugin for free-energy calculations and enhanced sampling")
whatis("URL: https://www.plumed.org/")

-- depends_on("cuda/11.2.2")
-- depends_on("gmp/6.2.1")
-- depends_on("mpfr/3.1.6")
-- depends_on("mpc/1.1.0")
-- depends_on("gcc/8.4.1")
-- depends_on("zlib/1.2.11")
-- depends_on("numactl/2.0.14")
-- depends_on("openmpi/4.0.6")
-- depends_on("boost/1.74.0")

local root = "/apps/anvil/external/apps/plumed/2.10/install"

setenv("PLUMED_ROOT", root)
setenv("PLUMED_KERNEL", pathJoin(root, "lib/libplumedKernel.so"))

prepend_path("PATH", pathJoin(root, "bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("CPATH", pathJoin(root, "include"))
prepend_path("C_INCLUDE_PATH", pathJoin(root, "include"))
prepend_path("CPLUS_INCLUDE_PATH", pathJoin(root, "include"))
prepend_path("PKG_CONFIG_PATH", pathJoin(root, "lib/pkgconfig"))
prepend_path("CMAKE_PREFIX_PATH", root)

-- Useful for builds that look for PLUMED through generic compiler/linker flags
prepend_path("LDFLAGS", "-L" .. pathJoin(root, "lib"), " ")
prepend_path("CPPFLAGS", "-I" .. pathJoin(root, "include"), " ")
