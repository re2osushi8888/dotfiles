#!/usr/bin/env bash

input=$(cat)

model=$(echo "$input"        | jq -r '.model.display_name')
cwd=$(echo "$input"          | jq -r '.workspace.current_dir')
used_pct=$(echo "$input"     | jq -r '.context_window.used_percentage // 0')
total_input=$(echo "$input"  | jq -r '.context_window.total_input_tokens // 0')
total_output=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
transcript=$(echo "$input"   | jq -r '.transcript_path')

# Repo name and git branch
repo_name=$(basename "$cwd")
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" -c core.fileMode=false --no-optional-locks branch --show-current 2>/dev/null || echo "detached")
  [ -z "$branch" ] && branch="detached"
else
  branch="no-git"
fi

# Elapsed time from transcript file creation
if [ -f "$transcript" ]; then
  now=$(date +%s)
  start=$(stat -c %Y "$transcript" 2>/dev/null || stat -f %m "$transcript" 2>/dev/null || echo "$now")
  elapsed=$(( now - start ))
  hours=$(( elapsed / 3600 ))
  minutes=$(( (elapsed % 3600) / 60 ))
  seconds=$(( elapsed % 60 ))
  if [ "$hours" -gt 0 ]; then
    elapsed_str=$(printf "%dh%02dm%02ds" "$hours" "$minutes" "$seconds")
  elif [ "$minutes" -gt 0 ]; then
    elapsed_str=$(printf "%dm%02ds" "$minutes" "$seconds")
  else
    elapsed_str=$(printf "%ds" "$seconds")
  fi
else
  elapsed_str="0s"
fi

# Session cost (claude-sonnet-4: $3/M input, $15/M output)
input_cost=$(echo "scale=6; $total_input * 3 / 1000000"          | bc)
output_cost=$(echo "scale=6; $total_output * 15 / 1000000"        | bc)
total_cost=$(printf "%.4f" "$(echo "scale=6; $input_cost + $output_cost" | bc)")

# Colored context bar
bar_width=20
filled=$(printf "%.0f" "$(echo "scale=4; $used_pct * $bar_width / 100" | bc)")
[ "$filled" -lt 0 ]          && filled=0
[ "$filled" -gt "$bar_width" ] && filled=$bar_width
empty=$(( bar_width - filled ))

if   (( $(echo "$used_pct < 50" | bc -l) )); then color="\033[32m"  # green
elif (( $(echo "$used_pct < 80" | bc -l) )); then color="\033[33m"  # yellow
else                                               color="\033[31m"  # red
fi
reset="\033[0m"

bar="$color"
for (( i=0; i<filled; i++ )); do bar="${bar}█"; done
bar="${bar}${reset}"
for (( i=0; i<empty;  i++ )); do bar="${bar}░"; done

# Line 1: model | repo (branch)
printf "%s | %s (%s)\n" "$model" "$repo_name" "$branch"
# Line 2: context bar + %, cost, elapsed time
printf "Context: %b %.0f%% | Cost: \$%s | Time: %s\n" "$bar" "$used_pct" "$total_cost" "$elapsed_str"
