#!/bin/bash
# SR Query Helper
# Usage:
#   ./sr/query.sh due <session_number>     — list items due by session N
#   ./sr/query.sh count                    — count total active items
#   ./sr/query.sh weakest                  — items with ease_factor < 2.0
#   ./sr/query.sh all                      — list all active items (topic + next_review)

SR_DIR="$(cd "$(dirname "$0")" && pwd)"
ITEMS_DIR="$SR_DIR/items"

case "$1" in
  due)
    SESSION="${2:?Usage: query.sh due <session_number>}"
    for f in "$ITEMS_DIR"/*.md; do
      [ -f "$f" ] || continue
      retired=$(awk '/^retired:/{print $2}' "$f")
      [ "$retired" = "true" ] && continue
      next=$(awk '/^next_review_session:/{print $2}' "$f")
      if [ -n "$next" ] && [ "$next" != "null" ] && [ "$next" -le "$SESSION" ] 2>/dev/null; then
        topic=$(awk '/^topic:/{$1=""; print substr($0,2)}' "$f")
        category=$(awk '/^category:/{print $2}' "$f")
        ease=$(awk '/^ease_factor:/{print $2}' "$f")
        echo "$next|$ease|$category|$topic|$(basename "$f")"
      fi
    done | sort -t'|' -k1,1n -k2,2n
    ;;
  count)
    total=0
    for f in "$ITEMS_DIR"/*.md; do
      [ -f "$f" ] || continue
      retired=$(awk '/^retired:/{print $2}' "$f")
      [ "$retired" = "true" ] && continue
      total=$((total + 1))
    done
    echo "$total"
    ;;
  weakest)
    for f in "$ITEMS_DIR"/*.md; do
      [ -f "$f" ] || continue
      retired=$(awk '/^retired:/{print $2}' "$f")
      [ "$retired" = "true" ] && continue
      ease=$(awk '/^ease_factor:/{print $2}' "$f")
      # awk exits 0 (true for shell) when ease < 2.0, exits 1 otherwise
      if [ -n "$ease" ] && awk "BEGIN{exit !($ease < 2.0)}" 2>/dev/null; then
        topic=$(awk '/^topic:/{$1=""; print substr($0,2)}' "$f")
        echo "$ease|$topic|$(basename "$f")"
      fi
    done | sort -t'|' -k1,1n
    ;;
  all)
    for f in "$ITEMS_DIR"/*.md; do
      [ -f "$f" ] || continue
      retired=$(awk '/^retired:/{print $2}' "$f")
      [ "$retired" = "true" ] && continue
      topic=$(awk '/^topic:/{$1=""; print substr($0,2)}' "$f")
      next=$(awk '/^next_review_session:/{print $2}' "$f")
      ease=$(awk '/^ease_factor:/{print $2}' "$f")
      echo "$next|$ease|$topic|$(basename "$f")"
    done | sort -t'|' -k1,1n
    ;;
  redistribute)
    SESSION="${2:?Usage: query.sh redistribute <current_session>}"
    MAX_PER_SESSION="${3:-5}"

    # Collect overflow items (positions 8+) from the priority-sorted due list
    items=()
    while IFS='|' read -r next ease cat topic file; do
      items+=("$file")
    done < <("$0" due "$SESSION" | tail -n +8)

    total=${#items[@]}
    [ "$total" -eq 0 ] && echo "No overflow to redistribute." && exit 0

    # Spread evenly across future sessions, MAX_PER_SESSION per session
    slot=1
    count=0
    for file in "${items[@]}"; do
      target=$((SESSION + slot))
      sed -i '' "s/^next_review_session:.*/next_review_session: $target/" "$ITEMS_DIR/$file"
      count=$((count + 1))
      if [ "$count" -ge "$MAX_PER_SESSION" ]; then
        slot=$((slot + 1))
        count=0
      fi
    done
    echo "Redistributed $total items across sessions $((SESSION + 1))-$((SESSION + slot))"
    ;;
  *)
    echo "Usage: query.sh {due <session>|count|weakest|all|redistribute <session>}"
    exit 1
    ;;
esac
