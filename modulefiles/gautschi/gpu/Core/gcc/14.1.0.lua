-- -*- lua -*-
-- Module file created by spack (https://github.com/spack/spack) on 2026-03-25 13:37:57.870134
--
-- gcc@14.1.0%gcc@11.4.1~binutils+bootstrap~graphite~mold~nvptx~piclibs~profiled~strip build_system=autotools build_type=RelWithDebInfo languages='c,c++,fortran' arch=linux-rocky9-zen4/yt5bhjj
--

whatis([[Name : gcc]])
whatis([[Version : 14.1.0]])
whatis([[Target : zen4]])
whatis([[Short description : The GNU Compiler Collection includes front ends for C, C++, Objective-C, Fortran, Ada, and Go, as well as libraries for these languages.]])
whatis([[Configure options : --with-pkgversion=Spack GCC --with-bugurl=https://github.com/spack/spack/issues --disable-multilib --enable-languages=c,c++,fortran --disable-nls --disable-canonical-system-headers --with-system-zlib --with-zstd-include=/apps/spack/gautschi-gpu/apps/zstd/1.5.6-gcc-11.4.1-ctqxjhr/include --with-zstd-lib=/apps/spack/gautschi-gpu/apps/zstd/1.5.6-gcc-11.4.1-ctqxjhr/lib --enable-bootstrap --with-mpfr-include=/apps/spack/gautschi-gpu/apps/mpfr/4.2.1-gcc-11.4.1-iiap2cg/include --with-mpfr-lib=/apps/spack/gautschi-gpu/apps/mpfr/4.2.1-gcc-11.4.1-iiap2cg/lib --with-gmp-include=/apps/spack/gautschi-gpu/apps/gmp/6.3.0-gcc-11.4.1-airq3yj/include --with-gmp-lib=/apps/spack/gautschi-gpu/apps/gmp/6.3.0-gcc-11.4.1-airq3yj/lib --with-mpc-include=/apps/spack/gautschi-gpu/apps/mpc/1.3.1-gcc-11.4.1-zq2vfv3/include --with-mpc-lib=/apps/spack/gautschi-gpu/apps/mpc/1.3.1-gcc-11.4.1-zq2vfv3/lib --without-isl --with-stage1-ldflags=-Wl,-rpath,/apps/spack/gautschi-gpu/apps/gcc/14.1.0-gcc-11.4.1-yt5bhjj/lib -Wl,-rpath,/apps/spack/gautschi-gpu/apps/gcc/14.1.0-gcc-11.4.1-yt5bhjj/lib64 -Wl,-rpath,/apps/spack/gautschi-gpu/apps/gcc-runtime/11.4.1-gcc-11.4.1-7hex6dy/lib -Wl,-rpath,/usr/lib -Wl,-rpath,/apps/spack/gautschi-gpu/apps/gmp/6.3.0-gcc-11.4.1-airq3yj/lib -Wl,-rpath,/apps/spack/gautschi-gpu/apps/mpc/1.3.1-gcc-11.4.1-zq2vfv3/lib -Wl,-rpath,/apps/spack/gautschi-gpu/apps/mpfr/4.2.1-gcc-11.4.1-iiap2cg/lib -Wl,-rpath,/usr/lib -Wl,-rpath,/apps/spack/gautschi-gpu/apps/zstd/1.5.6-gcc-11.4.1-ctqxjhr/lib -Wl,-rpath,/usr/lib64 -Wl,-rpath,/usr/lib64 --with-boot-ldflags=-Wl,-rpath,/apps/spack/gautschi-gpu/apps/gcc/14.1.0-gcc-11.4.1-yt5bhjj/lib -Wl,-rpath,/apps/spack/gautschi-gpu/apps/gcc/14.1.0-gcc-11.4.1-yt5bhjj/lib64 -Wl,-rpath,/apps/spack/gautschi-gpu/apps/gcc-runtime/11.4.1-gcc-11.4.1-7hex6dy/lib -Wl,-rpath,/usr/lib -Wl,-rpath,/apps/spack/gautschi-gpu/apps/gmp/6.3.0-gcc-11.4.1-airq3yj/lib -Wl,-rpath,/apps/spack/gautschi-gpu/apps/mpc/1.3.1-gcc-11.4.1-zq2vfv3/lib -Wl,-rpath,/apps/spack/gautschi-gpu/apps/mpfr/4.2.1-gcc-11.4.1-iiap2cg/lib -Wl,-rpath,/usr/lib -Wl,-rpath,/apps/spack/gautschi-gpu/apps/zstd/1.5.6-gcc-11.4.1-ctqxjhr/lib -Wl,-rpath,/usr/lib64 -Wl,-rpath,/usr/lib64 -static-libstdc++ -static-libgcc --with-build-config=spack]])

help([[Name   : gcc]])
help([[Version: 14.1.0]])
help([[Target : zen4]])
help()
help([[The GNU Compiler Collection includes front ends for C, C++, Objective-C,
Fortran, Ada, and Go, as well as libraries for these languages.]])

-- Services provided by the package
family("compiler")

-- Loading this module unlocks the path below unconditionally
prepend_path("MODULEPATH", "/apps/spack/gautschi-gpu/modules/lmod/linux-rocky9-x86_64/gcc/14.1.0")


depends_on("gmp/6.3.0-airq3yj")
depends_on("mpc/1.3.1-zq2vfv3")
depends_on("mpfr/4.2.1-iiap2cg")
depends_on("zlib/1.2.11-seqnime")

prepend_path("PATH", "/apps/spack/gautschi-gpu/apps/gcc/14.1.0-gcc-11.4.1-yt5bhjj/bin", ":")
prepend_path("LIBRARY_PATH", "/apps/spack/gautschi-gpu/apps/gcc/14.1.0-gcc-11.4.1-yt5bhjj/lib", ":")
prepend_path("LD_LIBRARY_PATH", "/apps/spack/gautschi-gpu/apps/gcc/14.1.0-gcc-11.4.1-yt5bhjj/lib", ":")
prepend_path("LIBRARY_PATH", "/apps/spack/gautschi-gpu/apps/gcc/14.1.0-gcc-11.4.1-yt5bhjj/lib64", ":")
prepend_path("LD_LIBRARY_PATH", "/apps/spack/gautschi-gpu/apps/gcc/14.1.0-gcc-11.4.1-yt5bhjj/lib64", ":")
prepend_path("CPATH", "/apps/spack/gautschi-gpu/apps/gcc/14.1.0-gcc-11.4.1-yt5bhjj/include", ":")
prepend_path("MANPATH", "/apps/spack/gautschi-gpu/apps/gcc/14.1.0-gcc-11.4.1-yt5bhjj/share/man", ":")
prepend_path("CMAKE_PREFIX_PATH", "/apps/spack/gautschi-gpu/apps/gcc/14.1.0-gcc-11.4.1-yt5bhjj/.", ":")
setenv("CC", "/apps/spack/gautschi-gpu/apps/gcc/14.1.0-gcc-11.4.1-yt5bhjj/bin/gcc")
setenv("FC", "/apps/spack/gautschi-gpu/apps/gcc/14.1.0-gcc-11.4.1-yt5bhjj/bin/gfortran")
setenv("F77", "/apps/spack/gautschi-gpu/apps/gcc/14.1.0-gcc-11.4.1-yt5bhjj/bin/gfortran")
setenv("GCC_HOME", "/apps/spack/gautschi-gpu/apps/gcc/14.1.0-gcc-11.4.1-yt5bhjj")
setenv("RCAC_GCC_ROOT", "/apps/spack/gautschi-gpu/apps/gcc/14.1.0-gcc-11.4.1-yt5bhjj")
setenv("RCAC_GCC_VERSION", "/apps/spack/gautschi-gpu/apps/gcc/14.1.0-gcc-11.4.1-yt5bhjj")
append_path("MANPATH", "", ":")

