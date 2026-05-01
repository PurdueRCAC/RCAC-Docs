-- -*- lua -*-
-- Module file created by spack (https://github.com/spack/spack) on 2026-03-23 16:35:05.522920
--
-- mpfr@4.2.1%gcc@11.4.1 build_system=autotools libs=shared,static arch=linux-rocky9-zen4/iiap2cg
--

whatis([[Name : mpfr]])
whatis([[Version : 4.2.1]])
whatis([[Target : zen4]])
whatis([[Short description : The MPFR library is a C library for multiple-precision floating-point computations with correct rounding.]])
whatis([[Configure options : --with-gmp=/apps/spack/gautschi-gpu/apps/gmp/6.3.0-gcc-11.4.1-airq3yj --enable-shared --enable-static --with-pic]])

help([[Name   : mpfr]])
help([[Version: 4.2.1]])
help([[Target : zen4]])
help()
help([[The MPFR library is a C library for multiple-precision floating-point
computations with correct rounding.]])


depends_on("gmp/6.3.0-airq3yj")

prepend_path("LIBRARY_PATH", "/apps/spack/gautschi-gpu/apps/mpfr/4.2.1-gcc-11.4.1-iiap2cg/lib", ":")
prepend_path("LD_LIBRARY_PATH", "/apps/spack/gautschi-gpu/apps/mpfr/4.2.1-gcc-11.4.1-iiap2cg/lib", ":")
prepend_path("CPATH", "/apps/spack/gautschi-gpu/apps/mpfr/4.2.1-gcc-11.4.1-iiap2cg/include", ":")
prepend_path("PKG_CONFIG_PATH", "/apps/spack/gautschi-gpu/apps/mpfr/4.2.1-gcc-11.4.1-iiap2cg/lib/pkgconfig", ":")
prepend_path("CMAKE_PREFIX_PATH", "/apps/spack/gautschi-gpu/apps/mpfr/4.2.1-gcc-11.4.1-iiap2cg/.", ":")
setenv("MPFR_HOME", "/apps/spack/gautschi-gpu/apps/mpfr/4.2.1-gcc-11.4.1-iiap2cg")
setenv("RCAC_MPFR_ROOT", "/apps/spack/gautschi-gpu/apps/mpfr/4.2.1-gcc-11.4.1-iiap2cg")
setenv("RCAC_MPFR_VERSION", "/apps/spack/gautschi-gpu/apps/mpfr/4.2.1-gcc-11.4.1-iiap2cg")

