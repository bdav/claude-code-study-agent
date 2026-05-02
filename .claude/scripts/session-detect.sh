#!/bin/bash
# Session detection hook — runs at SessionStart
# Reads sr/meta.yaml and determines if this is a new or continuing session.
# Returns JSON context for Claude.

STUDY_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
META="$STUDY_DIR/sr/meta.yaml"

if [ ! -f "$META" ]; then
  echo '{"context": "No sr/meta.yaml found. SR system may not be initialized."}'
  exit 0
fi

TODAY=$(date +%Y-%m-%d)
CURRENT_SESSION=$(awk '/^current_session:/{print $2}' "$META")

# Check if today's date is already in the session log
if grep -qE "(^|[, \[])$TODAY([, \]]|$)" "$META" 2>/dev/null; then
  SESSION_TYPE="continuation"
else
  SESSION_TYPE="new"
fi

# Find latest day directory by extracting day numbers
LATEST_DAY="none"
NEXT_DAY_NUM=0
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
if [ "$MAX_DAY" -ge 0 ] 2>/dev/null; then
  NEXT_DAY_NUM=$((MAX_DAY + 1))
fi

# Check if review was already completed today
REVIEW_COMPLETED_DATE=$(awk '/^review_completed_date:/{print $2}' "$META")
REVIEW_DONE="false"
if [ "$REVIEW_COMPLETED_DATE" = "$TODAY" ]; then
  REVIEW_DONE="true"
fi

# Count due SR items
DUE_COUNT=0
if [ "$REVIEW_DONE" = "false" ]; then
  if [ "$SESSION_TYPE" = "new" ]; then
    NEXT_SESSION=$((CURRENT_SESSION + 1))
    DUE_COUNT=$(bash "$STUDY_DIR/sr/query.sh" due "$NEXT_SESSION" 2>/dev/null | wc -l | tr -d ' ')
  else
    DUE_COUNT=$(bash "$STUDY_DIR/sr/query.sh" due "$CURRENT_SESSION" 2>/dev/null | wc -l | tr -d ' ')
  fi
fi

# Check for handoff from previous conversation
HAS_HANDOFF="false"
if [ -f "$STUDY_DIR/handoff.md" ]; then
  HAS_HANDOFF="true"
fi

cat <<EOF
{"context": "Session detection: session_type=$SESSION_TYPE, current_session=$CURRENT_SESSION, latest_day=$LATEST_DAY, next_day_num=$NEXT_DAY_NUM, sr_items_due=$DUE_COUNT, review_done=$REVIEW_DONE, has_handoff=$HAS_HANDOFF, date=$TODAY. If this is a NEW session and the user wants to study, increment current_session in meta.yaml and run /review if items are due before starting new material. If this is a CONTINUATION or review_done=true, skip review. If has_handoff=true, read handoff.md for context from the previous conversation (what was covered, what to reinforce, what's next)."}
EOF
exit 0
