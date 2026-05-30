---
name: daily-checkin
description: >
  Use this skill when a developer wants to submit their daily standup check-in
  or status update to the shared team file. Triggers on 'check in', 'submit my
  standup', 'add my update', 'log what I did today', 'post my check-in', or
  'write my daily update'. Reads recent git log and open tasks automatically,
  then appends a structured entry to TEAM.md. Do NOT use for full sprint
  planning — use /skills/sprint-planning instead. Do NOT use for reading the
  team summary — use /skills/team-digest instead.
version: "1.0"
updated: "2026-05-30"
---

# Daily Check-in Skill

## Safety — Read First

- NEVER include credentials, tokens, API keys, or customer PII in the check-in
- NEVER fabricate work — only include what actually happened
- If a blocker involves a security issue, write "SECURITY BLOCKER — see DM" rather than details in TEAM.md

## Step 1: Gather context automatically

Read these sources before asking the user anything:

| Source | Path | What to extract |
|--------|------|-----------------|
| Git log | `git log --oneline --since="yesterday" --author=$(git config user.name)` | Commits made since yesterday |
| Sprint board | `SPRINT.md` (root or `docs/SPRINT.md`) | Tasks assigned to this user, their status |
| Team file | `TEAM.md` (root or `docs/TEAM.md`) | Last entry by this user to avoid duplication |

## Step 2: Ask one question

If git log and SPRINT.md give enough context, ask only:

> "Anything blocked or flagged that I should note?"

If context is thin (no commits, no sprint tasks), ask:

> "What did you work on yesterday, what's next, and is anything blocked?"

Keep it to one message. Do not ask multiple separate questions.

## Step 3: Write the entry and append to TEAM.md

Format the entry exactly as below, then append it to `TEAM.md`. Create the file if it doesn't exist.

```markdown
---

## {YYYY-MM-DD} — @{git username}

**Done**
- {specific thing completed — not "worked on X" but "shipped X" or "fixed Y in Z"}

**Today**
- {specific next action}

**Blocked**
- {blocker — who needs to act, or "None"}
```

After appending, confirm: "Check-in added to TEAM.md."

## Output Template (what gets appended)

```
---

## 2026-05-30 — @syed

**Done**
- Fixed N+1 query on /projects endpoint — eager load members, query count 40 → 1
- Merged PR #214 (billing edge case fix)

**Today**
- Benchmark /projects before/after and commit results to docs/performance/
- Review PR #219 (search pagination)

**Blocked**
- None
```

## Worked Example

INPUT: User runs `/daily-checkin` with no extra text.

CONTEXT GATHERED:
```
git log: 
  a3f92b1 fix: resolve N+1 query on /projects
  b81de04 test: add integration test for project members

SPRINT.md:
  [x] Fix N+1 on /projects list (#2)
  [ ] Benchmark endpoints and commit report (#7)
  [ ] Review PR #219 (#8 — assigned to @syed)
```

USER REPLY: "Blocked waiting on infra to provision Redis before I can finish caching tasks."

OUTPUT appended to TEAM.md:
```
---

## 2026-05-30 — @syed

**Done**
- Fixed N+1 query on /projects — eager load added, query count down from 40 to 1 (sprint task #2 ✓)
- Added integration test for project member loading

**Today**
- Benchmark /projects endpoint and commit results (sprint task #7)
- Review PR #219 — search pagination (sprint task #8)

**Blocked**
- Redis not provisioned — infra team needs to act before caching tasks (#5, #6) can proceed
```
