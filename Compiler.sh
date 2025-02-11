#!/bin/bash

echo "Steam Deck Video Converter to MP4"
echo "---------------------------------"
echo "Original Version by u/jack-of-some"
echo "Win Command Line by u/darkuni"
echo "---------------------------------"

# Ask for the directory where the files are located
echo "Please enter the directory where your video files are located:"
read directory

# Navigate to the provided directory
cd "$directory" || { echo "Directory not found!"; exit 1; }

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    echo "ffmpeg is not installed. Installing now..."
    sudo pacman -Sy ffmpeg --noconfirm
else
    echo "ffmpeg is already installed."
fi

# Check if the required files exist
if ! ls init-stream0.m4s chunk-stream0*.m4s init-stream1.m4s chunk-stream1*.m4s &> /dev/null; then
    echo "Required video/audio chunks not found in the directory!"
    exit 1
fi

# Creating Header Chunks
echo "Creating Header Chunks ..."
cp init-stream0.m4s chunk-stream0-00000.m4s > tmp.txt
cp init-stream1.m4s chunk-stream1-00000.m4s > tmp.txt

# Combining video files
echo "Combining video files ..."
cat chunk-stream0*.m4s > video.mp4

# Check if video file was created
if [ ! -f video.mp4 ]; then
    echo "Failed to create video.mp4!"
    exit 1
else
    echo "video.mp4 created successfully."
fi

# Combining audio files
echo "Combining audio files ..."
cat chunk-stream1*.m4s > audio.mp4

# Check if audio file was created
if [ ! -f audio.mp4 ]; then
    echo "Failed to create audio.mp4!"
    exit 1
else
    echo "audio.mp4 created successfully."
fi

# Merging Video and Audio Files
echo "Merging Video and Audio Files ..."
ffmpeg -loglevel debug -y -i video.mp4 -i audio.mp4 -c copy final_video.mp4

# Check if final video was created
if [ ! -f final_video.mp4 ]; then
    echo "Failed to merge video and audio!"
    exit 1
else
    echo "final_video.mp4 created successfully."
fi

# Cleaning Up
echo "Cleaning Up ..."
#rm audio.mp4
#rm video.mp4
#rm tmp.txt
#rm init*.m4s
#rm chunk*.m4s
#rm session.mpd

echo "Conversion complete. Check the folder for final_video.mp4"

