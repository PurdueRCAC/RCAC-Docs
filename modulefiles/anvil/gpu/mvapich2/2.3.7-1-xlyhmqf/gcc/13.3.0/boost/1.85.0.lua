-- -*- lua -*---
-- boost@1.85.0%gcc@13.3.0+atomic~charconv~chrono~clanglibcpp~cobalt~container~context~contract~coroutine+date_time~debug+exception~fiber+filesystem+graph+graph_parallel+icu+iostreams+json+locale+log+math+mpi+multithreaded~nowide+numpy~pic+program_options+python+random+regex+serialization+shared+signals~singlethreaded~stacktrace+system~taggedlayout+test+thread+timer~type_erasure+url~versionedlayout~wave build_system=generic cxxstd=11 patches=a440f96,b8569d7 visibility=hidden arch=linux-rocky8-zen3/l5p6hh3
--

whatis([[Name : boost]])
whatis([[Version : 1.85.0]])
whatis([[Short description : Boost provides free peer-reviewed portable C++ source libraries, emphasizing libraries that work well with the C++ Standard Library.]])

help([[Boost provides free peer-reviewed portable C++ source libraries,
emphasizing libraries that work well with the C++ Standard Library.
Boost libraries are intended to be widely useful, and usable across a
broad spectrum of applications. The Boost license encourages both
commercial and non-commercial use.]])


depends_on("mvapich2/2.3.7-1")
depends_on("zlib/1.3.1-ummgjdr")

local modroot="/apps/spack/anvilgpu-2025/apps/boost/1.85.0-gcc-13.3.0-l5p6hh3"
prepend_path("LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("CPATH", modroot.."/include", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/.", ":")
setenv("BOOST_ROOT", modroot)
setenv("BOOST_HOME", modroot)
setenv("RCAC_BOOST_ROOT", modroot)
setenv("RCAC_BOOST_VERSION", modroot)
setenv("BOOST_ROOT", modroot)
setenv("BOOST_INCLUDE", "-I"..modroot.."/include")
setenv("LINK_BOOST", "-L"..modroot.."/lib -Xlinker -rpath -Xlinker "..modroot.."/lib")

