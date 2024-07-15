#!/bin/bash

VOICES=("male1" "male2" "male3" "female1" "female2" "female3" "child_male" "child_female")

while true; do

    RATE=$(( RANDOM % 101 - 70 ))
    PITCH=$(( RANDOM % 101 - 100 ))
	RANGE=$(( RANDOM % 101 - 100 ))
	VOLUME=$(( RANDOM % 101))
    VOICE=${VOICES[$RANDOM % ${#VOICES[@]}]}

    source ~/git/micro_projects/diablo_names/d2name.sh | spd-say -e -r $RATE -p $PITCH -R $RANGE -i $VOLUME -t $VOICE
    sleep 2
done

