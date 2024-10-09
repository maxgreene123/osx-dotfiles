#!/bin/bash

# Get the currently focused space
active_space=$(yabai -m query --spaces --space | jq '.index')

# Reset all spaces to default background color (fully transparent)
for i in {1..10}; do
  sketchybar --set space.$i background.color=0x00000000 # fully transparent for inactive spaces
done

# Set the active space background to a translucent dark gray color
sketchybar --set space.$active_space background.color=0x66000000 # translucent dark gray
