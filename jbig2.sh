#! /usr/bin/env bash

set -e
set -u
dir_in="$1"
dir_out="$2"
completion_file="$3"
counter=0
start_time=$(date +%s.%N)
for fp in "$dir_in"/*.jpg
do
    stem=$(basename "$fp" .jpg)
    jbig2 -O $dir_out/threshold_$stem.png -T 90 -S -j -b $dir_out/seg_$stem -s -a $fp > $dir_out/$stem.jb2
    jbig2dec -o $dir_out/$stem.png $dir_out/$stem.jb2
    counter=$((counter+1))
done
end_time=$(date +%s.%N)
duration=$(echo "$end_time - $start_time" | bc)
printf 'processed %s files in %s seconds\n' $counter $duration > "$completion_file"
