-- -*- lua -*-
-- Module file created by spack (https://github.com/spack/spack) on 2026-03-23 16:35:12.419162
--
-- mpc@1.3.1%gcc@11.4.1 build_system=autotools libs=shared,static arch=linux-rocky9-zen4/zq2vfv3
--

whatis([[Name : mpc]])
whatis([[Version : 1.3.1]])
whatis([[Target : zen4]])
whatis([[Short description : Gnu Mpc is a C library for the arithmetic of complex numbers with arbitrarily high precision and correct rounding of the result.]])
whatis([[Configure options : --with-mpfr=/apps/spack/gautschi-gpu/apps/mpfr/4.2.1-gcc-11.4.1-iiap2cg --with-gmp=/apps/spack/gautschi-gpu/apps/gmp/6.3.0-gcc-11.4.1-airq3yj --enable-shared --enable-static]])

help([[Name   : mpc]])
help([[Version: 1.3.1]])
help([[Target : zen4]])
help()
help([[Gnu Mpc is a C library for the arithmetic of complex numbers with
arbitrarily high precision and correct rounding of the result.]])


depends_on("gmp/6.3.0-airq3yj")
depends_on("mpfr/4.2.1-iiap2cg")

prepend_path("LIBRARY_PATH", "/apps/spack/gautschi-gpu/apps/mpc/1.3.1-gcc-11.4.1-zq2vfv3/lib", ":")
prepend_path("LD_LIBRARY_PATH", "/apps/spack/gautschi-gpu/apps/mpc/1.3.1-gcc-11.4.1-zq2vfv3/lib", ":")
prepend_path("CPATH", "/apps/spack/gautschi-gpu/apps/mpc/1.3.1-gcc-11.4.1-zq2vfv3/include", ":")
prepend_path("CMAKE_PREFIX_PATH", "/apps/spack/gautschi-gpu/apps/mpc/1.3.1-gcc-11.4.1-zq2vfv3/.", ":")
setenv("MPC_HOME", "/apps/spack/gautschi-gpu/apps/mpc/1.3.1-gcc-11.4.1-zq2vfv3")
setenv("RCAC_MPC_ROOT", "/apps/spack/gautschi-gpu/apps/mpc/1.3.1-gcc-11.4.1-zq2vfv3")
setenv("RCAC_MPC_VERSION", "/apps/spack/gautschi-gpu/apps/mpc/1.3.1-gcc-11.4.1-zq2vfv3")


