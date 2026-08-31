local app = "prime"
local version = "Y-2026.03-SP1"
local modroot = pathJoin("/apps/external/synopsys", app, version)

whatis("invoke " .. app .. " " .. version)

local err_message="\nWARNING: Access to this software is restricted. For more information, see https://engineering.purdue.edu/ECEIL/Lab_Support/EDA/\n"
local found = required_group("cae2")
if (not found and mode() == "load") then
    LmodError(err_message)
end

depends_on("libxscrnsaver")
depends_on("mesa-glu")

setenv("STROOT",modroot)
setenv("LM_LICENSE_FILE","1718@marina.ecn.purdue.edu")

prepend_path("PATH",modroot.."/bin")
