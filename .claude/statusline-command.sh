#!/bin/bash
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "Unknown Model"')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "?"')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Build progress bar
if [ -n "$used" ]; then
  used_int=$(printf '%.0f' "$used")
  filled=$(( used_int * 10 / 100 ))
  empty=$(( 10 - filled ))
  bar=""
  for i in $(seq 1 $filled); do bar="${bar}█"; done
  for i in $(seq 1 $empty); do bar="${bar}░"; done
  ctx_part=" [${bar}] ${used_int}%"
else
  ctx_part=""
fi

printf "%s - %s - %s" "$model" "$cwd" "$ctx_part"
