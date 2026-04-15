#!/bin/bash

# Log assistant response content when a turn stops

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
# shellcheck source=/dev/null
source "$SCRIPT_DIR/common.sh"

# Skip if logging disabled
if [[ "${SKIP_LOGGING:-}" == "true" ]]; then
  exit 0
fi

INPUT=$(cat)

ensure_dirs

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
PAYLOAD_TS=$(extract_json_field "$INPUT" "timestamp")
SESSION_ID=$(infer_session_id "$INPUT")
ensure_session_meta "$SESSION_ID" "$PAYLOAD_TS"
SESSION_FILE=$(session_log_path "$SESSION_ID")

MESSAGE_ID=""
RESPONSE_CONTENT=""
PARSED_AGENT_JSON=""
TRANSCRIPT_PATH=""
LAST_USER_LINE=""
LAST_ASSISTANT_LINE=""

if [[ -n "$PARSED_AGENT_JSON" ]]; then
  MESSAGE_ID=$(extract_json_field "$PARSED_AGENT_JSON" "messageId")
  RESPONSE_CONTENT=$(extract_json_field "$PARSED_AGENT_JSON" "response")
else
  # Fallback parser when Python is unavailable.
  TRANSCRIPT_PATH_ESCAPED=$(extract_json_field "$INPUT" "transcript_path")
  TRANSCRIPT_PATH_ESCAPED=${TRANSCRIPT_PATH_ESCAPED//$'\r'/}

  TRANSCRIPT_PATH=$(normalize_transcript_path "$TRANSCRIPT_PATH_ESCAPED")

  if [[ -n "$TRANSCRIPT_PATH" && -f "$TRANSCRIPT_PATH" ]]; then
    LAST_USER_LINE=$(grep '"type":"user.message"' "$TRANSCRIPT_PATH" | tail -n 1 || true)
    LAST_ASSISTANT_LINE=$(grep '"type":"assistant.message"' "$TRANSCRIPT_PATH" | tail -n 1 || true)
  fi

  DIRECT_RESPONSE=$(extract_json_field "$INPUT" "response")

  if [[ -n "$LAST_ASSISTANT_LINE" ]]; then
    MESSAGE_ID=$(extract_json_field "$LAST_ASSISTANT_LINE" "messageId")
    RESPONSE_CONTENT=$(printf '%s' "$LAST_ASSISTANT_LINE" | sed -n 's/.*"content":"\(.*\)","toolRequests".*/\1/p' | head -n 1)
    if [[ -z "$RESPONSE_CONTENT" ]]; then
      RESPONSE_CONTENT=$(printf '%s' "$LAST_ASSISTANT_LINE" | sed -n 's/.*"content":"\(.*\)","reasoningText".*/\1/p' | head -n 1)
    fi
  fi

  if [[ -z "$RESPONSE_CONTENT" ]]; then
    RESPONSE_CONTENT="$DIRECT_RESPONSE"
  fi

  if [[ -z "$RESPONSE_CONTENT" ]]; then
    RESPONSE_CONTENT=$(printf '%s' "$INPUT" | tr -d '\r')
  fi
fi

# Recover missing user events when UserPromptSubmit hook is skipped.
if [[ -n "$LAST_USER_LINE" ]]; then
  USER_MESSAGE_ID=$(transcript_line_field "$LAST_USER_LINE" "id")
  USER_CONTENT=$(transcript_line_content "$LAST_USER_LINE")

  if [[ -n "$USER_MESSAGE_ID" ]]; then
    USER_EVENT_ID="user-${SESSION_ID}-${USER_MESSAGE_ID}"
  else
    USER_TS=$(transcript_line_field "$LAST_USER_LINE" "timestamp")
    USER_EVENT_ID="user-$(hash_text "${SESSION_ID}|${USER_TS}|${USER_CONTENT}")"
  fi

  if ! event_seen "user-events" "$USER_EVENT_ID"; then
    ESCAPED_SESSION_ID=$(json_escape "$SESSION_ID")
    ESCAPED_USER_EVENT_ID=$(json_escape "$USER_EVENT_ID")
    ESCAPED_USER_MSG_ID=$(json_escape "$USER_MESSAGE_ID")
    ESCAPED_USER_CONTENT=$(json_escape "$USER_CONTENT")
    ESCAPED_TRANSCRIPT_PATH=$(json_escape "$TRANSCRIPT_PATH")
    USER_EVENT_JSON="{\"timestamp\":\"$TIMESTAMP\",\"event\":\"userPromptSubmitted\",\"level\":\"${LOG_LEVEL:-INFO}\",\"sessionId\":\"$ESCAPED_SESSION_ID\",\"eventId\":\"$ESCAPED_USER_EVENT_ID\",\"transcriptMessageId\":\"$ESCAPED_USER_MSG_ID\",\"transcriptPath\":\"$ESCAPED_TRANSCRIPT_PATH\",\"promptText\":\"$ESCAPED_USER_CONTENT\",\"recovered\":true,\"recoverySource\":\"transcript\"}"
    append_event_dual "$USER_EVENT_JSON" "$SESSION_FILE"
    mark_event_seen "user-events" "$USER_EVENT_ID"
  fi
fi

# Deduplicate repeated Stop callbacks for the same assistant message.
STATE_FILE="logs/copilot/.last-agent-message-id"
if [[ -n "$MESSAGE_ID" && -f "$STATE_FILE" ]]; then
  LAST_MESSAGE_ID=$(cat "$STATE_FILE")
  if [[ "$LAST_MESSAGE_ID" == "$MESSAGE_ID" ]]; then
    exit 0
  fi
fi

if [[ -n "$MESSAGE_ID" ]]; then
  printf '%s' "$MESSAGE_ID" > "$STATE_FILE"
fi

EVENT_SOURCE_ID="$MESSAGE_ID"
if [[ -z "$EVENT_SOURCE_ID" ]]; then
  EVENT_SOURCE_ID=$(hash_text "${SESSION_ID}|${TIMESTAMP}|${RESPONSE_CONTENT}")
fi
EVENT_ID="agent-${SESSION_ID}-${EVENT_SOURCE_ID}"

if event_seen "agent-events" "$EVENT_ID"; then
  exit 0
fi
mark_event_seen "agent-events" "$EVENT_ID"

if [[ -n "$PARSED_AGENT_JSON" ]]; then
  append_event_dual "$PARSED_AGENT_JSON" "$SESSION_FILE"
else
  ESCAPED_RESPONSE=$(json_escape "$RESPONSE_CONTENT")
  ESCAPED_MESSAGE_ID=$(json_escape "$MESSAGE_ID")
  ESCAPED_SESSION_ID=$(json_escape "$SESSION_ID")
  ESCAPED_EVENT_ID=$(json_escape "$EVENT_ID")
  ESCAPED_TRANSCRIPT_PATH=$(json_escape "$TRANSCRIPT_PATH")
  EVENT_JSON="{\"timestamp\":\"$TIMESTAMP\",\"event\":\"agentResponse\",\"level\":\"${LOG_LEVEL:-INFO}\",\"sessionId\":\"$ESCAPED_SESSION_ID\",\"eventId\":\"$ESCAPED_EVENT_ID\",\"messageId\":\"$ESCAPED_MESSAGE_ID\",\"transcriptPath\":\"$ESCAPED_TRANSCRIPT_PATH\",\"response\":\"$ESCAPED_RESPONSE\"}"
  append_event_dual "$EVENT_JSON" "$SESSION_FILE"
fi

exit 0
