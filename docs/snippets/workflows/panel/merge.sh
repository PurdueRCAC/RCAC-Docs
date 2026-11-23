#!/bin/sh
# FILENAME: merge.sh
# A stand-in for merging every region into one file of calls.
# "sh merge.sh" waits 5 seconds, as if working, prints how many lines
# each region holds, and writes every call to panel-calls.txt.
sleep 5
wc -l regions/region_*.txt
cat regions/region_*.txt > panel-calls.txt
