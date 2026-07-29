VIDEO_IN:=warner_home_video.mp4
VIDEO_OUT:=out.mp4
VIDEO_OUT_NO_AUDIO:=out_no_audio.mp4
COMPLETED:=ffmpeg-split_completed.txt \
jbig2_completed.txt \
montage2x2_completed.txt
PNG_DIRS:=montage_2x2 jbig2
PNG_GLOB:=$(patsubst %,%/*.png,$(PNG_DIRS))
SH:=ffmpeg-split.sh \
    jbig2.sh \
    montage_2x2.sh \
    ffmpeg-concatenate.sh

$(VIDEO_OUT): $(VIDEO_OUT_NO_AUDIO)
	ffmpeg -hide_banner -loglevel error -i $< -i $(VIDEO_IN) -map 0:v -map 1:a -c copy -y $@

$(VIDEO_OUT_NO_AUDIO): ffmpeg-concatenate.sh montage2x2_completed.txt
	./ffmpeg-concatenate.sh montage_2x2/ $@

montage2x2_completed.txt: montage_2x2.sh jbig2_completed.txt
	./montage_2x2.sh montage_2x2/ $@

jbig2_completed.txt : jbig2.sh ffmpeg-split_completed.txt
	./jbig2.sh jpg/ jbig2/ $@

ffmpeg-split_completed.txt : ffmpeg-split.sh $(VIDEO_IN)
	./ffmpeg-split.sh $(VIDEO_IN) jpg/ $@

.PHONY: clean
clean:
	rm --force -- $(VIDEO_OUT) $(VIDEO_OUT_NO_AUDIO) $(COMPLETED) jpg/*.jpg jbig2/*.jpg jbig2/*.jb2 $(PNG_GLOB)

.PHONY: shellcheck
shellcheck:
	shellcheck $(SH)

.PHONY: apt-install
apt-install:
	sudo apt install ffmpeg jbig2 python3 imagemagick-6.q16
