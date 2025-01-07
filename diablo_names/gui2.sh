#!/bin/bash

# Path to the GIF
gif_path="images/Black_Archer.gif"

# Message to display
message="Your message goes here"

# Display the GIF in the background
(display "$gif_path" &) 

# Wait for a moment to let the image display settle
sleep 1

# Use Zenity to display the message. Adjust --height and --width to position correctly
zenity --info --text="$message" --title="Display Text" --height=100 --width=300

