# Post this meow-meow every week

Small macOS utility that turns a transparent cat PNG into a 30-second square social video. The cat is scaled down, placed in the lower-right corner, and subtly floats so the left side stays open for a caption or speech bubble.

## Demo

<video src="https://s3.akarmain.ru/S/KkgIl.mp4" controls muted loop playsinline width="360"></video>

[Open the demo video](https://s3.akarmain.ru/S/KkgIl.mp4)

## Requirements

- macOS or another system with `zsh`
- [FFmpeg](https://ffmpeg.org/): `brew install ffmpeg`
- A PNG with a transparent background

## Use

```zsh
zsh make_cat_video.sh '/path/to/cat.png'
```

The script creates a silent 30-second H.264/AAC MP4 on the Desktop. To use a sound from an existing video or audio file, pass it as a second argument:

```zsh
zsh make_cat_video.sh '/path/to/cat.png' '/path/to/sound.mp4'
```

Output: 720×720, 30 fps, 30 seconds. A timestamp prevents overwriting an earlier export.

## Layout

The current layout uses a 450 px cat canvas, positioned at `x=270`, `y=220` in a 720×720 video. Edit those values in `make_cat_video.sh` if you want a different composition.
