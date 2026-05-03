---
name: review
description: Run spaced repetition review block — query due items, quiz the user, update SR data
disable-model-invocation: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
---

# Spaced Repetition Review

Run the SR review block for the current session.

## Steps

1. **Read `sr/meta.yaml`** to get `current_session`.

2. **Query due items**:
   ```
   ./sr/query.sh due <current_session>
   ```
   Output format: `next_review_session|ease_factor|category|topic|filename`

3. If no items are due, tell the user and stop.

4. **Redistribute overflow**: If more than 7 items are due, run:
   ```
   ./sr/query.sh redistribute <current_session>
   ```
   This spreads overflow items (positions 8+) across future sessions. Tell the user how many were due total and how many were redistributed. Then re-query to get the final 7.

5. Take **up to 7** items for review. Tell the user how many are being reviewed.

6. **For each item**, one at a time:
   a. Read ONLY the `## Prompt` section. **NEVER show or hint at Expected Points.**
   b. Present the prompt. Let the user answer freely.
   c. After the user answers, read `## Expected Points`.
   d. Evaluate against expected points. Rate on this scale:
      - **0** = no recall at all
      - **1** = wrong answer
      - **2** = mostly wrong, but a glimmer of the right idea
      - **3** = partial recall — hit some points, missed others
      - **4** = good recall with minor gaps
      - **5** = perfect, could teach it
   e. Share the rating and briefly discuss gaps. Keep it concise.
   f. Compute updated SR values using the SM-2 variant:
      ```
      if quality < 3:
          interval_sessions = 1
          ease_factor = max(1.3, ease_factor - 0.2)
      elif quality == 3:
          interval_sessions = interval_sessions  # unchanged
          ease_factor = max(1.3, ease_factor - 0.1)
      elif quality == 4:
          interval_sessions = ceil(interval_sessions * ease_factor)
      elif quality == 5:
          interval_sessions = ceil(interval_sessions * ease_factor * 1.1)
          ease_factor = ease_factor + 0.1

      next_review_session = current_session + interval_sessions
      ```
   g. Update the item file's frontmatter (`ease_factor`, `interval_sessions`, `next_review_session`, `times_reviewed`, `last_reviewed_session`, `last_quality`) and append to the `history` array.

7. **Retirement check**: If any item has 5 consecutive reviews with quality >= 4, ask the user if they want to retire it.

8. **Mark review complete**: Set `review_completed_date` in `sr/meta.yaml` to today's date (YYYY-MM-DD).

9. Tell the user review is done. Suggest they run `/handoff` before starting a fresh conversation for the study block.

## Rules
- **NEVER** show expected points — this defeats the purpose of recall
- **The agent rates quality** — do NOT ask the user to self-rate
- Keep discussion brief — if re-teaching is needed, that's for the study block
- Max 7 items per session
