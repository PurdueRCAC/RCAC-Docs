-- uv through the uv-manager wrapper: https://github.com/PurdueRCAC/uv-manager
-- Every path this file exports is architecture-neutral; the wrapper adds the
-- architecture at exec time, on the node that runs it. Never set UV_*_DIR here.

local appname = "uv"
local version = "0.8.0"
local appsdir = "/apps/external/apps"
local modroot = pathJoin(appsdir, appname, version)

whatis("Name: uv")
whatis("Version: " .. version)
whatis([[Description:
The uv Python package and project manager, through the uv-manager wrapper:
your own uv, with its cache, tools and Pythons on scratch, and only small
records of installed tools in home.]])
whatis("URL: https://github.com/PurdueRCAC/uv-manager")

help([[
Use uv and uvx as usual. The first call on each CPU architecture installs your
own copy of uv. The uv binary, its cache, tool environments and uv-managed
Pythons live under $UVM_ROOT (default $SCRATCH/.uv). The only thing kept in
your home directory is a record of each tool you install with 'uv tool
install', a few KB apiece, under $UVM_DATA (default ~/.local/share/uvm).

  uv-manager status    show where everything is
  uv-manager doctor    check for files lost to the scratch purge
  uv-manager help      all wrapper commands ('uvm' for short)

Scratch is purged. This module sets UVM_REPAIR=1, so in a Slurm job the first
uv or uvx call, or the first call of an installed tool by its own name,
repairs what the purge took, once per job, before the command runs: a managed
Python, an installed tool (restored from its record), and the environments
'uv run <script>' and 'uvx' run from uv's cache. To opt out, export
UVM_REPAIR=0. Outside a job, run 'uv-manager doctor' when something that used
to work stops importing.

Upgrading from uv/0.7.0: run 'uv-manager doctor' once. It writes a record for
each tool you installed before, so a purged tool can be restored.

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

-- A UVM_ROOT, UVM_DATA, UVM_REPAIR or UV_LINK_MODE the user exported wins, and pushenv
-- puts the user's value back on unload.
local scratch = os.getenv("CLUSTER_SCRATCH") or os.getenv("RCAC_SCRATCH") or os.getenv("SCRATCH")
local uvm_root = os.getenv("UVM_ROOT")
if (uvm_root == nil or uvm_root == "") and scratch ~= nil and scratch ~= "" then
    uvm_root = pathJoin(scratch, ".uv")
end
if uvm_root ~= nil and uvm_root ~= "" then
    pushenv("UVM_ROOT", uvm_root)
    prepend_path("PATH", pathJoin(uvm_root, "bin"))  -- this root's trampolines: managed Pythons, unrecorded tools
end

-- Records of installed tools, a few KB each, kept off scratch; they name no
-- architecture. $UVM_DATA/bin holds the recorded tools' trampolines and is
-- prepended after the entry above, so it comes first on PATH.
local uvm_data = os.getenv("UVM_DATA")
if uvm_data == nil or uvm_data == "" then
    local data_home = os.getenv("XDG_DATA_HOME")
    if (data_home == nil or data_home == "") and os.getenv("HOME") ~= nil then
        data_home = pathJoin(os.getenv("HOME"), ".local/share")
    end
    if data_home ~= nil and data_home ~= "" then
        uvm_data = pathJoin(data_home, "uvm")
    end
end
if uvm_data ~= nil and uvm_data ~= "" then
    pushenv("UVM_DATA", uvm_data)
    prepend_path("PATH", pathJoin(uvm_data, "bin"))
end

pushenv("UVM_REPAIR", os.getenv("UVM_REPAIR") or "1")
pushenv("UV_LINK_MODE", os.getenv("UV_LINK_MODE") or "copy")  -- cache on scratch, venvs usually elsewhere
pushenv("UV_PYTHON_PREFERENCE", os.getenv("UV_PYTHON_PREFERENCE") or "only-managed")  -- el8 /usr/bin/python3 is 3.6
