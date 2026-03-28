#!/bin/bash

# Read all stdin up front
input=$(cat)

# ---------------------------------------------------------------------------
# JSON field extraction — use jq when available, fall back to sed otherwise
# ---------------------------------------------------------------------------
json_get() {
  # $1 = dot-path like .cwd or .model.display_name
  # Returns the string value or empty string
  local path="$1"
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "$input" | jq -r "$path // empty" 2>/dev/null
  else
    # Build a sed pattern from the last key in the path
    local key
    key=$(printf '%s' "$path" | sed 's/.*\.//')
    printf '%s' "$input" \
      | grep -o "\"${key}\"[[:space:]]*:[[:space:]]*[^,}]*" \
      | head -1 \
      | sed 's/.*:[[:space:]]*//' \
      | sed 's/^"//' \
      | sed 's/"[[:space:]]*$//' \
      | sed 's/[[:space:]]*$//'
  fi
}

# ---------------------------------------------------------------------------
# Extract fields
# ---------------------------------------------------------------------------
cwd=$(json_get '.cwd')
[ -z "$cwd" ] && cwd="?"

# Try display_name first, fall back to id
model=$(json_get '.display_name')    # picks up model.display_name via key match
if [ -z "$model" ] || [ "$model" = "null" ]; then
  # Narrow to the model block then pull id
  if command -v jq >/dev/null 2>&1; then
    model=$(printf '%s' "$input" | jq -r '.model.display_name // .model.id // "?"' 2>/dev/null)
  else
    # Extract the substring from "model":{...} and then grab display_name or id
    model_block=$(printf '%s' "$input" | grep -o '"model"[[:space:]]*:[[:space:]]*{[^}]*}' | head -1)
    model=$(printf '%s' "$model_block" \
      | grep -o '"display_name"[[:space:]]*:[[:space:]]*"[^"]*"' \
      | sed 's/.*:[[:space:]]*"//' | sed 's/"$//')
    if [ -z "$model" ]; then
      model=$(printf '%s' "$model_block" \
        | grep -o '"id"[[:space:]]*:[[:space:]]*"[^"]*"' \
        | sed 's/.*:[[:space:]]*"//' | sed 's/"$//')
    fi
    [ -z "$model" ] && model="?"
  fi
fi

used=$(json_get '.used_percentage')   # picks up context_window.used_percentage via key match
if [ -z "$used" ] || [ "$used" = "null" ]; then
  if command -v jq >/dev/null 2>&1; then
    used=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty' 2>/dev/null)
  else
    ctx_block=$(printf '%s' "$input" | grep -o '"context_window"[[:space:]]*:[[:space:]]*{[^}]*}' | head -1)
    used=$(printf '%s' "$ctx_block" \
      | grep -o '"used_percentage"[[:space:]]*:[[:space:]]*[0-9.]*' \
      | sed 's/.*:[[:space:]]*//')
  fi
fi

if command -v jq >/dev/null 2>&1; then
  added=$(printf '%s' "$input" | jq -r '.cost.total_lines_added // 0' 2>/dev/null)
  removed=$(printf '%s' "$input" | jq -r '.cost.total_lines_removed // 0' 2>/dev/null)
else
  cost_block=$(printf '%s' "$input" | grep -o '"cost"[[:space:]]*:[[:space:]]*{[^}]*}' | head -1)
  added=$(printf '%s' "$cost_block" \
    | grep -o '"total_lines_added"[[:space:]]*:[[:space:]]*[0-9]*' \
    | sed 's/.*:[[:space:]]*//')
  removed=$(printf '%s' "$cost_block" \
    | grep -o '"total_lines_removed"[[:space:]]*:[[:space:]]*[0-9]*' \
    | sed 's/.*:[[:space:]]*//')
fi
[ -z "$added" ]   && added=0
[ -z "$removed" ] && removed=0

# Build progress bar for context usage
bar_width=10
if [ -n "$used" ] && [ "$used" != "null" ]; then
  used=$(printf '%.0f' "$used" 2>/dev/null || printf '%s' "$used")
  filled=$(( used * bar_width / 100 ))
  empty=$(( bar_width - filled ))
  bar=""
  for ((i=0; i<filled; i++)); do bar+="█"; done
  for ((i=0; i<empty; i++)); do bar+="░"; done
  context_str="${bar} ${used}%"
else
  context_str="░░░░░░░░░░ 0%"
fi

# ---------------------------------------------------------------------------
# Emit status line
# ---------------------------------------------------------------------------
printf "%s | +%s/-%s | %s %s\n" \
  "$cwd" "$added" "$removed" "$model" "$context_str"
