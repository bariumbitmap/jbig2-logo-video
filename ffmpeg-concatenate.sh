#! /usr/bin/env bash

set -e
set -u

dir_in="$1"
mp4_out="$2"
# use ffplay for troubleshooting, ffmpeg for output
ffmpeg \
    -hide_banner -loglevel error -framerate 60 -i ${dir_in}/%04d.png -pix_fmt yuv420p -y -vf \
"[in]
drawtext=fontsize=64:fontcolor=black:box=1:boxcolor=white@1.0:boxborderw=4:
text='original':x=10:y=10,
drawtext=fontsize=64:fontcolor=black:box=1:boxcolor=white@1.0:boxborderw=4:
text='thresholded':x=w-text_w-10:y=10,
drawtext=fontsize=64:fontcolor=black:box=1:boxcolor=white@1.0:boxborderw=4:
text='image region':x=10:y=h-text_h-10,
drawtext=fontsize=64:fontcolor=black:box=1:boxcolor=white@1.0:boxborderw=4:
text='symbol region':x=w-text_w-10:y=h-text_h-10
[out]" \
"${mp4_out}"
# https://trac.ffmpeg.org/wiki/Slideshow
# https://stackoverflow.com/questions/11138832/ffmpeg-multiple-text-in-one-command-drawtext
