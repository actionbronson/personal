#!/bin/ksh

YOUTUBE="/usr/local/bin/youtube-dl"
FFMPEG="/usr/local/bin/ffmpeg"
YOUTUBE_LINK=""

USAGE="[+NAME?$0]"
USAGE+="[y:youtube]:[YOUTUBE_LINK]"
USAGE+="[a:account]:[YOUTUBE_ACC]"
USAGE+="[s:start]:[START_SEC]"
USAGE+="[e:end]:[END_SEC]"
USAGE+="[o:output]:[OUTPUT]"

while getopts "$USAGE" optchar; do
    case $optchar in
        y) YOUTUBE_LINK=$OPTARG ;;
        a) YOUTUBE_ACC=$OPTARG ;;
        s) START_SEC=$OPTARG ;;
        e) END_SEC=$OPTARG ;;
        o) OUTPUT=$OPTARG ;;
    esac
done

echo "Fetching '$YOUTUBE_LINK'"

set -x
$YOUTUBE -u $YOUTUBE_ACC -x --audio-format m4a -o "$OUTPUT" "$YOUTUBE_LINK"
CLIP_START=$(echo $START_SEC | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
CLIP_END=$(echo $END_SEC | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
CLIP_LENGTH=$(( $CLIP_END - $CLIP_START ))
FADE_OUT_START=$(( $CLIP_LENGTH - 2 ))
$FFMPEG -ss $START_SEC -to $END_SEC -i $OUTPUT -af "afade=t=in:st=0:d=2,afade=t=out:st=$FADE_OUT_START:d=2" ringtone-$OUTPUT

