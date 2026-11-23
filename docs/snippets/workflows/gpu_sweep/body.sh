# --- same on every cluster ---
# Keep this campaign's database, logs and captured output beside the
# script, as in tier 1, so a resubmission picks up where it stopped.
export HYPERSHELL_SITE="${SLURM_SUBMIT_DIR}/hypershell"
hs --version

# The GPUs this job holds. Slurm lists them in CUDA_VISIBLE_DEVICES.
: "${CUDA_VISIBLE_DEVICES:?this job has no GPUs}"
echo "GPUs in this job: ${CUDA_VISIBLE_DEVICES}"
nvidia-smi --query-gpu=index,pci.bus_id,name,memory.total,compute_mode --format=csv
gpus=$(printf '%s\n' "$CUDA_VISIBLE_DEVICES" | tr ',' '\n' | wc -l)

# How many tasks share each GPU at once. Measure before you raise it.
tasks_per_gpu="${TASKS_PER_GPU:-4}"

# Every 10 seconds, record the processes on each GPU and their memory.
while sleep 10; do
    date +%T
    nvidia-smi --query-compute-apps=gpu_bus_id,pid,used_memory --format=csv,noheader
done > "gpu-use-${SLURM_JOB_ID}.txt" &
sampler=$!

# One client on this node runs (GPUs x tasks per GPU) tasks at once.
# gpu-pick.sh gives each task one GPU, chosen by its executor slot.
mkdir -p results
hsx sweep.txt --restart --capture \
    -t 'sh gpu-pick.sh {}' \
    -N "$(( gpus * tasks_per_gpu ))"

kill "$sampler"
