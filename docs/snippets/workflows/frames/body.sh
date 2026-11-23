# --- same on every cluster ---
# HyperShell keeps its database, logs and captured task output under
# HYPERSHELL_SITE. A directory beside this script, the same for every
# job you submit from here, is what lets a resubmission pick up where
# the last job stopped.
export HYPERSHELL_SITE="${SLURM_SUBMIT_DIR}/hypershell"
hs --version

# Render every frame in frames.txt. srun starts one HyperShell client
# on each node, and each client renders as many frames at once as the
# job has cores per node. With --restart, frames that already ran in an
# earlier job are skipped.
mkdir -p frames
hsx frames.txt --restart --capture \
    --launcher="srun --cpus-per-task=${SLURM_CPUS_PER_TASK}" \
    -N "${SLURM_CPUS_PER_TASK}"
