-- -*- lua -*---
-- python@3.11.9%gcc@13.3.0+bz2+crypt+ctypes+dbm~debug+libxml2+lzma~nis+optimizations+pic+pyexpat+pythoncmd+readline+shared+sqlite3+ssl~tkinter+uuid+zlib build_system=generic patches=13fa8bf,b0615b2,ebdca64,f2fd060 arch=linux-rocky8-zen3/n3ttrlf
--

whatis([[Name : python]])
whatis([[Version : 3.11.9]])
whatis([[Short description : The Python programming language.]])
whatis([[Configure options : CPPFLAGS=-I/apps/spack/anvilgpu-2025/apps/bzip2/1.0.8-gcc-13.3.0-fpv42e4/include -I/apps/spack/anvilgpu-2025/apps/expat/2.6.3-gcc-13.3.0-bdib3fe/include -I/apps/spack/anvilgpu-2025/apps/gcc-runtime/13.3.0-gcc-13.3.0-mvpokg4/include -I/apps/spack/anvilgpu-2025/apps/gdbm/1.23-gcc-13.3.0-dqhxs4n/include -I/apps/spack/anvilgpu-2025/apps/gettext/0.22.5-gcc-13.3.0-cnokaed/include -I/usr/include -I/apps/spack/anvilgpu-2025/apps/libffi/3.4.6-gcc-13.3.0-lb4hxgd/include -I/apps/spack/anvilgpu-2025/apps/libxcrypt/4.4.35-gcc-13.3.0-m2b2vym/include -I/apps/spack/anvilgpu-2025/apps/ncurses/6.5-gcc-13.3.0-4zuui5u/include -I/usr/include -I/apps/spack/anvilgpu-2025/apps/readline/8.2-gcc-13.3.0-qp2ue3f/include -I/apps/spack/anvilgpu-2025/apps/sqlite/3.46.0-gcc-13.3.0-emona5w/include -I/apps/spack/anvilgpu-2025/apps/util-linux-uuid/2.40.2-gcc-13.3.0-vhrua5v/include -I/apps/spack/anvilgpu-2025/apps/xz/5.4.6-gcc-13.3.0-5dylmei/include -I/apps/spack/anvilgpu-2025/apps/zlib/1.3.1-gcc-13.3.0-ummgjdr/include LDFLAGS=-L/apps/spack/anvilgpu-2025/apps/bzip2/1.0.8-gcc-13.3.0-fpv42e4/lib -L/apps/spack/anvilgpu-2025/apps/expat/2.6.3-gcc-13.3.0-bdib3fe/lib  -L/apps/spack/anvilgpu-2025/apps/gdbm/1.23-gcc-13.3.0-dqhxs4n/lib -L/apps/spack/anvilgpu-2025/apps/gettext/0.22.5-gcc-13.3.0-cnokaed/lib  -L/apps/spack/anvilgpu-2025/apps/libffi/3.4.6-gcc-13.3.0-lb4hxgd/lib64 -L/apps/spack/anvilgpu-2025/apps/libxcrypt/4.4.35-gcc-13.3.0-m2b2vym/lib -L/apps/spack/anvilgpu-2025/apps/ncurses/6.5-gcc-13.3.0-4zuui5u/lib -L/usr/lib64 -L/apps/spack/anvilgpu-2025/apps/readline/8.2-gcc-13.3.0-qp2ue3f/lib -L/apps/spack/anvilgpu-2025/apps/sqlite/3.46.0-gcc-13.3.0-emona5w/lib -L/apps/spack/anvilgpu-2025/apps/util-linux-uuid/2.40.2-gcc-13.3.0-vhrua5v/lib -L/apps/spack/anvilgpu-2025/apps/xz/5.4.6-gcc-13.3.0-5dylmei/lib -L/apps/spack/anvilgpu-2025/apps/zlib/1.3.1-gcc-13.3.0-ummgjdr/lib --enable-optimizations --with-lto --with-computed-gotos --without-pydebug --enable-shared --without-ensurepip --with-openssl=/usr --with-dbmliborder=gdbm --with-system-expat --with-system-ffi --enable-loadable-sqlite-extensions CFLAGS=-fPIC]])

help([[The Python programming language.]])


depends_on("sqlite/3.46.0-emona5w")
depends_on("zlib/1.3.1-ummgjdr")

local modroot="/apps/spack/anvilgpu-2025/apps/python/3.11.9-gcc-13.3.0-n3ttrlf"
prepend_path("PATH", modroot.."/bin", ":")
prepend_path("LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("CPATH", modroot.."/include", ":")
prepend_path("MANPATH", modroot.."/share/man", ":")
prepend_path("PKG_CONFIG_PATH", modroot.."/lib/pkgconfig", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/.", ":")
setenv("PYTHON_HOME", modroot)
setenv("RCAC_PYTHON_ROOT", modroot)
setenv("RCAC_PYTHON_VERSION", modroot)

