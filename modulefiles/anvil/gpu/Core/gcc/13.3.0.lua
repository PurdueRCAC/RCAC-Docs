-- -*- lua -*---
-- gcc@13.3.0%gcc@8.5.0~binutils+bootstrap~graphite~mold~nvptx~piclibs~profiled~strip build_system=autotools build_type=RelWithDebInfo languages='c,c++,fortran' arch=linux-rocky8-zen/z2pschb
--

whatis([[Name : gcc]])
whatis([[Version : 13.3.0]])
whatis([[Short description : The GNU Compiler Collection includes front ends for C, C++, Objective-C, Fortran, Ada, and Go, as well as libraries for these languages.]])
whatis([[Configure options : --with-pkgversion=Spack GCC --with-bugurl=https://github.com/spack/spack/issues --disable-multilib --enable-languages=c,c++,fortran --disable-nls --disable-canonical-system-headers --with-system-zlib --with-zstd-include=/apps/spack/anvilgpu-2025/apps/zstd/1.5.6-gcc-8.5.0-ylwnc6f/include --with-zstd-lib=/apps/spack/anvilgpu-2025/apps/zstd/1.5.6-gcc-8.5.0-ylwnc6f/lib --enable-bootstrap --with-mpfr-include=/apps/spack/anvilgpu-2025/apps/mpfr/4.2.1-gcc-8.5.0-7ymsytp/include --with-mpfr-lib=/apps/spack/anvilgpu-2025/apps/mpfr/4.2.1-gcc-8.5.0-7ymsytp/lib --with-gmp-include=/apps/spack/anvilgpu-2025/apps/gmp/6.3.0-gcc-8.5.0-o4hyb7k/include --with-gmp-lib=/apps/spack/anvilgpu-2025/apps/gmp/6.3.0-gcc-8.5.0-o4hyb7k/lib --with-mpc-include=/apps/spack/anvilgpu-2025/apps/mpc/1.3.1-gcc-8.5.0-45xcm7c/include --with-mpc-lib=/apps/spack/anvilgpu-2025/apps/mpc/1.3.1-gcc-8.5.0-45xcm7c/lib --without-isl --with-stage1-ldflags=-Wl,-rpath,/apps/spack/anvilgpu-2025/apps/gcc/13.3.0-gcc-8.5.0-z2pschb/lib -Wl,-rpath,/apps/spack/anvilgpu-2025/apps/gcc/13.3.0-gcc-8.5.0-z2pschb/lib64 -Wl,-rpath,/apps/spack/anvilgpu-2025/apps/gcc-runtime/8.5.0-gcc-8.5.0-u6ywdr3/lib -Wl,-rpath,/usr/lib -Wl,-rpath,/apps/spack/anvilgpu-2025/apps/gmp/6.3.0-gcc-8.5.0-o4hyb7k/lib -Wl,-rpath,/apps/spack/anvilgpu-2025/apps/mpc/1.3.1-gcc-8.5.0-45xcm7c/lib -Wl,-rpath,/apps/spack/anvilgpu-2025/apps/mpfr/4.2.1-gcc-8.5.0-7ymsytp/lib -Wl,-rpath,/apps/spack/anvilgpu-2025/apps/zlib/1.3.1-gcc-8.5.0-z54tklg/lib -Wl,-rpath,/apps/spack/anvilgpu-2025/apps/zstd/1.5.6-gcc-8.5.0-ylwnc6f/lib -Wl,-rpath,/usr/lib64 --with-boot-ldflags=-Wl,-rpath,/apps/spack/anvilgpu-2025/apps/gcc/13.3.0-gcc-8.5.0-z2pschb/lib -Wl,-rpath,/apps/spack/anvilgpu-2025/apps/gcc/13.3.0-gcc-8.5.0-z2pschb/lib64 -Wl,-rpath,/apps/spack/anvilgpu-2025/apps/gcc-runtime/8.5.0-gcc-8.5.0-u6ywdr3/lib -Wl,-rpath,/usr/lib -Wl,-rpath,/apps/spack/anvilgpu-2025/apps/gmp/6.3.0-gcc-8.5.0-o4hyb7k/lib -Wl,-rpath,/apps/spack/anvilgpu-2025/apps/mpc/1.3.1-gcc-8.5.0-45xcm7c/lib -Wl,-rpath,/apps/spack/anvilgpu-2025/apps/mpfr/4.2.1-gcc-8.5.0-7ymsytp/lib -Wl,-rpath,/apps/spack/anvilgpu-2025/apps/zlib/1.3.1-gcc-8.5.0-z54tklg/lib -Wl,-rpath,/apps/spack/anvilgpu-2025/apps/zstd/1.5.6-gcc-8.5.0-ylwnc6f/lib -Wl,-rpath,/usr/lib64 -static-libstdc++ -static-libgcc --with-build-config=spack]])

help([[The GNU Compiler Collection includes front ends for C, C++, Objective-C,
Fortran, Ada, and Go, as well as libraries for these languages.]])

-- Services provided by the package
family("compiler")

-- Loading this module unlocks the path below unconditionally
prepend_path("MODULEPATH", "/apps/spack/anvilgpu-2025/modules/lmod/linux-rocky8-x86_64/gcc/13.3.0")


depends_on("gmp/6.3.0-o4hyb7k")
depends_on("mpc/1.3.1-45xcm7c")
depends_on("mpfr/4.2.1-7ymsytp")
depends_on("zlib/1.3.1-z54tklg")

local modroot="/apps/spack/anvilgpu-2025/apps/gcc/13.3.0-gcc-8.5.0-z2pschb"
prepend_path("PATH", modroot.."/bin", ":")
prepend_path("LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("LIBRARY_PATH", modroot.."/lib64", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/lib64", ":")
prepend_path("CPATH", modroot.."/include", ":")
prepend_path("MANPATH", modroot.."/share/man", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/.", ":")
setenv("CC", modroot.."/bin/gcc")
setenv("FC", modroot.."/bin/gfortran")
setenv("F77", modroot.."/bin/gfortran")
setenv("GCC_HOME", modroot)
setenv("RCAC_GCC_ROOT", modroot)
setenv("RCAC_GCC_VERSION", modroot)
setenv("F95", modroot.."/bin/gfortran")

