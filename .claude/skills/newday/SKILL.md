---
name: newday
description: Bootstrap a new study day — creates directory, notes from template, and empty files
disable-model-invocation: true
allowed-tools:
  - Read
  - Write
  - Bash
  - Edit
  - Glob
---

# Bootstrap New Day

The user is starting a new study day. The day number is: **$ARGUMENTS**

If no day number was provided, determine the next day by checking which `days/day-N/` directories already exist and using the next number.

## Steps

1. **Read `plan.md`** to find the section for this day. Identify:
   - Day title/theme
   - Topics and tasks listed
   - Practice problems listed (if any)

2. **Create the directory**: `days/day-$N/`

3. **Create `notes.md`** by composing sections based on the tasks in the plan for this day.

   At the TOP of `notes.md`, include:
   - `# Day N — <day title from plan>`
   - A **Plan Checklist** copied from the plan — all tasks for that day as `- [ ]` items.

   Then, for each task in the plan, add an appropriate section header. Read the task description and create a section that fits:

   - **Reading/theory tasks** (textbook chapters, videos, documentation):
     ```
     ## <Topic/Chapter Name>
     ### Key Ideas
     ### Takeaways
     ### Connections to Other Topics
     ```

   - **Practice problems** (always last, one sub-section per problem):
     ```
     ## Practice
     ### <Problem Name>
     - Pattern:
     - Complexity:
     - Key insight:
     ```

   - **Review/consolidation tasks**:
     ```
     ## Review: <Topic>
     ```

   - **Projects, labs, or exercises**:
     ```
     ## <Exercise/Lab Name>
     ```

   - **Any other task**: create a simple `## <Task Name>` header.

   Only include sections relevant to what's on the plan for that day.

4. **Create empty solution/exercise files** if the plan lists specific practice problems:
   - Use `<kebab-case-problem-name>.<ext>` (use the appropriate extension for the user's language)

5. **Report** what was created and what the day covers. Then ask the user what they want to start with.
