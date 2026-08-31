-- -*- lua -*---
-- tk@8.6.11%gcc@13.3.0+xft+xss build_system=autotools arch=linux-rocky8-zen3/cekcc47
--

whatis([[Name : tk]])
whatis([[Version : 8.6.11]])
whatis([[Short description : Tk is a graphical user interface toolkit that takes developing desktop applications to a higher level than conventional approaches. Tk is the standard GUI not only for Tcl, but for many other dynamic languages, and can produce rich, native applications that run unchanged across Windows, Mac OS X, Linux and more.]])
whatis([[Configure options : --with-tcl=/apps/spack/anvilgpu-2025/apps/tcl/8.6.12-gcc-13.3.0-oe2ubjv/lib --x-includes=/apps/spack/anvilgpu-2025/apps/libx11/1.8.10-gcc-13.3.0-dhnx72j/include --x-libraries=/apps/spack/anvilgpu-2025/apps/libx11/1.8.10-gcc-13.3.0-dhnx72j/lib --enable-xft --enable-xss]])

help([[Tk is a graphical user interface toolkit that takes developing desktop
applications to a higher level than conventional approaches. Tk is the
standard GUI not only for Tcl, but for many other dynamic languages, and
can produce rich, native applications that run unchanged across Windows,
Mac OS X, Linux and more.]])


depends_on("tcl/8.6.12-oe2ubjv")

local modroot="/apps/spack/anvilgpu-2025/apps/tk/8.6.11-gcc-13.3.0-cekcc47"
prepend_path("PATH", modroot.."/bin", ":")
prepend_path("LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("CPATH", modroot.."/include", ":")
prepend_path("MANPATH", modroot.."/man", ":")
prepend_path("PKG_CONFIG_PATH", modroot.."/lib/pkgconfig", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/.", ":")
prepend_path("XLOCALEDIR", "/apps/spack/anvilgpu-2025/apps/libx11/1.8.10-gcc-13.3.0-dhnx72j/share/X11/locale", ":")
prepend_path("TCLLIBPATH", modroot.."/lib", " ")
setenv("TK_LIBRARY", modroot.."/lib/tk8.6")
setenv("TK_HOME", modroot)
setenv("RCAC_TK_ROOT", modroot)
setenv("RCAC_TK_VERSION", modroot)

