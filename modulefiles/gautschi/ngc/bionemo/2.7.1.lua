whatis("Name: BioNeMo Framework")
whatis("Version: 2.7.1")
whatis("URL: https://catalog.ngc.nvidia.com/orgs/nvidia/teams/clara/containers/bionemo-framework")

conflict(myModuleName())

if not (os.getenv("NGC_SINGULARITY_MODULE") == "none") then
    local singularity_module = os.getenv("NGC_SINGULARITY_MODULE") or "Singularity"
    if not (isloaded(singularity_module)) then
        load(singularity_module)
    end
end

local image_name = "nvcr.io_nvidia_clara_bionemo-framework:2.7.1.sif"
local image = image_name

if (os.getenv("NGC_IMAGE_DIR")) then
    image = pathJoin(os.getenv("NGC_IMAGE_DIR"), image_name)
end

if not isFile(image) then
    LmodError("BioNeMo container image not found: " .. image)
end

local singularity = capture("which singularity | head -c -1")

local user = os.getenv("USER") or "unknown"
local home = os.getenv("HOME") or ""
local scratch = os.getenv("CLUSTER_SCRATCH")

-- Just put datasets in scratch
local container_root   = pathJoin(scratch, "containers", "bionemo-framework", "2.7.1")
local container_home   = pathJoin(container_root, "home")
local cache_dir_host   = pathJoin(container_home, ".cache")
local data_dir_host    = pathJoin(container_root, "data")
local models_dir_host  = pathJoin(container_root, "models")
local results_dir_host = pathJoin(container_root, "results")
local work_dir_host    = pathJoin(container_root, "work")

setenv("BIONEMO_CONTAINER_IMAGE", image)
setenv("BIONEMO_CONTAINER_ROOT", container_root)
setenv("BIONEMO_CONTAINER_HOME", container_home)
setenv("BIONEMO_CACHE_DIR_HOST", cache_dir_host)
setenv("BIONEMO_DATA_DIR_HOST", data_dir_host)
setenv("BIONEMO_MODELS_DIR_HOST", models_dir_host)
setenv("BIONEMO_RESULTS_DIR_HOST", results_dir_host)
setenv("BIONEMO_WORK_DIR_HOST", work_dir_host)

setenv("SINGULARITYENV_NVIDIA_VISIBLE_DEVICES", "all")
setenv("SINGULARITYENV_NVIDIA_DRIVER_CAPABILITIES", "compute,utility")


setenv("SINGULARITYENV_XDG_CACHE_HOME", "/.singularity.d/libs/.cache")
setenv("SINGULARITYENV_BIONEMO_CACHE_DIR", "/models")

local bind_paths = table.concat({
    container_home .. ":" .. home,
    cache_dir_host .. ":" .. pathJoin(home, ".cache"),
    data_dir_host .. ":/data",
    models_dir_host .. ":/models",
    results_dir_host .. ":/results",
    work_dir_host .. ":/workspace"
}, ",")

setenv("SINGULARITY_BINDPATH", bind_paths)

local common_opts = table.concat({
    "--nv",
    "--home " .. container_home .. ":" .. home,
    "--bind " .. bind_paths
}, " ")

set_shell_function("bionemo_shell",
    "mkdir -p '" .. container_home .. "' '" .. cache_dir_host .. "' '" .. data_dir_host .. "' '" .. models_dir_host .. "' '" .. results_dir_host .. "' '" .. work_dir_host .. "' ; " ..
    singularity .. " shell " .. common_opts .. " '" .. image .. "'",
    "mkdir -p '" .. container_home .. "' '" .. cache_dir_host .. "' '" .. data_dir_host .. "' '" .. models_dir_host .. "' '" .. results_dir_host .. "' '" .. work_dir_host .. "' ; " ..
    singularity .. " shell " .. common_opts .. " '" .. image .. "'"
)

set_shell_function("bionemo_exec",
    "mkdir -p '" .. container_home .. "' '" .. cache_dir_host .. "' '" .. data_dir_host .. "' '" .. models_dir_host .. "' '" .. results_dir_host .. "' '" .. work_dir_host .. "' ; " ..
    singularity .. " exec " .. common_opts .. " '" .. image .. "' \"$@\"",
    "mkdir -p '" .. container_home .. "' '" .. cache_dir_host .. "' '" .. data_dir_host .. "' '" .. models_dir_host .. "' '" .. results_dir_host .. "' '" .. work_dir_host .. "' ; " ..
    singularity .. " exec " .. common_opts .. " '" .. image .. "' $*"
)

set_shell_function("bionemo_python",
    "mkdir -p '" .. container_home .. "' '" .. cache_dir_host .. "' '" .. data_dir_host .. "' '" .. models_dir_host .. "' '" .. results_dir_host .. "' '" .. work_dir_host .. "' ; " ..
    singularity .. " exec " .. common_opts .. " '" .. image .. "' python \"$@\"",
    "mkdir -p '" .. container_home .. "' '" .. cache_dir_host .. "' '" .. data_dir_host .. "' '" .. models_dir_host .. "' '" .. results_dir_host .. "' '" .. work_dir_host .. "' ; " ..
    singularity .. " exec " .. common_opts .. " '" .. image .. "' python $*"
)

set_shell_function("download_bionemo_data",
    "mkdir -p '" .. container_home .. "' '" .. cache_dir_host .. "' '" .. data_dir_host .. "' '" .. models_dir_host .. "' '" .. results_dir_host .. "' '" .. work_dir_host .. "' ; " ..
    singularity .. " exec " .. common_opts .. " '" .. image .. "' download_bionemo_data \"$@\"",
    "mkdir -p '" .. container_home .. "' '" .. cache_dir_host .. "' '" .. data_dir_host .. "' '" .. models_dir_host .. "' '" .. results_dir_host .. "' '" .. work_dir_host .. "' ; " ..
    singularity .. " exec " .. common_opts .. " '" .. image .. "' download_bionemo_data $*"
)

set_shell_function("esm2_3b_download",
    "mkdir -p '" .. container_home .. "' '" .. cache_dir_host .. "' '" .. data_dir_host .. "' '" .. models_dir_host .. "' '" .. results_dir_host .. "' '" .. work_dir_host .. "' ; " ..
    singularity .. " exec " .. common_opts .. " '" .. image .. "' bash -lc 'download_bionemo_data esm2/3b:2.0 --source ngc'",
    "mkdir -p '" .. container_home .. "' '" .. cache_dir_host .. "' '" .. data_dir_host .. "' '" .. models_dir_host .. "' '" .. results_dir_host .. "' '" .. work_dir_host .. "' ; " ..
    singularity .. " exec " .. common_opts .. " '" .. image .. "' bash -lc 'download_bionemo_data esm2/3b:2.0 --source ngc'"
)