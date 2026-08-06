-- -*- lua -*---
-- mpc@1.3.1%gcc@8.5.0 build_system=autotools libs=shared,static arch=linux-rocky8-zen/45xcm7c
--

whatis([[Name : mpc]])
whatis([[Version : 1.3.1]])
whatis([[Short description : Gnu Mpc is a C library for the arithmetic of complex numbers with arbitrarily high precision and correct rounding of the result.]])
whatis([[Configure options : --with-mpfr=/apps/spack/anvilgpu-2025/apps/mpfr/4.2.1-gcc-8.5.0-7ymsytp --with-gmp=/apps/spack/anvilgpu-2025/apps/gmp/6.3.0-gcc-8.5.0-o4hyb7k --enable-shared --enable-static]])

help([[Gnu Mpc is a C library for the arithmetic of complex numbers with
arbitrarily high precision and correct rounding of the result.]])


depends_on("gmp/6.3.0-o4hyb7k")
depends_on("mpfr/4.2.1-7ymsytp")

local modroot="/apps/spack/anvilgpu-2025/apps/mpc/1.3.1-gcc-8.5.0-45xcm7c"
prepend_path("LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("CPATH", modroot.."/include", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/.", ":")
setenv("MPC_HOME", modroot)
setenv("RCAC_MPC_ROOT", modroot)
setenv("RCAC_MPC_VERSION", modroot)

