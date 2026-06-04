-- The MIT License (MIT)
--
-- Copyright (c) 2021 Purdue University
-- Copyright (c) 2020 NVIDIA Corporation
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

help([==[

Description
===========
OpenMM is a high-performance toolkit for molecular simulation. It can be used
as an application, a library, or a flexible programming environment.  OpenMM
includes extensive language bindings for Python, C, C++, and even Fortran.
The code is open source and developed on GitHub, licensed under MIT and LGPL.

This module defines program installation directory (note: inside the
container!) as environment variable $OPENMM_PATH.  Once again, this is not
a host path, this path is only available from inside the container.  Most
likely you will not need it for production simulations, but it might be
occasionally needed for benchmarks or access to container innards.  With
the way this module is organized, you should be able to use this variable
freely with containerized commands like
      python3 $OPENMM_PATH/examples/benchmarks.py --help

More information
================
 - Home page:  https://openmm.org
 - Docker:     https://www.amd.com/en/technologies/infinity-hub/openmm
]==])

whatis("Name: Openmm")
whatis("Version: 7.6.0")
whatis("Description: OpenMM is a high-performance toolkit for molecular simulation. It can be used as an application, a library, or a flexible programming environment.  OpenMM includes extensive language bindings for Python, C, C++, and even Fortran.  The code is open source and developed on GitHub, licensed under MIT and LGPL.")
whatis("Home page:   https://openmm.org")
whatis("Docker:      https://www.amd.com/en/technologies/infinity-hub/openmm")

if not (os.getenv("ROCM_SINGULARITY_MODULE") == "none") then
   local singularity_module = os.getenv("ROCM_SINGULARITY_MODULE") or "Singularity"
   if not (isloaded(singularity_module)) then
      load(singularity_module)
   end
end

-- Need to alias Python interpreter and set conflicts with all Python-y things.
conflict("biopython", "anaconda", "python",
         "deepspeed", "openmm", "pytorch", "tensorflow")

local image = "amdih_openmm:7.6.0.sif"
local uri = "docker://amdih/openmm:7.6.0"
local programs = {"python", "python3", "python3.8", "python2", "python2.7",
                  "run-benchmarks",
                 }
local entrypoint_args = ""

-- The absolute path to Singularity is needed so it can be invoked on remote
-- nodes without the corresponding module necessarily being loaded.
-- Trim off the trailing newline.
local singularity = capture("which singularity | head -c -1")

if (os.getenv("ROCM_IMAGE_DIR")) then
   image = pathJoin(os.getenv("ROCM_IMAGE_DIR"), image)

   if not (isFile(image)) then
      -- The image could not be found in the container directory
      if (mode() == "load") then
         LmodMessage("file not found: " .. image)
         LmodMessage("The container image will be pulled upon first use to the Singularity cache")
      end
      image = uri

      -- Alternatively, this could pull the container image and
      -- save it in the container directory
      --if (mode() == "load") then
      --   subprocess(singularity .. " pull " .. image .. " " .. uri)
      --end
   end
else
   -- Look for the image in the Singularity cache, and if not found
   -- download it when "singularity run" is invoked.
   image = uri
end

-- Determine Nvidia and/or AMD GPUs (to pass coresponding flag to Singularity)
local run_args = {}
if (capture("nvidia-smi -L 2>/dev/null") ~= "") then
   if (mode() == "load") then
      LmodMessage("ROCM_CONTAINER: Enabling Nvidia GPU support in the container.")
   end
   table.insert(run_args, "--nv")
end
if (capture("/opt/rocm/bin/rocm-smi -i 2>/dev/null | grep ^GPU") ~= "") then
   if (mode() == "load") then
      LmodMessage("ROCM_CONTAINER: Enabling AMD GPU support in the container.")
   end
   table.insert(run_args, "--rocm")
end

-- And assemble container command
local container_launch = singularity .. " run " .. table.concat(run_args, " ") .. " " .. image .. " " .. entrypoint_args

-- Programs to setup in the shell
for i,program in pairs(programs) do
    set_shell_function(program, container_launch .. " " .. program .. " \"$@\"",
                                container_launch .. " " .. program .. " $*")
end

-- Additional commands or environment variables, if any
-- Note: this is inside the container.
pushenv("OPENMM_PATH", "/opt/openmm")
