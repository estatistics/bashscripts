# Useful bashscript commands for 
- Editing videos
- Downloading / Editing Streamings
- Debian terminal comamnds
- HDD / SDD commands
- Image Manipulation / process (montage, cropping, adjusting, color correction)
- Audio manipulation / process (highres audio, louder audio, ripping audio)
- Video manipulation / process (color correction, resolution higher/lower, cropping, transforming, encoding, decocind)
- Changing exif data in bulk
- PDF manipulations / process 
- Bulk file operations recursively (renaming, moving, copying)
- Bulk folder operations recursively (renaming, moving, copying)
- Text files manipulations (sed / awk commands)
- wget / yt-dlp commands
- adb commands
- system health check
- monitor commands
- wine commands

# gstream encoding/decoding script
AMD VA-API H.265/Opus Transcoder

A high-performance Bash script designed to batch-convert MKV files into H.265 (HEVC) using AMD hardware acceleration (VA-API). This script utilizes GStreamer for ultra-efficient video encoding and FFmpeg for professional-grade audio processing and container muxing.
🚀 Features
-    Dual-Engine Pipeline: Uses GStreamer's vaapih265enc for video and FFmpeg's libopus for audio.
-    Hardware Accelerated: Offloads video encoding to the AMD VCN (Video Core Next) engine, keeping CPU usage low and speed high.
-    Smart Clipping: Toggle between encoding a full video or a specific duration for testing.
-    High-Fidelity Audio: Encodes audio into 512k Opus with support for 5.1 surround sound mapping.
-    Automatic Cleanup: Removes temporary video-only files after successful muxing.
- VARS:
  - TIME_VID	Set to 0 for the Full Movie. Set to a number (e.g., 60) to encode only the first X seconds for a quality test.	1200 (20 mins)
  - BITRATE	Target video bitrate in kbps.	4000 (4Mbps)

🖥️ How it Works
-    FPS Detection: Uses ffprobe to find the exact frame rate of the source.
-    Video Encoding: GStreamer pulls the raw video, converts the colorspace, and pipes it into the AMD hardware encoder.
-    Audio & Muxing: FFmpeg takes the new video stream, encodes the original audio to Opus, ensures 5.1 channel mapping is correct, and combines them into a final .mkv file.

📈 Performance
- On an AMD RX 5700 XT, this script typically processes 1080p video at 3x-5x real-time speed. To reach 100% GPU utilization (ENC), it is recommended to run two instances of the script in parallel.
📋 Prerequisites

Ensure you have the following installed:
-    FFmpeg (with libopus support)
-    GStreamer (with va-api plugins)
-    Python3 (for frame calculation)
-    amdgpu_top (optional, to monitor hardware usage)
