#!/bin/bash

# Function to display a GIF using eog
display_gif() {
    eog "images/Black_Archer.gif" &
}

# Creating a simple GUI with options
ans=$(zenity --list --title="Choose an Option" --column="0" "Display GIF" "Exit")

case $ans in
    "Display GIF")
        display_gif
        ;;
    "Exit")
        exit 0
        ;;
esac

