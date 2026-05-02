# Example Study Plan — Distributed Systems

> This is an example to show the expected format. Delete this file and create your own `plan.md`, or use `/generate-plan` to build one interactively.

> Goal: Prepare for backend/infrastructure interviews with strong distributed systems fundamentals.
> Timeline: 15 days
> Materials: Designing Data-Intensive Applications (Kleppmann), MIT 6.824 lectures

> Review is handled by the spaced repetition system in `sr/`. At the start of each session, the agent will surface due review items based on your actual recall performance.

---

## Day 1 — Foundations

- [ ] DDIA Ch.1: Reliability, Scalability, Maintainability
- [ ] MIT 6.824 Lecture 1: Introduction
- [ ] Practice: Define SLAs for a hypothetical web service

---

## Day 2 — Data Models & Storage

- [ ] DDIA Ch.2: Data Models and Query Languages
- [ ] Compare SQL vs document vs graph models
- [ ] Practice: Model a social network in each paradigm

---

## Day 3 — Storage Engines

- [ ] DDIA Ch.3: Storage and Retrieval
- [ ] Focus: LSM trees vs B-trees — when to use each
- [ ] Practice: Sketch a KV store using an LSM tree

---

## Day 4 — Encoding & Evolution

- [ ] DDIA Ch.4: Encoding and Evolution
- [ ] Focus: Schema evolution strategies, backward/forward compatibility
- [ ] Practice: Design a schema migration plan for a REST API

---

## Day 5 — Review

- [ ] Review Days 1-4 from memory (no notes)
- [ ] Revisit weakest topic
- [ ] No new material

---

## Day 6 — Replication

- [ ] DDIA Ch.5: Replication
- [ ] MIT 6.824 Lecture 4: Primary/Backup Replication
- [ ] Focus: Leader-based vs leaderless, replication lag
- [ ] Practice: Draw replication topology for a chat app

---

...and so on.

---

# Format Rules

1. Each day has a `## Day N — Title` header
2. Tasks use `- [ ]` checkboxes
3. Be specific: chapter numbers, lecture names, problem descriptions
4. Include links where helpful
5. Review days have no new material — just recall and consolidation
