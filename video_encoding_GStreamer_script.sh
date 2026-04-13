#!/bin/bash

# --- SETTINGS ---
TIME_VID=0       # Set to 0 for FULL VIDEO, or seconds (e.g., 1200) for a cut
BITRATE=4000     # Your desired bitrate in kbps
# ----------------

for vids in *.mkv; do
  [ -e "$vids" ] || continue
  # Skip processing if we are looking at our own output
  [[ "$vids" == a_* ]] && continue
  [[ "$vids" == temp_* ]] && continue

  echo "--- Processing: $vids ---"

  # 1. Detect FPS
  fps_raw=$(ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -of default=noprint_wrappers=1:nokey=1 "$vids")
  fps=$(echo "scale=4; $fps_raw" | bc -l)

  # 2. Logic for Full vs. Cut
  if [ "$TIME_VID" -eq 0 ]; then
      echo "Mode: FULL VIDEO detected."
      LIMIT_STREAM=""
      TIME_FLAG=""
  else
      num_frames=$(python3 -c "print(round($fps * $TIME_VID))")
      echo "Mode: CUT detected. Encoding $num_frames frames..."
      LIMIT_STREAM="! identity eos-after=$num_frames"
      TIME_FLAG="-t $TIME_VID"
  fi

  # 3. GStreamer: Encode Video
  gst-launch-1.0 -e filesrc location="$vids" ! decodebin ! queue ! \
    videoconvert $LIMIT_STREAM ! queue !  \
    vaapih265enc bitrate=$BITRATE rate-control=cbr ! \
    h265parse ! matroskamux ! filesink location="temp_${vids%.*}.mkv"

  # 4. FFmpeg: Combine with Audio
  # Added -mapping_family 1 (for surround) and channel layout fix
  ffmpeg -y -i "temp_${vids%.*}.mkv" $TIME_FLAG -i "$vids" \
    -map 0:v:0 -map 1:a? \
    -c:v copy \
    -c:a libopus -b:a 512k -vbr on \
    -af "aformat=channel_layouts=5.1|stereo" \
    -mapping_family 1 \
    -shortest -fflags +genpts \
    "a_${vids%.*}.mkv"

  # 5. Cleanup
  if [ -f "a_${vids%.*}.mkv" ] && [ -s "a_${vids%.*}.mkv" ]; then
     "temp_${vids%.*}.mkv"
     echo "Success: a_${vids%.*}.mkv created."
  else
     echo "ERROR: Output file is empty. Keeping temp file for inspection."
  fi

  echo "-----------------------------------"
done


