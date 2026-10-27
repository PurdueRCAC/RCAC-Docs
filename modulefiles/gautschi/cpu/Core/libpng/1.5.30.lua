-- -*- lua -*---
-- libpng@1.5.30%gcc@11.4.1~ipo~pic build_system=cmake build_type=Release generator=make libs=shared,static arch=linux-rocky9-zen4/wxrdzlw
--

whatis([[Name : libpng]])
whatis([[Version : 1.5.30]])
whatis([[Short description : libpng is the official PNG reference library.]])

help([[libpng is the official PNG reference library.]])



local modroot="/apps/spack/gautschi-cpu/apps/libpng/1.5.30-gcc-11.4.1-wxrdzlw"
prepend_path("PATH", modroot.."/bin", ":")
prepend_path("LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("CPATH", modroot.."/include", ":")
prepend_path("MANPATH", modroot.."/share/man", ":")
prepend_path("PKG_CONFIG_PATH", modroot.."/lib/pkgconfig", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/.", ":")
setenv("LIBPNG_HOME", modroot)
setenv("RCAC_LIBPNG_ROOT", modroot)
setenv("RCAC_LIBPNG_VERSION", modroot)
