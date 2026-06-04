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
DeepSpeed is a deep learning optimization library that makes distributed
training easy, efficient, and effective.  DeepSpeed delivers extreme-scale
model training for everyone, from data scientists training on massive
 supercomputers to those training on low-end clusters or even on a single GPU.

More information
================
 - Home page:  https://www.deepspeed.ai
 - Docker:     docker://rocm/deepspeed
]==])

whatis("Name: DeepSpeed")
whatis("Version: rocm6.1_ubuntu20.04_py3.9_pytorch_2.1.2")
whatis("Description: DeepSpeed is a deep learning optimization library that makes distributed training easy, efficient, and effective.")
whatis("Home page:   https://www.deepspeed.ai")
whatis("Docker:      docker://rocm/deepspeed")

if not (os.getenv("ROCM_SINGULARITY_MODULE") == "none") then
   local singularity_module = os.getenv("ROCM_SINGULARITY_MODULE") or "Singularity"
   if not (isloaded(singularity_module)) then
      load(singularity_module)
   end
end

-- Need to alias Python interpreter and set conflicts with all Python-y things.
conflict(myModuleName())
conflict("biopython", "anaconda", "python",
         "deepspeed", "openmm", "pytorch", "tensorflow")

local image = "rocm_pytorch:rocm6.3.2_ubuntu24.04_py3.12_pytorch_release_2.4.0.sif"
local uri = "docker://rocm/deepspeed:rocm6.1_ubuntu20.04_py3.9_pytorch_2.1.2"
local programs = {"deepspeed",
                  "python", "python3", "python3.6", "ipython", "ipython3",
                  "convert-caffe2-to-onnx", "convert-onnx-to-caffe2",
                  "estimator_ckpt_converter", "import_pb_to_tensorboard",
		  "tensorboard", "tflite_convert",
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
-- Note: using 'exec' instead of 'run' to bypass a failing runscript entrypoint
local container_launch = singularity .. " exec " .. table.concat(run_args, " ") .. " " .. image .. " " .. entrypoint_args

-- Multinode support
pushenv("OMPI_MCA_orte_launch_agent", container_launch .. " orted")

-- Programs to setup in the shell
for i,program in pairs(programs) do
    set_shell_function(program, container_launch .. " " .. program .. " \"$@\"",
                                container_launch .. " " .. program .. " $*")
end

-- Additional commands or environment variables, if any
