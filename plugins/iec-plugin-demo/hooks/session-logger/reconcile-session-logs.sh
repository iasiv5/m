#!/bin/bash

# Reconcile transcript events into session shard logs.

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
# shellcheck source=/dev/null
source "$SCRIPT_DIR/common.sh"

if [[ "${SKIP_LOGGING:-}" == "true" ]]; then
  exit 0
fi

INPUT=$(cat)
ensure_dirs
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

reconcile_transcript() {
  local transcript_path="$1"
  if [[ -z "$transcript_path" || ! -f "$transcript_path" ]]; then
    return
  fi

  local session_id
  session_id="$(basename "$transcript_path")"
  session_id="${session_id%.jsonl}"
  ensure_session_meta "$session_id" ""
  local session_file
  session_file=$(session_log_path "$session_id")

  while IFS= read -r line; do
    local typ
    typ=$(transcript_line_field "$line" "type")

    if [[ "$typ" == "user.message" ]]; then
      local msg_id content event_id escaped
      msg_id=$(transcript_line_field "$line" "id")
      content=$(transcript_line_content "$line")
      if [[ -n "$msg_id" ]]; then
        event_id="user-${session_id}-${msg_id}"
      else
        local ts
        ts=$(transcript_line_field "$line" "timestamp")
        event_id="user-$(hash_text "${session_id}|${ts}|${content}")"
      fi

      if ! event_seen "user-events" "$event_id"; then
        escaped=$(json_escape "$content")
        local escaped_session escaped_event escaped_msg escaped_path
        escaped_session=$(json_escape "$session_id")
        escaped_event=$(json_escape "$event_id")
        escaped_msg=$(json_escape "$msg_id")
        escaped_path=$(json_escape "$transcript_path")
        local event_json
        event_json="{\"timestamp\":\"$TIMESTAMP\",\"event\":\"userPromptSubmitted\",\"level\":\"INFO\",\"sessionId\":\"$escaped_session\",\"eventId\":\"$escaped_event\",\"transcriptMessageId\":\"$escaped_msg\",\"transcriptPath\":\"$escaped_path\",\"promptText\":\"$escaped\",\"recovered\":true,\"recoverySource\":\"reconcile\"}"
        append_event_dual "$event_json" "$session_file"
        mark_event_seen "user-events" "$event_id"
      fi
    fi

    if [[ "$typ" == "assistant.message" ]]; then
      local msg_id content event_id escaped
      msg_id=$(transcript_line_field "$line" "messageId")
      content=$(transcript_line_content "$line")
      if [[ -n "$msg_id" ]]; then
        event_id="agent-${session_id}-${msg_id}"
      else
        local ts
        ts=$(transcript_line_field "$line" "timestamp")
        event_id="agent-$(hash_text "${session_id}|${ts}|${content}")"
      fi

      if ! event_seen "agent-events" "$event_id"; then
        escaped=$(json_escape "$content")
        local escaped_session escaped_event escaped_msg escaped_path
        escaped_session=$(json_escape "$session_id")
        escaped_event=$(json_escape "$event_id")
        escaped_msg=$(json_escape "$msg_id")
        escaped_path=$(json_escape "$transcript_path")
        local event_json
        event_json="{\"timestamp\":\"$TIMESTAMP\",\"event\":\"agentResponse\",\"level\":\"INFO\",\"sessionId\":\"$escaped_session\",\"eventId\":\"$escaped_event\",\"messageId\":\"$escaped_msg\",\"transcriptPath\":\"$escaped_path\",\"response\":\"$escaped\",\"recovered\":true,\"recoverySource\":\"reconcile\"}"
        append_event_dual "$event_json" "$session_file"
        mark_event_seen "agent-events" "$event_id"
      fi
    fi
  done < "$transcript_path"
}

transcript_path_escaped=$(extract_json_field "$INPUT" "transcript_path")
transcript_path=$(normalize_transcript_path "$transcript_path_escaped")

if [[ -n "$transcript_path" ]]; then
  reconcile_transcript "$transcript_path"
  exit 0
fi

# Fallback: reconcile all known transcripts if transcript_path is not provided.
TRANSCRIPT_ROOT=$(printf '%s' "$INPUT" | sed -n 's/.*\"transcript_path\":\"\([^\"]*\\transcripts\\\)[^\"]*\".*/\1/p' | head -n 1)
TRANSCRIPT_ROOT=${TRANSCRIPT_ROOT//\\\\/\\}
if [[ -z "$TRANSCRIPT_ROOT" ]]; then
  exit 0
fi

if [[ "$TRANSCRIPT_ROOT" =~ ^([A-Za-z]):\\(.*)$ ]]; then
  drive=$(printf '%s' "${BASH_REMATCH[1]}" | tr '[:upper:]' '[:lower:]')
  rest=${BASH_REMATCH[2]//\\//}
  TRANSCRIPT_ROOT="/mnt/$drive/$rest"
fi

if [[ -d "$TRANSCRIPT_ROOT" ]]; then
  while IFS= read -r file; do
    reconcile_transcript "$file"
  done < <(find "$TRANSCRIPT_ROOT" -maxdepth 1 -type f -name '*.jsonl' 2>/dev/null)
fi

exit 0
