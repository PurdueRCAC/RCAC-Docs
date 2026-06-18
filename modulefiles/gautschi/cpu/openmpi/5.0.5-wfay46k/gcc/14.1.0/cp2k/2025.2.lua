-- -*- lua -*---
-- cp2k@2025.2%gcc@14.1.0~cosma~cuda~dlaf+elpa~enable_regtests~ipo+libint~libvori~libxc+mpi~mpi_f08+openmp~pexsi+plumed~pytorch~quip~rocm~sirius~spglib~spla build_system=cmake build_type=Release generator=make lmax=5 smm=libxsmm arch=linux-rocky9-zen4/2r4ugot
--

whatis([[Name : cp2k]])
whatis([[Version : 2025.2]])
whatis([[Short description : CP2K is a quantum chemistry and solid state physics software package that can perform atomistic simulations of solid state, liquid, molecular, periodic, material, crystal, and biological systems ]])

help([[CP2K is a quantum chemistry and solid state physics software package
that can perform atomistic simulations of solid state, liquid,
molecular, periodic, material, crystal, and biological systems]])


depends_on("netlib-lapack/3.11.0")
depends_on("openmpi/5.0.5")

local modroot="/apps/spack/gautschi-cpu/apps/cp2k/2025.2-gcc-14.1.0-2r4ugot"
prepend_path("PATH", modroot.."/bin", ":")
prepend_path("LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("CPATH", modroot.."/include", ":")
prepend_path("PKG_CONFIG_PATH", modroot.."/lib/pkgconfig", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/.", ":")
setenv("CP2K_HOME", modroot)
setenv("RCAC_CP2K_ROOT", modroot)
setenv("RCAC_CP2K_VERSION", modroot)

