#!/bin/sh
# FILENAME: genotype.sh
# A stand-in for genotyping one region of the genome across the whole
# panel. "sh genotype.sh 07" waits 15 seconds, as if working, then
# collects region 07's line from every aligned line of the panel into
# regions/region_07.txt. It reads every line's alignment, so it must not
# start before the last alignment has finished.
region=$1
mkdir -p regions
sleep 15
# grep -h prints the matching lines without their file names.
grep -h "^$region " aligned/*.txt > "regions/region_$region.txt"
