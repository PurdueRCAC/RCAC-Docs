#!/bin/sh
# FILENAME: submit-phases.sh
# Submit one phase of the panel pipeline to the campaign's database.
# Run it on the server's login node, from the campaign directory:
#   sh submit-phases.sh align batch-1.txt   align a batch of lines
#   sh submit-phases.sh genotype            genotype every region
#   sh submit-phases.sh merge               merge the regions
# The group number orders the phases: no task of group 1 starts until
# every task of group 0 has finished, and so on. The zone sends each
# phase to the clients that serve it: cpu or highmem.
set -e
export HYPERSHELL_SITE="$PWD/hypershell"
export HYPERSHELL_CONFIG_FILE="$HYPERSHELL_SITE/config.toml"
mkdir -p tasks

case "$1" in
    align)
        # One task per line of the panel named in the batch file.
        batch="${2:?name a batch file of line names}"
        tasks="tasks/align-$(basename "$batch")"
        sed 's/^/sh panel.sh align /' "$batch" > "$tasks"
        hs submit --group 0 --zone cpu "$tasks"
        ;;
    genotype)
        # One task per region of the genome.
        sh panel.sh regions | sed 's/^/sh panel.sh genotype /' > tasks/genotype.txt
        hs submit --group 1 --zone highmem tasks/genotype.txt
        ;;
    merge)
        # One task that merges every region.
        echo 'sh panel.sh merge' > tasks/merge.txt
        hs submit --group 2 --zone cpu tasks/merge.txt
        ;;
    *)
        echo "usage: sh submit-phases.sh align BATCH | genotype | merge" >&2
        exit 2
        ;;
esac
