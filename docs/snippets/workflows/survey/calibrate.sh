#!/bin/bash
# FILENAME: calibrate.sh
# A stand-in for calibrating one field's images. Run it as
#   bash calibrate.sh 20261123 F007
# for night 20261123 and field F007. It waits a few seconds, as if
# working, and writes nights/20261123/calibrated/F007.txt, which records
# the cluster and the node that ran it.

# The survey's directory on Data Depot.
survey=/depot/mygroup/survey

night=$1
field=$2
mkdir -p $survey/nights/$night/calibrated
sleep 10
echo "$field calibrated on $SLURM_CLUSTER_NAME $(hostname -s)" > $survey/nights/$night/calibrated/$field.txt
