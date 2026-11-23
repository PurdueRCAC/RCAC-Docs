# --- same on every cluster ---
# Keep this campaign's database, logs and captured output beside the
# script, as in tier 1, so a resubmission picks up where it stopped.
export HYPERSHELL_SITE="${SLURM_SUBMIT_DIR}/hypershell"
hs --version

# The number of GPUs this job asks for: keep it equal to --gpus-per-node
# above. gpu-pick.sh reads it too.
export GPUS=2
# How many tasks share each GPU at once. Measure before you raise it.
TASKS_PER_GPU=4

# Write the job's GPUs into the job's output file.
echo "GPUs in this job: ${CUDA_VISIBLE_DEVICES}"
nvidia-smi --query-gpu=index,pci.bus_id,name,memory.total,compute_mode --format=csv

# Every 10 seconds, record the processes on each GPU and their memory.
# The & at the end keeps this running beside the tasks until the job ends.
nvidia-smi --query-compute-apps=timestamp,gpu_bus_id,pid,used_memory \
    --format=csv,noheader --loop=10 > "gpu-use-${SLURM_JOB_ID}.txt" &

# One client on this node runs GPUS x TASKS_PER_GPU tasks at once.
# gpu-pick.sh gives each task one GPU, chosen by its executor slot.
mkdir -p results
hsx sweep.txt --restart --capture \
    -t 'sh gpu-pick.sh {}' \
    -N $(( GPUS * TASKS_PER_GPU ))
