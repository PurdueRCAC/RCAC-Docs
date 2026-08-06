-- -*- lua -*---
-- gmp@6.3.0%gcc@13.3.0+cxx build_system=autotools libs=shared,static arch=linux-rocky8-zen3/fqckvy6
--

whatis([[Name : gmp]])
whatis([[Version : 6.3.0]])
whatis([[Short description : GMP is a free library for arbitrary precision arithmetic, operating on signed integers, rational numbers, and floating-point numbers.]])
whatis([[Configure options : --enable-cxx --enable-shared --enable-static --with-pic]])

help([[GMP is a free library for arbitrary precision arithmetic, operating on
signed integers, rational numbers, and floating-point numbers.]])



local modroot="/apps/spack/anvilgpu-2025/apps/gmp/6.3.0-gcc-13.3.0-fqckvy6"
prepend_path("LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("CPATH", modroot.."/include", ":")
prepend_path("PKG_CONFIG_PATH", modroot.."/lib/pkgconfig", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/.", ":")
setenv("GMP_HOME", modroot)
setenv("RCAC_GMP_ROOT", modroot)
setenv("RCAC_GMP_VERSION", modroot)

