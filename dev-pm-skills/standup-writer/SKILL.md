---
name: standup-writer
description: >
  Use this skill when the user wants to write a standup update, daily status
  message, async standup, or weekly progress summary for their team. Triggers
  on 'write my standup', 'help me write a status update', 'what do I say in
  standup today', 'write a weekly update', 'summarize what I did', 'draft my
  async standup', or 'turn my git log into a standup'. Works from git log,
  task list, rough notes, or just a topic description. Do NOT use for writing
  a full project status report for stakeholders — use /skills/spec-writer
  instead. Do NOT use for retro notes — use /skills/retro instead.
version: "1.0"
updated: "2026-05-30"
---

# Standup Writer Skill

## Safety — Read First

- NEVER include credentials, tokens, internal URLs, or customer PII in the standup output
- NEVER fabricate progress — if context is thin, ask what was actually done before writing
- If the user is blocked, surface the blocker explicitly and concisely — don't soften it

## Output Template

```
**Yesterday**
- {what shipped, merged, or meaningfully progressed — be specific, not vague}
- {second item if applicable}

**Today**
- {specific next action — not "work on X" but "implement X" or "review PR for Y"}
- {second item if applicable}

**Blockers / flags**
- {blocker with who needs to unblock it — or "None"}
```

## Worked Examples

### Example 1 — From git log

INPUT:
```
git log --oneline --since="yesterday"
a3f92b1 fix: resolve N+1 query on /projects list endpoint
b81de04 test: add integration test for project member loading
c22fa3f refactor: extract auth middleware into shared module
```

OUTPUT:
```
**Yesterday**
- Fixed N+1 query on `/projects` list endpoint — member data now eagerly loaded, query count down from ~40 to 1
- Added integration test for project member loading
- Extracted auth middleware into a shared module — was copy-pasted across 6 routes

**Today**
- Benchmark the `/projects` endpoint before/after and commit results to docs/performance/
- Open PR for auth middleware extraction — needs review before merge

**Blockers / flags**
- None
```

### Example 2 — From rough notes

INPUT: "worked on the dark mode ticket, got the CSS vars wired up but the toggle isn't persisting yet. Today I need to finish persistence and run contrast checks. Waiting on design to confirm the color tokens."

OUTPUT:
```
**Yesterday**
- Dark mode: wired up CSS custom properties across all components, OS preference detection working
- Toggle renders but localStorage persistence not yet implemented

**Today**
- Implement toggle persistence (localStorage + `data-theme` on `<html>`)
- Run WCAG AA contrast audit on dark theme colors
- Unblock: waiting on design to confirm final dark mode color tokens before finishing

**Blockers / flags**
- Blocked on design sign-off for dark mode color tokens — pinging @design today
```

### Example 3 — Weekly summary

INPUT: "It's Friday. This week: shipped the auth refactor, reviewed 3 PRs, started the performance work but it's still in progress. Next week continuing perf work and starting the notification system."

OUTPUT:
```
**This week**
- Shipped auth middleware refactor — extracted duplicate logic from 6 routes, all integration tests passing
- Reviewed and merged 3 PRs (#211 dashboard fix, #214 billing edge case, #219 search pagination)
- Started API performance work — profiled all endpoints, fixed N+1 on `/projects` and `/users`; caching layer in progress

**Next week**
- Finish performance sprint: add Redis caching to top 3 slow endpoints, produce benchmark report
- Start notification system — scoping ticket this Monday

**Flags**
- Performance work slightly behind estimate — Redis provisioning needs infra approval before I can finish caching tasks
```

## Writing Rules (Secondary Reference)

**Specificity test:** Could another engineer on your team understand exactly what changed without asking a follow-up? If not, be more specific.

| Too vague | Specific |
|-----------|---------|
| "Worked on auth" | "Fixed session expiry bug — JWT TTL was 30min instead of 24h" |
| "Did some refactoring" | "Extracted auth middleware into shared module — was copy-pasted in 6 routes" |
| "Fixed bugs" | "Fixed N+1 query on /projects — query count down from 40 to 1" |
| "Working on dark mode" | "Dark mode CSS vars wired, toggle persistence in progress" |

**Blocker format:** `Blocked on {what} — {who needs to act} by {when if urgent}`

**Today items:** Use action verbs — "implement", "review", "merge", "deploy", "benchmark", "open PR" — not "work on" or "continue".

**Length:** Daily standup ≤ 5 bullet points total. Weekly summary ≤ 8. Anything longer belongs in a status doc.
