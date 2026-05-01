local app = "quantumatk"
local version = "2026.03"
local versiondir = "Y-2026.03"
local modroot = pathJoin("/apps/external/", app, versiondir)

whatis("Invoke QuantumATK " .. version)

local err_message="\nWARNING: Access to this software is restricted. For more information, see https://engineering.purdue.edu/ECEIL/Lab_Support/EDA/\n"
local found = required_group("quantumatk")
if (not found and mode() == "load") then
    LmodError(err_message)
end

-- On Negishi and later clusters (with lean node image)
depends_on("mesa-glu")
depends_on("libxdmcp/1.1.5-cgdwkbn")
setenv("QATKROOT",modroot)
setenv("LM_LICENSE_FILE","1718@marina.ecn.purdue.edu")

prepend_path("PATH",modroot.."/bin")

