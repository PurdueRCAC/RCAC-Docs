# --- same on every cluster ---
# Run one task per line of inputs.txt, up to one task per core at once.
# parallel.log records each task's exit status and run time. With
# --resume-failed, a rerun skips the tasks that succeeded and runs the
# ones that failed or never ran.
mkdir -p results
parallel --jobs "${SLURM_CPUS_PER_TASK}" \
    --joblog parallel.log --resume-failed \
    'wc -w {} > results/{/.}.count' :::: inputs.txt
