-- -*- lua -*-
-- Module file created by spack (https://github.com/spack/spack) on 2026-06-16 13:23:18.804092
--
-- openblas@0.3.27%gcc@14.2.0~bignuma~consistent_fpcsr+dynamic_dispatch+fortran~ilp64+locking+pic+shared build_system=makefile symbol_suffix=none threads=openmp arch=linux-rocky8-zen3/kqza34s
--

whatis([[Name : openblas]])
whatis([[Version : 0.3.27]])
whatis([[Target : zen3]])
whatis([[Short description : OpenBLAS: An optimized BLAS library]])

help([[Name   : openblas]])
help([[Version: 0.3.27]])
help([[Target : zen3]])
help()
help([[OpenBLAS: An optimized BLAS library]])



prepend_path("PATH", "/apps/spack/anvil-cpu-2025/apps/openblas/0.3.27-gcc-14.2.0-kqza34s/bin", ":")
prepend_path("LIBRARY_PATH", "/apps/spack/anvil-cpu-2025/apps/openblas/0.3.27-gcc-14.2.0-kqza34s/lib", ":")
prepend_path("LD_LIBRARY_PATH", "/apps/spack/anvil-cpu-2025/apps/openblas/0.3.27-gcc-14.2.0-kqza34s/lib", ":")
prepend_path("CPATH", "/apps/spack/anvil-cpu-2025/apps/openblas/0.3.27-gcc-14.2.0-kqza34s/include", ":")
prepend_path("PKG_CONFIG_PATH", "/apps/spack/anvil-cpu-2025/apps/openblas/0.3.27-gcc-14.2.0-kqza34s/lib/pkgconfig", ":")
prepend_path("CMAKE_PREFIX_PATH", "/apps/spack/anvil-cpu-2025/apps/openblas/0.3.27-gcc-14.2.0-kqza34s/.", ":")
setenv("OPENBLAS_HOME", "/apps/spack/anvil-cpu-2025/apps/openblas/0.3.27-gcc-14.2.0-kqza34s")
setenv("RCAC_OPENBLAS_ROOT", "/apps/spack/anvil-cpu-2025/apps/openblas/0.3.27-gcc-14.2.0-kqza34s")
setenv("RCAC_OPENBLAS_VERSION", "/apps/spack/anvil-cpu-2025/apps/openblas/0.3.27-gcc-14.2.0-kqza34s")

