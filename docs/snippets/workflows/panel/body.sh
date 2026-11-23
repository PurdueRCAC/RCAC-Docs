# --- same on every cluster ---
# Run one HyperShell client for the zone named on the command line;
# schedule-clients.sh passes it. The client finds the server on the
# login node through config.toml, runs one task per core, and exits
# after 10 minutes with nothing to do, which ends this job early.
zone="${1:?usage: sbatch client.sub ZONE}"
export HYPERSHELL_SITE="${SLURM_SUBMIT_DIR}/hypershell"
export HYPERSHELL_CONFIG_FILE="${HYPERSHELL_SITE}/config.toml"
hs --version

hs client --zone "${zone}" --capture \
    -N "${SLURM_CPUS_PER_TASK}" -T 600
