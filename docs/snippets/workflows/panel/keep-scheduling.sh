#!/bin/sh
# FILENAME: keep-scheduling.sh
# Run schedule-clients.sh for each zone every five minutes, until you
# stop it. The second word of each line is the zone, the third the
# partition for that zone's client jobs.
while true; do
    sh schedule-clients.sh cpu cpu
    sh schedule-clients.sh highmem highmem
    sleep 300
done
