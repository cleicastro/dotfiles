#!/usr/bin/env bash

input=$(cat)

RESET=$'\033[0m'
CYAN=$'\033[36m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'

# Thresholds: green <50%, yellow 50-75%, red >=76%
color_for_pct() {
  local pct_int
  pct_int=$(awk -v p="$1" 'BEGIN { printf "%d", p }')
  if [ "$pct_int" -ge 76 ]; then
    echo "$RED"
  elif [ "$pct_int" -ge 50 ]; then
    echo "$YELLOW"
  else
    echo "$GREEN"
  fi
}

dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
project_dir=$(echo "$input" | jq -r '.workspace.project_dir // empty')
repo_dir="${project_dir:-$dir}"
folder=$(basename "$repo_dir")

branch=$(git -C "$repo_dir" --no-optional-locks branch --show-current 2>/dev/null)
if [ -n "$branch" ] && [ -n "$(git -C "$repo_dir" --no-optional-locks status --porcelain 2>/dev/null)" ]; then
  branch="$branch*"
fi

model=$(echo "$input" | jq -r '.model.display_name // empty')
effort=$(echo "$input" | jq -r '.effort.level // empty')
model_str="$model"
[ -n "$effort" ] && model_str="$model - $effort"

used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
input_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')

human_tokens() {
  LC_NUMERIC=C awk -v n="$1" 'BEGIN {
    if (n >= 1000000) printf "%.1fm", n / 1000000
    else if (n >= 1000) printf "%.1fk", n / 1000
    else printf "%d", n
  }'
}

bar_width=10
render_bar() {
  local pct="$1" filled empty bar i
  filled=$(awk -v u="$pct" -v w="$bar_width" 'BEGIN { f = int((u / 100) * w + 0.5); if (f > w) f = w; if (f < 0) f = 0; print f }')
  empty=$((bar_width - filled))
  bar=""
  # Plain counting loops, not printf '%.0s' + seq: that combo prints one
  # stray character even when the seq range is empty (0 filled/empty blocks),
  # which broke the bar at the 0% and >=95% edges.
  for ((i = 0; i < filled; i++)); do bar+="█"; done
  for ((i = 0; i < empty; i++)); do bar+="░"; done
  printf '%s' "$bar"
}

ctx_str=""
if [ -n "$used" ]; then
  bar=$(render_bar "$used")
  ctx_color=$(color_for_pct "$used")
  tokens_str=""
  if [ -n "$input_tokens" ]; then
    tokens_str=$(printf ' (%s tok)' "$(human_tokens "$input_tokens")")
  fi
  ctx_str=$(printf '%s[%s] %.0f%%%s%s' "$ctx_color" "$bar" "$used" "$tokens_str" "$RESET")
fi

# rate_limits exposes no dollar cost, only Claude.ai usage percentages for the
# 5-hour session window and the 7-day weekly window.
session_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
session_resets_at=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
session_str=""
if [ -n "$session_pct" ]; then
  session_color=$(color_for_pct "$session_pct")
  reset_str=""
  if [ -n "$session_resets_at" ]; then
    remaining_secs=$((session_resets_at - $(date +%s)))
    if [ "$remaining_secs" -gt 0 ]; then
      reset_str=$(printf ' (resets in %dh %dm)' "$((remaining_secs / 3600))" "$(((remaining_secs % 3600) / 60))")
    fi
  fi
  session_str=$(printf '%sSession %.0f%%%s%s' "$session_color" "$session_pct" "$reset_str" "$RESET")
fi

week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
week_str=""
if [ -n "$week_pct" ]; then
  week_color=$(color_for_pct "$week_pct")
  week_str=$(printf '%sWeek %.0f%%%s' "$week_color" "$week_pct" "$RESET")
fi

parts=()
parts+=("${CYAN}${folder}${RESET}")
[ -n "$branch" ] && parts+=("${GREEN}${branch}${RESET}")
[ -n "$model_str" ] && parts+=("${CYAN}${model_str}${RESET}")
[ -n "$ctx_str" ] && parts+=("$ctx_str")
[ -n "$session_str" ] && parts+=("$session_str")
[ -n "$week_str" ] && parts+=("$week_str")

output=""
for part in "${parts[@]}"; do
  if [ -z "$output" ]; then
    output="$part"
  else
    output="$output | $part"
  fi
done

printf '%s' "$output"