-- -*- lua -*---
-- cmake@3.30.2%gcc@13.3.0~doc+ncurses+ownlibs build_system=generic build_type=Release patches=dbc3892 arch=linux-rocky8-zen3/5znp6js
--

whatis([[Name : cmake]])
whatis([[Version : 3.30.2]])
whatis([[Short description : A cross-platform, open-source build system. CMake is a family of tools designed to build, test and package software. ]])

help([[A cross-platform, open-source build system. CMake is a family of tools
designed to build, test and package software.]])


depends_on("curl/8.8.0-shtex55")
depends_on("zlib/1.3.1-ummgjdr")

local modroot="/apps/spack/anvilgpu-2025/apps/cmake/3.30.2-gcc-13.3.0-5znp6js"
prepend_path("PATH", modroot.."/bin", ":")
prepend_path("ACLOCAL_PATH", modroot.."/share/aclocal", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/.", ":")
setenv("CMAKE_HOME", modroot)
setenv("RCAC_CMAKE_ROOT", modroot)
setenv("RCAC_CMAKE_VERSION", modroot)

