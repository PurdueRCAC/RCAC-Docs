#!/bin/sh
# FILENAME: panel.sh
# A stand-in for the three steps of a diversity-panel genotyping
# pipeline. Each step is one command, run from the campaign directory:
#   sh panel.sh align L042    align line L042's reads -> aligned/L042.txt
#   sh panel.sh genotype 7    call region 7 across every aligned line
#                             -> regions/region_07.txt
#   sh panel.sh merge         merge every region -> panel-calls.txt
#   sh panel.sh regions       list the region numbers, 1 to 24
# Real steps run an aligner or a variant caller for minutes to hours;
# these wait a few seconds, as if working, and write small text files.
regions=24
case "$1" in
    regions)
        seq 1 "$regions"
        ;;
    align)
        # One genotype (0, 1 or 2) per region for this line, drawn from
        # a seed made from the line's name, so a rerun writes the same.
        line=$2
        seed=$(printf '%s' "$line" | cksum | cut -d' ' -f1)
        mkdir -p aligned
        sleep $(( 20 + seed % 20 ))
        awk -v line="$line" -v seed="$seed" -v n="$regions" 'BEGIN {
            srand(seed)
            for (r = 1; r <= n; r++) print r, line, int(3 * rand())
        }' > "aligned/$line.txt"
        ;;
    genotype)
        # Read this region's line from every aligned file. Genotyping
        # needs every line of the panel, so it must not start before the
        # last alignment has finished.
        region=$2
        out=$(printf 'regions/region_%02d.txt' "$region")
        mkdir -p regions
        sleep $(( 10 + region % 10 ))
        cat aligned/*.txt | awk -v r="$region" '$1 == r' > "$out"
        ;;
    merge)
        # Merge the regions in order and report how many calls each holds.
        sleep 5
        for region in $(seq 1 "$regions"); do
            cat "$(printf 'regions/region_%02d.txt' "$region")" || exit 1
        done > panel-calls.txt
        awk '{n[$1]++} END {for (r in n) print "region", r, n[r], "lines"}' panel-calls.txt | sort -n -k2
        ;;
    *)
        echo "usage: sh panel.sh align LINE | genotype REGION | merge | regions" >&2
        exit 2
        ;;
esac
