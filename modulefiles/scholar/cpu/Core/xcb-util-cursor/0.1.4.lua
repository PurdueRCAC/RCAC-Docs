-- -*- lua -*-
-- Module file created by spack (https://github.com/spack/spack) on 2026-08-18 10:42:18.924292
--
-- xcb-util-cursor@0.1.4%gcc@11.4.1 build_system=autotools arch=linux-rocky9-x86_64_v3/66e4bg6
--

whatis([[Name : xcb-util-cursor]])
whatis([[Version : 0.1.4]])
whatis([[Target : x86_64_v3]])
whatis([[Short description : The XCB util modules provides a number of libraries which sit on top of libxcb, the core X protocol library, and some of the extension libraries. These experimental libraries provide convenience functions and interfaces which make the raw X protocol more usable. Some of the libraries also provide client-side code which is not strictly part of the X protocol but which have traditionally been provided by Xlib.]])

help([[Name   : xcb-util-cursor]])
help([[Version: 0.1.4]])
help([[Target : x86_64_v3]])
help()
help([[The XCB util modules provides a number of libraries which sit on top of
libxcb, the core X protocol library, and some of the extension
libraries. These experimental libraries provide convenience functions
and interfaces which make the raw X protocol more usable. Some of the
libraries also provide client-side code which is not strictly part of
the X protocol but which have traditionally been provided by Xlib.]])


depends_on("gcc-runtime/11.4.1")
depends_on("xcb-util-image/0.4.1")
depends_on("xcb-util-renderutil/0.3.10")

prepend_path("LIBRARY_PATH", "/apps/spack/scholar-all/apps/xcb-util-cursor/0.1.4-gcc-11.4.1-66e4bg6/lib", ":")
prepend_path("LD_LIBRARY_PATH", "/apps/spack/scholar-all/apps/xcb-util-cursor/0.1.4-gcc-11.4.1-66e4bg6/lib", ":")
prepend_path("CPATH", "/apps/spack/scholar-all/apps/xcb-util-cursor/0.1.4-gcc-11.4.1-66e4bg6/include", ":")
prepend_path("PKG_CONFIG_PATH", "/apps/spack/scholar-all/apps/xcb-util-cursor/0.1.4-gcc-11.4.1-66e4bg6/lib/pkgconfig", ":")
prepend_path("CMAKE_PREFIX_PATH", "/apps/spack/scholar-all/apps/xcb-util-cursor/0.1.4-gcc-11.4.1-66e4bg6/.", ":")
setenv("XCB_UTIL_CURSOR_HOME", "/apps/spack/scholar-all/apps/xcb-util-cursor/0.1.4-gcc-11.4.1-66e4bg6")
setenv("RCAC_XCB_UTIL_CURSOR_ROOT", "/apps/spack/scholar-all/apps/xcb-util-cursor/0.1.4-gcc-11.4.1-66e4bg6")
setenv("RCAC_XCB_UTIL_CURSOR_VERSION", "/apps/spack/scholar-all/apps/xcb-util-cursor/0.1.4-gcc-11.4.1-66e4bg6")

