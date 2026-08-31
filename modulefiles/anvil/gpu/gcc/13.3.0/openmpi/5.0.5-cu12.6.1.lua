-- -*- lua -*---
-- openmpi@5.0.5%gcc@13.3.0+atomics+cuda~debug+gpfs~internal-hwloc~internal-libevent~internal-pmix~java~lustre~memchecker+openshmem+romio+rsh~static+vt+wrapper-rpath build_system=autotools cuda_arch=none fabrics=cma,hcoll,knem,ofi,ucc,ucx,verbs,xpmem romio-filesystem=none schedulers=slurm arch=linux-rocky8-zen3/ejf5w66
--

whatis([[Name : openmpi]])
whatis([[Version : 5.0.5]])
whatis([[Short description : An open source Message Passing Interface implementation.]])
whatis([[Configure options : --enable-shared --disable-silent-rules --disable-sphinx --enable-builtin-atomics --disable-static --enable-mpi1-compatibility --with-verbs=/usr --with-knem=/apps/spack/anvilgpu-2025/apps/knem/1.1.4-gcc-13.3.0-tkpktyx --without-mxm --without-fca --without-psm --with-ofi=/apps/spack/anvilgpu-2025/apps/libfabric/1.19.1-gcc-13.3.0-ystu653 --with-ucx=/apps/spack/anvilgpu-2025/apps/ucx/1.17.0-gcc-13.3.0-55tghvy --with-hcoll=/opt/mellanox/hcoll --with-cma --with-xpmem=/apps/spack/anvilgpu-2025/apps/xpmem/2.6.5-36-gcc-13.3.0-edohenh --with-ucc=/apps/spack/anvilgpu-2025/apps/ucc/1.3.0-gcc-13.3.0-7bxrgzo --without-psm2 --with-cray-xpmem --without-loadleveler --without-tm --without-lsf --with-slurm --without-sge --without-alps --disable-memchecker --with-libevent=/apps/spack/anvilgpu-2025/apps/libevent/2.1.12-gcc-13.3.0-whusim6 --with-pmix=/apps/spack/anvilgpu-2025/apps/pmix/5.0.3-gcc-13.3.0-cadi5sj --with-zlib=/apps/spack/anvilgpu-2025/apps/zlib/1.3.1-gcc-13.3.0-ummgjdr --with-hwloc=/apps/spack/anvilgpu-2025/apps/hwloc/2.11.1-gcc-13.3.0-hta4rev --disable-java --disable-mpi-java --with-gpfs --enable-dlopen --with-cuda=/apps/anvilgpu/external/apps/cuda-toolkit/12.6.1 --with-cuda-libdir=/apps/anvilgpu/external/apps/cuda-toolkit/12.6.1/lib64/stubs --enable-oshmem --enable-wrapper-rpath --disable-wrapper-runpath --with-wrapper-ldflags=-Wl,-rpath,/apps/spack/anvilgpu-2025/apps/gcc/13.3.0-gcc-8.5.0-z2pschb/lib/gcc/x86_64-pc-linux-gnu/13.3.0 -Wl,-rpath,/apps/spack/anvilgpu-2025/apps/gcc/13.3.0-gcc-8.5.0-z2pschb/lib64 CFLAGS=-DYY_BUF_SIZE=1048576 --disable-debug]])

help([[An open source Message Passing Interface implementation. The Open MPI
Project is an open source Message Passing Interface implementation that
is developed and maintained by a consortium of academic, research, and
industry partners. Open MPI is therefore able to combine the expertise,
technologies, and resources from all across the High Performance
Computing community in order to build the best MPI library available.
Open MPI offers advantages for system and software vendors, application
developers and computer science researchers.]])

-- Services provided by the package
family("mpi")

-- Loading this module unlocks the path below unconditionally
prepend_path("MODULEPATH", "/apps/spack/anvilgpu-2025/modules/lmod/linux-rocky8-x86_64/openmpi/5.0.5-ejf5w66/gcc/13.3.0")

-- Try to load variables into path to see if providers are there

-- Change MODULEPATH based on the result of the tests above

-- Set variables to notify the provider of the new services
setenv("LMOD_MPI_NAME", "openmpi")
setenv("LMOD_MPI_VERSION", "5.0.5-ejf5w66")

depends_on("cuda/12.6.1-qmri43f")
depends_on("zlib/1.3.1-ummgjdr")

local modroot="/apps/spack/anvilgpu-2025/apps/openmpi/5.0.5-gcc-13.3.0-ejf5w66"
prepend_path("PATH", modroot.."/bin", ":")
prepend_path("LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("CPATH", modroot.."/include", ":")
prepend_path("MANPATH", modroot.."/share/man", ":")
prepend_path("PKG_CONFIG_PATH", modroot.."/lib/pkgconfig", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/.", ":")
prepend_path("LD_LIBRARY_PATH", "/apps/spack/anvilgpu-2025/apps/libfabric/1.19.1-gcc-13.3.0-ystu653/lib", ":")
prepend_path("LD_LIBRARY_PATH", "/apps/spack/anvilgpu-2025/apps/libfabric/1.19.1-gcc-13.3.0-ystu653/lib64", ":")
setenv("MPICC", modroot.."/bin/mpicc")
setenv("MPICXX", modroot.."/bin/mpic++")
setenv("MPIF77", modroot.."/bin/mpif77")
setenv("MPIF90", modroot.."/bin/mpif90")
setenv("MPIFC", modroot.."/bin/mpifort")
setenv("OPENMPI_HOME", modroot)
setenv("RCAC_OPENMPI_ROOT", modroot)
setenv("RCAC_OPENMPI_VERSION", modroot)
setenv("CC", "mpicc")
setenv("CXX", "mpiCC")
setenv("FC", "mpif90")
setenv("F90", "mpif90")
setenv("F77", "mpif77")
setenv("MPI_HOME", modroot)
setenv("OMPI_MCA_btl_openib_warn_default_gid_prefix", "0")
setenv("OMPI_MCA_btl_openib_warn_nonexistent_if", "0")
setenv("OMPI_MCA_btl_openib_warn_no_device_params_found", "0")
setenv("OMPI_MCA_pml", "ucx")
setenv("OMPI_MCA_spml", "ucx")
setenv("OMPI_MCA_btl", "^vader,tcp,openib,uct")
setenv("OMPI_MCA_coll_hcoll_enable", "0")
setenv("OMPI_MCA_hwloc_base_binding_policy", "core")
setenv("OMPI_MCA_oob_tcp_if_include", "ib1,ib0")
setenv("OMPI_MCA_osc", "ucx")

