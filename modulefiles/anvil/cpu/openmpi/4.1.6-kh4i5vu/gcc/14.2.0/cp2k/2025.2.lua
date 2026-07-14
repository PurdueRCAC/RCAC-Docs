-- -*- lua -*-
-- Module file created by spack (https://github.com/spack/spack) on 2026-06-16 13:07:22.461709
--
-- cp2k@2025.2%gcc@14.2.0~cosma~cuda+dlaf+elpa~enable_regtests~ipo+libint~libvori~libxc+mpi~mpi_f08+openmp~pexsi+plumed~pytorch~quip~rocm~sirius~spglib~spla build_system=cmake build_type=Release generator=make lmax=5 smm=blas arch=linux-rocky8-zen3/azh3ulj
--

whatis([[Name : cp2k]])
whatis([[Version : 2025.2]])
whatis([[Target : zen3]])
whatis([[Short description : CP2K is a quantum chemistry and solid state physics software package that can perform atomistic simulations of solid state, liquid, molecular, periodic, material, crystal, and biological systems ]])

help([[Name   : cp2k]])
help([[Version: 2025.2]])
help([[Target : zen3]])
help()
help([[CP2K is a quantum chemistry and solid state physics software package
that can perform atomistic simulations of solid state, liquid,
molecular, periodic, material, crystal, and biological systems]])


depends_on("fftw/3.3.10")
depends_on("openblas/0.3.27")
depends_on("openmpi/4.1.6")

prepend_path("PATH", "/apps/spack/anvil-cpu-2025/apps/cp2k/2025.2-gcc-14.2.0-azh3ulj/bin", ":")
prepend_path("LIBRARY_PATH", "/apps/spack/anvil-cpu-2025/apps/cp2k/2025.2-gcc-14.2.0-azh3ulj/lib", ":")
prepend_path("LD_LIBRARY_PATH", "/apps/spack/anvil-cpu-2025/apps/cp2k/2025.2-gcc-14.2.0-azh3ulj/lib", ":")
prepend_path("CPATH", "/apps/spack/anvil-cpu-2025/apps/cp2k/2025.2-gcc-14.2.0-azh3ulj/include", ":")
prepend_path("PKG_CONFIG_PATH", "/apps/spack/anvil-cpu-2025/apps/cp2k/2025.2-gcc-14.2.0-azh3ulj/lib/pkgconfig", ":")
prepend_path("CMAKE_PREFIX_PATH", "/apps/spack/anvil-cpu-2025/apps/cp2k/2025.2-gcc-14.2.0-azh3ulj/.", ":")
setenv("CP2K_HOME", "/apps/spack/anvil-cpu-2025/apps/cp2k/2025.2-gcc-14.2.0-azh3ulj")
setenv("RCAC_CP2K_ROOT", "/apps/spack/anvil-cpu-2025/apps/cp2k/2025.2-gcc-14.2.0-azh3ulj")
setenv("RCAC_CP2K_VERSION", "/apps/spack/anvil-cpu-2025/apps/cp2k/2025.2-gcc-14.2.0-azh3ulj")

