-- -*- lua -*---
-- parallel-netcdf@1.12.3%gcc@13.3.0+burstbuffer+cxx+fortran+pic+shared build_system=autotools arch=linux-rocky8-zen3/c4frckp
--

whatis([[Name : parallel-netcdf]])
whatis([[Version : 1.12.3]])
whatis([[Short description : PnetCDF (Parallel netCDF) is a high-performance parallel I/O library for accessing files in format compatibility with Unidata's NetCDF, specifically the formats of CDF-1, 2, and 5. ]])
whatis([[Configure options : --with-mpi=/apps/spack/anvilgpu-2025/apps/mvapich2/2.3.7-1-gcc-13.3.0-xlyhmqf SEQ_CC=/apps/spack/anvilgpu-2025/framework/spack/lib/spack/env/gcc/gcc --enable-cxx --enable-fortran CFLAGS=-fPIC CXXFLAGS=-fPIC FCFLAGS=-fPIC -fallow-argument-mismatch FFLAGS=-fPIC -fallow-argument-mismatch --enable-relax-coord-bound --enable-shared --enable-static --disable-silent-rules --enable-burst-buffering]])

help([[PnetCDF (Parallel netCDF) is a high-performance parallel I/O library for
accessing files in format compatibility with Unidata's NetCDF,
specifically the formats of CDF-1, 2, and 5.]])


depends_on("mvapich2/2.3.7-1")

local modroot="/apps/spack/anvilgpu-2025/apps/parallel-netcdf/1.12.3-gcc-13.3.0-c4frckp"
prepend_path("PATH", modroot.."/bin", ":")
prepend_path("LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("CPATH", modroot.."/include", ":")
prepend_path("MANPATH", modroot.."/share/man", ":")
prepend_path("PKG_CONFIG_PATH", modroot.."/lib/pkgconfig", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/.", ":")
setenv("PARALLEL_NETCDF_HOME", modroot)
setenv("RCAC_PARALLEL_NETCDF_ROOT", modroot)
setenv("RCAC_PARALLEL_NETCDF_VERSION", modroot)
setenv("PNETCDF", modroot)
setenv("PNETCDF_HOME", modroot)

