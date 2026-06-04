-- The MIT License (MIT)
--
-- Copyright (c) 2021 NVIDIA Corporation
-- Copyright (c) 2021 Purdue University
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to
-- deal in the Software without restriction, including without limitation the
-- rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
-- sell copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
-- IN THE SOFTWARE.

local ver      = "5.9.0"
local shortver = "5.9"
help([==[

Description
===========
ParaView is an open-source, multi-platform data analysis and visualization
application. This ParaView container is enabled with the NVIDIA IndeX plugin
and the OptiX ray-tracing backend.  It can be used in tandem with an official
ParaView ]==] .. ver .. [==[ client or standalone as ParaView Web.

Note: no ParaView client GUI in this container.  However, ParaView Web
      Visualizer app is included for a ParaView-like experience inside
      a web browser.  You can start ParaView Web with a 'pvweb' command
      and point your browser to proper http://HOST:PORT/
      Default port is 8080 ('--port NNNN' to change, '--help' for help).

More information
================
 - NGC: https://ngc.nvidia.com/catalog/containers/nvidia-hpcvis:paraview
]==])

whatis("Name: ParaView")
whatis("Version: " .. ver)
whatis("Description: ParaView is an open-source, multi-platform data analysis and visualization application. This ParaView container is enabled with the NVIDIA IndeX plugin and the OptiX ray-tracing backend.  It can be used in tandem with an official ParaView " .. ver .. " client or standalone as ParaView Web.  Note: no ParaView client GUI in this container, but ParaView Web application is included.")
whatis("URL: https://ngc.nvidia.com/catalog/containers/nvidia-hpcvis:paraview")

if not (os.getenv("NGC_SINGULARITY_MODULE") == "none") then
	local singularity_module = os.getenv("NGC_SINGULARITY_MODULE") or "Singularity"
	if not (isloaded(singularity_module)) then
		load(singularity_module)
	end
end

conflict(myModuleName(), "openmpi", "chroma", "lammps", "milc", "qmcpack", "quantum-espresso", "relion")

local image = "nvcr.io_nvidia-hpcvis_paraview:egl-py3-" .. ver .. ".sif"
local uri = "docker://nvcr.io/nvidia-hpcvis/paraview:egl-py3-" .. ver
local programs = {"pvserver", "pvbatch", "pvpython",
                  "pvdataserver", "pvrenderserver", "mpirun"}
local entrypoint_args = ""

-- The absolute path to Singularity is needed so it can be invoked on remote
-- nodes without the corresponding module necessarily being loaded.
-- Trim off the training newline.
local singularity = capture("which singularity | head -c -1")

if (os.getenv("NGC_IMAGE_DIR") and mode() == "load") then
	image = pathJoin(os.getenv("NGC_IMAGE_DIR"), image)

	if not (isFile(image)) then
		-- The image could not be found in the container directory
		LmodMessage("file not found: " .. image)
		LmodMessage("The container image will be pulled upon first use to the Singularity cache")
		image = uri

		-- Alternatively, this could pull the container image and
		-- save it in the container directory
		--subprocess(singularity .. " pull " .. image .. " " .. uri)
	end
else
	-- Look for the image in the Singularity cache, and if not found
	-- download it when "singularity run" is invoked.
	image = uri
end

local container_launch = singularity .. " run --nv " .. image .. " " .. entrypoint_args

-- Multinode support
setenv("OMPI_MCA_orte_launch_agent", container_launch .. " orted")

-- Programs to setup in the shell
for i,program in pairs(programs) do
        set_shell_function(program, container_launch .. " " .. program .. " \"$@\"",
	                            container_launch .. " " .. program .. " $*")
end

-- Extra settings.

-- Somehow, in the 5.9.0 container the /opt/paraview/bin is not in PATH (Waat?)
prepend_path("SINGULARITYENV_PREPEND_PATH", "/opt/paraview/bin")

-- There is no ParaView GUI client in this container (to minimize image size),
-- but it supports ParaView Web mode.  Let's define it as 'pvweb' alias.
local webcmd = "pvpython" .. " "
                  .. pathJoin("/opt/paraview/share", "paraview-"..shortver, "web/visualizer/server/pvw-visualizer.py") .. " "
                  .. "--content" .. " " .. pathJoin("/opt/paraview/share", "paraview-"..shortver, "web/visualizer/www/")
set_shell_function("pvweb", container_launch .. " " .. webcmd .. " \"$@\"",
                            container_launch .. " " .. webcmd .. " $*")
