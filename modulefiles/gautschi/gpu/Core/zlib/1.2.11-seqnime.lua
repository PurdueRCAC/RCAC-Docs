-- -*- lua -*-
-- Module file created by spack (https://github.com/spack/spack) on 2026-03-23 16:28:15.883558
--
-- zlib@1.2.11%gcc@11.4.1+optimize+pic+shared build_system=makefile arch=linux-rocky9-zen4/seqnime
--

whatis([[Name : zlib]])
whatis([[Version : 1.2.11]])
whatis([[Target : zen4]])
whatis([[Short description : A free, general-purpose, legally unencumbered lossless data-compression library. ]])
whatis([[Configure options : unknown, software installed outside of Spack]])

help([[Name   : zlib]])
help([[Version: 1.2.11]])
help([[Target : zen4]])
help()
help([[A free, general-purpose, legally unencumbered lossless data-compression
library.]])



prepend_path("MANPATH", "/usr/share/man", ":")
prepend_path("ACLOCAL_PATH", "/usr/share/aclocal", ":")
prepend_path("PKG_CONFIG_PATH", "/usr/lib64/pkgconfig", ":")
prepend_path("PKG_CONFIG_PATH", "/usr/share/pkgconfig", ":")
setenv("ZLIB_HOME", "/usr")
setenv("RCAC_ZLIB_ROOT", "/usr")
setenv("RCAC_ZLIB_VERSION", "/usr")
append_path("MANPATH", "", ":")

