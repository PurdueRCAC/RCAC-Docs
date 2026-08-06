-- -*- lua -*---
-- hdf@4.2.15%gcc@13.3.0+external-xdr~fortran~java~netcdf+pic+shared+szip build_system=autotools patches=49733dd,5434f29,ce75518,d54592d,f7d67e8 arch=linux-rocky8-zen3/xwvxex4
--

whatis([[Name : hdf]])
whatis([[Version : 4.2.15]])
whatis([[Short description : HDF4 (also known as HDF) is a library and multi-object file format for storing and managing data between machines.]])
whatis([[Configure options : --enable-production --enable-static --with-zlib=/apps/spack/anvilgpu-2025/apps/zlib/1.3.1-gcc-13.3.0-ummgjdr --with-jpeg=/apps/spack/anvilgpu-2025/apps/libjpeg-turbo/3.0.3-gcc-13.3.0-ats5dkx --enable-shared --disable-netcdf --disable-fortran --disable-java --with-szlib=/apps/spack/anvilgpu-2025/apps/libaec/1.0.6-gcc-13.3.0-z7munhf LIBS=-ltirpc LDFLAGS=-L/apps/spack/anvilgpu-2025/apps/libtirpc/1.3.3-gcc-13.3.0-2awzvvu/lib FFLAGS=-fallow-argument-mismatch FCFLAGS=-fallow-argument-mismatch]])

help([[HDF4 (also known as HDF) is a library and multi-object file format for
storing and managing data between machines.]])


depends_on("zlib/1.3.1-ummgjdr")

local modroot="/apps/spack/anvilgpu-2025/apps/hdf/4.2.15-gcc-13.3.0-xwvxex4"
prepend_path("PATH", modroot.."/bin", ":")
prepend_path("LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("CPATH", modroot.."/include", ":")
prepend_path("MANPATH", modroot.."/share/man", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/.", ":")
setenv("HDF_HOME", modroot)
setenv("RCAC_HDF_ROOT", modroot)
setenv("RCAC_HDF_VERSION", modroot)

