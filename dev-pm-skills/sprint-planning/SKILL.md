---
name: sprint-planning
description: >
  Use this skill when the user wants to plan a sprint, break a feature or
  milestone into tasks, create a sprint backlog, estimate work, or organize
  tickets by priority and dependency. Triggers on 'plan this sprint', 'break
  this feature into tasks', 'what should we build this sprint', 'help me
  prioritize the backlog', 'create sprint tasks', 'how long will this take',
  or 'scope this milestone'. Do NOT use for writing individual tickets in
  detail — use /skills/ticket-writer instead. Do NOT use for writing a PRD
  or product spec — use /skills/spec-writer instead.
version: "1.0"
updated: "2026-05-30"
---

# Sprint Planning Skill

## Safety — Read First

- NEVER invent estimates without flagging them as rough guesses — always note confidence level
- NEVER create tasks without asking what the definition of done is if it isn't clear
- If the user mentions a hard deadline, surface any scope risk explicitly before the task list

## Output Template

```
## Sprint: {Sprint Name or Goal}

**Duration:** {N weeks}  
**Goal:** {one sentence — what does a successful sprint look like?}

### Tasks

| # | Task | Size | Priority | Depends on | Owner |
|---|------|------|----------|------------|-------|
| 1 | {task} | {XS/S/M/L/XL} | {P0/P1/P2} | {# or —} | {name or —} |

### Scope Risks
- {risk 1 — what could blow up and why}

### Not in this sprint (parking lot)
- {deferred item}: {one-line reason}

### Definition of done
- {criterion 1}
- {criterion 2}
```

## Worked Examples

### Example 1

INPUT: "We're building a user authentication system in 2 weeks. Need login, signup, password reset, and session management."

OUTPUT:
```
## Sprint: Auth System — v1

**Duration:** 2 weeks  
**Goal:** Users can sign up, log in, reset passwords, and stay logged in across sessions.

### Tasks

| # | Task | Size | Priority | Depends on | Owner |
|---|------|------|----------|------------|-------|
| 1 | DB schema — users table + sessions | S | P0 | — | — |
| 2 | POST /auth/signup endpoint | M | P0 | 1 | — |
| 3 | POST /auth/login endpoint + JWT issue | M | P0 | 1 | — |
| 4 | Auth middleware (verify JWT on protected routes) | S | P0 | 3 | — |
| 5 | POST /auth/logout (invalidate session) | S | P0 | 3, 4 | — |
| 6 | POST /auth/forgot-password (send reset email) | M | P1 | 1 | — |
| 7 | POST /auth/reset-password (consume token) | S | P1 | 6 | — |
| 8 | Rate limiting on auth endpoints | S | P1 | 2, 3 | — |
| 9 | Integration tests — happy path + failure cases | M | P0 | 2, 3, 4, 5 | — |

### Scope Risks
- Email delivery (task 6) depends on email provider setup — if not configured, blocks password reset
- JWT secret rotation not included — flag if compliance requires it

### Not in this sprint (parking lot)
- OAuth / social login: scope too large, no user demand yet
- 2FA: P2, needs product decision on enforcement policy

### Definition of done
- All P0 tasks merged and deployed to staging
- Integration tests passing in CI
- Auth endpoints documented in API spec
```

### Example 2

INPUT: "Next sprint I want to improve our API performance. We've got N+1 query issues, no caching, and slow endpoints."

OUTPUT:
```
## Sprint: API Performance — Phase 1

**Duration:** 1 week  
**Goal:** Eliminate known N+1 queries and add caching to the 3 slowest endpoints.

### Tasks

| # | Task | Size | Priority | Depends on | Owner |
|---|------|------|----------|------------|-------|
| 1 | Profile all endpoints — identify top 5 slowest (add timing logs) | S | P0 | — | — |
| 2 | Fix N+1 on /users list (eager load roles + teams) | M | P0 | 1 | — |
| 3 | Fix N+1 on /projects list (eager load members) | M | P0 | 1 | — |
| 4 | Add Redis cache layer — cache TTL config | S | P1 | — | — |
| 5 | Cache /dashboard summary endpoint (TTL: 60s) | S | P1 | 4 | — |
| 6 | Cache /search results (TTL: 30s, key by query) | S | P1 | 4 | — |
| 7 | Benchmark before/after — document p50/p95 | S | P0 | 2, 3, 5, 6 | — |

### Scope Risks
- Redis setup (task 4) needs infra approval if not already provisioned
- Cache invalidation strategy not included — agreed to accept stale reads within TTL for now

### Not in this sprint (parking lot)
- Database index audit: needs a separate investigation sprint
- CDN for static assets: infra team owns this

### Definition of done
- N+1 queries eliminated on tasks 2, 3 (verified by query log)
- p95 latency on cached endpoints reduced by ≥ 40%
- Benchmark report committed to /docs/performance/
```

## Planning Rules (Secondary Reference)

**Sizing guide:**
| Size | Hours | Examples |
|------|-------|---------|
| XS | < 2h | Config change, copy update, 1-line fix |
| S | 2–4h | Simple endpoint, small component, bug fix |
| M | 4–8h | New feature with tests, moderate refactor |
| L | 1–2 days | Complex feature, DB migration + code change |
| XL | 2–5 days | Split this into multiple tasks |

**Priority guide:**
- P0: Sprint fails without it. Blocks other tasks or is the core deliverable.
- P1: Important but not a blocker. Ship if time allows.
- P2: Nice to have. Move to parking lot if time is tight.

**Always ask before planning:**
1. What's the sprint duration?
2. What's the single most important outcome?
3. Are there hard dependencies on other teams or infrastructure?
4. What was left over from last sprint?
