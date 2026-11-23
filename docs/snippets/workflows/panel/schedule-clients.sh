#!/bin/sh
# FILENAME: schedule-clients.sh
# Keep client jobs queued for each zone that has work waiting in the
# active task group, and submit none for a zone that has none. Run it on
# the server's login node, from the campaign directory, by hand or in a
# loop (see the page). One run submits at most enough jobs to bring
# each zone up to max_jobs; clients with nothing to do exit on their own.

# The most client jobs, queued or running, to keep for one zone.
max_jobs="${MAX_JOBS:-2}"
# The partition for highmem clients. The cpu zone's clients use the
# partition named in client.sub.
highmem_partition="${HIGHMEM_PARTITION:-highmem}"

export HYPERSHELL_SITE="$PWD/hypershell"
export HYPERSHELL_CONFIG_FILE="$HYPERSHELL_SITE/config.toml"

# Clients need a server to connect to: check that it runs on this host.
if ! kill -0 "$(cat hypershell/server.pid 2>/dev/null)" 2>/dev/null; then
    echo "No server running on $(hostname) for this campaign" >&2
    exit 1
fi

# The active group is the lowest group with tasks not yet finished. A
# lower group that still holds failed tasks stops it from starting.
group=$(hs list group --remaining --order-by group --limit 1)
failed=$(hs list group --failed --where 'exit_status != -1' --order-by group --limit 1)
if [ -n "$failed" ] && { [ -z "$group" ] || [ "$failed" -lt "$group" ]; }; then
    echo "Group $failed has failed tasks: revert or cancel them with hs update"
    exit 0
fi
if [ -z "$group" ]; then
    echo "No tasks waiting"
    exit 0
fi

# Count the unfinished tasks of the active group in each zone, and top
# up that zone's client jobs: never more than max_jobs, and never more
# jobs than tasks.
hs list zone --remaining --group "$group" --all | sort | uniq -c |
while read -r waiting zone; do
    case "$zone" in
        cpu)     options="" ;;
        highmem) options="--partition=$highmem_partition" ;;
        *)       echo "Group $group: $waiting tasks in zone $zone, which no client serves"
                 continue ;;
    esac
    jobs=$(squeue --noheader --user="$USER" --name="panel-$zone" --format=%i | wc -l)
    want=$max_jobs
    if [ "$waiting" -lt "$want" ]; then want=$waiting; fi
    submitted=0
    while [ $(( jobs + submitted )) -lt "$want" ]; do
        sbatch --job-name="panel-$zone" $options client.sub "$zone"
        submitted=$(( submitted + 1 ))
    done
    echo "Group $group, zone $zone: $waiting tasks waiting, $(( jobs )) client jobs, $submitted submitted"
done
