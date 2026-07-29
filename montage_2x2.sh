#! /usr/bin/env bash

set -e
set -u

outdir="$1"
completion_file="$2"
counter=0
for jpg in jpg/*.jpg
do
    stem=$(basename "$jpg" .jpg)
    img1=jbig2/threshold_${stem}.png
    img2=jbig2/seg_${stem}.0000.jpg
    img3=jbig2/${stem}.png
    montage $jpg $img1 $img2 $img3 -tile 2x2 -geometry +0+0 ${outdir}/${stem}.png
    counter=$((counter+1))
done
printf 'processed %s files in %s seconds\n' $counter $SECONDS > "$completion_file"
