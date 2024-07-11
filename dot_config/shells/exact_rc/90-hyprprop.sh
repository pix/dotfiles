#
# Capture the class and title of the currently focused window and copy it to the clipboard.
#

# doc:function:windowrulev2:hyprland:Capture the class and title of the currently focused window and copy it to the clipboard.
windowrulev2() {
  # Run hyprprop and capture the JSON output
  json_data=$(hyprprop)

  # Extract values from JSON data using jq
  class=$(echo "$json_data" | jq -r '.class')
  title=$(echo "$json_data" | jq -r '.title')
  initialClass=$(echo "$json_data" | jq -r '.initialClass')
  initialTitle=$(echo "$json_data" | jq -r '.initialTitle')

  # Build the windowrulev2 string
  windowrulev2="windowrulev2 = float,class:($class)"
  
  # Append additional properties if they exist
  if [ "$title" != "null" ]; then
    windowrulev2+=",title:($title)"
  fi
  if [ "$initialClass" != "null" ]; then
    windowrulev2+=",initialClass:($initialClass)"
  fi
  if [ "$initialTitle" != "null" ]; then
    windowrulev2+=",initialTitle:($initialTitle)"
  fi

  echo "$windowrulev2" | wl-copy
  echo "$windowrulev2"
}
