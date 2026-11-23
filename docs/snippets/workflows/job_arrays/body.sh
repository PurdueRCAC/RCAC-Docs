# --- same on every cluster ---
# Each array task takes one line of inputs.txt: task 1 takes line 1, and so on.
INPUT=$(sed -n "${SLURM_ARRAY_TASK_ID}p" inputs.txt)
echo "Array task ${SLURM_ARRAY_TASK_ID} of job ${SLURM_ARRAY_JOB_ID}: ${INPUT}"

# The work itself. Replace this with your own command.
# basename turns data/sample_05.txt into sample_05, the name of the result.
NAME=$(basename "${INPUT}" .txt)
mkdir -p results
wc -w "${INPUT}" > "results/${NAME}.count"
