---
name: handoff
description: Write a handoff summary for the next conversation to pick up from
disable-model-invocation: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
---

# Handoff

Write a handoff file so the next conversation knows where to pick up.

## Steps

1. **Assess what was covered** in this conversation:
   - Check the current day's `notes.md` for what was written
   - Check `plan.md` for what items are still unchecked on the current day
   - Consider any SR items that were reviewed (if this was a review conversation)
   - Note any concepts the user struggled with or topics that came up organically

2. **Ask the user** to confirm what was completed. Propose marking items done in `plan.md` if appropriate.

3. **Propose SR items** for concepts covered in this conversation:
   - Review the current day's `notes.md` for concepts, tradeoffs, or decisions worth retaining.
   - For concepts the user struggled with: propose as `struggled` items (ease_factor: 1.8, interval: 1).
   - For concepts covered clearly but worth reinforcing: propose as `refresh` items (ease_factor: 2.5, interval: 3).
   - Before proposing, scan `sr/items/` for existing items from the same day/topic — previous conversations in this session may have already created items from the same notes file.
   - Follow all SR item creation rules in CLAUDE.md (confirm with user, etc.).
   - If this was a review-only conversation with no new study content, skip this step.

4. **Write `handoff.md`** at the study root with this format:

```markdown
# Handoff

## Session
- **Date**: <today>
- **Session**: <current_session from sr/meta.yaml>
- **Day**: <current study day>

## Completed this conversation
- <what was done — topics covered, problems solved, sections read>

## Still remaining today
- <unchecked items from plan.md for the current day>

## Reinforce
- <concepts the user struggled with, SR items that scored low, things to revisit>

## Next up
- <what the next conversation should start with>
```

5. **Create any SR items** the user approved in step 3.

6. **Update `plan.md`** — check off completed items (only after user confirms).

7. **Update `review_completed_date`** in `sr/meta.yaml` to today's date (YYYY-MM-DD) if this was the review conversation (i.e., SR items were reviewed this conversation).

## Rules
- ALWAYS confirm with the user before marking plan items complete
- Keep the handoff concise — it's a pointer for the next agent, not a transcript
- Overwrite any existing `handoff.md` — only the most recent handoff matters
- If nothing was accomplished (user just chatted), don't write a handoff — tell the user there's nothing to hand off
