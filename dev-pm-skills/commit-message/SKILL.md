---
name: commit-message
description: >
  Use this skill when the user wants to write, format, or improve a git commit
  message. Triggers on 'write a commit message', 'format this commit',
  'conventional commit', 'commit message for this change', or when the user
  describes code changes and wants them summarized as a commit. Also triggers
  when reviewing commit message quality or converting verbose descriptions into
  concise commits. Do NOT use for generating changelogs — use
  /skills/changelog instead. Do NOT use for PR descriptions — use
  /skills/pr-description instead.
version: "1.0"
updated: "2026-05-30"
---

# Commit Message Skill

## Output Template

```
{type}: {Subject line in imperative mood, under 72 chars}

{Body: what changed and why, wrapped at 80 chars. 1-3 sentences.}

{Footer: Closes #N or Breaking Change notes, if applicable}
```

## Worked Examples

### Example 1

INPUT:
I added error handling to the payment processing module. It now catches timeout
errors from the payment gateway and retries up to 3 times with exponential
backoff before failing gracefully with a user-friendly error message instead of
a 500. This is related to bug report #234.

OUTPUT:
```
fix: Add retry logic for payment timeout errors

Add try/catch around payment gateway calls with exponential backoff.
Retry up to 3 times on timeout before returning a user-friendly error
instead of a 500.

Closes #234
```

### Example 2

INPUT:
Moved all the database query functions from the user controller into a separate
repository file. This gives us better separation of concerns and makes the
controller testable with mocks since it now depends on a repository interface
instead of raw SQL.

OUTPUT:
```
refactor: Extract database queries into user repository

Move all raw SQL calls from UserController into UserRepository.
Controller now depends on repository interface, making it testable
with mocks.
```

### Example 3

INPUT:
Updated the API response format. The old format returned { data: [...] } but
now it returns { items: [...], total: N, page: N }. This breaks existing
clients.

OUTPUT:
```
feat: Add pagination metadata to API responses

Change response envelope from { data } to { items, total, page }.
Clients must update to handle the new response shape.

BREAKING CHANGE: API response format changed — see migration guide.
```

## Type Reference

| Type | When to Use |
|------|------------|
| feat | New feature or capability |
| fix | Bug fix |
| refactor | Code change that neither fixes a bug nor adds a feature |
| docs | Documentation only |
| test | Adding or updating tests |
| chore | Build, CI, deps, config changes |
| perf | Performance improvement |
| style | Formatting, whitespace (no logic change) |
