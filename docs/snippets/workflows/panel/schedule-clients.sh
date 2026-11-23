#!/bin/sh
# FILENAME: schedule-clients.sh
# Submit a client job for one zone if the active task group has work
# waiting there. Run it on the server's login node, in the campaign
# directory, as: sh schedule-clients.sh ZONE PARTITION
zone=$1
partition=$2
# The most client jobs, queued or running, to keep for one zone.
MAX_JOBS=2
export HYPERSHELL_SITE="$PWD/hypershell"
export HYPERSHELL_CONFIG_FILE="$HYPERSHELL_SITE/config.toml"

# The active group is the lowest group with tasks not yet finished.
group=$(hs list group --remaining --order-by group --limit 1)
if [ -z "$group" ]; then
    echo "No tasks waiting"
    exit 0
fi

# A failed task in a lower group holds the active group: submit nothing.
failed=$(hs list group --failed --where 'exit_status != -1' "group < $group" --limit 1)
if [ -n "$failed" ]; then
    echo "Group $failed has failed tasks: revert or cancel them with hs update"
    exit 0
fi

# Count the zone's waiting tasks in the active group, and its client jobs.
waiting=$(hs list zone --remaining --group "$group" --all | grep -c -x "$zone")
jobs=$(squeue --noheader --user="$USER" --name="panel-$zone" | wc -l)
echo "Group $group, zone $zone: $waiting tasks waiting, $jobs client jobs"

# Submit one job if the zone has fewer jobs than MAX_JOBS and than tasks.
if [ "$jobs" -lt "$MAX_JOBS" ]; then
    if [ "$jobs" -lt "$waiting" ]; then
        sbatch --job-name="panel-$zone" --partition="$partition" client.sub "$zone"
    fi
fi
