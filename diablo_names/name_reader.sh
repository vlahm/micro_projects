#!/bin/bash

VOICES=("male2" "male3" "female1" "female3" "child_male" "child_female")
IMAGE_DIR="$HOME/git/micro_projects/diablo_names/images"

exec 2>/dev/null

# Function to handle cleanup on exit
cleanup() {
    pkill -f gifview
	exit 0
}

# Set trap to catch SIGINT (Ctrl-C) and call cleanup
trap cleanup SIGINT

while true; do

    RATE=$(( RANDOM % 101 - 70 ))
    PITCH=$(( RANDOM % 101 - 100 ))
	RANGE=$(( RANDOM % 101 - 100 ))
	VOLUME=$(( RANDOM % 101))
    VOICE=${VOICES[$RANDOM % ${#VOICES[@]}]}

    IMAGE=$(/usr/bin/ls "$IMAGE_DIR"/*.gif | shuf -n 1)
	#feh -Zxg 400x400 -B white $IMAGE &
	gifview -a --title ___ --bg white +e $IMAGE &

    IMG_PID=$!

    source ~/git/micro_projects/diablo_names/d2name.sh | spd-say -e -r $RATE -p $PITCH -R $RANGE -i $VOLUME -t $VOICE -w
    sleep 0.2

	kill $IMG_PID
done

