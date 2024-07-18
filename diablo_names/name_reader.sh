#!/bin/bash

VOICES=("male2" "male3" "female1" "female3" "child_male" "child_female")
IMAGE_DIR="$HOME/git/micro_projects/diablo_names/images"

while true; do

    RATE=$(( RANDOM % 101 - 70 ))
    PITCH=$(( RANDOM % 101 - 100 ))
	RANGE=$(( RANDOM % 101 - 100 ))
	VOLUME=$(( RANDOM % 101))
    VOICE=${VOICES[$RANDOM % ${#VOICES[@]}]}

    IMAGE=$(/usr/bin/ls "$IMAGE_DIR"/*.gif | shuf -n 1)
	feh -Zxg 400x400 -B black $IMAGE >/dev/null 2>&1 &

    FEH_PID=$!

    source ~/git/micro_projects/diablo_names/d2name.sh | spd-say -e -r $RATE -p $PITCH -R $RANGE -i $VOLUME -t $VOICE -w
    #sleep 0.1

	kill feh >/dev/null 2>&1
done

