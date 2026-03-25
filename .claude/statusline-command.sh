#!/bin/bash
input=$(cat)

user=$(whoami)
host=$(hostname -s)
cwd=$(echo "$input" | jq -r '.cwd // "?"')
model=$(echo "$input" | jq -r '.model.display_name // .model.id // "?"')
used=$(echo "$input" | jq -r '.context_window.used_percentage // 0')

# PS1-style: user@host:cwd (green for user@host, blue for cwd)
printf "\033[01;32m%s@%s\033[00m:\033[01;34m%s\033[00m" "$user" "$host" "$cwd"

# Append model name
printf " | %s" "$model"

# Append context usage bar
used_int=$(printf '%.0f' "$used" 2>/dev/null || echo 0)
filled=$(( used_int * 10 / 100 ))
empty=$(( 10 - filled ))
bar=""
for i in $(seq 1 $filled); do bar="${bar}█"; done
for i in $(seq 1 $empty); do bar="${bar}░"; done
printf " [%s] %s%%" "$bar" "$used_int"
