-- The MIT License (MIT)
--
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
Large-scale Atomic/Molecular Massively Parallel Simulator (LAMMPS) is a
software application designed for molecular dynamics simulations. It has
potentials for solid-state materials (metals, semiconductor), soft matter
(biomolecules, polymers) and coarse-grained or mesoscopic systems. It can be
used to model atoms or, more generically, as a parallel particle simulator at
the atomic, meso, or continuum scale.

More information
================
 - NGC: https://catalog.ngc.nvidia.com/orgs/nvidia/containers/lammps
]==])

whatis("Name: lammps")
whatis("Version: 10Sep25_pytorch")
whatis("Description: Large-scale Atomic/Molecular Massively Parallel Simulator (LAMMPS) is a software application designed for molecular dynamics simulations. It has potentials for solid-state materials (metals, semiconductor), soft matter (biomolecules, polymers) and coarse-grained or mesoscopic systems. It can be used to model atoms or, more generically, as a parallel particle simulator at the atomic, meso, or continuum scale.")
whatis("URL: https://ngc.nvidia.com/catalog/containers/hpc:lammps")


-- Load apptainer if needed
if not (os.getenv("NGC_SINGULARITY_MODULE") == "none") then
	local singularity_module = os.getenv("NGC_SINGULARITY_MODULE") or "apptainer"
	if not (isloaded(singularity_module)) then
		load(singularity_module)
	end
end

conflict(myModuleName(), "openmpi", "impi", "mvapich2", "chroma", "milc", "qmcpack", "relion")

local image = "nvcr.io_hpc_lammps:10Sep25_pytorch.sif"
local uri = "docker://nvcr.io/nvidia/lammps:10Sep25_pytorch"

prepend_path("PATH", "/apps/ngc/scripts/lammps/10Sep25_pytorch/bin")

-- Multinode support, Required for OpenMPI inside container to launch
setenv("OMPI_MCA_orte_launch_agent", "orted")
