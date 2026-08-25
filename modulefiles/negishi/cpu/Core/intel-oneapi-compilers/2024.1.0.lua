-- -*- lua -*---
-- 

whatis([[Name : intel-oneapi-compilers]])
whatis([[Version : 2024.1.0]])
whatis([[Short description : Intel oneAPI Compilers. Includes: icc, icpc, ifort, icx, icpx, ifx, and dpcpp.]])

help([[Intel oneAPI Compilers. Includes: icc, icpc, ifort, icx, icpx, ifx, and
dpcpp. LICENSE INFORMATION: By downloading and using this software, you
agree to the terms and conditions of the software license agreements at
https://intel.ly/393CijO.]])

-- Services provided by the package
family("compiler")

-- Loading this module unlocks the path below unconditionally
prepend_path("MODULEPATH", "/opt/spack/cpu/oneapi/2023.0.0")



local modroot="/apps/external/apps/intel/oneapi/2024.1"
local comproot="/apps/external/apps/intel/oneapi/compiler/2024.1"
prepend_path("LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/./", ":")
setenv("CMPLR_ROOT", comproot)
prepend_path("DIAGUTIL_PATH", comproot.."/sys_check/sys_check.sh", ":")
prepend_path("NLSPATH", comproot.."/lib/compiler/locale/%l_%t/%N", ":")
prepend_path("PKG_CONFIG_PATH", comproot.."/lib/pkgconfig", ":")
prepend_path("PATH", comproot.."/bin", ":")
setenv("CC", comproot.."/bin/icx")
setenv("CXX", comproot.."/bin/icpx")
setenv("F77", comproot.."/bin/ifx")
setenv("FC", comproot.."/bin/ifx")
setenv("INTEL_ONEAPI_COMPILERS_HOME", modroot)
setenv("RCAC_INTEL_ONEAPI_COMPILERS_ROOT", modroot)
setenv("RCAC_INTEL_ONEAPI_COMPILERS_VERSION", "2024.1.0")

