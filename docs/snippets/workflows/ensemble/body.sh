# --- same on every cluster ---
# The campaign's database and logs live beside this script, as in
# tier 1. The task list was loaded into the database once, with
# hs submit, before the first job; every job takes up what is left.
export HYPERSHELL_SITE="${SLURM_SUBMIT_DIR}/hypershell"
# One log line per task is too many at this scale: log only warnings
# and errors.
export HYPERSHELL_LOGGING_LEVEL=warning
hs --version

# One client per node, one executor per core. Each client asks for a
# bundle of tasks as large as its executor count and returns results
# in bundles of the same size. Clients start up to 30 seconds apart,
# and a member still running after 5 minutes is stopped.
# Every member's result line is collected in one file per job.
executors="${SLURM_CPUS_PER_TASK}"
hsx --restart \
    --launcher="srun --cpus-per-task=${SLURM_CPUS_PER_TASK}" \
    -N "${executors}" -b "${executors}" -w 30 \
    --delay-start=-30 -W 300 \
    > "ensemble-${SLURM_JOB_ID}.txt"
