help([==[

Description
===========
The AutoDock Suite is a growing collection of methods for computational
docking and virtual screening, for use in structure-based drug discovery
and exploration of the basic mechanisms of biomolecular structure and
function.

]==])

whatis("Name: autodock")
whatis("Version: 2025.11")
whatis("Description: The AutoDock Suite is a growing collection of methods for computational docking and virtual screening, for use in structure-based drug discovery and exploration of the basic mechanisms of biomolecular structure and function. ")

local image = "/apps/custom_containers/autodock/autodock-gpu_2025.11.sif"
local programs = {"autodock_gpu_128wi"}
local entrypoint_args = ""

-- The absolute path to Singularity is needed so it can be invoked on remote
-- nodes without the corresponding module necessarily being loaded.
-- Trim off the training newline.
local singularity = capture("which singularity | head -c -1")

local container_launch = singularity .. " run --nv " .. image .. " " .. entrypoint_args

-- Programs to setup in the shell
for i,program in pairs(programs) do
        set_shell_function(program, container_launch .. " " .. program .. " \"$@\"",
	                            container_launch .. " " .. program .. " $*")
end
