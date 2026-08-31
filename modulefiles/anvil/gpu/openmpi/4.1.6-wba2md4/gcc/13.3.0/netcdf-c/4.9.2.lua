-- -*- lua -*---
-- netcdf-c@4.9.2%gcc@13.3.0+blosc+byterange+dap~fsync+hdf4~ipo~jna~logging+mpi~nczarr_zip+optimize+parallel-netcdf+pic+shared+szip+zstd build_system=cmake build_type=Release generator=make patches=0161eb8,3b09181 arch=linux-rocky8-zen3/3ist4us
--

whatis([[Name : netcdf-c]])
whatis([[Version : 4.9.2]])
whatis([[Short description : NetCDF (network Common Data Form) is a set of software libraries and machine-independent data formats that support the creation, access, and sharing of array-oriented scientific data. This is the C distribution.]])

help([[NetCDF (network Common Data Form) is a set of software libraries and
machine-independent data formats that support the creation, access, and
sharing of array-oriented scientific data. This is the C distribution.]])


depends_on("curl/8.8.0-shtex55")
depends_on("hdf/4.2.15-xwvxex4")
depends_on("hdf5/1.14.3")
depends_on("libxml2/2.10.3-af3sqt3")
depends_on("openmpi/4.1.6-cu12.6.1")
depends_on("parallel-netcdf/1.12.3")
depends_on("zlib/1.3.1-ummgjdr")

local modroot="/apps/spack/anvilgpu-2025/apps/netcdf-c/4.9.2-gcc-13.3.0-3ist4us"
prepend_path("PATH", modroot.."/bin", ":")
prepend_path("LIBRARY_PATH", modroot.."/lib64", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/lib64", ":")
prepend_path("CPATH", modroot.."/include", ":")
prepend_path("MANPATH", modroot.."/share/man", ":")
prepend_path("PKG_CONFIG_PATH", modroot.."/lib64/pkgconfig", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/.", ":")
append_path("HDF5_PLUGIN_PATH", modroot.."/plugins", ":")
setenv("NETCDF_C_HOME", modroot)
setenv("RCAC_NETCDF_C_ROOT", modroot)
setenv("RCAC_NETCDF_C_VERSION", modroot)
setenv("NETCDF", modroot)
setenv("NETCDF_ROOT", modroot)
setenv("NETCDF_INCLUDE", "-I"..modroot.."/include")

