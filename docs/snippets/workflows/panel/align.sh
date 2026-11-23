#!/bin/sh
# FILENAME: align.sh
# A stand-in for aligning one line of the panel. "sh align.sh L042"
# waits 30 seconds, as if working, then writes aligned/L042.txt with
# one call for each of the genome's 24 regions.
line=$1
mkdir -p aligned
sleep 30
# seq writes one line per region: "01 L042 1", "02 L042 1", and so on.
seq -f "%02g $line 1" 1 24 > "aligned/$line.txt"
