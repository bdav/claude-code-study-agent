# Claude Code Study Agent

An AI-powered study system built on [Claude Code](https://docs.anthropic.com/en/docs/claude-code). It turns Claude into a tutor that guides you through a structured study plan with spaced repetition, session management, and active recall.

## What it does

- **Guided study sessions** — Claude acts as a tutor: asks before telling, pushes back on vague answers, encourages deep understanding
- **Spaced repetition** — concepts you study are added to a file-based SR system (SM-2 variant) and resurface for review based on your actual recall performance
- **Session continuity** — study sessions can span multiple conversations; a handoff system preserves context between them
- **Progress tracking** — your study plan is a markdown checklist that gets checked off as you go
- **Adaptive pacing** — Claude adjusts to your pace, suggests harder/easier problems, and proposes plan changes based on how you're doing

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI installed and configured
- A terminal or editor with Claude Code support (VS Code, JetBrains, etc.)

## Quick Start

1. **Clone this repo** (or copy the files) into a directory for your study project.

2. **Generate a study plan:**
   ```
   /generate-plan
   ```
   Claude will ask you ~10 questions about what you're studying, your timeline, materials, and preferences, then generate a `plan.md` tailored to you.

   Alternatively, create `plan.md` manually — see `plan.example.md` for the expected format.

3. **Start your first day:**
   ```
   /newday 1
   ```
   This creates a `days/day-1/` directory with a `notes.md` scaffolded from your plan.

4. **Study!** Work through the day's topics with Claude. It will:
   - Guide you through material with questions
   - Capture your thinking into notes as you go
   - Propose adding concepts to spaced review when you struggle

5. **Hand off between conversations:**
   ```
   /handoff
   ```
   When your context window gets long, this writes a summary so the next conversation picks up where you left off.

6. **Review** happens automatically. At the start of each new session, Claude checks for due SR items and quizzes you before new material.

## Project Structure

```
.claude/
  settings.local.json    # hooks, permissions, status line config
  scripts/
    session-detect.sh    # SessionStart hook — detects new vs continuing session
    statusline.sh        # status line — shows session, day, and SR stats
  skills/
    generate-plan/       # /generate-plan — interactive plan builder
    newday/              # /newday — bootstrap a study day
    review/              # /review — spaced repetition review block
    handoff/             # /handoff — write context for next conversation
CLAUDE.md                # agent instructions — the brain of the system
plan.md                  # your study plan (create via /generate-plan or manually)
plan.example.md          # example plan showing the expected format
sr/
  meta.yaml              # session counter and log
  query.sh               # helper script for querying due SR items
  items/                 # one markdown file per reviewable concept
days/
  day-N/
    notes.md             # notes for that day
    ...                  # solution files, exercises, etc.
```

## Slash Commands

| Command | Description |
|---|---|
| `/generate-plan` | Interactive questionnaire to build your `plan.md` |
| `/newday` or `/newday N` | Bootstrap a new study day directory and notes |
| `/review` | Run spaced repetition review for due items |
| `/handoff` | Write a handoff summary and close the conversation |

## How Spaced Repetition Works

The SR system uses a session-based SM-2 variant. Instead of tracking days between reviews, it tracks **sessions** — so irregular study schedules work fine.

- **Struggled concepts** (ease 1.8, interval 1) come back next session
- **Refresh concepts** (ease 2.5, interval 3) come back in 3 sessions
- Good recall grows the interval; poor recall resets it
- After 5 consecutive good reviews, Claude offers to retire the item

Items are stored as markdown files in `sr/items/` with YAML frontmatter. The agent manages all of this — you just answer the review prompts.

## How Session Management Works

Each time you open a new Claude Code conversation in this directory, the `SessionStart` hook runs and detects whether this is a new session or a continuation.

- **New session**: increments the session counter, triggers review if items are due
- **Continuation**: reads the handoff file (if present) and picks up where you left off

This means you can split a long study day across multiple conversations without losing context or re-running review.

## Customization

The system is designed to evolve with your study. Claude will propose changes to:

- **The plan** — reordering days, swapping problems, adding missing topics
- **The SR system** — tuning intervals, rephrasing stale prompts
- **The agent instructions** — adding coaching guidelines based on what works

All changes are proposed, never unilateral. You approve before anything is modified.

## Creating Your Plan Manually

If you prefer to write `plan.md` by hand instead of using `/generate-plan`, follow this format:

```markdown
# <Topic> — Study Plan

> Goal: <your goal>

---

## Day 1 — <Title>

- [ ] Task 1
- [ ] Task 2
- [ ] Practice problem (if applicable)

---

## Day 2 — <Title>

- [ ] ...
```

Key rules:
- Each day gets a `## Day N — Title` header
- Every task uses a `- [ ]` checkbox
- Be specific: chapter numbers, problem names, links
- See `plan.example.md` for a full example

## FAQ

**Can I pause studying and come back later?**
Yes. The spaced repetition system tracks sessions, not calendar days, so gaps don't break anything. Just start a new conversation and pick up where you left off.

**What if I fall behind my plan?**
The plan is flexible — Claude will help you adjust. You can ask it to reorder days, skip topics, or extend your timeline.

**Can I use this for non-technical subjects?**
Yes. The system works for any topic that can be structured as a day-by-day plan with concepts to review. Run `/generate-plan` and describe what you're studying.

**Do I need to finish a day in one conversation?**
No. Use `/handoff` when your context window gets long, then start a new conversation. The handoff file preserves your progress.

## License

MIT
