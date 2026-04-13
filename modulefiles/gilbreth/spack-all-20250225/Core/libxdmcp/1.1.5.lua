whatis([[Name : libxdmcp]])
whatis([[Version : 1.1.5]])
whatis([[Short description : XDisplayManagerControlProtcol library]])

help([[Name   : libxdmcp]])
help([[Version: 1.1.5]])
help()
help([[LibXdmcp : X11 Display Manager Control Protcol library]])


local modroot = "/apps/spack/gilbreth-r9/apps/libxdmcp/1.1.5-gcc-11.5.0-3l5kirs/"
prepend_path("LIBRARY_PATH", modroot.."/lib")
prepend_path("LD_LIBRARY_PATH", modroot.."/lib")
prepend_path("CPATH", modroot.."/include")

