-- -*- lua -*-
-- Module file created by spack (https://github.com/spack/spack) on 2026-10-06 11:45:43.802594
--
-- gsl@2.7.1%gcc@11.4.1~external-cblas+pic+shared build_system=autotools arch=linux-rocky9-x86_64_v3/acr2qmb
--

whatis([[Name : gsl]])
whatis([[Version : 2.7.1]])
whatis([[Target : x86_64_v3]])
whatis([[Short description : The GNU Scientific Library (GSL) is a numerical library for C and C++ programmers. It is free software under the GNU General Public License. The library provides a wide range of mathematical routines such as random number generators, special functions and least-squares fitting. There are over 1000 functions in total with an extensive test suite.]])
whatis([[Configure options : --enable-shared --with-pic]])

help([[Name   : gsl]])
help([[Version: 2.7.1]])
help([[Target : x86_64_v3]])
help()
help([[The GNU Scientific Library (GSL) is a numerical library for C and C++
programmers. It is free software under the GNU General Public License.
The library provides a wide range of mathematical routines such as
random number generators, special functions and least-squares fitting.
There are over 1000 functions in total with an extensive test suite.]])


depends_on("gcc-runtime/11.4.1")

prepend_path("PATH", "/apps/spack/scholar-all-20241216/apps/gsl/2.7.1-gcc-11.4.1-acr2qmb/bin", ":")
prepend_path("LIBRARY_PATH", "/apps/spack/scholar-all-20241216/apps/gsl/2.7.1-gcc-11.4.1-acr2qmb/lib", ":")
prepend_path("LD_LIBRARY_PATH", "/apps/spack/scholar-all-20241216/apps/gsl/2.7.1-gcc-11.4.1-acr2qmb/lib", ":")
prepend_path("CPATH", "/apps/spack/scholar-all-20241216/apps/gsl/2.7.1-gcc-11.4.1-acr2qmb/include", ":")
prepend_path("MANPATH", "/apps/spack/scholar-all-20241216/apps/gsl/2.7.1-gcc-11.4.1-acr2qmb/share/man", ":")
prepend_path("ACLOCAL_PATH", "/apps/spack/scholar-all-20241216/apps/gsl/2.7.1-gcc-11.4.1-acr2qmb/share/aclocal", ":")
prepend_path("PKG_CONFIG_PATH", "/apps/spack/scholar-all-20241216/apps/gsl/2.7.1-gcc-11.4.1-acr2qmb/lib/pkgconfig", ":")
prepend_path("CMAKE_PREFIX_PATH", "/apps/spack/scholar-all-20241216/apps/gsl/2.7.1-gcc-11.4.1-acr2qmb/.", ":")
setenv("GSL_ROOT_DIR", "/apps/spack/scholar-all-20241216/apps/gsl/2.7.1-gcc-11.4.1-acr2qmb")
setenv("GSL_HOME", "/apps/spack/scholar-all-20241216/apps/gsl/2.7.1-gcc-11.4.1-acr2qmb")
setenv("RCAC_GSL_ROOT", "/apps/spack/scholar-all-20241216/apps/gsl/2.7.1-gcc-11.4.1-acr2qmb")
setenv("RCAC_GSL_VERSION", "/apps/spack/scholar-all-20241216/apps/gsl/2.7.1-gcc-11.4.1-acr2qmb")
append_path("MANPATH", "", ":")

