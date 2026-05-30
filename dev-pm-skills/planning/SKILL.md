---
name: planning
description: >
  Use this skill when the user wants to break down a feature, task, or project
  into implementable steps. Triggers on 'help me plan this', 'break this down',
  'how should I approach this', 'task breakdown', 'where do I start', 'create
  a plan for this feature', 'what order should I build this in', or 'spec this
  out'. Also triggers on 'create subtasks', 'estimate this work', 'what are the
  dependencies', or 'how do I implement this without breaking things'. Do NOT
  use for writing code — plan first, then implement. Do NOT use for debugging
  — use /skills/debugging instead.
version: "1.0"
updated: "2026-05-30"
---

# Planning Skill

## Safety — Read First

- NEVER start with implementation — always define done criteria first
- If requirements are ambiguous, list the ambiguities and ask before planning
- Flag any step that could affect production data or shared infrastructure

## The Planning Process

```
1. CLARIFY   — State assumptions, flag ambiguities
2. DECOMPOSE — Break into the smallest independently shippable tasks
3. ORDER     — Sequence by dependencies, highest risk first
4. VERIFY    — Define done criteria for each task
5. SCOPE     — Explicitly state what is NOT included
```

## Output Template

```
## Plan: {feature or task name}

### Assumptions
- {assumption 1}
- {assumption 2}

### Open questions (resolve before starting)
- {question if any — otherwise "None"}

### Tasks

| # | Task | Done when | Depends on |
|---|------|-----------|------------|
| 1 | {task} | {verifiable condition} | — |
| 2 | {task} | {verifiable condition} | #1 |
| 3 | {task} | {verifiable condition} | #2 |

### Out of scope
- {what will NOT be built in this plan}

### Risk
{HIGH / MEDIUM / LOW} — {biggest risk and mitigation}
```

## Worked Examples

### Example 1

INPUT:
Add user authentication to our Flask app. We need login, logout, and protected routes.

OUTPUT:
```
## Plan: User Authentication (Flask)

### Assumptions
- Using session-based auth (not JWT) — simpler for a server-rendered app
- Users table already exists with email + password_hash columns
- No OAuth/SSO required in this scope

### Open questions
- Should "remember me" extend the session? (affects cookie TTL)
- Password reset flow: in scope or out?

### Tasks

| # | Task | Done when | Depends on |
|---|------|-----------|------------|
| 1 | Add bcrypt password hashing to User model | `user.check_password("x")` works in tests | — |
| 2 | Build POST /login route | Returns 200 + sets session cookie on valid creds, 401 on invalid | #1 |
| 3 | Build POST /logout route | Clears session, redirects to /login | #2 |
| 4 | Add @login_required decorator | Unauthenticated requests to protected routes → redirect /login | #2 |
| 5 | Protect existing routes with decorator | All routes return 401 when not logged in | #4 |
| 6 | Write integration tests | Login, logout, protected route, invalid creds all tested | #3, #4 |

### Out of scope
- Password reset / forgot password
- OAuth (Google, GitHub)
- Rate limiting on login attempts
- "Remember me" cookie

### Risk
MEDIUM — Password hashing must be correct from Day 1. Bcrypt library handles
the hard part; risk is in the integration between User model and login route.
```

### Example 2

INPUT:
We need to migrate our SQLite database to PostgreSQL.

OUTPUT:
```
## Plan: SQLite → PostgreSQL Migration

### Assumptions
- App is Python/SQLAlchemy (ORM handles most dialect differences)
- We can tolerate a maintenance window for the cutover
- Prod data must be preserved — no data loss acceptable

### Open questions
- Is zero-downtime cutover required? (changes the complexity significantly)
- Do we have a staging environment to test the migration?

### Tasks

| # | Task | Done when | Depends on |
|---|------|-----------|------------|
| 1 | Set up PostgreSQL locally + in staging | Can connect with psycopg2, DB exists | — |
| 2 | Audit SQLite-specific code | List of all raw SQL queries and SQLite-isms identified | — |
| 3 | Fix dialect incompatibilities | All flagged queries updated to work with PostgreSQL | #2 |
| 4 | Run test suite against PostgreSQL | All tests pass with PG connection string | #1, #3 |
| 5 | Write data migration script | Script copies all SQLite data to PG, row counts match | #4 |
| 6 | Test migration on staging with prod-sized data | Migration completes, app works end-to-end on staging | #5 |
| 7 | Schedule prod cutover | Go/no-go checklist signed off, rollback plan documented | #6 |
| 8 | Execute prod cutover | App live on PG, SQLite file archived | #7 |

### Out of scope
- Zero-downtime migration (blue/green deployment)
- Read replicas or connection pooling (follow-up)

### Risk
HIGH — data migration is irreversible. Mitigate by testing on staging
with a full prod data copy before touching prod.
```

## Task Quality Rules (Secondary Reference)

A good task has:
- **A single verb** — implement, write, add, fix, remove (not "handle auth stuff")
- **A verifiable done condition** — a test that passes, a command that succeeds, a behavior that's observable
- **Clear dependencies** — what must exist before this task can start
- **Fits in one sitting** — if it takes more than a day, split it further
