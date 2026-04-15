#!/bin/bash

# Log session end event

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

# Extract timestamp
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
PAYLOAD_TS=$(extract_json_field "$INPUT" "timestamp")
SESSION_ID=$(infer_session_id "$INPUT")
ensure_session_meta "$SESSION_ID" "$PAYLOAD_TS"
SESSION_FILE=$(session_log_path "$SESSION_ID")

# Log session end
ESCAPED_SESSION_ID=$(json_escape "$SESSION_ID")
SESSION_EVENT="{\"timestamp\":\"$TIMESTAMP\",\"event\":\"sessionEnd\",\"sessionId\":\"$ESCAPED_SESSION_ID\"}"
echo "$SESSION_EVENT" >> logs/copilot/session.log
echo "$SESSION_EVENT" >> "$SESSION_FILE"

echo "Session end logged"
exit 0
