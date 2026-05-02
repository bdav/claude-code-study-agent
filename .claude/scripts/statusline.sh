#!/bin/bash
# Status line script — shows current session state
# Output format: plain text, single line

STUDY_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
META="$STUDY_DIR/sr/meta.yaml"

if [ ! -f "$META" ]; then
  echo "SR: not initialized"
  exit 0
fi

CURRENT_SESSION=$(awk '/^current_session:/{print $2}' "$META")

# Latest day directory
LATEST_DAY="none"
MAX_DAY=-1
for d in "$STUDY_DIR/days/day-"*/; do
  [ -d "$d" ] || continue
  base="$(basename "$d")"
  num="${base#day-}"
  if [ "$num" -gt "$MAX_DAY" ] 2>/dev/null; then
    MAX_DAY="$num"
    LATEST_DAY="$base"
  fi
done

# Due items
DUE_COUNT=$(bash "$STUDY_DIR/sr/query.sh" due "$CURRENT_SESSION" 2>/dev/null | wc -l | tr -d ' ')

# Total SR items
TOTAL=$(bash "$STUDY_DIR/sr/query.sh" count 2>/dev/null)

echo "Session $CURRENT_SESSION | $LATEST_DAY | SR: ${DUE_COUNT} due / ${TOTAL} total"
