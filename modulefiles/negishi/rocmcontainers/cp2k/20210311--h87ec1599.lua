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
CP2K is a quantum chemistry and solid state physics software package that
can perform atomistic simulations of solid state, liquid, molecular,
periodic, material, crystal, and biological systems. CP2K provides a
general framework for different modeling methods such as DFT using the
mixed Gaussian and plane waves approaches GPW and GAPW. Supported theory
levels include DFTB, LDA, GGA, MP2, RPA, semi-empirical methods (AM1, PM3,
PM6, RM1, MNDO, ...), and classical force fields (AMBER, CHARMM, ...).
CP2K can do simulations of molecular dynamics, metadynamics, Monte Carlo,
Ehrenfest dynamics, vibrational analysis, core level spectroscopy, energy
minimization, and transition state optimization using NEB or dimer method.
CP2K is written in Fortran 2008 and can be run efficiently in parallel
using a combination of multi-threading, MPI, and HIP/CUDA.

More information
================
 - Home page:  http://www.cp2k.org/
 - Docker:     https://www.amd.com/en/technologies/infinity-hub/cp2k
]==])

whatis("Name: CP2K")
whatis("Version: 20210311--h87ec1599")
whatis("Description: CP2K is a quantum chemistry and solid state physics software package that can perform atomistic simulations of solid state, liquid, molecular, periodic, material, crystal, and biological systems. CP2K provides a general framework for different modeling methods such as DFT using the mixed Gaussian and plane waves approaches GPW and GAPW. Supported theory levels include DFTB, LDA, GGA, MP2, RPA, semi-empirical methods (AM1, PM3, PM6, RM1, MNDO, ...), and classical force fields (AMBER, CHARMM, ...).  CP2K can do simulations of molecular dynamics, metadynamics, Monte Carlo, Ehrenfest dynamics, vibrational analysis, core level spectroscopy, energy minimization, and transition state optimization using NEB or dimer method.  CP2K is written in Fortran 2008 and can be run efficiently in parallel using a combination of multi-threading, MPI, and HIP/CUDA.")
whatis("Home page:   http://www.cp2k.org/")
whatis("Docker:      https://www.amd.com/en/technologies/infinity-hub/cp2k")

if not (os.getenv("ROCM_SINGULARITY_MODULE") == "none") then
   local singularity_module = os.getenv("ROCM_SINGULARITY_MODULE") or "Singularity"
   if not (isloaded(singularity_module)) then
      load(singularity_module)
   end
end

conflict(myModuleName(), "openmpi")

local image = "amdih_cp2k:87ec1599.sif"
local uri = "docker://amdih/cp2k:87ec1599"
local programs = {"cp2k.psmp", "cp2k.popt", "cp2k_shell.psmp", "dumpdcd.psmp",
                  "graph.psmp", "grid_miniapp.psmp", "xyz2dcd.psmp",
                  "benchmark",
                  "mpirun", "mpiexec", "ompi_info",
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

-- Multinode support
pushenv("OMPI_MCA_orte_launch_agent", container_launch .. " orted")

-- Programs to setup in the shell
for i,program in pairs(programs) do
    set_shell_function(program, container_launch .. " " .. program .. " \"$@\"",
                                container_launch .. " " .. program .. " $*")
end

-- Additional commands or environment variables, if any
-- Somehow CP2K's bin directory is not in container's default PATH.
-- And neither is OpenMPI.
prepend_path("SINGULARITYENV_PREPEND_PATH", "/opt/cp2k/bin")
prepend_path("APPTAINERENV_PREPEND_PATH", "/opt/cp2k/bin")
prepend_path("SINGULARITYENV_PREPEND_PATH", "/opt/cp2k/benchmark-scripts")
prepend_path("APPTAINERENV_PREPEND_PATH", "/opt/cp2k/benchmark-scripts")
prepend_path("SINGULARITYENV_PREPEND_PATH", "/opt/ompi/bin")
prepend_path("APPTAINERENV_PREPEND_PATH", "/opt/ompi/bin")
