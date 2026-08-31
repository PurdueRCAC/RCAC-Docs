-- -*- lua -*---
-- libxml2@2.10.3%gcc@8.5.0+pic~python+shared build_system=autotools arch=linux-rocky8-zen/rwvkf5e
--

whatis([[Name : libxml2]])
whatis([[Version : 2.10.3]])
whatis([[Short description : Libxml2 is the XML C parser and toolkit developed for the Gnome project (but usable outside of the Gnome platform), it is free software available under the MIT License.]])

help([[Libxml2 is the XML C parser and toolkit developed for the Gnome project
(but usable outside of the Gnome platform), it is free software
available under the MIT License.]])


depends_on("libiconv/1.17-haakotd")
depends_on("zlib/1.3.1-z54tklg")

local modroot="/apps/spack/anvilgpu-2025/apps/libxml2/2.10.3-gcc-8.5.0-rwvkf5e"
prepend_path("PATH", modroot.."/bin", ":")
prepend_path("LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("CPATH", modroot.."/include", ":")
prepend_path("MANPATH", modroot.."/share/man", ":")
prepend_path("ACLOCAL_PATH", modroot.."/share/aclocal", ":")
prepend_path("PKG_CONFIG_PATH", modroot.."/lib/pkgconfig", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/.", ":")
setenv("LIBXML2_HOME", modroot)
setenv("RCAC_LIBXML2_ROOT", modroot)
setenv("RCAC_LIBXML2_VERSION", modroot)

