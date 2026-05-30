---
name: debugging
description: >
  Use this skill when the user has a bug, error, or unexpected behavior and
  needs help diagnosing it. Triggers on 'debug this', 'why is this failing',
  'error I can't figure out', 'this isn't working', 'help me fix this bug',
  stack traces, exception messages, or 'it works locally but not in production'.
  Also triggers on 'reproduce this bug', 'find the root cause', or 'why does
  this return the wrong value'. Do NOT use for general code review — use
  /skills/code-review instead.
version: "1.0"
updated: "2026-05-30"
---

# Debugging Skill

## Safety — Read First

- NEVER suggest deleting logs, disabling error handling, or silencing exceptions as a fix
- NEVER recommend catching broad exceptions (bare `except`, `catch (Exception e)`) without re-raising or logging
- If the bug involves data corruption or security, flag immediately before proceeding

## The 5-Step Triage Process

Follow these steps in order. Do not skip to a fix before completing Steps 1–3.

```
1. REPRODUCE  — Confirm the bug is real and reproducible
2. LOCALIZE   — Narrow down where in the code it happens
3. REDUCE     — Find the smallest input that triggers it
4. FIX        — Change the minimum code required
5. GUARD      — Add a test so it can't silently return
```

## Output Template

```
## Bug Report

### What's happening
{one sentence describing observed behavior}

### What should happen
{one sentence describing expected behavior}

### Root cause
{file:line} — {explanation of why this fails}

### Fix
{specific code change}

### Guard (test to prevent regression)
{test snippet or description of what to assert}

### Confidence
{HIGH / MEDIUM / LOW} — {reason, e.g. "can't reproduce in prod env"}
```

## Worked Examples

### Example 1

INPUT:
```python
def get_user(user_id):
    users = load_users()
    return users[user_id]

# Error: KeyError: 'abc123'
```

OUTPUT:
```
## Bug Report

### What's happening
get_user() raises KeyError when user_id doesn't exist in the users dict.

### What should happen
Should return None (or raise a descriptive error) when user not found.

### Root cause
get_user():3 — dict access with [] raises KeyError on missing key instead of returning None.

### Fix
return users.get(user_id)
# Or if None is not acceptable:
# if user_id not in users:
#     raise ValueError(f"User '{user_id}' not found")
# return users[user_id]

### Guard
def test_get_user_returns_none_for_missing_id():
    assert get_user("nonexistent") is None

### Confidence
HIGH — root cause is clear from the traceback.
```

### Example 2

INPUT:
"My API returns 200 but the response body is empty. Works fine locally."

OUTPUT:
```
## Bug Report

### What's happening
API returns HTTP 200 with an empty body in production; works locally.

### Root cause
UNKNOWN yet — need to localize. Likely candidates:
1. Environment variable missing in prod (DB_URL, API_KEY) → query returns nothing
2. Different DB seeding between local and prod
3. Serialization error silently swallowed in a try/except

### Triage steps
1. Add logging before the return: log the raw query result
2. Check prod env vars match local: `printenv | grep DB`
3. Search for bare except/catch blocks near the return path
4. Test with a known-good record ID in prod

### Confidence
LOW — can't determine root cause without logs. Run triage steps first.
```

## Debugging Patterns (Secondary Reference)

| Pattern | When to use |
|---------|------------|
| Binary search | Add a print/log in the middle of the call stack; narrow up or down |
| Minimal reproduction | Remove code until the bug disappears; last removal = root cause |
| Rubber duck | Explain the code line by line out loud (or in comments) |
| Time-travel | Check git log for when it last worked; diff against that commit |
| Environment diff | Compare env vars, deps, OS between working and broken environments |
| Assumption check | List every assumption the code makes; test each one explicitly |
