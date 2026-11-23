#!/bin/sh
# FILENAME: render-frame.sh
# A stand-in for a renderer. "sh render-frame.sh 42" draws frame 42 of
# a moving gradient as a small greyscale image, frames/frame_0042.pgm.
# A real renderer would take minutes per frame; this one waits 10 to
# 29 seconds to stand in for that time.
frame=$1
out=$(printf 'frames/frame_%04d.pgm' "$frame")
sleep $(( 10 + frame % 20 ))
awk -v f="$frame" 'BEGIN {
    w = 160; h = 90
    print "P2"; print w, h; print 255
    for (y = 0; y < h; y++) {
        row = ""
        for (x = 0; x < w; x++) row = row " " int((x + y + 4 * f) % 256)
        print row
    }
}' > "$out"
