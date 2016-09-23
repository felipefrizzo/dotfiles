echo ""
echo "Installing latest CLI Tools…"

cmd_line_tool_temp_file="/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"
touch "$cmd_line_tool_temp_file"

cmd_line_tools=$(softwareupdate -l | awk '/\*\ Command Line Tools/ { $1=$1;print }' | tail -1 | sed 's/^[[ \t]]*//;s/[[ \t]]*$//;s/*//' | cut -c 2-)
softwareupdate -i "$cmd_line_tools" --verbose

if [[ -f "$cmd_line_tool_temp_file" ]]; then
  rm  -rf "$cmd_line_tool_temp_file"
fi
