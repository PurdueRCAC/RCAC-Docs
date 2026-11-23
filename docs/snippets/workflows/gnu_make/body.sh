# --- same on every cluster ---
# Build every target in ./Makefile, running up to one recipe per core at once.
# --keep-going carries on past a failed target and builds everything that does
# not depend on it. A rerun builds only targets that are missing or out of date.
make --jobs="${SLURM_CPUS_PER_TASK}" --keep-going
