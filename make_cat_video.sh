#!/bin/zsh
# Usage: ./make_cat_video.sh "/path/to/cat.png" ["/path/to/audio-source.mp4"]
# Creates a 30-second square video on the macOS Desktop.

set -euo pipefail

if (( $# < 1 || $# > 2 )); then
  print -u2 "Использование: $0 /путь/к/котику.png [путь/к/аудио.mp4]"
  exit 64
fi

cat_image=$1
script_dir=${0:A:h}
background="$script_dir/cat-free-background-template.png"
# Default soundtrack ships with the repo; a second argument overrides it.
audio_source=${2:-$script_dir/cat-default-audio.m4a}
# Works for any macOS account; no personal user name is embedded in the script.
desktop_dir="$HOME/Desktop"
base_name=${cat_image:t:r}
stamp=$(date +%Y%m%d-%H%M%S)
output="$desktop_dir/${base_name}-cat-video-30s-${stamp}.mp4"

[[ -f "$cat_image" ]] || { print -u2 "Не найдено изображение: $cat_image"; exit 66; }
[[ -f "$background" ]] || { print -u2 "Не найден фон: $background"; exit 66; }
command -v ffmpeg >/dev/null || { print -u2 "Нужен ffmpeg: brew install ffmpeg"; exit 69; }

[[ -f "$audio_source" ]] || { print -u2 "Не найдено аудио/видео: $audio_source"; exit 66; }

# Settings approved in the final layout: 720×720, cat 450px wide,
# shifted right (x=270) and down (y=220), plus a subtle floating motion.
ffmpeg \
  -loop 1 -i "$background" \
  -loop 1 -i "$cat_image" \
  -stream_loop -1 -i "$audio_source" \
  -filter_complex "[0:v]scale=720:720:force_original_aspect_ratio=increase,crop=720:720,setsar=1[bg];[1:v]scale=450:450,setsar=1[cat];[bg][cat]overlay=x=270:y=220+7*sin(2*PI*t/5):eval=frame,format=yuv420p[v]" \
  -map "[v]" -map 2:a:0 -t 30 -r 30 \
  -c:v libx264 -preset medium -crf 22 \
  -c:a aac -b:a 128k -movflags +faststart \
  "$output"

print "Готово: $output"
