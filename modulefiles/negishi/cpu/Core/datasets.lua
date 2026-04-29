local app = "datasets"
local version = "null"
local contact = "hkashgar"
local license_type = "null	"

whatis("This module enables a collection of datasets.")

help([[
        datasets - Load this first to make dataset modules available.
]])

-- All set
prepend_path("MODULEPATH", "/opt/spack/datasets")
pushenv("DATASETS_DIR","/depot/datasets")

-- This if statement makes sure to display the message only during module loading
if (mode() == "load") then
  LmodMessage("                    Welcome to RCAC datasets!                       ")
  LmodMessage("---------------------------------------------------------------------")
  LmodMessage("Use command 'module avail' to check all available dataset modules.")
  LmodMessage("Use command 'module spider xxx' to query dataset modules.")
  LmodMessage("e.g. module spider nasa")
  LmodMessage("Use command 'module help xxx' to check instructions on dataset usage.")
  LmodMessage("e.g. module help igenomes/AGPv3/2023-04-26")
end
