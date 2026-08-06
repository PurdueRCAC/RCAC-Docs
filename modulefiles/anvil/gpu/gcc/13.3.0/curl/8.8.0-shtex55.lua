-- -*- lua -*---
-- curl@8.8.0%gcc@13.3.0~gssapi~ldap+libidn2~librtmp~libssh~libssh2+nghttp2 build_system=autotools libs=shared,static tls=openssl arch=linux-rocky8-zen3/shtex55
--

whatis([[Name : curl]])
whatis([[Version : 8.8.0]])
whatis([[Short description : cURL is an open source command line tool and library for transferring data with URL syntax]])

help([[cURL is an open source command line tool and library for transferring
data with URL syntax]])


depends_on("zlib/1.3.1-ummgjdr")

local modroot="/apps/spack/anvilgpu-2025/apps/curl/8.8.0-gcc-13.3.0-shtex55"
prepend_path("PATH", modroot.."/bin", ":")
prepend_path("LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("CPATH", modroot.."/include", ":")
prepend_path("MANPATH", modroot.."/share/man", ":")
prepend_path("ACLOCAL_PATH", modroot.."/share/aclocal", ":")
prepend_path("PKG_CONFIG_PATH", modroot.."/lib/pkgconfig", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/.", ":")
setenv("CURL_HOME", modroot)
setenv("RCAC_CURL_ROOT", modroot)
setenv("RCAC_CURL_VERSION", modroot)

