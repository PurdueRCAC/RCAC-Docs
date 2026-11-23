#!/bin/sh
# FILENAME: member.sh
# A stand-in for one member of a perturbed-parameter climate ensemble.
# "sh member.sh 42" runs member 42: a one-box energy-balance model
# whose feedback parameter is drawn from a seed, stepped through 150
# years of a steady rise in forcing. It prints one line: the member
# number, its feedback parameter, and its warming at the end.
# A real member would run for seconds to minutes; this one is quick.
exec awk -v m="$1" 'BEGIN {
    srand(m)
    lambda = 0.8 + 0.8 * rand()
    t = 0
    for (year = 1; year <= 150; year++)
        t += 0.1 * (0.04 * year - lambda * t)
    printf "%d %.3f %.3f\n", m, lambda, t
}'
