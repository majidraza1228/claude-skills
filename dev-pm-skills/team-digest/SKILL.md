---
name: team-digest
description: >
  Use this skill to generate the daily team digest, track sprint progress, and
  surface blockers from the shared TEAM.md check-in file. Triggers on 'run
  team digest', 'show team summary', 'what is the team working on', 'sprint
  status', 'who is blocked', 'daily summary', 'team standup summary', or
  'what did the team do today'. Reads TEAM.md and SPRINT.md automatically —
  no input required. Do NOT use for individual check-ins — use
  /skills/daily-checkin instead.
version: "1.0"
updated: "2026-05-30"
---

# Team Digest Skill

## Safety — Read First

- NEVER speculate about work not in TEAM.md — if someone hasn't checked in, flag it as missing, don't infer
- NEVER assign blame or single out individuals negatively — report facts, not judgements
- If a blocker involves a security issue, escalate it at the top of the output and flag it separately

## Step 1: Read both files

| Source | Path | What to extract |
|--------|------|-----------------|
| Team check-ins | `TEAM.md` (root or `docs/TEAM.md`) | All entries from today; yesterday's if today is sparse |
| Sprint board | `SPRINT.md` (root or `docs/SPRINT.md`) | All tasks, owners, statuses, and sprint goal |

If `TEAM.md` doesn't exist or has no entries for today, report: "No check-ins found for today — file is empty or missing."

## Step 2: Generate the digest

Produce the output in this exact structure:

```
## Team Digest — {date}

### Sprint Progress
**Goal:** {sprint goal from SPRINT.md}  
**Velocity:** {done} / {total} tasks complete ({%})

| Status | Count |
|--------|-------|
| ✅ Done | {n} |
| 🔄 In progress | {n} |
| ⏳ Not started | {n} |
| 🚨 Blocked | {n} |

### Who's Checked In
{list of @usernames who submitted today — flag anyone missing}

### What Got Done Today
- @{user}: {specific thing — pull from their "Done" section}
- @{user}: {specific thing}

### In Flight Today
- @{user}: {what they're working on}

### 🚨 Blockers (needs action)
| Blocker | Who's blocked | Who needs to act |
|---------|--------------|-----------------|
| {blocker description} | @{user} | @{owner or team} |

*No blockers* if none.

### ⚠️ At Risk
- {sprint task not progressed in 2+ days with no blocker explanation}
- {task whose owner hasn't checked in}

### Missing Check-ins
- @{username} — no entry today
```

## Worked Example

TEAM.md contents (today):
```
---

## 2026-05-30 — @syed

**Done**
- Fixed N+1 query on /projects — query count 40 → 1 (task #2 ✓)
- Merged PR #214

**Today**
- Benchmark /projects endpoint (task #7)
- Review PR #219 (task #8)

**Blocked**
- Redis not provisioned — infra needs to act before tasks #5 and #6 can proceed

---

## 2026-05-30 — @ali

**Done**
- Completed dark mode CSS vars and OS detection

**Today**
- Finish toggle persistence (localStorage)
- WCAG contrast audit

**Blocked**
- Waiting on design to confirm color tokens — @design team

---

## 2026-05-30 — @fatima

**Done**
- Reviewed PRs #211 and #213

**Today**
- Start notification system scoping (task #10)

**Blocked**
- None
```

SPRINT.md contents:
```
## Sprint 12 — API Performance + Dark Mode
Goal: Ship dark mode and eliminate N+1 queries on core endpoints

Tasks:
1. [x] Profile all endpoints — @syed
2. [x] Fix N+1 on /projects — @syed
3. [x] Fix N+1 on /users — @ali
4. [ ] Redis cache layer setup — @syed (NOT STARTED)
5. [ ] Cache /dashboard (depends on #4) — @syed (BLOCKED)
6. [ ] Cache /search (depends on #4) — @syed (BLOCKED)
7. [ ] Benchmark before/after — @syed (IN PROGRESS)
8. [ ] Review PR #219 — @syed (IN PROGRESS)
9. [ ] Dark mode CSS + OS detection — @ali (DONE)
10. [ ] Dark mode toggle + persistence — @ali (IN PROGRESS)
11. [ ] Notification system scoping — @fatima (IN PROGRESS)
```

OUTPUT:
```
## Team Digest — 2026-05-30

### Sprint Progress
**Goal:** Ship dark mode and eliminate N+1 queries on core endpoints  
**Velocity:** 4 / 11 tasks complete (36%)

| Status | Count |
|--------|-------|
| ✅ Done | 4 |
| 🔄 In progress | 4 |
| ⏳ Not started | 1 |
| 🚨 Blocked | 2 |

### Who's Checked In
✅ @syed · ✅ @ali · ✅ @fatima

### What Got Done Today
- @syed: Fixed N+1 on /projects (40 → 1 query), merged billing fix PR #214
- @ali: Dark mode CSS vars complete, OS preference detection working
- @fatima: Reviewed and approved PRs #211, #213

### In Flight Today
- @syed: Benchmarking /projects endpoint, reviewing PR #219
- @ali: Toggle persistence (localStorage) + WCAG contrast audit
- @fatima: Starting notification system scope (task #10)

### 🚨 Blockers (needs action)

| Blocker | Who's blocked | Who needs to act |
|---------|--------------|-----------------|
| Redis not provisioned — blocks tasks #5 and #6 | @syed | Infra team |
| Dark mode color tokens not confirmed | @ali | @design team |

### ⚠️ At Risk
- Task #4 (Redis cache layer setup) not started — depends on infra, no ETA yet. If Redis isn't provisioned by tomorrow, tasks #5 and #6 slip out of the sprint.

### Missing Check-ins
- None — full team checked in ✅
```

## Scheduling This Digest

To run automatically on a schedule, use the `schedule` skill:
```
/schedule "run /team-digest at 9:30am every weekday and post to #standup"
```

Or trigger it manually at any time with:
```
/team-digest
```
