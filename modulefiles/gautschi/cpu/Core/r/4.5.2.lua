-- /apps/spack/gautschi-cpu/apps/r/4.5.2-gcc-14.1.0-lrfbr5v/rlib/R/modulefile
-- r@4.5.2%gcc@14.1.0 build_system=autotools arch=linux-rocky9-zen4/lrfbr5v
--

whatis([[Name : r]])
whatis([[Version : 4.5.2]])
whatis([[Short description : R is 'GNU S', a freely available language and environment for statistical computing and graphics which provides a wide variety of statistical and graphical techniques: linear and nonlinear modelling, statistical tests, time series analysis, classification, clustering, etc. Please consult the R project homepage for further information.]])

help([[R is 'GNU S', a freely available language and environment for
statistical computing and graphics which provides a wide variety of
statistical and graphical techniques: linear and nonlinear modelling,
statistical tests, time series analysis, classification, clustering,
etc. Please consult the R project homepage for further information.]])

local modroot="/apps/spack/gautschi-cpu/apps/r/4.5.2-gcc-14.1.0-lrfbr5v"
local spack="/apps/spack/gautschi-cpu/apps"

prepend_path("PATH", modroot.."/bin", ":")
prepend_path("CPATH", modroot.."/include", ":")
prepend_path("MANPATH", modroot.."/share/man", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/.", ":")

-- R libs
prepend_path("LD_LIBRARY_PATH", modroot.."/rlib/R/lib", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/rlib", ":")
prepend_path("PKG_CONFIG_PATH", modroot.."/rlib/pkgconfig", ":")

-- gcc 14.1.0 runtime
prepend_path("LD_LIBRARY_PATH", spack.."/gcc/14.1.0-gcc-11.4.1-fa2732i/lib64", ":")

-- Spack deps needed at runtime by CRAN packages
prepend_path("LD_LIBRARY_PATH", spack.."/curl/8.8.0-gcc-11.4.1-qfg7usf/lib", ":")
prepend_path("LD_LIBRARY_PATH", spack.."/libxml2/2.10.3-gcc-11.4.1-4drlclc/lib", ":")
prepend_path("LD_LIBRARY_PATH", spack.."/udunits/2.2.28-gcc-11.4.1-y2ksuqv/lib", ":")
prepend_path("LD_LIBRARY_PATH", spack.."/fontconfig/2.15.0-gcc-11.4.1-a367p35/lib", ":")
prepend_path("LD_LIBRARY_PATH", spack.."/freetype/2.13.2-gcc-11.4.1-5lnok44/lib", ":")
prepend_path("LD_LIBRARY_PATH", spack.."/harfbuzz/9.0.0-gcc-11.4.1-j6pndui/lib", ":")
prepend_path("LD_LIBRARY_PATH", spack.."/fribidi/1.0.12-gcc-11.4.1-aqijpfb/lib", ":")
prepend_path("LD_LIBRARY_PATH", spack.."/libpng/1.6.39-gcc-11.4.1-q7jm2rg/lib", ":")
prepend_path("LD_LIBRARY_PATH", spack.."/libjpeg-turbo/3.0.3-gcc-11.4.1-yxqswws/lib64", ":")
prepend_path("LD_LIBRARY_PATH", spack.."/libtiff/4.6.0-gcc-11.4.1-y4zexwo/lib64", ":")
prepend_path("LD_LIBRARY_PATH", spack.."/bzip2/1.0.8-gcc-11.4.1-74lbk3j/lib", ":")
prepend_path("LD_LIBRARY_PATH", spack.."/netcdf-c/4.9.2-gcc-14.1.0-huzvs7j/lib", ":")
prepend_path("LD_LIBRARY_PATH", spack.."/hdf5/1.14.3-gcc-14.1.0-k2dbjbc/lib", ":")

-- webp (built from source, installed alongside R)
prepend_path("LD_LIBRARY_PATH", modroot.."/rlib/webp/lib", ":")

-- harfbuzz data
prepend_path("XDG_DATA_DIRS", spack.."/harfbuzz/9.0.0-gcc-11.4.1-j6pndui/share", ":")
prepend_path("GI_TYPELIB_PATH", spack.."/harfbuzz/9.0.0-gcc-11.4.1-j6pndui/lib/girepository-1.0", ":")

-- R environment
setenv("R_HOME", modroot.."/rlib/R")
setenv("RCAC_R_ROOT", modroot)
setenv("RCAC_R_VERSION", "4.5.2")
