--/sas/9.4.lua
local version   = "9.4"
local sas_root  = "/apps/external/sas/" .. version
local sas_found = pathJoin(sas_root, "SASFoundation", version)

whatis('Name: SAS')
whatis('Version: ' .. version)
whatis('Description: Statistical Analysis Software')


-- SAS needs its own shared-libs visible
prepend_path("LD_LIBRARY_PATH", pathJoin(sas_found, "sasexe"))
prepend_path("PATH", sas_found)
setenv("SASROOT", sas_found)
setenv("SAS_HOME", sas_root)