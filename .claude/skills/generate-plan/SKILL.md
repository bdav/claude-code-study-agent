---
name: generate-plan
description: Generate a study plan through an interactive questionnaire — creates plan.md
disable-model-invocation: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - WebSearch
  - WebFetch
---

# Generate Study Plan

Guide the user through creating a personalized study plan. The result is a `plan.md` file at the project root.

## Pre-check

1. Check if `plan.md` already exists.
2. If it does, warn the user: "You already have a plan.md — generating a new one will overwrite it. Continue?"
3. If they decline, stop.

## Questionnaire

Ask these questions **one at a time**. Wait for the user's answer before moving to the next question. Adapt follow-ups based on their answers.

### 1. Topic
"What are you studying? (e.g., distributed systems, machine learning, AWS certification, a programming language, etc.)"

### 2. Goal
"What's the goal? (e.g., interview prep, certification exam, career transition, personal learning, course completion)"

### 3. Materials
"Do you have specific materials you want to work through? (e.g., a textbook, video course, documentation, tutorial series) Or would you like me to research and suggest resources?"

- If they have materials: ask for titles/links and use those as the backbone of the plan.
- If they want suggestions: use `WebSearch` to find highly-regarded resources for the topic. Propose 2-3 options and let the user pick.

### 4. Timeline
"How much total time do you have? (e.g., '2 weeks', 'a month', 'no deadline')"

### 5. Session length
"How long is a typical study session for you? (e.g., '1 hour', '2-3 hours', 'varies')"

### 6. Prior knowledge
"What do you already know about this topic? (e.g., 'complete beginner', 'I know the basics but not X', 'experienced with Y but new to Z')"

### 7. Practice problems
"Does your study involve practice problems or exercises? (e.g., coding problems, lab exercises, problem sets, writing prompts) If so, what kind?"

### 8. Review days
"Do you want periodic review/consolidation days built into the plan? (These are days with no new material — just revisiting what you've covered.)"

### 9. Deadlines
"Are there any hard deadlines or milestones? (e.g., exam date, interview date, project start)"

### 10. Day structure
"How do you prefer your study days structured? Options:
  - **Mixed**: multiple topics per day (e.g., reading + practice + exercises)
  - **Focused**: one topic per day, go deep
  - **No preference** — I'll decide based on the material"

## Plan Generation

After collecting answers, generate `plan.md` following this format:

```markdown
# <Study Topic> — Study Plan

> Goal: <user's stated goal>
> Timeline: <N days>
> Materials: <list of resources>

> Review is handled by the spaced repetition system in `sr/`. At the start of each session, the agent will surface due review items based on your actual recall performance.

---

## Day 1 — <Day Title>

- [ ] <Task 1>
- [ ] <Task 2>
- [ ] <Practice problem, if applicable>

---

## Day 2 — <Day Title>

...
```

### Plan generation rules

- Each day should be achievable in the user's stated session length
- Use `- [ ]` checkboxes for every task
- Group related topics on the same day (or adjacent days)
- If the user requested review days, insert them at regular intervals (e.g., every 5-7 days)
- If the user has a hard deadline, work backward from it
- Include specific chapter numbers, video titles, or problem names — not vague "study X"
- If you used web search to find resources, include links where available
- Add a brief title to each day that describes its theme

## After Generation

1. Show the user a summary of the plan (number of days, structure, pacing).
2. Ask if they want to adjust anything before finalizing.
3. Once confirmed, write `plan.md`.
4. Suggest they run `/newday 1` to start.
