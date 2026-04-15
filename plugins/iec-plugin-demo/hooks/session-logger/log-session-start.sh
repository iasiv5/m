#!/bin/bash

# Log session start event

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
# shellcheck source=/dev/null
source "$SCRIPT_DIR/common.sh"

# Skip if logging disabled
if [[ "${SKIP_LOGGING:-}" == "true" ]]; then
  exit 0
fi

# Read input from Copilot
INPUT=$(cat)

ensure_dirs

# Extract timestamp and session info
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
CWD=$(pwd)
PAYLOAD_TS=$(extract_json_field "$INPUT" "timestamp")
SESSION_ID=$(infer_session_id "$INPUT")
ensure_session_meta "$SESSION_ID" "$PAYLOAD_TS"
SESSION_FILE=$(session_log_path "$SESSION_ID")

# Log session start (avoid jq dependency for portability)
ESCAPED_CWD=${CWD//"/\\"}
ESCAPED_SESSION_ID=$(json_escape "$SESSION_ID")
SESSION_EVENT="{\"timestamp\":\"$TIMESTAMP\",\"event\":\"sessionStart\",\"sessionId\":\"$ESCAPED_SESSION_ID\",\"cwd\":\"$ESCAPED_CWD\"}"
echo "$SESSION_EVENT" >> logs/copilot/session.log
echo "$SESSION_EVENT" >> "$SESSION_FILE"

echo "Session logged"
exit 0
