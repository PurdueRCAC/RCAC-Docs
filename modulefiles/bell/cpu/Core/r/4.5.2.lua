-- -*- lua -*-
-- Module file for R 4.5.2 on Bell
--
-- r@4.5.2%gcc@8.5.0+X~memory_profiling~rmath build_system=autotools patches=abc572d arch=linux-rocky8-zen/rv5q5q3
--

whatis([[Name : r]])
whatis([[Version : 4.5.2]])
whatis([[Target : zen]])
whatis([[Short description : R is 'GNU S', a freely available language and environment for statistical computing and graphics which provides a wide variety of statistical and graphical techniques: linear and nonlinear modelling, statistical tests, time series analysis, classification, clustering, etc. Please consult the R project homepage for further information.]])

help([[Name   : r]])
help([[Version: 4.5.2]])
help([[Target : zen]])
help()
help([[R is 'GNU S', a freely available language and environment for
statistical computing and graphics which provides a wide variety of
statistical and graphical techniques: linear and nonlinear modelling,
statistical tests, time series analysis, classification, clustering,
etc. Please consult the R project homepage for further information.]])

local r_root = "/apps/spack/bell-20250305/apps/r/4.5.2-gcc-8.5.0-rv5q5q3"

depends_on("libpng/1.6.37")
depends_on("libtiff/4.7.0-d3hk3hg")
depends_on("openblas/0.3.27")
depends_on("tk/8.6.11-bhnemn7")

prepend_path("PATH", r_root .. "/bin", ":")
prepend_path("CPATH", r_root .. "/include", ":")
prepend_path("MANPATH", r_root .. "/share/man", ":")
prepend_path("CMAKE_PREFIX_PATH", r_root .. "/.", ":")
prepend_path("XDG_DATA_DIRS", "/apps/spack/bell-20250305/apps/harfbuzz/10.0.1-gcc-8.5.0-rtzoe74/share", ":")
prepend_path("GI_TYPELIB_PATH", "/apps/spack/bell-20250305/apps/harfbuzz/10.0.1-gcc-8.5.0-rtzoe74/lib/girepository-1.0", ":")
prepend_path("XLOCALEDIR", "/apps/spack/bell-20250305/apps/libx11/1.8.10-gcc-8.5.0-pcoirj2/share/X11/locale", ":")
prepend_path("XDG_DATA_DIRS", "/apps/spack/bell-20250305/apps/pango/1.54.0-gcc-8.5.0-alyplkr/share", ":")
prepend_path("GI_TYPELIB_PATH", "/apps/spack/bell-20250305/apps/pango/1.54.0-gcc-8.5.0-alyplkr/lib/girepository-1.0", ":")
prepend_path("LD_LIBRARY_PATH", r_root .. "/rlib/R/lib", ":")
prepend_path("LD_LIBRARY_PATH", r_root .. "/rlib", ":")
prepend_path("PKG_CONFIG_PATH", r_root .. "/rlib/pkgconfig", ":")
prepend_path("LD_PRELOAD", "/apps/spack/bell-20250305/apps/gcc-runtime/14.2.0-gcc-14.2.0-otbertb/lib/libstdc++.so.6", ":")
prepend_path("LD_LIBRARY_PATH", "/apps/spack/bell-20250305/apps/gdal/3.10.0-gcc-8.5.0-b6zsoas/lib64", ":")
prepend_path("LD_LIBRARY_PATH", "/apps/spack/bell-20250305/apps/geos/3.13.0-gcc-8.5.0-kxrr6pp/lib64", ":")
prepend_path("LD_LIBRARY_PATH", "/apps/spack/bell-20250305/apps/proj/9.4.1-gcc-8.5.0-uqs76rj/lib64", ":")
prepend_path("LD_LIBRARY_PATH", "/apps/spack/bell-20250305/apps/sqlite/3.46.0-gcc-8.5.0-4ynusvp/lib", ":")
setenv("R_HOME", r_root .. "/rlib/R")
setenv("RCAC_R_ROOT", r_root)
setenv("RCAC_R_VERSION", "4.5.2")
append_path("MANPATH", "", ":")
