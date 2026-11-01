-- uv through the uv-manager wrapper: https://github.com/PurdueRCAC/uv-manager
-- Every path this file exports is architecture-neutral; the wrapper adds the
-- architecture at exec time, on the node that runs it. Never set UV_*_DIR here.

local appname = "uv"
local version = "0.7.0"
local appsdir = "/apps/external/apps"
local modroot = pathJoin(appsdir, appname, version)

whatis("Name: uv")
whatis("Version: " .. version)
whatis([[Description:
The uv Python package and project manager, through the uv-manager wrapper:
your own uv, with its cache, tools and Pythons on scratch, not in home.]])
whatis("URL: https://github.com/PurdueRCAC/uv-manager")

help([[
Use uv and uvx as usual. The first call on each CPU architecture installs your
own copy of uv. The uv binary, its cache, tool environments and uv-managed
Pythons live under $UVM_ROOT (default $SCRATCH/.uv), not in your home directory.

  uv-manager status    show where everything is
  uv-manager doctor    check for files lost to the scratch purge
  uv-manager help      all wrapper commands ('uvm' for short)

Scratch is purged. This module sets UVM_REPAIR=1, so in a Slurm job the first
uv or uvx call repairs a purged tool environment or managed Python, once per
job, before the command runs. To opt out, export UVM_REPAIR=0. Outside a job,
run 'uv-manager doctor' when something that used to work stops importing.

By default uv uses only the Pythons it installs itself (this module sets
UV_PYTHON_PREFERENCE=only-managed), never an old system Python by accident.
To use another, such as the conda module's, pass --python <path>.

Documentation: https://github.com/PurdueRCAC/uv-manager
]])

if mode() == "load" and not isDir(pathJoin(modroot, "bin")) then
    LmodError("uv/" .. version .. ": not found at " .. modroot .. "\n")
end

setenv("RCAC_UV_ROOT", modroot)
setenv("RCAC_UV_VERSION", version)
prepend_path("PATH", pathJoin(modroot, "bin"))

-- A UVM_ROOT, UVM_REPAIR or UV_LINK_MODE the user exported wins, and pushenv
-- puts the user's value back on unload.
local scratch = os.getenv("CLUSTER_SCRATCH") or os.getenv("RCAC_SCRATCH") or os.getenv("SCRATCH")
local uvm_root = os.getenv("UVM_ROOT")
if (uvm_root == nil or uvm_root == "") and scratch ~= nil and scratch ~= "" then
    uvm_root = pathJoin(scratch, ".uv")
end
if uvm_root ~= nil and uvm_root ~= "" then
    pushenv("UVM_ROOT", uvm_root)
    prepend_path("PATH", pathJoin(uvm_root, "bin"))  -- architecture-neutral trampolines
end

pushenv("UVM_REPAIR", os.getenv("UVM_REPAIR") or "1")
pushenv("UV_LINK_MODE", os.getenv("UV_LINK_MODE") or "copy")  -- cache on scratch, venvs usually elsewhere
pushenv("UV_PYTHON_PREFERENCE", os.getenv("UV_PYTHON_PREFERENCE") or "only-managed")  -- el8 /usr/bin/python3 is 3.6
