-- -*- lua -*---
-- mpfr@4.2.1%gcc@13.3.0 build_system=autotools libs=shared,static arch=linux-rocky8-zen3/avf5i2w
--

whatis([[Name : mpfr]])
whatis([[Version : 4.2.1]])
whatis([[Short description : The MPFR library is a C library for multiple-precision floating-point computations with correct rounding.]])
whatis([[Configure options : --with-gmp=/apps/spack/anvilgpu-2025/apps/gmp/6.3.0-gcc-13.3.0-fqckvy6 --enable-shared --enable-static --with-pic]])

help([[The MPFR library is a C library for multiple-precision floating-point
computations with correct rounding.]])


depends_on("gmp/6.3.0-fqckvy6")

local modroot="/apps/spack/anvilgpu-2025/apps/mpfr/4.2.1-gcc-13.3.0-avf5i2w"
prepend_path("LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("CPATH", modroot.."/include", ":")
prepend_path("PKG_CONFIG_PATH", modroot.."/lib/pkgconfig", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/.", ":")
setenv("MPFR_HOME", modroot)
setenv("RCAC_MPFR_ROOT", modroot)
setenv("RCAC_MPFR_VERSION", modroot)

