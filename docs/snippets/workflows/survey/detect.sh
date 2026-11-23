#!/bin/bash
# FILENAME: detect.sh
# A stand-in for finding the sources in one field's calibrated images.
# Run it as
#   bash detect.sh 20261123 F007
# It waits a few seconds, as if working on the GPU its client's Slurm job
# was given, and writes nights/20261123/detected/F007.txt.

# The survey's directory on Data Depot.
survey=/depot/mygroup/data/survey

night=$1
field=$2
mkdir -p $survey/nights/$night/detected
sleep 10
echo "$field detected on $SLURM_CLUSTER_NAME $(hostname -s) GPU $CUDA_VISIBLE_DEVICES" > $survey/nights/$night/detected/$field.txt
# Add the calibration record. This is the last command, so the task fails
# if the field was never calibrated.
cat $survey/nights/$night/calibrated/$field.txt >> $survey/nights/$night/detected/$field.txt
