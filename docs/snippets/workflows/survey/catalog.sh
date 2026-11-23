#!/bin/bash
# FILENAME: catalog.sh
# A stand-in for merging one night's detections into a catalog. Run it as
#   bash catalog.sh 20261123
# It counts the fields each cluster calibrated, then writes
# nights/20261123/catalog.txt from every field's detections.

# The survey's directory on Data Depot.
survey=/depot/mygroup/survey

night=$1
cd $survey/nights/$night
sleep 5
# Count the fields each cluster calibrated.
cat calibrated/*.txt > calibrated.txt
echo "Fields calibrated on Gautschi: $(grep -c gautschi calibrated.txt)"
echo "Fields calibrated on Negishi: $(grep -c negishi calibrated.txt)"
# Merge the detections. This is the last command, so the task fails if
# there are none.
cat detected/*.txt > catalog.txt
