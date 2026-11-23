#!/bin/bash
# FILENAME: submit-night.sh
# Submit one night of the survey to the database on Geddes. Run it on
# Gautschi's login00, after module load hypershell, with the night's date:
#   bash submit-night.sh 20261123

# The survey's directory on Data Depot: the same path on every cluster.
survey=/depot/mygroup/data/survey
# The number of fields the telescope images each night.
fields=24

night=$1

# Use the survey's database settings and no other configuration.
export HYPERSHELL_SITE=$HOME/survey/hypershell
export HYPERSHELL_CONFIG_FILE=$HYPERSHELL_SITE/database.toml

# Write one task file per phase, kept with the night's data. seq writes
# one line per field, F001, F002, and so on.
mkdir -p $survey/nights/$night/tasks
cd $survey/nights/$night/tasks
seq -f "bash $survey/calibrate.sh $night F%03g" 1 $fields > calibrate.txt
seq -f "bash $survey/detect.sh $night F%03g" 1 $fields > detect.txt
echo "bash $survey/catalog.sh $night" > catalog.txt

# Submit the phases. The group, the night's date and the phase number,
# orders them; the zone places them. && submits the next phase only if
# the one before it was accepted.
hs submit --group ${night}0 --zone cpu calibrate.txt &&
hs submit --group ${night}1 --zone gpu detect.txt &&
hs submit --group ${night}2 --zone cpu catalog.txt
