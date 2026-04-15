#!/bin/bash

# Log user prompt submission

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
# shellcheck source=/dev/null
source "$SCRIPT_DIR/common.sh"

# Skip if logging disabled
if [[ "${SKIP_LOGGING:-}" == "true" ]]; then
  exit 0
fi

# Read input from Copilot (contains prompt info)
INPUT=$(cat)

ensure_dirs

# Extract timestamp
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

PAYLOAD_TS=$(extract_json_field "$INPUT" "timestamp")
SESSION_ID=$(infer_session_id "$INPUT")
TRANSCRIPT_PATH_ESCAPED=$(extract_json_field "$INPUT" "transcript_path")
TRANSCRIPT_PATH=$(normalize_transcript_path "$TRANSCRIPT_PATH_ESCAPED")
PROMPT_TEXT=$(extract_json_field "$INPUT" "prompt")
USER_MESSAGE_ID=""

if [[ -n "$TRANSCRIPT_PATH" && -f "$TRANSCRIPT_PATH" ]]; then
  LAST_USER_LINE=$(grep '"type":"user.message"' "$TRANSCRIPT_PATH" | tail -n 1 || true)
  if [[ -n "$LAST_USER_LINE" ]]; then
    USER_MESSAGE_ID=$(transcript_line_field "$LAST_USER_LINE" "id")
  fi
fi

ensure_session_meta "$SESSION_ID" "$PAYLOAD_TS"
SESSION_FILE=$(session_log_path "$SESSION_ID")

EVENT_SEED="${SESSION_ID}|${PAYLOAD_TS}|${PROMPT_TEXT}"
if [[ -n "$USER_MESSAGE_ID" ]]; then
  EVENT_ID="user-${SESSION_ID}-${USER_MESSAGE_ID}"
else
  EVENT_ID="user-$(hash_text "$EVENT_SEED")"
fi
if event_seen "user-events" "$EVENT_ID"; then
  exit 0
fi
mark_event_seen "user-events" "$EVENT_ID"

# Log prompt content (flatten newlines and escape quotes)
PROMPT_ONE_LINE=$(printf '%s' "$INPUT" | tr '\r\n' '  ')
ESCAPED_PROMPT=$(json_escape "$PROMPT_ONE_LINE")
ESCAPED_SESSION_ID=$(json_escape "$SESSION_ID")
ESCAPED_TRANSCRIPT_PATH=$(json_escape "$TRANSCRIPT_PATH")
ESCAPED_PROMPT_TEXT=$(json_escape "$PROMPT_TEXT")
ESCAPED_EVENT_ID=$(json_escape "$EVENT_ID")
ESCAPED_USER_MESSAGE_ID=$(json_escape "$USER_MESSAGE_ID")

EVENT_JSON="{\"timestamp\":\"$TIMESTAMP\",\"event\":\"userPromptSubmitted\",\"level\":\"${LOG_LEVEL:-INFO}\",\"sessionId\":\"$ESCAPED_SESSION_ID\",\"eventId\":\"$ESCAPED_EVENT_ID\",\"transcriptMessageId\":\"$ESCAPED_USER_MESSAGE_ID\",\"transcriptPath\":\"$ESCAPED_TRANSCRIPT_PATH\",\"promptText\":\"$ESCAPED_PROMPT_TEXT\",\"prompt\":\"$ESCAPED_PROMPT\"}"

append_event_dual "$EVENT_JSON" "$SESSION_FILE"

exit 0
