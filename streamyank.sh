#!/bin/bash

# A crazy simple interface for the streamlink command that automatically passes a given URL into best-case settings
# Includes a prompt for ffmpeg, so that the user can move to re-encode right away, or not if they want to download another stream right away
# I don't auto delete the .ts file because if a stream is pulled after it airs, that might be the only working copy. You can delete it yourself

# Ask the user for the stream link
read -p 'YouTube Live-Stream Link: ' linkvar
# Ask the user for the target name
read -p 'Enter Name for Output File: ' namevar
# Enter downloads for ease of retrieval
cd ~/Downloads
# Streamlink command, start from beginning, use link, export to .ts file in case of disconnect
streamlink --hls-live-edge 99999 --hls-segment-threads 5 -o "$namevar.ts" $linkvar best
# Tree for ffmpeg encode
while true; do
    read -p "Re-Encode file to mp4? (Y/N) " yn
    case $yn in
    	# If yes, pass .ts file into ffmpeg and don't fully re-encode, simply copy to new container
        [Yy]* ) ffmpeg -i "$namevar.ts" -c copy "$namevar.mp4"; echo " "; echo "$namevar.mp4 encoded, in Downloads."; break;;
		# If no, break
        [Nn]* ) echo "$namevar.ts left in Downloads."; break;;
        * ) echo " "; echo "Please answer Y or N. ";;
    esac
done
echo "Streamyank complete."
echo ""