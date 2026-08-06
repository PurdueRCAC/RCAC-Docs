-- -*- lua -*---
-- r@4.4.1%gcc@13.3.0+X~memory_profiling~rmath build_system=autotools patches=abc572d arch=linux-rocky8-zen3/636opzq
--

whatis([[Name : r]])
whatis([[Version : 4.4.1]])
whatis([[Short description : R is 'GNU S', a freely available language and environment for statistical computing and graphics which provides a wide variety of statistical and graphical techniques: linear and nonlinear modelling, statistical tests, time series analysis, classification, clustering, etc. Please consult the R project homepage for further information.]])
whatis([[Configure options : --with-internal-tzcode --libdir=/apps/spack/anvilgpu-2025/apps/r/4.4.1-gcc-13.3.0-636opzq/rlib --enable-R-shlib --enable-R-framework=no --without-recommended-packages LDFLAGS=-Wl,-rpath,/apps/spack/anvilgpu-2025/apps/r/4.4.1-gcc-13.3.0-636opzq/rlib/R/lib --with-blas=-L/apps/spack/anvilgpu-2025/apps/openblas/0.3.27-gcc-13.3.0-ippvsqv/lib -lopenblas --with-lapack=-L/apps/spack/anvilgpu-2025/apps/openblas/0.3.27-gcc-13.3.0-ippvsqv/lib -lopenblas ac_cv_path_PDFLATEX= ac_cv_path_PDFTEX= ac_cv_path_TEX= ac_cv_path_TEXI2DVI= --with-cairo --with-jpeglib --with-libpng --with-libtiff --with-tcltk --with-x --with-tcl-config=/apps/spack/anvilgpu-2025/apps/tcl/8.6.12-gcc-13.3.0-oe2ubjv/lib/tclConfig.sh --with-tk-config=/apps/spack/anvilgpu-2025/apps/tk/8.6.11-gcc-13.3.0-cekcc47/lib/tkConfig.sh]])

help([[R is 'GNU S', a freely available language and environment for
statistical computing and graphics which provides a wide variety of
statistical and graphical techniques: linear and nonlinear modelling,
statistical tests, time series analysis, classification, clustering,
etc. Please consult the R project homepage for further information.]])


depends_on("curl/8.8.0-shtex55")
depends_on("libtiff/4.6.0-l7unpbl")
depends_on("openblas/0.3.27")
depends_on("tk/8.6.11-cekcc47")
depends_on("zlib/1.3.1-ummgjdr")

local modroot="/apps/spack/anvilgpu-2025/apps/r/4.4.1-gcc-13.3.0-636opzq"
prepend_path("PATH", modroot.."/bin", ":")
prepend_path("MANPATH", modroot.."/share/man", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/.", ":")
prepend_path("XDG_DATA_DIRS", "/apps/spack/anvilgpu-2025/apps/harfbuzz/9.0.0-gcc-13.3.0-nbttqae/share", ":")
prepend_path("GI_TYPELIB_PATH", "/apps/spack/anvilgpu-2025/apps/harfbuzz/9.0.0-gcc-13.3.0-nbttqae/lib/girepository-1.0", ":")
prepend_path("XLOCALEDIR", "/apps/spack/anvilgpu-2025/apps/libx11/1.8.10-gcc-13.3.0-dhnx72j/share/X11/locale", ":")
prepend_path("XDG_DATA_DIRS", "/apps/spack/anvilgpu-2025/apps/pango/1.52.2-gcc-13.3.0-kx24vdg/share", ":")
prepend_path("GI_TYPELIB_PATH", "/apps/spack/anvilgpu-2025/apps/pango/1.52.2-gcc-13.3.0-kx24vdg/lib/girepository-1.0", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/rlib/R/lib", ":")
prepend_path("PKG_CONFIG_PATH", modroot.."/rlib/pkgconfig", ":")
setenv("RCAC_R_ROOT", modroot)
setenv("RCAC_R_VERSION", modroot)
setenv("R_ROOT", modroot)


if (mode() == "load" ) then
    if os.getenv("OMP_NUM_THREADS") == nil then
        setenv("OMP_NUM_THREADS", "1")
    end
    if os.getenv("OPENBLAS_NUM_THREADS") == nil then
        setenv("OPENBLAS_NUM_THREADS", "1")
    end
end
