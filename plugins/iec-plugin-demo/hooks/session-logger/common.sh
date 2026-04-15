#!/bin/bash

set -euo pipefail

json_escape() {
  printf '%s' "$1" \
    | sed -e 's/\\/\\\\/g' \
          -e 's/"/\\"/g' \
          -e 's/\t/\\t/g' \
          -e 's/\r/\\r/g' \
          -e ':a;N;$!ba;s/\n/\\n/g'
}

extract_json_field() {
  local json="$1"
  local key="$2"
  printf '%s' "$json" \
    | tr -d '\r' \
    | sed -n "s/.*\"$key\":\"\([^\"]*\)\".*/\1/p" \
    | head -n 1
}

normalize_transcript_path() {
  local raw_path="$1"
  local path_candidate="$raw_path"
  local resolved=""

  for _ in 1 2 3 4; do
    path_candidate=${path_candidate//\\\\/\\}
    if [[ -f "$path_candidate" ]]; then
      resolved="$path_candidate"
      break
    fi
  done

  if [[ -z "$resolved" && -f "$raw_path" ]]; then
    resolved="$raw_path"
  fi

  if [[ -z "$resolved" ]]; then
    local win_path
    win_path=${raw_path//\\\\/\\}
    if [[ "$win_path" =~ ^([A-Za-z]):\\(.*)$ ]]; then
      local drive_letter
      drive_letter=$(printf '%s' "${BASH_REMATCH[1]}" | tr '[:upper:]' '[:lower:]')
      local rest_path=${BASH_REMATCH[2]//\\//}
      local wsl_path="/mnt/$drive_letter/$rest_path"
      if [[ -f "$wsl_path" ]]; then
        resolved="$wsl_path"
      fi
    fi
  fi

  printf '%s' "$resolved"
}

hash_text() {
  local input="$1"
  if command -v sha1sum >/dev/null 2>&1; then
    printf '%s' "$input" | sha1sum | awk '{print $1}'
    return
  fi
  if command -v shasum >/dev/null 2>&1; then
    printf '%s' "$input" | shasum | awk '{print $1}'
    return
  fi
  if command -v md5sum >/dev/null 2>&1; then
    printf '%s' "$input" | md5sum | awk '{print $1}'
    return
  fi
  printf '%s' "$input" | wc -c | awk '{print "len"$1}'
}

ensure_dirs() {
  mkdir -p logs/copilot
  mkdir -p logs/copilot/sessions
  mkdir -p logs/copilot/.sessions
  mkdir -p logs/copilot/.state
}

infer_session_id() {
  local input_json="$1"
  local session_id
  session_id=$(extract_json_field "$input_json" "session_id")
  if [[ -n "$session_id" ]]; then
    printf '%s' "$session_id"
    return
  fi

  local transcript_path_escaped
  transcript_path_escaped=$(extract_json_field "$input_json" "transcript_path")
  local transcript_path
  transcript_path=$(normalize_transcript_path "$transcript_path_escaped")
  if [[ -n "$transcript_path" ]]; then
    local filename
    filename=$(basename "$transcript_path")
    printf '%s' "${filename%.jsonl}"
    return
  fi

  printf '%s' "unknown-session"
}

ensure_session_meta() {
  local session_id="$1"
  local fallback_ts="$2"
  local meta_file="logs/copilot/.sessions/${session_id}.meta"

  if [[ -f "$meta_file" ]]; then
    return
  fi

  local start_utc
  start_utc="$fallback_ts"
  if [[ -z "$start_utc" ]]; then
    start_utc=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  fi

  local start_label
  start_label=$(date +"%Y-%m-%d_%H%M%S")
  local start_day
  start_day=$(date +"%Y-%m-%d")

  {
    echo "session_id=$session_id"
    echo "start_utc=$start_utc"
    echo "start_label=$start_label"
    echo "start_day=$start_day"
  } > "$meta_file"
}

session_log_path() {
  local session_id="$1"
  local meta_file="logs/copilot/.sessions/${session_id}.meta"
  if [[ ! -f "$meta_file" ]]; then
    ensure_session_meta "$session_id" ""
  fi

  local start_label
  local start_day
  start_label=$(sed -n 's/^start_label=//p' "$meta_file" | head -n 1)
  start_day=$(sed -n 's/^start_day=//p' "$meta_file" | head -n 1)
  if [[ -z "$start_label" || -z "$start_day" ]]; then
    start_label=$(date +"%Y-%m-%d_%H%M%S")
    start_day=$(date +"%Y-%m-%d")
  fi

  local dir="logs/copilot/sessions/$start_day"
  mkdir -p "$dir"
  printf '%s' "$dir/${start_label}-${session_id}-prompts.log"
}

event_seen() {
  local scope="$1"
  local event_id="$2"
  local state_file="logs/copilot/.state/${scope}.seen"
  [[ -f "$state_file" ]] && grep -Fxq "$event_id" "$state_file"
}

mark_event_seen() {
  local scope="$1"
  local event_id="$2"
  local state_file="logs/copilot/.state/${scope}.seen"
  echo "$event_id" >> "$state_file"
}

transcript_line_field() {
  local line="$1"
  local key="$2"
  printf '%s' "$line" \
    | sed -n "s/.*\"$key\":\"\([^\"]*\)\".*/\1/p" \
    | head -n 1
}

transcript_line_content() {
  local line="$1"
  local content
  content=$(printf '%s' "$line" | sed -n 's/.*"content":"\(.*\)","attachments".*/\1/p' | head -n 1)
  if [[ -z "$content" ]]; then
    content=$(printf '%s' "$line" | sed -n 's/.*"content":"\(.*\)","toolRequests".*/\1/p' | head -n 1)
  fi
  if [[ -z "$content" ]]; then
    content=$(printf '%s' "$line" | sed -n 's/.*"content":"\(.*\)","reasoningText".*/\1/p' | head -n 1)
  fi
  printf '%s' "$content"
}

append_event_dual() {
  local event_json="$1"
  local session_file="$2"
  echo "$event_json" >> "$session_file"
}