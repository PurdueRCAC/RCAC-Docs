-- -*- lua -*-
-- Module file created by spack (https://github.com/spack/spack) on 2026-03-23 16:33:11.096147
--
-- gmp@6.3.0%gcc@11.4.1+cxx build_system=autotools libs=shared,static arch=linux-rocky9-zen4/airq3yj
--

whatis([[Name : gmp]])
whatis([[Version : 6.3.0]])
whatis([[Target : zen4]])
whatis([[Short description : GMP is a free library for arbitrary precision arithmetic, operating on signed integers, rational numbers, and floating-point numbers.]])
whatis([[Configure options : --enable-cxx --enable-shared --enable-static --with-pic]])

help([[Name   : gmp]])
help([[Version: 6.3.0]])
help([[Target : zen4]])
help()
help([[GMP is a free library for arbitrary precision arithmetic, operating on
signed integers, rational numbers, and floating-point numbers.]])



prepend_path("LIBRARY_PATH", "/apps/spack/gautschi-gpu/apps/gmp/6.3.0-gcc-11.4.1-airq3yj/lib", ":")
prepend_path("LD_LIBRARY_PATH", "/apps/spack/gautschi-gpu/apps/gmp/6.3.0-gcc-11.4.1-airq3yj/lib", ":")
prepend_path("CPATH", "/apps/spack/gautschi-gpu/apps/gmp/6.3.0-gcc-11.4.1-airq3yj/include", ":")
prepend_path("PKG_CONFIG_PATH", "/apps/spack/gautschi-gpu/apps/gmp/6.3.0-gcc-11.4.1-airq3yj/lib/pkgconfig", ":")
prepend_path("CMAKE_PREFIX_PATH", "/apps/spack/gautschi-gpu/apps/gmp/6.3.0-gcc-11.4.1-airq3yj/.", ":")
setenv("GMP_HOME", "/apps/spack/gautschi-gpu/apps/gmp/6.3.0-gcc-11.4.1-airq3yj")
setenv("RCAC_GMP_ROOT", "/apps/spack/gautschi-gpu/apps/gmp/6.3.0-gcc-11.4.1-airq3yj")
setenv("RCAC_GMP_VERSION", "/apps/spack/gautschi-gpu/apps/gmp/6.3.0-gcc-11.4.1-airq3yj")

